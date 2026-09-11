extends MarginContainer
@onready var move: MarginContainer = $"../move"
@onready var manual: TextureRect = $"../Manual"
@onready var timer: Timer = $"../Timer"

#region // Variables
@onready var tecla_esc: Sprite2D = $Tecla_ESC
@onready var tecla_space: Sprite2D = $Tecla_Space
@onready var label: Label = $Label

var menu = false
var complete = false
#endregion

func _ready() -> void:
	timer.wait_time = 5.0
	timer.timeout.connect(eliminar_tutorial)

func _unhandled_input(event: InputEvent) -> void:
	if move.visible==false and menu == false:
		menu = true
		manual.visible = true
		var tween = create_tween()
		tween.tween_property(manual, "position", Vector2(-81.0, 281.0), 1)
		timer.start()

	if (menu == true) and (event.is_action_pressed("atacar") || event.is_action_pressed("pausa")):
		timer.stop()
		eliminar_tutorial()

func eliminar_tutorial():
	
	var tween = create_tween()
	tween.tween_property(manual, "position", Vector2(-469.0, -116.0), 1)
	await tween.finished
	#visible = false
	queue_free()
	manual.queue_free()
