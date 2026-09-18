extends CanvasLayer
@export var velocidad = 120.0
@export var tolerancia = 15.0
@export var alturaArriba = 10.0
@export var alturaAbajo = 90.0
@export var lineaMinima = 20.0
@export var lineaMaxima = 70.0
@export var ciclo = 1.5
@export var tiempoVisibleInicial = 0.8
@export var reduccionVisible = 0.25
@export var tiempoVisibleMinimo = 0.15
@export var colorSuelto = Color(0.6, 0.6, 0.6)
@export var colorTrabado = Color(0.3, 0.7, 0.3)
var activa = false
var puertaActual = null
var indice = 0
var direccion = -1
var alturaLinea = 40.0
var tiempo = 0.0
@onready var pernos = $Caja/ListaPernos.get_children()
@onready var linea = $Caja/Linea
@onready var etiquetaEstado = $EtiquetaEstado
func iniciar(puerta):
	puertaActual = puerta
	activa = true
	visible = true
	get_tree().paused = true
	reiniciar()
	Tutorial.mostrar("pernos")
func _process(delta):
	if not activa or Tutorial.activo:
		return
	moverPerno(delta)
	parpadearLinea(delta)
	if Input.is_action_just_pressed("interactuar"):
		probar()
	elif Input.is_action_just_pressed("ui_cancel"):
		cerrar()
func moverPerno(delta):
	var perno = pernos[indice]
	perno.position.y += velocidad * direccion * delta
	if perno.position.y < alturaArriba:
		direccion = 1
	elif perno.position.y > alturaAbajo:
		direccion = -1
func parpadearLinea(delta):
	tiempo += delta
	linea.visible = fmod(tiempo, ciclo) < tiempoVisible()
func tiempoVisible():
	return max(tiempoVisibleInicial - reduccionVisible * indice, tiempoVisibleMinimo)
func moverLinea():
	alturaLinea = randf_range(lineaMinima, lineaMaxima)
	linea.position.y = alturaLinea - linea.size.y / 2
	linea.visible = true
	tiempo = 0.0
func probar():
	if pernoEnLinea():
		trabarPerno()
	else:
		reiniciar()
func pernoEnLinea():
	return abs(pernos[indice].position.y - alturaLinea) <= tolerancia
func trabarPerno():
	var perno = pernos[indice]
	perno.position.y = alturaLinea
	perno.color = colorTrabado
	indice += 1
	if indice >= pernos.size():
		puertaActual.abrir()
		cerrar()
	else:
		moverLinea()
		actualizarEstado()
func reiniciar():
	indice = 0
	direccion = -1
	for perno in pernos:
		perno.position.y = alturaAbajo
		perno.color = colorSuelto
	moverLinea()
	actualizarEstado()
func actualizarEstado():
	etiquetaEstado.text = "Sin ganzua - Pernos: " + str(indice) + "/" + str(pernos.size())
func cerrar():
	activa = false
	visible = false
	get_tree().paused = false
