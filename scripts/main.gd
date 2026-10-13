extends Node2D

const SCREEN_SIZE := Vector2(540.0, 960.0)
const HOLE_Y := 250.0
const HOLE_RADIUS := 48.0
const HOLE_BASE_X := [116.0, 270.0, 424.0]
const LAUNCH_POS := Vector2(270.0, 790.0)
const BALL_RADIUS := 18.0
const BALL_DROP_DURATION := 0.44
const YUMI_HOME := Vector2(180.0, 510.0)
const YUMI_MIN_X := 100.0
const YUMI_MAX_X := 440.0
const AIM_AREA := Rect2(24, 172, 492, 686)
const TOUCH_AIM_RADIANS_PER_PIXEL := 0.0045
const WALL_LEFT := 24.0 + BALL_RADIUS
const WALL_RIGHT := SCREEN_SIZE.x - 24.0 - BALL_RADIUS
const GOAL_LINE := HOLE_Y + 14.0
const TYPE_NAMES := ["BALIK", "PATİ", "YUMAK"]
const TYPE_SYMBOLS := ["◆", "●", "✦"]
const TYPE_COLORS := [Color("57d9ff"), Color("ff8b74"), Color("b98cff")]
const TYPE_DARK := [Color("146582"), Color("833b36"), Color("563a84")]
const INK := Color("54321f")
const CREAM := Color("fff0d2")
const KITCHEN_BACKGROUND := preload("res://assets/art/kitchen-background-v1.png")
const CUPBOARD_ART := preload("res://assets/art/cupboard-v1.png")
const YUMI_IDLE_ART := preload("res://assets/art/characters/yumi-idle-v1.png")
const YUMI_SLEEP_ART := preload("res://assets/art/characters/yumi-sleep-v2.png")
const YUMI_PAW_ART := preload("res://assets/art/characters/yumi-paw-v1.png")
const YUMI_WALK_ART := preload("res://assets/art/characters/yumi-walk-v1.png")
const YUMI_GROOM_ART := preload("res://assets/art/characters/yumi-groom-v1.png")
const SHAKO_REACTION_ART := preload("res://assets/art/characters/shako-reactions-v1.png")
const SHAKO_REACTION_ANCHORS := [Vector2(256, 495), Vector2(256, 495), Vector2(265, 495), Vector2(245, 480), Vector2(264, 480), Vector2(274, 480)]
const YUMI_GROOM_ANCHORS := [Vector2(250, 498), Vector2(235, 498), Vector2(250, 498), Vector2(242, 465), Vector2(244, 465), Vector2(251, 466)]
const YUMI_WALK_ANCHORS := [Vector2(280, 476), Vector2(266, 480), Vector2(254, 480), Vector2(274, 444), Vector2(252, 448), Vector2(258, 452)]
const SHAKO_IDLE_ART := preload("res://assets/art/characters/shako-idle-v1.png")
const TOY_AREA := Rect2(100, 498, 340, 124)
const SCATTER_BOUNDS := Rect2(82, 242, 376, 170)
const TARGET_SPACING := 112.0
const GAME_AUDIO := preload("res://scripts/game_audio.gd")
const GAME_PROGRESS := preload("res://scripts/game_progress.gd")
const MENU_CARDS_PER_PAGE := 4

const LEVELS := [
	{
		"name": "1 · MAMA DOLABI",
		"menu_description": "Nişan al, kilidi çöz. Yumi uyanıyor!",
		"sequence": [0, 1, 2, 0, 2, 0, 1, 2, 1, 2, 0, 1],
		"stage_size": 4,
		"bark_budget": 3,
		"ball_speed": 420.0,
		"warning_time": 0.42,
		"yumi_speed": 72.0,
		"yumi_active": false,
		"move_directions": 2,
		"turn_min": 2.4,
		"turn_max": 3.6,
		"vertical_range": 0.0,
		"pause_chance": 0.04,
		"dash_chance": 0.0,
		"deflection_range": 120.0,
		"moving_holes": false,
		"intro": "Mama dolabını aç! İlk 4 atışta Yumi uyukluyor.",
	},
	{
		"name": "2 · DUVAR OYUNU",
		"menu_description": "Duvarlardan sektirerek hedefe ulaş.",
		"sequence": [0, 2, 1, 0, 1, 2, 0, 2, 2, 0, 1, 2],
		"stage_size": 4,
		"max_wall_bounces": 2,
		"aim_limit": 1.12,
		"warning_time": 0.40,
		"ball_speed": 460.0,
		"yumi_speed": 100.0,
		"yumi_active": true,
		"move_directions": 4,
		"turn_min": 0.9,
		"turn_max": 1.8,
		"vertical_range": 42.0,
		"pause_chance": 0.09,
		"dash_chance": 0.04,
		"deflection_range": 220.0,
		"moving_holes": false,
		"intro": "Duvarı kullan! İlk 4 hedefe en az 1 sekmeyle ulaş. Yumi uyuyor.",
	},
	{
		"name": "3 · KAYAN KİLİT",
		"menu_description": "Kayan hedefler ve oyuncak fare.",
		"toy_budget": 2,
		"sequence": [0, 2, 1, 0, 2],
		"yumi_speed": 162.0,
		"yumi_active": true,
		"move_directions": 8,
		"turn_min": 0.45,
		"turn_max": 1.15,
		"vertical_range": 62.0,
		"pause_chance": 0.14,
		"dash_chance": 0.16,
		"deflection_range": 360.0,
		"moving_holes": true,
		"intro": "FARE'ye bas, işaretli alana bırak: Yumi oyalanırken atış yap!",
	},
	{
		"name": "4 · YUMİ'NİN YARAMAZLIĞI",
		"menu_description": "Yumi hedefleri dağıtır.\nYeni düzene nişan al.",
		"sequence": [0, 1, 2, 0, 2, 1, 0, 2],
		"yumi_speed": 115.0,
		"yumi_active": true,
		"move_directions": 4,
		"turn_min": 1.0,
		"turn_max": 1.8,
		"vertical_range": 42.0,
		"pause_chance": 0.08,
		"dash_chance": 0.0,
		"deflection_range": 220.0,
		"moving_holes": false,
		"scatter_targets": true,
		"intro": "Yumi hedeflere göz dikti! Karışınca durmalarını bekle, yeni düzene nişan al.",
	},
	{
		"name": "5 · GİZLİ ŞİFRE",
		"menu_description": "Yumi şifreyi kapatır.\nSembolü hatırla, deliği hedefle.",
		"sequence": [0, 2, 1, 1, 0, 2, 0, 1],
		"memory_preview": 2.5,
		"ball_speed": 460.0,
		"yumi_speed": 72.0,
		"yumi_active": false,
		"move_directions": 2,
		"turn_min": 2.4,
		"turn_max": 3.6,
		"vertical_range": 0.0,
		"pause_chance": 0.0,
		"dash_chance": 0.0,
		"deflection_range": 120.0,
		"moving_holes": false,
		"intro": "Sembolü hatırla! Yumi 2,5 saniye sonra kapatır; nişan ve atış serbest.",
	},
]

var rng := RandomNumberGenerator.new()
var hole_positions: Array[Vector2] = []
var sequence: Array[int] = []
var level_index := 0
var level_time := 0.0
var memory_preview_left := 0.0
var progress := 0
var stage_index := 0
var stage_rotation := 0.0
var stage_from_positions: Array[Vector2] = []
var errors := 0
var last_error_message := ""
var game_state := "playing"

var aim_angle := 0.0
var last_pointer_position := Vector2(270.0, HOLE_Y)
var active_touch_index := -1
var touch_can_launch := false
var touch_start_position := Vector2.ZERO
var touch_start_angle := 0.0
var ball_active := false
var ball_position := LAUNCH_POS
var ball_velocity := Vector2.ZERO
var ball_type := 0
var ball_drop_time := 0.0
var ball_drop_hole := -1
var ball_drop_type := 0
var ball_drop_offset := Vector2.ZERO
var ball_swatted := false
var ball_deflected_by_yumi := false
var shot_delay := 0.0
var wall_bounces := 0
var wall_flash := 0.0
var wall_flash_position := Vector2.ZERO

var bark_available := false
var barks_left := 0
var yumi_help_count := 0
var celebration_time := 0.0
var celebration_yumi_start := Vector2.ZERO
var celebration_shako_position := LAUNCH_POS + Vector2(0, 18)
var bark_flash := 0.0
var bark_target_x := 270.0
var toys_left := 0
var toy_selecting := false
var toy_touch_index := -1
var toy_active := false
var toy_position := Vector2.ZERO
var toy_time_left := 0.0
var toy_play_left := 0.0
var scatter_state := ""
var scatter_timer := 0.0
var scatter_count := 0
var scatter_velocities: Array[Vector2] = []
var scatter_wall_hits := 0
var scatter_contact := Vector2.ZERO

var yumi_position := YUMI_HOME
var yumi_direction := 1.0
var yumi_speed := 100.0
var yumi_velocity := Vector2.RIGHT
var yumi_walk_phase := 0.0
var yumi_walk_moving := false
var yumi_groom_time := 0.0
var yumi_groom_wait := 3.5
var yumi_groom_variant := 0
var shako_surprise_left := 0.0
var shako_joy_left := 0.0
var shako_look_direction := 1.0
var yumi_move_timer := 0.0
var yumi_pause_timer := 0.0
var yumi_dash_timer := 0.0
var yumi_warning_timer := 0.0
var yumi_warning_started := false
var yumi_swipe_flash := 0.0
var paw_impact_position := Vector2.ZERO
var paw_target_index := -1
var status_flash := 0.0

var title_label: Label
var level_label: Label
var code_label: Label
var status_label: Label
var instruction_label: Label
var next_label: Label
var ability_label: Label
var time_label: Label
var story_label: Label
var overlay: ColorRect
var overlay_title: Label
var overlay_subtitle: Label
var result_notice_label: Label
var menu_footer_label: Label
var overlay_button: Button
var launch_button: Button
var bark_button: Button
var restart_button: Button
var toy_button: Button
var level_menu: ColorRect
var menu_button: Button
var level_cards: Array[Button] = []
var menu_page := 0
var menu_previous_button: Button
var menu_next_button: Button
var menu_page_label: Label
var menu_characters: Array[TextureRect] = []
var game_audio: Node
var sound_button: Button
var tutorial_label: Label
var tutorial_aim_done := false
var tutorial_bark_done := false
var tutorial_toy_done := false
var tutorial_bark_time := 0.0
var tutorial_touch_mode := OS.has_feature("android") or OS.has_feature("ios")
var pause_button: Button
var pause_panel: ColorRect
var paused_from_state := "playing"
var game_progress: Node
var progress_labels: Array[Label] = []
var new_time_record := false


func _ready() -> void:
	game_audio = GAME_AUDIO.new()
	add_child(game_audio)
	game_progress = GAME_PROGRESS.new()
	game_progress.level_count = LEVELS.size()
	add_child(game_progress)
	rng.randomize()
	for x_position in HOLE_BASE_X:
		hole_positions.append(Vector2(float(x_position), HOLE_Y))
	build_interface()
	var initial_level := 0
	var direct_start := false
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--level="):
			direct_start = true
			initial_level = clampi(argument.trim_prefix("--level=").to_int() - 1, 0, LEVELS.size() - 1)
	start_level(initial_level)
	if not direct_start:
		show_level_menu()
	queue_redraw()


func build_interface() -> void:
	title_label = make_label("YUMI & ŞAKO", 28, Color("874719"), Vector2(84, 24), Vector2(354, 40))
	title_label.add_theme_color_override("font_shadow_color", CREAM)
	title_label.add_theme_constant_override("shadow_offset_x", 2)
	title_label.add_theme_constant_override("shadow_offset_y", 3)

	level_label = make_label("", 17, INK, Vector2(28, 76), Vector2(306, 30))
	level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	code_label = make_label("", 18, INK, Vector2(28, 114), Vector2(404, 34))
	time_label = make_label("", 15, INK, Vector2(358, 76), Vector2(154, 30))
	status_label = make_label("", 19, INK, Vector2(28, 638), Vector2(484, 72))
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	next_label = make_label("", 17, INK, Vector2(28, 778), Vector2(156, 64))
	ability_label = make_label("", 15, INK, Vector2(354, 778), Vector2(162, 64))
	ability_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	story_label = make_label("", 15, INK, Vector2(28, 154), Vector2(484, 26))
	instruction_label = make_label(
		"Sürükle, bırak: atış · HAV!: müdahale",
		14,
		INK,
		Vector2(24, 940),
		Vector2(492, 18)
	)
	launch_button = make_action_button("AT!", Vector2(28, 870), Vector2(224, 64), Color("c7eef1"))
	launch_button.pressed.connect(launch_ball)
	bark_button = make_action_button("HAV!  3/3", Vector2(288, 870), Vector2(224, 64), Color("ffe3a4"))
	bark_button.pressed.connect(func(): use_bark(last_pointer_position.x))
	toy_button = make_action_button("FARE  2/2", Vector2(200, 870), Vector2(140, 64), Color("d8c7ef"))
	toy_button.add_theme_font_size_override("font_size", 19)
	toy_button.pressed.connect(toggle_toy_selection)
	restart_button = make_action_button("↻", Vector2(456, 24), Vector2(56, 48), CREAM)
	restart_button.pressed.connect(func(): start_level(level_index))
	menu_button = make_action_button("≡", Vector2(24, 24), Vector2(52, 48), CREAM)
	menu_button.pressed.connect(show_level_menu)

	overlay = ColorRect.new()
	overlay.position = Vector2.ZERO
	overlay.size = SCREEN_SIZE
	overlay.color = Color(0.12, 0.055, 0.025, 0.90)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.z_index = 20
	add_child(overlay)

	overlay_title = make_label("", 32, Color("fff3cf"), Vector2(30, 290), Vector2(480, 100), overlay)
	overlay_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	overlay_subtitle = make_label("", 20, Color("d8e9ff"), Vector2(40, 408), Vector2(460, 210), overlay)
	overlay_subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result_notice_label = make_label("", 14, Color("ffe3a4"), Vector2(40, 624), Vector2(460, 28), overlay)
	overlay_button = Button.new()
	overlay_button.text = "TEKRAR DENE"
	overlay_button.position = Vector2(100, 662)
	overlay_button.size = Vector2(340, 70)
	overlay_button.add_theme_font_size_override("font_size", 20)
	overlay_button.add_theme_color_override("font_color", Color("16233d"))
	overlay_button.add_theme_color_override("font_hover_color", Color("16233d"))
	overlay_button.add_theme_stylebox_override("normal", button_style(Color("ffcf5a")))
	overlay_button.add_theme_stylebox_override("hover", button_style(Color("ffe18e")))
	overlay_button.add_theme_stylebox_override("pressed", button_style(Color("eab746")))
	overlay_button.pressed.connect(on_overlay_button_pressed)
	overlay.add_child(overlay_button)
	var result_menu_button := make_action_button("BÖLÜMLER", Vector2(100, 766), Vector2(340, 64), CREAM)
	result_menu_button.reparent(overlay, false)
	result_menu_button.pressed.connect(show_level_menu)
	overlay.hide()
	build_level_menu()
	sound_button = make_action_button("", Vector2(398, 160), Vector2(112, 48), CREAM)
	sound_button.z_index = 40
	sound_button.add_theme_font_size_override("font_size", 16)
	sound_button.pressed.connect(toggle_sound)
	tutorial_label = make_label("", 14, INK, Vector2(34, 719), Vector2(172, 46), self, true)
	build_pause_interface()
	update_sound_button()


