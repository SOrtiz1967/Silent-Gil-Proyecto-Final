extends Area2D

@export var velocidad = 400.0

var direccion = Vector2.RIGHT

func _physics_process(delta):
	position += direccion * velocidad * delta

func _on_temporizador_vida_timeout():
	queue_free()

func _on_area_entered(area):
	print("el disparo pego a: ", area.name)
	queue_free()
