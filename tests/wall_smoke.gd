extends SceneTree

var failures := 0
var game: Node

func _initialize() -> void:
	call_deferred("run_checks")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func reset(level: int = 1) -> void:
	game.start_level(level)
	game.shot_delay = 0.0
	game.rng.seed = 42

func set_ball(position: Vector2, velocity: Vector2) -> void:
	game.ball_active = true
	game.ball_position = position
	game.ball_velocity = velocity
	game.ball_type = game.sequence[game.progress]

func bank_angle(target: Vector2, bounce_count: int, right: bool) -> float:
	var width: float = game.WALL_RIGHT - game.WALL_LEFT
	var unfolded_x: float
	if bounce_count == 1:
		unfolded_x = 2.0 * game.WALL_RIGHT - target.x if right else 2.0 * game.WALL_LEFT - target.x
	else:
		unfolded_x = target.x + 2.0 * width if right else target.x - 2.0 * width
	return atan2(unfolded_x - game.LAUNCH_POS.x, game.LAUNCH_POS.y - game.GOAL_LINE)

func fire_bank(right: bool = true, auto_bark: bool = false, simulation_delta: float = 1.0 / 120.0) -> void:
	while game.shot_delay > 0.0:
		game._process(simulation_delta)
	var target: Vector2 = game.hole_positions[game.sequence[game.progress]]
	game.aim_angle = bank_angle(target, game.required_wall_bounces(), right)
	check(absf(game.aim_angle) <= game.aim_limit(), "Bank shot is within aiming range")
	game.last_pointer_position = target
	game.launch_ball()
	for step in range(ceili(7.5 / simulation_delta)):
		game._process(simulation_delta)
		if auto_bark and game.yumi_warning_timer > 0.0 and game.bark_available:
			game.use_bark(target.x)
		if not game.ball_active:
			return
	check(false, "Shot must resolve within 7.5s")

func run_checks() -> void:
	game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	reset()
	check(game.sequence.size() == 12 and game.required_wall_bounces() == 1, "Second level has 12 goals and starts with one bank")
	check(not game.yumi_is_active(), "Yumi sleeps in bank tutorial")
	set_ball(Vector2(490, 650), Vector2(300, -400))
	game.advance_ball_segment(0.1)
	check(game.wall_bounces == 1 and game.ball_position.is_equal_approx(Vector2(476, 610)), "Right reflection preserves remaining travel")
	check(game.ball_velocity.is_equal_approx(Vector2(-300, -400)), "Reflection reverses x only and preserves speed")
	reset()
	set_ball(Vector2(50, 650), Vector2(-300, -400))
	game.advance_ball_segment(0.1)
	check(game.wall_bounces == 1 and game.ball_position.is_equal_approx(Vector2(64, 610)), "Left reflection is symmetric")
	check(game.ball_velocity.is_equal_approx(Vector2(300, -400)), "Left reflection preserves angle")
	reset()
	set_ball(Vector2(game.WALL_RIGHT, 650), Vector2(300, -400))
	game.advance_ball_segment(0.1)
	check(game.wall_bounces == 1 and game.ball_position.x < game.WALL_RIGHT, "Exactly on wall cannot loop or tunnel")
	reset()
	set_ball(Vector2(270, 650), Vector2(1200, -10))
	game.advance_ball_segment(2.0)
	check(game.wall_bounces == 2 and game.errors == 1 and not game.ball_active, "Third wall contact ends shot even with large delta")
	reset()
	set_ball(Vector2(270, 970), Vector2(0, 400))
	game.advance_ball_segment(0.1)
	check(game.errors == 1 and not game.ball_active, "Bottom escape still ends shot")
	reset(0)
	set_ball(Vector2(490, 650), Vector2(300, -400))
	game.advance_ball_segment(0.1)
	check(game.wall_bounces == 0 and game.errors == 1, "First level keeps original no-bounce rule")
	reset()
	game.update_mouse_aim(game.hole_positions[game.sequence[0]])
	game.launch_ball()
	for step in range(400):
		game._process(1.0 / 120.0)
		if not game.ball_active:
			break
	check(game.progress == 0 and game.errors == 1, "Straight correct shot cannot bypass bank teaching")
	# Bark must preserve the bank route before, between and after two contacts.
	for already_banked in [0, 1, 2]:
		reset()
		game.stage_index = 1
		game.progress = 4
		game.update_holes()
		var target: Vector2 = game.hole_positions[game.sequence[4]]
		game.aim_angle = bank_angle(target, 2, true)
		game.launch_ball()
		while game.wall_bounces < already_banked and game.ball_active:
			game.move_ball(1.0 / 120.0)
		game.use_bark(target.x)
		for step in range(600):
			game.move_ball(1.0 / 120.0)
			if not game.ball_active:
				break
		check(game.progress == 5 and game.errors == 0 and game.wall_bounces == 2, "Bark preserves route at bank count %d" % already_banked)
	# Eight real trajectories, banked in alternate directions at each new layout.
	reset()
	for shot in range(8):
		fire_bank(shot % 2 == 0)
		check(game.progress == shot + 1 and game.errors == 0, "Bank tutorial goal %d is reachable" % shot)
		check(game.wall_bounces >= (1 if shot < 4 else 2), "Required banks were physically made")
		if shot == 3:
			check(game.stage_index == 1 and not game.yumi_is_active(), "Stage two teaches two banks without cat")
	check(game.stage_index == 2 and game.yumi_is_active() and game.required_wall_bounces() == 1, "Final stage combines Yumi and one bank")
	# Check preview against real bank endpoint for both directions and all holes.
	for bounce_count in [1, 2]:
		for right in [true, false]:
			for target in game.hole_positions:
				game.aim_angle = bank_angle(target, bounce_count, right)
				var points: Array = game.aim_preview_points()
				check(points.size() == bounce_count + 2, "Preview has expected number of reflected segments")
				check(points[-1].is_equal_approx(Vector2(target.x, game.GOAL_LINE)), "Preview reaches chosen goal exactly")
	# Play the final stage too: no goal forcing, only normal aim and warning barks.
	var final_attempts := 0
	while game.progress < 12 and game.game_state == "playing" and final_attempts < 8:
		fire_bank(final_attempts % 2 == 0, true)
		final_attempts += 1
	check(game.game_state == "celebrating" and game.progress == 12, "Second level can be completed with real flights")
	print("Second level playthrough: %.2fs, %d errors, %d barks left" % [game.level_time, game.errors, game.barks_left])
	game._process(2.3)
	check(game.game_state == "success", "Second-level completion reaches results")
	game.on_overlay_button_pressed()
	check(game.level_index == 2, "Second-level results lead to third level")
	for fps in [30, 60, 144]:
		reset()
		for shot in range(8):
			fire_bank(shot % 2 == 0, false, 1.0 / fps)
			check(game.progress == shot + 1 and game.errors == 0, "Bank path is stable at %d FPS, goal %d" % [fps, shot])
	reset()
	game.wall_bounces = 2
	game.barks_left = 0
	game.start_level(1)
	check(game.wall_bounces == 0 and game.barks_left == 3, "Retry resets bounces and bark budget")
	game.free()
	print("Wall smoke tests: %d failures" % failures)
	quit(1 if failures else 0)
