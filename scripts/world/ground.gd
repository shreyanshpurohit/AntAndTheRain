extends Node2D

const SOIL = [preload("res://assets/sprites/dirt_0.png"),preload("res://assets/sprites/dirt_1.png")]

func _draw() -> void:
    for ty in range(6):
        for tx in range(10):
            draw_texture(SOIL[(tx + ty * 3) % 2],Vector2(tx*32, ty*32))
    draw_rect(Rect2(0,22,320,2),Color(0.61568627, 0.41176471, 0.41568627, 1))
