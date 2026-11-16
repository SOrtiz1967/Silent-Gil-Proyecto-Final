extends PointLight2D
#luz que titila como una lampara fallando. lento = va y viene suave, fuerte = titila mas seguido
@export var parpadea = true
@export var fuerte = false
@export var lento = false

var energia_base = 1.0
var espera = 0.0
var rafaga = 0.0
var paso = 0.0

func _ready() -> void:
	energia_base = energy
	espera = randf_range(1.0, 6.0)

func _process(delta: float) -> void:
	if not parpadea:
		return
	if lento:
		energy = energia_base * (0.65 + 0.35 * sin(Time.get_ticks_msec() / 400.0 + global_position.x))
		return
	#espera un rato y despues hace una rafaga de parpadeos cortitos
	if rafaga > 0.0:
		rafaga -= delta
		paso -= delta
		if rafaga <= 0.0:
			energy = energia_base
			espera = randf_range(0.5, 2.5) if fuerte else randf_range(3.0, 9.0)
		elif paso <= 0.0:
			paso = randf_range(0.03, 0.09)
			energy = energia_base if randf() < 0.4 else energia_base * randf_range(0.0, 0.3)
	else:
		espera -= delta
		if espera <= 0.0:
			rafaga = randf_range(0.15, 0.6)
