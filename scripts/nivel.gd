extends Node2D
class_name Nivel
#script base de los niveles: acomoda al jugador y muestra el texto de la historia la primera vez
@export var titulo_intro = ""
@export_multiline var texto_intro = ""

func _ready() -> void:
	CambioNivel.ubicar_jugador(self)
	mostrar_intro()

func mostrar_intro() -> void:
	#el id sale del nombre del archivo asi cada nivel muestra su intro una sola vez
	var id = "intro_" + scene_file_path.get_file()
	if texto_intro == "" or Inventario.ya_recogido(id):
		return
	Inventario.marcar_recogido(id)
	Tutorial.mostrar_texto(titulo_intro, texto_intro)
