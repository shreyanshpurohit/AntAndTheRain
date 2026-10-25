extends Node2D

const SAVE_FILE := "user://ant_rain_best.txt"
@onready var ant: AntPlayer = $Ant
@onready var crumb: FoodCrumb = $Crumb
@onready var rain: StormSystem = $RainSystem
@onready var shelters_root: Node2D = $Shelters
@onready var ambient: Node2D = $AmbientRain
@onready var title_screen: TitleView = $UI/TitleScreen
@onready var hud: HUDView = $UI/HUD
@onready var modal: GameModal = $UI/Modal
@onready var sound: GameAudio = $Audio

var shelters: Array[LeafShelter] = []
var playing := false
var paused := false
var seconds := 0.0
var best := 0.0
var food := 0

func _ready() -> void:
	randomize()
	for child in shelters_root.get_children():
		if child is LeafShelter:
			shelters.append(child)
	if FileAccess.file_exists(SAVE_FILE):
		best = FileAccess.get_file_as_string(SAVE_FILE).strip_edges().to_float()
	title_screen.start_requested.connect(start_game)
	modal.resume_requested.connect(resume_game)
	modal.retry_requested.connect(start_game)
	modal.menu_requested.connect(show_title)
	rain.impact.connect(_on_rain_impact)
	hud.hide()
	title_screen.show()
	sound.play_rain()
	ambient.show()

func start_game() -> void:
	title_screen.hide()
	modal.hide()
	hud.show()
	playing = true
	paused = false
	seconds = 0.0
	food = 0
	ant.reset_ant()
	ant.set_sheltered(false)
	for leaf in shelters:
		leaf.reset_leaf()
	crumb.relocate(ant.position)
	rain.reset_rain()

func show_title() -> void:
	playing = false
	paused = false
	ant.enabled = false
	ant.set_sheltered(false)
	rain.stop_rain()
	title_screen.show()
	hud.hide()
	modal.hide()

func pause_game() -> void:
	if not playing or paused:
		return
	paused = true
	ant.enabled = false
	rain.freeze_rain()
	sound.play_ui()
	modal.open_pause()

func resume_game() -> void:
	if not playing:
		return
	paused = false
	ant.enabled = true
	rain.unfreeze_rain()
	sound.play_ui()
	modal.hide()

func finish_game() -> void:
	if not playing:
		return
	playing = false
	paused = false
	ant.enabled = false
	rain.stop_rain()
	var record := seconds > best
	if record:
		best = seconds
		var f := FileAccess.open(SAVE_FILE, FileAccess.WRITE)
		if f != null:
			f.store_string("%.3f" % best)
	sound.play_hit()
	modal.open_game_over(seconds, food, record)

func _process(delta: float) -> void:
	if not playing or paused:
		return
	seconds += delta
	rain.follow_target = ant.position
	var safe := _is_ant_safe()
	ant.set_sheltered(safe)
	hud.update_display(seconds, best, food, safe)
	if ant.position.distance_to(crumb.position) < 10.0:
		food += 1
		sound.play_pickup()
		crumb.relocate(ant.position)

func _is_ant_safe() -> bool:
	for leaf in shelters:
		if leaf.protects(ant.position):
			return true
	return false

func _on_rain_impact(at: Vector2, radius: float) -> void:
	if not playing or paused:
		return
	var safe := _is_ant_safe()
	sound.play_splash()
	for leaf in shelters:
		if leaf.touches_splash(at):
			leaf.soak()
	if ant.position.distance_to(at) < radius + 6.0 and not safe:
		finish_game()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			if paused:
				resume_game()
			else:
				pause_game()
		elif event.keycode in [KEY_ENTER, KEY_KP_ENTER, KEY_SPACE]:
			if title_screen.visible:
				start_game()
			elif modal.visible and not paused:
				start_game()
			elif paused:
				resume_game()
	if not playing or paused:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		ant.set_waypoint(event.position, event.pressed)
	elif event is InputEventMouseMotion and (event.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
		ant.set_waypoint(event.position, true)
	elif event is InputEventScreenTouch:
		ant.set_waypoint(event.position, event.pressed)
	elif event is InputEventScreenDrag:
		ant.set_waypoint(event.position, true)
