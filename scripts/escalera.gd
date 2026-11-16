extends Area2D
#escalera dentro del mismo nivel, te lleva al nodo "destino"
@export var destino: NodePath
@export var texto_aviso = "F para subir"

var jugador_cerca = false
var jugador = null

func _process(delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		jugador.global_position = get_node(destino).global_position
		jugador_cerca = false
		Inventario.ocultar_aviso()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador = body
		jugador_cerca = true
		Inventario.mostrar_aviso(texto_aviso)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = false
		Inventario.ocultar_aviso()
