extends CharacterBody2D

@export var tamaño_maximo: float = 20.0
@export var velocidad_disminucion: float = 1 # Qué tan rápido se reduce
@export var tamaño_minimo: float = 1.0 # Límite mínimo de escala

@onready var area_segura: Area2D = $area_segura
@onready var cuerpo_patasca: Area2D = $cuerpo_patasca
var aumento = false

func _ready() -> void:
	add_to_group("Patasca")
	cuerpo_patasca.area_entered.connect(_on_area_2d_area_entered)
	
func _process(delta):
	area_patasca(delta)

func area_patasca(delta):
	if aumento == true:
		_aumento()
	if area_segura.scale.x > tamaño_minimo:
		var nueva_escala = area_segura.scale - Vector2(velocidad_disminucion, velocidad_disminucion) * delta
			# Evita que sea menor que el mínimo
		nueva_escala.x = clamp(nueva_escala.x, tamaño_minimo, tamaño_maximo)
		nueva_escala.y = clamp(nueva_escala.y, tamaño_minimo, tamaño_maximo)
		area_segura.scale = nueva_escala
		MensajeroGlobal.Bar_patasca.emit(nueva_escala.x, tamaño_maximo)
	elif area_segura.scale.x < tamaño_maximo:
			area_segura.scale += Vector2(1, 1) * delta


func _aumento():
	var nueva_escala = Vector2(5, 5)
	# Evita que sea menor que el mínimo
	nueva_escala.x = clamp(nueva_escala.x, tamaño_minimo, tamaño_maximo)
	nueva_escala.y = clamp(nueva_escala.y, tamaño_minimo, tamaño_maximo)
	area_segura.scale += nueva_escala
	aumento = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	match area.owner.get_groups():
		[&"Personaje"]:
			aumento=true
	#print(area.owner.get_groups())
