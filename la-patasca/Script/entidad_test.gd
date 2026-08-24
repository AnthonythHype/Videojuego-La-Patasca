extends Entidad
@onready var area_accion: Area2D = $Area_accion
var parar = false
func _ready() -> void:

	#entrada de los elemento
	#area_accion.tipo = "Entidad" #etiquetar a la entidad como la variable puesta
	area2d.area_entered.connect(_on_area_2d_area_entered) #entradas de las areas que enuentre
	MensajeroGlobal.muerte.connect(func(a): parar = a)

func _physics_process(delta: float):
	#Estados de la entidad y su movimiento
	match current_state:
		STATE.movimiento: #movimiento de la entidad
			velocity = seguir_jugador()
			if huir: current_state = STATE.huir #se activa el estado huida si encuentra el area Patasca
			elif empujado: current_state = STATE.empujado #se activa cuando llega a se empujado por el jugador
			elif atacar:  current_state = STATE.atagar
			#elif parar: current_state = STATE.parar
		STATE.huir:#movimiento de huida
			velocity = enemigo_huir(delta)
		STATE.empujado: #movimiento de empujado
			empuje_enemigo(20)
		STATE.atagar:
			if huir: current_state = STATE.huir #se activa el estado huida si encuentra el area Patasca
			elif empujado: current_state = STATE.empujado #se activa cuando llega a se empujado por el jugador
			if !atacar: 
				return
			else: await ataque() 
		STATE.parar:
			velocity = Vector2.ZERO
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	match area.get_groups(): #busqueda de los padres de las areas #mejorar la forma de buscar
		[&"Patasca"]: #entrada cuando el area de la patasca entra
			huir = true
			vida_entidad = herido(1, vida_entidad)
		[&"Empuje"]: #entrada cuando el area accion del jugador entra
			empujado = true
