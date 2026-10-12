extends SceneTree

class MockProfile:
	extends "res://scripts/game_progress.gd"
	var simulated_result := ERR_CANT_CREATE
	func save_progress() -> Error:
		return simulated_result

var failures := 0

func _initialize() -> void:
	call_deferred("run_checks")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func run_checks() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.game_progress.free()
	var profile := MockProfile.new()
	game.add_child(profile)
	game.game_progress = profile
	profile.level_count = game.LEVELS.size()
	profile.persistence_enabled = true
	game.start_level(3)
	game.progress = game.sequence.size()
	game.level_time = 62.4
	print("Expected simulated disk-write warning follows; no player files are touched.")
	game.finish_game(true)
	check(profile.unsaved_changes and profile.last_save_error == ERR_CANT_CREATE, "Failed save is marked as unsaved")
	check(profile.best_times[3] == 62.4 and game.game_state == "celebrating", "Failed save preserves in-memory result and game completion")
	check(game.result_notice_label.text.contains("yazılamadı") and game.overlay_subtitle.text.contains("oturumdaki"), "Result distinguishes session record from saved record")
	game.show_level_menu()
	check(game.menu_footer_label.text.contains("oturumda"), "Menu continues to disclose unsaved progress")
	game.start_level(4)
	game.progress = game.sequence.size()
	game.level_time = 58.0
	game.finish_game(true)
	check(profile.best_times.get(4) == 58.0 and profile.unsaved_changes, "Fifth completion retains its result despite simulated save failure")
	check(game.result_notice_label.text.contains("yazılamadı") and game.overlay_subtitle.text.contains("oturumdaki"), "Fifth result discloses failure without claiming a saved record")
	game._process(2.3)
	game._notification(Node.NOTIFICATION_WM_GO_BACK_REQUEST)
	check(game.menu_page == 1 and game.progress_labels[4].text.contains("58.0") and game.menu_footer_label.text.contains("oturumda"), "Second-page card and footer disclose in-session result")
	profile.simulated_result = OK
	game.start_level(0)
	game.progress = game.sequence.size()
	game.level_time = 45.0
	game.finish_game(true)
	check(not profile.unsaved_changes and profile.last_save_error == OK and game.result_notice_label.text.is_empty(), "Successful later save clears warning")
	check(profile.best_times.get(4) == 58.0, "Successful later simulated save keeps fifth result")
	game.show_level_menu()
	check(game.menu_footer_label.text == "Test sürümü · Tüm bölümler açık", "Normal menu footer returns after save succeeds")
	profile.recovered_from_backup = true
	game.show_level_menu()
	check(game.menu_footer_label.text.contains("geri yüklendi"), "Backup recovery is disclosed")
	game.free()
	print("Save notice smoke: %d failures" % failures)
	quit(1 if failures else 0)
