extends Node2D
#tren de la intro: el jugador baja, camina hasta la salida y el tren se va
enum estado {QUIETO, BAJANDO, ESPERANDO, PARTIENDO}
var estado_actual = estado.QUIETO

@export var velocidad_maxima = 120.0
@export var aceleracion = 12.0
@export var espera = 3.0
@export var velocidad_caminata = 90.0
@export var salida = Vector2(2192, 740)

var velocidad = 0.0
var tiempo = 0.0
var jugador = null

@onready var colision = $Cuerpo/Colision

func iniciar(nodo_jugador: Node2D) -> void:
	jugador = nodo_jugador
	jugador.control_bloqueado = true
	jugador.mirando = "derecha"
	jugador.global_position = global_position + Vector2(64, 420)
	colision.disabled = true
	estado_actual = estado.BAJANDO

func _process(delta: float) -> void:
	if estado_actual == estado.BAJANDO:
		jugador.global_position = jugador.global_position.move_toward(salida, velocidad_caminata * delta)
		if jugador.global_position == salida:
			jugador.control_bloqueado = false
			colision.disabled = false
			CambioNivel.intro_tren_hecha = true
			tiempo = espera
			estado_actual = estado.ESPERANDO
	elif estado_actual == estado.ESPERANDO:
		tiempo -= delta
		if tiempo <= 0.0:
			estado_actual = estado.PARTIENDO
	elif estado_actual == estado.PARTIENDO:
		velocidad = min(velocidad + aceleracion * delta, velocidad_maxima)
		position.y -= velocidad * delta
		if position.y < -640.0:
			queue_free()
