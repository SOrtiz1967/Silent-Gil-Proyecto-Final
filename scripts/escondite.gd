extends Area2D
@export var textoAviso = "F para revisar"
@export var mensajeEncontrado = "Sacaste una hamburguesa"
@export var mensajeVacio = "No hay nada"
var idObjeto = ""
var jugadorCerca = false
var revisado = false
func _ready():
	idObjeto = str(get_path())
	revisado = Inventario.yaRecogido(idObjeto)
func _process(delta):
	if jugadorCerca and Input.is_action_just_pressed("interactuar") and not Tutorial.activo:
		revisar()
func revisar():
	if revisado:
		Inventario.mostrarMensaje(mensajeVacio)
		return
	revisado = true
	Inventario.marcarRecogido(idObjeto)
	Inventario.hamburguesas += 1
	Inventario.ocultarAviso()
	Inventario.mostrarMensaje(mensajeEncontrado + ". Llevala al Cliente o comela con C")
	Tutorial.mostrar("hamburguesa")
func alEntrarCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = true
		Inventario.mostrarAviso(textoAviso)
func alSalirCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = false
		Inventario.ocultarAviso()
