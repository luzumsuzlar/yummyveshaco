extends SceneTree

var failures := 0
var game: Node

func _initialize() -> void:
	call_deferred("run_checks")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func key(code: Key, echo: bool = false) -> void:
	for pressed in [true, false]:
		var event := InputEventKey.new()
		event.keycode = code
		event.pressed = pressed
		event.echo = echo if pressed else false
		root.push_input(event, true)

func touch(position: Vector2, pressed: bool) -> void:
	var event := InputEventScreenTouch.new()
	event.index = 0
	event.position = position
	event.pressed = pressed
	root.push_input(event, true)

func drag(position: Vector2) -> void:
	var event := InputEventScreenDrag.new()
	event.index = 0
	event.position = position
	root.push_input(event, true)

func run_checks() -> void:
	game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	await process_frame
	for level in range(game.LEVELS.size()):
		game.start_level(level)
		game.shot_delay = 0.0
		touch(Vector2(270, 400), true)
		drag(Vector2(330, 400))
		var angle: float = game.aim_angle
		key(KEY_P)
		check(game.game_state == "paused" and game.active_touch_index == -1, "Keyboard pause clears real touch event in level %d" % level)
		drag(Vector2(450, 400))
		key(KEY_SPACE)
		key(KEY_R)
		check(not game.ball_active and is_equal_approx(game.aim_angle, angle), "Paused input cannot shoot, steer or restart")
		key(KEY_P, true)
		check(game.game_state == "paused", "Key-repeat cannot dismiss pause")
		key(KEY_ESCAPE)
		check(game.game_state == "playing", "Escape resumes through event route")
		touch(Vector2(450, 400), false)
		check(not game.ball_active and is_equal_approx(game.aim_angle, angle), "Old release after pause cannot shoot or change aim")
		touch(Vector2(300, 500), true)
		drag(Vector2(330, 500))
		touch(Vector2(330, 500), false)
		check(game.ball_active and is_equal_approx(game.aim_angle, angle + 30.0 * game.TOUCH_AIM_RADIANS_PER_PIXEL), "Fresh resumed gesture uses preserved relative aim")
		key(KEY_R)
		check(not game.ball_active and game.active_touch_index == -1 and is_zero_approx(game.aim_angle), "Keyboard restart clears shot and aim")
		game.shot_delay = 0.0
		touch(Vector2(330, 500), false)
		key(KEY_SPACE, true)
		check(not game.ball_active, "Old release and held-space repeat cannot shoot after restart")
		key(KEY_SPACE)
		check(game.ball_active, "Fresh space press shoots after restart")
		key(KEY_E)
		key(KEY_E, true)
		key(KEY_E)
		check(game.barks_left == 2, "Repeated bark input spends only one right per shot")
	game.start_level(2)
	game.shot_delay = 0.0
	key(KEY_M)
	touch(Vector2(200, 550), true)
	key(KEY_P)
	check(game.toy_selecting and game.toy_touch_index == -1, "Pause preserves toy selection but cancels placement gesture")
	key(KEY_P)
	touch(Vector2(200, 550), false)
	check(not game.toy_active and game.toys_left == 2, "Old toy release after resume cannot spend a toy")
	touch(Vector2(200, 550), true)
	touch(Vector2(200, 550), false)
	check(game.toy_active and game.toys_left == 1 and not game.ball_active, "Fresh resumed toy gesture places once, without firing")
	var toy_time: float = game.toy_time_left
	key(KEY_P)
	game._process(20.0)
	key(KEY_P)
	check(game.toy_active and game.toy_time_left == toy_time, "Placed toy time survives pause unchanged")
	# Finish a real launched shot while another field gesture remains held.
	# Test routing and counters, not the flight trajectory or phone ergonomics.
	var cues: Array[String] = []
	game.game_audio.effect_played.connect(func(effect: String): cues.append(effect))
	for level in range(game.LEVELS.size()):
		for success in [true, false]:
			game.start_level(level)
			game.shot_delay = 0
			game.level_time = 7.0
			game.progress = game.sequence.size() - 1 if success else 0
			game.errors = 0 if success else 2
			var completed_before: int = game.game_progress.completions.get(level, 0)
			key(KEY_SPACE)
			touch(Vector2(300, 500), true)
			check(game.ball_active and game.active_touch_index == 0 and not game.touch_can_launch, "In-flight held touch is tracked without arming another shot")
			game.wall_bounces = game.required_wall_bounces()
			var hole: int = game.ball_type if success else (game.ball_type + 1) % 3
			game.ball_position = game.hole_positions[hole]
			cues.clear()
			game.resolve_hole_hit(hole)
			check(game.active_touch_index == -1 and not game.touch_can_launch, "Result cancels held input in level %d" % level)
			check(cues == (["unlock"] if success else []), "Result emits only its intended sound")
			var expected_count := completed_before + (1 if success else 0)
			check(game.game_progress.completions.get(level, 0) == expected_count, "Only a successful finish records completion")
			if success: game._process(2.3)
			drag(Vector2(350, 500))
			touch(Vector2(350, 500), false)
			key(KEY_SPACE)
			check(not game.ball_active and game.game_state == ("success" if success else "failed"), "Result ignores old field release and space")
			check(game.level_time == 7.0 and game.game_progress.completions.get(level, 0) == expected_count, "Result input cannot add time or duplicate completion")
			game.overlay_button.pressed.emit()
			game.shot_delay = 0
			cues.clear()
			touch(Vector2(350, 500), false)
			check(not game.ball_active and cues.is_empty() and game.aim_angle == 0, "Stale release cannot fire or sound in the next attempt")
			touch(Vector2(300, 500), true)
			drag(Vector2(330, 500))
			touch(Vector2(330, 500), false)
			check(game.ball_active and cues == ["launch"], "Fresh result-to-play gesture launches exactly once")
	game.free()
	print("Input lifecycle smoke: %d failures" % failures)
	quit(1 if failures else 0)
