extends Node

var storage_path := "user://progress.cfg"
var persistence_enabled := not OS.get_cmdline_args().has("--script")
var best_times: Dictionary = {}
var completions: Dictionary = {}

func _ready() -> void:
	if persistence_enabled:
		load_progress()

func load_progress() -> void:
	best_times.clear()
	completions.clear()
	var file := ConfigFile.new()
	if file.load(storage_path) != OK:
		return
	for index in range(4):
		var section := "level_%d" % (index + 1)
		var best = file.get_value(section, "best_seconds", 0.0)
		var count = file.get_value(section, "completions", 0)
		if typeof(best) not in [TYPE_INT, TYPE_FLOAT] or typeof(count) != TYPE_INT:
			continue
		if not is_finite(float(best)) or float(best) <= 0.0 or float(best) > 86400.0 or int(count) <= 0:
			continue
		best_times[index] = float(best)
		completions[index] = mini(int(count), 1000000)

func record_completion(index: int, seconds: float) -> bool:
	if index < 0 or index >= 4 or not is_finite(seconds) or seconds <= 0.0 or seconds > 86400.0:
		return false
	var previous := float(best_times.get(index, INF))
	best_times[index] = minf(previous, seconds)
	completions[index] = mini(int(completions.get(index, 0)) + 1, 1000000)
	if persistence_enabled:
		var file := ConfigFile.new()
		for level in best_times:
			var section := "level_%d" % (int(level) + 1)
			file.set_value(section, "best_seconds", best_times[level])
			file.set_value(section, "completions", completions[level])
		var result := file.save(storage_path)
		if result != OK:
			push_warning("Bölüm kaydı diske yazılamadı: %s" % result)
	return seconds < previous

func summary(index: int) -> String:
	if not best_times.has(index):
		return "Henüz tamamlanmadı"
	return "Tamamlandı · En iyi: %.1f sn" % float(best_times[index])
