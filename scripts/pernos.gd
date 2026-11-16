extends CanvasLayer
#minijuego de los pernos (autoload). se usa cuando no hay ganzuas ni llave
@export var velocidad = 120.0
@export var tolerancia = 15.0
@export var altura_arriba = 10.0
@export var altura_abajo = 90.0
@export var linea_minima = 20.0
@export var linea_maxima = 70.0
@export var ciclo = 1.5
@export var tiempo_visible_inicial = 0.8
@export var reduccion_visible = 0.25
@export var tiempo_visible_minimo = 0.15
@export var color_suelto = Color(0.6, 0.6, 0.6)
@export var color_trabado = Color(0.3, 0.7, 0.3)

var activa = false
var puerta_actual = null
var indice = 0
var direccion = -1
var altura_linea = 40.0
var tiempo = 0.0

@onready var pernos = $Caja/ListaPernos.get_children()
@onready var linea = $Caja/Linea
@onready var etiqueta_estado = $EtiquetaEstado

func iniciar(puerta) -> void:
	puerta_actual = puerta
	activa = true
	visible = true
	get_tree().paused = true
	reiniciar()
	Tutorial.mostrar("pernos")

func _process(delta: float) -> void:
	if not activa or Tutorial.activo:
		return
	mover_perno(delta)
	parpadear_linea(delta)
	if Input.is_action_just_pressed("interactuar"):
		probar()
	elif Input.is_action_just_pressed("ui_cancel"):
		cerrar()

#solo se mueve el perno que toca, los anteriores quedan trabados
func mover_perno(delta: float) -> void:
	var perno = pernos[indice]
	perno.position.y += velocidad * direccion * delta
	if perno.position.y < altura_arriba:
		direccion = 1
	elif perno.position.y > altura_abajo:
		direccion = -1

#la linea roja se ve un ratito y se va, cada perno la deja menos tiempo
func parpadear_linea(delta: float) -> void:
	tiempo += delta
	linea.visible = fmod(tiempo, ciclo) < tiempo_visible()

func tiempo_visible() -> float:
	return max(tiempo_visible_inicial - reduccion_visible * indice, tiempo_visible_minimo)

func mover_linea() -> void:
	altura_linea = randf_range(linea_minima, linea_maxima)
	linea.position.y = altura_linea - linea.size.y / 2
	linea.visible = true
	tiempo = 0.0

func probar() -> void:
	if perno_en_linea():
		trabar_perno()
	else:
		reiniciar()

func perno_en_linea() -> bool:
	return abs(pernos[indice].position.y - altura_linea) <= tolerancia

func trabar_perno() -> void:
	var perno = pernos[indice]
	perno.position.y = altura_linea
	perno.color = color_trabado
	indice += 1
	if indice >= pernos.size():
		puerta_actual.abrir()
		cerrar()
	else:
		mover_linea()
		actualizar_estado()

func reiniciar() -> void:
	indice = 0
	direccion = -1
	for perno in pernos:
		perno.position.y = altura_abajo
		perno.color = color_suelto
	mover_linea()
	actualizar_estado()

func actualizar_estado() -> void:
	etiqueta_estado.text = "Sin ganzua - Pernos: " + str(indice) + "/" + str(pernos.size())

func cerrar() -> void:
	activa = false
	visible = false
	get_tree().paused = false
