extends Node
var puntoDestino = ""
func ir(rutaNivel, punto):
	puntoDestino = punto
	get_tree().change_scene_to_file.call_deferred(rutaNivel)
func ubicarJugador(nivel):
	if puntoDestino == "":
		return
	var marcador = nivel.get_node_or_null(puntoDestino)
	var jugador = nivel.get_node_or_null("Jugador")
	if marcador and jugador:
		jugador.global_position = marcador.global_position
	puntoDestino = ""