func toggle_sound() -> void:
	game_audio.set_muted(not game_audio.muted)
	update_sound_button()
	if not game_audio.muted:
		game_audio.play_effect("bounce")


func update_sound_button() -> void:
	sound_button.text = "SES: KAPALI" if game_audio.muted else "SES: AÇIK"
	sound_button.position = Vector2(398, 160) if game_state == "menu" else Vector2(398, 714)
	sound_button.visible = game_state in ["menu", "playing"]
	if is_instance_valid(pause_button):
		pause_button.visible = game_state == "playing"


func build_pause_interface() -> void:
	pause_button = make_action_button("II", Vector2(334, 714), Vector2(56, 48), CREAM)
	pause_button.pressed.connect(pause_game)
	pause_panel = ColorRect.new()
	pause_panel.size = SCREEN_SIZE
	pause_panel.color = Color(0.15, 0.08, 0.04, 0.87)
	pause_panel.z_index = 50
	pause_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(pause_panel)
	make_label("MOLA ZAMANI", 32, CREAM, Vector2(30, 286), Vector2(480, 60), pause_panel)
	make_label("Top ve süre durdu.\nHazır olduğunda devam et.", 21, CREAM, Vector2(40, 370), Vector2(460, 80), pause_panel)
	var resume_button := make_action_button("DEVAM ET", Vector2(100, 488), Vector2(340, 64), Color("c7eef1"))
	resume_button.reparent(pause_panel, false)
	resume_button.pressed.connect(resume_game)
	var retry_button := make_action_button("BÖLÜMÜ YENİDEN BAŞLAT", Vector2(100, 576), Vector2(340, 64), CREAM)
	retry_button.add_theme_font_size_override("font_size", 18)
	retry_button.reparent(pause_panel, false)
	retry_button.pressed.connect(func(): start_level(level_index))
	var back_button := make_action_button("BÖLÜMLER", Vector2(100, 664), Vector2(340, 64), CREAM)
	back_button.reparent(pause_panel, false)
	back_button.pressed.connect(show_level_menu)
	make_label("Bölümlere dönmek bu denemeyi kapatır.", 15, CREAM, Vector2(24, 756), Vector2(492, 32), pause_panel)
	pause_panel.hide()


func pause_game() -> void:
	if game_state not in ["playing", "celebrating"]:
		return
	paused_from_state = game_state
	game_state = "paused"
	active_touch_index = -1
	touch_can_launch = false
	toy_touch_index = -1
	game_audio.stop_all()
	tutorial_label.hide()
	pause_panel.show()
	update_sound_button()
	queue_redraw()


func resume_game() -> void:
	if game_state != "paused":
		return
	game_state = paused_from_state
	pause_panel.hide()
	update_interface()
	update_sound_button()
	queue_redraw()


func _notification(what: int) -> void:
	if not is_instance_valid(pause_panel):
		return
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_APPLICATION_PAUSED:
		pause_game()
	elif what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if game_state == "paused":
			resume_game()
		elif game_state in ["playing", "celebrating"]:
			pause_game()
		elif game_state in ["success", "failed"]:
			show_level_menu()


func build_level_menu() -> void:
	level_menu = ColorRect.new()
	level_menu.size = SCREEN_SIZE
	level_menu.color = Color(1.0, 0.94, 0.82, 0.94)
	level_menu.z_index = 30
	level_menu.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(level_menu)
	make_label("YUMI & ŞAKO", 38, Color("874719"), Vector2(24, 48), Vector2(492, 60), level_menu)
	make_label("Hangi yaramazlığa hazırsın?", 22, INK, Vector2(24, 116), Vector2(492, 38), level_menu)
	make_label("BÖLÜM SEÇ", 17, Color("8e6544"), Vector2(24, 172), Vector2(300, 28), level_menu)
	for index in range(LEVELS.size()):
		add_level_menu_card(index, LEVELS[index])
	for item in [[YUMI_IDLE_ART, 158.0], [SHAKO_IDLE_ART, 282.0]]:
		var character := TextureRect.new()
		character.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		character.texture = item[0]
		character.position = Vector2(item[1], 824)
		character.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		character.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		character.size = Vector2(100, 100)
		character.mouse_filter = Control.MOUSE_FILTER_IGNORE
		level_menu.add_child(character)
		menu_characters.append(character)
	menu_previous_button = make_action_button("‹ ÖNCEKİ", Vector2(22, 838), Vector2(162, 64), CREAM)
	menu_previous_button.reparent(level_menu, false)
	menu_previous_button.pressed.connect(change_menu_page.bind(-1))
	menu_next_button = make_action_button("SONRAKİ ›", Vector2(356, 838), Vector2(162, 64), CREAM)
	menu_next_button.reparent(level_menu, false)
	menu_next_button.pressed.connect(change_menu_page.bind(1))
	menu_page_label = make_label("", 18, INK, Vector2(188, 838), Vector2(164, 64), level_menu)
	menu_footer_label = make_label("Test sürümü · Tüm bölümler açık", 15, INK, Vector2(24, 926), Vector2(492, 24), level_menu)
	layout_level_menu_cards()


func add_level_menu_card(index: int, level_data: Dictionary) -> Button:
	var card := make_action_button("", Vector2.ZERO, Vector2(496, 132), CREAM)
	card.reparent(level_menu, false)
	card.pressed.connect(start_level.bind(index))
	level_cards.append(card)
	var thumbnail := Control.new()
	thumbnail.position = Vector2(14, 16)
	thumbnail.size = Vector2(112, 100)
	thumbnail.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(thumbnail)
	thumbnail.draw.connect(draw_level_thumbnail.bind(thumbnail, index))
	var name_label := make_label(str(level_data["name"]), 18, INK, Vector2(142, 12), Vector2(332, 32), card, true)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	var description := make_label(str(level_data.get("menu_description", "Kilidi çöz, yeni yaramazlığı keşfet.")), 16, Color("856044"), Vector2(142, 48), Vector2(324, 49), card, true)
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	var progress_text := make_label("", 14, Color("856044"), Vector2(142, 105), Vector2(324, 23), card)
	progress_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	progress_labels.append(progress_text)
	return card


func layout_level_menu_cards() -> void:
	var page_count := maxi(1, ceili(float(level_cards.size()) / MENU_CARDS_PER_PAGE))
	menu_page = clampi(menu_page, 0, page_count - 1)
	for index in range(level_cards.size()):
		var on_page := index / MENU_CARDS_PER_PAGE == menu_page
		level_cards[index].position = Vector2(22, 218 + (index % MENU_CARDS_PER_PAGE) * 150)
		level_cards[index].visible = on_page
		level_cards[index].disabled = not on_page
	var paginated := page_count > 1
	menu_previous_button.visible = paginated
	menu_next_button.visible = paginated
	menu_page_label.visible = paginated
	menu_previous_button.disabled = menu_page == 0
	menu_next_button.disabled = menu_page == page_count - 1
	menu_page_label.text = "%d / %d" % [menu_page + 1, page_count]
	for character in menu_characters:
		character.visible = not paginated


func change_menu_page(direction: int) -> void:
	if game_state != "menu":
		return
	menu_page += direction
	layout_level_menu_cards()


func draw_level_thumbnail(canvas: Control, index: int) -> void:
	canvas.draw_style_box(rounded_box(Color("ecd4af"), 10), Rect2(Vector2.ZERO, canvas.size))
	var locations := [Vector2(22, 24), Vector2(56, 24), Vector2(90, 24)]
	if index == 3:
		locations = [Vector2(23, 23), Vector2(56, 43), Vector2(90, 29)]
	for target in range(3):
		canvas.draw_circle(locations[target], 12, TYPE_COLORS[target])
		canvas.draw_circle(locations[target], 8, INK)
	if index == 1:
		canvas.draw_line(Vector2(5, 12), Vector2(5, 92), Color("bd8139"), 3)
		canvas.draw_line(Vector2(107, 12), Vector2(107, 92), Color("bd8139"), 3)
		canvas.draw_polyline(PackedVector2Array([Vector2(56, 92), Vector2(5, 57), Vector2(90, 24)]), Color("24616b"), 2, true)
	elif index == 2:
		canvas.draw_line(Vector2(12, 44), Vector2(100, 44), Color("9a70b8"), 2)
		canvas.draw_circle(Vector2(91, 81), 7, Color("9a70b8"))
		canvas.draw_arc(Vector2(81, 81), 6, 0, PI, 12, Color("9a70b8"), 2, true)
	canvas.draw_texture_rect(YUMI_SLEEP_ART if index == 0 else YUMI_PAW_ART, Rect2(29, 48, 54, 50), false)


func show_level_menu() -> void:
	shako_surprise_left = 0.0
	shako_joy_left = 0.0
	yumi_groom_time = 0.0
	ball_drop_time = 0.0
	ball_drop_hole = -1
	pause_panel.hide()
	game_audio.stop_all()
	game_state = "menu"
	ball_active = false
	bark_available = false
	active_touch_index = -1
	touch_can_launch = false
	toy_touch_index = -1
	toy_selecting = false
	toy_active = false
	scatter_state = ""
	yumi_warning_timer = 0.0
	yumi_swipe_flash = 0.0
	yumi_walk_moving = false
	for control in [title_label, level_label, code_label, status_label, instruction_label, next_label, ability_label, time_label, story_label, launch_button, bark_button, toy_button, restart_button, menu_button, overlay]:
		control.hide()
	level_menu.show()
	menu_page = level_index / MENU_CARDS_PER_PAGE
	layout_level_menu_cards()
	for index in range(progress_labels.size()):
		progress_labels[index].text = game_progress.summary(index)
		progress_labels[index].add_theme_color_override("font_color", Color("2c6838") if game_progress.best_times.has(index) else Color("856044"))
	var storage_notice: String = game_progress.storage_notice()
	menu_footer_label.text = storage_notice if not storage_notice.is_empty() else "Test sürümü · Tüm bölümler açık"
	menu_footer_label.add_theme_color_override("font_color", Color("a03125") if game_progress.unsaved_changes else INK)
	tutorial_label.hide()
	update_sound_button()
	queue_redraw()


func make_action_button(text: String, position: Vector2, size: Vector2, color: Color) -> Button:
	var button := Button.new()
	button.text = text
	button.position = position
	button.size = size
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 22)
	button.add_theme_color_override("font_color", INK)
	button.add_theme_color_override("font_hover_color", INK)
	button.add_theme_color_override("font_pressed_color", INK)
	button.add_theme_color_override("font_disabled_color", Color("856d53"))
	button.add_theme_stylebox_override("normal", button_style(color))
	button.add_theme_stylebox_override("hover", button_style(color.lightened(0.15)))
	button.add_theme_stylebox_override("pressed", button_style(color.darkened(0.12)))
	button.add_theme_stylebox_override("disabled", button_style(Color("dac5a3")))
	add_child(button)
	return button


func make_label(text: String, font_size: int, color: Color, position: Vector2, size: Vector2, parent: Node = self, wrap: bool = false) -> Label:
	var label := Label.new()
	if wrap:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.text = text
	label.position = position
	label.size = size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label


func button_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color("b78047")
	style.set_border_width_all(2)
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	style.shadow_color = Color(0.24, 0.12, 0.04, 0.30)
	style.shadow_size = 4
	style.shadow_offset = Vector2(0, 4)
	return style


func level_config() -> Dictionary:
	return LEVELS[level_index]


