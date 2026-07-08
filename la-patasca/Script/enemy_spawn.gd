extends Node2D

#Emenigos en array para poder añadirlos en una lista
@export var Nodo_entidades: Node
@export var _Enemigos: Array[PackedScene]
var enemigo_instanciado = Node
var Enemigo_ins: int = randi_range(0, _Enemigos.size())

#timer de spawn de enemigo
@export var timer: Timer
var delta = 1
var offset = 0.5

func _ready() -> void:
	randomize()
	_siguiente_enemigo()

func _Spawn_Enemy():
	var _posicion = _posicion_enemigo()
	
	enemigo_instanciado = _Enemigos[Enemigo_ins -1].instantiate()
	Nodo_entidades.add_child(enemigo_instanciado)
	enemigo_instanciado.position = _posicion

func _posicion_enemigo():
	var i = randi_range(1,4)
	match i:
		1: 
			return Vector2(randi_range(-280, 300), randi_range(-150, -220))
		2: 
			return Vector2(randi_range(-280, 300), randi_range(150, 220))
		3: 
			return Vector2(randi_range(-350, -250), randi_range(-140, 140))
		4: 
			return Vector2(randi_range(250, 330), randi_range(-140, 140))
	
func _siguiente_enemigo():
	var nextTime = delta + (randi()%5)*2*offset
	
	timer.wait_time = nextTime
	timer.start()
	timer.connect("timeout", Callable(self, "_on_timer_timeout"), CONNECT_REFERENCE_COUNTED)

func _on_timer_timeout():
	_Spawn_Enemy()
	_siguiente_enemigo()
	
#func _draw() -> void:
	##limites de area del spawn
	#var rectanculo1 = Rect2(-280, -230, 560, 80)
	#var rectanculo2 = Rect2(-280, 150, 560, 80)
	#var rectanculo3 = Rect2(-330, -145, 80, 290)
	#var rectanculo4 = Rect2(250, -145, 80, 290)
	#draw_rect(rectanculo1, Color(0.294, 0.478, 0.89, 0.451))
	#draw_rect(rectanculo2, Color(0.294, 0.478, 0.89, 0.451))
	#draw_rect(rectanculo3, Color(0.294, 0.478, 0.89, 0.451))
	#draw_rect(rectanculo4, Color(0.294, 0.478, 0.89, 0.451))
