extends SceneTree

var failures := 0

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func _initialize() -> void:
	call_deferred("run_checks")

func run_checks() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.start_level(2)
	game.yumi_warning_timer = 0.24
	var early: Dictionary = game.yumi_paw_motion()
	game.yumi_warning_timer = 0.03
	var late: Dictionary = game.yumi_paw_motion()
	check(Vector2(late.arm).y < Vector2(early.arm).y, "Paw lifts visibly before swipe")
	game.yumi_warning_timer = 0
	game.yumi_swipe_flash = 0.34
	var hit: Dictionary = game.yumi_paw_motion()
	check(Vector2(hit.arm).x > 20 and Vector2(hit.shift).x > 10, "Swipe extends foreleg and lunges body")
	game.yumi_swipe_flash = 0.10
	var recovery: Dictionary = game.yumi_paw_motion()
	check(Vector2(recovery.arm).length() < Vector2(hit.arm).length(), "Paw returns after impact")
	game.yumi_swipe_flash = 0
	check(Vector2(game.yumi_paw_motion().arm) == Vector2.ZERO, "Rest pose has no deformation")
	game.start_level(3)
	game.scatter_state = "scatter"
	game.scatter_timer = 2.2
	game.paw_target_index = 1
	var big_hit: Dictionary = game.yumi_paw_motion()
	check(Vector2(big_hit.arm).length() > Vector2(hit.arm).length(), "Target swipe is bigger than ball swipe")
	var positions: Array = game.hole_positions.duplicate()
	game.hole_visual_position(1)
	game.yumi_paw_motion()
	check(game.hole_positions == positions, "Shake never modifies target physics")
	game.scatter_timer = 1.0
	check(is_zero_approx(float(game.yumi_paw_motion().impact)), "Impact effect is short-lived")
	game.start_level(2)
	game.ball_active = true
	game.ball_position = game.yumi_position + Vector2(30, -20)
	game.ball_velocity = Vector2(0, -500)
	var original: Vector2 = game.yumi_position
	game.deflect_ball_from_yumi()
	check(game.paw_impact_position == game.ball_position and game.yumi_position == original, "Impact point follows ball without moving collision center")
	game.start_level(2)
	check(game.paw_target_index == -1 and game.paw_impact_position == Vector2.ZERO, "Restart clears impact")
	game.free()
	print("Paw smoke: %d failures" % failures)
	quit(1 if failures else 0)
