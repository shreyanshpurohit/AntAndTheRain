class_name FoodCrumb
extends Node2D

func relocate(avoid: Vector2) -> void:
    for _attempt in range(40):
        position = Vector2(randf_range(18,302),randf_range(40,161)).round()
        if position.distance_to(avoid) > 35.0:
            return
