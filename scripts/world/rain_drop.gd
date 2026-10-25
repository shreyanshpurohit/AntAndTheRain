class_name RainHazard
extends Node2D

signal impact(at: Vector2, radius: float)

const WARNINGS = [preload("res://assets/sprites/warning_0.png"), preload("res://assets/sprites/warning_1.png")]
const SPLASHES = [preload("res://assets/sprites/splash_0.png"), preload("res://assets/sprites/splash_1.png"), preload("res://assets/sprites/splash_2.png")]

@onready var warning: Sprite2D = $Warning
@onready var falling: Sprite2D = $Falling
@onready var splash: Sprite2D = $Splash

var age := 0.0
var warning_time := 1.15
var landed := false

func _ready() -> void:
    warning.texture = WARNINGS[0]
    falling.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    falling.position = Vector2(0, -12)
    splash.hide()

func _process(delta: float) -> void:
    age += delta
    if not landed:
        var progress := clampf(age / warning_time, 0.0, 1.0)
        warning.texture = WARNINGS[int(age * 8.0) % 2]
        # Top-down circular droplet, approaching the warning spot.
        falling.position = Vector2(0, -12.0 * (1.0 - progress))
        falling.scale = Vector2.ONE * (0.55 + 0.45 * progress)
        if age >= warning_time:
            landed = true
            warning.hide()
            falling.hide()
            splash.show()
            impact.emit(global_position, 16.5)
    else:
        var frame := int((age - warning_time) / 0.10)
        if frame >= SPLASHES.size():
            queue_free()
        else:
            splash.texture = SPLASHES[frame]
