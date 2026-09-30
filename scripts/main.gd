extends Node2D

const SCREEN_SIZE := Vector2(1152.0, 648.0)
const HOLE_Y := 172.0
const HOLE_RADIUS := 54.0
const HOLE_BASE_X := [310.0, 576.0, 842.0]
const LAUNCH_POS := Vector2(576.0, 532.0)
const BALL_RADIUS := 21.0
const TYPE_NAMES := ["BALIK", "PATİ", "YUMAK"]
const TYPE_SYMBOLS := ["◆", "●", "✦"]
const TYPE_COLORS := [Color("57d9ff"), Color("ff8b74"), Color("b98cff")]
const TYPE_DARK := [Color("146582"), Color("833b36"), Color("563a84")]

const LEVELS := [
	{
		"name": "1 · İLK ATIŞ",
		"sequence": [0, 1, 2],
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
		"intro": "Sıradaki sembolü aynı işaretli deliğe gönder.",
	},
	{
		"name": "2 · YUMI SAHADA",
		"sequence": [2, 0, 1, 2],
		"yumi_speed": 142.0,
		"yumi_active": true,
		"move_directions": 4,
		"turn_min": 0.9,
		"turn_max": 1.8,
		"vertical_range": 42.0,
		"pause_chance": 0.09,
		"dash_chance": 0.04,
		"deflection_range": 220.0,
		"moving_holes": false,
		"intro": "Yumi hazırlanırken uçuşta tekrar tıkla: Şako HAV! desin.",
	},
	{
		"name": "3 · KAYAN KİLİT",
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
		"intro": "Delikler hareket ediyor. Atış anını seç ve havlamanı sakla.",
	},
]

var rng := RandomNumberGenerator.new()
var hole_positions: Array[Vector2] = []
var sequence: Array[int] = []
var level_index := 0
var level_time := 0.0
var progress := 0
var errors := 0
var game_state := "playing"

var aim_angle := 0.0
var last_pointer_position := Vector2(576.0, 220.0)
var ball_active := false
var ball_position := LAUNCH_POS
var ball_velocity := Vector2.ZERO
var ball_type := 0
var ball_swatted := false
var ball_deflected_by_yumi := false
var shot_delay := 0.0

var bark_available := false
var bark_flash := 0.0
var bark_target_x := 576.0

var yumi_position := Vector2(300.0, 345.0)
var yumi_direction := 1.0
var yumi_speed := 100.0
var yumi_velocity := Vector2.RIGHT
var yumi_move_timer := 0.0
var yumi_pause_timer := 0.0
var yumi_dash_timer := 0.0
var yumi_warning_timer := 0.0
var yumi_warning_started := false
var yumi_swipe_flash := 0.0
var status_flash := 0.0

var title_label: Label
var level_label: Label
var code_label: Label
var status_label: Label
var instruction_label: Label
var next_label: Label
var ability_label: Label
var overlay: ColorRect
var overlay_title: Label
var overlay_subtitle: Label
var overlay_button: Button


func _ready() -> void:
	rng.randomize()
	for x_position in HOLE_BASE_X:
		hole_positions.append(Vector2(float(x_position), HOLE_Y))
	build_interface()
	start_level(0)
	queue_redraw()


func build_interface() -> void:
	title_label = make_label("YUMI & ŞAKO", 28, Color("fff3cf"), Vector2(0, 14), Vector2(1152, 38))
	title_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.55))
	title_label.add_theme_constant_override("shadow_offset_x", 2)
	title_label.add_theme_constant_override("shadow_offset_y", 3)

	level_label = make_label("", 15, Color("8fa8c4"), Vector2(28, 58), Vector2(210, 40))
	level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	code_label = make_label("", 20, Color.WHITE, Vector2(210, 58), Vector2(760, 40))
	status_label = make_label("", 19, Color("fff3cf"), Vector2(176, 424), Vector2(800, 34))
	next_label = make_label("", 17, Color("d8e9ff"), Vector2(346, 482), Vector2(460, 28))
	ability_label = make_label("", 15, Color("86f7a8"), Vector2(396, 509), Vector2(360, 25))
	instruction_label = make_label(
		"Nişan/Atış: Fare + sol tık veya Boşluk     Havlama: Uçuşta tekrar tık / E     Yenile: R",
		14,
		Color("a9bbd3"),
		Vector2(62, 612),
		Vector2(1028, 22)
	)

	overlay = ColorRect.new()
	overlay.position = Vector2.ZERO
	overlay.size = SCREEN_SIZE
	overlay.color = Color(0.02, 0.03, 0.06, 0.86)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.z_index = 20
	add_child(overlay)

	overlay_title = make_label("", 42, Color("fff3cf"), Vector2(206, 180), Vector2(740, 62), overlay)
	overlay_subtitle = make_label("", 21, Color("d8e9ff"), Vector2(256, 255), Vector2(640, 100), overlay)
	overlay_subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	overlay_button = Button.new()
	overlay_button.text = "TEKRAR DENE"
	overlay_button.position = Vector2(436, 384)
	overlay_button.size = Vector2(280, 62)
	overlay_button.add_theme_font_size_override("font_size", 20)
	overlay_button.add_theme_color_override("font_color", Color("16233d"))
	overlay_button.add_theme_color_override("font_hover_color", Color("16233d"))
	overlay_button.add_theme_stylebox_override("normal", button_style(Color("ffcf5a")))
	overlay_button.add_theme_stylebox_override("hover", button_style(Color("ffe18e")))
	overlay_button.add_theme_stylebox_override("pressed", button_style(Color("eab746")))
	overlay_button.pressed.connect(on_overlay_button_pressed)
	overlay.add_child(overlay_button)
	overlay.hide()


