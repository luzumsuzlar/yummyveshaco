extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	DirAccess.make_dir_recursive_absolute("res://exports/tutorial-preview")
	game.start_level(0)
	game.tutorial_touch_mode = true
	game.update_interface()
	await save_preview(game, "aim")
	game.tutorial_aim_done = true
	game.progress = 4
	game.tutorial_bark_time = 9
	game.ball_active = true
	game.ball_position = Vector2(230, 600)
	game.bark_available = true
	game.yumi_warning_timer = 0.4
	game.update_interface()
	await save_preview(game, "bark")
	game.start_level(2)
	await save_preview(game, "toy")
	game.toggle_toy_selection()
	await save_preview(game, "toy-place")
	game.free()
	quit()

func save_preview(game: Node2D, name: String) -> void:
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png("res://exports/tutorial-preview/%s.png" % name) != OK:
		quit(1)
