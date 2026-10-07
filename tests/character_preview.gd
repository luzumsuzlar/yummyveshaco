extends SceneTree

class Preview extends Node2D:
	const NAMES := ["Yumi", "Yumi · uyku", "Yumi · pati", "Şako"]
	const FILES := ["yumi-idle-v1", "yumi-sleep-v2", "yumi-paw-v1", "shako-idle-v1"]
	var textures: Array[Texture2D] = []

	func _ready() -> void:
		for asset in FILES:
			textures.append(load("res://assets/art/characters/%s.png" % asset) as Texture2D)

	func _draw() -> void:
		draw_rect(Rect2(0, 0, 540, 960), Color("f5e2bf"))
		draw_string(ThemeDB.fallback_font, Vector2(20, 40), "YUMI & ŞAKO · İLK POZLAR", HORIZONTAL_ALIGNMENT_CENTER, 500, 25, Color("54321f"))
		for index in range(textures.size()):
			var origin := Vector2(20 + (index % 2) * 260, 64 + (index / 2) * 212)
			draw_rect(Rect2(origin, Vector2(240, 204)), Color("fff2db"))
			draw_texture_rect(textures[index], Rect2(origin + Vector2(30, 3), Vector2(180, 180)), false)
			draw_string(ThemeDB.fallback_font, origin + Vector2(0, 198), NAMES[index], HORIZONTAL_ALIGNMENT_CENTER, 240, 18, Color("54321f"))
		draw_string(ThemeDB.fallback_font, Vector2(20, 750), "100 piksel boyda okunabilirlik", HORIZONTAL_ALIGNMENT_CENTER, 500, 20, Color("54321f"))
		for index in range(textures.size()):
			draw_texture_rect(textures[index], Rect2(5 + index * 106, 772, 100, 100), false)
		draw_string(ThemeDB.fallback_font, Vector2(20, 920), "Ayrı pozlar · henüz akıcı animasyon değil", HORIZONTAL_ALIGNMENT_CENTER, 500, 17, Color("54321f"))

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	root.content_scale_size = Vector2i(540, 960)
	root.size = Vector2i(540, 960)
	root.add_child(Preview.new())
	await process_frame
	await RenderingServer.frame_post_draw
	DirAccess.make_dir_recursive_absolute("res://exports")
	var result := root.get_texture().get_image().save_png("res://exports/character-preview.png")
	print("Character preview: ", result)
	quit(0 if result == OK else 1)