func make_label(text: String, font_size: int, color: Color, position: Vector2, size: Vector2, parent: Node = self) -> Label:
	var label := Label.new()
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
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	style.shadow_color = Color(0, 0, 0, 0.35)
	style.shadow_size = 7
	return style


func level_config() -> Dictionary:
	return LEVELS[level_index]


func start_level(new_level_index: int = level_index) -> void:
	level_index = clampi(new_level_index, 0, LEVELS.size() - 1)
	var config := level_config()
	sequence.clear()
	for value in config["sequence"]:
		sequence.append(int(value))
	progress = 0
	errors = 0
	level_time = 0.0
	game_state = "playing"
	ball_active = false
	ball_position = LAUNCH_POS
	ball_velocity = Vector2.ZERO
	ball_swatted = false
	ball_deflected_by_yumi = false
	bark_available = false
	bark_flash = 0.0
	shot_delay = 0.35
	aim_angle = 0.0
	yumi_position = Vector2(300.0, 345.0)
	yumi_direction = 1.0
	yumi_speed = float(config["yumi_speed"])
	yumi_velocity = Vector2.RIGHT * yumi_speed
	yumi_move_timer = 0.0
	yumi_pause_timer = 0.0
	yumi_dash_timer = 0.0
	yumi_warning_timer = 0.0
	yumi_warning_started = false
	yumi_swipe_flash = 0.0
	choose_yumi_direction(true)
	status_label.text = str(config["intro"])
	status_label.add_theme_color_override("font_color", Color("fff3cf"))
	overlay.hide()
	update_holes()
	update_interface()
	queue_redraw()


func _process(delta: float) -> void:
	if game_state != "playing":
		return

	level_time += delta
	shot_delay = maxf(0.0, shot_delay - delta)
	status_flash = maxf(0.0, status_flash - delta)
	yumi_swipe_flash = maxf(0.0, yumi_swipe_flash - delta)
	bark_flash = maxf(0.0, bark_flash - delta)

	var keyboard_direction := 0.0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		keyboard_direction -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		keyboard_direction += 1.0
	if keyboard_direction != 0.0 and not ball_active:
		aim_angle = clampf(aim_angle + keyboard_direction * delta * 1.35, -0.78, 0.78)

	update_holes()
	move_yumi(delta)
	if ball_active:
		move_ball(delta)
	update_interface()
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseMotion
		last_pointer_position = mouse_event.position
		if game_state == "playing" and not ball_active:
			update_mouse_aim(last_pointer_position)
		return

	if event is InputEventKey and event.pressed and not event.echo:
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
	if not mouse_button.pressed:
		return
	last_pointer_position = mouse_button.position
	if mouse_button.button_index == MOUSE_BUTTON_LEFT:
		if ball_active:
			use_bark(mouse_button.position.x)
		else:
			update_mouse_aim(mouse_button.position)
			launch_ball()
	elif mouse_button.button_index == MOUSE_BUTTON_RIGHT and ball_active:
		use_bark(mouse_button.position.x)


func update_mouse_aim(pointer_position: Vector2) -> void:
	var offset: Vector2 = pointer_position - LAUNCH_POS
	if offset.y < -20.0:
		aim_angle = clampf(atan2(offset.x, -offset.y), -0.78, 0.78)


