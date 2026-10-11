extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.start_level(2)
	DirAccess.make_dir_recursive_absolute("res://exports/toy-preview")
	game.toggle_toy_selection()
	await save_preview(game, "selection")
	game.place_toy(Vector2(390, 560))
	game.move_yumi(0.3)
	game.update_yumi_walk(0.3, 48.6)
	await save_preview(game, "chase")
	game.free()
	quit()

func save_preview(game: Node2D, name: String) -> void:
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png("res://exports/toy-preview/%s.png" % name) != OK:
		quit(1)
