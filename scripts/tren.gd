extends Node2D
@export var velocidadMaxima = 120.0
@export var aceleracion = 12.0
@export var espera = 3.0
@export var velocidadCaminata = 90.0
@export var salida = Vector2(2192, 740)
var estado = "quieto"
var velocidad = 0.0
var tiempo = 0.0
var jugador = null
@onready var colision = $Cuerpo/Colision
func iniciar(nodoJugador):
	jugador = nodoJugador
	jugador.controlBloqueado = true
	jugador.mirando = "derecha"
	jugador.global_position = global_position + Vector2(64, 420)
	colision.disabled = true
	estado = "bajando"
func _process(delta):
	match estado:
		"bajando":
			jugador.global_position = jugador.global_position.move_toward(salida, velocidadCaminata * delta)
			if jugador.global_position == salida:
				jugador.controlBloqueado = false
				colision.disabled = false
				CambioNivel.introTrenHecha = true
				tiempo = espera
				estado = "esperando"
		"esperando":
			tiempo -= delta
			if tiempo <= 0.0:
				estado = "partiendo"
		"partiendo":
			velocidad = min(velocidad + aceleracion * delta, velocidadMaxima)
			position.y -= velocidad * delta
			if position.y < -640.0:
				queue_free()
