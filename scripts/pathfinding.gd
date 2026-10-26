extends Node
const tamanoCelda = 32
var grilla = AStarGrid2D.new()
var formas = []
func _ready():
	add_to_group("pathfinding")
	buscarFormas(get_parent())
	armarGrilla()
	actualizar()
func buscarFormas(nodo):
	for hijo in nodo.get_children():
		if hijo is CollisionShape2D and hijo.get_parent() is StaticBody2D:
			formas.append(hijo)
		buscarFormas(hijo)
func rectangulo(forma):
	var tamano = Vector2.ZERO
	if forma.shape is RectangleShape2D:
		tamano = forma.shape.size
	elif forma.shape is CircleShape2D:
		tamano = Vector2.ONE * forma.shape.radius * 2.0
	elif forma.shape is CapsuleShape2D:
		tamano = Vector2(forma.shape.radius * 2.0, forma.shape.height)
	return forma.global_transform * Rect2(-tamano / 2.0, tamano)
func armarGrilla():
	var total = null
	for forma in formas:
		var r = rectangulo(forma)
		total = r if total == null else total.merge(r)
	if total == null:
		return
	var inicio = celdaDe(total.position) - Vector2i(1, 1)
	var fin = celdaDe(total.end) + Vector2i(2, 2)
	grilla.region = Rect2i(inicio, fin - inicio)
	grilla.cell_size = Vector2(tamanoCelda, tamanoCelda)
	grilla.offset = Vector2(tamanoCelda, tamanoCelda) / 2.0
	grilla.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	grilla.update()
func actualizar():
	if grilla.region.size == Vector2i.ZERO:
		return
	grilla.fill_solid_region(grilla.region, false)
	for forma in formas:
		if is_instance_valid(forma) and not forma.disabled:
			marcar(rectangulo(forma))
func marcar(r):
	var desde = celdaDe(r.position)
	var hasta = celdaDe(r.end - Vector2(1, 1))
	for x in range(desde.x, hasta.x + 1):
		for y in range(desde.y, hasta.y + 1):
			if grilla.is_in_boundsv(Vector2i(x, y)):
				grilla.set_point_solid(Vector2i(x, y), true)
func celdaDe(posicion):
	return Vector2i((posicion / tamanoCelda).floor())
func celdaLibre(celda):
	if not grilla.is_in_boundsv(celda):
		return null
	if not grilla.is_point_solid(celda):
		return celda
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			var vecina = celda + Vector2i(dx, dy)
			if grilla.is_in_boundsv(vecina) and not grilla.is_point_solid(vecina):
				return vecina
	return null
func buscarRuta(desde, hasta):
	var a = celdaLibre(celdaDe(desde))
	var b = celdaLibre(celdaDe(hasta))
	if a == null or b == null:
		return []
	return grilla.get_point_path(a, b)
