extends Area2D
#poste para cargar el celular. Hay que mantener F
@export var velocidad_carga = 5.0

var jugador_cerca = false
var tiempo = 0.0

@onready var luz = $Luz

func _process(delta: float) -> void:
	tiempo += delta
	luz.energy = 0.8 + 0.12 * sin(tiempo * 3.0)
	if not jugador_cerca:
		return
	if Inventario.tiene_llave("powerbank"):
		Inventario.mostrar_aviso("No necesito cargar, tengo el powerbank")
	elif Inventario.bateria >= 100.0:
		Inventario.mostrar_aviso("Celular cargado")
	elif Input.is_action_pressed("interactuar"):
		Inventario.cargar_bateria(velocidad_carga * delta)
		Inventario.mostrar_aviso("Cargando celular... " + str(int(Inventario.bateria)) + "%")
	else:
		Inventario.mostrar_aviso("Mantene F para cargar el celular")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = false
		Inventario.ocultar_aviso()
