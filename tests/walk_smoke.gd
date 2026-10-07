extends SceneTree

var failures := 0

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func _initialize() -> void:
	call_deferred("run_checks")

func run_checks() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.start_level(2)
	var initial_position: Vector2 = game.yumi_position
	game.update_yumi_walk(0.1, 8.0)
	check(game.yumi_art_texture() == game.YUMI_WALK_ART, "Travel starts walk animation")
	check(game.yumi_position == initial_position, "Visual update cannot move the cat")
	check(is_equal_approx(game.yumi_walk_phase, 0.6), "Phase follows travelled distance")
	var image: Image = game.YUMI_WALK_ART.get_image()
	if image.is_compressed():
		image.decompress()
	for frame in range(6):
		game.yumi_walk_phase = frame
		var region: Rect2 = game.yumi_walk_region()
		check(game.yumi_walk_frame() == frame, "All six frames are reachable")
		var anchor: Vector2 = game.YUMI_WALK_ANCHORS[frame] * (144.0 / 512.0)
		check(is_equal_approx(game.yumi_art_rect().position.y + anchor.y, 57.0), "Each walking foot line stays on the same floor")
		check(Rect2(Vector2.ZERO, image.get_size()).encloses(region), "Frame region stays inside sheet")
		var visible := 0
		var transparent := 0
		for y in range(int(region.position.y), int(region.end.y), 16):
			for x in range(int(region.position.x), int(region.end.x), 16):
				var alpha := image.get_pixel(x, y).a
				if alpha > 0.9:
					visible += 1
				if alpha < 0.01:
					transparent += 1
		check(visible > 80 and transparent > 80, "Each frame contains an isolated transparent cat")
	game.yumi_walk_phase = 5.8
	game.update_yumi_walk(0.1, 8.0)
	check(is_equal_approx(game.yumi_walk_phase, 0.4), "Walk wraps into first frame")
	game.update_yumi_walk(0.1, 0.0)
	check(not game.yumi_walk_moving and game.yumi_art_texture() == game.YUMI_IDLE_ART, "No movement returns to idle")
	game.update_yumi_walk(0.1, 8.0)
	game.yumi_warning_timer = 0.4
	check(game.yumi_art_texture() == game.YUMI_PAW_ART, "Warning interrupts walking")
	game.yumi_warning_timer = 0
	game.yumi_swipe_flash = 0.1
	check(game.yumi_art_texture() == game.YUMI_PAW_ART, "Swipe interrupts walking")
	game.start_level(0)
	game.update_yumi_walk(0.1, 8.0)
	check(not game.yumi_walk_moving and game.yumi_art_texture() == game.YUMI_SLEEP_ART, "Sleeping cat cannot walk")
	game.start_level(2)
	game._process(0.05)
	check(game.yumi_walk_moving and game.yumi_position != initial_position, "Actual process movement drives animation")
	game.start_level(2)
	game.game_state = "failed"
	game.update_yumi_walk(0.1, 8.0)
	check(not game.yumi_walk_moving, "Loss stops walking")
	game.start_level(2)
	game.update_yumi_walk(0.1, 100.0)
	check(is_equal_approx(game.yumi_walk_phase, 1.35), "Dash frame speed is bounded")
	# Same distance at different simulation rates produces the same phase.
	var phases: Array[float] = []
	for rate in [30, 60, 144]:
		game.start_level(2)
		for step in range(rate):
			game.update_yumi_walk(1.0 / rate, 72.0 / rate)
		phases.append(game.yumi_walk_phase)
	check(absf(phases[0] - phases[1]) < 0.001 and absf(phases[1] - phases[2]) < 0.001, "Walk phase is frame-rate independent")
	game.start_level(2)
	check(game.yumi_walk_phase == 0 and not game.yumi_walk_moving, "Restart clears walk phase")
	game.free()
	print("Walk smoke tests: %d failures" % failures)
	quit(1 if failures else 0)
