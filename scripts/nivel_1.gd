extends Node2D
@export var idTutorialInicial = "intro"
func _ready():
	CambioNivel.ubicarJugador(self)
	if CambioNivel.introTrenHecha:
		$Tren.queue_free()
	else:
		$Tren.iniciar($Jugador)
	Tutorial.mostrar(idTutorialInicial)
