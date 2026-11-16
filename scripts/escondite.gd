extends Area2D
#lugares donde esta escondida una hamburguesa del Cliente. Se revisan con F
@export var texto_aviso = "F para revisar"
@export var mensaje_encontrado = "Sacaste una hamburguesa"
@export var mensaje_vacio = "No hay nada"

var id_objeto = ""
var jugador_cerca = false
var revisado = false

func _ready() -> void:
	id_objeto = str(get_path())
	revisado = Inventario.ya_recogido(id_objeto)

func _process(delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("interactuar") and not Tutorial.activo:
		revisar()

func revisar() -> void:
	if revisado:
		Inventario.mostrar_mensaje(mensaje_vacio)
		return
	revisado = true
	Inventario.marcar_recogido(id_objeto)
	Inventario.hamburguesas += 1
	Inventario.ocultar_aviso()
	Inventario.mostrar_mensaje(mensaje_encontrado + ". Llevala al Cliente o comela con C")
	Tutorial.mostrar("hamburguesa")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = true
		Inventario.mostrar_aviso(texto_aviso)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = false
		Inventario.ocultar_aviso()
