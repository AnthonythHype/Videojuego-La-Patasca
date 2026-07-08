extends CanvasLayer
#region /// variables
#general
@onready var sistema_inicio: Control = $Control/Sistema_inicio
const ESCENA = preload("res://Escenas/Escena_test.tscn")

#botoenes de inicio
@onready var button_inicio: TextureButton = $Control/Sistema_inicio/MarginContainer/VBoxContainer/Button_inicio
@onready var button_configuraciones: TextureButton = $Control/Sistema_inicio/MarginContainer/VBoxContainer/Button_configuraciones
@onready var button_salir: TextureButton = $Control/Sistema_inicio/MarginContainer/VBoxContainer/Button_salir

#configuraciones
@onready var sistema: Control = $Control/Sistema

#pantalla para efecto
@onready var pantalla: ColorRect = $Control/pantalla

#sonidos
@onready var musica_audio = AudioGenerales.get_child(0).get_child(0)
@onready var sfx_audio = AudioGenerales.get_child(0).get_child(1)
@onready var ui_audio = AudioGenerales.get_child(0).get_child(2)

@export var Musica: Array[AudioStream]
@export var sonido: AudioStream
@export var ui: AudioStream


#endregion
func _ready() -> void:
	sistema_inicio_f()
	MensajeroGlobal.volver.connect( volver_inicio )
	
	sfx_audio.stream = sonido
	ui_audio.stream = ui
	
	musica_audio.stream = Musica[0]
	musica_audio.play()
	musica_audio.finished.connect(_on_audio_finished)
	
func sistema_inicio_f():
	button_inicio.pressed.connect( cambio_escenario )
	button_configuraciones.pressed.connect( cambio_configuracion )
	button_salir.pressed.connect(func(): get_tree().quit())

func cambio_escenario():
	musica_audio.stream = Musica[2]
	sfx_audio.play()
	musica_audio.play()
	var botones = [button_inicio, button_configuraciones, button_salir]
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel(true)
	for boton in botones:
		var posicion_final = Vector2(-550, boton.position.y)
		tween.tween_property(boton, "position", posicion_final, 0.8)
	 # Esperamos a que la animación termine
	await musica_audio.finished
	get_tree().change_scene_to_packed(ESCENA)

func cambio_configuracion():
	sistema_inicio.visible = false
	sistema.visible = true
	ui_audio.play()

func volver_inicio():
	var tween = create_tween().set_parallel(false)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(pantalla, "modulate:a", 255, 1)
	sistema.visible = false
	ui_audio.play()
	#tween.tween_property(pantalla, "modulate:a", 0.0, 0.7)
	await tween.finished
	sistema_inicio.visible = true

func _on_audio_finished():
	musica_audio.stream = Musica[1]
	musica_audio.play()
