extends CharacterBody2D

@export var velocidad = 200.0
@export var duracion_golpe = 0.3

var mirando_derecha = true
var golpeando = false

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

	if entrada.x > 0:
		mirando_derecha = true
	elif entrada.x < 0:
		mirando_derecha = false

	$Sprite2D.flip_h = not mirando_derecha
	zona_golpe.position.x = abs(zona_golpe.position.x) * (1 if mirando_derecha else -1)

	velocity = entrada * velocidad
	move_and_slide()

	if Input.is_action_just_pressed("golpear"):
		golpear()

func golpear():
	golpeando = true
	zona_golpe.monitoring = true
	temporizador_golpe.start(duracion_golpe)

func _on_temporizador_golpe_timeout():
	golpeando = false
	zona_golpe.monitoring = false

func _on_zona_golpe_area_entered(area):
	print("golpeaste a: ", area.name)
