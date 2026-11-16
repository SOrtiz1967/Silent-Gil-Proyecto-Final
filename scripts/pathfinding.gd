extends Node
#arma una grilla A* con las colisiones del nivel para que los enemigos rodeen las paredes.
#se pone como hijo del nivel y busca todos los StaticBody2D
const tamaño_celda = 32
var grilla = AStarGrid2D.new()
var formas = []

func _ready() -> void:
	add_to_group("pathfinding")
	buscar_formas(get_parent())
	armar_grilla()
	actualizar()

func buscar_formas(nodo: Node) -> void:
	for hijo in nodo.get_children():
		if hijo is CollisionShape2D and hijo.get_parent() is StaticBody2D:
			formas.append(hijo)
		buscar_formas(hijo)

func rectangulo(forma: CollisionShape2D) -> Rect2:
	var tamaño = Vector2.ZERO
	if forma.shape is RectangleShape2D:
		tamaño = forma.shape.size
	elif forma.shape is CircleShape2D:
		tamaño = Vector2.ONE * forma.shape.radius * 2.0
	elif forma.shape is CapsuleShape2D:
		tamaño = Vector2(forma.shape.radius * 2.0, forma.shape.height)
	return forma.global_transform * Rect2(-tamaño / 2.0, tamaño)

#la grilla tiene que cubrir todas las formas del nivel
func armar_grilla() -> void:
	var total = null
	for forma in formas:
		var r = rectangulo(forma)
		total = r if total == null else total.merge(r)
	if total == null:
		return
	var inicio = celda_de(total.position) - Vector2i(1, 1)
	var fin = celda_de(total.end) + Vector2i(2, 2)
	grilla.region = Rect2i(inicio, fin - inicio)
	grilla.cell_size = Vector2(tamaño_celda, tamaño_celda)
	grilla.offset = Vector2(tamaño_celda, tamaño_celda) / 2.0
	grilla.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	grilla.update()

#se vuelve a llamar cuando se abre una puerta (grupo "pathfinding")
func actualizar() -> void:
	if grilla.region.size == Vector2i.ZERO:
		return
	grilla.fill_solid_region(grilla.region, false)
	for forma in formas:
		if is_instance_valid(forma) and not forma.disabled:
			marcar(rectangulo(forma))

func marcar(r: Rect2) -> void:
	var desde = celda_de(r.position)
	var hasta = celda_de(r.end - Vector2(1, 1))
	for x in range(desde.x, hasta.x + 1):
		for y in range(desde.y, hasta.y + 1):
			if grilla.is_in_boundsv(Vector2i(x, y)):
				grilla.set_point_solid(Vector2i(x, y), true)

func celda_de(posicion: Vector2) -> Vector2i:
	return Vector2i((posicion / tamaño_celda).floor())

#si la celda esta ocupada busca una vecina libre
func celda_libre(celda: Vector2i):
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

func buscar_ruta(desde: Vector2, hasta: Vector2):
	var a = celda_libre(celda_de(desde))
	var b = celda_libre(celda_de(hasta))
	if a == null or b == null:
		return []
	return grilla.get_point_path(a, b)
