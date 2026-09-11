extends Label

var timer = 0
var timer_on = false
var tiempo = 5
var timer_passed 

func _ready() -> void:
	MensajeroGlobal.iniciar.connect(iniciar_cronometro)
	MensajeroGlobal.muerte.connect(final_tiempo)
	MensajeroGlobal.reinicio_nivel.connect(func(): 
		timer_on = false
		timer = 0)

func iniciar_cronometro(activo, _tiempo):
	timer_on = activo
	tiempo = _tiempo

func _process(delta: float) -> void:
	if (timer_on):
		timer += delta
	
	var _sec = fmod(timer, 60)
	var _min = fmod(timer, 60*60) / 60
	#print(_min)
	timer_passed = "%02d : %02d" % [_min,_sec]
	self.text = timer_passed
	
	if _min >= tiempo and timer_on == true:
		final_tiempo(false)
		print("finalizar cronocrama")

func final_tiempo(a):
	MensajeroGlobal.finalizar_mundo.emit(a, timer_passed)
	timer_on = a
