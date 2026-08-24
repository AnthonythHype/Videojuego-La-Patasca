extends Node2D

@onready var entidades: Node2D = $Entidades
@onready var pantalla_final: PackedScene = load("res://interfax/Escenarios/Final_pantalla.tscn")
@onready var pantalla_pausa: PackedScene = load("res://interfax/Escenarios/pausa_fin_menu.tscn")
var pausa_activo:bool = false
var puntuacion: int = 0

@export var iniciar_cronometro: bool = true
@export var final_mundo: bool = false

func _ready() -> void:
	MensajeroGlobal.iniciar.emit(iniciar_cronometro)
	MensajeroGlobal.puntos.connect(puntos)
	#MensajeroGlobal.muerte.connect(crear_pantalla_final)
	MensajeroGlobal.finalizar_mundo.connect(crear_pantalla_final)

func puntos(_puntos: int):
	puntuacion += _puntos
	MensajeroGlobal.puntuacion_total.emit(puntuacion)

func _crear_mundo():
	pass

func crear_pantalla_final(_activar, tiempo):
	final_mundo = true # esta variable ayuda a no activar nada mas que la pantalla final
	eliminar_mundo()
	var final = pantalla_final.instantiate()
	self.add_child(final)
	MensajeroGlobal.puntuacion_total.emit(puntuacion)
	MensajeroGlobal.reinicio_nivel.emit()
	MensajeroGlobal.finalizar.emit(_activar)
	MensajeroGlobal.tiempo_final.emit(tiempo)

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

@onready var enemy_spawn: Node2D = $Enemy_Spawn
@onready var _entidades: Node2D = $Entidades
@onready var pausa_menu: HBoxContainer = $Pausa_menu
#@onready var entidad_test: CharacterBody2D = $Entidad_test

func eliminar_mundo():
	for hijo in self.get_children():
		if hijo==enemy_spawn or hijo==_entidades: #or hijo==entidad_test
			call_deferred("remove_child", hijo)
			hijo.call_deferred("queue_free")
