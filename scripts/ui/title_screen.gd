class_name TitleView
extends Control

signal start_requested

@onready var start_button: PixelButton = $StartButton

func _ready() -> void:
	start_button.pressed.connect(func(): start_requested.emit())

func _draw() -> void:
	# Restrained flat pixel-art title. No fake showcase or decorative sprites.
	draw_rect(Rect2(0, 0, 320, 180), Color("#2d272f"))
	draw_rect(Rect2(0, 170, 320, 10), Color("#524d4a"))
	draw_rect(Rect2(0, 169, 320, 1), Color("#dbaf91"))
