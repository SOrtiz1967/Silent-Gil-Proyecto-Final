extends Nivel
#la casa. al entrar a la cocina se apagan las luces de a una, queda solo la luz del celular
#y aparece el cartel del final. con F se vuelve al menu principal
enum estado {ESPERANDO, APAGANDO, OSCURO, CARTEL}
var estado_actual = estado.ESPERANDO

@export var ruta_menu = "res://escenas/interfaz/menu_principal.tscn"
@export var tiempo_entre_luces = 1.3
@export var tiempo_parpadeo = 0.35
@export var espera_cartel = 2.5
@export var luces: Array[String] = ["del pasillo", "del dormitorio", "del baño", "del living", "de la entrada", "de la cocina"]

var tiempo = 0.0
var indice = 0
var final_empezado = false

@onready var oscuridad = $Oscuridad
@onready var cartel = $CartelFinal
@onready var jugador = $Jugador

func _ready() -> void:
	super()
	cartel.visible = false

func _on_zona_fin_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador") and estado_actual == estado.ESPERANDO:
		final_empezado = true
		tiempo = tiempo_entre_luces
		estado_actual = estado.APAGANDO

func _process(delta: float) -> void:
	if estado_actual == estado.ESPERANDO:
		return
	tiempo -= delta
	if estado_actual == estado.APAGANDO:
		parpadear()
		if tiempo <= 0.0:
			apagar_siguiente()
	elif estado_actual == estado.OSCURO:
		if tiempo <= 0.0:
			mostrar_cartel()
	elif estado_actual == estado.CARTEL:
		if tiempo <= 0.0 and Input.is_action_just_pressed("interactuar"):
			get_tree().change_scene_to_file(ruta_menu)

func brillo_actual() -> float:
	return 1.0 - float(indice) / luces.size()

#un ratito antes de cortarse la luz titila
func parpadear() -> void:
	var brillo = brillo_actual()
	if tiempo < tiempo_parpadeo and randf() < 0.5:
		brillo *= 0.3
	oscuridad.color = Color(brillo, brillo, brillo)

func apagar_siguiente() -> void:
	Inventario.mostrar_mensaje("Se apaga la luz " + luces[indice] + ".")
	indice += 1
	var brillo = brillo_actual()
	oscuridad.color = Color(brillo, brillo, brillo)
	tiempo = tiempo_entre_luces
	if indice >= luces.size():
		#a oscuras solo queda la luz del celular y el jugador ya no se puede mover
		jugador.control_bloqueado = true
		jugador.velocity = Vector2.ZERO
		Inventario.mostrar_mensaje("Algo respira detrás tuyo.")
		tiempo = espera_cartel
		estado_actual = estado.OSCURO

func mostrar_cartel() -> void:
	Inventario.ocultar_aviso()
	cartel.visible = true
	#un segundo antes de poder salir, asi no se saltea sin querer
	tiempo = 1.0
	estado_actual = estado.CARTEL
