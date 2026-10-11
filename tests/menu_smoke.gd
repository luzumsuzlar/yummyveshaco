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
	check(game.level_cards.size() == 4, "All four levels are available")
	for card in game.level_cards:
		check(Rect2(Vector2.ZERO, game.SCREEN_SIZE).encloses(card.get_rect()), "Cards fit portrait display")
		check(card.size.y >= 48, "Cards have finger-sized hit areas")
		for child in card.get_children():
			if child is Label:
				check(Rect2(Vector2.ZERO, card.size).encloses(child.get_rect()), "Card text fits without overflowing")
	var old_time: float = game.level_time
	game._process(5.0)
	game.launch_ball()
	check(game.level_time == old_time and not game.ball_active, "Menu does not run game or launch balls")
	for index in range(4):
		game.level_cards[index].pressed.emit()
		check(game.level_index == index and game.game_state == "playing" and not game.level_menu.visible, "Card opens correct level")
		check(game.menu_button.visible and game.restart_button.visible, "Playing exposes navigation")
		game.menu_button.pressed.emit()
		check(game.game_state == "menu" and not game.launch_button.visible, "Return hides gameplay controls")
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
	game.free()
	print("Menu smoke: %d failures" % failures)
	quit(1 if failures else 0)
