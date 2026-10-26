extends Area2D
@export var destino:NodePath
@export var mensaje = ""
@export var soloConLuz = false
func _physics_process(delta):
	for cuerpo in get_overlapping_bodies():
		if cuerpo.is_in_group("jugador"):
			teletransportar(cuerpo)
func teletransportar(jugador):
	if soloConLuz and not jugador.linternaEncendida:
		return
	jugador.global_position = get_node(destino).global_position
	if mensaje != "":
		Inventario.mostrarMensaje(mensaje)
