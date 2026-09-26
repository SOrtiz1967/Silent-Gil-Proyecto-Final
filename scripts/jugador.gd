extends CharacterBody2D

const Proyectil = preload("res://escenas/proyectil.tscn")

@export var velocidad = 200.0
@export var duracion_golpe = 0.3
@export var distancia_golpe = 24.0
@export var distancia_disparo = 20.0
@export var dano = 1
@export var vidaMaxima = 3

var mirando = "abajo"
var golpeando = false
var vida = vidaMaxima

@onready var zona_golpe = $ZonaGolpe
@onready var temporizador_golpe = $TemporizadorGolpe

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

func disparar():
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
	vida -= cantidad
	if vida <= 0:
		morir()

func morir():
	get_tree().reload_current_scene()
