extends Area2D
@export var curacion = 1.0
@export var nombreConsumible = "Golosina"
@export var verbo = "comer"
@export_file("*.png") var rutaTextura = ""
@export var escala = 2.0
@export var rotacion = 0.0
@export var persistente = true
@export var radioInteraccion = 48.0
var idObjeto = ""
var jugador = null
var tiempo = 0.0
@onready var sprite = $Sprite2D
@onready var luz = $Luz
func _ready():
	if rutaTextura != "":
		sprite.texture = load(rutaTextura)
	sprite.scale = Vector2(escala, escala)
	sprite.rotation_degrees = rotacion
	var forma = CircleShape2D.new()
	forma.radius = radioInteraccion
	$ColisionZona.shape = forma
	tiempo = randf() * 6.0
	if not persistente:
		sprite.position.y = -26.0
		var caida = create_tween()
		caida.tween_property(sprite, "position:y", 0.0, 0.35).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	if persistente:
		idObjeto = str(get_path())
		if Inventario.yaRecogido(idObjeto):
			queue_free()
func _process(delta):
	tiempo += delta
	luz.energy = 0.5 + 0.12 * sin(tiempo * 3.0)
	if jugador and Input.is_action_just_pressed("interactuar"):
		consumir()
func textoCuracion():
	if curacion == floor(curacion):
		return str(int(curacion))
	return str(curacion).replace(".", ",")
func consumir():
	if jugador.vida >= jugador.vidaMaxima:
		Inventario.mostrarMensaje("Tenes la vida llena")
		return
	jugador.curar(curacion)
	Inventario.ocultarAviso()
	Inventario.mostrarMensaje(nombreConsumible + ": +" + textoCuracion() + " de vida")
	if persistente:
		Inventario.marcarRecogido(idObjeto)
	queue_free()
func alEntrarCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugador = cuerpo
		Inventario.mostrarAviso("F para " + verbo + " " + nombreConsumible + " (+" + textoCuracion() + " vida)")
func alSalirCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugador = null
		Inventario.ocultarAviso()