func start_level(new_level_index: int = level_index) -> void:
	pause_panel.hide()
	game_audio.stop_all()
	level_menu.hide()
	for control in [title_label, level_label, code_label, instruction_label, time_label, story_label, restart_button, menu_button]:
		control.show()
	level_index = clampi(new_level_index, 0, LEVELS.size() - 1)
	var config := level_config()
	sequence.clear()
	for value in config["sequence"]:
		sequence.append(int(value))
	progress = 0
	stage_index = 0
	stage_rotation = 0.0
	stage_from_positions.clear()
	errors = 0
	last_error_message = ""
	level_time = 0.0
	new_time_record = false
	tutorial_aim_done = false
	tutorial_bark_done = false
	tutorial_toy_done = false
	tutorial_bark_time = 0.0
	game_state = "playing"
	memory_preview_left = float(config.get("memory_preview", 0.0))
	ball_active = false
	ball_drop_time = 0.0
	ball_drop_hole = -1
	ball_position = LAUNCH_POS
	ball_velocity = Vector2.ZERO
	ball_swatted = false
	ball_deflected_by_yumi = false
	wall_bounces = 0
	wall_flash = 0.0
	bark_available = false
	barks_left = int(config.get("bark_budget", 3))
	yumi_help_count = 0
	celebration_time = 0.0
	celebration_shako_position = LAUNCH_POS + Vector2(0, 18)
	bark_flash = 0.0
	toys_left = int(config.get("toy_budget", 0))
	toy_selecting = false
	toy_touch_index = -1
	toy_active = false
	toy_time_left = 0.0
	toy_play_left = 0.0
	scatter_state = ""
	scatter_timer = 0.0
	scatter_count = 0
	scatter_wall_hits = 0
	scatter_velocities.assign([Vector2.ZERO, Vector2.ZERO, Vector2.ZERO])
	for index in range(hole_positions.size()):
		hole_positions[index] = Vector2(HOLE_BASE_X[index], HOLE_Y)
	shot_delay = 0.35
	aim_angle = 0.0
	active_touch_index = -1
	touch_can_launch = false
	last_pointer_position = Vector2(LAUNCH_POS.x, HOLE_Y)
	yumi_position = YUMI_HOME
	shako_surprise_left = 0.0
	shako_joy_left = 0.0
	shako_look_direction = 1.0
	yumi_groom_time = 0.0
	yumi_groom_wait = 3.5
	yumi_groom_variant = 0
	yumi_walk_phase = 0.0
	yumi_walk_moving = false
	yumi_direction = 1.0
	yumi_speed = float(config["yumi_speed"])
	yumi_velocity = Vector2.RIGHT * yumi_speed
	yumi_move_timer = 0.0
	yumi_pause_timer = 0.0
	yumi_dash_timer = 0.0
	yumi_warning_timer = 0.0
	yumi_warning_started = false
	yumi_swipe_flash = 0.0
	paw_target_index = -1
	paw_impact_position = Vector2.ZERO
	choose_yumi_direction(true)
	story_label.text = "AMAÇ: MAMA DOLABINI AÇ"
	status_label.show()
	next_label.show()
	ability_label.show()
	launch_button.show()
	bark_button.show()
	status_label.text = str(config["intro"])
	status_label.add_theme_color_override("font_color", INK)
	overlay.hide()
	update_holes()
	update_interface()
	update_sound_button()
	queue_redraw()


func _process(delta: float) -> void:
	if game_state in ["playing", "celebrating"]:
		shako_surprise_left = maxf(0.0, shako_surprise_left - delta)
		shako_joy_left = maxf(0.0, shako_joy_left - delta)
	# Cosmetic only: scoring and existing shot delays are unchanged. Pause freezes it.
	if game_state not in ["paused", "menu"] and ball_drop_time > 0.0:
		ball_drop_time = maxf(0.0, ball_drop_time - delta)
		queue_redraw()
	if game_state == "celebrating":
		celebration_time += delta
		var run_fraction := smoothstep(0.0, 1.0, clampf((celebration_time - 0.5) / 1.4, 0.0, 1.0))
		yumi_position = celebration_yumi_start.lerp(Vector2(340, 430), run_fraction)
		celebration_shako_position = (LAUNCH_POS + Vector2(0, 18)).lerp(Vector2(200, 440), run_fraction)
		queue_redraw()
		if celebration_time >= 2.2:
			game_state = "success"
			overlay.show()
		return
	if game_state != "playing":
		return

	# Only ready-to-aim time consumes the clue. Pause, flight and cooldown don't.
	if can_launch_ball() and memory_preview_left > 0.0:
		memory_preview_left = maxf(0.0, memory_preview_left - delta)
		if memory_preview_left == 0.0 and memory_clue_hidden():
			status_label.text = "Yumi şifreyi kapattı! Hatırladığın deliğe atış yap."
	level_time += delta
	tutorial_bark_time = maxf(0.0, tutorial_bark_time - delta)
	stage_rotation = maxf(0.0, stage_rotation - delta)
	shot_delay = maxf(0.0, shot_delay - delta)
	status_flash = maxf(0.0, status_flash - delta)
	yumi_swipe_flash = maxf(0.0, yumi_swipe_flash - delta)
	bark_flash = maxf(0.0, bark_flash - delta)
	wall_flash = maxf(0.0, wall_flash - delta)

	var keyboard_direction := 0.0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		keyboard_direction -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		keyboard_direction += 1.0
	if keyboard_direction != 0.0 and not ball_active and not toy_selecting:
		aim_angle = clampf(aim_angle + keyboard_direction * delta * 1.35, -aim_limit(), aim_limit())
		last_pointer_position = Vector2(LAUNCH_POS.x + tan(aim_angle) * (LAUNCH_POS.y - HOLE_Y), HOLE_Y)

	update_holes()
	var previous_yumi_position := yumi_position
	update_yumi_groom(delta)
	if scatter_state != "":
		update_scatter(delta)
	elif yumi_groom_time <= 0.0:
		move_yumi(delta)
	update_yumi_walk(delta, previous_yumi_position.distance_to(yumi_position))
	if ball_active:
		move_ball(delta)
	game_audio.update_sleep(game_state == "playing" and not yumi_is_active() and not is_memory_level(), delta)
	update_interface()
	queue_redraw()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.index == toy_touch_index and not event.pressed:
		if event.canceled or not TOY_AREA.has_point(event.position) or game_state != "playing":
			toy_touch_index = -1
	# A release over a GUI button must cancel, not leave an old drag armed.
	if event is InputEventScreenTouch and event.index == active_touch_index and not event.pressed:
		if event.canceled or not AIM_AREA.has_point(event.position) or pointer_over_action_button(event.position) or game_state != "playing":
			active_touch_index = -1
			touch_can_launch = false


func pointer_over_action_button(position: Vector2) -> bool:
	# Some HUD buttons sit inside AIM_AREA. Native touch and emulated mouse
	# ordering must never turn a release over those buttons into a field shot.
	for button in [launch_button, bark_button, toy_button, restart_button, menu_button, sound_button, pause_button]:
		if is_instance_valid(button) and button.is_visible_in_tree() and button.get_global_rect().has_point(position):
			return true
	return false


func _unhandled_input(event: InputEvent) -> void:
	# GUI buttons use emulated clicks; the playfield handles native touch once.
	if event is InputEventMouse and event.device == InputEvent.DEVICE_ID_EMULATION:
		return
	if event is InputEventScreenTouch:
		handle_touch(event)
		return
	if event is InputEventScreenDrag:
		if game_state == "playing" and event.index == active_touch_index and AIM_AREA.has_point(event.position):
			if touch_can_launch and not ball_active:
				update_touch_aim(event.position)
		return
	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseMotion
		if not AIM_AREA.has_point(mouse_event.position):
			return
		last_pointer_position = mouse_event.position
		if game_state == "playing" and not ball_active and not toy_selecting:
			update_mouse_aim(last_pointer_position)
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if game_state == "paused":
			if event.keycode in [KEY_ESCAPE, KEY_P]:
				resume_game()
			return
		if game_state == "menu":
			return
		if event.keycode == KEY_P:
			pause_game()
			return
		if event.keycode == KEY_ESCAPE and not toy_selecting:
			pause_game()
			return
		if event.keycode == KEY_M or (event.keycode == KEY_ESCAPE and toy_selecting):
			toggle_toy_selection()
			return
		if event.keycode == KEY_R:
			start_level(level_index)
			return
		if event.keycode == KEY_E:
			use_bark(last_pointer_position.x)
			return
		if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
			if ball_active:
				use_bark(last_pointer_position.x)
			else:
				launch_ball()
			return

	if game_state != "playing" or not event is InputEventMouseButton:
		return
	var mouse_button := event as InputEventMouseButton
	if not mouse_button.pressed or not AIM_AREA.has_point(mouse_button.position):
		return
	last_pointer_position = mouse_button.position
	if toy_selecting:
		if mouse_button.button_index == MOUSE_BUTTON_LEFT:
			place_toy(mouse_button.position)
		return
	if mouse_button.button_index == MOUSE_BUTTON_LEFT:
		if ball_active:
			use_bark(mouse_button.position.x)
		else:
			update_mouse_aim(mouse_button.position)
			launch_ball()
	elif mouse_button.button_index == MOUSE_BUTTON_RIGHT and ball_active:
		use_bark(mouse_button.position.x)


func handle_touch(event: InputEventScreenTouch) -> void:
	if game_state != "playing":
		return
	tutorial_touch_mode = true
	if toy_selecting:
		if event.pressed and toy_touch_index == -1 and TOY_AREA.has_point(event.position):
			toy_touch_index = event.index
		elif not event.pressed and event.index == toy_touch_index:
			toy_touch_index = -1
			if not event.canceled:
				place_toy(event.position)
		return
	if event.pressed:
		if active_touch_index != -1 or not AIM_AREA.has_point(event.position) or pointer_over_action_button(event.position):
			return
		active_touch_index = event.index
		touch_can_launch = can_launch_ball()
		touch_start_position = event.position
		touch_start_angle = aim_angle
	elif event.index == active_touch_index:
		active_touch_index = -1
		var should_launch := touch_can_launch
		touch_can_launch = false
		if should_launch and not event.canceled and AIM_AREA.has_point(event.position) and not pointer_over_action_button(event.position) and not ball_active:
			update_touch_aim(event.position)
			launch_ball()


func update_touch_aim(pointer_position: Vector2) -> void:
	# Relative drag: touching elsewhere never teleports the current aim.
	var horizontal_drag := pointer_position.x - touch_start_position.x
	aim_angle = clampf(touch_start_angle + horizontal_drag * TOUCH_AIM_RADIANS_PER_PIXEL, -aim_limit(), aim_limit())
	# Bark follows the aimed ray, not the finger's screen position.
	last_pointer_position = Vector2(LAUNCH_POS.x + tan(aim_angle) * (LAUNCH_POS.y - HOLE_Y), HOLE_Y)


func update_mouse_aim(pointer_position: Vector2) -> void:
	var offset: Vector2 = pointer_position - LAUNCH_POS
	if offset.y < -20.0:
		aim_angle = clampf(atan2(offset.x, -offset.y), -aim_limit(), aim_limit())


func aim_limit() -> float:
	return float(level_config().get("aim_limit", 0.78))


func required_wall_bounces() -> int:
	if level_index != 1:
		return 0
	return 2 if stage_index == 1 else 1


func can_launch_ball() -> bool:
	return game_state == "playing" and scatter_state == "" and not toy_selecting and not ball_active and shot_delay <= 0.0 and stage_rotation <= 0.0


func launch_ball() -> void:
	if not can_launch_ball():
		return
	yumi_groom_time = 0.0
	yumi_groom_wait = 5.0
	touch_can_launch = false
	ball_type = sequence[progress]
	var direction := Vector2(sin(aim_angle), -cos(aim_angle))
	ball_position = LAUNCH_POS + direction * 50.0
	ball_velocity = direction * float(level_config().get("ball_speed", 520.0))
	ball_active = true
	tutorial_aim_done = true
	game_audio.play_effect("launch")
	ball_swatted = false
	ball_deflected_by_yumi = false
	wall_bounces = 0
	bark_available = barks_left > 0
	yumi_warning_timer = 0.0
	yumi_warning_started = false
	status_label.text = "%s topu yolda." % TYPE_NAMES[ball_type]
	if yumi_is_active() and ball_type == 2:
		status_label.text = "Yumi: O yumak benim! Ünlemi bekle, gerekirse HAV!"
	status_label.add_theme_color_override("font_color", TYPE_DARK[ball_type])


func use_bark(target_x: float) -> void:
	if game_state != "playing" or not ball_active or not bark_available:
		return
	bark_available = false
	tutorial_bark_done = true
	barks_left -= 1
	bark_flash = 0.48
	bark_target_x = clampf(target_x, 90.0, SCREEN_SIZE.x - 90.0)

	var steering_target := bark_target_x
	if level_index == 1:
		# Unfold the remaining bank route instead of canceling it with a bark.
		var banks_needed := maxi(required_wall_bounces() - wall_bounces, 0)
		var toward_right := ball_velocity.x >= 0.0
		if banks_needed == 1:
			steering_target = 2.0 * (WALL_RIGHT if toward_right else WALL_LEFT) - bark_target_x
		elif banks_needed == 2:
			steering_target += (WALL_RIGHT - WALL_LEFT) * (2.0 if toward_right else -2.0)
	var remaining_distance := maxf(ball_position.y - GOAL_LINE, 70.0)
	var upward_speed := maxf(-ball_velocity.y, 180.0 if level_index == 1 else 420.0)
	var remaining_time := maxf(remaining_distance / upward_speed, 0.18)
	var desired_x_speed := (steering_target - ball_position.x) / remaining_time
	ball_velocity.x = clampf(lerpf(ball_velocity.x, desired_x_speed, 0.82), -560.0, 560.0)
	ball_velocity.y = -upward_speed

	if yumi_warning_timer > 0.0:
		yumi_warning_timer = 0.0
		ball_swatted = true
		status_label.text = "HAV! Yumi irkildi; top yeniden yönlendirildi."
	else:
		status_label.text = "HAV! Şako topun yönünü düzeltti."
	status_label.add_theme_color_override("font_color", Color("2c6838"))


func update_holes() -> void:
	if bool(level_config().get("scatter_targets", false)):
		return
	var moving := bool(level_config()["moving_holes"])
	for index in range(hole_positions.size()):
		var offset := 0.0
		if moving:
			offset = sin(level_time * 1.18 + index * 1.65) * 22.0
		var slot := (index + stage_index) % hole_positions.size()
		var destination := Vector2(HOLE_BASE_X[slot] + offset, HOLE_Y)
		if stage_rotation > 0.0:
			var fraction := 1.0 - stage_rotation / 1.2
			var eased := smoothstep(0.0, 1.0, fraction)
			destination = stage_from_positions[index].lerp(destination, eased)
			destination.y += sin(fraction * PI) * (58.0 if index % 2 == 0 else -42.0)
		hole_positions[index] = destination


