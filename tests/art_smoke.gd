extends SceneTree

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
	check(game.KITCHEN_BACKGROUND.get_width() > 500, "Kitchen background loads at sufficient resolution")
	check(game.KITCHEN_BACKGROUND.get_height() > game.KITCHEN_BACKGROUND.get_width(), "Kitchen background is portrait")
	var cupboard: Image = game.CUPBOARD_ART.get_image()
	check(cupboard.get_pixel(0, 0).a < 0.01, "Cupboard outside silhouette stays transparent")
	check(cupboard.get_pixel(cupboard.get_width() / 2, cupboard.get_height() / 2).a > 0.95, "Cupboard middle stays opaque")
	for label in [game.level_label, game.code_label, game.time_label, game.story_label, game.status_label, game.next_label, game.ability_label]:
		check(Rect2(Vector2.ZERO, game.SCREEN_SIZE).encloses(label.get_rect()), "HUD label stays inside portrait bounds")
	var cream_luminance: float = luminance(game.CREAM)
	var ink_luminance: float = luminance(game.INK)
	check((cream_luminance + 0.05) / (ink_luminance + 0.05) > 7.0, "Neutral HUD colors have strong contrast")
	for level in range(3):
		game.start_level(level)
		check(game.hole_positions.size() == 3, "Art does not create extra gameplay targets")
		game.shot_delay = 0
		game.update_interface()
		check(not game.launch_button.disabled and game.bark_button.disabled, "Restyled controls keep original enabled states")
	game.free()
	print("Art smoke tests: %d failures" % failures)
	quit(1 if failures else 0)

func luminance(color: Color) -> float:
	var linear := color.srgb_to_linear()
	return linear.r * 0.2126 + linear.g * 0.7152 + linear.b * 0.0722
