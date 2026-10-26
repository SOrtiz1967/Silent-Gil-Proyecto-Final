extends Area2D
@export var cantidad = 3
@export var daPistola = false
@export_multiline var textoPistola = "Una pistola de bengalas. Con E disparas una bengala: pega mas fuerte que una piedra y ilumina la zona. Las bengalas son pocas, asi que cada tiro cuenta. Se ve cuantas te quedan con T."
var idObjeto = ""
func _ready():
	idObjeto = str(get_path())
	if Inventario.yaRecogido(idObjeto):
		queue_free()
func _physics_process(delta):
	for cuerpo in get_overlapping_bodies():
		if cuerpo.is_in_group("jugador"):
			recoger()
			return
func recoger():
	Inventario.marcarRecogido(idObjeto)
	Inventario.bengalas += cantidad
	if daPistola and not Inventario.pistola:
		Inventario.pistola = true
		Tutorial.mostrarTexto("PISTOLA DE BENGALAS", textoPistola)
	else:
		Inventario.mostrarMensaje("Bengalas: +" + str(cantidad))
	queue_free()
