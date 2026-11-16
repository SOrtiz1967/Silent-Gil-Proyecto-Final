extends Area2D
#muestra un mensaje una sola vez cuando el jugador entra a la zona
@export_multiline var mensaje = ""

var id_objeto = ""

func _ready() -> void:
	id_objeto = str(get_path())

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("jugador") or Inventario.ya_recogido(id_objeto):
		return
	Inventario.marcar_recogido(id_objeto)
	Inventario.mostrar_mensaje(mensaje)
