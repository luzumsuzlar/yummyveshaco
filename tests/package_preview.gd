extends SceneTree

# Run this external script with --main-pack to avoid falling back to source assets.
var failures := 0

func _initialize() -> void:
	call_deferred("verify_pack")

func verify_pack() -> void:
	var output := "D:/Works/kedikopek/exports/package-preview"
	DirAccess.make_dir_recursive_absolute(output)
	if ResourceLoader.exists("res://tests/art_smoke.gd"):
		push_error("Pack check must not see source-only test resources")
		quit(1)
		return
	var scene = load("res://scenes/main.tscn")
	if scene == null:
		quit(1)
		return
	var game = scene.instantiate()
	root.add_child(game)
	game.set_process(false)
	if game.game_progress.persistence_enabled or game.game_audio.persistence_enabled:
		push_error("Pack preview must not read/write real player settings")
		game.free()
		quit(1)
		return
	for level in range(4):
		game.start_level(level)
		if game.hole_positions.size() != 3 or game.KITCHEN_BACKGROUND.get_width() < 500:
			failures += 1
		await capture(game, output + "/level-%d.png" % (level + 1))
	game.pause_game()
	await capture(game, output + "/paused.png")
	game.resume_game()
	game.show_level_menu()
	await capture(game, output + "/menu.png")
	game.free()
	print("Exported pack checks: %d failures" % failures)
	quit(1 if failures else 0)

func capture(game: Node2D, path: String) -> void:
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png(path) != OK:
		failures += 1
