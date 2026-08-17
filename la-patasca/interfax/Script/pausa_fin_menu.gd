class_name Menu extends CanvasLayer
#region /// variables
@onready var control: Control = $Control
const ESCENA = preload("res://interfax/Escenarios/Inicio_pantalla.tscn")

#sistema de pausa y botones en pausa
@onready var sis_pausa: Control = $Control/sis_Pausa
@onready var button_continuar: Button = $Control/sis_Pausa/GridContainer/button_continuar
@onready var button_reiniciar: Button = $Control/sis_Pausa/GridContainer/button_reiniciar
@onready var button_configuraciones: Button = $Control/sis_Pausa/GridContainer/button_configuraciones
@onready var button_salir: Button = $Control/sis_Pausa/GridContainer/button_salir

#configuraciones
@onready var sistema: Control = $Control/Sistema


#boton de salir
@onready var salir: Control = $Control/Salir
@onready var button_salir_p: Button = $Control/Salir/ColorRect/VBoxContainer/HBoxContainer/button_salir_p
@onready var button_cancelar_p: Button = $Control/Salir/ColorRect/VBoxContainer/HBoxContainer/button_cancelar_p
@onready var pantalla: ColorRect = $pantalla

#audio
@onready var sfx_audio = AudioGenerales.get_child(0).get_child(1)
@onready var ui_audio = AudioGenerales.get_child(0).get_child(2)

@export var sonido: AudioStream
@export var ui: AudioStream
#endregion

#var pausa_activo = false
func _ready() -> void:
	sfx_audio.stream = sonido
	ui_audio.stream = ui
	
	sistema_pausa()
	MensajeroGlobal.volver.connect(volver_pausa)
	sistema_salir()

#funcion de botones para iniciar la pausa
func _unhandled_input( event: InputEvent ) -> void:
	#es para realizar un enfoque a los botones y se pueda usar el teclado
	if sis_pausa.visible == true: #usar el teclado en el menu de pausa
		if event.is_action_pressed( "ui_right" ) or event.is_action_pressed( "ui_left" ):
			button_continuar.grab_focus()
	elif salir.visible == true: #usar el teclado en la ventana de salir
		button_cancelar_p.grab_focus()
	#elif sistema.visible == true: #usar el teclado en configuracion
		#if event.is_action_pressed( "ui_down" ) or event.is_action_pressed( "ui_right" ):
			#musica_slider.grab_focus()

func sistema_pausa(): #botones del menu de pausa
	button_continuar.pressed.connect(func(): 
		control.visible = false
		#pausa_activo = false
		get_tree().paused = false 
		sfx_audio.play() ) #boton de continuar, mismo script que el de espacio en botones

	#button_reiniciar.pressed.emit(  ) #boton de reinicar nivel, emite una señal al mundo principal para reiniicar
	button_configuraciones.pressed.connect(func():
		sis_pausa.visible = false
		sistema.visible = true 
		sfx_audio.play() ) #boton para abrir el menu de configuraciones

	button_salir.pressed.connect( func():
		salir.visible = true 
		sfx_audio.play() ) #boton para abrir la ventana de salir

func volver_pausa(): #boton para volve a menu de pausa
		sis_pausa.visible = true
		sistema.visible = false 
		ui_audio.play()

func sistema_salir():
	button_salir_p.pressed.connect( volver_menu_inicio ) #boton para salir del juego abierto
	button_cancelar_p.pressed.connect( func():
		salir.visible = false ) #boton para quitar la ventana de salir

func volver_menu_inicio(): #funcion para volver al menu de inicio del juego
	get_tree().paused = false
	#var tween = create_tween()
	#tween.tween_property(pantalla, "modulate:a", 1.0, 1.5)
	#await tween.finished # Esperamos a que la animación termine
	ui_audio.play()
	MensajeroGlobal.reinicio_nivel.emit()
	get_tree().change_scene_to_packed(ESCENA)
