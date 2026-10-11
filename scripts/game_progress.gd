extends Node

var storage_path := "user://progress.cfg"
var persistence_enabled := not OS.get_cmdline_args().has("--script")
var best_times: Dictionary = {}
var completions: Dictionary = {}
var recovered_from_backup := false
var last_save_error := OK
var unsaved_changes := false

func _ready() -> void:
	if persistence_enabled:
		load_progress()

func load_progress() -> void:
	best_times.clear()
	completions.clear()
	recovered_from_backup = false
	unsaved_changes = false
	last_save_error = OK
	var snapshot := read_snapshot(storage_path)
	if snapshot.is_empty() or snapshot["best"].is_empty():
		var backup := read_snapshot(storage_path + ".bak")
		if not backup.is_empty() and not backup["best"].is_empty():
			snapshot = backup
			recovered_from_backup = true
	if not snapshot.is_empty():
		best_times = snapshot["best"]
		completions = snapshot["counts"]


func read_snapshot(path: String) -> Dictionary:
	var file := ConfigFile.new()
	if file.load(path) != OK:
		return {}
	var best_values: Dictionary = {}
	var count_values: Dictionary = {}
	for index in range(4):
		var section := "level_%d" % (index + 1)
		var best = file.get_value(section, "best_seconds", 0.0)
		var count = file.get_value(section, "completions", 0)
		if typeof(best) not in [TYPE_INT, TYPE_FLOAT] or typeof(count) != TYPE_INT:
			continue
		if not is_finite(float(best)) or float(best) <= 0.0 or float(best) > 86400.0 or int(count) <= 0:
			continue
		best_values[index] = float(best)
		count_values[index] = mini(int(count), 1000000)
	# Older prototype files have no metadata and remain readable. New saves
	# carry an integrity check so even syntactically valid partial data is rejected.
	if file.has_section("meta"):
		if file.get_value("meta", "format", 0) != 1 or file.get_value("meta", "checksum", "") != snapshot_checksum(best_values, count_values):
			return {}
	return {"best": best_values, "counts": count_values}


func snapshot_checksum(best_values: Dictionary, count_values: Dictionary) -> String:
	var payload := ""
	for index in range(4):
		if best_values.has(index):
			payload += "%d:%s:%d;" % [index, var_to_str(float(best_values[index])), int(count_values[index])]
	return payload.sha256_text()


func save_progress() -> Error:
	var file := ConfigFile.new()
	for level in best_times:
		var section := "level_%d" % (int(level) + 1)
		file.set_value(section, "best_seconds", best_times[level])
		file.set_value(section, "completions", completions[level])
	file.set_value("meta", "format", 1)
	file.set_value("meta", "checksum", snapshot_checksum(best_times, completions))
	var temporary := storage_path + ".tmp"
	var result := file.save(temporary)
	if result != OK:
		return result
	if read_snapshot(temporary).is_empty():
		return ERR_FILE_CORRUPT
	var previous := read_snapshot(storage_path)
	if not previous.is_empty() and not previous["best"].is_empty():
		# Preserve the old backup until its replacement is fully copied.
		var backup_temporary := storage_path + ".bak.tmp"
		result = DirAccess.copy_absolute(storage_path, backup_temporary)
		if result != OK:
			return result
		result = DirAccess.rename_absolute(backup_temporary, storage_path + ".bak")
		if result != OK:
			return result
	# Same-directory rename avoids truncating the live profile during writing.
	return DirAccess.rename_absolute(temporary, storage_path)

func record_completion(index: int, seconds: float) -> bool:
	if index < 0 or index >= 4 or not is_finite(seconds) or seconds <= 0.0 or seconds > 86400.0:
		return false
	var previous := float(best_times.get(index, INF))
	best_times[index] = minf(previous, seconds)
	completions[index] = mini(int(completions.get(index, 0)) + 1, 1000000)
	if persistence_enabled:
		last_save_error = save_progress()
		unsaved_changes = last_save_error != OK
		if last_save_error == OK:
			recovered_from_backup = false
		if last_save_error != OK:
			push_warning("Bölüm kaydı diske yazılamadı: %s" % last_save_error)
	return seconds < previous


func storage_notice() -> String:
	if unsaved_changes:
		return "Kayıt yazılamadı · Sadece bu oturumda"
	if recovered_from_backup:
		return "Önceki sağlam kayıt geri yüklendi"
	return ""

func summary(index: int) -> String:
	if not best_times.has(index):
		return "Henüz tamamlanmadı"
	return "Tamamlandı · En iyi: %.1f sn" % float(best_times[index])
