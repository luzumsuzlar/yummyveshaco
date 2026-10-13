extends SceneTree

var failures := 0

func check(value: bool, message: String) -> void:
	if not value:
		failures += 1
		push_error(message)

func _initialize() -> void:
	call_deferred("run_checks")

func touch(position: Vector2, pressed: bool, index: int = 0, canceled: bool = false) -> void:
	var event := InputEventScreenTouch.new()
	event.position = position
	event.pressed = pressed
	event.index = index
	event.canceled = canceled
	root.push_input(event, true)

func drag(position: Vector2) -> void:
	var event := InputEventScreenDrag.new()
	event.index = 0
	event.position = position
	root.push_input(event, true)

func run_checks() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	await process_frame
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
		var duration: float = game.yumi_groom_duration()
		game.yumi_groom_time = 0.001
		check(game.yumi_groom_frame() == 5, "Every idle action starts with a neutral attentive pose")
		game.yumi_groom_time = duration - 0.001
		check(game.yumi_groom_frame() == 5, "Every idle action recovers to the neutral pose")
		if variant < 2:
			game.yumi_groom_time = 0.19
			check(game.yumi_groom_frame() == 0, "Prepared action raises its paw after anticipation")
		check(duration == [2.8, 2.4, 1.2][variant], "Anticipation adds no action duration")
		for step in range(8):
			game.yumi_groom_time = game.yumi_groom_duration() * (step + 0.1) / 8.0
			var region: Rect2 = game.yumi_groom_region()
			check(Rect2(Vector2.ZERO, img.get_size()).encloses(region), "Animation frame stays inside the atlas")
			var anchor: Vector2 = game.YUMI_GROOM_ANCHORS[game.yumi_groom_frame()] * (158.0 / 512.0)
			check(is_equal_approx(game.yumi_art_rect().position.y + anchor.y, 67.0), "Feet remain on the same baseline")
	for variant in range(3):
		game.start_level(2)
		game.shot_delay = 0
		game.yumi_groom_variant = variant
		game.yumi_groom_wait = 0
		game.update_yumi_groom(0.01)
		game.update_yumi_groom(0.5)
		check(game.yumi_art_texture() == game.YUMI_GROOM_ART, "Toy interruption starts with a visible grooming pose")
		rng_state = game.rng.state
		game.toy_button.pressed.emit()
		check(game.toy_selecting and game.yumi_groom_time == 0, "Toy selection interrupts grooming in the same input event")
		game.pause_game()
		check(game.yumi_art_texture() != game.YUMI_GROOM_ART, "Immediate pause cannot resurrect interrupted grooming")
		game.resume_game()
		game.toy_button.pressed.emit()
		check(game.toys_left == 2 and game.can_launch_ball() and game.rng.state == rng_state, "Cancelling selection preserves charges, readiness and randomness")
	game.show_level_menu()
	check(game.yumi_groom_time == 0, "Menu clears action")
	game.start_level(3)
	check(game.yumi_groom_variant == 0 and game.yumi_groom_wait == 3.5, "Restart resets the idle sequence")
	# Route real viewport events across the transition, not only launch_ball().
	for rate in [30, 60, 144]:
		game.start_level(3)
		game.shot_delay = 0
		game.yumi_groom_wait = 0.1
		touch(Vector2(270, 400), true)
		for step in range(int(rate * 0.5)):
			game._process(1.0 / rate)
		check(game.yumi_groom_time > 0, "Held aim survives grooming start at %d FPS" % rate)
		drag(Vector2(300, 400))
		var angle: float = game.aim_angle
		touch(Vector2(400, 400), true, 1)
		touch(Vector2(400, 400), false, 1)
		check(not game.ball_active and is_equal_approx(angle, game.aim_angle), "Second finger cannot shoot or steer during grooming")
		touch(Vector2(300, 400), false)
		check(game.ball_active and game.yumi_groom_time == 0, "Held gesture fires across animation start at %d FPS" % rate)
		var velocity_before_repeat: Vector2 = game.ball_velocity
		touch(Vector2(300, 400), false)
		check(game.ball_velocity == velocity_before_repeat and game.barks_left == 3, "Duplicate release cannot fire or bark")
	game.start_level(3)
	game.shot_delay = 0
	game.update_yumi_groom(3.6)
	touch(Vector2(270, 400), true)
	drag(Vector2(310, 400))
	var angle_before_pause: float = game.aim_angle
	var groom_before_pause: float = game.yumi_groom_time
	game._notification(Node.NOTIFICATION_APPLICATION_PAUSED)
	game._process(10.0)
	game._notification(Node.NOTIFICATION_APPLICATION_FOCUS_IN)
	check(game.game_state == "paused" and game.yumi_groom_time == groom_before_pause, "Background/foreground cannot run or resume grooming automatically")
	game.resume_game()
	touch(Vector2(310, 400), false)
	check(not game.ball_active and game.aim_angle == angle_before_pause, "Old held gesture after background cannot shoot")
	touch(Vector2(270, 400), true)
	touch(Vector2(310, 400), false, 0, true)
	check(not game.ball_active and game.yumi_groom_time > 0, "Canceled gesture leaves grooming and ball intact")
	touch(Vector2(270, 400), true)
	touch(Vector2(300, 400), false)
	check(game.ball_active and game.yumi_groom_time == 0, "Fresh gesture after background/cancel fires normally")
	game.free()
	print("Groom smoke tests: %d failures" % failures)
	quit(1 if failures else 0)
