extends Area2D
@export var idLlaveRequerida = ""
@export var consumirLlave = false
@export var mensajeBloqueada = "Esta cerrada"
@export var mensajeAbierta = "Abriste la puerta"
@export var forzar = false
@export var forzarSiNoHayLlave = false
@export var idTutorialAlAbrir = ""
@export var bloqueosExtra:Array[NodePath] = []
var jugadorCerca = false
var abierta = false
@onready var imagen = get_node_or_null("Sprite2D")
@onready var colisionBloqueo = get_node_or_null("Bloqueo/ColisionBloqueo")
func _process(delta):
	if jugadorCerca and not abierta and Input.is_action_just_pressed("interactuar"):
		intentarAbrir()
func intentarAbrir():
	if forzar:
		intentarForzar()
	elif puedeAbrir():
		abrir()
	elif forzarSiNoHayLlave:
		intentarForzar()
	else:
		Inventario.mostrarMensaje(mensajeBloqueada)
func intentarForzar():
	if Inventario.tieneGanzua():
		Cerradura.iniciar(self)
	else:
		Pernos.iniciar(self)
func puedeAbrir():
	return idLlaveRequerida=="" or Inventario.tieneLlave(idLlaveRequerida)
func abrir():
	abierta = true
	if consumirLlave:
		Inventario.quitarLlave(idLlaveRequerida)
	if imagen:
		imagen.visible = false
	if colisionBloqueo:
		colisionBloqueo.disabled = true
	for ruta in bloqueosExtra:
		get_node(ruta).disabled = true
	Inventario.mostrarMensaje(mensajeAbierta)
	if idTutorialAlAbrir != "":
		Tutorial.mostrar(idTutorialAlAbrir)
func alEntrarCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = true
func alSalirCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = false
