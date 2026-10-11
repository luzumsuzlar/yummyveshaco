extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	DirAccess.make_dir_recursive_absolute("res://exports/interaction-preview")
	for cat_caused in [false, true]:
		game.start_level(2)
		game.errors = 2
		game.ball_type = game.sequence[0]
		game.ball_deflected_by_yumi = cat_caused
		game.ball_position = game.hole_positions[1]
		game.resolve_hole_hit(1)
		game.queue_redraw()
		await process_frame
		await RenderingServer.frame_post_draw
		var filename := "yumi-wrong-goal" if cat_caused else "wrong-symbol"
		if root.get_texture().get_image().save_png("res://exports/interaction-preview/%s.png" % filename) != OK:
			quit(1)
			return
	game.free()
	quit()
