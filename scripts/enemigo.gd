extends CharacterBody2D
const Consumible = preload("res://escenas/consumible.tscn")
const BEBIDAS = [
	["Cerveza", "res://assets/argentinian-assets-pack-v1.0 (1)/bebidas/cerveza-01.png", 1.0, 90.0],
	["Gaseosa de uva", "res://assets/argentinian-assets-pack-v1.0 (1)/bebidas/gaseosa-uva.png", 1.0, 90.0],
	["Esto no es coca papi", "res://assets/argentinian-assets-pack-v1.0 (1)/bebidas/esto-no-es-coca-papi-con-espuma.png", 2.0, 0.0]
]
@export var probabilidadBotin = 0.7
static var muertesSinBotin = 0
@export var vida = 6
@export var velocidad = 60.0
@export var rangoAtaque = 40.0
@export var dano = 1
@export var rangoDeteccion = 250.0
var persiguiendo = false
@export var colorNormal: Color = Color(1, 1, 1)
@export var colorDano: Color = Color(3, 3, 3)
@export var fps = 6.0
var tiempoAnim = 0.0
@export var variante = 0
@onready var jugador = get_tree().get_first_node_in_group("jugador")
@onready var temporizador_ataque = $TemporizadorAtaque
@onready var temporizadorFlash = $TemporizadorFlash
@onready var sprite = $Sprite2D
func _ready():
	sprite.texture = load("res://assets/plaza/vagabundo_%d.png" % variante)
func _process(delta):
	tiempoAnim += delta * (1.6 if persiguiendo else 1.0)
	sprite.frame = int(tiempoAnim * fps) % 4
	if absf(velocity.x) > 1.0:
		sprite.flip_h = velocity.x < 0.0
func _physics_process(delta):
	if jugador:
		var distancia = global_position.distance_to(jugador.global_position)
		if not persiguiendo and distancia <= rangoDeteccion:
			persiguiendo = true
		if not persiguiendo:
			velocity = Vector2.ZERO
		elif distancia > rangoAtaque:
			velocity = global_position.direction_to(jugador.global_position) * velocidad
		else:
			velocity = Vector2.ZERO
			if temporizador_ataque.is_stopped():
				jugador.recibirDano(dano)
				temporizador_ataque.start()
	else:
		velocity = Vector2.ZERO
	move_and_slide()
func recibirDano(cantidad):
	vida -= cantidad
	if vida <= 0:
		soltarBotin()
		queue_free()
		return
	mostrarFlash()
func mostrarFlash():
	sprite.modulate = colorDano
	temporizadorFlash.start()
func _on_temporizador_flash_timeout():
	sprite.modulate = colorNormal
func soltarBotin():
	if randf() > probabilidadBotin and muertesSinBotin < 1:
		muertesSinBotin += 1
		return
	muertesSinBotin = 0
	var b = BEBIDAS.pick_random()
	var c = Consumible.instantiate()
	c.persistente = false
	c.curacion = 0.5
	c.verbo = "tomar"
	c.nombreConsumible = b[0]
	c.rutaTextura = b[1]
	c.escala = b[2]
	c.rotacion = b[3]
	c.position = global_position
	get_parent().call_deferred("add_child", c)
	Inventario.mostrarMensaje("Solto una bebida: " + b[0])
