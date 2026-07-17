class_name Entidad extends CharacterBody2D
#variables de movimiento
@export var vida_entidad: int = 1
@export var velocidad: float = 10
@export var distancia_minima: float = 10.0
@onready var jugador: Node2D = get_tree().get_first_node_in_group("Personaje")
@onready var Patasca: Node2D = get_tree().get_first_node_in_group("Patasca")
@export var area2d: Area2D
#variables de estados
enum STATE {movimiento,atagar,huir,dash,empujado}
var current_state:STATE = STATE.movimiento
var huir: bool = false
var tiempo_espera: float = randf_range(10, 50)
var direccion: Vector2

var timer = 1
func seguir_jugador() -> Vector2:
	var distancia = global_position.distance_to(jugador.global_position)
	var j = velocidad * (jugador.global_position - global_position).normalized()
	if distancia > distancia_minima:
		direccion = j.normalized()
		return j
	else:
		return Vector2.ZERO

func herido(daño: int, vida_actual: int):
	vida_actual = max(0, vida_actual - daño)
	if vida_actual == 0:
		queue_free()
	return vida_actual

func enemigo_huir(delta):
	timer += delta*10
	if timer >= tiempo_espera: 
		current_state = STATE.movimiento
		timer = 1
		huir = false
		tiempo_espera = randf_range(10, 50)
	return velocidad * (global_position - Patasca.global_position).normalized()
