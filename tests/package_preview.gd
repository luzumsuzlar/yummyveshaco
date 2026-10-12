extends SceneTree

# Run this external script with --main-pack to avoid falling back to source assets.
var failures := 0
var output := "D:/Works/kedikopek/exports/package-preview"
var expected_levels := 0

func _initialize() -> void:
	call_deferred("verify_pack")

func verify_pack() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--output="):
			output = argument.trim_prefix("--output=")
		elif argument.begins_with("--expected-levels="):
			expected_levels = argument.trim_prefix("--expected-levels=").to_int()
	# This external helper must never write into the source tree or user profile.
	output = output.replace("\\", "/").simplify_path()
	if not output.begins_with("D:/Works/kedikopek/exports/"):
		push_error("Pack preview output must be inside project exports")
		quit(1)
		return
	DirAccess.make_dir_recursive_absolute(output)
	if ResourceLoader.exists("res://tests/art_smoke.gd"):
		push_error("Pack check must not see source-only test resources")
		quit(1)
		return
	var packed_paths: Array[String] = []
	collect_paths("res://", packed_paths)
	for path in packed_paths:
		var lower := path.to_lower()
		if lower.begins_with("res://tests/") or lower.begins_with("res://docs/") or lower.begins_with("res://exports/") or lower.begins_with("res://sources/") or lower.ends_with(".xls") or lower.ends_with(".xlsx") or lower.ends_with(".csv") or lower.ends_with(".tsv") or lower.ends_with(".jpg") or lower.contains("sleep.jpg") or lower.contains("generated image") or lower.contains("yumi-sleep-v1"):
			failures += 1
			push_error("Excluded resource found in pack: %s" % path)
	var scene = load("res://scenes/main.tscn")
	if scene == null:
		quit(1)
		return
	var game = scene.instantiate()
	root.add_child(game)
	game.set_process(false)
	if expected_levels > 0 and game.LEVELS.size() != expected_levels:
		push_error("Pack roster does not match expected level count")
		game.free()
		quit(1)
		return
	if game.game_progress.level_count != game.LEVELS.size() or game.level_cards.size() != game.LEVELS.size():
		failures += 1
	if game.game_progress.persistence_enabled or game.game_audio.persistence_enabled:
		push_error("Pack preview must not read/write real player settings")
		game.free()
		quit(1)
		return
	for level in range(game.LEVELS.size()):
		game.start_level(level)
		if game.hole_positions.size() != 3 or game.KITCHEN_BACKGROUND.get_width() < 500:
			failures += 1
		await capture(game, output + "/level-%d.png" % (level + 1))
		if game.is_memory_level():
			game.shot_delay = 0.0
			game._process(2.6)
			if not game.memory_clue_hidden() or not game.can_launch_ball():
				failures += 1
			await capture(game, output + "/memory-hidden.png")
	game.pause_game()
	await capture(game, output + "/paused.png")
	game.resume_game()
	game.show_level_menu()
	await capture(game, output + "/menu.png")
	game.start_level(2)
	game.toggle_toy_selection()
	game.place_toy(Vector2(390, 560))
	game.move_yumi(0.3)
	game.update_interface()
	await capture(game, output + "/toy-feedback.png")
	game.free()
	print("Packed resource paths audited: %d" % packed_paths.size())
	print("Exported pack checks: %d failures" % failures)
	quit(1 if failures else 0)

func collect_paths(directory: String, paths: Array[String]) -> void:
	var access := DirAccess.open(directory)
	if access == null:
		failures += 1
		return
	access.include_hidden = true
	for file in access.get_files():
		paths.append(directory.path_join(file))
	for child in access.get_directories():
		collect_paths(directory.path_join(child), paths)

func capture(game: Node2D, path: String) -> void:
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png(path) != OK:
		failures += 1
