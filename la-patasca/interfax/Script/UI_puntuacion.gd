extends MarginContainer

@onready var text_numero: Label = $HBoxContainer/puntos

func _ready() -> void:
	MensajeroGlobal.puntuacion_total.connect(puntos_texto)
	text_numero.text = "0"
	MensajeroGlobal.reinicio_nivel.connect(func(): text_numero.text = "Punto:")

func puntos_texto(_puntos):
	text_numero.text = "Punto: %02d" %[_puntos]