func begin_scatter() -> void:
	if not bool(level_config().get("scatter_targets", false)) or ball_active or scatter_count >= 2 or scatter_state != "":
		return
	scatter_count += 1
	scatter_state = "approach"
	scatter_contact = hole_positions[rng.randi_range(0, 2)] + Vector2(0, 85)
	active_touch_index = -1
	touch_can_launch = false
	yumi_warning_timer = 0.0
	yumi_swipe_flash = 0.0
	status_label.text = "Yumi hedeflere gidiyor... Bir yaramazlık hazırlığında!"
	update_interface()


func clamp_scatter_position(position: Vector2) -> Vector2:
	return Vector2(clampf(position.x, SCATTER_BOUNDS.position.x, SCATTER_BOUNDS.end.x), clampf(position.y, SCATTER_BOUNDS.position.y, SCATTER_BOUNDS.end.y))


func separate_scatter_targets() -> void:
	for iteration in range(40):
		for first in range(3):
			for second in range(first + 1, 3):
				var offset := hole_positions[second] - hole_positions[first]
				var distance := offset.length()
				if distance < TARGET_SPACING:
					var normal := offset / distance if distance > 0.001 else Vector2.RIGHT
					var correction := normal * (TARGET_SPACING - distance + 0.01) * 0.5
					hole_positions[first] = clamp_scatter_position(hole_positions[first] - correction)
					hole_positions[second] = clamp_scatter_position(hole_positions[second] + correction)


func scatter_physics(delta: float) -> void:
	var remaining := delta
	while remaining > 0.000001:
		var step := minf(remaining, 1.0 / 120.0)
		remaining -= step
		for index in range(3):
			var position := hole_positions[index] + scatter_velocities[index] * step
			var clamped := clamp_scatter_position(position)
			if position.x != clamped.x:
				scatter_velocities[index].x *= -0.85
				scatter_wall_hits += 1
			if position.y != clamped.y:
				scatter_velocities[index].y *= -0.85
				scatter_wall_hits += 1
			hole_positions[index] = clamped
			scatter_velocities[index] *= exp(-1.05 * step)
		for first in range(3):
			for second in range(first + 1, 3):
				var offset := hole_positions[second] - hole_positions[first]
				if offset.length() < TARGET_SPACING:
					var normal := offset.normalized() if offset.length() > 0.001 else Vector2.RIGHT
					var closing_speed := (scatter_velocities[first] - scatter_velocities[second]).dot(normal)
					if closing_speed > 0.0:
						scatter_velocities[first] -= normal * closing_speed
						scatter_velocities[second] += normal * closing_speed
		separate_scatter_targets()


func scatter_targets_accessible() -> bool:
	for target in range(3):
		var ray := hole_positions[target] - LAUNCH_POS
		for other in range(3):
			if other == target:
				continue
			var fraction := (hole_positions[other] - LAUNCH_POS).dot(ray) / ray.length_squared()
			if fraction > 0.0 and fraction < 1.0:
				if hole_positions[other].distance_to(LAUNCH_POS + ray * fraction) < HOLE_RADIUS + 8.0:
					return false
	return true


func update_scatter(delta: float) -> void:
	if scatter_state == "approach":
		if absf(scatter_contact.x - yumi_position.x) > 5.0:
			yumi_direction = signf(scatter_contact.x - yumi_position.x)
		yumi_position = yumi_position.move_toward(scatter_contact, 300.0 * delta)
		if yumi_position.distance_to(scatter_contact) < 1.0:
			scatter_state = "warning"
			scatter_timer = 0.65
			status_label.text = "! Yumi pati atacak! Hedefler birazdan karışıyor."
	elif scatter_state == "warning":
		scatter_timer -= delta
		if scatter_timer <= 0.0:
			scatter_state = "scatter"
			game_audio.play_effect("paw")
			scatter_timer = 2.2
			paw_impact_position = scatter_contact - Vector2(0, 85)
			paw_target_index = 0
			for index in range(1, 3):
				if hole_positions[index].distance_to(paw_impact_position) < hole_positions[paw_target_index].distance_to(paw_impact_position):
					paw_target_index = index
			for index in range(3):
				var angle := rng.randf_range(-PI, PI)
				scatter_velocities[index] = Vector2.from_angle(angle) * rng.randf_range(340.0, 460.0)
			status_label.text = "PAT! Hedefler duvarlardan sekiyor. Durmalarını bekle."
	elif scatter_state == "scatter":
		var step := minf(delta, maxf(scatter_timer, 0.0))
		scatter_physics(step)
		scatter_timer -= delta
		if scatter_timer <= 0.0:
			scatter_velocities.assign([Vector2.ZERO, Vector2.ZERO, Vector2.ZERO])
			separate_scatter_targets()
			# No target may hide another. Rare blocked layouts get a short safe settle.
			if not scatter_targets_accessible():
				var order := [0, 1, 2]
				order.sort_custom(func(a, b): return hole_positions[a].x < hole_positions[b].x)
				for slot in range(3):
					scatter_velocities[order[slot]] = Vector2(HOLE_BASE_X[slot], hole_positions[order[slot]].y)
				scatter_state = "settle"
			else:
				scatter_state = "return"
			status_label.text = "Hedefler yerleşiyor. Yeni düzeni incele." if scatter_state == "settle" else "Delikler durdu. Yumi geri dönüyor; atış birazdan."
	elif scatter_state == "settle":
		var complete := true
		for index in range(3):
			hole_positions[index] = hole_positions[index].move_toward(scatter_velocities[index], 240.0 * delta)
			complete = complete and hole_positions[index].is_equal_approx(scatter_velocities[index])
		if complete:
			scatter_velocities.assign([Vector2.ZERO, Vector2.ZERO, Vector2.ZERO])
			scatter_state = "return"
			status_label.text = "Delikler durdu. Yumi geri dönüyor; atış birazdan."
	elif scatter_state == "return":
		yumi_position = yumi_position.move_toward(YUMI_HOME, 300.0 * delta)
		if yumi_position.distance_to(YUMI_HOME) < 1.0:
			scatter_state = ""
			choose_yumi_direction(true)
			status_label.text = progress_hint()
			shot_delay = 0.25


func toggle_toy_selection() -> void:
	if game_state != "playing" or toys_left <= 0 or toy_active:
		return
	toy_selecting = not toy_selecting
	if toy_selecting:
		# Interrupt during input, before a pause can preserve the old idle action.
		yumi_groom_time = 0.0
		yumi_groom_wait = 3.5
	toy_touch_index = -1
	active_touch_index = -1
	touch_can_launch = false
	status_label.text = "İşaretli alanda yer seç. FARE'ye tekrar bas: vazgeç." if toy_selecting else progress_hint()
	update_interface()
	queue_redraw()


func place_toy(position: Vector2) -> void:
	if game_state != "playing" or not toy_selecting or toy_active or toys_left <= 0 or not TOY_AREA.has_point(position):
		return
	toys_left -= 1
	toy_selecting = false
	toy_touch_index = -1
	toy_active = true
	tutorial_toy_done = true
	toy_position = position
	toy_time_left = 6.0
	toy_play_left = 2.5
	yumi_warning_timer = 0.0
	yumi_warning_started = false
	yumi_swipe_flash = 0.0
	status_label.text = "Yumi fareye gidiyor! Şimdi atış fırsatı." if can_launch_ball() else ("Yumi fareye gidiyor; top uçuşta." if ball_active else "Yumi fareye gidiyor; yeni atış hazırlanıyor.")
	update_interface()
	queue_redraw()


func toy_feedback() -> Dictionary:
	# Read-only presentation of the existing travel / play timers.
	# Travel can end early on arrival, so it is not shown as a fixed countdown.
	if not toy_active:
		return {"phase": "inactive", "remaining": 0.0, "fraction": 0.0}
	var arrived := yumi_position.distance_to(toy_position - Vector2(0, 50)) <= 5.0
	if not arrived:
		return {"phase": "travel", "remaining": toy_time_left, "fraction": 1.0}
	var remaining := minf(toy_time_left, toy_play_left)
	return {"phase": "play", "remaining": remaining, "fraction": clampf(remaining / 2.5, 0.0, 1.0)}


func move_yumi(delta: float) -> void:
	if toy_active:
		var was_travelling: bool = toy_feedback()["phase"] == "travel"
		toy_time_left = maxf(0.0, toy_time_left - delta)
		# The chosen point is on the floor; Yumi's origin is above her feet.
		var destination := toy_position - Vector2(0, 50)
		var offset := destination - yumi_position
		if offset.length() > 5.0:
			yumi_velocity = offset.normalized() * yumi_speed
			yumi_position = yumi_position.move_toward(destination, yumi_speed * delta)
			if absf(offset.x) > 5.0:
				yumi_direction = signf(offset.x)
		else:
			yumi_velocity = Vector2.ZERO
			toy_play_left = maxf(0.0, toy_play_left - delta)
		if toy_time_left <= 0.0 or toy_play_left <= 0.0:
			toy_active = false
			choose_yumi_direction(true)
			status_label.text = "Yumi fareyi bıraktı, tekrar topun peşinde!"
		elif was_travelling and toy_feedback()["phase"] == "play":
			status_label.text = "Yumi fareyi yakaladı! Süre bitmeden nişan al." if can_launch_ball() else "Yumi fareyi yakaladı, bir süre oyalanacak."
		return
	if not yumi_is_active():
		yumi_velocity = Vector2.ZERO
		return
	var config := level_config()
	var movement_scale := 0.18 if yumi_warning_timer > 0.0 else 1.0

	if yumi_pause_timer > 0.0:
		yumi_pause_timer = maxf(0.0, yumi_pause_timer - delta)
		yumi_velocity = yumi_velocity.move_toward(Vector2.ZERO, yumi_speed * delta * 7.0)
		if yumi_pause_timer == 0.0:
			choose_yumi_direction(true)
	else:
		yumi_move_timer = maxf(0.0, yumi_move_timer - delta)
		var was_dashing := yumi_dash_timer > 0.0
		yumi_dash_timer = maxf(0.0, yumi_dash_timer - delta)
		if was_dashing and yumi_dash_timer == 0.0 and yumi_velocity.length() > 0.0:
			yumi_velocity = yumi_velocity.normalized() * yumi_speed
		if yumi_move_timer == 0.0:
			choose_yumi_direction()

	# Yumi wants the yarn; the first level keeps this pursuit slow and horizontal.
	if ball_active and ball_type == 2 and not ball_swatted and yumi_warning_timer <= 0.0:
		var chase_direction := ball_position - yumi_position
		if level_index == 0:
			chase_direction.y = 0.0
		if chase_direction.length() > 8.0:
			yumi_velocity = chase_direction.normalized() * yumi_speed
			yumi_pause_timer = 0.0

	yumi_position += yumi_velocity * delta * movement_scale

	var vertical_range := float(config["vertical_range"])
	var min_y := YUMI_HOME.y - vertical_range
	var max_y := YUMI_HOME.y + vertical_range
	var hit_boundary := false
	if yumi_position.x < YUMI_MIN_X:
		yumi_position.x = YUMI_MIN_X
		yumi_velocity.x = absf(yumi_velocity.x)
		hit_boundary = true
	elif yumi_position.x > YUMI_MAX_X:
		yumi_position.x = YUMI_MAX_X
		yumi_velocity.x = -absf(yumi_velocity.x)
		hit_boundary = true
	if vertical_range <= 0.0:
		yumi_position.y = YUMI_HOME.y
		yumi_velocity.y = 0.0
	elif yumi_position.y < min_y:
		yumi_position.y = min_y
		yumi_velocity.y = absf(yumi_velocity.y)
		hit_boundary = true
	elif yumi_position.y > max_y:
		yumi_position.y = max_y
		yumi_velocity.y = -absf(yumi_velocity.y)
		hit_boundary = true
	if hit_boundary:
		yumi_move_timer = minf(yumi_move_timer, 0.35)
	if absf(yumi_velocity.x) > 5.0:
		yumi_direction = signf(yumi_velocity.x)


func yumi_can_groom() -> bool:
	return game_state == "playing" and yumi_is_active() and not is_memory_level() and not ball_active and ball_drop_time <= 0.0 and scatter_state.is_empty() and stage_rotation <= 0.0 and shot_delay <= 0.0 and not toy_active and not toy_selecting and yumi_warning_timer <= 0.0 and yumi_swipe_flash <= 0.0 and bark_flash <= 0.0


func update_yumi_groom(delta: float) -> void:
	# Idle acting never consumes gameplay RNG or delays a shot. Movement resumes
	# with its existing velocity/timers as soon as a ball or another event arrives.
	if game_state == "paused":
		return
	if not yumi_can_groom():
		yumi_groom_time = 0.0
		yumi_groom_wait = 3.5
		return
	if yumi_groom_time > 0.0:
		yumi_groom_time += delta
		if yumi_groom_time >= yumi_groom_duration():
			yumi_groom_time = 0.0
			yumi_groom_variant = (yumi_groom_variant + 1) % 3
			yumi_groom_wait = 6.0 + float(yumi_groom_variant)
		return
	yumi_groom_wait = maxf(0.0, yumi_groom_wait - delta)
	if yumi_groom_wait <= 0.0:
		yumi_groom_time = 0.001


func yumi_groom_duration() -> float:
	return [2.8, 2.4, 1.2][yumi_groom_variant]


func yumi_groom_frame() -> int:
	var frames: Array = [[0, 1, 0, 1, 0, 1, 4, 5], [0, 1, 2, 3, 2, 3, 4, 5], [5, 4, 4, 5]][yumi_groom_variant]
	var fraction := clampf(yumi_groom_time / yumi_groom_duration(), 0.0, 0.999)
	return frames[int(fraction * frames.size())]


func yumi_groom_region() -> Rect2:
	var frame := yumi_groom_frame()
	var cell := Vector2(YUMI_GROOM_ART.get_width() / 3.0, YUMI_GROOM_ART.get_height() / 2.0)
	return Rect2(Vector2(frame % 3, frame / 3) * cell, cell)


