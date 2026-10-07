extends SceneTree

const ASSETS := ["yumi-idle-v1", "yumi-sleep-v1", "yumi-sleep-v2", "yumi-paw-v1", "shako-idle-v1"]
var failures := 0

func _initialize() -> void:
	for asset in ASSETS:
		var image := Image.load_from_file(ProjectSettings.globalize_path("res://assets/art/characters/%s.png" % asset))
		if image == null or image.is_empty():
			push_error("Missing character asset: " + asset)
			failures += 1
			continue
		check(image.get_width() >= 512 and image.get_height() >= 512, asset + " has enough source resolution")
		for corner in [Vector2i.ZERO, Vector2i(image.get_width() - 1, 0), Vector2i(0, image.get_height() - 1), Vector2i(image.get_width() - 1, image.get_height() - 1)]:
			check(image.get_pixelv(corner).a < 0.01, asset + " has transparent canvas corners")
		var opaque_samples := 0
		var clear_samples := 0
		for y in range(0, image.get_height(), 16):
			for x in range(0, image.get_width(), 16):
				var alpha := image.get_pixel(x, y).a
				if alpha > 0.9:
					opaque_samples += 1
				if alpha < 0.01:
					clear_samples += 1
		check(opaque_samples > 200, asset + " contains an opaque character")
		check(clear_samples > 200, asset + " is a genuine cutout")
	print("Character art smoke tests: %d failures" % failures)
	quit(1 if failures else 0)

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)
