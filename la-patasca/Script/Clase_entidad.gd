class_name Entidad extends CharacterBody2D
#variables de movimiento
@export var vida_entidad: int = 1
@export var velocidad: float = 10
@export var distancia_minima: float = 10.0
@onready var jugador: Node2D = get_tree().get_first_node_in_group("Personaje")
@onready var Patasca: Node2D = get_tree().get_first_node_in_group("Patasca")
@export var area2d: Area2D

#variables de estados
enum STATE { #estados del enemigo
	movimiento,
	atagar,
	empujado,
	huir,
	dash}
var current_state:STATE = STATE.movimiento #estado actual / inicial
var huir: bool = false #swith de huida
var tiempo_espera: float = randf_range(10, 50) #tiempor de espera de un estado (huir)
var direccion: Vector2 #direccion de movimiento
var ataco = false
var empujado = false
#fuerza de empuje
@export var Fuerza_empuje: int

var timer = 1 #timer de control
@export var puntos_enemigo: int = 10 #puntuacion del enemigo al morir
@onready var colicion_ataque: CollisionShape2D = $Area_accion/Colicion_ataque

func seguir_jugador() -> Vector2:
	#funcion de seguimiento del jugador
	#calcula la distancia del jugador para conocer su posicion
	#y lo posiciona en el plano global al jugador menos el planpo global para crear un vecto simple (normalizado)
	var distancia = global_position.distance_to(jugador.global_position)
	var j = velocidad * (jugador.global_position - global_position).normalized()
	#se busca que tenga una distancia minima, y se devuelve un vector para que se dirija a esa direccion, direccion del jugador
	if distancia > distancia_minima:
		direccion = j.normalized()
		return j
	else:
		#timer += delta*10 
		if ataco == false:
			ataco = true
			current_state = STATE.atagar
		return Vector2.ZERO

func herido(daño: int, vida_actual: int):
	#funcion de daño del enemigo
	vida_actual = max(0, vida_actual - daño) #daño obtenido y limita la vida para que no se sobre salga
	if vida_actual == 0:
		MensajeroGlobal.puntos.emit(puntos_enemigo) #emite puntos despues de muerte
		queue_free() #lo destruye al funalizar su vida
	return vida_actual

func enemigo_huir(delta):
	#funcion de retirada del enemigo de la zona segura
	timer += delta*10 
	if timer >= tiempo_espera: #tiempo que dura la huida
		current_state = STATE.movimiento #cambio de estado
		timer = 1
		huir = false
		tiempo_espera = randf_range(10, 50)
	#cambio de direccion del enemigo, a lo contrario
	return velocidad * (global_position - Patasca.global_position).normalized()

func empuje_enemigo(velocidad_empuje):
	# Aplica el empuje actual a la velocidad
	var _direccion = -(jugador.global_position - global_position)
	velocidad_empuje = Vector2(velocidad_empuje, velocidad_empuje) * _direccion
	#velocity = velocidad_empuje
	# Desaceleración suave (exponencial) usando lerp hacia cero.
	# Cuanto más alto sea "knockback_friction", más rápido frena.
	var tween = create_tween()
	tween.tween_property(self, "velocity", velocidad_empuje, 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	empujado = false
	tween.finished.connect(func(): current_state = STATE.movimiento)
 
@onready var color_rect: ColorRect = $Area_accion/ColorRect
func ataque():
	var tween = create_tween().set_parallel()
	if ataco == true: 
		tween.tween_property(color_rect, "visible", true, 1) #color_rect.visible = true
		tween.tween_property(colicion_ataque, "disabled", false, 0.5).set_trans(Tween.TRANS_EXPO)
		await tween.finished
		color_rect.visible = false
		colicion_ataque.disabled = true
		ataco = false
	current_state = STATE.movimiento
