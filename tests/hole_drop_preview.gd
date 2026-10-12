extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.start_level(0)
	DirAccess.make_dir_recursive_absolute("res://exports/hole-drop-preview")
	await save_frame(game, "depth")
	game.ball_type = game.sequence[0]
	game.ball_position = game.hole_positions[game.ball_type] + Vector2(0, 20)
	game.resolve_hole_hit(game.ball_type)
	for phase in [0.04, 0.16, 0.28]:
		game.ball_drop_time = game.BALL_DROP_DURATION - phase
		await save_frame(game, "drop-%d" % int(phase * 100))
	game.free()
	quit()

func save_frame(game: Node2D, name: String) -> void:
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png("res://exports/hole-drop-preview/%s.png" % name) != OK:
		quit(1)