func launch_ball() -> void:
	if game_state != "playing" or ball_active or shot_delay > 0.0:
		return
	ball_type = sequence[progress]
	var direction := Vector2(sin(aim_angle), -cos(aim_angle))
	ball_position = LAUNCH_POS + direction * 50.0
	ball_velocity = direction * 520.0
	ball_active = true
	ball_swatted = false
	ball_deflected_by_yumi = false
	bark_available = true
	yumi_warning_timer = 0.0
	yumi_warning_started = false
	status_label.text = "%s topu yolda. Gerekirse bir kez HAV!" % TYPE_NAMES[ball_type]
	status_label.add_theme_color_override("font_color", TYPE_COLORS[ball_type])


func use_bark(target_x: float) -> void:
	if game_state != "playing" or not ball_active or not bark_available:
		return
	bark_available = false
	bark_flash = 0.48
	bark_target_x = clampf(target_x, 90.0, SCREEN_SIZE.x - 90.0)

	var remaining_distance := maxf(ball_position.y - HOLE_Y, 70.0)
	var upward_speed := maxf(-ball_velocity.y, 220.0)
	var remaining_time := maxf(remaining_distance / upward_speed, 0.18)
	var desired_x_speed := (bark_target_x - ball_position.x) / remaining_time
	ball_velocity.x = clampf(lerpf(ball_velocity.x, desired_x_speed, 0.82), -560.0, 560.0)
	ball_velocity.y = -maxf(absf(ball_velocity.y), 420.0)

	if yumi_warning_timer > 0.0:
		yumi_warning_timer = 0.0
		ball_swatted = true
		status_label.text = "HAV! Yumi irkildi; top yeniden yönlendirildi."
	else:
		status_label.text = "HAV! Şako topun yönünü düzeltti."
	status_label.add_theme_color_override("font_color", Color("86f7a8"))


func update_holes() -> void:
	var moving := bool(level_config()["moving_holes"])
	for index in range(hole_positions.size()):
		var offset := 0.0
		if moving:
			offset = sin(level_time * 1.18 + index * 1.65) * 43.0
		hole_positions[index] = Vector2(HOLE_BASE_X[index] + offset, HOLE_Y)


func move_yumi(delta: float) -> void:
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

	yumi_position += yumi_velocity * delta * movement_scale

	var vertical_range := float(config["vertical_range"])
	var min_y := 348.0 - vertical_range
	var max_y := 348.0 + vertical_range
	var hit_boundary := false
	if yumi_position.x < 222.0:
		yumi_position.x = 222.0
		yumi_velocity.x = absf(yumi_velocity.x)
		hit_boundary = true
	elif yumi_position.x > 930.0:
		yumi_position.x = 930.0
		yumi_velocity.x = -absf(yumi_velocity.x)
		hit_boundary = true
	if vertical_range <= 0.0:
		yumi_position.y = 348.0
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
	if yumi_position.x < 300.0 and selected.x < 0.0:
		selected.x = absf(selected.x)
	elif yumi_position.x > 852.0 and selected.x > 0.0:
		selected.x = -absf(selected.x)
	var vertical_range := float(config["vertical_range"])
	if vertical_range > 0.0:
		if yumi_position.y < 348.0 - vertical_range * 0.72 and selected.y < 0.0:
			selected.y = absf(selected.y)
		elif yumi_position.y > 348.0 + vertical_range * 0.72 and selected.y > 0.0:
			selected.y = -absf(selected.y)

	var speed_multiplier := 1.0
	if rng.randf() < float(config["dash_chance"]):
		speed_multiplier = 1.48
		yumi_dash_timer = rng.randf_range(0.20, 0.34)
	yumi_velocity = selected.normalized() * yumi_speed * speed_multiplier
	yumi_move_timer = rng.randf_range(float(config["turn_min"]), float(config["turn_max"]))


func move_ball(delta: float) -> void:
	ball_position += ball_velocity * delta

	if ball_position.x < 42.0 + BALL_RADIUS or ball_position.x > SCREEN_SIZE.x - 42.0 - BALL_RADIUS:
		register_error("Top kilit kanalının dışına çıktı!")
		return

	update_yumi_attack(delta)
	if not ball_active:
		return

	if ball_position.y <= HOLE_Y + 14.0:
		resolve_hole_hit()
	elif ball_position.y > SCREEN_SIZE.y + 40.0:
		register_error("Top oyun alanından çıktı!")