func update_yumi_walk(delta: float, distance: float) -> void:
	# Visual phase follows actual travel, never changes motion or collision.
	yumi_walk_moving = game_state == "playing" and yumi_is_active() and distance > 0.001 and yumi_warning_timer <= 0.0 and yumi_swipe_flash <= 0.0
	if not yumi_walk_moving:
		yumi_walk_phase = 0.0
		return
	var visual_distance := minf(distance, maxf(delta, 0.0) * 180.0)
	yumi_walk_phase = fposmod(yumi_walk_phase + visual_distance * 6.0 / 80.0, 6.0)


func yumi_walk_frame() -> int:
	return int(floor(yumi_walk_phase)) % 6


func choose_yumi_direction(force_move: bool = false) -> void:
	var config := level_config()
	if not force_move and rng.randf() < float(config["pause_chance"]):
		yumi_pause_timer = rng.randf_range(0.18, 0.48)
		yumi_move_timer = yumi_pause_timer
		return

	var directions: Array[Vector2] = [Vector2.LEFT, Vector2.RIGHT]
	var direction_count := int(config["move_directions"])
	if direction_count >= 4:
		directions.append(Vector2.UP)
		directions.append(Vector2.DOWN)
	if direction_count >= 8:
		directions.append(Vector2(-1.0, -1.0).normalized())
		directions.append(Vector2(1.0, -1.0).normalized())
		directions.append(Vector2(-1.0, 1.0).normalized())
		directions.append(Vector2(1.0, 1.0).normalized())

	var selected := directions[rng.randi_range(0, directions.size() - 1)]
	if yumi_position.x < YUMI_MIN_X + 44.0 and selected.x < 0.0:
		selected.x = absf(selected.x)
	elif yumi_position.x > YUMI_MAX_X - 44.0 and selected.x > 0.0:
		selected.x = -absf(selected.x)
	var vertical_range := float(config["vertical_range"])
	if vertical_range > 0.0:
		if yumi_position.y < YUMI_HOME.y - vertical_range * 0.72 and selected.y < 0.0:
			selected.y = absf(selected.y)
		elif yumi_position.y > YUMI_HOME.y + vertical_range * 0.72 and selected.y > 0.0:
			selected.y = -absf(selected.y)

	var speed_multiplier := 1.0
	if rng.randf() < float(config["dash_chance"]):
		speed_multiplier = 1.48
		yumi_dash_timer = rng.randf_range(0.20, 0.34)
	yumi_velocity = selected.normalized() * yumi_speed * speed_multiplier
	yumi_move_timer = rng.randf_range(float(config["turn_min"]), float(config["turn_max"]))


func move_ball(delta: float) -> void:
	# Short steps keep warning timing and collisions stable at different FPS.
	var remaining := delta
	while remaining > 0.0 and ball_active:
		var step := minf(remaining, 1.0 / 120.0)
		advance_ball_segment(step)
		if ball_active:
			update_yumi_attack(step)
		remaining -= step


func advance_ball_segment(delta: float) -> void:
	var remaining := delta
	while remaining > 0.0 and ball_active:
		var side_time := INF
		if ball_velocity.x > 0.0:
			side_time = maxf(0.0, (WALL_RIGHT - ball_position.x) / ball_velocity.x)
		elif ball_velocity.x < 0.0:
			side_time = maxf(0.0, (WALL_LEFT - ball_position.x) / ball_velocity.x)
		var goal_time := INF
		var target_hit := -1
		if bool(level_config().get("scatter_targets", false)):
			# Sweep against each real target position, not the old fixed goal line.
			for index in range(hole_positions.size()):
				var offset := ball_position - hole_positions[index]
				var speed_squared := ball_velocity.length_squared()
				var b := offset.dot(ball_velocity)
				var c := offset.length_squared() - pow(HOLE_RADIUS - 4.0, 2)
				var discriminant := b * b - speed_squared * c
				if speed_squared > 0.0 and discriminant >= 0.0:
					var hit_time := 0.0 if c <= 0.0 else (-b - sqrt(discriminant)) / speed_squared
					if hit_time >= 0.0 and hit_time < goal_time:
						goal_time = hit_time
						target_hit = index
			if ball_velocity.y < 0.0:
				var miss_time := maxf(0.0, (184.0 - ball_position.y) / ball_velocity.y)
				if miss_time < goal_time:
					goal_time = miss_time
					target_hit = -1
		elif ball_velocity.y < 0.0:
			goal_time = maxf(0.0, (GOAL_LINE - ball_position.y) / ball_velocity.y)
		var travel_time := minf(remaining, minf(side_time, goal_time))
		ball_position += ball_velocity * travel_time
		remaining -= travel_time
		if goal_time <= side_time and goal_time <= travel_time:
			if bool(level_config().get("scatter_targets", false)) and target_hit < 0:
				register_error("Top hedefleri ıskaladı!")
			else:
				resolve_hole_hit(target_hit)
			return
		if side_time <= travel_time:
			var bounce_limit := int(level_config().get("max_wall_bounces", 0))
			if wall_bounces >= bounce_limit:
				register_error("İki sekme hakkı bitti!" if bounce_limit > 0 else "Top kilit kanalının dışına çıktı!")
				return
			wall_bounces += 1
			game_audio.play_effect("bounce")
			wall_flash = 0.28
			wall_flash_position = ball_position
			ball_velocity.x = -ball_velocity.x
			status_label.text = "TAK! Duvar sekmesi: %d/2" % wall_bounces
			status_label.add_theme_color_override("font_color", Color("865315"))
		if ball_position.y > SCREEN_SIZE.y + 40.0:
			register_error("Top oyun alanından çıktı!")
			return


func update_yumi_attack(delta: float) -> void:
	if toy_active or scatter_state != "":
		return
	if not yumi_is_active() or ball_swatted:
		return

	if yumi_warning_timer > 0.0:
		yumi_warning_timer = maxf(0.0, yumi_warning_timer - delta)
		if yumi_warning_timer == 0.0:
			if ball_position.distance_to(yumi_position) < 155.0:
				perform_yumi_swipe()
			else:
				ball_swatted = true
				status_label.text = "Yumi ıskaladı!"
				status_label.add_theme_color_override("font_color", Color("2c6838"))
		return

	if not yumi_warning_started and ball_position.distance_to(yumi_position) < 178.0:
		yumi_warning_started = true
		yumi_warning_timer = float(level_config().get("warning_time", 0.24))
		status_label.text = "Yumi hazırlanıyor! Şimdi HAV! diyebilirsin."
		status_label.add_theme_color_override("font_color", Color("865315"))


func yumi_is_active() -> bool:
	if level_index == 0:
		return progress >= 4
	if level_index == 1:
		return stage_index >= 2
	return bool(level_config()["yumi_active"])


func perform_yumi_swipe() -> void:
	deflect_ball_from_yumi()


func deflect_ball_from_yumi() -> void:
	shako_surprise_left = 0.65
	shako_joy_left = 0.0
	# Atlas looks screen-left; mirror only the reaction toward the actual cat.
	shako_look_direction = -1.0 if yumi_position.x > LAUNCH_POS.x else 1.0
	game_audio.play_effect("paw")
	paw_impact_position = ball_position
	paw_target_index = -1
	var config := level_config()
	var contact_side := signf(ball_position.x - yumi_position.x)
	if contact_side == 0.0:
		contact_side = -1.0 if rng.randf() < 0.5 else 1.0
	var deflection_range := float(config["deflection_range"])
	var target_x := ball_position.x
	target_x += contact_side * rng.randf_range(deflection_range * 0.18, deflection_range * 0.62)
	target_x += rng.randf_range(-deflection_range * 0.55, deflection_range * 0.55)
	target_x = clampf(target_x, 90.0, SCREEN_SIZE.x - 90.0)
	var target_point := Vector2(target_x, HOLE_Y - 8.0)
	var new_direction := (target_point - ball_position).normalized()
	var new_speed := clampf(ball_velocity.length() * rng.randf_range(0.92, 1.08), 420.0, 620.0)
	ball_velocity = new_direction * new_speed
	ball_swatted = true
	ball_deflected_by_yumi = true
	yumi_warning_timer = 0.0
	yumi_swipe_flash = 0.34
	status_label.text = "PAT! Top Yumi'den rastgele bir yöne sekti!"
	status_label.add_theme_color_override("font_color", Color("865315"))


func resolve_hole_hit(target_index: int = -1) -> void:
	var nearest_hole := 0
	var nearest_distance := INF
	for index in range(hole_positions.size()):
		var distance := absf(ball_position.x - hole_positions[index].x)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_hole = index
	if target_index >= 0:
		nearest_hole = target_index
		nearest_distance = 0.0

	if nearest_distance > HOLE_RADIUS - 4.0:
		register_error("Top deliği ıskaladı!")
		return

	ball_drop_hole = nearest_hole
	ball_drop_type = ball_type
	ball_drop_offset = (ball_position - hole_positions[nearest_hole]).limit_length(HOLE_RADIUS - BALL_RADIUS - 8.0)
	ball_drop_time = BALL_DROP_DURATION

	if nearest_hole == ball_type and ball_type == sequence[progress]:
		if wall_bounces < required_wall_bounces():
			register_error("Doğru delik, ama en az %d duvar sekmesi gerekiyor!" % required_wall_bounces())
			return
		var lucky_yumi_goal := ball_deflected_by_yumi
		shako_joy_left = 0.45
		shako_surprise_left = 0.0
		if lucky_yumi_goal:
			yumi_help_count += 1
		progress += 1
		memory_preview_left = float(level_config().get("memory_preview", 0.0))
		ball_active = false
		bark_available = false
		shot_delay = 0.45
		status_flash = 0.38
		if progress >= sequence.size():
			finish_game(true)
		elif bool(level_config().get("scatter_targets", false)) and progress in [2, 5]:
			begin_scatter()
		elif int(level_config().get("stage_size", 0)) > 0 and progress % int(level_config()["stage_size"]) == 0:
			stage_from_positions.assign(hole_positions)
			stage_index += 1
			stage_rotation = 1.2
			shot_delay = 1.2
			status_label.text = "TAK! Kasa dönüyor. Yeni hedef düzenini incele."
			if level_index == 0 and stage_index == 1:
				tutorial_bark_time = 9.0
				status_label.text = "Yumi uyandı! Yumağı istiyor. Ünlemde havla: %d hakkın var." % barks_left
			elif level_index == 0 and stage_index == 2:
				status_label.text = "Son kilit! Yumi'yi oku, kalan havlamalarını dikkatli kullan."
			elif level_index == 1 and stage_index == 1:
				status_label.text = "Şimdi iki duvar! Her hedefe 2 sekmeyle ulaş. Nişan çizgisini izle."
			elif level_index == 1 and stage_index == 2:
				status_label.text = "Yumi uyandı! En az 1 sekme yap; pati uyarısında HAV! kullan."
			status_label.add_theme_color_override("font_color", Color("865315"))
		else:
			status_label.text = "Yumi yanlışlıkla yardım etti! " + progress_hint() if lucky_yumi_goal else progress_hint()
			status_label.add_theme_color_override("font_color", Color("2c6838"))
	else:
		var error_message := "%s deliği! %s bekleniyordu." % [TYPE_NAMES[nearest_hole], TYPE_NAMES[sequence[progress]]]
		if ball_deflected_by_yumi:
			error_message = "Yumi %s deliğine sektirdi!\n%s bekleniyordu." % [TYPE_NAMES[nearest_hole], TYPE_NAMES[sequence[progress]]]
		register_error(error_message)


func progress_hint() -> String:
	if is_memory_level():
		return "Yeni sembolü hatırla! Yumi birazdan kapatacak."
	if bool(level_config().get("scatter_targets", false)):
		return "Yeni düzene göre %s hedefle." % TYPE_NAMES[sequence[progress]]
	if level_index == 0:
		return "Parça oturdu! Sıradaki hedef: %s." % TYPE_NAMES[sequence[progress]]
	if level_index == 1:
		return "Parça oturdu! En az %d sekme; %s hedefle." % [required_wall_bounces(), TYPE_NAMES[sequence[progress]]]
	return "Parça oturdu. Hareketli hedefin önüne nişan al."


func register_error(message: String) -> void:
	last_error_message = message
	ball_active = false
	bark_available = false
	yumi_warning_timer = 0.0
	shot_delay = 0.55
	memory_preview_left = float(level_config().get("memory_preview", 0.0))
	errors += 1
	status_flash = 0.5
	status_label.text = message
	status_label.add_theme_color_override("font_color", Color("a03125"))
	if errors >= 3:
		finish_game(false)


func finish_game(success: bool) -> void:
	if success and game_state == "playing" and progress >= sequence.size():
		new_time_record = game_progress.record_completion(level_index, level_time)
	game_audio.stop_all()
	scatter_state = ""
	toy_button.hide()
	toy_selecting = false
	toy_active = false
	toy_touch_index = -1
	active_touch_index = -1
	touch_can_launch = false
	ball_active = false
	bark_available = false
	yumi_warning_timer = 0.0
	# End-of-level states no longer tick the transient attack animation.
	yumi_swipe_flash = 0.0
	if success:
		game_audio.play_effect("unlock")
		game_state = "celebrating"
		celebration_time = 0.0
		celebration_yumi_start = yumi_position
		status_label.hide()
		next_label.hide()
		ability_label.hide()
		launch_button.hide()
		bark_button.hide()
		story_label.text = "DOLAP AÇILDI! MAMA ZAMANI!"
		overlay_title.text = "MAMA DOLABI AÇILDI!"
		overlay_title.add_theme_color_override("font_color", Color("86f7a8"))
		if yumi_help_count > 0:
			overlay_subtitle.text = "Şako: Sen de mi yardım ettin?\nYumi: Ben sadece yumağı istedim!"
			overlay_button.text = "SONRAKİ BÖLÜM" if level_index < LEVELS.size() - 1 else "BAŞA DÖN"
		elif level_index < LEVELS.size() - 1:
			overlay_subtitle.text = "%s tamamlandı. Sıradaki bölüm yeni bir kural ekliyor." % str(level_config()["name"])
			overlay_button.text = "SONRAKİ BÖLÜM"
		else:
			overlay_subtitle.text = "%d bölümlük prototip tamamlandı. Şako kilidi açtı; Yumi hâlâ masum görünüyor." % LEVELS.size()
			overlay_button.text = "BAŞA DÖN"
	else:
		game_state = "failed"
		overlay.show()
		overlay_title.text = "KİLİT SIKIŞTI!"
		overlay_title.add_theme_color_override("font_color", Color("ff746f"))
		overlay_subtitle.text = "Yumi: 😼     Şako: 😵\n" + (last_error_message if not last_error_message.is_empty() else "Aynı bölümü hemen yeniden deneyebilirsin.")
		overlay_button.text = "TEKRAR DENE"
	overlay_subtitle.text += "\nGeçen süre: %.1f saniye · Doğru atış: %d/%d" % [level_time, progress, sequence.size()]
	overlay_subtitle.text += "\nKalan havlama: %d · Yumi'nin yardımı: %d" % [barks_left, yumi_help_count]
	if success and new_time_record:
		overlay_subtitle.text += "\nBu oturumdaki en iyi süren!" if game_progress.unsaved_changes else "\nYeni en iyi süren!"
	result_notice_label.text = game_progress.storage_notice()
	update_interface()
	update_sound_button()
	queue_redraw()


