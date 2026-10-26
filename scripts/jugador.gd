extends CharacterBody2D

const Proyectil = preload("res://escenas/proyectil.tscn")
const Bengala = preload("res://escenas/bengala.tscn")
const anchoBarra = 200.0

@export var velocidad = 200.0
@export var duracion_golpe = 0.3
@export var distancia_golpe = 24.0
@export var distancia_disparo = 20.0
@export var dano = 3
@export var vidaMaxima = 5
@export var duracionInvulnerable = 0.6
@export var duracionBateria = 100.0
@export var energiaLinterna = 1.0
@export var velocidadPowerbank = 5.0

var mirando = "abajo"
var golpeando = false
var invulnerable = false
var vida = 0
var cantidad_piedras = 0
var controlBloqueado = false
var linternaEncendida = true
var posicionAnterior = Vector2.ZERO
var bloqueoAnim = 0.0
var bateriaAnterior = 100.0

@onready var etiquetaPiedras = $Hud/EtiquetaPiedras
@onready var zona_golpe = $ZonaGolpe
@onready var temporizador_golpe = $TemporizadorGolpe
@onready var temporizadorInvulnerable = $TemporizadorInvulnerable
@onready var rellenoVida = $Hud/RellenoVida
@onready var etiquetaVida = $Hud/EtiquetaVida
@onready var linterna = $Linterna
@onready var animacion = $Animacion
@onready var rellenoBateria = $Hud/RellenoBateria
@onready var etiquetaBateria = $Hud/EtiquetaBateria

func _ready():
	posicionAnterior = global_position
	vida = Inventario.vida if Inventario.vida > 0.0 else float(vidaMaxima)
	cantidad_piedras = Inventario.piedras
	actualizarBarraVida()
	actualizarPiedras()
	bateriaAnterior = Inventario.bateria
	actualizarLinterna(0.0)

func _process(delta):
	actualizarLinterna(delta)
	actualizarAnimacion(delta)

func actualizarAnimacion(delta):
	var movio = global_position.distance_to(posicionAnterior) > 0.2
	posicionAnterior = global_position
	if bloqueoAnim > 0.0:
		bloqueoAnim -= delta
		return
	if golpeando:
		return
	var nombre = ("caminar_" if movio else "idle_") + mirando
	if animacion.animation != nombre:
		animacion.play(nombre)

func actualizarLinterna(delta):
	var conPowerbank = Inventario.tieneLlave("powerbank")
	if conPowerbank:
		Inventario.cargarBateria(velocidadPowerbank * delta)
	if Input.is_action_just_pressed("linterna") and Inventario.bateria > 0.0:
		linternaEncendida = not linternaEncendida
	if Inventario.bateria > 0.0 and bateriaAnterior <= 0.0:
		linternaEncendida = true
	if linternaEncendida and not conPowerbank:
		Inventario.bateria = max(Inventario.bateria - 100.0 / duracionBateria * delta, 0.0)
	if bateriaAnterior > 20.0 and Inventario.bateria <= 20.0 and Inventario.bateria > 0.0:
		Inventario.mostrarMensaje("Bateria baja")
	if bateriaAnterior > 0.0 and Inventario.bateria <= 0.0:
		linternaEncendida = false
		Inventario.mostrarMensaje("Se te murio el celular")
	if Inventario.bateria < 70.0:
		Tutorial.mostrar("celular")
	bateriaAnterior = Inventario.bateria
	var energia = energiaLinterna
	if Inventario.bateria < 20.0:
		energia = energiaLinterna * (0.4 + 0.6 * Inventario.bateria / 20.0)
		if randf() < 0.05:
			energia *= 0.3
	linterna.energy = energia
	linterna.visible = linternaEncendida and Inventario.bateria > 0.0
	actualizarBarraBateria(conPowerbank)

func actualizarBarraBateria(conPowerbank):
	rellenoBateria.size.x = anchoBarra * Inventario.bateria / 100.0
	rellenoBateria.color = Color(0.9, 0.3, 0.2) if Inventario.bateria < 20.0 else Color(0.3, 0.9, 0.75)
	var texto = "Celular: " + str(int(Inventario.bateria)) + "%"
	if conPowerbank and Inventario.bateria < 100.0:
		texto += " (cargando)"
	if not linternaEncendida:
		texto += " (apagado)"
	etiquetaBateria.text = texto

func _physics_process(delta):
	if controlBloqueado:
		return
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
	animacion.play("golpear_" + mirando)
	zona_golpe.position = direccion_mirando() * distancia_golpe
	zona_golpe.monitoring = true
	temporizador_golpe.start(duracion_golpe)

func agregarPiedra():
	cantidad_piedras += 1
	actualizarPiedras()

func actualizarPiedras():
	Inventario.piedras = cantidad_piedras
	etiquetaPiedras.text = "Piedras: " + str(cantidad_piedras)

func disparar():
	if Inventario.pistola and Inventario.bengalas > 0:
		dispararBengala()
		return
	if cantidad_piedras <= 0:
		return
	cantidad_piedras -= 1
	animacion.play("lanzar_" + mirando)
	bloqueoAnim = 0.2
	actualizarPiedras()
	var proyectil = Proyectil.instantiate()
	get_parent().add_child(proyectil)
	proyectil.global_position = global_position + direccion_mirando() * distancia_disparo
	proyectil.direccion = direccion_mirando()

func dispararBengala():
	Inventario.bengalas -= 1
	Inventario.mostrarMensaje("Bengalas: " + str(Inventario.bengalas))
	animacion.play("lanzar_" + mirando)
	bloqueoAnim = 0.2
	var bengala = Bengala.instantiate()
	get_parent().add_child(bengala)
	bengala.global_position = global_position + direccion_mirando() * distancia_disparo
	bengala.direccion = direccion_mirando()

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
	animacion.modulate.a = 0.5
	temporizadorInvulnerable.start(duracionInvulnerable)

func _on_temporizador_invulnerable_timeout():
	invulnerable = false
	animacion.modulate.a = 1.0

func curar(cantidad):
	vida = min(vida + cantidad, vidaMaxima)
	actualizarBarraVida()

func actualizarBarraVida():
	Inventario.vida = vida
	var vidaVisible = max(vida, 0)
	rellenoVida.size.x = anchoBarra * float(vidaVisible) / float(vidaMaxima)
	var textoVida = str(int(vidaVisible)) if vidaVisible == floor(vidaVisible) else str(vidaVisible)
	etiquetaVida.text = textoVida + " / " + str(vidaMaxima)

func morir():
	Inventario.vida = -1.0
	Inventario.piedras = 0
	Inventario.bateria = max(Inventario.bateria, 30.0)
	get_tree().reload_current_scene()
