extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	DirAccess.make_dir_recursive_absolute("res://exports/paw-preview")
	game.start_level(2)
	game.yumi_position = Vector2(270, 510)
	game.yumi_warning_timer = 0.03
	await save_preview(game, "prepare")
	game.yumi_warning_timer = 0
	game.yumi_swipe_flash = 0.32
	game.paw_impact_position = Vector2(365, 500)
	await save_preview(game, "ball-hit-right")
	game.yumi_direction = -1.0
	game.paw_impact_position = Vector2(175, 500)
	await save_preview(game, "ball-hit-left")
	game.start_level(3)
	game.yumi_position = Vector2(270, 335)
	game.paw_target_index = 1
	game.paw_impact_position = Vector2(270, 250)
	game.scatter_state = "scatter"
	game.scatter_timer = 2.17
	await save_preview(game, "target-hit")
	game.scatter_timer = 1.78
	await save_preview(game, "recovery")
	game.free()
	quit()

func save_preview(game: Node2D, name: String) -> void:
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png("res://exports/paw-preview/%s.png" % name) != OK:
		quit(1)
