@tool
class_name PixelTextNode
extends Node2D

const Bitmap = preload("res://scripts/ui/pixel_font.gd")
@export var message := "LABEL":
    set(value):
        message = value
        queue_redraw()
@export var ink := Color(0.98431373, 0.98431373, 0.98431373, 1):
    set(value):
        ink = value
        queue_redraw()
@export_range(1, 3) var pixel_size := 1:
    set(value):
        pixel_size = value
        queue_redraw()
@export_enum("Left", "Center", "Right") var alignment := 0:
    set(value):
        alignment = value
        queue_redraw()

func _draw() -> void:
    var offset := 0
    if alignment == 1:
        offset = -Bitmap.measure(message, pixel_size) / 2
    elif alignment == 2:
        offset = -Bitmap.measure(message, pixel_size)
    Bitmap.paint(self, message, Vector2(offset, 0), ink, pixel_size)
