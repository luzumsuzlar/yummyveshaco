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
	game.start_level(0)
	check(game.KITCHEN_BACKGROUND.get_width() > 500, "Kitchen background loads at sufficient resolution")
	check(game.KITCHEN_BACKGROUND.get_height() > game.KITCHEN_BACKGROUND.get_width(), "Kitchen background is portrait")
	check(game.yumi_art_texture() == game.YUMI_SLEEP_ART, "Tutorial binds sleeping cat art")
	check(game.YUMI_SLEEP_ART.resource_path.ends_with("yumi-sleep-v2.png"), "Sleeping cat uses curled transparent replacement")
	check(game.yumi_art_rect() == Rect2(-72, -73, 144, 144), "Curled pose uses its own ground alignment")
	game.start_level(2)
	check(game.yumi_art_texture() == game.YUMI_IDLE_ART, "Active cat binds idle art")
	var cat_center: Vector2 = game.yumi_position
	game.yumi_warning_timer = 0.4
	check(game.yumi_art_texture() == game.YUMI_PAW_ART, "Paw warning binds reaching pose")
	game.yumi_direction = -1.0
	check(game.yumi_art_texture() == game.YUMI_PAW_ART and game.yumi_position == cat_center, "Left pose leaves gameplay center unchanged")
	game.yumi_warning_timer = 0.0
	game.yumi_swipe_flash = 0.12
	check(game.yumi_art_texture() == game.YUMI_PAW_ART, "Swipe keeps reaching pose")
	game.yumi_swipe_flash = 0.0
	check(game.yumi_art_texture() == game.YUMI_IDLE_ART, "Cat returns to idle after swipe")
	check(game.SHAKO_IDLE_ART.resource_path == "res://assets/art/characters/shako-idle-v1.png", "Dog uses the prepared character asset")
	game.start_level(0)
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
