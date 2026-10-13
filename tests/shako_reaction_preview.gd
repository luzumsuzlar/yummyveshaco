extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	DirAccess.make_dir_recursive_absolute("res://exports/shako-reaction-preview")
	for name in ["attention", "surprise-left", "surprise-right", "joy", "celebration", "shared-celebration", "paused-celebration"]:
		game.start_level(2)
		game.shot_delay = 0
		if name.begins_with("surprise"):
			game.launch_ball()
			game.yumi_position.x = 120 if name.ends_with("left") else 420
			game.ball_position = game.yumi_position + Vector2(20, 0)
			game.deflect_ball_from_yumi()
		elif name == "joy":
			game.shako_joy_left = 0.25
		elif name.contains("celebration"):
			game.finish_game(true)
			game._process(0.8 if name == "celebration" else 1.8)
			if name.begins_with("paused"): game.pause_game()
		game.update_interface()
		game.queue_redraw()
		await process_frame
		await RenderingServer.frame_post_draw
		if root.get_texture().get_image().save_png("res://exports/shako-reaction-preview/%s.png" % name) != OK:
			quit(1)
			return
	game.free()
	print("Seven Shako/shared celebration previews saved")
	quit()
