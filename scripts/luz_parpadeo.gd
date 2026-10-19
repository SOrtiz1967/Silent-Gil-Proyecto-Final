extends PointLight2D
@export var parpadea = true
@export var fuerte = false
@export var lento = false
var energiaBase = 1.0
var espera = 0.0
var rafaga = 0.0
var paso = 0.0
func _ready():
	energiaBase = energy
	espera = randf_range(1.0, 6.0)
func _process(delta):
	if not parpadea:
		return
	if lento:
		energy = energiaBase * (0.65 + 0.35 * sin(Time.get_ticks_msec() / 400.0 + global_position.x))
		return
	if rafaga > 0.0:
		rafaga -= delta
		paso -= delta
		if rafaga <= 0.0:
			energy = energiaBase
			espera = randf_range(0.5, 2.5) if fuerte else randf_range(3.0, 9.0)
		elif paso <= 0.0:
			paso = randf_range(0.03, 0.09)
			energy = energiaBase if randf() < 0.4 else energiaBase * randf_range(0.0, 0.3)
	else:
		espera -= delta
		if espera <= 0.0:
			rafaga = randf_range(0.15, 0.6)
