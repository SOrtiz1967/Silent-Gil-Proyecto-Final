extends Area2D

@export var velocidad = 400.0
@export var distanciaMaxima = 4000.0
@export var dano = 2

var direccion = Vector2.RIGHT
var posicionInicial = Vector2.ZERO

func _ready():
	posicionInicial = global_position

func _physics_process(delta):
	global_position += direccion * velocidad * delta
	if global_position.distance_to(posicionInicial) >= distanciaMaxima:
		queue_free()

func _on_temporizador_vida_timeout():
	queue_free()

func _on_area_entered(area):
	queue_free()

func _on_body_entered(cuerpo):
	if cuerpo.is_in_group("enemigo"):
		cuerpo.recibirDano(dano)
		queue_free()
