class_name AntPlayer
extends CharacterBody2D

const SPEED := 86.0
const WALK = [preload("res://assets/sprites/ant_walk_0.png"), preload("res://assets/sprites/ant_walk_1.png")]
@onready var sprite: Sprite2D = $Sprite2D
var enabled := false
var walk_clock := 0.0
var pointing := false
var waypoint := Vector2.ZERO

func reset_ant() -> void:
	position = Vector2(160, 108)
	rotation = 0.0
	walk_clock = 0.0
	pointing = false
	velocity = Vector2.ZERO
	enabled = true
	sprite.texture = WALK[0]
	sprite.visible = true

func set_sheltered(under_leaf: bool) -> void:
	sprite.visible = not under_leaf

func set_waypoint(point: Vector2, pressed: bool) -> void:
	waypoint = point
	pointing = pressed

func _physics_process(delta: float) -> void:
	if not enabled:
		velocity = Vector2.ZERO
		return
	var d := Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if Input.is_key_pressed(KEY_W): d.y -= 1.0
	if Input.is_key_pressed(KEY_S): d.y += 1.0
	if Input.is_key_pressed(KEY_A): d.x -= 1.0
	if Input.is_key_pressed(KEY_D): d.x += 1.0
	if d.length_squared() < 0.001 and pointing:
		var towards := waypoint - position
		if towards.length() > 3.0:
			d = towards.normalized()
	d = d.normalized()
	velocity = d * SPEED
	move_and_slide()
	position.x = clampf(position.x, 12.0, 308.0)
	position.y = clampf(position.y, 38.0, 164.0)
	if not d.is_zero_approx():
		rotation = d.angle() + PI/2.0
		walk_clock += delta * 9.0
		sprite.texture = WALK[int(walk_clock) % 2]
	else:
		sprite.texture = WALK[0]
