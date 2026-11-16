extends Enemigo
#el Cliente es un fisura que tiene la llave del candado del subte.
#te la da si le llevas sus 3 hamburguesas. Si te comes una, pelea a muerte
const escondites = [
	{"nodo": "EsconditeHorno", "pista": "La primera está donde se cocinan las hamburguesas."},
	{"nodo": "EsconditeBano", "pista": "Otra se la llevó alguien al baño. No me preguntes por qué."},
	{"nodo": "EsconditeSillon", "pista": "La última... alguien se sentó encima. En los sillones de arriba."},
]

@export var velocidad_furioso = 95.0
@export var radio_charla = 80.0

var furioso = false
var jugador_cerca = false

func _ready() -> void:
	sprite.texture = load("res://assets/plaza/vagabundo_%d.png" % variante)
	if Inventario.cliente_enojado and Inventario.tiene_llave(llave_botin):
		queue_free()
		return
	#zona para poder hablarle, la armo por codigo con el radio de charla
	var zona = Area2D.new()
	var forma = CollisionShape2D.new()
	forma.shape = CircleShape2D.new()
	forma.shape.radius = radio_charla
	zona.add_child(forma)
	add_child(zona)
	zona.body_entered.connect(_on_zona_charla_body_entered)
	zona.body_exited.connect(_on_zona_charla_body_exited)

func _process(delta: float) -> void:
	super(delta)
	if jugador_cerca and not Inventario.cliente_enojado and not Tutorial.activo and Input.is_action_just_pressed("interactuar"):
		hablar()

func _physics_process(delta: float) -> void:
	#mientras no lo hagan enojar se queda quieto
	if not Inventario.cliente_enojado:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	if not furioso:
		enfurecer()
	super(delta)

func enfurecer() -> void:
	furioso = true
	velocidad = velocidad_furioso
	rango_deteccion = 3000.0
	persiguiendo = true
	if jugador_cerca:
		Inventario.ocultar_aviso()
	Inventario.mostrar_mensaje("EL CLIENTE: «Se terminó el trato.»")

#devuelve la pista del primer escondite que todavia no se revisó
func pista_siguiente() -> String:
	for escondite in escondites:
		var nodo = get_parent().get_node_or_null(escondite["nodo"])
		if nodo != null and not nodo.revisado:
			return escondite["pista"]
	return "Ya las encontraste todas. Traémelas."

func hablar() -> void:
	if Inventario.hamburguesas_entregadas >= 3:
		Tutorial.mostrar_texto("EL CLIENTE", "Ya tenés la llave. Dejame comer en paz.")
		return
	if Inventario.hamburguesas > 0:
		entregar()
		return
	var texto = ""
	if Inventario.hamburguesas_entregadas == 0:
		texto = "No me molestes, estoy esperando mi pedido. El 307. Hace rato.\n\n¿La llave del candado? Sí, la tengo yo. Te la doy si me traés mis tres hamburguesas: alguien las escondió acá adentro. Y ni se te ocurra comerte una.\n\n"
	else:
		texto = "Me faltan " + str(3 - Inventario.hamburguesas_entregadas) + ".\n\n"
	Tutorial.mostrar_texto("EL CLIENTE", texto + pista_siguiente())

func entregar() -> void:
	Inventario.hamburguesas -= 1
	Inventario.hamburguesas_entregadas += 1
	if Inventario.hamburguesas_entregadas >= 3:
		Inventario.agregar_llave(llave_botin, nombre_llave_botin)
		Inventario.mostrar_mensaje("Obtuviste " + nombre_llave_botin)
		Tutorial.mostrar_texto("EL CLIENTE", "Las tres. Tomá la llave del candado.\n\nAhora andate y dejame comer.")
		return
	var faltan = 3 - Inventario.hamburguesas_entregadas
	Tutorial.mostrar_texto("EL CLIENTE", "(Se la come sin mirarte.)\n\nMe falta" + ("" if faltan == 1 else "n") + " " + str(faltan) + ".\n\n" + pista_siguiente())

#pegarle tambien rompe el trato
func recibir_daño(cantidad: float) -> void:
	if not Inventario.cliente_enojado:
		Inventario.cliente_enojado = true
	super(cantidad)

func _on_zona_charla_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = true
		if not Inventario.cliente_enojado:
			Inventario.mostrar_aviso("F para hablar con el Cliente")

func _on_zona_charla_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = false
		Inventario.ocultar_aviso()
