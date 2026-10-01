extends Node2D

const SCREEN_SIZE := Vector2(540.0, 960.0)
const HOLE_Y := 250.0
const HOLE_RADIUS := 48.0
const HOLE_BASE_X := [116.0, 270.0, 424.0]
const LAUNCH_POS := Vector2(270.0, 790.0)
const BALL_RADIUS := 18.0
const YUMI_HOME := Vector2(180.0, 510.0)
const YUMI_MIN_X := 100.0
const YUMI_MAX_X := 440.0
const AIM_AREA := Rect2(24, 172, 492, 686)
const WALL_LEFT := 24.0 + BALL_RADIUS
const WALL_RIGHT := SCREEN_SIZE.x - 24.0 - BALL_RADIUS
const GOAL_LINE := HOLE_Y + 14.0
const TYPE_NAMES := ["BALIK", "PATİ", "YUMAK"]
const TYPE_SYMBOLS := ["◆", "●", "✦"]
const TYPE_COLORS := [Color("57d9ff"), Color("ff8b74"), Color("b98cff")]
const TYPE_DARK := [Color("146582"), Color("833b36"), Color("563a84")]

const LEVELS := [
	{
		"name": "1 · MAMA DOLABI",
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
var stage_index := 0
var stage_rotation := 0.0
var stage_from_positions: Array[Vector2] = []
var errors := 0
var game_state := "playing"

var aim_angle := 0.0
var last_pointer_position := Vector2(270.0, HOLE_Y)
var active_touch_index := -1
var touch_can_launch := false
var ball_active := false
var ball_position := LAUNCH_POS
var ball_velocity := Vector2.ZERO
var ball_type := 0
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

var yumi_position := YUMI_HOME
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
var time_label: Label
var story_label: Label
var overlay: ColorRect
var overlay_title: Label
var overlay_subtitle: Label
var overlay_button: Button
var launch_button: Button
var bark_button: Button
var restart_button: Button


func _ready() -> void:
	rng.randomize()
	for x_position in HOLE_BASE_X:
		hole_positions.append(Vector2(float(x_position), HOLE_Y))
	build_interface()
	var initial_level := 0
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--level="):
			initial_level = clampi(argument.trim_prefix("--level=").to_int() - 1, 0, LEVELS.size() - 1)
	start_level(initial_level)
	queue_redraw()


func build_interface() -> void:
	title_label = make_label("YUMI & ŞAKO", 30, Color("fff3cf"), Vector2(24, 24), Vector2(420, 40))
	title_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.55))
	title_label.add_theme_constant_override("shadow_offset_x", 2)
	title_label.add_theme_constant_override("shadow_offset_y", 3)

	level_label = make_label("", 17, Color("8fa8c4"), Vector2(28, 76), Vector2(306, 30))
	level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	code_label = make_label("", 18, Color.WHITE, Vector2(28, 114), Vector2(404, 34))
	time_label = make_label("", 15, Color("a9bbd3"), Vector2(358, 76), Vector2(154, 30))
	status_label = make_label("", 19, Color("fff3cf"), Vector2(28, 638), Vector2(484, 72))
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	next_label = make_label("", 17, Color("d8e9ff"), Vector2(28, 778), Vector2(156, 64))
	ability_label = make_label("", 15, Color("86f7a8"), Vector2(354, 778), Vector2(162, 64))
	ability_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	story_label = make_label("", 15, Color("efc08c"), Vector2(28, 154), Vector2(484, 26))
	instruction_label = make_label(
		"Sürükle, bırak: atış · HAV!: müdahale",
		14,
		Color("a9bbd3"),
		Vector2(24, 940),
		Vector2(492, 18)
	)
	launch_button = make_action_button("AT!", Vector2(28, 870), Vector2(224, 64), Color("57d9ff"))
	launch_button.pressed.connect(launch_ball)
	bark_button = make_action_button("HAV!  3/3", Vector2(288, 870), Vector2(224, 64), Color("ffcf5a"))
	bark_button.pressed.connect(func(): use_bark(last_pointer_position.x))
	restart_button = make_action_button("↻", Vector2(456, 24), Vector2(56, 48), Color("b2c6df"))
	restart_button.pressed.connect(func(): start_level(level_index))

	overlay = ColorRect.new()
	overlay.position = Vector2.ZERO
	overlay.size = SCREEN_SIZE
	overlay.color = Color(0.02, 0.03, 0.06, 0.86)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.z_index = 20
	add_child(overlay)

	overlay_title = make_label("", 32, Color("fff3cf"), Vector2(30, 290), Vector2(480, 100), overlay)
	overlay_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	overlay_subtitle = make_label("", 20, Color("d8e9ff"), Vector2(40, 408), Vector2(460, 210), overlay)
	overlay_subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
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
	overlay.hide()


