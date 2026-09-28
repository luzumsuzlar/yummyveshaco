extends Node2D

const SCREEN_SIZE := Vector2(1152.0, 648.0)
const HOLE_Y := 172.0
const HOLE_RADIUS := 54.0
const LAUNCH_POS := Vector2(576.0, 532.0)
const BALL_RADIUS := 21.0
const TYPE_NAMES := ["BALIK", "PATİ", "YUMAK"]
const TYPE_SYMBOLS := ["◆", "●", "✦"]
const TYPE_COLORS := [Color("57d9ff"), Color("ff8b74"), Color("b98cff")]
const TYPE_DARK := [Color("146582"), Color("833b36"), Color("563a84")]

var rng := RandomNumberGenerator.new()
var hole_positions: Array[Vector2] = []
var sequence: Array[int] = []
var progress := 0
var errors := 0
var game_state := "playing"

var aim_angle := 0.0
var ball_active := false
var ball_position := LAUNCH_POS
var ball_velocity := Vector2.ZERO
var ball_type := 0
var ball_swatted := false
var shot_delay := 0.0

var yumi_position := Vector2(300.0, 345.0)
var yumi_direction := 1.0
var yumi_speed := 155.0
var yumi_swipe_flash := 0.0
var status_flash := 0.0

var title_label: Label
var code_label: Label
var status_label: Label
var instruction_label: Label
var next_label: Label
var overlay: ColorRect
var overlay_title: Label
var overlay_subtitle: Label
var restart_button: Button


func _ready() -> void:
	rng.randomize()
	hole_positions = [
		Vector2(310.0, HOLE_Y),
		Vector2(576.0, HOLE_Y),
		Vector2(842.0, HOLE_Y),
	]
	build_interface()
	start_new_game()
	queue_redraw()


func build_interface() -> void:
	title_label = make_label("YUMI & ŞAKO", 28, Color("fff3cf"), Vector2(0, 14), Vector2(1152, 38))
	title_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.55))
	title_label.add_theme_constant_override("shadow_offset_x", 2)
	title_label.add_theme_constant_override("shadow_offset_y", 3)

	code_label = make_label("", 20, Color.WHITE, Vector2(176, 58), Vector2(800, 40))
	status_label = make_label("", 20, Color("fff3cf"), Vector2(176, 438), Vector2(800, 34))
	next_label = make_label("", 18, Color("d8e9ff"), Vector2(420, 474), Vector2(312, 30))
	instruction_label = make_label(
		"Nişan: Fare veya A / D / ← / →     Atış: Boşluk ya da sol tık     Yenile: R",
		15,
		Color("a9bbd3"),
		Vector2(82, 611),
		Vector2(988, 24)
	)

	overlay = ColorRect.new()
	overlay.position = Vector2.ZERO
	overlay.size = SCREEN_SIZE
	overlay.color = Color(0.02, 0.03, 0.06, 0.84)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.z_index = 20
	add_child(overlay)

	overlay_title = make_label("", 42, Color("fff3cf"), Vector2(206, 186), Vector2(740, 62), overlay)
	overlay_subtitle = make_label("", 21, Color("d8e9ff"), Vector2(256, 262), Vector2(640, 82), overlay)
	overlay_subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	restart_button = Button.new()
	restart_button.text = "TEKRAR DENE"
	restart_button.position = Vector2(456, 380)
	restart_button.size = Vector2(240, 62)
	restart_button.add_theme_font_size_override("font_size", 20)
	restart_button.add_theme_color_override("font_color", Color("16233d"))
	restart_button.add_theme_color_override("font_hover_color", Color("16233d"))
	restart_button.add_theme_stylebox_override("normal", button_style(Color("ffcf5a")))
	restart_button.add_theme_stylebox_override("hover", button_style(Color("ffe18e")))
	restart_button.add_theme_stylebox_override("pressed", button_style(Color("eab746")))
	restart_button.pressed.connect(start_new_game)
	overlay.add_child(restart_button)
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


