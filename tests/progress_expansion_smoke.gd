extends SceneTree

var failures := 0

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func _initialize() -> void:
	var path := "res://exports/progress-expansion/profile.cfg"
	DirAccess.make_dir_recursive_absolute("res://exports/progress-expansion")
	var profile = load("res://scripts/game_progress.gd").new()
	profile.storage_path = path
	check(not profile.persistence_enabled, "Script tests cannot touch real progress")
	var old_best := {0: 50.0, 3: 60.0}
	var old_counts := {0: 2, 3: 1}
	var old_payload := ""
	for index in range(4):
		if old_best.has(index):
			old_payload += "%d:%s:%d;" % [index, var_to_str(float(old_best[index])), int(old_counts[index])]
	check(profile.snapshot_checksum(old_best, old_counts) == old_payload.sha256_text(), "Existing four-level checksum remains identical")
	var old_file := ConfigFile.new()
	for index in old_best:
		var section := "level_%d" % (index + 1)
		old_file.set_value(section, "best_seconds", old_best[index])
		old_file.set_value(section, "completions", old_counts[index])
	old_file.set_value("meta", "format", 1)
	old_file.set_value("meta", "checksum", old_payload.sha256_text())
	check(old_file.save(path) == OK, "Own old-format fixture saved")
	profile.load_progress()
	check(profile.best_times == old_best and not profile.recovered_from_backup, "Four-level profile loads without fallback")
	check(not profile.record_completion(4, 70.0), "Default four-level build rejects new completion outside roster")
	profile.level_count = 5
	check(profile.record_completion(4, 70.0), "Five-level roster accepts fifth completion")
	check(profile.save_progress() == OK, "Expanded fixture saves and validates")
	profile.level_count = 4
	profile.load_progress()
	check(profile.best_times.get(4) == 70.0 and profile.best_times.get(0) == 50.0 and not profile.recovered_from_backup, "Older roster preserves fifth saved result and current results")
	profile.record_completion(0, 48.0)
	check(profile.save_progress() == OK, "Older roster can update visible result without losing hidden result")
	profile.level_count = 5
	profile.load_progress()
	check(profile.best_times.get(4) == 70.0 and profile.best_times.get(0) == 48.0, "Expanded roster still sees preserved results")
	profile.free()
	print("Progress expansion smoke: %d failures" % failures)
	quit(1 if failures else 0)
