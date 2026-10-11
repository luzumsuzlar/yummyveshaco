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
	check(not game.pause_button.visible and not game.pause_panel.visible, "Menu hides pause UI")
	game.start_level(2)
	game.shot_delay = 0
	game.launch_ball()
	game.yumi_warning_timer = 0.2
	game.active_touch_index = 0
	game.touch_can_launch = true
	var position: Vector2 = game.ball_position
	var velocity: Vector2 = game.ball_velocity
	var cat: Vector2 = game.yumi_position
	var timer: float = game.level_time
	game.pause_button.pressed.emit()
	check(game.game_state == "paused" and game.pause_panel.visible, "Pause button opens modal")
	game._process(10)
	check(game.ball_position == position and game.ball_velocity == velocity and game.yumi_position == cat, "Motion freezes without changing velocities")
	check(game.level_time == timer and is_equal_approx(game.yumi_warning_timer, 0.2), "Timers freeze")
	check(game.active_touch_index == -1 and not game.touch_can_launch, "Pause cancels old touch")
	game.resume_game()
	check(game.game_state == "playing" and game.ball_active and not game.pause_panel.visible, "Resume preserves live shot")
	game._process(0.01)
	check(game.ball_position != position, "Live shot continues after resume")
	game.start_level(3)
	game.progress = 2
	game.begin_scatter()
	game.pause_game()
	game._process(20)
	check(game.scatter_state == "approach", "Target prank freezes")
	game.resume_game()
	check(game.scatter_state == "approach", "Prank resumes rather than restarting")
	game.start_level(0)
	game.finish_game(true)
	game.pause_game()
	game._process(10)
	check(game.game_state == "paused" and game.celebration_time == 0, "Celebration freezes")
	game.resume_game()
	game._process(2.3)
	check(game.game_state == "success", "Celebration completes after resume")
	game.start_level(0)
	game._notification(Node.NOTIFICATION_APPLICATION_PAUSED)
	check(game.game_state == "paused", "Phone backgrounding pauses")
	game._notification(Node.NOTIFICATION_WM_GO_BACK_REQUEST)
	check(game.game_state == "playing", "Back resumes paused game")
	game._notification(Node.NOTIFICATION_WM_GO_BACK_REQUEST)
	check(game.game_state == "paused", "Back pauses active game")
	game.start_level(1)
	check(game.game_state == "playing" and not game.pause_panel.visible, "Restart dismisses modal")
	game.pause_game()
	game.show_level_menu()
	check(game.game_state == "menu" and not game.pause_panel.visible, "Menu return dismisses modal")
	check(not ProjectSettings.get_setting("application/config/quit_on_go_back"), "Android back does not auto-quit")
	game.free()
	await process_frame
	print("Pause smoke: %d failures" % failures)
	quit(1 if failures else 0)
