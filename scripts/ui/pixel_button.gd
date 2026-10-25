@tool
class_name PixelButton
extends Control

signal pressed

const Bitmap = preload("res://scripts/ui/pixel_font.gd")
@export var caption := "PLAY":
	set(value):
		caption = value
		queue_redraw()
@export var fill := Color(0.43137255, 0.63137255, 0.43137255, 1)
var hovering := false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func _mouse_entered() -> void:
	hovering = true
	queue_redraw()

func _mouse_exited() -> void:
	hovering = false
	queue_redraw()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		accept_event()
		pressed.emit()
	if event is InputEventScreenTouch and event.pressed:
		accept_event()
		pressed.emit()

func _draw() -> void:
	var size_px := Vector2i(size)
	if size_px.x <= 0 or size_px.y <= 0:
		return
	var border := Color(0.17647059, 0.15294118, 0.18431373, 1)
	var face := Color(0.59215686, 0.85882353, 0.56862745, 1) if hovering else fill
	draw_rect(Rect2(Vector2.ZERO, size), border)
	draw_rect(Rect2(Vector2(2, 2), size - Vector2(4, 4)), face)
	draw_rect(Rect2(Vector2(4, 4), Vector2(size.x - 8, 2)), Color("#dbd991"))
	var x := roundi((size.x - Bitmap.measure(caption, 1)) / 2.0)
	var y := roundi((size.y - 7.0) / 2.0)
	Bitmap.paint(self, caption, Vector2(x, y), border)
