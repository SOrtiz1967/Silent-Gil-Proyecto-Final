extends CharacterBody2D
@export var vida = 3
@export var velocidad = 60.0
@export var rangoAtaque = 40.0
@export var dano = 1
@onready var jugador = get_tree().get_first_node_in_group("jugador")
@onready var temporizador_ataque = $TemporizadorAtaque
func _physics_process(delta):
	if jugador:
		var distancia = global_position.distance_to(jugador.global_position)
		if distancia > rangoAtaque:
			velocity = global_position.direction_to(jugador.global_position) * velocidad
		else:
			velocity = Vector2.ZERO
			if temporizador_ataque.is_stopped():
				jugador.recibirDano(dano)
				temporizador_ataque.start()
	else:
		velocity = Vector2.ZERO
	move_and_slide()
func recibirDano(cantidad):
	vida -= cantidad
	if vida <= 0:
		queue_free()
