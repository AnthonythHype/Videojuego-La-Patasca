extends Node2D

@onready var entidades: Node2D = $Entidades
@onready var pantalla_final: PackedScene = load("res://interfax/Escenarios/Final_pantalla.tscn")
@onready var pantalla_pausa: PackedScene = load("res://interfax/Escenarios/pausa_fin_menu.tscn")
var pausa_activo:bool = false
var puntuacion: int = 0
var final_mundo: bool = false
func _ready() -> void:
	MensajeroGlobal.puntos.connect(puntos)
	MensajeroGlobal.muerte.connect(crear_pantalla_final)

func puntos(_puntos: int):
	puntuacion += _puntos
	MensajeroGlobal.puntuacion_total.emit(puntuacion)

func _creacion_mundo():
	pass

func crear_pantalla_final():
	final_mundo = true
	var final = pantalla_final.instantiate()
	self.add_child(final)
	MensajeroGlobal.puntuacion_total.emit(puntuacion)

func _unhandled_input( event: InputEvent ) -> void:
	#inicio de pausa
	var p_pausa = pantalla_pausa.instantiate()
	if event.is_action_pressed( "pausa" ) && pausa_activo == false && final_mundo == false:
		pausa_activo = true
		self.add_child(p_pausa)
		get_tree().paused = true #esta funcion es para activar el modo pausa
		#ui_audio.play()
	#final de pausa
	elif event.is_action_pressed( "pausa" ) && pausa_activo == true && final_mundo == false:
		pausa_activo = false
		self.get_child(p_pausa)
		get_tree().paused = false
		#ui_audio.play()