func on_overlay_button_pressed() -> void:
	if game_state == "success":
		if level_index < LEVELS.size() - 1:
			start_level(level_index + 1)
		else:
			start_level(0)
	else:
		start_level(level_index)


func is_memory_level() -> bool:
	return float(level_config().get("memory_preview", 0.0)) > 0.0


func memory_clue_hidden() -> bool:
	return is_memory_level() and memory_preview_left <= 0.0 and not ball_active and progress < sequence.size()


func update_interface() -> void:
	update_tutorial()
	level_label.text = str(level_config()["name"])
	time_label.text = "SÜRE: %.1f sn" % level_time
	var code_text := "KİLİT:  "
	var stage_size := int(level_config().get("stage_size", sequence.size()))
	var stage_start := stage_index * stage_size
	if int(level_config().get("stage_size", 0)) > 0:
		code_text = "AŞAMA %d/%d:  " % [stage_index + 1, ceili(float(sequence.size()) / stage_size)]
	for index in range(stage_start, mini(stage_start + stage_size, sequence.size())):
		if index < progress:
			code_text += "✓  "
		elif index == progress and game_state == "playing":
			code_text += "[?]  " if memory_clue_hidden() else "[%s]  " % TYPE_SYMBOLS[sequence[index]]
		else:
			code_text += "?  " if is_memory_level() else "%s  " % TYPE_SYMBOLS[sequence[index]]
	code_label.text = code_text + "  %d/%d" % [progress, sequence.size()]
	launch_button.disabled = not can_launch_ball()
	toy_button.visible = int(level_config().get("toy_budget", 0)) > 0 and game_state == "playing"
	var has_toy := int(level_config().get("toy_budget", 0)) > 0
	launch_button.size.x = 148.0 if has_toy else 224.0
	bark_button.position.x = 372.0 if has_toy else 288.0
	bark_button.size.x = 140.0 if has_toy else 224.0
	toy_button.disabled = game_state != "playing" or toys_left <= 0 or toy_active
	toy_button.text = "FARE AKTİF" if toy_active else ("VAZGEÇ" if toy_selecting else "FARE  %d/2" % toys_left)
	instruction_label.text = "FARE: yer seç · Sürükle, bırak: atış" if has_toy else "Sürükle, bırak: atış · HAV!: müdahale"
	if is_memory_level():
		instruction_label.text = "Sembolü hatırla · Sürükle, bırak: atış"
	if toy_active:
		instruction_label.text = "Yumi oyalandı · Sürükle, bırak: atış"
	bark_button.disabled = game_state != "playing" or not ball_active or not bark_available
	bark_button.text = "HAV!  %d/3" % barks_left

	if game_state == "playing" and progress < sequence.size():
		if level_index == 1:
			story_label.text = "HEDEF: EN AZ %d SEKME + DOĞRU DELİK" % required_wall_bounces()
		next_label.text = "Sıradaki:\n%s  %s" % [TYPE_SYMBOLS[sequence[progress]], TYPE_NAMES[sequence[progress]]]
		next_label.add_theme_color_override("font_color", TYPE_DARK[sequence[progress]])
		if memory_clue_hidden():
			next_label.text = "Yumi kapattı:\n?  HATIRLA"
			next_label.add_theme_color_override("font_color", INK)
		if stage_rotation > 0.0:
			ability_label.text = "KASA DÖNÜYOR..."
			ability_label.add_theme_color_override("font_color", Color("865315"))
		elif toy_active:
			var feedback := toy_feedback()
			if feedback["phase"] == "travel":
				var shot_hint := "Atış hazır" if can_launch_ball() else ("Top uçuyor" if ball_active else "Atış hazırlanıyor")
				ability_label.text = "FAREYE GİDİYOR\n%s" % shot_hint
			else:
				ability_label.text = "FAREYLE OYNUYOR\n%.1f sn kaldı" % float(feedback["remaining"])
			ability_label.add_theme_color_override("font_color", Color("9c502a") if feedback["phase"] == "play" and float(feedback["remaining"]) <= 1.0 else Color("684a86"))
		elif ball_active:
			ability_label.text = "HAV! düğmesi / E" if bark_available else "Bu atışta HAV yok"
			ability_label.add_theme_color_override("font_color", Color("2c6838") if bark_available else Color("856d53"))
		else:
			ability_label.text = "Kalan HAV: %d/3" % barks_left
			ability_label.add_theme_color_override("font_color", INK)
		if level_index == 1 and stage_rotation <= 0.0:
			ability_label.text = "SEKME: %d/2\nKalan HAV: %d" % [wall_bounces if ball_active else 0, barks_left]
		if scatter_state != "":
			match scatter_state:
				"approach", "warning":
					ability_label.text = "YUMI HAZIRLANIYOR\nAtış kapalı"
				"scatter", "settle":
					ability_label.text = "DELİKLER HAREKETLİ\nDurmalarını bekle"
				"return":
					ability_label.text = "YUMI DÖNÜYOR\nAtış birazdan"
			ability_label.add_theme_color_override("font_color", Color("865315"))
		elif level_index == 3 and scatter_count > 0 and not ball_active:
			ability_label.text = "ATIŞ HAZIR\nSürükle, bırak" if can_launch_ball() else "ATIŞ HAZIRLANIYOR\nBirazdan hazır"
			ability_label.add_theme_color_override("font_color", Color("2c6838") if can_launch_ball() else Color("865315"))
		if is_memory_level() and not ball_active:
			ability_label.text = "ŞİFRE GİZLİ\nAtış serbest" if memory_clue_hidden() else "AKLINDA TUT\n%.1f sn görünür" % memory_preview_left
			ability_label.add_theme_color_override("font_color", Color("684a86"))


func tutorial_hint() -> String:
	if game_state != "playing":
		return ""
	if level_index == 0 and not tutorial_aim_done:
		return "aim"
	if level_index == 0 and yumi_is_active() and not tutorial_bark_done and barks_left > 0:
		if tutorial_bark_time > 0.0 or (yumi_warning_timer > 0.0 and bark_available):
			return "bark"
	if level_index == 2 and not tutorial_toy_done and toys_left > 0:
		return "toy_place" if toy_selecting else "toy"
	return ""


func update_tutorial() -> void:
	var hint := tutorial_hint()
	tutorial_label.visible = hint != ""
	match hint:
		"aim":
			tutorial_label.text = "Sağa–sola sürükle.\nBırakınca top gider." if tutorial_touch_mode else "Fareyle nişan al.\nTıkla veya AT!'a bas."
		"bark":
			tutorial_label.text = "Ünlem: pati geliyor!\nTop yoldayken HAV!"
		"toy":
			tutorial_label.text = "FARE ile Yumi'yi\nbaşka yere çek."
		"toy_place":
			tutorial_label.text = "Mor alana bırak.\nVazgeçmek ücretsiz."


func draw_tutorial() -> void:
	var hint := tutorial_hint()
	if hint == "":
		return
	draw_style_box(rounded_box(Color("fff4d8"), 8), Rect2(28, 714, 184, 56))
	if hint == "aim" and not ball_active:
		var center := Vector2(335, 600)
		var x := sin(level_time * 2.2) * 34.0
		draw_line(center + Vector2(-62, 0), center + Vector2(62, 0), Color("c7954a"), 3, true)
		for direction in [-1.0, 1.0]:
			var end := center + Vector2(direction * 62, 0)
			draw_line(end, end + Vector2(-direction * 10, -8), Color("c7954a"), 3, true)
			draw_line(end, end + Vector2(-direction * 10, 8), Color("c7954a"), 3, true)
		draw_circle(center + Vector2(x, 0), 12, Color("fff4d8"))
		draw_arc(center + Vector2(x, 0), 12, 0, TAU, 24, Color("94682f"), 2, true)
	if hint == "bark" and bark_available:
		draw_rect(bark_button.get_rect().grow(3), Color("e1a92d"), false, 3)
	if hint == "toy":
		draw_rect(toy_button.get_rect().grow(3), Color("9a70b8"), false, 3)


func _draw() -> void:
	if game_state == "menu":
		draw_texture_rect(KITCHEN_BACKGROUND, Rect2(Vector2.ZERO, SCREEN_SIZE), false)
		return
	draw_background()
	draw_cupboard()
	draw_lock_panel()
	draw_holes()
	draw_ground_shadows()
	draw_toy()
	draw_yumi()
	if scatter_state == "warning":
		var badge := yumi_position + Vector2(54, -54)
		draw_circle(badge, 22, Color("ffdc70"))
		draw_string(ThemeDB.fallback_font, badge + Vector2(-12, 13), "!", HORIZONTAL_ALIGNMENT_CENTER, 24, 38, INK)
	draw_shako_launcher()
	if ball_active:
		draw_ball(ball_position, ball_type)
	if bark_flash > 0.0:
		draw_bark_wave()
	if wall_flash > 0.0:
		draw_arc(wall_flash_position, 22.0 + (0.28 - wall_flash) * 90.0, 0, TAU, 24, Color(1, 0.8, 0.3, wall_flash / 0.28), 4.0, true)
	draw_tutorial()


func toy_visual_is_visible() -> bool:
	var state := paused_from_state if game_state == "paused" else game_state
	return state == "playing" and (toy_selecting or toy_active)


func toy_play_pose() -> Dictionary:
	# Cosmetic contact only: destination and distraction clocks remain unchanged.
	var playing: bool = toy_visual_is_visible() and toy_feedback()["phase"] == "play"
	var elapsed := maxf(0.0, 2.5 - toy_play_left)
	var direction := 1.0 if toy_position.x <= SCREEN_SIZE.x * 0.5 else -1.0
	var settle := smoothstep(0.0, 0.25, elapsed) if playing else 0.0
	var tap := pow(maxf(0.0, sin(elapsed * TAU * 2.0)), 2.0) if playing else 0.0
	var offset := Vector2(direction * (40.0 + tap * 6.0), -14.0 - tap * 2.0) * settle
	return {"playing": playing, "direction": direction, "tap": tap, "position": toy_position + offset}


func draw_toy() -> void:
	# Pause freezes the scene; it must not erase an active toy underneath the modal.
	if not toy_visual_is_visible():
		return
	if toy_selecting:
		draw_rect(TOY_AREA, Color(0.7, 0.5, 0.95, 0.16))
		draw_rect(TOY_AREA, Color("9a70b8"), false, 3.0)
	if not toy_active:
		return
	var p: Vector2 = toy_play_pose()["position"]
	draw_soft_shadow(p + Vector2(3, 9), Vector2(22, 6), 0.25)
	draw_arc(p + Vector2(-22, 0), 15, -0.6, 2.3, 16, Color("9873a6"), 3, true)
	draw_set_transform(p, 0.0, Vector2(22, 13))
	draw_circle(Vector2.ZERO, 1.0, Color("cab4d8"))
	draw_set_transform(Vector2.ZERO)
	draw_circle(p + Vector2(10, -10), 7, Color("e8c6d8"))
	draw_circle(p + Vector2(16, -2), 2, INK)
	draw_circle(p + Vector2(23, 3), 3, Color("c87992"))
	var feedback := toy_feedback()
	draw_arc(p, 32, 0, TAU, 32, Color(0.6, 0.4, 0.75, 0.25), 2, true)
	if feedback["phase"] == "play":
		var ring_color := Color("d78538") if float(feedback["remaining"]) <= 1.0 else Color("9a70b8")
		draw_arc(p, 32, -PI / 2, -PI / 2 + TAU * float(feedback["fraction"]), 40, ring_color, 4, true)
	else:
		# Attention pulse, not a misleading six-second promise.
		draw_arc(p, 32 + sin(level_time * 6.0) * 2.0, 0, TAU, 32, Color("9a70b8"), 3, true)


func celebration_visual_active() -> bool:
	return game_state in ["celebrating", "success"] or (game_state == "paused" and paused_from_state == "celebrating")


func shared_celebration_pose() -> Dictionary:
	var together := smoothstep(1.45, 1.95, celebration_time) if celebration_visual_active() else 0.0
	var nod := sin(clampf((celebration_time - 1.45) / 0.75, 0.0, 1.0) * PI) * together
	return {"together": together, "nod": nod, "opening": smoothstep(0.0, 0.4, celebration_time)}


