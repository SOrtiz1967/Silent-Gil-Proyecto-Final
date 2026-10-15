extends Area2D
@export var titulo = "CARTEL"
@export_multiline var texto = ""
@export_file("*.png") var rutaTextura = "res://assets/carteles/cartel_madera.png"
var jugadorCerca = false
@onready var sprite = $Sprite2D
func _ready():
	sprite.texture = load(rutaTextura)
func _process(delta):
	if jugadorCerca and Input.is_action_just_pressed("interactuar") and not Tutorial.activo:
		Tutorial.mostrarTexto(titulo, texto)
func alEntrarCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = true
		Inventario.mostrarAviso("F para leer el cartel")
func alSalirCuerpo(cuerpo):
	if cuerpo.is_in_group("jugador"):
		jugadorCerca = false
		Inventario.ocultarAviso()
