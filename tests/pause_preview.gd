extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.start_level(0)
	game.pause_game()
	DirAccess.make_dir_recursive_absolute("res://exports/pause-preview")
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	var result := root.get_texture().get_image().save_png("res://exports/pause-preview/paused.png")
	game.free()
	quit(0 if result == OK else 1)
