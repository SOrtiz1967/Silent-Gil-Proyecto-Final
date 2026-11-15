extends "res://scripts/enemigo.gd"
# El Cliente: un fisura que tiene la llave del candado del subte.
# Te la da si le llevas sus 3 hamburguesas. Si te comes una, pelea a muerte.
const ESCONDITES = [
	["EsconditeHorno", "La primera está donde se cocinan las hamburguesas."],
	["EsconditeBano", "Otra se la llevó alguien al baño. No me preguntes por qué."],
	["EsconditeSillon", "La última... alguien se sentó encima. En los sillones de arriba."]
]
@export var velocidadFurioso = 95.0
@export var radioCharla = 80.0
var furioso = false
var jugadorCerca = false
func _ready():
	sprite.texture = load("res://assets/plaza/vagabundo_%d.png" % variante)
	if Inventario.clienteEnojado and Inventario.tieneLlave(idLlaveBotin):
		queue_free()
		return
	var zona = Area2D.new()
	var forma = CollisionShape2D.new()
	forma.shape = CircleShape2D.new()
	forma.shape.radius = radioCharla
	zona.add_child(forma)
	add_child(zona)
	zona.body_entered.connect(alEntrarCuerpo)
	zona.body_exited.connect(alSalirCuerpo)
func _process(delta):
	super(delta)
	if jugadorCerca and not Inventario.clienteEnojado and not Tutorial.activo and Input.is_action_just_pressed("interactuar"):
		hablar()
func _physics_process(delta):
	if not Inventario.clienteEnojado:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	if not furioso:
		enfurecer()
	super(delta)
func enfurecer():
	furioso = true
	velocidad = velocidadFurioso
	rangoDeteccion = 3000.0
	persiguiendo = true
	if jugadorCerca:
		Inventario.ocultarAviso()
	Inventario.mostrarMensaje("EL CLIENTE: «Se terminó el trato.»")
func pistaSiguiente():
	for escondite in ESCONDITES:
		var nodo = get_parent().get_node_or_null(escondite[0])
		if nodo != null and not nodo.revisado:
			return escondite[1]
	return "Ya las encontraste todas. Traémelas."
func hablar():
	if Inventario.hamburguesasEntregadas >= 3:
		Tutorial.mostrarTexto("EL CLIENTE", "Ya tenés la llave. Dejame comer en paz.")
		return
	if Inventario.hamburguesas > 0:
		entregar()
		return
	var texto = ""
	if Inventario.hamburguesasEntregadas == 0:
		texto = "No me molestes, estoy esperando mi pedido. El 307. Hace rato.\n\n¿La llave del candado? Sí, la tengo yo. Te la doy si me traés mis tres hamburguesas: alguien las escondió acá adentro. Y ni se te ocurra comerte una.\n\n"
	else:
		texto = "Me faltan " + str(3 - Inventario.hamburguesasEntregadas) + ".\n\n"
	Tutorial.mostrarTexto("EL CLIENTE", texto + pistaSiguiente())
func entregar():
	Inventario.hamburguesas -= 1
	Inventario.hamburguesasEntregadas += 1
	if Inventario.hamburguesasEntregadas >= 3:
		Inventario.agregarLlave(idLlaveBotin, nombreLlaveBotin)
		Inventario.mostrarMensaje("Obtuviste " + nombreLlaveBotin)
		Tutorial.mostrarTexto("EL CLIENTE", "Las tres. Tomá la llave del candado.\n\nAhora andate y dejame comer.")
		return
	var faltan = 3 - Inventario.hamburguesasEntregadas
	Tutorial.mostrarTexto("EL CLIENTE", "(Se la come sin mirarte.)\n\nMe falta" + ("" if faltan == 1 else "n") + " " + str(faltan) + ".\n\n" + pistaSiguiente())
func recibirDano(cantidad):
	if not Inventario.clienteEnojado:
		Inventario.clienteEnojado = true
	super(cantidad)
func alEntrarCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = true
		if not Inventario.clienteEnojado:
			Inventario.mostrarAviso("F para hablar con el Cliente")
func alSalirCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = false
		Inventario.ocultarAviso()
