extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.start_level(0)
	DirAccess.make_dir_recursive_absolute("res://exports/yumi-rest-preview")
	var before: Image
	for name in ["inhale", "exhale", "held", "paused"]:
		game.level_time = 2.4 if name == "exhale" else 0.8
		if name == "paused":
			game.pause_game()
			game._process(10)
			game.pause_panel.hide()
		game.queue_redraw()
		await process_frame
		await RenderingServer.frame_post_draw
		var picture := root.get_texture().get_image()
		if picture.save_png("res://exports/yumi-rest-preview/%s.png" % name) != OK:
			quit(1)
			return
		var cat := picture.get_region(Rect2i(65, 290, 145, 170))
		if name == "held": before = cat
		if name == "paused" and before.get_data() != cat.get_data():
			push_error("Paused breathing pixels changed")
			quit(1)
			return
	game.free()
	print("Four sleep breathing previews saved; pause pixel equality passed")
	quit()
