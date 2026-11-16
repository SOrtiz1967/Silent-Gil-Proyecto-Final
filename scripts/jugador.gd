extends CharacterBody2D

const Proyectil = preload("res://escenas/jugador/proyectil.tscn")
const Bengala = preload("res://escenas/jugador/bengala.tscn")
const PantallaMuerte = preload("res://escenas/interfaz/pantalla_muerte.tscn")
const ancho_barra = 200.0
const direcciones = {
	"arriba": Vector2.UP,
	"abajo": Vector2.DOWN,
	"izquierda": Vector2.LEFT,
	"derecha": Vector2.RIGHT,
}

@export var velocidad = 200.0
@export var duracion_golpe = 0.3
@export var distancia_golpe = 32.0
@export var distancia_disparo = 20.0
@export var dano = 3
@export var vida_maxima = 5
@export var duracion_invulnerable = 0.6
@export var duracion_bateria = 100.0
@export var energia_linterna = 1.0
@export var velocidad_powerbank = 5.0

var mirando = "abajo"
var golpeando = false
var invulnerable = false
var vida = 0
var cantidad_piedras = 0
var control_bloqueado = false
var muerto = false
var linterna_encendida = true
var posicion_anterior = Vector2.ZERO
var bloqueo_anim = 0.0
var bateria_anterior = 100.0

@onready var etiqueta_piedras = $Hud/EtiquetaPiedras
@onready var zona_golpe = $ZonaGolpe
@onready var temporizador_golpe = $TemporizadorGolpe
@onready var temporizador_invulnerable = $TemporizadorInvulnerable
@onready var relleno_vida = $Hud/RellenoVida
@onready var etiqueta_vida = $Hud/EtiquetaVida
@onready var linterna = $Linterna
@onready var animacion = $Animacion
@onready var relleno_bateria = $Hud/RellenoBateria
@onready var etiqueta_bateria = $Hud/EtiquetaBateria
@onready var etiqueta_hamburguesas = $Hud/EtiquetaHamburguesas

func _ready() -> void:
	posicion_anterior = global_position
	#la vida, las piedras y la bateria viven en el inventario para que no se pierdan al cambiar de nivel
	vida = Inventario.vida if Inventario.vida > 0.0 else float(vida_maxima)
	cantidad_piedras = Inventario.piedras
	actualizar_barra_vida()
	actualizar_piedras()
	bateria_anterior = Inventario.bateria
	actualizar_linterna(0.0)

func _process(delta: float) -> void:
	actualizar_linterna(delta)
	actualizar_animacion(delta)
	if Input.is_action_just_pressed("comer") and not get_tree().paused:
		comer_hamburguesa()
	actualizar_hamburguesas()

func _physics_process(delta: float) -> void:
	if control_bloqueado:
		return
	if golpeando:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var entrada = Input.get_vector("izquierda", "derecha", "arriba", "abajo")
	if entrada != Vector2.ZERO:
		#me fijo para donde mira segun el eje que mas pesa
		if abs(entrada.x) > abs(entrada.y):
			mirando = "derecha" if entrada.x > 0 else "izquierda"
		else:
			mirando = "abajo" if entrada.y > 0 else "arriba"

	velocity = entrada * velocidad
	move_and_slide()

	if Input.is_action_just_pressed("atacar"):
		atacar()
	elif Input.is_action_just_pressed("disparar"):
		disparar()

func direccion_mirando() -> Vector2:
	return direcciones[mirando]

#---- animacion ----
func actualizar_animacion(delta: float) -> void:
	var movio = global_position.distance_to(posicion_anterior) > 0.2
	posicion_anterior = global_position
	if bloqueo_anim > 0.0:
		bloqueo_anim -= delta
		return
	if golpeando:
		return
	#las animaciones se llaman "caminar_abajo", "idle_arriba", etc
	var nombre = ("caminar_" if movio else "idle_") + mirando
	if animacion.animation != nombre:
		animacion.play(nombre)

#---- celular / linterna ----
func actualizar_linterna(delta: float) -> void:
	var con_powerbank = Inventario.tiene_llave("powerbank")
	if con_powerbank:
		Inventario.cargar_bateria(velocidad_powerbank * delta)
	if Input.is_action_just_pressed("linterna") and Inventario.bateria > 0.0:
		linterna_encendida = not linterna_encendida
	if Inventario.bateria > 0.0 and bateria_anterior <= 0.0:
		linterna_encendida = true
	if linterna_encendida and not con_powerbank:
		Inventario.bateria = max(Inventario.bateria - 100.0 / duracion_bateria * delta, 0.0)
	if bateria_anterior > 20.0 and Inventario.bateria <= 20.0 and Inventario.bateria > 0.0:
		Inventario.mostrar_mensaje("Bateria baja")
	if bateria_anterior > 0.0 and Inventario.bateria <= 0.0:
		linterna_encendida = false
		Inventario.mostrar_mensaje("Se te murio el celular")
	if Inventario.bateria < 70.0:
		Tutorial.mostrar("celular")
	bateria_anterior = Inventario.bateria

	#con poca bateria la luz baja y titila
	var energia = energia_linterna
	if Inventario.bateria < 20.0:
		energia = energia_linterna * (0.4 + 0.6 * Inventario.bateria / 20.0)
		if randf() < 0.05:
			energia *= 0.3
	linterna.energy = energia
	linterna.visible = linterna_encendida and Inventario.bateria > 0.0
	actualizar_barra_bateria(con_powerbank)