func draw_cupboard() -> void:
	# Shallow extrusion and floor contact; target coordinates stay unchanged.
	draw_soft_shadow(Vector2(274, 343), Vector2(225, 14), 0.20)
	draw_colored_polygon(PackedVector2Array([Vector2(496, 194), Vector2(513, 202), Vector2(513, 340), Vector2(496, 332)]), Color("765039"))
	draw_colored_polygon(PackedVector2Array([Vector2(44, 326), Vector2(496, 326), Vector2(508, 342), Vector2(56, 342)]), Color("875a39"))
	draw_texture_rect(CUPBOARD_ART, Rect2(32, 184, 476, 158), false)
	if celebration_visual_active():
		var opening: float = shared_celebration_pose()["opening"]
		# Warm reveal behind the bowl, using the existing celebration clock.
		for layer in range(3):
			draw_style_box(rounded_box(Color(1.0, 0.78, 0.28, 0.05 * opening), 24), Rect2(142 - layer * 8, 392 - layer * 8, 256 + layer * 16, 118 + layer * 16))
		draw_rect(Rect2(154, 400, 232, 102), Color("2c211e"))
		draw_rect(Rect2(154 - opening * 50, 400, 46, 102), Color("75513a"))
		draw_rect(Rect2(340 + opening * 50, 400, 46, 102), Color("75513a"))
		draw_colored_polygon(PackedVector2Array([Vector2(236, 465), Vector2(304, 465), Vector2(293, 491), Vector2(247, 491)]), Color("ffcf5a"))
		for crumb in range(5):
			draw_circle(Vector2(244 + crumb * 12, 465), 6, Color("a76f45"))
		var together: float = shared_celebration_pose()["together"]
		for index in range(3):
			var star := Vector2(242 + index * 28, 448 - sin(index * 1.8) * 10 - together * 12)
			var color := Color(1.0, 0.9, 0.5, together * 0.8)
			draw_line(star - Vector2(4, 0), star + Vector2(4, 0), color, 2, true)
			draw_line(star - Vector2(0, 5), star + Vector2(0, 5), color, 2, true)


func draw_background() -> void:
	draw_texture_rect(KITCHEN_BACKGROUND, Rect2(Vector2.ZERO, SCREEN_SIZE), false)
	draw_style_box(button_style(CREAM), Rect2(18, 20, 432, 48))
	draw_style_box(rounded_box(CREAM, 10), Rect2(24, 156, 492, 26))
	if game_state == "playing":
		draw_style_box(button_style(CREAM), Rect2(24, 636, 492, 76))
		draw_style_box(button_style(CREAM), Rect2(28, 778, 156, 64))
		draw_style_box(button_style(CREAM), Rect2(354, 778, 162, 64))
	draw_style_box(rounded_box(CREAM, 8), Rect2(24, 938, 492, 22))
	var wall_color := Color("e9bb5c") if level_index == 1 else Color("a06a3d")
	for x in [24.0, 516.0]:
		draw_line(Vector2(x, 184), Vector2(x, 858), INK, 7.0)
		draw_line(Vector2(x, 184), Vector2(x, 858), wall_color, 3.0)


func draw_lock_panel() -> void:
	var panel_color := CREAM
	if status_flash > 0.0:
		panel_color = Color("fff8e8") if errors < 3 else Color("f4b8a4")
	draw_style_box(button_style(panel_color), Rect2(18, 70, 504, 84))
	for index in range(3):
		var warning_color := Color("bb3830") if index < errors else Color("c5ae89")
		draw_circle(Vector2(454 + index * 22, 130), 6.0, warning_color)


func hole_visual_position(index: int) -> Vector2:
	var center := hole_positions[index]
	if yumi_visual_state() == "playing" and scatter_state == "scatter" and index == paw_target_index:
		var impact := float(yumi_paw_motion()["impact"])
		center += Vector2(sin((2.2 - scatter_timer) * 90.0) * 5.0, cos((2.2 - scatter_timer) * 75.0) * 3.0) * impact
	return center


func draw_holes() -> void:
	var font := ThemeDB.fallback_font
	for index in range(hole_positions.size()):
		var center := hole_visual_position(index)
		draw_soft_shadow(center + Vector2(3, 7), Vector2(HOLE_RADIUS + 8, HOLE_RADIUS + 5), 0.22)
		draw_circle(center, HOLE_RADIUS + 5.0, TYPE_COLORS[index])
		draw_circle(center, HOLE_RADIUS - 5.0, TYPE_DARK[index])
		# Offset, nested cavity shading makes a recessed tunnel without new textures.
		draw_circle(center + Vector2(0, 2), HOLE_RADIUS - 9.0, Color("38251d"))
		for depth in range(7):
			var fraction := float(depth) / 6.0
			draw_circle(center + Vector2(1, 3 + fraction * 5), HOLE_RADIUS - 12.0 - fraction * 12.0, Color("302019").lerp(Color("090909"), fraction))
		if ball_drop_time > 0.0 and ball_drop_hole == index:
			draw_ball_drop(center)
		# Inner upper lip is dark; the lower lip catches light from upper left.
		draw_arc(center + Vector2(0, 3), HOLE_RADIUS - 9.0, PI, TAU, 32, Color("130f0d"), 5.0, true)
		draw_arc(center, HOLE_RADIUS - 6.0, 0.15, PI - 0.15, 32, TYPE_DARK[index].lightened(0.25), 3.0, true)
		draw_arc(center, HOLE_RADIUS + 2.0, 0.1, PI - 0.1, 32, TYPE_DARK[index], 4.0, true)
		draw_arc(center, HOLE_RADIUS + 2.0, PI, TAU, 32, TYPE_COLORS[index].lightened(0.45), 3.0, true)
		var badge := center + Vector2(0, -48)
		draw_circle(badge + Vector2(0, 3), 21, Color("8e572f"))
		draw_circle(badge, 20, CREAM)
		draw_type_icon(badge, index, 14, TYPE_DARK[index])
		draw_style_box(rounded_box(CREAM, 7), Rect2(center + Vector2(-52, 60), Vector2(104, 24)))
		draw_string(font, center + Vector2(-52, 78), TYPE_NAMES[index], HORIZONTAL_ALIGNMENT_CENTER, 104, 15, INK)


func draw_soft_shadow(center: Vector2, radii: Vector2, opacity: float) -> void:
	# Nested ellipses approximate a soft contact shadow without extra textures.
	for layer in range(4):
		var scale_factor := 1.0 - float(layer) * 0.15
		var points := PackedVector2Array()
		for point in range(32):
			var angle := TAU * float(point) / 32.0
			points.append(center + Vector2(cos(angle), sin(angle)) * radii * scale_factor)
		draw_colored_polygon(points, Color(0.20, 0.12, 0.07, opacity * 0.32))


func draw_ground_shadows() -> void:
	var cat_shadow_radii := Vector2(58, 10) if yumi_art_texture() in [YUMI_SLEEP_ART, YUMI_WALK_ART] else Vector2(44, 12)
	draw_soft_shadow(yumi_position + Vector2(7, 57), cat_shadow_radii, 0.30)
	var shako_head := shako_visual_position()
	draw_soft_shadow(shako_head + Vector2(6, 31), Vector2(40, 11), 0.30)
	if ball_active:
		draw_soft_shadow(ball_position + Vector2(6, 12), Vector2(21, 9), 0.28)


func yumi_paw_motion() -> Dictionary:
	var toy_pose := toy_play_pose()
	if toy_pose["playing"] and yumi_warning_timer <= 0.0 and yumi_swipe_flash <= 0.0 and scatter_state.is_empty():
		return {"arm": Vector2(-8, 4 + float(toy_pose["tap"]) * 8), "shift": Vector2.ZERO, "angle": 0.0, "impact": 0.0, "big": false}
	# Render-only motion: no collision center, warning deadline or ball velocity changes.
	var big_swipe := scatter_state == "warning" or scatter_state == "scatter"
	var duration := 0.48 if big_swipe else 0.34
	var remaining := maxf(0.0, scatter_timer - 1.72) if scatter_state == "scatter" else yumi_swipe_flash
	var impact := clampf(remaining / duration, 0.0, 1.0)
	var warning := scatter_timer if scatter_state == "warning" else yumi_warning_timer
	var warning_duration := 0.65 if scatter_state == "warning" else float(level_config().get("warning_time", 0.24))
	var preparation := clampf(1.0 - warning / warning_duration, 0.0, 1.0) if warning > 0.0 else 0.0
	var force := impact * impact
	var arm := Vector2(-10, -14) * preparation
	var shift := Vector2(-6, 2) * preparation
	var angle := -0.08 * preparation
	if impact > 0.0:
		arm = (Vector2(26, -20) if big_swipe else Vector2(24, -14)) * force
		shift = (Vector2(4, -28) if big_swipe else Vector2(15, -3)) * force
		angle = (-0.16 if big_swipe else 0.12) * force
	return {"arm": arm, "shift": shift, "angle": angle, "impact": impact, "big": big_swipe}


func draw_animated_paw(rect: Rect2, arm_offset: Vector2) -> void:
	# Deform only the raised foreleg of the existing texture; no duplicate paw.
	var divisions := 12
	for row in range(divisions):
		for column in range(divisions):
			var points := PackedVector2Array()
			var uvs := PackedVector2Array()
			for corner in [Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1)]:
				var uv: Vector2 = (Vector2(column, row) + corner) / float(divisions)
				var right_weight := smoothstep(0.70, 0.90, uv.x)
				var vertical_weight := smoothstep(0.32, 0.60, uv.y) * (1.0 - smoothstep(0.70, 0.95, uv.y))
				points.append(rect.position + uv * rect.size + arm_offset * right_weight * vertical_weight)
				uvs.append(uv)
			draw_polygon(points, PackedColorArray([Color.WHITE]), uvs, YUMI_PAW_ART)


func draw_paw_impact(motion: Dictionary) -> void:
	var impact := float(motion["impact"])
	if impact <= 0.0 or yumi_visual_state() != "playing":
		return
	var point := paw_impact_position
	var radius := (42.0 if motion["big"] else 25.0) * (1.5 - impact * 0.5)
	var color := Color(1.0, 0.79, 0.32, impact)
	draw_arc(point, radius, 0, TAU, 28, color, 3.5, true)
	for ray in range(7):
		var direction := Vector2.from_angle(TAU * ray / 7.0)
		draw_line(point + direction * radius * 0.7, point + direction * radius * 1.25, color, 4.0, true)
	var local_paw := Vector2(48, 21) + Vector2(motion["arm"])
	var swipe_start := yumi_position + Vector2(local_paw.x * yumi_direction, local_paw.y)
	for offset in [-8.0, 0.0, 8.0]:
		draw_line(swipe_start + Vector2(0, offset), point + Vector2(0, offset), Color(1, 0.94, 0.73, impact * 0.75), 3.0, true)


func draw_yumi() -> void:
	var p := yumi_position
	var sleeping := not yumi_is_active() and yumi_visual_state() == "playing" and not is_memory_level()
	var art := yumi_art_texture()
	var reaching := art == YUMI_PAW_ART
	var walking := art == YUMI_WALK_ART
	var motion := yumi_paw_motion()
	var shift: Vector2 = motion["shift"] if reaching else Vector2.ZERO
	var direction := yumi_direction if reaching or walking else 1.0
	if reaching and toy_play_pose()["playing"]:
		direction = float(toy_play_pose()["direction"])
	var visual_origin := p + Vector2(shift.x * direction, shift.y)
	var friendly_nod: float = shared_celebration_pose()["nod"]
	visual_origin.y += friendly_nod * 2.0
	var rest: Dictionary = yumi_rest_pose()
	# Align each source pose around the unchanged gameplay center.
	draw_set_transform(visual_origin + Vector2(0, float(rest["offset_y"])), float(motion["angle"]) * direction if reaching else -friendly_nod * 0.055, Vector2(direction, float(rest["scale_y"])))
	if walking:
		draw_texture_rect_region(art, yumi_art_rect(), yumi_walk_region())
	elif art == YUMI_GROOM_ART:
		draw_texture_rect_region(art, yumi_art_rect(), yumi_groom_region())
	elif reaching:
		draw_animated_paw(yumi_art_rect(), motion["arm"])
	else:
		draw_texture_rect(art, yumi_art_rect(), false)
	draw_set_transform(Vector2.ZERO)
	draw_paw_impact(motion)

	var local_paw := Vector2(48, 21) + Vector2(motion["arm"])
	var paw_end := visual_origin + Vector2(local_paw.x * direction, local_paw.y).rotated(float(motion["angle"]) * direction)
	if yumi_warning_timer > 0.0:
		draw_circle(paw_end, 28.0 + sin(level_time * 24.0) * 4.0, Color(1.0, 0.8, 0.2, 0.18))
		draw_arc(paw_end, 33.0, 0, TAU, 28, Color("ffcf5a"), 4.0, true)

	var font := ThemeDB.fallback_font
	if yumi_warning_timer > 0.0:
		draw_circle(p + Vector2(0, -108), 22, INK)
		draw_string(font, p + Vector2(-20, -96), "!", HORIZONTAL_ALIGNMENT_CENTER, 40, 34, Color("ffcf5a"))
	var yumi_caption := "YUMI · Zzz" if sleeping else "YUMI"
	if is_memory_level() and memory_clue_hidden():
		yumi_caption = "ŞİFRE BENİM!"
	if toy_active:
		yumi_caption = "YAKALADIM!" if toy_feedback()["phase"] == "play" else "FARE BENİM!"
	elif yumi_is_active() and ball_active and ball_type == 2 and not ball_swatted:
		yumi_caption = "YUMAK BENİM!"
	if celebration_visual_active():
		yumi_caption = "BEN Mİ?" if yumi_help_count > 0 and celebration_time < 0.5 else "MAMA!"
		if celebration_time >= 1.7:
			yumi_caption = "PAYLAŞALIM!"
	if not (motion["big"] and float(motion["impact"]) > 0.0):
		draw_style_box(rounded_box(CREAM, 8), Rect2(visual_origin + Vector2(-70, -85), Vector2(140, 24)))
		draw_string(font, visual_origin + Vector2(-70, -68), yumi_caption, HORIZONTAL_ALIGNMENT_CENTER, 140, 16, INK)


func yumi_visual_state() -> String:
	# Pausing freezes the role as well as its animation clock.
	return paused_from_state if game_state == "paused" else game_state


func yumi_rest_pose() -> Dictionary:
	# Subtle breathing in the existing curled pose; the floor stays anchored.
	var sleeping := yumi_art_texture() == YUMI_SLEEP_ART
	var scale_y := 1.0 + sin(level_time * TAU / 3.2) * 0.02 if sleeping else 1.0
	return {"scale_y": scale_y, "offset_y": 71.0 * (1.0 - scale_y)}


