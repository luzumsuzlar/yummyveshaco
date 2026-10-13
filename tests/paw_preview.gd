extends SceneTree

var failures := 0

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	DirAccess.make_dir_recursive_absolute("res://exports/paw-preview")
	game.start_level(2)
	game.yumi_position = Vector2(270, 510)
	game.yumi_warning_timer = 0.03
	await save_preview(game, "prepare")
	game.yumi_warning_timer = 0
	game.yumi_swipe_flash = 0.32
	game.paw_impact_position = Vector2(365, 500)
	game.ball_active = true
	await save_preview(game, "ball-hit-right")
	await check_paused_impact(game, "ball-hit-right")
	game.yumi_direction = -1.0
	game.paw_impact_position = Vector2(175, 500)
	await save_preview(game, "ball-hit-left")
	game.start_level(3)
	game.yumi_position = Vector2(270, 335)
	game.paw_target_index = 1
	game.paw_impact_position = Vector2(270, 250)
	game.scatter_state = "scatter"
	game.scatter_timer = 2.17
	await save_preview(game, "target-hit")
	await check_paused_impact(game, "target-hit")
	game.scatter_timer = 1.78
	await save_preview(game, "recovery")
	game.free()
	print("Paw preview pause checks: %d failures" % failures)
	quit(1 if failures else 0)


func check_paused_impact(game: Node2D, name: String) -> void:
	# The target swipe is above the aim guide; the ball swipe has an active ball.
	var area := Rect2i(45, 130, 345, 190) if name == "target-hit" else Rect2i(45, 245, 345, 210)
	var before := root.get_texture().get_image().get_region(area)
	game.pause_game()
	game._process(10)
	# Hide only the modal for a diagnostic comparison of the frozen scene.
	game.pause_panel.hide()
	await save_preview(game, name + "-paused")
	var after := root.get_texture().get_image().get_region(area)
	if before.get_data() != after.get_data():
		failures += 1
		push_error("Pause changed paw impact pixels: " + name)
	game.resume_game()

func save_preview(game: Node2D, name: String) -> void:
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png("res://exports/paw-preview/%s.png" % name) != OK:
		quit(1)
