class_name LeafShelter
extends Node2D

const DAMAGE_TEXTURES = [
    preload("res://assets/sprites/leaf_0.png"),
    preload("res://assets/sprites/leaf_1.png"),
    preload("res://assets/sprites/leaf_2.png"),
    preload("res://assets/sprites/leaf_3.png")
]

@onready var sprite: Sprite2D = $Sprite2D
var durability: int = 3

func reset_leaf() -> void:
    durability = 3
    _refresh_sprite()

func protects(world_point: Vector2) -> bool:
    if durability <= 0:
        return false
    var p := to_local(world_point)
    # The ant's *center* must enter the central covered part of the leaf.
    # The player sprite disappears while sheltered to avoid protruding through the canopy.
    return absf(p.x) <= 13.0 and p.y >= -5.0 and p.y <= 6.0

func touches_splash(world_point: Vector2) -> bool:
    if durability <= 0:
        return false
    var p := to_local(world_point)
    return absf(p.x) <= 29.0 and absf(p.y) <= 20.0

func soak() -> void:
    if durability > 0:
        durability -= 1
        _refresh_sprite()

func _ready() -> void:
    _refresh_sprite()

func _refresh_sprite() -> void:
    sprite.texture = DAMAGE_TEXTURES[durability]
