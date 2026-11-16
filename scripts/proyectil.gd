extends Area2D
#sirve para las piedras y, con otros valores en la escena, para las bengalas
@export var velocidad = 400.0
@export var distancia_maxima = 4000.0
@export var dano = 2

var direccion = Vector2.RIGHT
var posicion_inicial = Vector2.ZERO

func _ready() -> void:
	posicion_inicial = global_position

func _physics_process(delta: float) -> void:
	global_position += direccion * velocidad * delta
	if global_position.distance_to(posicion_inicial) >= distancia_maxima:
		queue_free()

#por si queda trabado en algun lado, el timer lo borra
func _on_temporizador_vida_timeout() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigo"):
		body.recibir_daño(dano)
		queue_free()