func yumi_art_texture() -> Texture2D:
	var visual_state := yumi_visual_state()
	if is_memory_level() and visual_state == "playing":
		return YUMI_PAW_ART if memory_clue_hidden() else YUMI_IDLE_ART
	if scatter_state == "warning" or (scatter_state == "scatter" and scatter_timer > 1.72):
		return YUMI_PAW_ART
	if not yumi_is_active() and visual_state == "playing":
		return YUMI_SLEEP_ART
	if yumi_warning_timer > 0.0 or yumi_swipe_flash > 0.0:
		return YUMI_PAW_ART
	if toy_play_pose()["playing"]:
		return YUMI_PAW_ART
	if visual_state == "playing" and yumi_walk_moving:
		return YUMI_WALK_ART
	if yumi_groom_time > 0.0 and (yumi_can_groom() or game_state == "paused"):
		return YUMI_GROOM_ART
	return YUMI_IDLE_ART


func yumi_art_rect() -> Rect2:
	if yumi_art_texture() == YUMI_GROOM_ART:
		var anchor: Vector2 = YUMI_GROOM_ANCHORS[yumi_groom_frame()] * (158.0 / 512.0)
		return Rect2(Vector2(-anchor.x, 67.0 - anchor.y), Vector2(158, 158))
	if yumi_art_texture() == YUMI_WALK_ART:
		var anchor: Vector2 = YUMI_WALK_ANCHORS[yumi_walk_frame()] * (144.0 / 512.0)
		return Rect2(Vector2(-anchor.x, 57.0 - anchor.y), Vector2(144, 144))
	if yumi_art_texture() == YUMI_SLEEP_ART:
		# Curled silhouette rests on the same floor as the upright poses.
		return Rect2(Vector2(-72, -73), Vector2(144, 144))
	# The paw pose has a different source anchor, not a different collision box.
	var normalized_anchor := Vector2(680, 590) / 1280.0 if yumi_art_texture() == YUMI_PAW_ART else Vector2(600, 600) / 1280.0
	return Rect2(-normalized_anchor * 144.0, Vector2(144, 144))


func yumi_walk_region() -> Rect2:
	var frame := yumi_walk_frame()
	var cell := Vector2(YUMI_WALK_ART.get_width() / 3.0, YUMI_WALK_ART.get_height() / 2.0)
	return Rect2(Vector2(frame % 3, frame / 3) * cell, cell)


func shako_visual_position() -> Vector2:
	if game_state in ["celebrating", "success"] or (game_state == "paused" and paused_from_state == "celebrating"):
		return celebration_shako_position
	return LAUNCH_POS + Vector2(0, 18)


func draw_shako_launcher() -> void:
	if game_state in ["celebrating", "success"] or (game_state == "paused" and paused_from_state == "celebrating"):
		draw_shako_face(shako_visual_position(), true)
		return
	var direction := Vector2(sin(aim_angle), -cos(aim_angle))
	var muzzle := LAUNCH_POS + direction * 58.0
	if not ball_active and game_state == "playing":
		if level_index == 1:
			var points := aim_preview_points()
			for index in range(points.size() - 1):
				var segment_start := points[index]
				var segment_end := points[index + 1]
				var length := segment_start.distance_to(segment_end)
				for distance in range(12, int(length), 24):
					var dot := segment_start.lerp(segment_end, float(distance) / length)
					draw_circle(dot, 4.0, CREAM)
					draw_circle(dot, 2.5, Color("24616b"))
		else:
			for step in range(1, 7):
				var start := LAUNCH_POS + direction * (72.0 + step * 28.0)
				draw_line(start, start + direction * 13.0, CREAM, 5.0, true)
				draw_line(start, start + direction * 13.0, Color("24616b"), 2.0, true)

	draw_line(LAUNCH_POS, muzzle, Color("5d7898"), 30.0, true)
	draw_circle(muzzle, 18, Color("9db8cf"))
	draw_shako_face(LAUNCH_POS + Vector2(0, 18))
	if not ball_active and game_state == "playing" and progress < sequence.size():
		if memory_clue_hidden():
			var covered_ball := muzzle + direction * 7.0
			draw_circle(covered_ball, BALL_RADIUS, Color("d4c2dd"))
			draw_string(ThemeDB.fallback_font, covered_ball + Vector2(-12, 7), "?", HORIZONTAL_ALIGNMENT_CENTER, 24, 20, INK)
		else:
			draw_ball(muzzle + direction * 7.0, sequence[progress])


func aim_preview_points() -> Array[Vector2]:
	var direction := Vector2(sin(aim_angle), -cos(aim_angle))
	var position := LAUNCH_POS + direction * 50.0
	var points: Array[Vector2] = [position]
	var bounce_limit := int(level_config().get("max_wall_bounces", 0))
	for bounce in range(bounce_limit + 1):
		var goal_distance := (GOAL_LINE - position.y) / direction.y
		var wall_distance := INF
		if direction.x > 0.0:
			wall_distance = (WALL_RIGHT - position.x) / direction.x
		elif direction.x < 0.0:
			wall_distance = (WALL_LEFT - position.x) / direction.x
		position += direction * minf(goal_distance, wall_distance)
		points.append(position)
		if goal_distance <= wall_distance:
			break
		direction.x = -direction.x
	return points


func shako_reaction_pose() -> Dictionary:
	var state := paused_from_state if game_state == "paused" else game_state
	var frame := -1
	var lift := 0.0
	var direction := 1.0
	if state == "celebrating":
		frame = 4 + int(celebration_time * 8.0) % 2
		lift = absf(sin(celebration_time * PI * 4.0)) * 4.0
	elif state == "playing":
		if shako_joy_left > 0.0:
			var phase := 1.0 - shako_joy_left / 0.45
			frame = 4 + int(phase * 4.0) % 2
			lift = sin(phase * PI) * 4.0
		elif shako_surprise_left > 0.0:
			frame = 2 if shako_surprise_left > 0.35 else 3
			direction = shako_look_direction
		elif not ball_active and shot_delay <= 0.0 and stage_rotation <= 0.0 and scatter_state.is_empty() and not toy_selecting:
			frame = int(level_time * 1.8) % 2
	return {"frame": frame, "lift": lift, "direction": direction}


func shako_reaction_region(frame: int) -> Rect2:
	var cell := Vector2(SHAKO_REACTION_ART.get_width() / 3.0, SHAKO_REACTION_ART.get_height() / 2.0)
	return Rect2(Vector2(frame % 3, frame / 3) * cell, cell)


func draw_shako_face(head: Vector2, celebrating: bool = false) -> void:
	var pose := shako_reaction_pose()
	var frame: int = pose["frame"]
	if frame >= 0:
		var anchor: Vector2 = SHAKO_REACTION_ANCHORS[frame] * (118.0 / 512.0)
		draw_set_transform(head + Vector2(0, -float(pose["lift"])), float(shared_celebration_pose()["nod"]) * 0.055, Vector2(float(pose["direction"]), 1))
		draw_texture_rect_region(SHAKO_REACTION_ART, Rect2(Vector2(-anchor.x, 30.0 - anchor.y), Vector2(118, 118)), shako_reaction_region(frame))
		draw_set_transform(Vector2.ZERO)
	else:
		draw_texture_rect(SHAKO_IDLE_ART, Rect2(head + Vector2(-59, -77), Vector2(118, 118)), false)
	var font := ThemeDB.fallback_font
	var caption := "ŞAKO"
	if celebrating:
		caption = "YUMI?!" if yumi_help_count > 0 and celebration_time < 0.5 else "MAMA!"
		if celebration_time >= 1.7:
			caption = "BİRLİKTE!"
	draw_style_box(rounded_box(CREAM, 8), Rect2(head + Vector2(-48, 38), Vector2(96, 24)))
	draw_string(font, head + Vector2(-48, 55), caption, HORIZONTAL_ALIGNMENT_CENTER, 96, 16, INK)


func draw_bark_wave() -> void:
	var phase := 1.0 - bark_flash / 0.48
	for ring in range(3):
		var radius := 54.0 + phase * 150.0 + ring * 24.0
		var alpha := clampf((bark_flash / 0.48) * (0.72 - ring * 0.16), 0.0, 0.8)
		draw_arc(LAUNCH_POS, radius, -2.72, -0.42, 40, Color(0.4, 0.95, 1.0, alpha), 5.0, true)
	var font := ThemeDB.fallback_font
	draw_string(font, LAUNCH_POS + Vector2(-55, -86), "HAV!", HORIZONTAL_ALIGNMENT_CENTER, 110, 28, Color("86f7ff"))


func draw_ball_drop(hole_center: Vector2) -> void:
	var fraction := clampf(1.0 - ball_drop_time / BALL_DROP_DURATION, 0.0, 1.0)
	var pose := ball_drop_pose(fraction)
	var center: Vector2 = hole_center + pose["offset"]
	var radius: float = BALL_RADIUS * pose["scale"]
	var mouth_radius := HOLE_RADIUS - 10.0
	var cut_y := hole_center.y + sqrt(maxf(0.0, mouth_radius * mouth_radius - pow(center.x - hole_center.x, 2)))
	# Keep the sphere's size; the front of the opening hides it from bottom up.
	draw_drop_disc(center + Vector2(1, 1), radius + 1.0, cut_y, TYPE_DARK[ball_drop_type])
	draw_drop_disc(center, radius, cut_y, TYPE_COLORS[ball_drop_type])
	draw_drop_disc(center + Vector2(2, 4), radius * 0.72, cut_y, TYPE_DARK[ball_drop_type].lightened(0.16))
	if center.y + radius * 0.65 < cut_y:
		draw_type_icon(center, ball_drop_type, radius * 0.6, TYPE_DARK[ball_drop_type])
	draw_drop_disc(center + Vector2(-6, -7) * pose["scale"], radius * 0.18, cut_y, Color(1, 1, 1, 0.8))
	draw_drop_disc(center, radius + 1.0, cut_y, Color(0.04, 0.03, 0.02, float(pose["depth"]) * 0.22))
	# A subtle mouth ripple, drawn under the front rim rather than over the HUD.
	draw_arc(hole_center, HOLE_RADIUS - 11.0 + fraction * 4.0, 0.2, PI - 0.2, 32, Color(1, 0.86, 0.64, (1.0 - fraction) * 0.3), 1.5, true)


func ball_drop_pose(fraction: float) -> Dictionary:
	var entry := smoothstep(0.0, 0.22, fraction)
	var fall := clampf((fraction - 0.22) / 0.78, 0.0, 1.0)
	return {"offset": ball_drop_offset.lerp(Vector2(0, -8), entry) + Vector2(0, 86 * fall * fall), "scale": lerpf(1.0, 0.84, fall), "depth": fall}


func draw_drop_disc(center: Vector2, radius: float, cut_y: float, color: Color) -> void:
	# Clip each sphere layer against the foreground mouth, not a fade-to-black.
	var polygon := PackedVector2Array()
	var previous := center + Vector2(radius, 0)
	for point in range(1, 49):
		var angle := TAU * float(point) / 48.0
		var current := center + Vector2(cos(angle), sin(angle)) * radius
		var previous_inside := previous.y <= cut_y
		var current_inside := current.y <= cut_y
		if previous_inside != current_inside:
			polygon.append(previous.lerp(current, (cut_y - previous.y) / (current.y - previous.y)))
		if current_inside:
			polygon.append(current)
		previous = current
	if polygon.size() >= 3:
		draw_colored_polygon(polygon, color)


func draw_ball(center: Vector2, type: int, with_shadow: bool = true) -> void:
	if not ball_active and with_shadow:
		draw_soft_shadow(center + Vector2(4, 8), Vector2(20, 8), 0.22)
	draw_circle(center + Vector2(1, 2), BALL_RADIUS + 1.0, TYPE_DARK[type])
	draw_circle(center, BALL_RADIUS, TYPE_COLORS[type])
	draw_arc(center, BALL_RADIUS - 2, 0.2, PI - 0.2, 24, Color(0.12, 0.08, 0.05, 0.22), 3.0, true)
	draw_arc(center, BALL_RADIUS - 4, PI + 0.2, TAU - 0.4, 24, Color(1, 1, 1, 0.65), 2.0, true)
	draw_circle(center + Vector2(-7, -8), 3.0, Color(1, 1, 1, 0.70))
	draw_type_icon(center, type, 11, TYPE_DARK[type])


func draw_type_icon(center: Vector2, type: int, radius: float, color: Color) -> void:
	if type == 0:
		var body := PackedVector2Array()
		for point in [Vector2(-0.7, 0), Vector2(-0.3, -0.65), Vector2(0.5, -0.55), Vector2(1, 0), Vector2(0.5, 0.55), Vector2(-0.3, 0.65)]:
			body.append(center + point * radius)
		draw_colored_polygon(body, color)
		draw_colored_polygon(PackedVector2Array([center + Vector2(-0.5, 0) * radius, center + Vector2(-1.1, -0.6) * radius, center + Vector2(-1.1, 0.6) * radius]), color)
		draw_circle(center + Vector2(0.55, -0.12) * radius, radius * 0.12, CREAM)
	elif type == 1:
		draw_circle(center + Vector2(0, 0.35) * radius, radius * 0.55, color)
		for toe in [Vector2(-0.65, -0.3), Vector2(-0.22, -0.75), Vector2(0.3, -0.75), Vector2(0.7, -0.25)]:
			draw_circle(center + toe * radius, radius * 0.26, color)
	else:
		draw_circle(center, radius * 0.86, color)
		for offset in [-0.4, 0.0, 0.4]:
			draw_line(center + Vector2(-0.55, offset - 0.3) * radius, center + Vector2(0.55, offset + 0.3) * radius, CREAM, maxf(1.0, radius * 0.12), true)
		draw_arc(center, radius * 0.6, -1.0, 1.4, 16, CREAM, maxf(1.0, radius * 0.1), true)


func rounded_box(color: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	return style
