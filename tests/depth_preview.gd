extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	DirAccess.make_dir_recursive_absolute("res://exports/depth-preview")
	for level in range(3):
		game.start_level(level)
		game.shot_delay = 0
		game.aim_angle = 0.68 if level == 1 else -0.22
		game.update_interface()
		game.queue_redraw()
		await process_frame
		await RenderingServer.frame_post_draw
		var result := root.get_texture().get_image().save_png("res://exports/depth-preview/level-%d.png" % (level + 1))
		if result != OK:
			push_error("Preview could not be saved")
			quit(1)
			return
	game.ball_active = true
	game.ball_position = Vector2(330, 420)
	game.yumi_warning_timer = 0.4
	game.update_interface()
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png("res://exports/depth-preview/flight.png") != OK:
		quit(1)
		return
	game.start_level(0)
	game.game_state = "celebrating"
	game.celebration_time = 1.0
	game.celebration_shako_position = Vector2(320, 550)
	game.yumi_position = Vector2(200, 530)
	game.update_interface()
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png("res://exports/depth-preview/celebration.png") != OK:
		quit(1)
		return
	print("Depth previews saved")
	quit()
