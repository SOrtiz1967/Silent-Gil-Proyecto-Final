extends Area2D
@export var idLlave = ""
@export var nombreObjeto = "Llave"
@export var mensajeRecogida = "Obtuviste"
@export var esGanzua = false
var idObjeto = ""
var jugadorCerca = false
func _ready():
	idObjeto = str(get_path())
	if Inventario.yaRecogido(idObjeto):
		queue_free()
func _process(delta):
	if jugadorCerca and Input.is_action_just_pressed("interactuar"):
		recoger()
func recoger():
	if esGanzua:
		Inventario.agregarGanzua()
		Tutorial.mostrar("ganzua")
	else:
		Inventario.agregarLlave(idLlave, nombreObjeto)
		Tutorial.mostrar("llave")
	Inventario.marcarRecogido(idObjeto)
	Inventario.mostrarMensaje(mensajeRecogida + " " + nombreObjeto)
	queue_free()
func alEntrarCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = true
func alSalirCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = false
