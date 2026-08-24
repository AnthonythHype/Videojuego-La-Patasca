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
@onready var area_reaccion: Area2D = $Area_reaccion
@onready var Collicion_reaccion: CollisionShape2D = $Area_reaccion/CollisionShape2D

	
func recuperar_vida() -> void:
	vida += max_vida

func tomar_daño():
	vida -= daño
	if vida <= 0:
		dead()
	#var tween = create_tween()
	#tween.tween_property(Collicion_reaccion, "disabled", true, 1)
	#await tween.finished
	#Collicion_reaccion.disabled = false

func dead():
	#print("moriste")
	MensajeroGlobal.muerte.emit(true)
	#get_parent().queue_free()
