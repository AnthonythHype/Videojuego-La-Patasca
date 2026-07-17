extends Control
#region /// variables
#audio
@onready var musica_slider: HSlider = $Box_sistema/HBoxMusica/musicaSlider
@onready var sfx_slider: HSlider = $Box_sistema/HBoxSFX/SFXSlider
@onready var ui_slider: HSlider = $Box_sistema/HBoxUI/UISlider
@onready var audio_bus_id_music = AudioServer.get_bus_index("Musica")
@onready var audio_bus_id_sfx = AudioServer.get_bus_index("SFX")
@onready var audio_bus_id_ui = AudioServer.get_bus_index("UI")

#resolution
@onready var check_button: CheckButton = $Box_sistema/HBoxContainer2/CheckButton
@onready var resolucion_button: OptionButton = $Box_sistema/HBoxContainer/resolucionButton

@onready var sfx_audio = AudioGenerales.get_child(0).get_child(1)
@export var sonido: AudioStream
#volver
@onready var button_volver: Button = $Box_sistema/Button_volver
#endregion

func _ready() -> void:
	sfx_audio.stream = sonido
	
	musica_slider.value_changed.connect(_on_musica_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)
	ui_slider.value_changed.connect(_on_ui_slider_value_changed)
	
	check_button.toggled.connect( _on_toggled )
	resolucion_button.item_selected.connect( _on_item_selected )
	
	button_volver.pressed.connect( volver_inicio )

func volver_inicio():
	MensajeroGlobal.volver.emit()

func _on_musica_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id_music, db)
	sfx_audio.play()
func _on_sfx_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id_sfx, db)
	sfx_audio.play()
func _on_ui_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id_ui, db)
	sfx_audio.play()

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		sfx_audio.play()
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		sfx_audio.play()

func _on_item_selected(index: int) -> void:
	var items = [index]
	sfx_audio.play()
	
