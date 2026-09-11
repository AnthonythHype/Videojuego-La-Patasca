class_name Player extends CharacterBody2D 
@export var daño = 1
@export var max_vida: int = 5 :
	set( value ):
		max_vida = value
		MensajeroGlobal.Max_corazones.emit(max_vida)
		
@export var vida: int = 5 :
	set( value ):
		vida = clamp(value, 0, max_vida)
		MensajeroGlobal.Cambio_vida.emit(vida)

#func _ready() -> void:
@onready var area_reaccion: Area2D = $Area_reaccion
@onready var Collicion_reaccion: CollisionShape2D = $Area_reaccion/CollisionShape2D

var invulnerabilidad: bool = false

func recuperar_vida() -> void:
	vida += max_vida

func tomar_daño():
	if invulnerabilidad:
		return
	else:
		vida -= daño
		invulnerabilidad = true
		if vida == 0:
			dead()
			return
		var tween = create_tween()
		for i in range(20):
			tween.tween_callback(efecto_parpadeo).set_delay(0.1)
		tween.tween_interval(1)
		await tween.finished
		invulnerabilidad = false
	#var tween = create_tween()
	#tween.tween_property(Collicion_reaccion, "disabled", true, 1)
	#await tween.finished
	#Collicion_reaccion.disabled = false
func efecto_parpadeo(): 
	visible = !visible
func dead():
	#print("moriste")
	MensajeroGlobal.muerte.emit(true)
	#get_parent().queue_free()