func make_action_button(text: String, position: Vector2, size: Vector2, color: Color) -> Button:
	var button := Button.new()
	button.text = text
	button.position = position
	button.size = size
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 22)
	button.add_theme_color_override("font_color", Color("16233d"))
	button.add_theme_color_override("font_hover_color", Color("16233d"))
	button.add_theme_color_override("font_pressed_color", Color("16233d"))
	button.add_theme_stylebox_override("normal", button_style(color))
	button.add_theme_stylebox_override("hover", button_style(color.lightened(0.15)))
	button.add_theme_stylebox_override("pressed", button_style(color.darkened(0.12)))
	button.add_theme_stylebox_override("disabled", button_style(Color("33465e")))
	add_child(button)
	return button


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
	stage_index = 0
	stage_rotation = 0.0
	stage_from_positions.clear()
	errors = 0
	level_time = 0.0
	game_state = "playing"
	ball_active = false
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
	shot_delay = 0.35
	aim_angle = 0.0
	active_touch_index = -1
	touch_can_launch = false
	last_pointer_position = Vector2(LAUNCH_POS.x, HOLE_Y)
	yumi_position = YUMI_HOME
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
	story_label.text = "AMAÇ: MAMA DOLABINI AÇ"
	status_label.show()
	next_label.show()
	ability_label.show()
	launch_button.show()
	bark_button.show()
	status_label.text = str(config["intro"])
	status_label.add_theme_color_override("font_color", Color("fff3cf"))
	overlay.hide()
	update_holes()
	update_interface()
	queue_redraw()


func _process(delta: float) -> void:
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

	level_time += delta
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
	if keyboard_direction != 0.0 and not ball_active:
		aim_angle = clampf(aim_angle + keyboard_direction * delta * 1.35, -aim_limit(), aim_limit())
		last_pointer_position = Vector2(LAUNCH_POS.x + tan(aim_angle) * (LAUNCH_POS.y - HOLE_Y), HOLE_Y)

	update_holes()
	move_yumi(delta)
	if ball_active:
		move_ball(delta)
	update_interface()
	queue_redraw()


func _input(event: InputEvent) -> void:
	# A release over a GUI button must cancel, not leave an old drag armed.
	if event is InputEventScreenTouch and event.index == active_touch_index and not event.pressed:
		if event.canceled or not AIM_AREA.has_point(event.position) or game_state != "playing":
			active_touch_index = -1
			touch_can_launch = false


func _unhandled_input(event: InputEvent) -> void:
	# GUI buttons use emulated clicks; the playfield handles native touch once.
	if event is InputEventMouse and event.device == InputEvent.DEVICE_ID_EMULATION:
		return
	if event is InputEventScreenTouch:
		handle_touch(event)
		return
	if event is InputEventScreenDrag:
		if game_state == "playing" and event.index == active_touch_index and AIM_AREA.has_point(event.position):
			last_pointer_position = event.position
			if not ball_active:
				update_mouse_aim(last_pointer_position)
		return
	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseMotion
		if not AIM_AREA.has_point(mouse_event.position):
			return
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
	if not mouse_button.pressed or not AIM_AREA.has_point(mouse_button.position):
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


func handle_touch(event: InputEventScreenTouch) -> void:
	if game_state != "playing":
		return
	if event.pressed:
		if active_touch_index != -1 or not AIM_AREA.has_point(event.position):
			return
		active_touch_index = event.index
		touch_can_launch = not ball_active
		last_pointer_position = event.position
		if not ball_active:
			update_mouse_aim(last_pointer_position)
	elif event.index == active_touch_index:
		active_touch_index = -1
		var should_launch := touch_can_launch
		touch_can_launch = false
		if should_launch and not event.canceled and AIM_AREA.has_point(event.position) and not ball_active:
			last_pointer_position = event.position
			update_mouse_aim(last_pointer_position)
			launch_ball()


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


