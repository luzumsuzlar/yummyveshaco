extends SceneTree

var failures := 0
var game: Node

func _initialize() -> void:
	call_deferred("run_checks")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func touch(index: int, position: Vector2, pressed: bool, canceled: bool = false) -> void:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.position = position
	event.pressed = pressed
	event.canceled = canceled
	root.push_input(event, true)

func mouse(position: Vector2, pressed: bool, emulated: bool = false) -> void:
	var event := InputEventMouseButton.new()
	event.position = position
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = pressed
	event.device = InputEvent.DEVICE_ID_EMULATION if emulated else 0
	root.push_input(event, true)

func drag_touch(index: int, position: Vector2) -> void:
	var event := InputEventScreenDrag.new()
	event.index = index
	event.position = position
	root.push_input(event, true)

func reset(level: int = 0) -> void:
	game.start_level(level)
	game.shot_delay = 0.0
	game.update_interface()

func run_checks() -> void:
	game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	await process_frame
	# Normal startup now opens the menu; explicitly select the tutorial for play tests.
	game.start_level(0)
	check(root.content_scale_size == Vector2i(540, 960), "Viewport is portrait 540x960")
	check(ProjectSettings.get_setting("display/window/handheld/orientation") == DisplayServer.SCREEN_PORTRAIT, "Mobile orientation is portrait")
	for button in [game.launch_button, game.bark_button, game.restart_button]:
		check(Rect2(Vector2.ZERO, game.SCREEN_SIZE).encloses(button.get_rect()), "Button stays in portrait bounds")
		check(button.size.y >= 48.0, "Button has finger-sized hit area")
	check(not game.yumi_is_active(), "Yumi sleeps at start")
	var sleep_position: Vector2 = game.yumi_position
	game.move_yumi(1.0)
	check(game.yumi_position == sleep_position, "Sleeping Yumi stays still")
	# Real ball flights for the four tutorial shots, not forced goal states.
	for shot in range(4):
		while game.shot_delay > 0.0:
			game._process(1.0 / 120.0)
		game.update_mouse_aim(game.hole_positions[game.sequence[game.progress]])
		game.launch_ball()
		for step in range(600):
			game._process(1.0 / 120.0)
			if not game.ball_active:
				break
		check(game.progress == shot + 1 and game.errors == 0, "Tutorial target reachable: %d" % shot)
	check(game.yumi_is_active() and game.stage_index == 1, "Four goals wake Yumi")
	# Relative touch preserves aim on press, ignores vertical motion and other fingers.
	reset()
	game.update_mouse_aim(Vector2(116, 250))
	var previous_angle: float = game.aim_angle
	var previous_target: Vector2 = game.last_pointer_position
	touch(0, Vector2(420, 700), true)
	check(is_equal_approx(game.aim_angle, previous_angle), "Touch down does not teleport aim")
	check(game.last_pointer_position == previous_target, "Touch down preserves bark target")
	drag_touch(0, Vector2(420, 450))
	check(is_equal_approx(game.aim_angle, previous_angle), "Vertical drag leaves aim unchanged")
	drag_touch(0, Vector2(450, 450))
	check(is_equal_approx(game.aim_angle, previous_angle + 30.0 * game.TOUCH_AIM_RADIANS_PER_PIXEL), "Horizontal drag adjusts existing angle")
	var relative_angle: float = game.aim_angle
	drag_touch(1, Vector2(50, 450))
	check(is_equal_approx(game.aim_angle, relative_angle), "Other finger drag cannot change aim")
	drag_touch(0, Vector2(390, 500))
	check(game.aim_angle < previous_angle, "Reversing drag turns aim left")
	touch(0, Vector2(390, 500), false, true)
	reset()
	touch(0, Vector2(200, 700), true)
	drag_touch(0, Vector2(240, 700))
	var first_origin_angle: float = game.aim_angle
	touch(0, Vector2(240, 700), false, true)
	reset()
	touch(0, Vector2(380, 400), true)
	drag_touch(0, Vector2(420, 400))
	check(is_equal_approx(game.aim_angle, first_origin_angle), "Same drag gives same aim from another screen position")
	var expected_target_x: float = game.LAUNCH_POS.x + tan(game.aim_angle) * (game.LAUNCH_POS.y - game.HOLE_Y)
	check(is_equal_approx(game.last_pointer_position.x, expected_target_x), "Touch bark target lies on aimed ray")
	touch(0, Vector2(440, 400), false)
	check(is_equal_approx(game.aim_angle, 60.0 * game.TOUCH_AIM_RADIANS_PER_PIXEL), "Release uses final relative displacement")
	check(game.ball_active, "Relative release launches")
	reset(1)
	touch(0, Vector2(40, 700), true)
	drag_touch(0, Vector2(500, 700))
	check(is_equal_approx(game.aim_angle, game.aim_limit()), "Relative drag respects level aim limit")
	touch(0, Vector2(500, 700), false, true)
	# Native touch ignores another finger and launches on release.
	reset()
	touch(0, Vector2(116, 250), true)
	check(not game.ball_active and game.active_touch_index == 0, "Touch down aims without firing")
	var drag := InputEventScreenDrag.new()
	drag.index = 0
	drag.position = Vector2(424, 250)
	root.push_input(drag, true)
	check(game.aim_angle > 0.0, "Drag updates aim")
	touch(1, Vector2(116, 250), true)
	touch(1, Vector2(116, 250), false)
	check(game.active_touch_index == 0 and not game.ball_active, "Second finger cannot hijack drag")
	touch(0, Vector2(424, 250), false)
	check(game.ball_active and game.active_touch_index == -1, "Release fires once")
	mouse(Vector2(424, 250), true, true)
	check(game.barks_left == 3, "Emulated duplicate click does not bark")
	touch(0, Vector2(270, 400), true)
	var flight_target: Vector2 = game.last_pointer_position
	drag_touch(0, Vector2(400, 400))
	check(game.last_pointer_position == flight_target, "In-flight touch does not hijack bark target")
	game.ball_active = false
	game.shot_delay = 0.0
	touch(0, Vector2(270, 400), false)
	check(not game.ball_active, "Gesture started in flight cannot launch next shot")
	# A gesture begun while the launcher is blocked must not become a delayed shot.
	for blocker in ["shot_delay", "stage_rotation", "scatter_state"]:
		reset()
		game.set(blocker, "return" if blocker == "scatter_state" else 0.5)
		touch(0, Vector2(270, 400), true)
		game.set(blocker, "" if blocker == "scatter_state" else 0.0)
		touch(0, Vector2(270, 400), false)
		check(not game.ball_active, "Blocked gesture cannot launch later: %s" % blocker)
		touch(0, Vector2(270, 400), true)
		touch(0, Vector2(270, 400), false)
		check(game.ball_active, "Fresh gesture launches after blocker ends: %s" % blocker)
	# Canceled/outside releases must never fire or poison the next gesture.
	reset()
	touch(0, Vector2(270, 400), true)
	touch(0, Vector2(270, 400), false, true)
	check(not game.ball_active and game.active_touch_index == -1, "Canceled gesture does not fire")
	touch(0, Vector2(270, 400), true)
	touch(0, Vector2(10, 400), false)
	check(not game.ball_active and game.active_touch_index == -1, "Outside release cancels")
	touch(0, Vector2(270, 400), true)
	touch(0, Vector2(400, 900), false)
	check(not game.ball_active and game.active_touch_index == -1, "Release over GUI cancels drag")
	# Test the actual GUI signal route with emulated touchscreen clicks.
	reset()
	game.last_pointer_position = Vector2(116, 250)
	game.update_mouse_aim(game.last_pointer_position)
	mouse(game.launch_button.position + game.launch_button.size / 2, true, true)
	mouse(game.launch_button.position + game.launch_button.size / 2, false, true)
	check(game.ball_active, "AT button launches through GUI")
	game.yumi_warning_timer = 0.42
	game.update_interface()
	mouse(game.bark_button.position + game.bark_button.size / 2, true, true)
	mouse(game.bark_button.position + game.bark_button.size / 2, false, true)
	check(game.barks_left == 2 and game.yumi_warning_timer == 0.0, "HAV button spends one right and cancels warning")
	check(is_equal_approx(game.bark_target_x, 116.0), "HAV button uses aim target, not button x")
	game.update_interface()
	check(game.bark_button.disabled, "HAV disabled after one use in a shot")
	game.use_bark(270)
	check(game.barks_left == 2, "Second bark in one shot rejected")
	# Exhaustion and retry restore original level rules.
	for remaining in [1, 0]:
		game.ball_active = false
		game.shot_delay = 0.0
		game.launch_ball()
		game.use_bark(270)
		check(game.barks_left == remaining, "Bark budget persists across shots")
	game.ball_active = false
	game.shot_delay = 0.0
	game.launch_ball()
	game.use_bark(270)
	check(game.barks_left == 0, "Empty budget cannot become negative")
	reset()
	game.progress = 5
	game.register_error("test miss")
	check(game.progress == 5, "Miss preserves progress")
	game.register_error("test miss")
	game.register_error("test miss")
	check(game.game_state == "failed" and game.overlay.visible, "Three errors show loss")
	game.on_overlay_button_pressed()
	check(game.progress == 0 and game.barks_left == 3 and not game.overlay.visible, "Retry resets resources and progress")
	# Later-level hole and cat bounds, including moving targets.
	for level in range(3):
		reset(level)
		for sample in range(240):
			game.level_time = sample * 0.1
			game.update_holes()
			game.move_yumi(0.1)
			for hole in game.hole_positions:
				check(hole.x - game.HOLE_RADIUS > 24 and hole.x + game.HOLE_RADIUS < 516, "Moving hole fits screen")
			check(game.yumi_position.x >= game.YUMI_MIN_X and game.yumi_position.x <= game.YUMI_MAX_X, "Yumi fits portrait movement area")
	# One lucky final shot gives shared food scene and counted help.
	reset()
	game.progress = 11
	game.stage_index = 2
	game.update_holes()
	game.ball_type = game.sequence[11]
	game.ball_position = game.hole_positions[game.ball_type]
	game.ball_deflected_by_yumi = true
	game.level_time = 37.0
	game.resolve_hole_hit()
	check(game.game_state == "celebrating" and game.yumi_help_count == 1, "Lucky final goal gives celebration")
	game._process(2.3)
	check(game.game_state == "success" and game.overlay.visible, "Food animation reaches success")
	check(is_equal_approx(game.level_time, 37.0), "Celebration excluded from completion time")
	check(Rect2(Vector2.ZERO, game.SCREEN_SIZE).encloses(game.overlay_button.get_rect()), "Result action stays inside portrait")
	game.on_overlay_button_pressed()
	check(game.level_index == 1 and game.barks_left == 3 and game.launch_button.visible, "Next level restores buttons and budget")
	for window_size in [Vector2i(360, 800), Vector2i(600, 960), Vector2i(720, 1280)]:
		root.size = window_size
		await process_frame
		check(root.get_visible_rect().size.is_equal_approx(Vector2(540, 960)), "Aspect ratio retains logical playfield at %s" % window_size)
	game.free()
	print("Portrait smoke tests: %d failures" % failures)
	quit(1 if failures else 0)
