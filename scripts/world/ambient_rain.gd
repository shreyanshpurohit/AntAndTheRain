extends Node2D

var lines: Array[Vector2] = []
var speeds: Array[float] = []

func _ready() -> void:
    var r := RandomNumberGenerator.new()
    r.seed = 1531
    for i in range(25):
        lines.append(Vector2(r.randf_range(0,320),r.randf_range(24,180)))
        speeds.append(r.randf_range(45,90))

func _process(delta: float) -> void:
    for i in range(lines.size()):
        var p := lines[i]
        p.y += speeds[i] * delta
        if p.y > 182:
            p.y = 24
        lines[i] = p
    queue_redraw()

func _draw() -> void:
    for p in lines:
        draw_rect(Rect2(p.round(),Vector2(1,4)),Color("#91b4db"))