func start_new_game() -> void:
	sequence.clear()
	for index in range(5):
		sequence.append(rng.randi_range(0, TYPE_NAMES.size() - 1))
	progress = 0
	errors = 0
	game_state = "playing"
	ball_active = false
	ball_position = LAUNCH_POS
	ball_velocity = Vector2.ZERO
	ball_swatted = false
	shot_delay = 0.35
	aim_angle = 0.0
	yumi_position = Vector2(300.0, 345.0)
	yumi_direction = 1.0
	status_label.text = "Kilit dizisini tamamla. Yumi'nin patisine dikkat!"
	status_label.add_theme_color_override("font_color", Color("fff3cf"))
	overlay.hide()
	update_interface()
	queue_redraw()


func _process(delta: float) -> void:
	if game_state != "playing":
		return

	shot_delay = maxf(0.0, shot_delay - delta)
	status_flash = maxf(0.0, status_flash - delta)
	yumi_swipe_flash = maxf(0.0, yumi_swipe_flash - delta)

	var keyboard_direction := 0.0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		keyboard_direction -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		keyboard_direction += 1.0
	if keyboard_direction != 0.0 and not ball_active:
		aim_angle = clampf(aim_angle + keyboard_direction * delta * 1.35, -0.78, 0.78)

	move_yumi(delta)
	if ball_active:
		move_ball(delta)
	update_interface()
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			start_new_game()
			return
		if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
			launch_ball()
			return

	if game_state != "playing" or ball_active:
		return

	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseMotion
		var offset: Vector2 = mouse_event.position - LAUNCH_POS
		if offset.y < -20.0:
			aim_angle = clampf(atan2(offset.x, -offset.y), -0.78, 0.78)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		launch_ball()


func launch_ball() -> void:
	if game_state != "playing" or ball_active or shot_delay > 0.0:
		return
	ball_type = sequence[progress]
	ball_position = LAUNCH_POS + Vector2(sin(aim_angle), -cos(aim_angle)) * 50.0
	ball_velocity = Vector2(sin(aim_angle), -cos(aim_angle)) * 520.0
	ball_active = true
	ball_swatted = false
	status_label.text = "%s topu fırlatıldı!" % TYPE_NAMES[ball_type]
	status_label.add_theme_color_override("font_color", TYPE_COLORS[ball_type])


func move_yumi(delta: float) -> void:
	yumi_position.x += yumi_direction * yumi_speed * delta
	if yumi_position.x > 930.0:
		yumi_position.x = 930.0
		yumi_direction = -1.0
	elif yumi_position.x < 222.0:
		yumi_position.x = 222.0
		yumi_direction = 1.0
	yumi_position.y = 348.0 + sin(Time.get_ticks_msec() * 0.003) * 13.0


func move_ball(delta: float) -> void:
	ball_position += ball_velocity * delta

	if ball_position.x < 42.0 + BALL_RADIUS:
		ball_position.x = 42.0 + BALL_RADIUS
		ball_velocity.x = absf(ball_velocity.x) * 0.88
	elif ball_position.x > SCREEN_SIZE.x - 42.0 - BALL_RADIUS:
		ball_position.x = SCREEN_SIZE.x - 42.0 - BALL_RADIUS
		ball_velocity.x = -absf(ball_velocity.x) * 0.88

	if not ball_swatted and ball_position.distance_to(yumi_position) < 67.0:
		var push_direction := signf(ball_position.x - yumi_position.x)
		if push_direction == 0.0:
			push_direction = -yumi_direction
		ball_velocity.x += push_direction * 355.0
		ball_velocity.y *= 0.94
		ball_swatted = true
		yumi_swipe_flash = 0.32
		status_label.text = "Yumi topa pati attı!"
		status_label.add_theme_color_override("font_color", Color("ffcf5a"))

	if ball_position.y <= HOLE_Y + 14.0:
		resolve_hole_hit()
	elif ball_position.y > SCREEN_SIZE.y + 40.0:
		register_error("Top oyun alanından çıktı!")


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
		progress += 1
		ball_active = false
		shot_delay = 0.45
		status_flash = 0.38
		if progress >= sequence.size():
			finish_game(true)
		else:
			status_label.text = "TAK! Parça yerine oturdu."
			status_label.add_theme_color_override("font_color", Color("86f7a8"))
	else:
		register_error("Yanlış delik! Kilitte çatlak oluştu.")


