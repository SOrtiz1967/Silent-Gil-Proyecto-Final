extends Area2D
#puertas, rejas y molinetes. Se abren con llave o se fuerzan con la ganzua / los pernos
@export var llave_requerida = ""
@export var consumir_llave = false
@export var mensaje_bloqueada = "Esta cerrada"
@export var mensaje_abierta = "Abriste la puerta"
@export var texto_aviso = "F para abrir"
@export var forzar = false
@export var forzar_sin_llave = false
@export var tutorial_al_abrir = ""
@export var bloqueos_extra: Array[NodePath] = []

var jugador_cerca = false
var abierta = false

@onready var imagen = get_node_or_null("Sprite2D")
@onready var colision_bloqueo = get_node_or_null("Bloqueo/ColisionBloqueo")

func _process(delta: float) -> void:
	if jugador_cerca and not abierta and Input.is_action_just_pressed("interactuar"):
		intentar_abrir()

func intentar_abrir() -> void:
	if forzar:
		intentar_forzar()
	elif puede_abrir():
		abrir()
	elif forzar_sin_llave:
		intentar_forzar()
	else:
		Inventario.mostrar_mensaje(mensaje_bloqueada)

#con ganzuas va el minijuego de la cerradura, sin ganzuas el de los pernos
func intentar_forzar() -> void:
	if Inventario.tiene_ganzua():
		Cerradura.iniciar(self)
	else:
		Pernos.iniciar(self)

func puede_abrir() -> bool:
	return llave_requerida == "" or Inventario.tiene_llave(llave_requerida)

func abrir() -> void:
	abierta = true
	Inventario.ocultar_aviso()
	if consumir_llave:
		Inventario.quitar_llave(llave_requerida)
	if imagen:
		imagen.visible = false
	if colision_bloqueo:
		colision_bloqueo.disabled = true
	for ruta in bloqueos_extra:
		get_node(ruta).disabled = true
	Inventario.mostrar_mensaje(mensaje_abierta)
	#le aviso al pathfinding que ahora se puede pasar por ahi
	get_tree().call_group("pathfinding", "actualizar")
	if tutorial_al_abrir != "":
		Tutorial.mostrar(tutorial_al_abrir)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = true
		if not abierta:
			Inventario.mostrar_aviso(texto_aviso)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = false
		Inventario.ocultar_aviso()
