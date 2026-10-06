extends Area2D

func _on_body_entered(cuerpo):
	if cuerpo.is_in_group("jugador"):
		cuerpo.agregarPiedra()
		queue_free()
