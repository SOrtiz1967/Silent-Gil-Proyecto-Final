extends Node2D
@export var idTutorialInicial = "intro"
func _ready():
	Tutorial.mostrar(idTutorialInicial)
