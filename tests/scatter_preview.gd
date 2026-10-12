extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.start_level(3)
	game.rng.seed = 12
	game.progress = 2
	game.begin_scatter()
	DirAccess.make_dir_recursive_absolute("res://exports/scatter-preview")
	while game.scatter_state != "warning":
		game._process(1.0 / 60.0)
	await save_preview(game, "warning")
	while game.scatter_state != "scatter":
		game._process(1.0 / 60.0)
	for step in range(40):
		game._process(1.0 / 60.0)
	await save_preview(game, "bouncing")
	while game.scatter_state != "return":
		game._process(1.0 / 60.0)
	await save_preview(game, "returning")
	while game.scatter_state != "":
		game._process(1.0 / 60.0)
	await save_preview(game, "resting")
	game._process(0.3)
	await save_preview(game, "ready")
	game.free()
	quit()

func save_preview(game: Node2D, name: String) -> void:
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png("res://exports/scatter-preview/%s.png" % name) != OK:
		quit(1)
