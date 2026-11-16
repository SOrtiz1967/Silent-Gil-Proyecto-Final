extends Node2D
# Un tren vacio que cruza las vias una sola vez cuando el jugador entra a la zona de disparo.
# Se dibuja recortado por la forma de las vias (clip_children) para que no se vea fuera de ellas.
@export var vias = Rect2(896, 832, 2368, 224)
@export var disparador = Rect2(1700, 480, 412, 320)
@export var idEvento = "trenFantasmaSubte"
@export var velocidad = 650.0
@export var dano = 2
@export var cantidadVagones = 4
@export var largoVagon = 300.0
@export var espera = 1.8
@export var mensajeAviso = "Algo retumba en el túnel. Viene un tren."
@export var mensajePaso = "Pasó un tren sin nadie adentro. Ni conductor. No frenó."
var estado = "esperando"
var tiempo = 0.0
var avisoLuz = null
var tren = null
var luces = []
func _ready():
	if Inventario.yaRecogido(idEvento):
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
	for i in cantidadVagones:
		var x = i * (largoVagon + 12.0)
		var vagon = Polygon2D.new()
		vagon.color = Color(0.55, 0.58, 0.62)
		vagon.polygon = PackedVector2Array([Vector2(x, 0), Vector2(x + largoVagon, 0), Vector2(x + largoVagon, alto), Vector2(x, alto)])
		tren.add_child(vagon)
		for v in 4:
			var vx = x + 24.0 + v * (largoVagon - 48.0) / 4.0
			var ventana = Polygon2D.new()
			ventana.color = Color(1.0, 0.95, 0.6)
			ventana.polygon = PackedVector2Array([Vector2(vx, 18), Vector2(vx + 48, 18), Vector2(vx + 48, alto - 18), Vector2(vx, alto - 18)])
			tren.add_child(ventana)
		var luz = PointLight2D.new()
		luz.texture = textura
		luz.texture_scale = 1.6
		luz.energy = 1.1
		luz.color = Color(1.0, 0.92, 0.6)
		luz.position = Vector2(x + largoVagon / 2.0, alto / 2.0)
		luz.visible = false
		tren.add_child(luz)
		luces.append(luz)
	tren.position = Vector2(vias.position.x - largoTotal(), vias.position.y + 20.0)
func largoTotal():
	return cantidadVagones * (largoVagon + 12.0)
func _physics_process(delta):
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador == null:
		return
	match estado:
		"esperando":
			if disparador.has_point(jugador.global_position):
				estado = "avisando"
				tiempo = espera
				Inventario.marcarRecogido(idEvento)
				Inventario.mostrarMensaje(mensajeAviso)
		"avisando":
			tiempo -= delta
			if tiempo <= 0.0:
				estado = "pasando"
		"pasando":
			tren.position.x += velocidad * delta
			actualizarLuces()
			golpear(jugador)
			if tren.position.x > vias.end.x:
				Inventario.mostrarMensaje(mensajePaso)
				queue_free()
func actualizarLuces():
	for luz in luces:
		var x = tren.position.x + luz.position.x
		luz.visible = x > vias.position.x and x < vias.end.x
func golpear(jugador):
	var cuerpo = Rect2(tren.position, Vector2(largoTotal(), vias.size.y - 40.0))
	if not cuerpo.has_point(jugador.global_position):
		return
	jugador.recibirDano(dano)
	var centro = vias.position.y + vias.size.y / 2.0
	if jugador.global_position.y < centro:
		jugador.global_position.y = vias.position.y - 24.0
	else:
		jugador.global_position.y = vias.end.y + 24.0
	Inventario.mostrarMensaje("El tren te tiró contra el andén")
