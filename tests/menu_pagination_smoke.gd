extends SceneTree

var failures := 0
var selected_fixture := -1

func _initialize() -> void:
	call_deferred("run_checks")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func click(position: Vector2, pressed: bool) -> void:
	var event := InputEventMouseButton.new()
	event.position = position
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = pressed
	root.push_input(event, true)

func touch(position: Vector2, pressed: bool) -> void:
	var event := InputEventScreenTouch.new()
	event.position = position
	event.index = 0
	event.pressed = pressed
	root.push_input(event, true)

func run_checks() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	await process_frame
	check(not game.menu_next_button.visible and not game.menu_page_label.visible, "Four-level menu retains its original layout")
	check(game.menu_characters[0].visible, "Four-level menu retains characters")
	# UI-only fixtures: no fifth level is claimed playable, no real profile is used.
	for index in range(4, 9):
		var card: Button = game.add_level_menu_card(index, {"name": "%d · DENEME KARTI" % (index + 1)})
		card.pressed.disconnect(game.start_level.bind(index))
		card.pressed.connect(func(): selected_fixture = index)
	game.show_level_menu()
	await process_frame
	check(game.menu_page == 0 and game.menu_page_label.text == "1 / 3", "Nine cards form three pages")
	check(game.menu_previous_button.disabled and not game.menu_next_button.disabled, "First page has a bounded previous button")
	check(not game.menu_characters[0].visible, "Characters do not overlap pagination")
	for page in range(3):
		game.change_menu_page(page - game.menu_page)
		await process_frame
		var visible_count := 0
		for index in range(game.level_cards.size()):
			var card: Button = game.level_cards[index]
			check(card.visible == (index / 4 == page), "Only the selected page is visible")
			check(card.disabled == not card.visible, "Hidden cards cannot activate")
			if card.visible:
				visible_count += 1
				check(Rect2(Vector2.ZERO, game.SCREEN_SIZE).encloses(card.get_rect()), "Visible cards fit portrait")
				check(card.get_rect().end.y < game.menu_next_button.position.y, "Cards do not overlap page controls")
		check(visible_count == (1 if page == 2 else 4), "Partial final page has no dummy cards")
	check(game.menu_next_button.disabled and game.menu_page_label.text == "3 / 3", "Last page has a bounded next button")
	game.change_menu_page(99)
	check(game.menu_page == 2, "High page requests clamp")
	game.change_menu_page(-99)
	check(game.menu_page == 0, "Negative page requests clamp")
	await process_frame
	click(game.menu_next_button.position + game.menu_next_button.size / 2, true)
	click(game.menu_next_button.position + game.menu_next_button.size / 2, false)
	check(game.menu_page == 1 and game.game_state == "menu" and not game.ball_active, "Actual next click changes page without shooting")
	await process_frame
	click(game.level_cards[4].position + game.level_cards[4].size / 2, true)
	click(game.level_cards[4].position + game.level_cards[4].size / 2, false)
	check(selected_fixture == 4, "Fifth card is reachable with correct binding")
	click(game.menu_previous_button.position + game.menu_previous_button.size / 2, true)
	click(game.menu_previous_button.position + game.menu_previous_button.size / 2, false)
	check(game.menu_page == 0, "Actual previous click returns")
	await process_frame
	touch(game.menu_next_button.position + game.menu_next_button.size / 2, true)
	touch(game.menu_next_button.position + game.menu_next_button.size / 2, false)
	check(game.menu_page == 1 and not game.ball_active and game.active_touch_index == -1, "Touch next changes page without arming a shot")
	await process_frame
	touch(game.menu_previous_button.position + game.menu_previous_button.size / 2, true)
	touch(game.menu_previous_button.position + game.menu_previous_button.size / 2, false)
	check(game.menu_page == 0, "Touch previous returns")
	game.start_level(2)
	game.change_menu_page(1)
	check(game.menu_page == 0, "Gameplay ignores hidden page navigation")
	game.show_level_menu()
	check(game.menu_page == 0 and game.level_cards[2].visible, "Returning exposes the current level's page")
	# Future selection restoration is isolated from gameplay level definitions.
	game.level_index = 8
	game.show_level_menu()
	check(game.menu_page == 2 and game.level_cards[8].visible, "Returning restores a later selection page")
	game.free()
	print("Menu pagination smoke: %d failures" % failures)
	quit(1 if failures else 0)
