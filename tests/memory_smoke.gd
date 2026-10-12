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
	game.change_menu_page(1)
	game.level_cards[4].pressed.emit()
	check(game.level_index == 4 and game.is_memory_level(), "Fifth card opens memory prototype")
	check(game.game_progress.level_count == 5 and not game.game_progress.persistence_enabled, "Five-level profile is configured without touching real saves")
	check(not game.yumi_is_active() and not game.level_config()["moving_holes"], "Memory is isolated from cat attacks and moving holes")
	game._process(0.35)
	check(is_equal_approx(game.memory_preview_left, 2.5), "Initial cooldown does not consume clue time")
	game._process(1.0)
	check(is_equal_approx(game.memory_preview_left, 1.5), "Ready time consumes clue")
	game.pause_game()
	game._process(20.0)
	check(is_equal_approx(game.memory_preview_left, 1.5), "Pause freezes clue")
	game.resume_game()
	game._process(1.6)
	check(game.memory_clue_hidden() and game.can_launch_ball(), "Hidden clue does not lock aim or shot")
	check(game.code_label.text.contains("[?]") and not game.code_label.text.contains("◆"), "Top code masks current and future answers")
	check(game.next_label.text.contains("HATIRLA") and not game.next_label.text.contains("BALIK"), "Target panel masks answer and color")
	check(not game.status_label.text.contains("BALIK"), "Status does not leak hidden answer")
	game.register_error("Top deliği ıskaladı!")
	check(game.memory_preview_left == 2.5 and game.errors == 1, "Miss reveals the same clue again")
	game.memory_preview_left = 0.0
	game.shot_delay = 0.0
	game.launch_ball()
	game.resolve_hole_hit((game.ball_type + 1) % 3)
	check(game.errors == 2 and game.progress == 0 and game.memory_preview_left == 2.5, "Wrong hole reveals the same target without advancing")
	game.start_level(4)
	for shot in range(game.sequence.size()):
		while game.shot_delay > 0.0:
			game._process(1.0 / 120.0)
		var target: int = game.sequence[game.progress]
		game._process(2.6)
		check(game.memory_clue_hidden(), "Each ready clue can hide before firing")
		game.update_mouse_aim(game.hole_positions[target])
		game.launch_ball()
		check(game.ball_active and game.ball_type == target, "Hidden launch keeps the actual target")
		for step in range(480):
			game._process(1.0 / 120.0)
			if not game.ball_active:
				break
		check(game.progress == shot + 1 and game.errors == 0, "Real flight resolves remembered target")
		if game.progress < game.sequence.size():
			check(game.memory_preview_left == 2.5, "Success restores a full clue for the next target")
	check(game.game_state == "celebrating" and game.game_progress.best_times.has(4), "Real eight-shot completion records fifth level")
	game._process(2.3)
	game.show_level_menu()
	check(game.menu_page == 1 and game.progress_labels[4].text.contains("Tamamlandı"), "Fifth result appears on its own menu page")
	game.start_level(4)
	check(game.memory_preview_left == 2.5 and game.progress == 0 and game.errors == 0, "Restart resets memory attempt")
	for level in range(4):
		game.start_level(level)
		game._process(3.0)
		check(not game.is_memory_level() and not game.memory_clue_hidden(), "First four levels keep visible clues")
	game.free()
	print("Memory smoke: %d failures" % failures)
	quit(1 if failures else 0)
