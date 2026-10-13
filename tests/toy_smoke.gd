extends SceneTree

var failures := 0

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func _initialize() -> void:
	call_deferred("run_checks")

func touch(index: int, position: Vector2, pressed: bool, canceled: bool = false) -> InputEventScreenTouch:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.position = position
	event.pressed = pressed
	event.canceled = canceled
	return event

func run_checks() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	for level in [0, 1]:
		game.start_level(level)
		game.toggle_toy_selection()
		check(not game.toy_selecting and not game.toy_button.visible, "Earlier levels unchanged")
	game.start_level(2)
	game.shot_delay = 0
	game.toggle_toy_selection()
	game.launch_ball()
	check(not game.ball_active and game.toys_left == 2, "Selection never launches or spends")
	game.place_toy(Vector2(50, 300))
	check(game.toy_selecting and game.toys_left == 2, "Invalid placement is free")
	game.handle_touch(touch(0, Vector2(400, 500), true))
	game.handle_touch(touch(1, Vector2(120, 550), true))
	game.handle_touch(touch(1, Vector2(120, 550), false))
	check(not game.toy_active, "Second finger cannot place")
	game.handle_touch(touch(0, Vector2(400, 500), false, true))
	check(not game.toy_active and game.toys_left == 2, "Canceled touch spends nothing")
	game.handle_touch(touch(0, Vector2(400, 500), true))
	game.handle_touch(touch(0, Vector2(400, 500), false))
	check(game.toy_active and game.toys_left == 1 and not game.ball_active, "Release places without launching")
	check(game.toy_feedback()["phase"] == "travel", "Travel has a distinct visual phase")
	check(game.ability_label.text.contains("FAREYE GİDİYOR") and game.ability_label.text.contains("Atış hazır"), "Travel exposes current shot readiness")
	check(game.toy_button.text == "FARE AKTİF" and game.toy_button.disabled, "Active toy is distinct from remaining charges")
	game.shot_delay = 0.1
	game.update_interface()
	check(game.ability_label.text.contains("Atış hazırlanıyor") and game.launch_button.disabled, "Cooldown cannot advertise a ready shot")
	game.shot_delay = 0.0
	game.yumi_warning_timer = 0.01
	game.ball_active = true
	game.ball_type = 2
	game.ball_position = game.yumi_position
	game.yumi_warning_timer = 0
	game.update_yumi_attack(1.0)
	check(not game.ball_swatted and game.yumi_warning_timer == 0, "Toy suppresses attacks")
	var destination: Vector2 = game.toy_position - Vector2(0, 50)
	var distance: float = game.yumi_position.distance_to(destination)
	game.move_yumi(0.1)
	check(game.yumi_position.distance_to(destination) < distance, "Toy overrides yarn pursuit")
	game.yumi_position = destination - Vector2(8, 0)
	game.move_yumi(0.1)
	check(game.status_label.text.contains("yakaladı"), "Arrival replaces the stale travel message")
	game.toy_time_left = 4.0
	game.toy_play_left = 2.5
	game.ball_active = false
	game.update_interface()
	check(game.toy_feedback()["phase"] == "play" and game.ability_label.text.contains("2.5 sn kaldı"), "Arrival shows actual play time, not the total travel cap")
	game.toy_time_left = 0.7
	game.update_interface()
	check(is_equal_approx(game.toy_feedback()["remaining"], 0.7), "Earlier total timeout limits displayed play time")
	check(game.ability_label.text.contains("0.7 sn kaldı"), "Last-second feedback reflects the limiting timer")
	var feedback: Dictionary = game.toy_feedback()
	game.toy_play_left = 2.125
	var toy_position: Vector2 = game.toy_position
	var pose: Dictionary = game.toy_play_pose()
	check(pose["playing"] and Vector2(pose["position"]).distance_to(toy_position) > 30.0, "Caught mouse becomes visible beside the cat")
	check(game.yumi_art_texture() == game.YUMI_PAW_ART, "Caught mouse gets a playful paw pose")
	check(game.yumi_paw_motion()["impact"] == 0.0, "Toy taps never draw attack impact effects")
	check(game.toy_position == toy_position, "Visual mouse motion cannot alter the gameplay destination")
	var original_cat: Vector2 = game.yumi_position
	for edge_x in [100.0, 440.0]:
		game.toy_position.x = edge_x
		game.yumi_position = game.toy_position - Vector2(0, 50)
		var edge_pose: Dictionary = game.toy_play_pose()
		check((float(edge_pose["direction"]) > 0) == (edge_x < 270), "Playful paw faces inward at both placement edges")
		check(float(edge_pose["position"].x) > 60 and float(edge_pose["position"].x) < 480, "Toy stays visible inside portrait edges")
	game.toy_position = toy_position
	game.yumi_position = original_cat
	feedback = game.toy_feedback()
	game.pause_game()
	game._process(20.0)
	check(game.toy_feedback() == feedback, "Pause freezes toy and its feedback")
	check(game.toy_play_pose() == pose, "Pause freezes synchronized paw and toy movement")
	check(game.toy_visual_is_visible(), "Paused play retains the toy beneath the pause panel")
	game.resume_game()
	game.toy_time_left = 4.0
	for step in range(45):
		game.move_yumi(0.1)
	check(not game.toy_active, "Distraction expires and patrol resumes")
	check(not game.toy_visual_is_visible(), "Expired toy cannot remain visible")
	game.update_interface()
	check(game.toy_feedback()["phase"] == "inactive" and game.toy_button.text == "FARE  1/2", "Expiry removes the active feedback and restores charge count")
	check(not game.ability_label.text.contains("FAREYLE"), "Expired timer cannot linger in the ability panel")
	game.ball_active = false
	game.toggle_toy_selection()
	game.place_toy(Vector2(120, 550))
	check(game.toys_left == 0, "Second use consumes last charge")
	game.toy_active = false
	game.toggle_toy_selection()
	check(not game.toy_selecting, "No third use")
	game.start_level(2)
	check(game.toys_left == 2 and not game.toy_active and not game.toy_selecting, "Restart resets toys")
	game.toggle_toy_selection()
	game.toggle_toy_selection()
	check(not game.toy_selecting and game.toys_left == 2, "Cancel button is free")
	game.toggle_toy_selection()
	game.pause_game()
	check(game.toy_visual_is_visible(), "Paused placement retains the selection area")
	game.show_level_menu()
	check(not game.toy_visual_is_visible(), "Menu clears toy presentation")
	game.queue_free()
	print("Toy smoke: %d failures" % failures)
	quit(1 if failures else 0)
