extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	var audio = game.game_audio
	# Validate the real desktop player flags quietly; do not touch system volume.
	for voice in audio.voices:
		voice.volume_db = -80.0
	audio.purr_voice.volume_db = -80.0
	game.start_level(0)
	game._process(2.1)
	if not audio.purr_voice.playing:
		push_error("Desktop purr player did not start")
		quit(1)
		return
	game.pause_game()
	if audio.purr_voice.playing:
		push_error("Pause did not stop desktop purr player")
		quit(1)
		return
	game.resume_game()
	DirAccess.make_dir_recursive_absolute("res://exports/audio-state")
	await save_preview(game, "sound-on")
	game.toggle_sound()
	await save_preview(game, "sound-off")
	game.toggle_sound()
	game.game_audio.play_effect("paw")
	game.finish_game(false)
	for voice in audio.voices:
		if voice.playing:
			push_error("Result did not stop desktop action player")
			quit(1)
			return
	game.free()
	print("Desktop audio state and preview checks passed")
	quit()

func save_preview(game: Node2D, name: String) -> void:
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png("res://exports/audio-state/%s.png" % name) != OK:
		quit(1)