func launch_ball() -> void:
	if game_state != "playing" or ball_active or shot_delay > 0.0 or stage_rotation > 0.0:
		return
	touch_can_launch = false
	ball_type = sequence[progress]
	var direction := Vector2(sin(aim_angle), -cos(aim_angle))
	ball_position = LAUNCH_POS + direction * 50.0
	ball_velocity = direction * float(level_config().get("ball_speed", 520.0))
	ball_active = true
	ball_swatted = false
	ball_deflected_by_yumi = false
	wall_bounces = 0
	bark_available = barks_left > 0
	yumi_warning_timer = 0.0
	yumi_warning_started = false
	status_label.text = "%s topu yolda." % TYPE_NAMES[ball_type]
	if yumi_is_active() and ball_type == 2:
		status_label.text = "Yumi: O yumak benim! Ünlemi bekle, gerekirse HAV!"
	status_label.add_theme_color_override("font_color", TYPE_COLORS[ball_type])


func use_bark(target_x: float) -> void:
	if game_state != "playing" or not ball_active or not bark_available:
		return
	bark_available = false
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
	status_label.add_theme_color_override("font_color", Color("86f7a8"))


func update_holes() -> void:
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


func move_yumi(delta: float) -> void:
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
		if ball_velocity.y < 0.0:
			goal_time = maxf(0.0, (GOAL_LINE - ball_position.y) / ball_velocity.y)
		var travel_time := minf(remaining, minf(side_time, goal_time))
		ball_position += ball_velocity * travel_time
		remaining -= travel_time
		if goal_time <= side_time and goal_time <= travel_time:
			resolve_hole_hit()
			return
		if side_time <= travel_time:
			var bounce_limit := int(level_config().get("max_wall_bounces", 0))
			if wall_bounces >= bounce_limit:
				register_error("İki sekme hakkı bitti!" if bounce_limit > 0 else "Top kilit kanalının dışına çıktı!")
				return
			wall_bounces += 1
			wall_flash = 0.28
			wall_flash_position = ball_position
			ball_velocity.x = -ball_velocity.x
			status_label.text = "TAK! Duvar sekmesi: %d/2" % wall_bounces
			status_label.add_theme_color_override("font_color", Color("ffcf5a"))
		if ball_position.y > SCREEN_SIZE.y + 40.0:
			register_error("Top oyun alanından çıktı!")
			return


func update_yumi_attack(delta: float) -> void:
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
				status_label.add_theme_color_override("font_color", Color("86f7a8"))
		return

	if not yumi_warning_started and ball_position.distance_to(yumi_position) < 178.0:
		yumi_warning_started = true
		yumi_warning_timer = float(level_config().get("warning_time", 0.24))
		status_label.text = "Yumi hazırlanıyor! Şimdi HAV! diyebilirsin."
		status_label.add_theme_color_override("font_color", Color("ffcf5a"))


func yumi_is_active() -> bool:
	if level_index == 0:
		return progress >= 4
	if level_index == 1:
		return stage_index >= 2
	return bool(level_config()["yumi_active"])


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
		if wall_bounces < required_wall_bounces():
			register_error("Doğru delik, ama en az %d duvar sekmesi gerekiyor!" % required_wall_bounces())
			return
		var lucky_yumi_goal := ball_deflected_by_yumi
		if lucky_yumi_goal:
			yumi_help_count += 1
		progress += 1
		ball_active = false
		bark_available = false
		shot_delay = 0.45
		status_flash = 0.38
		if progress >= sequence.size():
			finish_game(true)
		elif int(level_config().get("stage_size", 0)) > 0 and progress % int(level_config()["stage_size"]) == 0:
			stage_from_positions.assign(hole_positions)
			stage_index += 1
			stage_rotation = 1.2
			shot_delay = 1.2
			status_label.text = "TAK! Kasa dönüyor. Yeni hedef düzenini incele."
			if level_index == 0 and stage_index == 1:
				status_label.text = "Yumi uyandı! Yumağı istiyor. Ünlemde havla: %d hakkın var." % barks_left
			elif level_index == 0 and stage_index == 2:
				status_label.text = "Son kilit! Yumi'yi oku, kalan havlamalarını dikkatli kullan."
			elif level_index == 1 and stage_index == 1:
				status_label.text = "Şimdi iki duvar! Her hedefe 2 sekmeyle ulaş. Nişan çizgisini izle."
			elif level_index == 1 and stage_index == 2:
				status_label.text = "Yumi uyandı! En az 1 sekme yap; pati uyarısında HAV! kullan."
			status_label.add_theme_color_override("font_color", Color("ffcf5a"))
		else:
			status_label.text = "Yumi yanlışlıkla yardım etti! " + progress_hint() if lucky_yumi_goal else progress_hint()
			status_label.add_theme_color_override("font_color", Color("86f7a8"))
	else:
		var error_message := "Yumi topu yanlış deliğe sektirdi!" if ball_deflected_by_yumi else "Yanlış delik! Kilitte çatlak oluştu."
		register_error(error_message)


