extends Enemigo
#el Guardia del ultimo tren. Con la linterna prendida te ve de lejos y te persigue.
#A oscuras no te ve: camina despacio hacia donde vio tu luz por ultima vez,
#y si estas pegado a el te pega igual. Si le pegas, toca el silbato y te
#persigue rapido un rato aunque tengas la luz apagada.
@export var velocidad_oscuras = 35.0
@export var velocidad_silbato = 140.0
@export var duracion_silbato = 3.0
@export var cada_cuanto_frase = 8.0

var velocidad_base = 0.0
var ultima_posicion_vista = null
var silbato = 0.0
var tiempo_frase = 0.0
var ya_te_vio = false

func _ready() -> void:
	super()
	velocidad_base = velocidad
	solo_con_luz = false
	color_normal = Color(0.45, 0.55, 1.0)
	sprite.modulate = color_normal

func _physics_process(delta: float) -> void:
	if jugador == null or aturdido > 0.0:
		super(delta)
		return
	tiempo_frase -= delta
	#mientras suena el silbato persigue igual, tengas luz o no
	if silbato > 0.0:
		silbato -= delta
		velocidad = velocidad_silbato
		persiguiendo = true
		ultima_posicion_vista = jugador.global_position
		super(delta)
		return
	var distancia = global_position.distance_to(jugador.global_position)
	if jugador.linterna_encendida:
		velocidad = velocidad_base
		if distancia <= rango_deteccion:
			ultima_posicion_vista = jugador.global_position
			decir_frase()
		super(delta)
		return
	#sin luz no te ve, va a donde vio la luz por ultima vez
	persiguiendo = false
	if distancia <= rango_ataque:
		velocity = Vector2.ZERO
		atacar(delta)
	elif ultima_posicion_vista != null and global_position.distance_to(ultima_posicion_vista) > 12.0:
		cancelar_preparacion()
		velocity = global_position.direction_to(ultima_posicion_vista) * velocidad_oscuras
	else:
		cancelar_preparacion()
		velocity = Vector2.ZERO
	move_and_slide()

func decir_frase() -> void:
	if ya_te_vio and tiempo_frase > 0.0:
		return
	ya_te_vio = true
	tiempo_frase = cada_cuanto_frase
	Inventario.mostrar_mensaje("EL GUARDIA: «Última estación. Todos bajan.»")

func recibir_daño(cantidad: float) -> void:
	super(cantidad)
	if vida > 0:
		silbato = duracion_silbato
		Inventario.mostrar_mensaje("¡PRIIIIII! El Guardia toca el silbato y te persigue")
