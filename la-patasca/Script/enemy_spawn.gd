extends Node2D

#Emenigos en array para poder añadirlos en una lista
@onready var Nodo_entidades: Node2D = get_tree().get_first_node_in_group("Nodo_entidades")
@export var _Enemigos: Array[PackedScene] #lista de los enemigos que spwanean
var enemigo_instanciado = Node
var Enemigo_ins: int = 1

#timer de spawn de enemigo
@onready var timer: Timer = $Timer
var delta = 1 #tiempo de siquiente enemigo
var offset = 0.5 #multiplicador de tiempo para el siquiente enemigos
var desactivar = false
func _ready() -> void:
	randomize()
	_siguiente_enemigo()
	MensajeroGlobal.muerte.connect(func(a): desactivar = a)
	
func _Spawn_Enemy():
	#funcion de spwan de enemigos
	var _posicion = _posicion_enemigo()
	
	enemigo_instanciado = _Enemigos[Enemigo_ins -1].instantiate() #instancia del enemigo
	Nodo_entidades.add_child(enemigo_instanciado) #añade al Nodo de Entidades en el Mundo
	enemigo_instanciado.position = _posicion #posicion de aleatorio en un espacio

func _posicion_enemigo():
	#funcion de posicion ramdom de diferentes areas
	var i = randi_range(1,4) #variables para elegir una de las 4 areas
	match i:
		1: #area rectangular ARRIBA del mundo
			return Vector2(randi_range(-280, 300), randi_range(-150, -220))
		2: #area rectangular ABAJO del mundo
			return Vector2(randi_range(-280, 300), randi_range(150, 220))
		3: #area rectangular IZQUIERDA del mundo
			return Vector2(randi_range(-350, -250), randi_range(-140, 140))
		4: #area rectangular DERECHA del mundo
			return Vector2(randi_range(250, 330), randi_range(-140, 140))
	
func _siguiente_enemigo():
	#funcion de espera para la siquiente enemigo
	var nextTime = delta + (randi()%5)*2*offset #operacion para crear un tiempo
	#toma el timer para consinuar el reloj y activa la funcion timeout
	timer.wait_time = nextTime
	timer.start()
	timer.connect("timeout", Callable(self, "_on_timer_timeout"), CONNECT_REFERENCE_COUNTED)

func _on_timer_timeout():
	Enemigo_ins = randi_range(0, _Enemigos.size())
	if !desactivar:#funcion para realizar el spwan y volver en el ciclo de spawn
		_Spawn_Enemy()
		_siguiente_enemigo()
	
#func _draw() -> void:
#dibujo de los cuadros de posicion
	##limites de area del spawn
	#var rectanculo1 = Rect2(-280, -230, 560, 80)
	#var rectanculo2 = Rect2(-280, 150, 560, 80)
	#var rectanculo3 = Rect2(-330, -145, 80, 290)
	#var rectanculo4 = Rect2(250, -145, 80, 290)
	#draw_rect(rectanculo1, Color(0.294, 0.478, 0.89, 0.451))
	#draw_rect(rectanculo2, Color(0.294, 0.478, 0.89, 0.451))
	#draw_rect(rectanculo3, Color(0.294, 0.478, 0.89, 0.451))
	#draw_rect(rectanculo4, Color(0.294, 0.478, 0.89, 0.451))
