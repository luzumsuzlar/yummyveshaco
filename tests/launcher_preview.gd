extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	DirAccess.make_dir_recursive_absolute("res://exports/launcher-preview")
	game.start_level(0)
	game.shot_delay = 0
	for state in ["loaded", "flight", "paused-flight"]:
		if state == "flight":
			game.launch_ball()
			game.ball_position = Vector2(270, 420)
		if state == "paused-flight":
			game.pause_game()
			game.pause_panel.hide()
		game.queue_redraw()
		await process_frame
		await RenderingServer.frame_post_draw
		var picture := root.get_texture().get_image()
		if picture.save_png("res://exports/launcher-preview/%s.png" % state) != OK:
			quit(1)
			return
		if state != "loaded":
			var old_muzzle := Color("9db8cf")
			for y in range(577, 591):
				for x in range(209, 223):
					var pixel := picture.get_pixel(x, y)
					if absf(pixel.r - old_muzzle.r) < 0.02 and absf(pixel.g - old_muzzle.g) < 0.02 and absf(pixel.b - old_muzzle.b) < 0.02:
						push_error("Legacy gray muzzle still visible: " + state)
						quit(1)
						return
	game.free()
	print("Launcher previews: no legacy gray circle in flight or pause")
	quit()
