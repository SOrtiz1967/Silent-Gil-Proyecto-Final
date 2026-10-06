extends CharacterBody2D

const Proyectil = preload("res://escenas/proyectil.tscn")
const anchoBarra = 200.0

@export var velocidad = 200.0
@export var duracion_golpe = 0.3
@export var distancia_golpe = 24.0
@export var distancia_disparo = 20.0
@export var dano = 3
@export var vidaMaxima = 5
@export var duracionInvulnerable = 0.6

var mirando = "abajo"
var golpeando = false
var invulnerable = false
var vida = 0
var cantidad_piedras = 0

@onready var etiquetaPiedras = $Hud/EtiquetaPiedras
@onready var zona_golpe = $ZonaGolpe
@onready var temporizador_golpe = $TemporizadorGolpe
@onready var temporizadorInvulnerable = $TemporizadorInvulnerable
@onready var rellenoVida = $Hud/RellenoVida
@onready var etiquetaVida = $Hud/EtiquetaVida

func _ready():
	vida = vidaMaxima
	actualizarBarraVida()

func _physics_process(delta):
	if golpeando:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var entrada = Vector2.ZERO
	entrada.x = Input.get_axis("mover_izquierda", "mover_derecha")
	entrada.y = Input.get_axis("mover_arriba", "mover_abajo")
	entrada = entrada.normalized()

	if entrada.x != 0 or entrada.y != 0:
		if abs(entrada.x) > abs(entrada.y):
			mirando = "derecha" if entrada.x > 0 else "izquierda"
		else:
			mirando = "abajo" if entrada.y > 0 else "arriba"

	$Sprite2D.flip_h = mirando == "izquierda"

	velocity = entrada * velocidad
	move_and_slide()

	if Input.is_action_just_pressed("golpear"):
		golpear()
	elif Input.is_action_just_pressed("disparar"):
		disparar()

func direccion_mirando():
	match mirando:
		"arriba":
			return Vector2.UP
		"abajo":
			return Vector2.DOWN
		"izquierda":
			return Vector2.LEFT
		_:
			return Vector2.RIGHT

func golpear():
	golpeando = true
	zona_golpe.position = direccion_mirando() * distancia_golpe
	zona_golpe.monitoring = true
	temporizador_golpe.start(duracion_golpe)

func agregarPiedra():
	cantidad_piedras += 1
	actualizarPiedras()

func actualizarPiedras():
	etiquetaPiedras.text = "Piedras: " + str(cantidad_piedras)

func disparar():
	if cantidad_piedras <= 0:
		return
	cantidad_piedras -= 1
	actualizarPiedras()
	var proyectil = Proyectil.instantiate()
	get_parent().add_child(proyectil)
	proyectil.global_position = global_position + direccion_mirando() * distancia_disparo
	proyectil.direccion = direccion_mirando()

func _on_temporizador_golpe_timeout():
	golpeando = false
	zona_golpe.monitoring = false

func _on_zona_golpe_area_entered(area):
	print("golpeaste a: ", area.name)

func _on_zona_golpe_body_entered(cuerpo):
	if cuerpo.is_in_group("enemigo"):
		cuerpo.recibirDano(dano)

func recibirDano(cantidad):
	if invulnerable:
		return
	vida -= cantidad
	actualizarBarraVida()
	if vida <= 0:
		morir()
		return
	activarInvulnerable()

func activarInvulnerable():
	invulnerable = true
	$Sprite2D.modulate.a = 0.5
	temporizadorInvulnerable.start(duracionInvulnerable)

func _on_temporizador_invulnerable_timeout():
	invulnerable = false
	$Sprite2D.modulate.a = 1.0

func actualizarBarraVida():
	var vidaVisible = max(vida, 0)
	rellenoVida.size.x = anchoBarra * float(vidaVisible) / float(vidaMaxima)
	etiquetaVida.text = str(vidaVisible) + " / " + str(vidaMaxima)

func morir():
	get_tree().reload_current_scene()
