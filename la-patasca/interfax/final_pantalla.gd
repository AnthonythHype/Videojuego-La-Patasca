extends CanvasLayer

#region /// variables
const ESCENA = preload("res://interfax/Inicio_pantalla.tscn")
var activar_fin = false
var puntuacion = false
var puntos_t = 0
@onready var timer: Timer = $Timer

#fondo
@onready var fondo: TextureRect = $Fondo_final/fondo
@onready var text_continuar: Label = $Fondo_final/text_continuar

#variables de victoria
@onready var variables: Control = $variables
@onready var img_base_patasca: TextureRect = $variables/Panel/img_base_patasca
@onready var img_luna: TextureRect = $variables/Panel/img_luna
@onready var img_sol: TextureRect = $variables/Panel/img_sol
@onready var text_puntos_total: Label = $variables/text_puntos_total
@onready var text_puntos_total2: Label = $variables/text_puntos_total2


#@onready var boton_salida: Button = $variables/botonSalida
#endregion


func _ready() -> void:
	timer.start()
	timer.connect("timeout", Callable(self, "_on_timer_timeout"), CONNECT_REFERENCE_COUNTED)

func _unhandled_input( event: InputEvent ) -> void:
	
	#inicio de pausa
	if event.is_action_pressed( "ui_accept" ) and !activar_fin and !puntuacion:
		variables.visible = true
		activar_fin = true
		finalizar(1000)
		#MensajeroGlobal.puntuacion_total.connect( finalizar )
		#text_continuar.text = "Pulse entre para continuar"
	elif event.is_action_pressed( "ui_accept" ) and activar_fin and !puntuacion:
		finalizar_puntos(1000)
		#MensajeroGlobal.puntuacion_total.connect( finalizar_puntos )
		puntuacion = true
	elif event.is_action_pressed( "ui_accept" ) and activar_fin and puntuacion:
		salir()

func finalizar(puntos):
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(_cambio_text_puntos.bind(text_puntos_total), 0, puntos, 8).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(img_luna, "rotation", 3.6, 8)
	await tween.finished
	tween.stop()
	puntuacion = true
	finalizar_puntos(puntos)

func _cambio_text_puntos(new_exp: int, label: Label): 
	label.text = str(new_exp)

func finalizar_puntos(puntos):
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(img_sol, "rotation", 3.6, 8)
	text_puntos_total.visible = false
	text_puntos_total2.visible = true
	img_luna.visible = false
	img_sol.visible = true
	text_continuar.text = "Pulse para salir"
	text_puntos_total2.text = str(puntos)
	img_luna.visible = false
	img_sol.visible = true
	#tween.stop()

func _on_timer_timeout():
	text_continuar.visible = not text_continuar.visible 

func salir(): #boton de salida
	get_tree().change_scene_to_packed(ESCENA)
