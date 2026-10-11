extends SceneTree

var failures := 0
var game: Node

func _initialize() -> void:
	call_deferred("run_checks")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func reset(level: int = 2) -> void:
	game.start_level(level)
	game.shot_delay = 0.0
	game.rng.seed = 42

func run_checks() -> void:
	game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	# Predict the target at the actual arrival time, then simulate the flight.
	# Isolate target movement from Yumi, whose warning rules are checked below.
	for fps in [30, 60, 144]:
		for phase in range(8):
			for target_index in range(3):
				reset()
				game.level_time = phase * 0.7
				game.update_holes()
				game.sequence[0] = target_index
				var arrival := 1.0
				var angle := 0.0
				var speed := float(game.level_config().get("ball_speed", 520.0))
				for iteration in range(12):
					var predicted_x: float = game.HOLE_BASE_X[target_index] + sin((game.level_time + arrival) * 1.18 + target_index * 1.65) * 22.0
					angle = atan2(predicted_x - game.LAUNCH_POS.x, game.LAUNCH_POS.y - game.GOAL_LINE)
					arrival = ((game.LAUNCH_POS.y - game.GOAL_LINE) / cos(angle) - 50.0) / speed
				game.aim_angle = angle
				game.launch_ball()
				game.ball_swatted = true
				for step in range(fps * 3):
					game._process(1.0 / fps)
					if not game.ball_active:
						break
				check(game.progress == 1 and game.errors == 0, "Moving target flight at FPS %d phase %d target %d" % [fps, phase, target_index])
	reset()
	game.launch_ball()
	game.ball_position = game.yumi_position + Vector2(0, -40)
	var velocity: Vector2 = game.ball_velocity
	game.update_yumi_attack(0.01)
	check(game.yumi_warning_timer > 0.0 and not game.ball_swatted and game.ball_velocity == velocity, "Cat warns before changing the ball")
	game.update_yumi_attack(0.01)
	check(not game.ball_swatted, "Warning gives reaction time")
	game.use_bark(270)
	game.update_yumi_attack(1.0)
	check(game.ball_swatted and not game.ball_deflected_by_yumi and game.yumi_warning_timer == 0.0, "Bark cancels pending swipe, not just its display")
	reset()
	game.launch_ball()
	game.ball_position = game.yumi_position + Vector2(0, -40)
	game.update_yumi_attack(0.01)
	game.update_yumi_attack(1.0)
	check(game.ball_swatted and game.ball_deflected_by_yumi and game.ball_velocity.y < 0.0, "Ignored warning produces one upward deflection")
	velocity = game.ball_velocity
	game.update_yumi_attack(1.0)
	check(game.ball_velocity == velocity, "Yumi cannot swat the same shot twice")
	reset()
	game.launch_ball()
	game.ball_position = game.yumi_position + Vector2(0, -40)
	game.update_yumi_attack(0.01)
	game.ball_position = game.yumi_position + Vector2(0, -200)
	game.update_yumi_attack(1.0)
	check(game.ball_swatted and not game.ball_deflected_by_yumi, "Moving out of reach makes warned swipe miss")
	# Wrong symbol gives precise feedback; losing keeps the cause; retry clears it.
	reset(0)
	for attempt in range(3):
		game.ball_type = game.sequence[0]
		game.ball_position = game.hole_positions[1]
		game.resolve_hole_hit(1)
	check(game.game_state == "failed" and game.overlay_subtitle.text.contains("PATİ") and game.overlay_subtitle.text.contains("BALIK"), "Loss names actual and expected symbol")
	reset()
	check(game.last_error_message.is_empty(), "Retry clears stale error")
	game.ball_type = game.sequence[0]
	game.ball_deflected_by_yumi = true
	game.ball_position = game.hole_positions[1]
	game.resolve_hole_hit(1)
	check(game.last_error_message.contains("Yumi") and game.yumi_help_count == 0, "Cat-caused wrong goal is explained, not counted as help")
	reset()
	game.ball_type = game.sequence[0]
	game.ball_deflected_by_yumi = true
	game.ball_position = game.hole_positions[0]
	game.resolve_hole_hit(0)
	check(game.progress == 1 and game.yumi_help_count == 1, "Cat's lucky goal counts once")
	game.free()
	print("Interaction smoke: %d failures" % failures)
	quit(1 if failures else 0)
