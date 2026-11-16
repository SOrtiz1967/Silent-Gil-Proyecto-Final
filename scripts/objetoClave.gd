extends Area2D
@export var idLlave = ""
@export var nombreObjeto = "Llave"
@export var mensajeRecogida = "Obtuviste"
@export var esGanzua = false
@export var idTutorialPersonalizado = ""
var idObjeto = ""
var jugadorCerca = false
# Sprite propio para los objetos que no son llaves (las llaves usan llave.svg)
const SPRITES = {
	"sube": "res://assets/sube.svg",
	"silbato": "res://assets/silbato.svg",
}
func _ready():
	if esGanzua:
		$Sprite2D.texture = load("res://assets/ganzua.svg")
	elif SPRITES.has(idLlave):
		$Sprite2D.texture = load(SPRITES[idLlave])
	idObjeto = str(get_path())
	if Inventario.yaRecogido(idObjeto):
		queue_free()
func _process(delta):
	if jugadorCerca and Input.is_action_just_pressed("interactuar"):
		recoger()
func recoger():
	if esGanzua:
		Inventario.agregarGanzua()
		mostrarTutorial("ganzua")
	else:
		Inventario.agregarLlave(idLlave, nombreObjeto)
		mostrarTutorial("llave")
	Inventario.ocultarAviso()
	Inventario.marcarRecogido(idObjeto)
	Inventario.mostrarMensaje(mensajeRecogida + " " + nombreObjeto)
	queue_free()
func mostrarTutorial(idPorDefecto):
	if idTutorialPersonalizado=="":
		Tutorial.mostrar(idPorDefecto)
	else:
		Tutorial.mostrar(idTutorialPersonalizado)
func alEntrarCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = true
		Inventario.mostrarAviso("F para agarrar " + nombreObjeto)
func alSalirCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = false
		Inventario.ocultarAviso()
