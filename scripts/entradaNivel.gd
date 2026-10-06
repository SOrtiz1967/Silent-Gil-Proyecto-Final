extends Area2D
@export var idLlaveRequerida = ""
@export var rutaNivel = ""
@export var puntoDestino = ""
@export var mensajeBloqueada = "Esta cerrada con llave"
@export var textoAviso = "F para entrar"
var jugadorCerca = false
func _process(delta):
	if jugadorCerca and Input.is_action_just_pressed("interactuar"):
		intentarEntrar()
func intentarEntrar():
	if idLlaveRequerida != "" and not Inventario.tieneLlave(idLlaveRequerida):
		Inventario.mostrarMensaje(mensajeBloqueada)
		return
	jugadorCerca = false
	Inventario.ocultarAviso()
	CambioNivel.ir(rutaNivel, puntoDestino)
func alEntrarCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = true
		Inventario.mostrarAviso(textoAviso)
func alSalirCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = false
		Inventario.ocultarAviso()