func update_yumi_attack(delta: float) -> void:
	if not bool(level_config()["yumi_active"]) or ball_swatted:
		return

	if ball_position.distance_to(yumi_position) < 64.0:
		deflect_ball_from_yumi()
		return

	if yumi_warning_timer > 0.0:
		yumi_warning_timer = maxf(0.0, yumi_warning_timer - delta)
		if yumi_warning_timer == 0.0:
			if ball_position.distance_to(yumi_position) < 155.0:
				perform_yumi_swipe()
			else:
				ball_swatted = true
				status_label.text = "Yumi ıskaladı!"
				status_label.add_theme_color_override("font_color", Color("86f7a8"))
		return

	if not yumi_warning_started and ball_position.distance_to(yumi_position) < 178.0:
		yumi_warning_started = true
		yumi_warning_timer = 0.24
		status_label.text = "Yumi hazırlanıyor! Şimdi HAV! diyebilirsin."
		status_label.add_theme_color_override("font_color", Color("ffcf5a"))


func perform_yumi_swipe() -> void:
	deflect_ball_from_yumi()


func deflect_ball_from_yumi() -> void:
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
	status_label.add_theme_color_override("font_color", Color("ffcf5a"))


func resolve_hole_hit() -> void:
	var nearest_hole := 0
	var nearest_distance := INF
	for index in range(hole_positions.size()):
		var distance := absf(ball_position.x - hole_positions[index].x)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_hole = index

	if nearest_distance > HOLE_RADIUS - 4.0:
		register_error("Top deliği ıskaladı!")
		return

	if nearest_hole == ball_type and ball_type == sequence[progress]:
		var lucky_yumi_goal := ball_deflected_by_yumi
		progress += 1
		ball_active = false
		bark_available = false
		shot_delay = 0.45
		status_flash = 0.38
		if progress >= sequence.size():
			finish_game(true)
		else:
			status_label.text = "Yumi yanlışlıkla yardım etti! " + progress_hint() if lucky_yumi_goal else progress_hint()
			status_label.add_theme_color_override("font_color", Color("86f7a8"))
	else:
		var error_message := "Yumi topu yanlış deliğe sektirdi!" if ball_deflected_by_yumi else "Yanlış delik! Kilitte çatlak oluştu."
		register_error(error_message)


func progress_hint() -> String:
	if level_index == 0:
		if progress == 1:
			return "TAK! Şimdi PATİ topunu ortadaki deliğe gönder."
		return "Harika! Son sembol YUMAK."
	if level_index == 1:
		return "Parça oturdu. Yumi'nin ünlem işaretini izle."
	return "Parça oturdu. Hareketli hedefin önüne nişan al."


func register_error(message: String) -> void:
	ball_active = false
	bark_available = false
	yumi_warning_timer = 0.0
	shot_delay = 0.55
	errors += 1
	status_flash = 0.5
	status_label.text = message
	status_label.add_theme_color_override("font_color", Color("ff746f"))
	if errors >= 3:
		finish_game(false)


func finish_game(success: bool) -> void:
	ball_active = false
	bark_available = false
	overlay.show()
	if success:
		game_state = "success"
		overlay_title.text = "KİLİT AÇILDI!"
		overlay_title.add_theme_color_override("font_color", Color("86f7a8"))
		if ball_deflected_by_yumi:
			overlay_subtitle.text = "Yumi son topu yanlışlıkla doğru deliğe gönderdi! Şako bu yardımı unutmayacak."
			overlay_button.text = "SONRAKİ BÖLÜM" if level_index < LEVELS.size() - 1 else "BAŞA DÖN"
		elif level_index < LEVELS.size() - 1:
			overlay_subtitle.text = "%s tamamlandı. Sıradaki bölüm yeni bir kural ekliyor." % str(level_config()["name"])
			overlay_button.text = "SONRAKİ BÖLÜM"
		else:
			overlay_subtitle.text = "Üç bölümlük prototip tamamlandı. Şako kilidi açtı; Yumi hâlâ masum görünüyor."
			overlay_button.text = "BAŞA DÖN"
	else:
		game_state = "failed"
		overlay_title.text = "KİLİT SIKIŞTI!"
		overlay_title.add_theme_color_override("font_color", Color("ff746f"))
		overlay_subtitle.text = "Yumi: 😼     Şako: 😵\nAynı bölümü hemen yeniden deneyebilirsin."
		overlay_button.text = "TEKRAR DENE"
	queue_redraw()


func on_overlay_button_pressed() -> void:
	if game_state == "success":
		if level_index < LEVELS.size() - 1:
			start_level(level_index + 1)
		else:
			start_level(0)
	else:
		start_level(level_index)


