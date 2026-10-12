extends SceneTree

var failures := 0

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

func drag(index: int, position: Vector2) -> void:
	var event := InputEventScreenDrag.new()
	event.index = index
	event.position = position
	root.push_input(event, true)

func ready_memory(game: Node) -> void:
	game.start_level(4)
	game.shot_delay = 0.0
	game.update_interface()

func check_boundary_inputs(game: Node) -> void:
	# Real event dispatch through the viewport, not direct touch handlers.
	for fps in [30, 60, 144]:
		ready_memory(game)
		game.memory_preview_left = 0.5 / fps
		touch(0, Vector2(270, 440), true)
		drag(0, Vector2(290, 440))
		var angle: float = game.aim_angle
		game._process(1.0 / fps)
		check(game.memory_clue_hidden() and game.active_touch_index == 0 and game.touch_can_launch, "Hiding preserves armed gesture at %d FPS" % fps)
		check(is_equal_approx(game.aim_angle, angle), "Hiding never moves the relative aim")
		touch(1, Vector2(150, 440), true)
		drag(1, Vector2(420, 440))
		touch(1, Vector2(420, 440), false)
		check(not game.ball_active and is_equal_approx(game.aim_angle, angle), "Second finger cannot act across clue hide")
		touch(0, Vector2(290, 440), false)
		check(game.ball_active and game.ball_type == game.sequence[0] and is_equal_approx(game.aim_angle, angle), "Release after hide launches once with preserved aim")
		var velocity: Vector2 = game.ball_velocity
		touch(0, Vector2(290, 440), false)
		check(game.ball_velocity == velocity and game.barks_left == 3, "Duplicate release neither fires again nor barks")
	ready_memory(game)
	game.memory_preview_left = 0.0
	game.update_interface()
	touch(0, Vector2(270, 440), true)
	drag(0, Vector2(330, 440))
	touch(0, Vector2(330, 440), false, true)
	check(not game.ball_active and game.active_touch_index == -1 and game.errors == 0, "Canceled hidden-clue drag is free")
	touch(0, Vector2(270, 440), true)
	touch(0, Vector2(530, 940), false)
	check(not game.ball_active and game.active_touch_index == -1, "Outside release cannot leave a hidden-clue gesture armed")
	ready_memory(game)
	game.memory_preview_left = 0.4
	touch(0, Vector2(270, 440), true)
	drag(0, Vector2(310, 440))
	var angle: float = game.aim_angle
	game._notification(Node.NOTIFICATION_APPLICATION_PAUSED)
	game._process(30.0)
	check(game.game_state == "paused" and is_equal_approx(game.memory_preview_left, 0.4), "Backgrounding preserves remaining clue time")
	check(game.active_touch_index == -1 and not game.touch_can_launch, "Backgrounding cancels old gesture")
	game._notification(Node.NOTIFICATION_APPLICATION_RESUMED)
	check(game.game_state == "paused", "Foregrounding cannot silently resume the clue clock")
	game.resume_game()
	touch(0, Vector2(310, 440), false)
	check(not game.ball_active and is_equal_approx(game.aim_angle, angle), "Old foreground release cannot shoot")
	game._process(0.5)
	touch(0, Vector2(270, 440), true)
	touch(0, Vector2(270, 440), false)
	check(game.ball_active, "Fresh hidden-clue gesture works after foreground resume")
	ready_memory(game)
	game.shot_delay = 0.1
	touch(0, Vector2(270, 440), true)
	game._process(0.2)
	touch(0, Vector2(270, 440), false)
	check(not game.ball_active and game.memory_preview_left == 2.5, "Cooldown-started gesture cannot become a shot or consume clue")
	touch(0, Vector2(270, 440), true)
	touch(0, Vector2(270, 440), false)
	check(game.ball_active and game.memory_preview_left == 2.5, "Early ready shot is allowed before hiding")
	game._process(0.1)
	check(game.ball_active and game.memory_preview_left == 2.5, "Flight does not consume unused clue time")
	game.show_level_menu()
	game._process(30.0)
	check(game.memory_preview_left == 2.5 and game.active_touch_index == -1, "Menu neither runs clue clock nor keeps touch state")

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
	check_boundary_inputs(game)
	for level in range(4):
		game.start_level(level)
		game._process(3.0)
		check(not game.is_memory_level() and not game.memory_clue_hidden(), "First four levels keep visible clues")
	game.free()
	print("Memory smoke: %d failures" % failures)
	quit(1 if failures else 0)
