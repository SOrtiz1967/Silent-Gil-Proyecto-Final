extends Node2D
@export var tituloIntro = ""
@export_multiline var textoIntro = ""
func _ready():
	CambioNivel.ubicarJugador(self)
	mostrarIntro()
func mostrarIntro():
	var id = "intro_" + scene_file_path.get_file()
	if textoIntro == "" or Inventario.yaRecogido(id):
		return
	Inventario.marcarRecogido(id)
	Tutorial.mostrarTexto(tituloIntro, textoIntro)