func register_error(message: String) -> void:
	ball_active = false
	shot_delay = 0.55
	errors += 1
	status_flash = 0.5
	status_label.text = message
	status_label.add_theme_color_override("font_color", Color("ff746f"))
	if errors >= 3:
		finish_game(false)


func finish_game(success: bool) -> void:
	ball_active = false
	overlay.show()
	if success:
		game_state = "success"
		overlay_title.text = "KİLİT AÇILDI!"
		overlay_title.add_theme_color_override("font_color", Color("86f7a8"))
		overlay_subtitle.text = "Şako diziyi tamamladı. Yumi ise hiçbir şey olmamış gibi davranıyor."
		restart_button.text = "YENİ KİLİT"
	else:
		game_state = "failed"
		overlay_title.text = "KİLİT SIKIŞTI!"
		overlay_title.add_theme_color_override("font_color", Color("ff746f"))
		overlay_subtitle.text = "Yumi: 😼     Şako: 😵\nBir dokunuşla hemen yeniden dene."
		restart_button.text = "TEKRAR DENE"
	queue_redraw()


func update_interface() -> void:
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


func _draw() -> void:
	draw_background()
	draw_lock_panel()
	draw_holes()
	draw_yumi()
	draw_shako_launcher()
	if ball_active:
		draw_ball(ball_position, ball_type)


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
	draw_style_box(rounded_box(panel_color, 20), Rect2(150, 50, 852, 54))
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
	# Gövde ve kuyruk
	draw_arc(p + Vector2(43, 30), 38, -1.4, 1.4, 24, fur_dark, 12.0, true)
	draw_circle(p + Vector2(0, 28), 38, fur)
	# Kulaklar
	draw_colored_polygon(PackedVector2Array([p + Vector2(-34, -28), p + Vector2(-15, -58), p + Vector2(-5, -25)]), fur)
	draw_colored_polygon(PackedVector2Array([p + Vector2(34, -28), p + Vector2(15, -58), p + Vector2(5, -25)]), fur)
	draw_circle(p, 42, fur)
	# Gözler ve sırıtış
	draw_circle(p + Vector2(-14, -5), 5, Color("122038"))
	draw_circle(p + Vector2(14, -5), 5, Color("122038"))
	draw_line(p + Vector2(-11, 17), p + Vector2(0, 22), Color("713b3c"), 3.0)
	draw_line(p + Vector2(0, 22), p + Vector2(13, 15), Color("713b3c"), 3.0)
	# Pati
	var paw_end := p + Vector2(yumi_direction * 58.0, 16)
	draw_line(p + Vector2(yumi_direction * 24.0, 15), paw_end, fur, 14.0, true)
	if yumi_swipe_flash > 0.0:
		for offset in [-12.0, 0.0, 12.0]:
			draw_line(paw_end + Vector2(yumi_direction * 10, offset - 25), paw_end + Vector2(yumi_direction * 36, offset - 16), Color("ffcf5a"), 4.0, true)
	var font := ThemeDB.fallback_font
	draw_string(font, p + Vector2(-45, 82), "YUMI", HORIZONTAL_ALIGNMENT_CENTER, 90, 16, Color("ffd490"))


func draw_shako_launcher() -> void:
	var direction := Vector2(sin(aim_angle), -cos(aim_angle))
	var muzzle := LAUNCH_POS + direction * 58.0
	# Nişan çizgisi
	if not ball_active and game_state == "playing":
		for step in range(1, 7):
			var start := LAUNCH_POS + direction * (72.0 + step * 28.0)
			draw_line(start, start + direction * 13.0, Color(1, 1, 1, 0.28), 3.0, true)
	# Fırlatıcı
	draw_line(LAUNCH_POS, muzzle, Color("5d7898"), 30.0, true)
	draw_circle(muzzle, 18, Color("9db8cf"))
	# Şako'nun kafası
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