func update_interface() -> void:
	level_label.text = str(level_config()["name"])
	var code_text := "KİLİT:  "
	for index in range(sequence.size()):
		if index < progress:
			code_text += "✓  "
		elif index == progress and game_state == "playing":
			code_text += "[%s]  " % TYPE_SYMBOLS[sequence[index]]
		else:
			code_text += "%s  " % TYPE_SYMBOLS[sequence[index]]
	code_label.text = code_text + "     HATA: %d / 3" % errors

	if game_state == "playing" and progress < sequence.size():
		next_label.text = "Sıradaki: %s  %s" % [TYPE_SYMBOLS[sequence[progress]], TYPE_NAMES[sequence[progress]]]
		next_label.add_theme_color_override("font_color", TYPE_COLORS[sequence[progress]])
		if ball_active:
			ability_label.text = "HAVLAMA: HAZIR — tekrar tıkla / E" if bark_available else "HAVLAMA: KULLANILDI"
			ability_label.add_theme_color_override("font_color", Color("86f7a8") if bark_available else Color("7b8da4"))
		else:
			ability_label.text = "Bu atışta 1 havlama hakkı"
			ability_label.add_theme_color_override("font_color", Color("8fa8c4"))


func _draw() -> void:
	draw_background()
	draw_lock_panel()
	draw_holes()
	draw_yumi()
	draw_shako_launcher()
	if ball_active:
		draw_ball(ball_position, ball_type)
	if bark_flash > 0.0:
		draw_bark_wave()


func draw_background() -> void:
	draw_rect(Rect2(Vector2.ZERO, SCREEN_SIZE), Color("081326"))
	draw_circle(Vector2(96, 112), 160, Color("10294a"))
	draw_circle(Vector2(1070, 560), 210, Color("182348"))
	for y in range(290, 610, 40):
		draw_line(Vector2(44, y), Vector2(1108, y), Color(0.18, 0.28, 0.42, 0.12), 1.0)
	draw_line(Vector2(42, 105), Vector2(42, 590), Color("294868"), 4.0)
	draw_line(Vector2(1110, 105), Vector2(1110, 590), Color("294868"), 4.0)


func draw_lock_panel() -> void:
	var panel_color := Color("12243e")
	if status_flash > 0.0:
		panel_color = Color("25445a") if errors < 3 else Color("5b2730")
	draw_style_box(rounded_box(panel_color, 20), Rect2(18, 50, 984, 54))
	for index in range(3):
		var warning_color := Color("ff645f") if index < errors else Color("263a55")
		draw_circle(Vector2(930 + index * 22, 77), 6.0, warning_color)


func draw_holes() -> void:
	var font := ThemeDB.fallback_font
	for index in range(hole_positions.size()):
		var center := hole_positions[index]
		draw_circle(center + Vector2(0, 7), HOLE_RADIUS + 6.0, Color(0, 0, 0, 0.42))
		draw_circle(center, HOLE_RADIUS + 5.0, TYPE_COLORS[index])
		draw_circle(center, HOLE_RADIUS - 7.0, Color("07101e"))
		draw_arc(center, HOLE_RADIUS - 14.0, 0, TAU, 48, TYPE_DARK[index], 5.0, true)
		draw_string(font, center + Vector2(-45, 7), TYPE_SYMBOLS[index], HORIZONTAL_ALIGNMENT_CENTER, 90, 31, TYPE_COLORS[index])
		draw_string(font, center + Vector2(-60, 86), TYPE_NAMES[index], HORIZONTAL_ALIGNMENT_CENTER, 120, 16, Color("dbeaff"))


