extends SceneTree

var failures := 0

func _initialize() -> void:
	call_deferred("run_checks")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func run_checks() -> void:
	DirAccess.make_dir_recursive_absolute("res://exports/progress-recovery")
	var path := "res://exports/progress-recovery/profile.cfg"
	# Only this test's explicit disposable fixtures; never the real user profile.
	for suffix in ["", ".tmp", ".bak", ".bak.tmp"]:
		if FileAccess.file_exists(path + suffix):
			check(DirAccess.remove_absolute(path + suffix) == OK, "Clear owned test fixture")
	var profile = load("res://scripts/game_progress.gd").new()
	profile.storage_path = path
	profile.persistence_enabled = true
	root.add_child(profile)
	profile.record_completion(0, 61.123456789)
	check(profile.last_save_error == OK, "First staged save commits")
	profile.record_completion(1, 55.7)
	check(profile.last_save_error == OK and FileAccess.file_exists(path + ".bak"), "Second save preserves previous profile")
	profile.record_completion(0, 58.0)
	profile.load_progress()
	check(profile.best_times[0] == 58.0 and profile.best_times[1] == 55.7 and not profile.recovered_from_backup, "Normal reload prefers newest intact profile")
	# A valid-looking but altered value must fail the integrity check.
	var changed := ConfigFile.new()
	changed.load(path)
	changed.set_value("level_1", "best_seconds", 1.0)
	changed.save(path)
	profile.load_progress()
	check(profile.recovered_from_backup and profile.best_times[0] == 61.123456789 and profile.best_times[1] == 55.7, "Damaged primary recovers last good backup")
	profile.record_completion(2, 42.0)
	check(profile.last_save_error == OK, "Recovered profile can save again")
	profile.load_progress()
	check(not profile.recovered_from_backup and profile.best_times[2] == 42.0, "Recovery does not repeat after successful save")
	# No commit: a stray newer temporary file is ignored at startup.
	var unfinished := ConfigFile.new()
	unfinished.set_value("level_4", "best_seconds", 2.0)
	unfinished.set_value("level_4", "completions", 100)
	unfinished.save(path + ".tmp")
	profile.load_progress()
	check(not profile.best_times.has(3) and profile.best_times.has(2), "Uncommitted temporary file cannot invent a completion")
	check(DirAccess.remove_absolute(path) == OK, "Simulate missing primary fixture")
	profile.load_progress()
	check(profile.recovered_from_backup and profile.best_times.has(1), "Missing primary recovers backup")
	# Pre-integrity prototype saves migrate without losing genuine results.
	profile.storage_path = "res://exports/progress-recovery/legacy.cfg"
	var legacy := ConfigFile.new()
	legacy.set_value("level_3", "best_seconds", 73.4)
	legacy.set_value("level_3", "completions", 2)
	legacy.save(profile.storage_path)
	profile.load_progress()
	check(profile.best_times[2] == 73.4 and profile.completions[2] == 2, "Legacy prototype format still loads")
	profile.record_completion(2, 70.0)
	profile.load_progress()
	check(profile.last_save_error == OK and profile.best_times[2] == 70.0, "Legacy profile migrates on next save")
	var intact_path: String = profile.storage_path
	profile.storage_path = "res://exports/progress-recovery/no-such-folder/profile.cfg"
	check(profile.save_progress() != OK, "Unavailable destination is reported, not called a successful save")
	profile.storage_path = intact_path
	profile.load_progress()
	check(profile.best_times[2] == 70.0, "Failed write leaves previous committed profile intact")
	profile.free()
	print("Save recovery smoke: %d failures" % failures)
	quit(1 if failures else 0)
