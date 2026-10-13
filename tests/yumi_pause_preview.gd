extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	DirAccess.make_dir_recursive_absolute("res://exports/yumi-pause-preview")
	for role in ["sleep", "walk", "memory", "groom-entry", "groom-lick", "groom-wash", "groom-recovery"]:
		game.start_level(0 if role == "sleep" else (4 if role == "memory" else 2))
		game.shot_delay = 0
		match role:
			"sleep": game.level_time = 0.8
			"walk": game.update_yumi_walk(0.1, 8.0)
			"memory": game.memory_preview_left = 0
			_:
				game.yumi_groom_variant = 1 if role == "groom-wash" else 0
				game.yumi_groom_wait = 0
				game.update_yumi_groom(0.1)
				game.yumi_groom_time = {"groom-entry": 0.001, "groom-lick": 0.6, "groom-wash": 1.1, "groom-recovery": game.yumi_groom_duration() - 0.01}[role]
		game.update_interface()
		var before: Image
		for paused in [false, true]:
			if paused:
				game.pause_game()
				game._process(10)
				# Diagnostic image hides only the modal, not the paused game state.
				game.pause_panel.hide()
			game.queue_redraw()
			await process_frame
			await RenderingServer.frame_post_draw
			var picture := root.get_texture().get_image()
			if picture.save_png("res://exports/yumi-pause-preview/%s-%s.png" % [role, "paused" if paused else "playing"]) != OK:
				quit(1)
				return
			# Exclude the aim guide at x=216: hiding controls on pause is intentional.
			var cat := picture.get_region(Rect2i(65, 290, 145, 170))
			if not paused:
				before = cat
			elif before.get_data() != cat.get_data():
				push_error("Pause changed Yumi pixels: " + role)
				quit(1)
				return
	game.free()
	print("Seven Yumi pause roles: pixel equality passed; fourteen diagnostic images saved")
	quit()
