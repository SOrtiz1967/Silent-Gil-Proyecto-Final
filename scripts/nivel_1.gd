extends Nivel
@export var id_tutorial_inicial = "intro"

func _ready() -> void:
	super()
	#el tren de la intro solo pasa la primera vez que se entra al nivel
	if CambioNivel.intro_tren_hecha:
		$Tren.queue_free()
	else:
		$Tren.iniciar($Jugador)
	Tutorial.mostrar(id_tutorial_inicial)
