extends CharacterBody2D
@onready var color_rect: ColorRect = $area_segura/ColorRect

#region // variables
@export var tamaño_maximo: float = 20.0
@export var velocidad_disminucion: float = 1 # Qué tan rápido se reduce
@export var tamaño_minimo: float = 1.0 # Límite mínimo de escala

#area que maneja la patasca
@onready var area_segura: Area2D = $area_segura
@onready var cuerpo_patasca: Area2D = $cuerpo_patasca
var aumento = false
@onready var point_light_2d: PointLight2D = $PointLight2D

#endregion

func _ready() -> void:
	area_segura.add_to_group("Patasca") #se le coloca al grupo de la Patasca
	cuerpo_patasca.area_entered.connect(_on_area_2d_area_entered) #coneccion de la area de la patasca
	
func _process(delta):
	#funcion activa cada segundo
	area_patasca(delta)

func area_patasca(delta):
	#
	if aumento == true:
		_aumento()
	if area_segura.scale.x > tamaño_minimo:
		var nueva_escala = area_segura.scale - Vector2(velocidad_disminucion, velocidad_disminucion) * delta
			# Evita que sea menor que el mínimo
		nueva_escala.x = clamp(nueva_escala.x, tamaño_minimo, tamaño_maximo)
		nueva_escala.y = clamp(nueva_escala.y, tamaño_minimo, tamaño_maximo)
		area_segura.scale = nueva_escala
		point_light_2d.texture_scale = nueva_escala.x/10
		print(point_light_2d.texture_scale)
		MensajeroGlobal.Bar_patasca.emit(nueva_escala.x, tamaño_maximo)
	elif area_segura.scale.x < tamaño_maximo:
			area_segura.scale += Vector2(0.5, 0.5) * delta


func _aumento():
	var nueva_escala = Vector2(5, 5)
	# Evita que sea menor que el mínimo
	nueva_escala.x = clamp(nueva_escala.x, tamaño_minimo, tamaño_maximo)
	nueva_escala.y = clamp(nueva_escala.y, tamaño_minimo, tamaño_maximo)
	area_segura.scale += nueva_escala
	point_light_2d.texture_scale += 0.01
	#print(nueva_escala.x -4.7)
	aumento = false
	var tween = create_tween()
	tween.tween_property(color_rect, "visible", true, 0.5)
	await tween.finished
	color_rect.visible = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	match area.owner.get_groups():
		[&"Personaje"]:
			aumento=true
	#print(area.owner.get_groups())
