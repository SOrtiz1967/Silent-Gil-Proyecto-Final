extends "res://scripts/enemigo.gd"
# El Guarda del ultimo tren. Con la linterna prendida te ve de lejos y te persigue.
# A oscuras no te ve: camina despacio hacia donde vio tu luz por ultima vez,
# y si estas pegado a el te pega igual. Si le pegas, toca el silbato y te
# persigue rapido un rato aunque tengas la luz apagada.
@export var velocidadOscuras = 35.0
@export var velocidadSilbato = 140.0
@export var duracionSilbato = 3.0
@export var cadaCuantoFrase = 8.0
var velocidadBase = 0.0
var ultimaPosicionVista = null
var silbato = 0.0
var tiempoFrase = 0.0
var yaTeVio = false
func _ready():
	super()
	velocidadBase = velocidad
	soloConLuz = false
	colorNormal = Color(0.45, 0.55, 1.0)
	sprite.modulate = colorNormal
func _physics_process(delta):
	if jugador == null or aturdido > 0.0:
		super(delta)
		return
	tiempoFrase -= delta
	if silbato > 0.0:
		silbato -= delta
		velocidad = velocidadSilbato
		persiguiendo = true
		ultimaPosicionVista = jugador.global_position
		super(delta)
		return
	var distancia = global_position.distance_to(jugador.global_position)
	if jugador.linternaEncendida:
		velocidad = velocidadBase
		if distancia <= rangoDeteccion:
			ultimaPosicionVista = jugador.global_position
			decirFrase()
		super(delta)
		return
	persiguiendo = false
	if distancia <= rangoAtaque:
		velocity = Vector2.ZERO
		atacar(delta)
	elif ultimaPosicionVista != null and global_position.distance_to(ultimaPosicionVista) > 12.0:
		cancelarPreparacion()
		velocity = global_position.direction_to(ultimaPosicionVista) * velocidadOscuras
	else:
		cancelarPreparacion()
		velocity = Vector2.ZERO
	move_and_slide()
func decirFrase():
	if yaTeVio and tiempoFrase > 0.0:
		return
	yaTeVio = true
	tiempoFrase = cadaCuantoFrase
	Inventario.mostrarMensaje("EL GUARDA: «Última estación. Todos bajan.»")
func recibirDano(cantidad):
	super(cantidad)
	if vida > 0:
		silbato = duracionSilbato
		Inventario.mostrarMensaje("¡PRIIIIII! El Guarda toca el silbato y te persigue")
