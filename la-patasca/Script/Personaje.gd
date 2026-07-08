#class_name Player extends CharacterBody2D 

#signal muerte


#@export var area2d: Area2D
#func _eliminar_entidad(entidad):
	#entidad.queue_free()
	#
#func _ready() -> void:
	#area2d.body_entered.connect(_on_area_2d_body_entered)
	#
#func _on_area_2d_body_entered(_body: Node2D) -> void:
	#muerte.emit()
	##await get_tree().create_timer().timeout
