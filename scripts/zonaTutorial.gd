extends Area2D
@export var idTutorial = ""
func alEntrarCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		Tutorial.mostrar(idTutorial)
