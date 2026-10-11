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
	for fps in [30, 60, 144]:
		for seed_value in range(20):
			game.start_level(3)
			game.rng.seed = seed_value
			game.progress = 2
			game.begin_scatter()
			game.shot_delay = 0.0
			game.launch_ball()
			check(not game.ball_active, "Cannot fire during approach")
			var warning_seen := false
			var scatter_seen := false
			for step in range(fps * 10):
				warning_seen = warning_seen or game.scatter_state == "warning"
				scatter_seen = scatter_seen or game.scatter_state == "scatter"
				game._process(1.0 / fps)
				if game.scatter_state == "":
					break
			check(warning_seen and scatter_seen and game.scatter_state == "", "Warning, bounce and return complete")
			check(game.scatter_wall_hits > 0, "Targets bounce off bounds")
			check(game.scatter_targets_accessible(), "Every resting target has a clear shot")
			var positions: Array = game.hole_positions.duplicate()
			for index in range(3):
				var p: Vector2 = game.hole_positions[index]
				check(p == game.clamp_scatter_position(p), "Target stays inside safe area")
				for other in range(index + 1, 3):
					check(p.distance_to(game.hole_positions[other]) >= game.TARGET_SPACING - 0.1, "Targets rest separately")
			game.update_holes()
			check(positions == game.hole_positions, "Targets retain resting positions")
			# Geometry alone is not enough: fire a real swept ball into all three
			# resting targets, isolating only Yumi's independent sabotage.
			for target_index in range(3):
				game.progress = 0
				game.sequence[0] = target_index
				game.errors = 0
				game.shot_delay = 0.0
				var target: Vector2 = game.hole_positions[target_index]
				game.update_mouse_aim(target)
				var direct_angle := atan2(target.x - game.LAUNCH_POS.x, game.LAUNCH_POS.y - target.y)
				check(is_equal_approx(game.aim_angle, direct_angle), "Resting target within legal aim: FPS %d seed %d target %d" % [fps, seed_value, target_index])
				game.launch_ball()
				game.ball_swatted = true
				game.advance_ball_segment(2.0)
				check(game.progress == 1 and game.errors == 0 and not game.ball_active, "Real shot reaches each resting target: FPS %d seed %d target %d" % [fps, seed_value, target_index])
	game.start_level(3)
	game.ball_active = true
	game.begin_scatter()
	check(game.scatter_state == "", "No surprise while ball is airborne")
	game.ball_active = false
	for attempt in range(3):
		game.scatter_state = ""
		game.begin_scatter()
	check(game.scatter_count == 2 and game.scatter_state == "", "Maximum two pranks")
	game.start_level(3)
	game.hole_positions.assign([Vector2(116, 270), Vector2(270, 390), Vector2(424, 300)])
	game.yumi_position = Vector2(100, 510)
	game.ball_swatted = true
	game.shot_delay = 0.0
	game.aim_angle = 0.0
	game.launch_ball()
	game.ball_type = 1
	game.sequence[0] = 1
	game.ball_swatted = true
	game.advance_ball_segment(2.0)
	check(game.progress == 1 and game.errors == 0, "Ball hits target at its actual height")
	game.start_level(3)
	check(game.scatter_count == 0 and game.scatter_state == "" and game.hole_positions[0] == Vector2(116, 250), "Restart resets layout and prank budget")
	for level in range(3):
		game.start_level(level)
		game.begin_scatter()
		check(game.scatter_state == "", "Earlier levels unchanged")
	game.start_level(3)
	game.rng.seed = 76
	for shot in range(8):
		for step in range(1200):
			if game.scatter_state == "" and game.shot_delay <= 0.0:
				break
			game._process(1.0 / 120.0)
		var target: Vector2 = game.hole_positions[game.sequence[game.progress]]
		game.aim_angle = atan2(target.x - game.LAUNCH_POS.x, game.LAUNCH_POS.y - target.y)
		check(absf(game.aim_angle) <= game.aim_limit(), "Every settled target within aim range")
		game.launch_ball()
		# Isolate target physics from the already-tested cat-ball sabotage.
		game.ball_swatted = true
		for step in range(500):
			if not game.ball_active:
				break
			game._process(1.0 / 120.0)
		check(game.progress == shot + 1 and game.errors == 0, "Complete level matches actual target positions")
	check(game.scatter_count == 2 and game.game_state == "celebrating", "Fourth level finishes after exactly two pranks")
	game.free()
	print("Scatter smoke: %d failures" % failures)
	quit(1 if failures else 0)
