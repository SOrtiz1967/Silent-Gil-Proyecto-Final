extends Node
#autoload, se usa para pasar de un nivel a otro y que el jugador aparezca en el lugar correcto
var punto_destino = ""
var intro_tren_hecha = false

func ir(ruta_nivel: String, punto: String) -> void:
	punto_destino = punto
	#call_deferred porque si cambio de escena en medio de un area entered se rompe todo
	get_tree().change_scene_to_file.call_deferred(ruta_nivel)

func ubicar_jugador(nivel: Node) -> void:
	if punto_destino == "":
		return
	var marcador = nivel.get_node_or_null(punto_destino)
	var jugador = nivel.get_node_or_null("Jugador")
	if marcador and jugador:
		jugador.global_position = marcador.global_position
	punto_destino = ""
