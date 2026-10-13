extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.start_level(3)
	game.shot_delay = 0
	game.update_interface()
	game.yumi_position = Vector2(270, 510)
	DirAccess.make_dir_recursive_absolute("res://exports/groom-preview")
	for variant in range(3):
		game.yumi_groom_variant = variant
		for step in range(8):
			game.yumi_groom_time = game.yumi_groom_duration() * (step + 0.1) / 8.0
			game.queue_redraw()
			await process_frame
			await RenderingServer.frame_post_draw
			if root.get_texture().get_image().save_png("res://exports/groom-preview/%d-%d.png" % [variant, step]) != OK:
				quit(1)
				return
		for boundary in ["entry", "raised", "recovery"]:
			game.yumi_groom_time = {"entry": 0.001, "raised": 0.19, "recovery": game.yumi_groom_duration() - 0.001}[boundary]
			game.queue_redraw()
			await process_frame
			await RenderingServer.frame_post_draw
			if root.get_texture().get_image().save_png("res://exports/groom-preview/%d-%s.png" % [variant, boundary]) != OK:
				quit(1)
				return
	game.free()
	print("33 grooming previews saved, including action boundaries")
	quit()
