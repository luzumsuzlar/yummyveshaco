extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	DirAccess.make_dir_recursive_absolute("res://exports/menu-preview")
	game.game_progress.record_completion(0, 64.3)
	game.show_level_menu()
	await save_preview(game, "level-menu")
	game.start_level(2)
	await save_preview(game, "navigation")
	game.finish_game(false)
	await save_preview(game, "loss-navigation")
	game.free()
	quit()

func save_preview(game: Node2D, name: String) -> void:
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png("res://exports/menu-preview/%s.png" % name) != OK:
		quit(1)
