extends Entidad
func _ready() -> void:
	randomize()
	add_to_group("Entidad")
	area2d.area_entered.connect(_on_area_2d_area_entered)
func _physics_process(delta: float):
	
	match current_state:
		STATE.movimiento:
			velocity = seguir_jugador()
			if huir: current_state = STATE.huir
		STATE.huir:
			velocity = enemigo_huir(delta)
	move_and_slide()

func reaccion():
	var empuje = (jugador.global_position).normalized() * 50
	var tween = create_tween()
	tween.tween_property(self, "position", position-empuje,0.5).set_trans(Tween.TRANS_QUAD)

func _on_area_2d_area_entered(area: Area2D) -> void:
	match area.owner.get_groups():
		[&"Patasca"]:
			huir = true
			vida_entidad = herido(1, vida_entidad)
		[&"Personaje"]:
			reaccion()
	#print(area.owner.get_groups())
	
	#print()
	#if area.owner.is_in_group("Patasca"):
		#huir = true
		#vida_entidad = herido(1, vida_entidad)
	#
	#if area.owner.is_in_group("Personaje"):
		#reaccion()

	
