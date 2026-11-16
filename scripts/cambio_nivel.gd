extends Node
#autoload, se usa para pasar de un nivel a otro y que el jugador aparezca en el lugar correcto
const ruta_inicio = "res://escenas/niveles/nivel_1.tscn"
var punto_destino = ""
var intro_tren_hecha = false

#en el menu principal no tienen que andar el inventario, la ayuda ni la pausa
func en_menu() -> bool:
	return get_tree().current_scene is MenuPrincipal

func ir(ruta_nivel: String, punto: String) -> void:
	punto_destino = punto
	#call_deferred porque si cambio de escena en medio de un area entered se rompe todo
	get_tree().change_scene_to_file.call_deferred(ruta_nivel)

#borra todo lo que se junto en la partida y arranca desde la intro del tren.
#lo usan el boton Jugar del menu principal y la pantalla de muerte cuando se pierden las 3 vidas
func reiniciar_partida() -> void:
	Inventario.reiniciar()
	Tutorial.vistos.clear()
	Enemigo.muertes_sin_botin = 0
	intro_tren_hecha = false
	punto_destino = ""
	get_tree().change_scene_to_file.call_deferred(ruta_inicio)

func ubicar_jugador(nivel: Node) -> void:
	if punto_destino == "":
		return
	var marcador = nivel.get_node_or_null(punto_destino)
	var jugador = nivel.get_node_or_null("Jugador")
	if marcador and jugador:
		jugador.global_position = marcador.global_position
	punto_destino = ""
