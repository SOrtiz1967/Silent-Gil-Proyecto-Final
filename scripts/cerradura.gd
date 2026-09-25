extends CanvasLayer
@export var velocidadAguja = 300.0
@export var aciertosNecesarios = 3
@export var anchoZonaInicial = 80.0
@export var achiqueZona = 20.0
var activa = false
var puertaActual = null
var aciertos = 0
var direccion = 1
@onready var barra = $Barra
@onready var zona = $Barra/Zona
@onready var aguja = $Barra/Aguja
@onready var etiquetaEstado = $EtiquetaEstado
func iniciar(puerta):
	puertaActual = puerta
	aciertos = 0
	activa = true
	visible = true
	get_tree().paused = true
	prepararZona()
	actualizarEstado()
	Tutorial.mostrar("cerradura")
func _process(delta):
	if not activa or Tutorial.activo:
		return
	moverAguja(delta)
	if Input.is_action_just_pressed("interactuar"):
		probar()
	elif Input.is_action_just_pressed("ui_cancel"):
		cerrar()
func moverAguja(delta):
	aguja.position.x += velocidadAguja * direccion * delta
	if aguja.position.x > barra.size.x - aguja.size.x:
		direccion = -1
	elif aguja.position.x < 0:
		direccion = 1
func probar():
	if agujaEnZona():
		acertar()
	else:
		fallar()
func agujaEnZona():
	var centro = aguja.position.x + aguja.size.x / 2
	return centro >= zona.position.x and centro <= zona.position.x + zona.size.x
func acertar():
	aciertos += 1
	if aciertos >= aciertosNecesarios:
		puertaActual.abrir()
		cerrar()
	else:
		prepararZona()
		actualizarEstado()
func fallar():
	Inventario.quitarGanzua()
	if Inventario.tieneGanzua():
		aciertos = 0
		prepararZona()
		actualizarEstado()
	else:
		cerrar()
		Pernos.iniciar(puertaActual)
func prepararZona():
	zona.size.x = anchoZonaInicial - achiqueZona * aciertos
	zona.position.x = randf_range(0, barra.size.x - zona.size.x)
func actualizarEstado():
	etiquetaEstado.text = "Aciertos: " + str(aciertos) + "/" + str(aciertosNecesarios) + "   Ganzuas: " + str(Inventario.ganzuas)
func cerrar():
	activa = false
	visible = false
	get_tree().paused = false
