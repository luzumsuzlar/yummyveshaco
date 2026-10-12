extends SceneTree

var failures := 0

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func _initialize() -> void:
	call_deferred("run_checks")

func click(position: Vector2, pressed: bool) -> void:
	var event := InputEventMouseButton.new()
	event.position = position
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = pressed
	root.push_input(event, true)

func run_checks() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	await process_frame
	check(game.game_state == "menu" and game.level_menu.visible, "Normal launch opens level menu")
	check(game.level_cards.size() == game.LEVELS.size(), "All defined levels are available")
	for card in game.level_cards:
		check(Rect2(Vector2.ZERO, game.SCREEN_SIZE).encloses(card.get_rect()), "Cards fit portrait display")
		check(card.size.y >= 48, "Cards have finger-sized hit areas")
		for child in card.get_children():
			if child is Label:
				check(Rect2(Vector2.ZERO, card.size).encloses(child.get_rect()), "Card text fits without overflowing")
		var labels: Array[Label] = []
		for child in card.get_children():
			if child is Label:
				labels.append(child)
		check(labels.size() == 3, "Card has title, description and progress")
		check(labels[1].position.y - labels[0].get_rect().end.y >= 4.0, "Title is separated from description")
		check(labels[2].position.y - labels[1].get_rect().end.y >= 8.0, "Progress has a clear gap after description: %s, description %s, progress %s" % [labels[0].text, labels[1].get_rect(), labels[2].get_rect()])
		for label in labels:
			check(label.get_combined_minimum_size().y <= label.size.y, "Rendered text height fits its assigned area")
	var old_time: float = game.level_time
	game._process(5.0)
	game.launch_ball()
	check(game.level_time == old_time and not game.ball_active, "Menu does not run game or launch balls")
	for index in range(game.LEVELS.size()):
		game.level_cards[index].pressed.emit()
		check(game.level_index == index and game.game_state == "playing" and not game.level_menu.visible, "Card opens correct level")
		check(game.menu_button.visible and game.restart_button.visible, "Playing exposes navigation")
		game.menu_button.pressed.emit()
		check(game.game_state == "menu" and not game.launch_button.visible, "Return hides gameplay controls")
	game.start_level(0)
	game.show_level_menu()
	click(Vector2(250, 710), true)
	click(Vector2(250, 710), false)
	check(game.level_index == 3 and game.game_state == "playing" and not game.ball_active, "Real card click opens fourth level without shooting")
	game.start_level(2)
	game.toy_selecting = true
	game.toy_touch_index = 0
	game.active_touch_index = 1
	game.touch_can_launch = true
	game.ball_active = true
	game.show_level_menu()
	check(not game.toy_selecting and game.toy_touch_index == -1 and game.active_touch_index == -1 and not game.ball_active, "Return clears touch and ability state")
	game.start_level(3)
	game.scatter_state = "warning"
	game.show_level_menu()
	check(game.scatter_state == "", "Return cancels target scatter")
	game.start_level(0)
	game.finish_game(false)
	var found := false
	for child in game.overlay.get_children():
		if child is Button and child.text == "BÖLÜMLER":
			found = true
			child.pressed.emit()
	check(found and game.game_state == "menu" and not game.overlay.visible, "Loss screen returns to menu")
	game.start_level(3)
	game.finish_game(true)
	game.show_level_menu()
	game._process(3.0)
	check(game.game_state == "menu" and not game.overlay.visible, "Celebration cannot revive overlay after return")
	game.start_level(0)
	check(game.progress == 0 and game.errors == 0 and game.level_time == 0.0, "Selection starts a fresh attempt")
	for success in [false, true]:
		game.start_level(2)
		game.toy_selecting = true
		game.toy_active = true
		game.toy_touch_index = 0
		game.progress = game.sequence.size() if success else 0
		game.level_time = 40.0
		game.finish_game(success)
		check(not game.toy_selecting and not game.toy_active and game.toy_touch_index == -1, "Results close toy selection and active distraction")
		var stale_release := InputEventScreenTouch.new()
		stale_release.index = 0
		stale_release.position = Vector2(200, 550)
		stale_release.pressed = false
		game.handle_touch(stale_release)
		check(not game.toy_active and not game.ball_active, "Old toy release cannot act on result screen")
		game.start_level(2)
		check(game.toys_left == 2 and not game.toy_selecting, "Next attempt gets clean toy state")
	# Exercise all result buttons through GUI, including last -> first.
	# Completion is forced here only to isolate navigation, not prove playability.
	for index in range(game.LEVELS.size()):
		game.start_level(index)
		game.progress = game.sequence.size()
		game.level_time = 70.0 + index
		game.finish_game(true)
		game._process(2.3)
		check(game.game_state == "success" and game.overlay.visible, "Each completion opens its result screen")
		click(game.overlay_button.position + game.overlay_button.size / 2, true)
		click(game.overlay_button.position + game.overlay_button.size / 2, false)
		check(game.level_index == (index + 1) % game.LEVELS.size() and game.game_state == "playing", "Actual result click advances or wraps to first level")
		check(not game.ball_active and not game.overlay.visible and not game.pause_panel.visible, "Transition click cannot launch a shot or keep an old modal")
		check(game.progress == 0 and game.errors == 0 and game.barks_left == 3, "Each next level resets attempt and bark budget")
		check(game.toys_left == (2 if game.level_index == 2 else 0), "Next level applies its own toy budget")
	game.free()
	print("Menu smoke: %d failures" % failures)
	quit(1 if failures else 0)
