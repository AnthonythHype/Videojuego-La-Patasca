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
	#if get_tree().paused == true:
		#get_tree().paused = false
	sistema_inicio_f() #activacion de los botones de inicio
	
	#mensaje del boton de volver del menu de configuraciones
	MensajeroGlobal.volver.connect( volver_inicio ) 
	
	#inicializacion de los sonido de la interfaz y de los botones.
	sfx_audio.stream = sonido
	ui_audio.stream = ui
	
	#la musica tiene tres partes IN, Loop y OUT, aqui es la loop para reporducir despues de in
	#sonidos que aparece al inicio y sonido de la interfas, no de botones (IN)
	musica_audio.stream = Musica[0]
	musica_audio.play()
	musica_audio.finished.connect(_on_audio_finished)
	

func sistema_inicio_f():
	#funcion de los botones de inicio
	button_inicio.pressed.connect( cambio_escenario ) #boton de inicio, inicia funcion de cambio de pantalla
	button_configuraciones.pressed.connect( cambio_configuracion ) #boton para ir a configuraciones
	button_salir.pressed.connect(func(): get_tree().quit()) #boton de salir de la ventana.

func cambio_escenario():
	#funcion de cambio de escenario
	
	musica_audio.stream = Musica[2] #cambio de la musica a (OUT)
	sfx_audio.play()
	musica_audio.play()
	
	#tween para hacer el movimiento de los botones al hacer el cambio de escenario.
	#agarra los botones en lista (botones), y con un bucle for los mueve con tweens, todos a la vez.
	var botones = [button_inicio, button_configuraciones, button_salir]
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel(true)
	for boton in botones:
		var posicion_final = Vector2(-550, boton.position.y) #variable para dejar la posicion final del movimiento.
		tween.tween_property(boton, "position", posicion_final, 0.8)
	 # Esperamos a que la animación termine.
	await tween.finished
	#await musica_audio.finished
	get_tree().change_scene_to_packed(ESCENA) #cambio de escenario al nivel seleccionado

func cambio_configuracion():
	#cambio de menu de inico a menu de conficuraciones
	sistema_inicio.visible = false
	sistema.visible = true
	ui_audio.play() #reproducir sonido de interfaz

func volver_inicio():
	#funcion de volver del menu de conficuraciones al menu de inicio
	#***************reparar este tween no funciona ************
	var tween = create_tween().set_parallel(false)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(pantalla, "modulate:a", 255, 1)
	sistema.visible = false
	ui_audio.play()
	#tween.tween_property(pantalla, "modulate:a", 0.0, 0.7)
	await tween.finished
	sistema_inicio.visible = true

func _on_audio_finished():
	#funcion de finalizacion del audio, para el cambio del (Loop)
	musica_audio.stream = Musica[1]
	musica_audio.play()
