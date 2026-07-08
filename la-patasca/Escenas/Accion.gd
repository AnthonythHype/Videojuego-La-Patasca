extends Area2D
@onready var posicion_padre = get_parent()
@export var tamaño: float
@export var tipo: String = "vacio"

#func _ready() -> void:
	#area_entered.connect(_on_area_2d_area_entered)
#
#func _on_area_2d_area_entered(area: Area2D) -> void:
	#var objeto = area.owner
	#if objeto.has_method("reaccion"):
		#objeto.reaccion()

func _process(_delta: float) -> void:
	self.position = posicion_padre.direccion * Vector2(tamaño, tamaño)
