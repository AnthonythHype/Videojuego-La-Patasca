extends MarginContainer

@onready var _Zona_bar = $NinePatchRect/zonaS

func _ready() -> void:
	MensajeroGlobal.Bar_patasca.connect(cambio_zona)

func cambio_zona(zona_bar: float, max_zona_bar: float) -> void: 
	_Zona_bar.value = (zona_bar/max_zona_bar)*100
	#MarginContainer.SIZE_EXPAND.
