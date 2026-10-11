extends SceneTree

var failures := 0

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func _initialize() -> void:
	call_deferred("run_checks")

func run_checks() -> void:
	DirAccess.make_dir_recursive_absolute("res://exports/progress-preview")
	var path := "res://exports/progress-preview/test-progress.cfg"
	var empty := ConfigFile.new()
	empty.save(path)
	empty.save(path + ".bak")
	var profile = load("res://scripts/game_progress.gd").new()
	profile.storage_path = path
	profile.persistence_enabled = true
	root.add_child(profile)
	check(profile.best_times.is_empty(), "New profile has no completions")
	check(profile.record_completion(0, 54.2), "First completion is best")
	check(not profile.record_completion(0, 60.0), "Slower result does not replace best")
	check(profile.record_completion(0, 48.5), "Faster result replaces best")
	check(profile.completions[0] == 3 and profile.best_times[0] == 48.5, "Count and best are independent")
	profile.load_progress()
	check(profile.best_times[0] == 48.5 and profile.completions[0] == 3, "Reload preserves profile")
	check(not profile.record_completion(1, NAN) and not profile.record_completion(-1, 20) and not profile.record_completion(1, -20), "Reject invalid times and levels")
	var malformed := ConfigFile.new()
	malformed.set_value("level_2", "best_seconds", "bad")
	malformed.set_value("level_2", "completions", 3)
	profile.storage_path = "res://exports/progress-preview/invalid-progress.cfg"
	malformed.save(profile.storage_path)
	profile.load_progress()
	check(profile.best_times.is_empty(), "Bad stored values do not crash or create fake records")
	profile.free()
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	check(not game.game_progress.persistence_enabled, "Script tests never write real player progress")
	game.start_level(0)
	game.progress = game.sequence.size()
	game.level_time = 52.0
	game.finish_game(true)
	check(game.game_progress.best_times[0] == 52.0 and game.new_time_record, "True completion records time before celebration")
	game._process(2.3)
	check(game.game_progress.best_times[0] == 52.0, "Celebration does not count toward best time")
	game.show_level_menu()
	check(game.progress_labels[0].text.contains("52.0") and game.progress_labels[1].text == "Henüz tamamlanmadı", "Menu shows saved and unplayed states")
	game.start_level(1)
	game.level_time = 12
	game.finish_game(false)
	check(not game.game_progress.best_times.has(1), "Loss does not mark completion")
	game.free()
	await process_frame
	print("Progress smoke: %d failures" % failures)
	quit(1 if failures else 0)
