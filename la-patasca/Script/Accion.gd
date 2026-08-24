extends Area2D
@onready var posicion_padre = get_parent() #(direccion del padre)
@export var tamaño: float #(direccion a a la que posiciona)

#no utilizado es para dirigir el mensaje de la accion al objeto que le afecta
#como enviar empujar al enemigo y que este active un empuje o atacar.
@export var tipo: String = "vacio" 

func _ready() -> void:
	if not tipo.is_empty():
		add_to_group(tipo) #etiquetar a la entidad como la variable puesta
	#else:
	#	add_to_group(tipo)
#Proceso que posiciona el area de accion a la vista del personaje o enemigos
#Accion es para todas las areas de accion
func _process(_delta: float) -> void:
	#operacion de la posicion = (direccion del padre) x (direccion de la posicion)
	self.position = posicion_padre.direccion * Vector2(tamaño, tamaño)