func progress_hint() -> String:
	if level_index == 0:
		return "Parça oturdu! Sıradaki hedef: %s." % TYPE_NAMES[sequence[progress]]
	if level_index == 1:
		return "Parça oturdu! En az %d sekme; %s hedefle." % [required_wall_bounces(), TYPE_NAMES[sequence[progress]]]
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
	active_touch_index = -1
	touch_can_launch = false
	ball_active = false
	bark_available = false
	yumi_warning_timer = 0.0
	if success:
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
			overlay_subtitle.text = "Üç bölümlük prototip tamamlandı. Şako kilidi açtı; Yumi hâlâ masum görünüyor."
			overlay_button.text = "BAŞA DÖN"
	else:
		game_state = "failed"
		overlay.show()
		overlay_title.text = "KİLİT SIKIŞTI!"
		overlay_title.add_theme_color_override("font_color", Color("ff746f"))
		overlay_subtitle.text = "Yumi: 😼     Şako: 😵\nAynı bölümü hemen yeniden deneyebilirsin."
		overlay_button.text = "TEKRAR DENE"
	overlay_subtitle.text += "\nGeçen süre: %.1f saniye · Doğru atış: %d/%d" % [level_time, progress, sequence.size()]
	overlay_subtitle.text += "\nKalan havlama: %d · Yumi'nin yardımı: %d" % [barks_left, yumi_help_count]
	update_interface()
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
			code_text += "[%s]  " % TYPE_SYMBOLS[sequence[index]]
		else:
			code_text += "%s  " % TYPE_SYMBOLS[sequence[index]]
	code_label.text = code_text + "  %d/%d" % [progress, sequence.size()]
	launch_button.disabled = game_state != "playing" or ball_active or shot_delay > 0.0 or stage_rotation > 0.0
	bark_button.disabled = game_state != "playing" or not ball_active or not bark_available
	bark_button.text = "HAV!  %d/3" % barks_left

	if game_state == "playing" and progress < sequence.size():
		if level_index == 1:
			story_label.text = "HEDEF: EN AZ %d SEKME + DOĞRU DELİK" % required_wall_bounces()
		next_label.text = "Sıradaki:\n%s  %s" % [TYPE_SYMBOLS[sequence[progress]], TYPE_NAMES[sequence[progress]]]
		next_label.add_theme_color_override("font_color", TYPE_COLORS[sequence[progress]])
		if stage_rotation > 0.0:
			ability_label.text = "KASA DÖNÜYOR..."
			ability_label.add_theme_color_override("font_color", Color("ffcf5a"))
		elif ball_active:
			ability_label.text = "HAV! düğmesi / E" if bark_available else "Bu atışta HAV yok"
			ability_label.add_theme_color_override("font_color", Color("86f7a8") if bark_available else Color("7b8da4"))
		else:
			ability_label.text = "Kalan HAV: %d/3" % barks_left
			ability_label.add_theme_color_override("font_color", Color("8fa8c4"))
		if level_index == 1 and stage_rotation <= 0.0:
			ability_label.text = "SEKME: %d/2\nKalan HAV: %d" % [wall_bounces if ball_active else 0, barks_left]


func _draw() -> void:
	draw_background()
	draw_cupboard()
	draw_lock_panel()
	draw_holes()
	draw_yumi()
	draw_shako_launcher()
	if ball_active:
		draw_ball(ball_position, ball_type)
	if bark_flash > 0.0:
		draw_bark_wave()
	if wall_flash > 0.0:
		draw_arc(wall_flash_position, 22.0 + (0.28 - wall_flash) * 90.0, 0, TAU, 24, Color(1, 0.8, 0.3, wall_flash / 0.28), 4.0, true)


func draw_cupboard() -> void:
	draw_style_box(rounded_box(Color("3b2b27"), 16), Rect2(42, 196, 456, 136))
	draw_line(Vector2(270, 200), Vector2(270, 326), Color("705044"), 4.0)
	if game_state == "celebrating" or game_state == "success":
		var opening := clampf(celebration_time / 0.4, 0.0, 1.0)
		draw_rect(Rect2(154, 400, 232, 102), Color("2c211e"))
		draw_rect(Rect2(154 - opening * 50, 400, 46, 102), Color("75513a"))
		draw_rect(Rect2(340 + opening * 50, 400, 46, 102), Color("75513a"))
		draw_colored_polygon(PackedVector2Array([Vector2(236, 465), Vector2(304, 465), Vector2(293, 491), Vector2(247, 491)]), Color("ffcf5a"))
		for crumb in range(5):
			draw_circle(Vector2(244 + crumb * 12, 465), 6, Color("a76f45"))


