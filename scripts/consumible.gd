extends Area2D
#cosas para curarse (alfajores, bebidas, etc). Se agarran con F
@export var curacion = 1.0
@export var nombre_consumible = "Golosina"
@export var verbo = "comer"
@export_file("*.png") var ruta_textura = ""
@export var escala = 2.0
@export var rotacion = 0.0
@export var persistente = true
@export var radio_interaccion = 48.0

var id_objeto = ""
var jugador = null
var tiempo = 0.0

@onready var sprite = $Sprite2D
@onready var luz = $Luz

func _ready() -> void:
	if ruta_textura != "":
		sprite.texture = load(ruta_textura)
	sprite.scale = Vector2(escala, escala)
	sprite.rotation_degrees = rotacion
	var forma = CircleShape2D.new()
	forma.radius = radio_interaccion
	$ColisionZona.shape = forma
	tiempo = randf() * 6.0
	if persistente:
		#los que vienen puestos en el mapa se acuerdan si ya los agarraste
		id_objeto = str(get_path())
		if Inventario.ya_recogido(id_objeto):
			queue_free()
	else:
		#los que suelta un enemigo caen con un rebote
		sprite.position.y = -26.0
		var caida = create_tween()
		caida.tween_property(sprite, "position:y", 0.0, 0.35).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func _process(delta: float) -> void:
	tiempo += delta
	luz.energy = 0.5 + 0.12 * sin(tiempo * 3.0)
	if jugador and Input.is_action_just_pressed("interactuar"):
		consumir()

func texto_curacion() -> String:
	if curacion == floor(curacion):
		return str(int(curacion))
	return str(curacion).replace(".", ",")

func consumir() -> void:
	if jugador.vida >= jugador.vida_maxima:
		Inventario.mostrar_mensaje("Tenes la vida llena")
		return
	jugador.curar(curacion)
	Inventario.ocultar_aviso()
	Inventario.mostrar_mensaje(nombre_consumible + ": +" + texto_curacion() + " de vida")
	if persistente:
		Inventario.marcar_recogido(id_objeto)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador = body
		Inventario.mostrar_aviso("F para " + verbo + " " + nombre_consumible + " (+" + texto_curacion() + " vida)")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador = null
		Inventario.ocultar_aviso()
