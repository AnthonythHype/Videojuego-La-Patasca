extends MarginContainer

@onready var acction: MarginContainer = $"../Acction"

#region // Variables
@onready var tecla_up: Sprite2D = $Tecla_Up
@onready var tecla_down: Sprite2D = $Tecla_Down
@onready var tecla_right: Sprite2D = $Tecla_Right
@onready var tecla_left: Sprite2D = $Tecla_Left
@onready var tecla_accion_1: Sprite2D = $Tecla_Accion1

var Up = false
var Down = false
var Right = false
var Left = false
var X = false

var Complete_1 = true

#endregion

# llamadas del teclado para el tutorial
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		Up = true
		if tecla_up.visible == true:
			tecla_up.visible =false
	if event.is_action_pressed("ui_down"):
		Down = true
		if tecla_down.visible == true:
			tecla_down.visible =false
	if event.is_action_pressed("ui_right"):
		Right = true
		if tecla_right.visible == true:
			tecla_right.visible =false
	if event.is_action_pressed("ui_left"):
		Left = true
		if tecla_left.visible == true:
			tecla_left.visible =false
	if event.is_action_pressed("atacar"):
		X = true
		if tecla_accion_1.visible == true:
			tecla_accion_1.visible =false

	#if (Complete_1):
	if Up and Down and Right and Left and X and Complete_1:
		Complete_1 = false
		acction.visible = true
		visible = false
