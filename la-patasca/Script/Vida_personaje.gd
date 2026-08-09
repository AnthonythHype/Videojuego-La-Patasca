class_name Player extends CharacterBody2D 
@export var daño = 1
@export var max_vida: int = 3 :
	set( value ):
		max_vida = value
		MensajeroGlobal.Max_corazones.emit(max_vida)
		
@export var vida: int = 3 :
	set( value ):
		vida = clamp(value, 0, max_vida)
		MensajeroGlobal.Cambio_vida.emit(vida)

#func _ready() -> void:

	
func recuperar_vida() -> void:
	vida += max_vida

func tomar_daño():
	vida -= daño
	if vida <= 0:
		dead()

func dead():
	MensajeroGlobal.muerte.emit()
	#get_parent().queue_free()
