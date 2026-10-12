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
	for level in range(4):
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
	game.free()
	print("Input lifecycle smoke: %d failures" % failures)
	quit(1 if failures else 0)
