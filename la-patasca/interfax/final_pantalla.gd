extends CanvasLayer
#fondo
@onready var fondo: TextureRect = $Fondo_final/fondo
@onready var text_continuar: Label = $Fondo_final/text_continuar

#variables de victoria
@onready var variables: Control = $variables
@onready var texture_rect_2: TextureRect = $variables/Panel/TextureRect2
@onready var texture_rect_3: TextureRect = $variables/Panel/TextureRect3

func _ready() -> void:
	pass
