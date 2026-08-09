extends Entidad
@onready var color_rect: ColorRect = $Area_accion/ColorRect

func _ready() -> void:
	#entrada de los elementos
	add_to_group("Entidad") #etiquetar a la entidad cono Entidad
	area2d.area_entered.connect(_on_area_2d_area_entered) #entradas de las areas que enuentre
	
func _physics_process(delta: float):
	#Estados de la entidad y su movimiento
	match current_state:
		STATE.movimiento: #movimiento de la entidad
			velocity = seguir_jugador()
			if huir: current_state = STATE.huir #se activa el estado huida si encuentra el area Patasca
		STATE.huir:#movimiento de huida
			velocity = enemigo_huir(delta)
		STATE.empujado: #movimiento de empujado
			empuje_enemigo(25)
		STATE.atagar:
				var tween = create_tween()
				if ataco == true: 
					color_rect.visible = true
					tween.tween_property(colicion_ataque, "disabled", false, 0.1)
					await tween.finished
					color_rect.visible = false
					colicion_ataque.disabled = true
				else:
					current_state = STATE.movimiento
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	match area.owner.get_groups(): #busqueda de los padres de las areas #mejorar la forma de buscar
		[&"Patasca"]: #entrada cuando el area de la patasca entra
			huir = true
			vida_entidad = herido(1, vida_entidad)
		[&"Personaje"]: #entrada cuando el area accion del jugador entra
			current_state = STATE.empujado
