extends Node2D
#un tren vacio que cruza las vias una sola vez cuando el jugador entra a la zona "disparador".
#se dibuja recortado por la forma de las vias (clip_children) para que no se vea fuera de ellas
enum estado {ESPERANDO, AVISANDO, PASANDO}
var estado_actual = estado.ESPERANDO

@export var vias = Rect2(896, 832, 2368, 224)
@export var disparador = Rect2(1700, 480, 412, 320)
@export var id_evento = "trenFantasmaSubte"
@export var velocidad = 650.0
@export var dano = 30
@export var cantidad_vagones = 4
@export var largo_vagon = 300.0
@export var espera = 1.8
@export var mensaje_aviso = "Algo retumba en el túnel. Viene un tren."
@export var mensaje_paso = "Pasó un tren sin nadie adentro. Ni conductor. No frenó."

var tiempo = 0.0
var tren = null
var luces = []

func _ready() -> void:
	#el evento pasa una sola vez en toda la partida
	if Inventario.ya_recogido(id_evento):
		queue_free()
		return
	var mascara = Polygon2D.new()
	mascara.polygon = PackedVector2Array([vias.position, Vector2(vias.end.x, vias.position.y), vias.end, Vector2(vias.position.x, vias.end.y)])
	mascara.clip_children = CanvasItem.CLIP_CHILDREN_ONLY
	mascara.z_index = 5
	add_child(mascara)
	tren = Node2D.new()
	mascara.add_child(tren)
	var alto = vias.size.y - 40.0
	var textura = load("res://assets/estacion/luz_radial.tres")
	for i in cantidad_vagones:
		var x = i * (largo_vagon + 12.0)
		var vagon = Polygon2D.new()
		vagon.color = Color(0.55, 0.58, 0.62)
		vagon.polygon = PackedVector2Array([Vector2(x, 0), Vector2(x + largo_vagon, 0), Vector2(x + largo_vagon, alto), Vector2(x, alto)])
		tren.add_child(vagon)
		for v in 4:
			var vx = x + 24.0 + v * (largo_vagon - 48.0) / 4.0
			var ventana = Polygon2D.new()
			ventana.color = Color(1.0, 0.95, 0.6)
			ventana.polygon = PackedVector2Array([Vector2(vx, 18), Vector2(vx + 48, 18), Vector2(vx + 48, alto - 18), Vector2(vx, alto - 18)])
			tren.add_child(ventana)
		var luz = PointLight2D.new()
		luz.texture = textura
		luz.texture_scale = 1.6
		luz.energy = 1.1
		luz.color = Color(1.0, 0.92, 0.6)
		luz.position = Vector2(x + largo_vagon / 2.0, alto / 2.0)
		luz.visible = false
		tren.add_child(luz)
		luces.append(luz)
	tren.position = Vector2(vias.position.x - largo_total(), vias.position.y + 20.0)

func largo_total() -> float:
	return cantidad_vagones * (largo_vagon + 12.0)

func _physics_process(delta: float) -> void:
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador == null:
		return
	if estado_actual == estado.ESPERANDO:
		if disparador.has_point(jugador.global_position):
			estado_actual = estado.AVISANDO
			tiempo = espera
			Inventario.marcar_recogido(id_evento)
			Inventario.mostrar_mensaje(mensaje_aviso)
	elif estado_actual == estado.AVISANDO:
		tiempo -= delta
		if tiempo <= 0.0:
			estado_actual = estado.PASANDO
	elif estado_actual == estado.PASANDO:
		tren.position.x += velocidad * delta
		actualizar_luces()
		golpear(jugador)
		if tren.position.x > vias.end.x:
			Inventario.mostrar_mensaje(mensaje_paso)
			queue_free()

#cada luz solo se prende mientras esta dentro de las vias
func actualizar_luces() -> void:
	for luz in luces:
		var x = tren.position.x + luz.position.x
		luz.visible = x > vias.position.x and x < vias.end.x

#si el tren te pasa por encima te saca vida y te tira al andén mas cercano
func golpear(jugador: Node2D) -> void:
	var cuerpo = Rect2(tren.position, Vector2(largo_total(), vias.size.y - 40.0))
	if not cuerpo.has_point(jugador.global_position):
		return
	jugador.recibir_daño(dano)
	var centro = vias.position.y + vias.size.y / 2
	if jugador.global_position.y < centro:
		jugador.global_position.y = vias.position.y - 24.0
	else:
		jugador.global_position.y = vias.end.y + 24.0
	Inventario.mostrar_mensaje("El tren te tiró contra el andén")