func actualizar_barra_bateria(con_powerbank: bool) -> void:
	relleno_bateria.size.x = ancho_barra * Inventario.bateria / 100.0
	relleno_bateria.color = Color(0.9, 0.3, 0.2) if Inventario.bateria < 20.0 else Color(0.3, 0.9, 0.75)
	var texto = "Celular: " + str(int(Inventario.bateria)) + "%"
	if con_powerbank and Inventario.bateria < 100.0:
		texto += " (cargando)"
	if not linterna_encendida:
		texto += " (apagado)"
	etiqueta_bateria.text = texto

#---- hamburguesas del Cliente ----
func actualizar_hamburguesas() -> void:
	etiqueta_hamburguesas.visible = Inventario.hamburguesas > 0
	etiqueta_hamburguesas.text = "Hamburguesas: " + str(Inventario.hamburguesas) + " (C para comer)"

func comer_hamburguesa() -> void:
	if Inventario.hamburguesas <= 0:
		return
	Inventario.hamburguesas -= 1
	curar(vida_maxima)
	if Inventario.cliente_enojado:
		Inventario.mostrar_mensaje("Te comiste otra hamburguesa: vida llena")
		return
	Inventario.cliente_enojado = true
	Inventario.mostrar_mensaje("Te comiste su hamburguesa: vida llena. El Cliente se levanta...")

#---- ataques ----
func atacar() -> void:
	golpeando = true
	animacion.play("golpear_" + mirando)
	#la zona de golpe se acomoda adelante de donde mira y se apaga cuando termina el timer
	zona_golpe.position = direccion_mirando() * distancia_golpe
	zona_golpe.monitoring = true
	temporizador_golpe.start(duracion_golpe)

func disparar() -> void:
	if Inventario.pistola and Inventario.bengalas > 0:
		disparar_bengala()
		return
	if cantidad_piedras <= 0:
		return
	cantidad_piedras -= 1
	animacion.play("lanzar_" + mirando)
	bloqueo_anim = 0.2
	actualizar_piedras()
	var proyectil = Proyectil.instantiate()
	get_parent().add_child(proyectil)
	proyectil.global_position = global_position + direccion_mirando() * distancia_disparo
	proyectil.direccion = direccion_mirando()

func disparar_bengala() -> void:
	Inventario.bengalas -= 1
	Inventario.mostrar_mensaje("Bengalas: " + str(Inventario.bengalas))
	animacion.play("lanzar_" + mirando)
	bloqueo_anim = 0.2
	var bengala = Bengala.instantiate()
	get_parent().add_child(bengala)
	bengala.global_position = global_position + direccion_mirando() * distancia_disparo
	bengala.direccion = direccion_mirando()

func agregar_piedra() -> void:
	cantidad_piedras += 1
	actualizar_piedras()

func actualizar_piedras() -> void:
	Inventario.piedras = cantidad_piedras
	etiqueta_piedras.text = "Piedras: " + str(cantidad_piedras)

func _on_temporizador_golpe_timeout() -> void:
	golpeando = false
	zona_golpe.monitoring = false

func _on_zona_golpe_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigo"):
		body.recibir_daño(dano)

#---- vida ----
func recibir_daño(cantidad: float) -> void:
	if invulnerable:
		return
	vida -= cantidad
	actualizar_barra_vida()
	if vida <= 0:
		morir()
		return
	activar_invulnerable()

func activar_invulnerable() -> void:
	invulnerable = true
	animacion.modulate.a = 0.5
	temporizador_invulnerable.start(duracion_invulnerable)

func _on_temporizador_invulnerable_timeout() -> void:
	invulnerable = false
	animacion.modulate.a = 1.0

func curar(cantidad: float) -> void:
	vida = min(vida + cantidad, vida_maxima)
	actualizar_barra_vida()

func actualizar_barra_vida() -> void:
	Inventario.vida = vida
	var vida_visible = max(vida, 0)
	relleno_vida.size.x = ancho_barra * float(vida_visible) / float(vida_maxima)
	var texto_vida = str(int(vida_visible)) if vida_visible == floor(vida_visible) else str(vida_visible)
	etiqueta_vida.text = texto_vida + " / " + str(vida_maxima)

#se cuenta la muerte y aparece el cartel, que decide si se repite el nivel o arranca todo de nuevo
func morir() -> void:
	if muerto:
		return
	muerto = true
	control_bloqueado = true
	Inventario.muertes += 1
	#el cartel va en la raiz para que no se borre cuando se recarga el nivel
	var pantalla = PantallaMuerte.instantiate()
	get_tree().root.add_child(pantalla)
	pantalla.mostrar(Inventario.muertes)
