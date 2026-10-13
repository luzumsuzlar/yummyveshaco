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
	game.start_level(2)
	game.shot_delay = 0
	check(game.shako_reaction_pose()["frame"] in [0, 1], "Ready shot displays attention")
	var angle: float = game.aim_angle
	var rng_state: int = game.rng.state
	for index in range(10): game.shako_reaction_pose()
	check(game.aim_angle == angle and game.rng.state == rng_state, "Drawing cannot change aim or gameplay randomness")
	game.launch_ball()
	check(game.shako_reaction_pose()["frame"] == -1, "Flight ends aiming expression")
	for cat_x in [120.0, 420.0]:
		game.yumi_position.x = cat_x
		game.deflect_ball_from_yumi()
		check(game.shako_reaction_pose()["frame"] == 2, "Actual swipe triggers surprise")
		check(game.shako_reaction_pose()["direction"] == (1.0 if cat_x < 270 else -1.0), "Surprise faces the actual cat")
	var pose: Dictionary = game.shako_reaction_pose()
	var velocity: Vector2 = game.ball_velocity
	game.pause_game()
	game._process(3)
	check(game.shako_reaction_pose() == pose and game.ball_velocity == velocity, "Pause preserves expression and ball physics")
	game.resume_game()
	game.ball_position = game.hole_positions[game.ball_type]
	game.resolve_hole_hit(game.ball_type)
	check(game.shako_reaction_pose()["frame"] == 4 and game.shako_surprise_left == 0, "Valid goal replaces surprise with joy")
	check(game.shot_delay == 0.45 and game.progress == 1, "Joy adds no waiting or progress change")
	game._process(0.2)
	check(game.shako_reaction_pose()["frame"] in [4, 5], "Joy persists within normal shot cooldown")
	game._process(0.3)
	check(game.shako_joy_left == 0, "Joy ends at existing next-shot boundary")
	game.start_level(0)
	game.shot_delay = 0
	game.launch_ball()
	game.resolve_hole_hit(1)
	check(game.shako_joy_left == 0 and game.errors == 1, "Wrong goal never celebrates")
	game.finish_game(true)
	game._process(1.8)
	check(game.shared_celebration_pose()["together"] > 0.5, "Shared reaction appears as characters reach the bowl")
	var shared: Dictionary = game.shared_celebration_pose()
	pose = game.shako_reaction_pose()
	var position: Vector2 = game.celebration_shako_position
	game.pause_game()
	game._process(5)
	check(game.shako_reaction_pose() == pose and game.celebration_shako_position == position, "Celebration pose freezes in place on pause")
	check(game.celebration_visual_active() and game.shared_celebration_pose() == shared, "Pause keeps the open cupboard and shared reaction frozen")
	check(game.shako_visual_position() == position, "Paused character and shadow share the same celebration origin")
	game.resume_game()
	game._process(0.5)
	check(game.game_state == "success", "Celebration still finishes after 2.2 seconds")
	game.show_level_menu()
	check(game.shako_joy_left == 0 and game.shako_surprise_left == 0 and game.shako_reaction_pose()["frame"] == -1, "Menu clears reactions")
	game.start_level(0)
	check(game.shako_surprise_left == 0 and game.shako_joy_left == 0, "Restart clears reactions")
	var img: Image = game.SHAKO_REACTION_ART.get_image()
	if img.is_compressed(): img.decompress()
	check(img.get_pixel(0, 0).a < 0.01, "Atlas retains alpha")
	for frame in range(6):
		check(Rect2(Vector2.ZERO, img.get_size()).encloses(game.shako_reaction_region(frame)), "All six poses fit atlas")
	game.free()
	print("Shako reaction smoke: %d failures" % failures)
	quit(1 if failures else 0)
