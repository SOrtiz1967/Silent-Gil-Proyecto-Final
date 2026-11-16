extends Area2D
#al pisarla te manda al nodo "destino". Con solo_con_luz solo funciona si tenes la linterna prendida
@export var destino: NodePath
@export var mensaje = ""
@export var solo_con_luz = false

func _physics_process(delta: float) -> void:
	for cuerpo in get_overlapping_bodies():
		if cuerpo.is_in_group("jugador"):
			teletransportar(cuerpo)

func teletransportar(jugador: Node2D) -> void:
	if solo_con_luz and not jugador.linterna_encendida:
		return
	jugador.global_position = get_node(destino).global_position
	if mensaje != "":
		Inventario.mostrar_mensaje(mensaje)
