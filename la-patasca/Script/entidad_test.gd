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
		STATE.empujado:
			var empuje = seguir_jugador() * 100
			empuje = empuje.move_toward(Vector2.ZERO, 100 * delta)
			velocity = -empuje
			get_tree().create_timer(0.01).timeout.connect(func(): current_state = STATE.movimiento)
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	match area.owner.get_groups():
		[&"Patasca"]:
			huir = true
			vida_entidad = herido(1, vida_entidad)
		[&"Personaje"]:
			current_state = STATE.empujado
	#print(area.owner.get_groups())
	
	#print()
	#if area.owner.is_in_group("Patasca"):
		#huir = true
		#vida_entidad = herido(1, vida_entidad)
	#
	#if area.owner.is_in_group("Personaje"):
		#reaccion()

	
