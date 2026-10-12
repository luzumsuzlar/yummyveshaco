extends SceneTree

class SpyAudio:
	extends "res://scripts/game_audio.gd"
	var stop_calls := 0
	func stop_all() -> void:
		stop_calls += 1
		super.stop_all()

var failures := 0

func _initialize() -> void:
	call_deferred("run_checks")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func run_checks() -> void:
	DirAccess.make_dir_recursive_absolute("res://exports/audio-state")
	var path := "res://exports/audio-state/settings.cfg"
	var fixture := ConfigFile.new()
	fixture.set_value("audio", "muted", true)
	fixture.save(path)
	var settings_audio := SpyAudio.new()
	settings_audio.settings_path = path
	root.add_child(settings_audio)
	check(not settings_audio.persistence_enabled and not settings_audio.muted, "Script mode ignores even a muted settings fixture")
	settings_audio.set_muted(false)
	fixture.load(path)
	check(fixture.get_value("audio", "muted") == true, "Script toggle cannot overwrite preferences by default")
	settings_audio.persistence_enabled = true
	settings_audio.load_settings()
	check(settings_audio.muted, "Explicit fixture opt-in can load preferences")
	settings_audio.set_muted(false)
	fixture.load(path)
	check(fixture.get_value("audio", "muted") == false, "Explicit opt-in saves only to selected fixture")
	fixture.set_value("audio", "muted", "false")
	fixture.save(path)
	settings_audio.load_settings()
	check(not settings_audio.muted, "Invalid string preference does not become true by truthiness")
	settings_audio.free()
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.game_audio.free()
	var audio := SpyAudio.new()
	game.add_child(audio)
	game.game_audio = audio
	game.start_level(0)
	game._process(2.1)
	check(audio.sleep_active, "Sleeping cat starts purr state")
	var count := audio.stop_calls
	game.pause_game()
	check(audio.stop_calls == count + 1 and not audio.sleep_active, "Pause cuts all channels")
	game._process(5.0)
	check(not audio.sleep_active, "Paused processing cannot restart purring")
	game.resume_game()
	game._process(1.9)
	check(audio.purr_wait > 0.0, "Resume waits before new purr")
	game._process(0.2)
	check(audio.sleep_active, "Purr state resumes naturally")
	count = audio.stop_calls
	game.finish_game(false)
	check(audio.stop_calls == count + 1 and not audio.sleep_active, "Loss cuts action and purr channels")
	game.start_level(0)
	count = audio.stop_calls
	var cues: Array[String] = []
	audio.effect_played.connect(func(effect: String): cues.append(effect))
	game.finish_game(true)
	check(audio.stop_calls == count + 1 and cues == ["unlock"], "Success clears old channels before its unlock cue")
	game.show_level_menu()
	check(not audio.sleep_active, "Menu is silent")
	game.free()
	print("Audio state smoke: %d failures" % failures)
	quit(1 if failures else 0)
