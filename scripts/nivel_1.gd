extends Node2D
@export var idTutorialInicial = "intro"
func _ready():
	CambioNivel.ubicarJugador(self)
	Tutorial.mostrar(idTutorialInicial)
