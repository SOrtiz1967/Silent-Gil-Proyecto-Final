extends Area2D
@export var velocidadCarga = 5.0
var jugadorCerca = false
var tiempo = 0.0
@onready var luz = $Luz
func _process(delta):
	tiempo += delta
	luz.energy = 0.8 + 0.12 * sin(tiempo * 3.0)
	if not jugadorCerca:
		return
	if Inventario.tieneLlave("powerbank"):
		Inventario.mostrarAviso("No necesito cargar, tengo el powerbank")
	elif Inventario.bateria >= 100.0:
		Inventario.mostrarAviso("Celular cargado")
	elif Input.is_action_pressed("interactuar"):
		Inventario.cargarBateria(velocidadCarga * delta)
		Inventario.mostrarAviso("Cargando celular... " + str(int(Inventario.bateria)) + "%")
	else:
		Inventario.mostrarAviso("Mantene F para cargar el celular")
func alEntrarCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = true
func alSalirCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = false
		Inventario.ocultarAviso()
