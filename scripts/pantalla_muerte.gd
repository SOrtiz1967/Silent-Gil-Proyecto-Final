extends CanvasLayer
#cartel que aparece cuando el jugador muere. con menos de 3 muertes se repite el nivel,
#a la tercera se pierde todo y el juego vuelve a empezar desde la estacion
@export var vidas = 3
@export var espera_minima = 1.0
@export var espera_maxima = 4.0

var tiempo = 0.0
var reinicia_todo = false

@onready var etiqueta_detalle = $Fondo/Centro/Caja/EtiquetaDetalle

func mostrar(muertes: int) -> void:
	get_tree().paused = true
	Inventario.ocultar_aviso()
	reinicia_todo = muertes >= vidas
	var quedan = vidas - muertes
	if reinicia_todo:
		etiqueta_detalle.text = "Perdiste las " + str(vidas) + " vidas. El juego vuelve a empezar desde el principio."
	elif quedan == 1:
		etiqueta_detalle.text = "Te queda 1 vida. Si morís otra vez, volvés al principio del juego."
	else:
		etiqueta_detalle.text = "Te quedan " + str(quedan) + " vidas. Volvés al principio del nivel."

func _process(delta: float) -> void:
	tiempo += delta
	#un segundo de espera para que no se saltee sin querer apretando F
	if tiempo >= espera_maxima or (tiempo >= espera_minima and Input.is_action_just_pressed("interactuar")):
		continuar()

func continuar() -> void:
	set_process(false)
	get_tree().paused = false
	if reinicia_todo:
		CambioNivel.reiniciar_partida()
	else:
		Inventario.vida = -1.0
		Inventario.piedras = 0
		Inventario.bateria = max(Inventario.bateria, 30.0)
		get_tree().reload_current_scene()
	queue_free()
