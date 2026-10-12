extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	DirAccess.make_dir_recursive_absolute("res://exports/memory-preview")
	game.start_level(4)
	game.shot_delay = 0.0
	game.update_interface()
	await save_preview(game, "visible")
	game._process(2.6)
	await save_preview(game, "hidden")
	game.pause_game()
	await save_preview(game, "paused")
	game.resume_game()
	game.show_level_menu()
	await save_preview(game, "fifth-menu")
	game.free()
	quit()

func save_preview(game: Node2D, name: String) -> void:
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png("res://exports/memory-preview/%s.png" % name) != OK:
		quit(1)
