extends Area2D
@export var destino:NodePath
@export var textoAviso = "F para subir"
var jugadorCerca = false
var jugador = null
func _process(delta):
	if jugadorCerca and Input.is_action_just_pressed("interactuar"):
		jugador.global_position = get_node(destino).global_position
		jugadorCerca = false
		Inventario.ocultarAviso()
func alEntrarCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugador = cuerpo
		jugadorCerca = true
		Inventario.mostrarAviso(textoAviso)
func alSalirCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = false
		Inventario.ocultarAviso()
