extends SceneTree

var failures := 0

func _initialize() -> void:
	call_deferred("run_checks")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func run_checks() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.start_level(0)
	var original_positions: Array = game.hole_positions.duplicate()
	game.ball_type = game.sequence[0]
	game.ball_position = game.hole_positions[game.ball_type] + Vector2(0, 25)
	game.resolve_hole_hit(game.ball_type)
	check(game.progress == 1 and game.errors == 0, "Goal still scores immediately")
	check(is_equal_approx(game.shot_delay, 0.45), "Drop adds no shot delay")
	check(game.ball_drop_time == game.BALL_DROP_DURATION, "Goal starts drop")
	check(game.hole_positions == original_positions and game.HOLE_RADIUS == 48.0, "Visual depth leaves targets unchanged")
	game._process(0.08)
	var paused_time: float = game.ball_drop_time
	game.pause_game()
	game._process(1.0)
	check(game.ball_drop_time == paused_time, "Pause freezes falling ball")
	game.resume_game()
	game._process(0.4)
	check(game.ball_drop_time == 0.0, "Drop ends after resume")
	game.start_level(0)
	game.ball_type = game.sequence[0]
	game.ball_position = game.hole_positions[1]
	game.resolve_hole_hit(1)
	check(game.errors == 1 and game.progress == 0 and game.ball_drop_hole == 1, "Wrong hole drops without scoring")
	game.show_level_menu()
	check(game.ball_drop_time == 0.0 and game.ball_drop_hole == -1, "Menu clears old drop")
	game.start_level(0)
	game.progress = game.sequence.size() - 1
	game.ball_type = game.sequence[game.progress]
	game.ball_position = game.hole_positions[game.ball_type]
	game.resolve_hole_hit(game.ball_type)
	check(game.game_state == "celebrating" and game.ball_drop_time > 0.0, "Final goal keeps drop during celebration")
	game._process(0.4)
	check(game.ball_drop_time == 0.0, "Celebration advances drop")
	game.start_level(0)
	check(game.ball_drop_hole == -1 and game.ball_drop_time == 0.0, "Restart clears drop")
	game.ball_position = Vector2(-100, game.HOLE_Y)
	game.resolve_hole_hit()
	check(game.ball_drop_time == 0.0, "Miss does not invent hole entry")
	game.free()
	print("Hole drop smoke: %d failures" % failures)
	quit(1 if failures else 0)
