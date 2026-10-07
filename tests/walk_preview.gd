extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.start_level(2)
	game.yumi_position = Vector2(270, 510)
	game.yumi_walk_moving = true
	game.yumi_warning_timer = 0
	game.yumi_swipe_flash = 0
	game.update_interface()
	DirAccess.make_dir_recursive_absolute("res://exports/walk-preview")
	for direction in [1.0, -1.0]:
		game.yumi_direction = direction
		for frame in range(6):
			game.yumi_walk_phase = frame
			game.queue_redraw()
			await process_frame
			await RenderingServer.frame_post_draw
			var name := "right" if direction > 0 else "left"
			if root.get_texture().get_image().save_png("res://exports/walk-preview/%s-%d.png" % [name, frame]) != OK:
				quit(1)
				return
	game.free()
	print("Twelve walk frame previews saved")
	quit()
