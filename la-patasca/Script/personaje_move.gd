extends Player

@export var velocidad: float = 600.0
var direccion: Vector2

@export var area2d: Area2D

@onready var animaciones: AnimatedSprite2D = $Animaciones

var atacar: bool = false
@onready var particulas: GPUParticles2D = $Area_accion/Particulas
@onready var colicion_ataque: CollisionShape2D = $Area_accion/Colicion_ataque

func _ready():
	add_to_group("Personaje")
	area2d.area_entered.connect(_on_area_2d_area_entered)
	MensajeroGlobal.Max_corazones.emit(max_vida)
	MensajeroGlobal.Cambio_vida.emit(vida)

#func _unhandled_input( event: InputEvent ) -> void:
	#

func _physics_process(delta: float):
	direccion = Vector2.ZERO #vector de movimiento, se mantiene en cero siempre que reinicie el flujo.
	#movimiento mediante la lectura del teclado de cada lado
	direccion = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#normalizar direccion a que sean enteros o cercano a ello.
	direccion = direccion.normalized()
	#Movimiento por velocidad, velocity genera el movimiento.
	velocity = direccion * velocidad * (delta * 10)
	#animaciones de 5 lados, tiene flip para reducir animaciones.
	
	#ataque del personaje
	if Input.is_action_pressed( "atacar" ):
		_atacar()
	
	if !atacar:
		_animaciones(direccion)
		move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	match area.owner.get_groups():
		[&"Entidad"]:
			tomar_daño()

func _atacar():
	atacar = true
	#animaciones.play("atacar")
	var tween = create_tween()
	particulas.emitting = true
	tween.tween_property(colicion_ataque, "disabled", false, 0.3)
	tween.tween_property(colicion_ataque, "disabled", true, 0.1)
	await tween.finished
	particulas.emitting = false
	atacar = false


func _animaciones(direction):
	"""la animaion de correr basa en animar una condicionar que cambio a si hay direccion o no
	Por el nombre de la animacion se establecen los 5 lados.
	1. de lado (todos los de lado poseen cambio de espejo del sprite)
	2. lado arriba
	3. arriba
	4. lado abajo
	5. abajo"""
	if direction != Vector2.ZERO and atacar == false:
		if abs(direction.x) == 1:
			animaciones.play("Move_RL")
			animaciones.flip_h = direction.x < 0
		elif abs(direction.x) >= 0.5 and direction.y <= -0.5:
			animaciones.play("Move_URL")
			animaciones.flip_h = direction.x < 0
		elif abs(direction.x) == 0 and direction.y == -1:
			animaciones.play("Move_U")
		elif abs(direction.x) >= 0.5 and direction.y >= -0.5:
			animaciones.play("Move_DRL")
			animaciones.flip_h = direction.x < 0
		elif abs(direction.x) == 0 and direction.y == 1:
			animaciones.play("Move_D")
			
	
	else:
		match animaciones.animation:
			"Move_RL":
				animaciones.play("Idle_RL")
			"Move_URL":
				animaciones.play("Idle_URL")
			"Move_U":
				animaciones.play("Idle_U")
			"Move_DRL":
				animaciones.play("Idle_DRL")
			"Move_D":
				animaciones.play("Idle_D")
