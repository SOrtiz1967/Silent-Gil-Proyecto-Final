extends Area2D
# Muestra un mensaje una sola vez cuando el jugador entra a la zona.
@export_multiline var mensaje = ""
var idObjeto = ""
func _ready():
	idObjeto = str(get_path())
	body_entered.connect(alEntrarCuerpo)
func alEntrarCuerpo(cuerpo):
	if not cuerpo.is_in_group("jugador") or Inventario.yaRecogido(idObjeto):
		return
	Inventario.marcarRecogido(idObjeto)
	Inventario.mostrarMensaje(mensaje)
