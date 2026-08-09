extends MarginContainer

@onready var text_numero: Label = $HBoxContainer/text_numero


func _ready() -> void:
	MensajeroGlobal.puntuacion_total.connect(puntos_texto)
	text_numero.text = "0"
	

func puntos_texto(_puntos):
	text_numero.text = str(_puntos)
