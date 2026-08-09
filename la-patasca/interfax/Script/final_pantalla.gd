extends CanvasLayer

#region /// variables
const ESCENA = preload("res://interfax/Escenarios/Inicio_pantalla.tscn")
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

#reparar la entrada de puntos en la funcion de botones de estados
func _ready() -> void:
	#comienzo del timer para activar el final
	timer.start()
	timer.connect("timeout", Callable(self, "_on_timer_timeout"), CONNECT_REFERENCE_COUNTED)
	
	MensajeroGlobal.puntuacion_total.connect(func(a): puntos_t = a )

func _unhandled_input( event: InputEvent ) -> void:
	#funcion de undir para continuar en la pantalla final
	#3 estados, undir para continuar, ver puntaje, final de la pantalla y salida
	
	#inicio de pausa/undir para continuar
	if event.is_action_pressed( "ui_accept" ) and !activar_fin and !puntuacion:
		variables.visible = true #variables para activar el segundo estado
		activar_fin = true #variables para activar la puntuacion en la funcion de puntos
		finalizar(puntos_t)
		#
		#text_continuar.text = "Pulse entre para continuar"
	#ver puntaje
	elif event.is_action_pressed( "ui_accept" ) and activar_fin and !puntuacion:
		finalizar_puntos(puntos_t) #funcion de puntuacion
		#MensajeroGlobal.puntuacion_total.connect( finalizar_puntos )
		puntuacion = true #variables para activar el tercer estado
	#final de la pantalla y salida
	elif event.is_action_pressed( "ui_accept" ) and activar_fin and puntuacion:
		salir() #funcion de salir

func finalizar(puntos):
	var tween = create_tween() #inicio de tweens
	tween.set_parallel()
	#cambio de texto de puntos de inicio a fin, con ligero movimiento
	tween.tween_method(_cambio_text_puntos.bind(text_puntos_total), 0, puntos, 8).set_trans(Tween.TRANS_EXPO)
	#movimiento de la luna de fondo
	tween.tween_property(img_luna, "rotation", 3.6, 8)
	await tween.finished #se espera a que finalice el tween, revisar
	tween.stop() #se para los tweens
	puntuacion = true #se activa el bool para el tercer estado
	finalizar_puntos(puntos) #se activa el estado de finalizar

func _cambio_text_puntos(new_exp: int, label: Label): 
	label.text = str(new_exp) #es el tween de texto, separado por control de tweens

func finalizar_puntos(puntos):
		#cambio de imagen, de sol y la luna
	img_luna.visible = false
	img_sol.visible = true
	var tween = create_tween() #otros tween, se elimina el anterior para controlar los tweens paralelos
	tween.set_parallel()
	#movimiento del sol de fondo.
	tween.tween_property(img_sol, "rotation", 3.6, 8)
	#cambio de texto, apagar, es por causa de que el tweens de texto de punto que no se para para hacer la puntuacion total
	text_puntos_total.visible = false 
	text_puntos_total2.visible = true 
	
	text_continuar.text = "Pulse para salir" #cambiar el texto de continuar por el de salir
	text_puntos_total2.text = str(puntos) #cambio del texto, colocar los puntajes final
	#tween.stop() no se si funcionaria eso.

func _on_timer_timeout():
	# Efecto: aparecer y desaparecer del texto de final de pantalla
	text_continuar.visible = not text_continuar.visible 

func salir(): #boton de salida, cambiar a pantalla de inicio
	get_tree().change_scene_to_packed(ESCENA)
