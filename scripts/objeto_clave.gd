@tool
extends Area2D
#llaves y ganzuas tiradas por el mapa. Se agarran con F
#es @tool para que en el editor tambien se vea el sprite de la sube, el silbato y la ganzua
@export var id_llave = ""
@export var nombre_objeto = "Llave"
@export var mensaje_recogida = "Obtuviste"
@export var es_ganzua = false
@export var tutorial_propio = ""

#las llaves usan el sprite de llave.svg, estos tienen el suyo
const sprites = {
	"sube": "res://assets/sube.svg",
	"silbato": "res://assets/silbato.svg",
}

var id_objeto = ""
var jugador_cerca = false

func _ready() -> void:
	if es_ganzua:
		$Sprite2D.texture = load("res://assets/ganzua.svg")
	elif sprites.has(id_llave):
		$Sprite2D.texture = load(sprites[id_llave])
	#en el editor solo se cambia el sprite, lo demas es del juego
	if Engine.is_editor_hint():
		return
	id_objeto = str(get_path())
	if Inventario.ya_recogido(id_objeto):
		queue_free()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		recoger()

func recoger() -> void:
	if es_ganzua:
		Inventario.agregar_ganzua()
		mostrar_tutorial("ganzua")
	else:
		Inventario.agregar_llave(id_llave, nombre_objeto)
		mostrar_tutorial("llave")
	Inventario.ocultar_aviso()
	Inventario.marcar_recogido(id_objeto)
	Inventario.mostrar_mensaje(mensaje_recogida + " " + nombre_objeto)
	queue_free()

#si tiene un tutorial propio (la sube, el powerbank) muestra ese en vez del de llave
func mostrar_tutorial(id_por_defecto: String) -> void:
	if tutorial_propio == "":
		Tutorial.mostrar(id_por_defecto)
	else:
		Tutorial.mostrar(tutorial_propio)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = true
		Inventario.mostrar_aviso("F para agarrar " + nombre_objeto)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = false
		Inventario.ocultar_aviso()
