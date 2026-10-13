extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.start_level(2)
	game.shot_delay = 0.0
	DirAccess.make_dir_recursive_absolute("res://exports/toy-preview")
	game.yumi_groom_wait = 0
	game.update_yumi_groom(0.01)
	game.update_yumi_groom(0.5)
	await save_preview(game, "groom-before-selection")
	game.toggle_toy_selection()
	await save_preview(game, "selection")
	game.pause_game()
	game.pause_panel.hide()
	await save_preview(game, "selection-after-groom-paused")
	game.resume_game()
	game.place_toy(Vector2(390, 560))
	game.move_yumi(0.3)
	game.update_yumi_walk(0.3, 48.6)
	await save_preview(game, "chase")
	game.yumi_position = game.toy_position - Vector2(0, 50)
	game.yumi_position.x -= 8.0
	game.move_yumi(0.1)
	game.yumi_velocity = Vector2.ZERO
	game.yumi_walk_moving = false
	game.toy_time_left = 4.0
	game.toy_play_left = 2.5
	game.update_interface()
	await save_preview(game, "arrival")
	game.toy_play_left = 2.125
	await save_preview(game, "playing")
	var before_pause: Image = root.get_texture().get_image().get_region(Rect2i(230, 410, 110, 80))
	game.pause_game()
	game._process(10.0)
	await save_preview(game, "paused-playing")
	# Hide only the modal for this diagnostic: compare the frozen toy pixels.
	game.pause_panel.hide()
	await save_preview(game, "paused-toy-diagnostic")
	var during_pause: Image = root.get_texture().get_image().get_region(Rect2i(230, 410, 110, 80))
	if before_pause.get_data() != during_pause.get_data():
		push_error("Toy image changes on pause even with the modal hidden")
		quit(1)
		return
	game.resume_game()
	game.toy_play_left = 1.875
	await save_preview(game, "paw-contact")
	game.toy_play_left = 0.7
	game.update_interface()
	await save_preview(game, "expiring")
	game.move_yumi(0.8)
	game.update_interface()
	await save_preview(game, "expired")
	game.free()
	print("Toy previews saved; paused toy pixel comparison passed")
	quit()

func save_preview(game: Node2D, name: String) -> void:
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png("res://exports/toy-preview/%s.png" % name) != OK:
		quit(1)