func draw_background() -> void:
	draw_rect(Rect2(Vector2.ZERO, SCREEN_SIZE), Color("081326"))
	draw_circle(Vector2(42, 200), 160, Color("10294a"))
	draw_circle(Vector2(516, 816), 210, Color("182348"))
	for y in range(350, 858, 40):
		draw_line(Vector2(24, y), Vector2(516, y), Color(0.18, 0.28, 0.42, 0.12), 1.0)
	var wall_color := Color("ffcf5a") if level_index == 1 else Color("294868")
	draw_line(Vector2(24, 184), Vector2(24, 858), wall_color, 4.0)
	draw_line(Vector2(516, 184), Vector2(516, 858), wall_color, 4.0)


func draw_lock_panel() -> void:
	var panel_color := Color("12243e")
	if status_flash > 0.0:
		panel_color = Color("25445a") if errors < 3 else Color("5b2730")
	draw_style_box(rounded_box(panel_color, 20), Rect2(18, 70, 504, 84))
	for index in range(3):
		var warning_color := Color("ff645f") if index < errors else Color("263a55")
		draw_circle(Vector2(454 + index * 22, 130), 6.0, warning_color)


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
	var sleeping := not yumi_is_active() and game_state == "playing"
	if sleeping:
		fur = Color("b9956e")
		fur_dark = Color("765948")

	draw_arc(p + Vector2(43, 30), 38, -1.4, 1.4, 24, fur_dark, 12.0, true)
	draw_circle(p + Vector2(0, 28), 38, fur)
	draw_colored_polygon(PackedVector2Array([p + Vector2(-34, -28), p + Vector2(-15, -58), p + Vector2(-5, -25)]), fur)
	draw_colored_polygon(PackedVector2Array([p + Vector2(34, -28), p + Vector2(15, -58), p + Vector2(5, -25)]), fur)
	draw_circle(p, 42, fur)
	if sleeping:
		draw_arc(p + Vector2(-14, -8), 7, 0, PI, 12, Color("122038"), 3.0, true)
		draw_arc(p + Vector2(14, -8), 7, 0, PI, 12, Color("122038"), 3.0, true)
	else:
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
	var yumi_caption := "YUMI · Zzz" if sleeping else "YUMI"
	if yumi_is_active() and ball_active and ball_type == 2 and not ball_swatted:
		yumi_caption = "YUMAK BENİM!"
	if game_state == "celebrating":
		yumi_caption = "BEN Mİ?" if yumi_help_count > 0 and celebration_time < 0.5 else "MAMA!"
	draw_string(font, p + Vector2(-70, -68), yumi_caption, HORIZONTAL_ALIGNMENT_CENTER, 140, 16, Color("ffd490"))


func draw_shako_launcher() -> void:
	if game_state == "celebrating" or game_state == "success":
		draw_shako_face(celebration_shako_position, true)
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
					draw_circle(segment_start.lerp(segment_end, float(distance) / length), 3.0, Color(1, 0.9, 0.6, 0.45))
		else:
			for step in range(1, 7):
				var start := LAUNCH_POS + direction * (72.0 + step * 28.0)
				draw_line(start, start + direction * 13.0, Color(1, 1, 1, 0.28), 3.0, true)

	draw_line(LAUNCH_POS, muzzle, Color("5d7898"), 30.0, true)
	draw_circle(muzzle, 18, Color("9db8cf"))
	draw_shako_face(LAUNCH_POS + Vector2(0, 18))
	if not ball_active and game_state == "playing" and progress < sequence.size():
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


func draw_shako_face(head: Vector2, celebrating: bool = false) -> void:
	draw_circle(head, 44, Color("a76f45"))
	draw_circle(head + Vector2(-38, -1), 21, Color("68442f"))
	draw_circle(head + Vector2(38, -1), 21, Color("68442f"))
	draw_circle(head + Vector2(-14, -5), 5, Color("0d1b2b"))
	draw_circle(head + Vector2(14, -5), 5, Color("0d1b2b"))
	draw_circle(head + Vector2(0, 12), 7, Color("15243a"))
	var font := ThemeDB.fallback_font
	var caption := "ŞAKO"
	if celebrating:
		caption = "YUMI?!" if yumi_help_count > 0 and celebration_time < 0.5 else "MAMA!"
	draw_string(font, head + Vector2(-48, 55), caption, HORIZONTAL_ALIGNMENT_CENTER, 96, 16, Color("efc08c"))


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
