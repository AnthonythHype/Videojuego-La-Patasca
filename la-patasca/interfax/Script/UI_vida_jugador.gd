extends Control
@export var corazon_null: Texture2D
@export var corazon_full: Texture2D
var corazon = preload("res://interfax/Escenarios/Corazones.tscn")
var j = 5
func _ready() -> void:
	MensajeroGlobal.Max_corazones.connect(Maximo_corazones)
	MensajeroGlobal.Cambio_vida.connect(cambiar_corazones)

func Maximo_corazones(_max: int): 
	for i in range(_max):
		var X = corazon.instantiate()
		add_child(X)

func cambiar_corazones(vida_actual: int) -> void:
	var corazones = get_children()
	
	for i in range(vida_actual):
		corazones[i].texture = corazon_full
	
	for i in range(vida_actual, corazones.size()):
		corazones[i].texture = corazon_null
