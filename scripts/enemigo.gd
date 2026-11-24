extends CharacterBody2D
class_name Enemigo
#los fisuras. el Cliente y el Guardia heredan de este script

const Consumible = preload("res://escenas/objetos/consumible.tscn")
const ObjetoClave = preload("res://escenas/objetos/objeto_clave.tscn")
#bebidas que pueden soltar al morir
const bebidas = [
	{"nombre": "Cerveza", "textura": "res://assets/argentinian-assets-pack-v1.0 (1)/bebidas/cerveza-01.png", "escala": 1.0, "rotacion": 90.0},
	{"nombre": "Gaseosa de uva", "textura": "res://assets/argentinian-assets-pack-v1.0 (1)/bebidas/gaseosa-uva.png", "escala": 1.0, "rotacion": 90.0},
	{"nombre": "Esto no es coca papi", "textura": "res://assets/argentinian-assets-pack-v1.0 (1)/bebidas/esto-no-es-coca-papi-con-espuma.png", "escala": 2.0, "rotacion": 0.0},
]
#cuenta las muertes seguidas que no soltaron nada, asi nunca pasan dos sin botin
static var muertes_sin_botin = 0

@export var vida = 6
@export var velocidad = 60.0
@export var rango_ataque = 40.0
#las variables exportadas sin ñ porque en el .tscn no se guardan bien con ñ
@export var dano = 15
@export var rango_deteccion = 250.0
@export var probabilidad_botin = 0.7
@export var llave_botin = ""
@export var nombre_llave_botin = "Llave"
@export var solo_con_luz = false
@export var tiempo_preparacion = 0.5
@export var tiempo_aturdido = 0.25
@export var fuerza_empuje = 220.0
@export var color_normal: Color = Color(1, 1, 1)
@export var color_dano: Color = Color(3, 3, 3)
@export var color_aviso: Color = Color(1.6, 0.6, 0.6)
@export var fps = 6.0
@export var variante = 0

var persiguiendo = false
var preparando = false
var preparacion = 0.0
var aturdido = 0.0
var empuje = Vector2.ZERO
var ruta = []
var tiempo_ruta = 0.0
var tiempo_anim = 0.0

@onready var jugador = get_tree().get_first_node_in_group("jugador")
@onready var temporizador_ataque = $TemporizadorAtaque
@onready var temporizador_flash = $TemporizadorFlash
@onready var sprite = $Sprite2D

func _ready() -> void:
	sprite.texture = load("res://assets/plaza/vagabundo_%d.png" % variante)
	#si ya tengo la llave que suelta este enemigo no hace falta que aparezca
	if llave_botin != "" and Inventario.tiene_llave(llave_botin):
		queue_free()

func _process(delta: float) -> void:
	#el sprite tiene 4 cuadros, cuando persigue los pasa mas rapido
	tiempo_anim += delta * (1.6 if persiguiendo else 1.0)
	sprite.frame = int(tiempo_anim * fps) % 4
	if absf(velocity.x) > 1.0:
		sprite.flip_h = velocity.x < 0.0

func _physics_process(delta: float) -> void:
	if jugador:
		var distancia = global_position.distance_to(jugador.global_position)
		if aturdido > 0.0:
			aturdido -= delta
			velocity = empuje
			move_and_slide()
			return
		if solo_con_luz and not jugador.linterna_encendida:
			cancelar_preparacion()
			persiguiendo = false
			velocity = Vector2.ZERO
			move_and_slide()
			return
		if not persiguiendo and distancia <= rango_deteccion:
			persiguiendo = true
		if not persiguiendo:
			velocity = Vector2.ZERO
		elif distancia > rango_ataque:
			cancelar_preparacion()
			velocity = direccion_al_jugador(delta) * velocidad
		else:
			velocity = Vector2.ZERO
			atacar(delta)
	else:
		velocity = Vector2.ZERO
	move_and_slide()

#---- ataque: primero avisa (se pone rojo) y despues pega ----
func atacar(delta: float) -> void:
	if not temporizador_ataque.is_stopped():
		return
	if not preparando:
		preparando = true
		preparacion = tiempo_preparacion
		sprite.modulate = color_aviso
		return
	preparacion -= delta
	if preparacion > 0.0:
		return
	cancelar_preparacion()
	if global_position.distance_to(jugador.global_position) <= rango_ataque * 1.3:
		jugador.recibir_daño(dano)
	temporizador_ataque.start()

func cancelar_preparacion() -> void:
	if preparando:
		preparando = false
		sprite.modulate = color_normal

#---- movimiento ----
#si el nivel tiene un nodo Pathfinding sigue el camino, si no va derecho al jugador
func direccion_al_jugador(delta: float) -> Vector2:
	var mapa = get_tree().get_first_node_in_group("pathfinding")
	if mapa == null:
		return global_position.direction_to(jugador.global_position)
	tiempo_ruta -= delta
	if tiempo_ruta <= 0.0:
		ruta = mapa.buscar_ruta(global_position, jugador.global_position)
		if ruta.size() > 1:
			ruta.remove_at(0)
		tiempo_ruta = 0.4
	while ruta.size() > 0 and global_position.distance_to(ruta[0]) < 10.0:
		ruta.remove_at(0)
	if ruta.is_empty():
		return global_position.direction_to(jugador.global_position)
	return global_position.direction_to(ruta[0])

#---- dano ----
func recibir_daño(cantidad: float) -> void:
	vida -= cantidad
	if vida <= 0:
		if llave_botin != "":
			soltar_llave()
		else:
			soltar_botin()
		queue_free()
		return
	aturdir()
	mostrar_flash()

#el golpe lo empuja un toquito para atras
func aturdir() -> void:
	if tiempo_aturdido <= 0.0 or jugador == null:
		return
	cancelar_preparacion()
	aturdido = tiempo_aturdido
	empuje = jugador.global_position.direction_to(global_position) * fuerza_empuje

func mostrar_flash() -> void:
	sprite.modulate = color_dano
	temporizador_flash.start()

func _on_temporizador_flash_timeout() -> void:
	sprite.modulate = color_normal

#---- botin ----
func soltar_botin() -> void:
	if randf() > probabilidad_botin and muertes_sin_botin < 1:
		muertes_sin_botin += 1
		return
	muertes_sin_botin = 0
	var bebida = bebidas.pick_random()
	var consumible = Consumible.instantiate()
	consumible.persistente = false
	consumible.curacion = 5.0
	consumible.verbo = "tomar"
	consumible.nombre_consumible = bebida["nombre"]
	consumible.ruta_textura = bebida["textura"]
	consumible.escala = bebida["escala"]
	consumible.rotacion = bebida["rotacion"]
	consumible.position = global_position
	get_parent().call_deferred("add_child", consumible)
	Inventario.mostrar_mensaje("Solto una bebida: " + bebida["nombre"])

func soltar_llave() -> void:
	var llave = ObjetoClave.instantiate()
	llave.id_llave = llave_botin
	llave.nombre_objeto = nombre_llave_botin
	llave.position = global_position
	get_parent().call_deferred("add_child", llave)
	Inventario.mostrar_mensaje("Solto: " + nombre_llave_botin)
