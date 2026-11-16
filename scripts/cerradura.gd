extends CanvasLayer
#minijuego de la ganzua (autoload). la aguja va y viene y hay que apretar F sobre la zona verde
@export var velocidad_aguja = 300.0
@export var aciertos_necesarios = 3
@export var ancho_zona_inicial = 80.0
@export var achique_zona = 20.0

var activa = false
var puerta_actual = null
var aciertos = 0
var direccion = 1

@onready var barra = $Barra
@onready var zona = $Barra/Zona
@onready var aguja = $Barra/Aguja
@onready var etiqueta_estado = $EtiquetaEstado

func iniciar(puerta) -> void:
	puerta_actual = puerta
	aciertos = 0
	activa = true
	visible = true
	get_tree().paused = true
	preparar_zona()
	actualizar_estado()
	Tutorial.mostrar("cerradura")

func _process(delta: float) -> void:
	if not activa or Tutorial.activo:
		return
	mover_aguja(delta)
	if Input.is_action_just_pressed("interactuar"):
		probar()
	elif Input.is_action_just_pressed("ui_cancel"):
		cerrar()

func mover_aguja(delta: float) -> void:
	aguja.position.x += velocidad_aguja * direccion * delta
	if aguja.position.x > barra.size.x - aguja.size.x:
		direccion = -1
	elif aguja.position.x < 0:
		direccion = 1

func probar() -> void:
	if aguja_en_zona():
		acertar()
	else:
		fallar()

func aguja_en_zona() -> bool:
	var centro = aguja.position.x + aguja.size.x / 2
	return centro >= zona.position.x and centro <= zona.position.x + zona.size.x

func acertar() -> void:
	aciertos += 1
	parpadear(Color(0.2, 0.55, 0.2))
	if aciertos >= aciertos_necesarios:
		puerta_actual.abrir()
		cerrar()
	else:
		preparar_zona()
		actualizar_estado()

func fallar() -> void:
	Inventario.quitar_ganzua()
	parpadear(Color(0.65, 0.15, 0.15))
	if Inventario.tiene_ganzua():
		aciertos = 0
		preparar_zona()
		actualizar_estado()
	else:
		#sin ganzuas se pasa al minijuego de los pernos
		cerrar()
		Pernos.iniciar(puerta_actual)

#la zona se achica con cada acierto y aparece en un lugar random
func preparar_zona() -> void:
	zona.size.x = ancho_zona_inicial - achique_zona * aciertos
	zona.position.x = randf_range(0, barra.size.x - zona.size.x)

func actualizar_estado() -> void:
	etiqueta_estado.text = "Aciertos: " + str(aciertos) + "/" + str(aciertos_necesarios) + "   Ganzuas: " + str(Inventario.ganzuas)

func cerrar() -> void:
	activa = false
	visible = false
	get_tree().paused = false

func parpadear(color: Color) -> void:
	barra.color = color
	await get_tree().create_timer(0.15).timeout
	barra.color = Color(0.2, 0.2, 0.2)
