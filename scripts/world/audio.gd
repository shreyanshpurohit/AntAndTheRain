class_name GameAudio
extends Node

# Sound files come from real CC0 recordings, installed by tools/get_sounds.py.
# The game remains playable if sound files have not been downloaded.
@onready var click_player: AudioStreamPlayer = $UIClick
@onready var pickup_player: AudioStreamPlayer = $Pickup
@onready var splash_player: AudioStreamPlayer = $Splash
@onready var hit_player: AudioStreamPlayer = $Hit
@onready var rain_player: AudioStreamPlayer = $RainLoop

func _ready() -> void:
	_attach(pickup_player, "res://assets/audio/pickup.wav")
	_attach(splash_player, "res://assets/audio/splash.wav")
	_attach(hit_player, "res://assets/audio/splash.wav")
	_attach(rain_player, "res://assets/audio/rain.ogg")
	rain_player.finished.connect(_repeat_rain)
	play_rain()

func _attach(player: AudioStreamPlayer, path: String) -> void:
	if ResourceLoader.exists(path):
		player.stream = load(path)

func play_pickup() -> void:
	if pickup_player.stream != null:
		pickup_player.play()

func play_splash() -> void:
	if splash_player.stream != null:
		splash_player.play()

func play_hit() -> void:
	if hit_player.stream != null:
		hit_player.play()

func play_rain() -> void:
	if rain_player.stream != null and not rain_player.playing:
		rain_player.play()

func _repeat_rain() -> void:
	if rain_player.stream != null:
		rain_player.play()
