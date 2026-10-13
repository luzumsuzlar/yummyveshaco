extends SceneTree

var failures := 0

func check(value: bool, message: String) -> void:
	if not value:
		failures += 1
		push_error(message)

func _initialize() -> void:
	call_deferred("run_checks")

func run_checks() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.start_level(3)
	game.shot_delay = 0
	var rng_state: int = game.rng.state
	game.update_yumi_groom(3.6)
	check(game.yumi_groom_time > 0 and game.can_launch_ball(), "Grooming starts without locking the shot")
	check(game.rng.state == rng_state, "Cosmetic scheduling does not consume gameplay randomness")
	var position: Vector2 = game.yumi_position
	var velocity: Vector2 = game.yumi_velocity
	game._process(0.1)
	check(game.yumi_position == position and game.yumi_velocity == velocity, "Grooming rests in place and preserves movement velocity")
	check(game.yumi_art_texture() == game.YUMI_GROOM_ART, "Grooming atlas is visible")
	game.pause_game()
	var phase: float = game.yumi_groom_time
	game._process(4.0)
	check(game.yumi_groom_time == phase, "Pause freezes the idle action")
	game.resume_game()
	game.launch_ball()
	check(game.ball_active and game.yumi_groom_time == 0, "Shot instantly interrupts grooming")
	game._process(0.01)
	check(game.yumi_position != position, "Movement resumes as soon as a ball is launched")
	for event in ["scatter", "toy", "warning", "stage"]:
		game.start_level(3)
		game.shot_delay = 0
		game.yumi_groom_time = 0.5
		match event:
			"scatter": game.scatter_state = "approach"
			"toy": game.toy_active = true
			"warning": game.yumi_warning_timer = 0.3
			"stage": game.stage_rotation = 0.8
		game.update_yumi_groom(0.01)
		check(game.yumi_groom_time == 0, "%s has priority over grooming" % event)
	for index in [0, 4]:
		game.start_level(index)
		game.shot_delay = 0
		game.update_yumi_groom(10.0)
		check(game.yumi_groom_time == 0, "Sleeping and memory roles stay intact")
	game.start_level(3)
	game.shot_delay = 0
	var img: Image = game.YUMI_GROOM_ART.get_image()
	if img.is_compressed(): img.decompress()
	check(absf(img.get_width() / 3.0 - img.get_height() / 2.0) < 1.0, "Atlas has six approximately square frames; fractional UVs tolerate a one-pixel export difference")
	check(img.get_pixel(0, 0).a < 0.01, "Atlas preserves transparent background")
	for variant in range(3):
		game.yumi_groom_variant = variant
		for step in range(8):
			game.yumi_groom_time = game.yumi_groom_duration() * (step + 0.1) / 8.0
			var region: Rect2 = game.yumi_groom_region()
			check(Rect2(Vector2.ZERO, img.get_size()).encloses(region), "Animation frame stays inside the atlas")
			var anchor: Vector2 = game.YUMI_GROOM_ANCHORS[game.yumi_groom_frame()] * (158.0 / 512.0)
			check(is_equal_approx(game.yumi_art_rect().position.y + anchor.y, 67.0), "Feet remain on the same baseline")
	game.show_level_menu()
	check(game.yumi_groom_time == 0, "Menu clears action")
	game.start_level(3)
	check(game.yumi_groom_variant == 0 and game.yumi_groom_wait == 3.5, "Restart resets the idle sequence")
	game.free()
	print("Groom smoke tests: %d failures" % failures)
	quit(1 if failures else 0)
