class_name StormSystem
extends Node2D

signal impact(at: Vector2, radius: float)

const DROP_SCENE = preload("res://scenes/world/rain_drop.tscn")
var active := false
var elapsed := 0.0
var countdown := 1.0
var follow_target := Vector2(160, 108)

func reset_rain() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	active = true
	elapsed = 0.0
	countdown = 0.8
	for drop in get_children():
		drop.set_process(false)
		drop.queue_free()

func freeze_rain() -> void:
	active = false
	process_mode = Node.PROCESS_MODE_DISABLED

func unfreeze_rain() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	active = true

func stop_rain() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	active = false
	for drop in get_children():
		drop.set_process(false)
		drop.queue_free()

func _process(delta: float) -> void:
	if not active:
		return
	elapsed += delta
	countdown -= delta
	if countdown <= 0.0:
		_spawn()
		countdown = maxf(0.36,1.1-elapsed*0.012) + randf_range(-0.07,0.07)

func _spawn() -> void:
	var drop: RainHazard = DROP_SCENE.instantiate()
	var spot := Vector2(randf_range(20,300),randf_range(45,160))
	if randf() < 0.52:
		spot = follow_target + Vector2(randf_range(-34,34),randf_range(-30,30))
	drop.position = Vector2(clampf(spot.x,18,302),clampf(spot.y,41,162)).round()
	drop.warning_time = maxf(0.55, 1.15-elapsed*0.010)
	add_child(drop)
	drop.impact.connect(_relay)

func _relay(at: Vector2, radius: float) -> void:
	if active:
		impact.emit(at,radius)
