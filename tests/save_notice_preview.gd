extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.start_level(3)
	game.progress = game.sequence.size()
	game.level_time = 62.4
	game.game_progress.unsaved_changes = true
	game.finish_game(true)
	game._process(2.3)
	DirAccess.make_dir_recursive_absolute("res://exports/save-notice-preview")
	await save_preview(game, "unsaved-result")
	game.show_level_menu()
	await save_preview(game, "unsaved-menu")
	game.game_progress.unsaved_changes = false
	game.game_progress.recovered_from_backup = true
	game.show_level_menu()
	await save_preview(game, "recovered-menu")
	game.game_progress.recovered_from_backup = false
	game.start_level(4)
	game.progress = game.sequence.size()
	game.level_time = 58.0
	game.game_progress.unsaved_changes = true
	game.finish_game(true)
	game._process(2.3)
	await save_preview(game, "fifth-unsaved-result")
	game.show_level_menu()
	await save_preview(game, "fifth-unsaved-menu")
	game.free()
	quit()

func save_preview(game: Node2D, name: String) -> void:
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png("res://exports/save-notice-preview/%s.png" % name) != OK:
		quit(1)
