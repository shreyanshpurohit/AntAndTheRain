class_name HUDView
extends Control

@onready var time_text: PixelTextNode = $TimeValue
@onready var best_text: PixelTextNode = $BestValue
@onready var crumb_text: PixelTextNode = $CrumbValue
@onready var shelter_text: PixelTextNode = $ShelterIndicator

func update_display(seconds: float, best: float, crumbs: int, sheltered: bool) -> void:
	time_text.message = "%ds" % floori(seconds)
	best_text.message = "%ds" % floori(best)
	crumb_text.message = str(crumbs)
	shelter_text.visible = sheltered

func _draw() -> void:
	draw_rect(Rect2(0,0,320,23),Color(0.17647059, 0.15294118, 0.18431373, 1))
	draw_rect(Rect2(0,21,320,2),Color(0.85882353, 0.85098039, 0.56862745, 1))
	for x in [88,173,246]:
		draw_rect(Rect2(x,6,1,10),Color(0.36078431, 0.44313725, 0.60392157, 1))
