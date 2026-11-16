extends Node2D
#cinematica del final: llega un tren a la estacion que no existe, el jugador se sube,
#el tren se va y despues llega a su estacion, se baja y camina a la salida. al final pasa a la casa
enum estado {LLEGANDO, SUBIENDO, PARTIENDO, VIAJANDO, BAJANDO, SALIENDO, TERMINANDO}
var estado_actual = estado.LLEGANDO

@export var ruta_casa = "res://escenas/niveles/nivel_7.tscn"
@export var punto_casa = "PUNTO_APARICION_JUGADOR"
@export var altura_parada = 36.0
@export var velocidad_tren = 420.0
@export var velocidad_caminata = 90.0
@export var tiempo_por_texto = 3.5
@export var velocidad_fundido = 0.8
@export var textos_viaje: Array[String] = [
	"El vagón está vacío, pero las luces andan.",
	"Por la ventana pasan estaciones sin nombre. Todas tienen el reloj en las 3:07.",
	"Reconocés tu parada.",
]

var tiempo = 0.0
var velocidad = 0.0
var indice_texto = 0

@onready var tren = $Tren
@onready var pasajero = $Pasajero
@onready var camara = $Camara
@onready var oscuridad = $Oscuridad
@onready var negro = $Pantalla/Negro
@onready var texto = $Pantalla/Texto
@onready var puerta_ida = $MARCADORES/PUERTA_TREN_IDA
@onready var puerta_llegada = $MARCADORES/PUERTA_TREN_LLEGADA
@onready var salida = $MARCADORES/SALIDA_ESTACION

func _ready() -> void:
	tren.position = Vector2(puerta_ida.position.x - 136.0, -1000.0)
	pasajero.play("idle_izquierda")
	negro.modulate.a = 1.0
	texto.text = "Se escucha un tren. Esta vez frena."

func _process(delta: float) -> void:
	if estado_actual != estado.TERMINANDO and Input.is_action_just_pressed("interactuar"):
		terminar()
		return
	if estado_actual == estado.LLEGANDO:
		aclarar(delta)
		if llegar_tren(delta):
			texto.text = ""
			pasajero.play("caminar_izquierda")
			estado_actual = estado.SUBIENDO
	elif estado_actual == estado.SUBIENDO:
		if caminar(puerta_ida.position, delta):
			pasajero.visible = false
			velocidad = 0.0
			estado_actual = estado.PARTIENDO
	elif estado_actual == estado.PARTIENDO:
		irse_tren(delta)
		if tren.position.y < -700.0:
			oscurecer(delta)
		if negro.modulate.a >= 1.0:
			cambiar_de_anden()
			estado_actual = estado.VIAJANDO
	elif estado_actual == estado.VIAJANDO:
		tiempo -= delta
		if tiempo <= 0.0:
			siguiente_texto()
	elif estado_actual == estado.BAJANDO:
		aclarar(delta)
		if llegar_tren(delta):
			pasajero.visible = true
			pasajero.play("caminar_derecha")
			texto.text = "Tu estación. No hay nadie, pero conocés el camino a casa."
			velocidad = 0.0
			estado_actual = estado.SALIENDO
	elif estado_actual == estado.SALIENDO:
		irse_tren(delta)
		if caminar(salida.position, delta):
			oscurecer(delta)
			if negro.modulate.a >= 1.0:
				terminar()

#el tren baja hasta la parada y va frenando a medida que se acerca. devuelve true cuando paro
func llegar_tren(delta: float) -> bool:
	var falta = altura_parada - tren.position.y
	var paso = max(falta * 1.5, 40.0) * delta
	tren.position.y = move_toward(tren.position.y, altura_parada, min(paso, velocidad_tren * delta))
	return tren.position.y == altura_parada

func irse_tren(delta: float) -> void:
	velocidad = min(velocidad + 60.0 * delta, velocidad_tren)
	tren.position.y -= velocidad * delta

#mueve al pasajero hacia un punto. devuelve true cuando llego
func caminar(destino: Vector2, delta: float) -> bool:
	pasajero.position = pasajero.position.move_toward(destino, velocidad_caminata * delta)
	if pasajero.position == destino:
		pasajero.play("idle_derecha")
		return true
	return false

#durante el viaje la pantalla esta en negro y se muestran los textos de a uno
func cambiar_de_anden() -> void:
	camara.position.x += puerta_llegada.position.x - puerta_ida.position.x
	tren.position = Vector2(puerta_llegada.position.x - 136.0, -1000.0)
	pasajero.position = puerta_llegada.position
	oscuridad.color = Color(0.75, 0.7, 0.6, 1)
	indice_texto = 0
	siguiente_texto()

func siguiente_texto() -> void:
	if indice_texto >= textos_viaje.size():
		texto.text = ""
		estado_actual = estado.BAJANDO
		return
	texto.text = textos_viaje[indice_texto]
	indice_texto += 1
	tiempo = tiempo_por_texto

func aclarar(delta: float) -> void:
	negro.modulate.a = max(negro.modulate.a - velocidad_fundido * delta, 0.0)

func oscurecer(delta: float) -> void:
	negro.modulate.a = min(negro.modulate.a + velocidad_fundido * delta, 1.0)

func terminar() -> void:
	estado_actual = estado.TERMINANDO
	CambioNivel.ir(ruta_casa, punto_casa)
