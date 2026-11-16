extends Area2D
#al entrar a la zona salta el tutorial con ese id (una sola vez)
@export var id_tutorial = ""

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		Tutorial.mostrar(id_tutorial)
