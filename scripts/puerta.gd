extends Area2D
@export var idLlaveRequerida = ""
@export var consumirLlave = false
@export var mensajeBloqueada = "Esta cerrada"
@export var mensajeAbierta = "Abriste la puerta"
@export var forzar = false
var jugadorCerca = false
var abierta = false
@onready var imagen = $Sprite2D
@onready var colisionBloqueo = $Bloqueo/ColisionBloqueo
func _process(delta):
	if jugadorCerca and not abierta and Input.is_action_just_pressed("interactuar"):
		intentarAbrir()
func intentarAbrir():
	if forzar:
		intentarForzar()
	elif puedeAbrir():
		abrir()
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
	imagen.visible = false
	colisionBloqueo.disabled = true
	Inventario.mostrarMensaje(mensajeAbierta)
func alEntrarCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = true
func alSalirCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = false
