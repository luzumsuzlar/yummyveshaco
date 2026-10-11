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
	check(game.tutorial_hint() == "" and not game.tutorial_label.visible, "Menu has no tutorial clutter")
	game.start_level(0)
	check(game.tutorial_hint() == "aim", "First attempt teaches aiming")
	check(game.tutorial_label.mouse_filter == Control.MOUSE_FILTER_IGNORE, "Tip never blocks input")
	var event := InputEventScreenTouch.new()
	event.index = 0
	event.position = Vector2(350, 600)
	event.pressed = true
	game.handle_touch(event)
	game.update_interface()
	check(game.tutorial_touch_mode and game.tutorial_label.text.contains("sürükle"), "Touch gets relative-drag instructions")
	event.pressed = false
	event.canceled = true
	game.handle_touch(event)
	check(not game.tutorial_aim_done, "Canceled gesture does not dismiss teaching")
	game.shot_delay = 0
	game.launch_ball()
	check(game.tutorial_hint() == "" and game.ball_active, "Valid shot completes aim tip without changing launch")
	game.start_level(0)
	game.tutorial_aim_done = true
	game.progress = 3
	game.ball_type = game.sequence[3]
	game.ball_position = game.hole_positions[game.ball_type]
	game.resolve_hole_hit()
	game.update_interface()
	check(game.progress == 4 and game.tutorial_hint() == "bark", "Waking at fourth goal teaches warning and bark")
	game.tutorial_bark_time = 0
	check(game.tutorial_hint() == "", "Wake-up tip does not stay forever")
	game.ball_active = true
	game.bark_available = true
	game.yumi_warning_timer = 0.3
	check(game.tutorial_hint() == "bark", "First real warning repeats timely help")
	game.use_bark(270)
	check(game.tutorial_bark_done and game.tutorial_hint() == "" and game.barks_left == 2, "Bark completes tip with normal budget")
	game.start_level(2)
	check(game.tutorial_hint() == "toy", "Third level teaches mouse toy")
	game.toggle_toy_selection()
	check(game.tutorial_hint() == "toy_place", "Selection explains highlighted area")
	game.place_toy(Vector2(50, 300))
	check(game.tutorial_hint() == "toy_place" and not game.tutorial_toy_done, "Invalid placement does not dismiss teaching")
	game.toggle_toy_selection()
	check(game.tutorial_hint() == "toy" and game.toys_left == 2, "Cancel is free and restores tip")
	game.toggle_toy_selection()
	game.place_toy(Vector2(400, 550))
	check(game.tutorial_toy_done and game.tutorial_hint() == "" and game.toys_left == 1, "Valid toy placement finishes help")
	game.finish_game(false)
	check(game.tutorial_hint() == "" and not game.tutorial_label.visible, "Results hide tutorial")
	for level in [1, 3]:
		game.start_level(level)
		check(game.tutorial_hint() == "", "No unrelated teaching in levels two and four")
	game.start_level(0)
	check(game.tutorial_hint() == "aim", "Restart offers help again")
	game.show_level_menu()
	check(not game.tutorial_label.visible, "Return hides tip")
	game.free()
	await process_frame
	print("Tutorial smoke: %d failures" % failures)
	quit(1 if failures else 0)