func draw_yumi() -> void:
	var p := yumi_position
	var fur := Color("f7b45b")
	var fur_dark := Color("c96c3d")
	if not bool(level_config()["yumi_active"]):
		fur = Color("b9956e")
		fur_dark = Color("765948")

	draw_arc(p + Vector2(43, 30), 38, -1.4, 1.4, 24, fur_dark, 12.0, true)
	draw_circle(p + Vector2(0, 28), 38, fur)
	draw_colored_polygon(PackedVector2Array([p + Vector2(-34, -28), p + Vector2(-15, -58), p + Vector2(-5, -25)]), fur)
	draw_colored_polygon(PackedVector2Array([p + Vector2(34, -28), p + Vector2(15, -58), p + Vector2(5, -25)]), fur)
	draw_circle(p, 42, fur)
	draw_circle(p + Vector2(-14, -5), 5, Color("122038"))
	draw_circle(p + Vector2(14, -5), 5, Color("122038"))
	draw_line(p + Vector2(-11, 17), p + Vector2(0, 22), Color("713b3c"), 3.0)
	draw_line(p + Vector2(0, 22), p + Vector2(13, 15), Color("713b3c"), 3.0)

	var paw_end := p + Vector2(yumi_direction * 58.0, 16)
	draw_line(p + Vector2(yumi_direction * 24.0, 15), paw_end, fur, 14.0, true)
	if yumi_warning_timer > 0.0:
		draw_circle(paw_end, 28.0 + sin(level_time * 24.0) * 4.0, Color(1.0, 0.8, 0.2, 0.18))
		draw_arc(paw_end, 33.0, 0, TAU, 28, Color("ffcf5a"), 4.0, true)
	if yumi_swipe_flash > 0.0:
		for offset in [-12.0, 0.0, 12.0]:
			draw_line(paw_end + Vector2(yumi_direction * 10, offset - 25), paw_end + Vector2(yumi_direction * 36, offset - 16), Color("ffcf5a"), 4.0, true)

	var font := ThemeDB.fallback_font
	if yumi_warning_timer > 0.0:
		draw_string(font, p + Vector2(-20, -96), "!", HORIZONTAL_ALIGNMENT_CENTER, 40, 34, Color("ffcf5a"))
	var yumi_caption := "YUMI" if bool(level_config()["yumi_active"]) else "YUMI · İZLİYOR"
	draw_string(font, p + Vector2(-70, -68), yumi_caption, HORIZONTAL_ALIGNMENT_CENTER, 140, 16, Color("ffd490"))


func draw_shako_launcher() -> void:
	var direction := Vector2(sin(aim_angle), -cos(aim_angle))
	var muzzle := LAUNCH_POS + direction * 58.0
	if not ball_active and game_state == "playing":
		for step in range(1, 7):
			var start := LAUNCH_POS + direction * (72.0 + step * 28.0)
			draw_line(start, start + direction * 13.0, Color(1, 1, 1, 0.28), 3.0, true)

	draw_line(LAUNCH_POS, muzzle, Color("5d7898"), 30.0, true)
	draw_circle(muzzle, 18, Color("9db8cf"))
	var head := LAUNCH_POS + Vector2(0, 18)
	draw_circle(head, 44, Color("a76f45"))
	draw_circle(head + Vector2(-38, -1), 21, Color("68442f"))
	draw_circle(head + Vector2(38, -1), 21, Color("68442f"))
	draw_circle(head + Vector2(-14, -5), 5, Color("0d1b2b"))
	draw_circle(head + Vector2(14, -5), 5, Color("0d1b2b"))
	draw_circle(head + Vector2(0, 12), 7, Color("15243a"))
	var font := ThemeDB.fallback_font
	draw_string(font, head + Vector2(-48, 55), "ŞAKO", HORIZONTAL_ALIGNMENT_CENTER, 96, 16, Color("efc08c"))
	if not ball_active and game_state == "playing" and progress < sequence.size():
		draw_ball(muzzle + direction * 7.0, sequence[progress])


func draw_bark_wave() -> void:
	var phase := 1.0 - bark_flash / 0.48
	for ring in range(3):
		var radius := 54.0 + phase * 150.0 + ring * 24.0
		var alpha := clampf((bark_flash / 0.48) * (0.72 - ring * 0.16), 0.0, 0.8)
		draw_arc(LAUNCH_POS, radius, -2.72, -0.42, 40, Color(0.4, 0.95, 1.0, alpha), 5.0, true)
	var font := ThemeDB.fallback_font
	draw_string(font, LAUNCH_POS + Vector2(-55, -86), "HAV!", HORIZONTAL_ALIGNMENT_CENTER, 110, 28, Color("86f7ff"))


func draw_ball(center: Vector2, type: int) -> void:
	draw_circle(center + Vector2(2, 4), BALL_RADIUS + 2.0, Color(0, 0, 0, 0.35))
	draw_circle(center, BALL_RADIUS, TYPE_COLORS[type])
	draw_arc(center, BALL_RADIUS - 4, 0, TAU, 24, Color(1, 1, 1, 0.55), 2.0, true)
	var font := ThemeDB.fallback_font
	draw_string(font, center + Vector2(-18, 7), TYPE_SYMBOLS[type], HORIZONTAL_ALIGNMENT_CENTER, 36, 21, Color("101b31"))


func rounded_box(color: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	return style
