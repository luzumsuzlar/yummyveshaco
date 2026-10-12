extends SceneTree

var failures := 0
var events: Array[String] = []

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
	DirAccess.make_dir_recursive_absolute("res://exports/audio-preview")
	audio.settings_path = "res://exports/audio-preview/test-settings.cfg"
	check(not audio.persistence_enabled, "Script mode does not read or write real sound preferences")
	audio.persistence_enabled = true
	audio.set_muted(false, false)
	game.update_sound_button()
	audio.effect_played.connect(func(effect: String): events.append(effect))
	check(audio.streams.size() == 5 and audio.voices.size() == 6 and audio.purr_voice != null, "Five cues with separate soft purr channel")
	for effect in audio.streams:
		var stream: AudioStreamWAV = audio.streams[effect]
		check(stream.mix_rate == 22050 and stream.format == AudioStreamWAV.FORMAT_16_BITS, "Portable 16-bit PCM format")
		check(stream.data.size() > 3000 and stream.get_length() < 1.0, "Short nonempty effect")
		var peak := 0
		for index in range(0, stream.data.size(), 2):
			peak = maxi(peak, absi(stream.data.decode_s16(index)))
		check(peak > 1000 and peak < 22000, "Audible data without clipping")
		check(stream.data == audio.synthesize(effect).data, "Synthesis is deterministic and isolated from game RNG")
		check(stream.save_to_wav("res://exports/audio-preview/%s.wav" % effect) == OK, "Cue can be exported for listening")
	game.start_level(0)
	game.shot_delay = 0.0
	game.launch_ball()
	check(events == ["launch"], "Valid launch plays once")
	game.launch_ball()
	check(events.size() == 1, "Rejected launch stays silent")
	game.start_level(1)
	game.ball_active = true
	game.ball_position = Vector2(game.WALL_RIGHT - 1, 500)
	game.ball_velocity = Vector2(300, -300)
	game.advance_ball_segment(0.02)
	check(events.back() == "bounce", "Wall contact triggers bounce sound")
	game.deflect_ball_from_yumi()
	check(events.back() == "paw", "Ball swipe triggers paw sound")
	game.start_level(3)
	game.scatter_state = "warning"
	game.scatter_contact = Vector2(270, 335)
	game.scatter_timer = 0.01
	game.update_scatter(0.02)
	check(events.back() == "paw", "Target swipe triggers paw sound")
	var count_before := events.size()
	game.update_scatter(0.02)
	check(events.size() == count_before, "Scatter does not spam paw every frame")
	game.start_level(0)
	game.finish_game(true)
	check(events.back() == "unlock", "Win plays unlocking cue")
	game.start_level(0)
	game.toggle_sound()
	check(audio.muted and game.sound_button.text == "SES: KAPALI", "Mute button updates state and text")
	for voice in audio.voices:
		check(not voice.playing, "Mute stops active voices")
	count_before = events.size()
	game.shot_delay = 0
	game.launch_ball()
	check(events.size() == count_before and game.ball_active, "Muted game remains playable")
	var reloaded = game.GAME_AUDIO.new()
	reloaded.settings_path = audio.settings_path
	reloaded.persistence_enabled = true
	root.add_child(reloaded)
	check(reloaded.muted, "Mute setting survives reopening")
	reloaded.free()
	game.toggle_sound()
	check(not audio.muted and events.back() == "bounce", "Unmute gives a short feedback cue")
	game.show_level_menu()
	check(game.sound_button.visible and Rect2(Vector2.ZERO, game.SCREEN_SIZE).encloses(game.sound_button.get_rect()), "Menu exposes sound toggle inside bounds")
	game.free()
	await process_frame
	print("Audio smoke: %d failures" % failures)
	quit(1 if failures else 0)
