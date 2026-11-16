extends Area2D
#carteles con la historia, se leen con F
@export var titulo = "CARTEL"
@export_multiline var texto = ""
@export_file("*.png") var ruta_textura = "res://assets/carteles/cartel_madera.png"

var jugador_cerca = false

@onready var sprite = $Sprite2D

func _ready() -> void:
	sprite.texture = load(ruta_textura)

func _process(delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("interactuar") and not Tutorial.activo:
		Tutorial.mostrar_texto(titulo, texto)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = true
		Inventario.mostrar_aviso("F para leer el cartel")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = false
		Inventario.ocultar_aviso()
