extends SceneTree

var failures := 0
var purrs := 0

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func _initialize() -> void:
	call_deferred("run_checks")

func run_checks() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	var audio = game.game_audio
	audio.set_muted(false, false)
	audio.effect_played.connect(func(effect: String):
		if effect == "purr":
			purrs += 1)
	game.start_level(0)
	game._process(1.9)
	check(purrs == 0, "Purr does not begin abruptly")
	game._process(0.2)
	check(purrs == 1 and audio.sleep_active, "Sleeping tutorial cat purrs")
	game._process(7.4)
	check(purrs == 1, "Silence between short purrs")
	game._process(0.2)
	check(purrs == 2, "Soft purr repeats at interval")
	check(audio.purr_voice.volume_db < audio.voices[0].volume_db, "Purr is quieter than action effects")
	check(audio.purr_voice.volume_db >= -10.0, "Purr is no longer buried at minus sixteen dB")
	var pcm: PackedByteArray = audio.streams["purr"].data
	var real_part := 0.0
	var imaginary_part := 0.0
	var count := pcm.size() / 2
	for index in range(count):
		var sample := pcm.decode_s16(index * 2) / 32767.0
		var phase := TAU * 360.0 * index / 22050.0
		real_part += sample * cos(phase)
		imaginary_part += sample * sin(phase)
	var harmonic := 2.0 * sqrt(real_part * real_part + imaginary_part * imaginary_part) / count
	check(harmonic > 0.04, "Strong mid-low harmonic helps small speakers reproduce purr")
	game.progress = 4
	game._process(0.01)
	check(not audio.sleep_active and not audio.purr_voice.playing, "Waking immediately stops purr")
	var previous := purrs
	game._process(10.0)
	check(purrs == previous, "Awake cat stays silent")
	game.start_level(1)
	game._process(2.1)
	check(purrs == previous + 1, "Sleeping second-level cat also purrs")
	audio.set_muted(true, false)
	game._process(12.0)
	check(purrs == previous + 1 and not audio.sleep_active, "Muted sleeping cat stays silent")
	audio.set_muted(false, false)
	game._process(1.9)
	check(purrs == previous + 1, "Unmute starts with a gentle delay")
	game._process(0.2)
	check(purrs == previous + 2, "Unmute restores purring")
	game.show_level_menu()
	check(not audio.sleep_active and not audio.purr_voice.playing, "Menu return cuts purr")
	game.start_level(2)
	game._process(10.0)
	check(purrs == previous + 2, "Active third level never purrs")
	game.start_level(0)
	game._process(2.1)
	game.finish_game(false)
	check(not audio.sleep_active, "Loss cuts purr immediately")
	game.start_level(0)
	game._process(2.1)
	game.finish_game(true)
	check(not audio.sleep_active, "Success cuts purr before celebration")
	game.free()
	await process_frame
	print("Purr smoke: %d failures" % failures)
	quit(1 if failures else 0)
