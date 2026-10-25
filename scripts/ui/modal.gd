class_name GameModal
extends Control

signal resume_requested
signal retry_requested
signal menu_requested

@onready var heading: PixelTextNode = $Heading
@onready var subtitle: PixelTextNode = $Subtitle
@onready var details: PixelTextNode = $Details
@onready var primary_button: PixelButton = $PrimaryButton
@onready var menu_button: PixelButton = $MenuButton
var state := "pause"

func _ready() -> void:
	primary_button.pressed.connect(_pressed_primary)
	menu_button.pressed.connect(func(): menu_requested.emit())

func open_pause() -> void:
	state = "pause"
	heading.message = "PAUSED"
	subtitle.message = "THE STORM CAN WAIT."
	details.message = ""
	primary_button.caption = "RESUME"
	show()

func open_game_over(seconds: float, crumbs: int, record: bool) -> void:
	state = "over"
	heading.message = "SOAKED!"
	subtitle.message = "THE STORM GOT YOU."
	details.message = "%d SEC  %d FOOD" % [floori(seconds), crumbs]
	primary_button.caption = "TRY AGAIN"
	show()

func _pressed_primary() -> void:
	if state == "pause":
		resume_requested.emit()
	else:
		retry_requested.emit()

func _draw() -> void:
	draw_rect(Rect2(0, 0, 320, 180), Color("#2d272f"))
	draw_rect(Rect2(56, 26, 208, 138), Color("#524d4a"))
	draw_rect(Rect2(54, 24, 212, 142), Color(0.36078431, 0.44313725, 0.60392157, 1), false, 2.0)
