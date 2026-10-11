extends SceneTree

# Runs with a real desktop audio driver, not --headless.
func _initialize() -> void:
	call_deferred("run_checks")

func run_checks() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("Run this check with a real desktop display/audio driver")
		quit(1)
		return
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.game_audio.set_muted(false, false)
	game.start_level(0)
	game._process(2.05)
	await create_timer(0.05).timeout
	if not game.game_audio.purr_voice.playing:
		push_error("Sleeping Yumi did not start real audio playback")
		quit(1)
		return
	game.progress = 4
	game._process(0.01)
	if game.game_audio.purr_voice.playing:
		push_error("Purr continued after waking")
		quit(1)
		return
	game.free()
	await create_timer(0.1).timeout
	print("Purr desktop playback: start and immediate stop verified")
	quit()
