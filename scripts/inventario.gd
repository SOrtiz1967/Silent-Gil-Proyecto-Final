extends CanvasLayer
var llaves = []
var nombresLlaves = {}
var objetosRecogidos = []
var ganzuas = 0
var inventarioAbierto = false
@onready var etiquetaMensaje = $EtiquetaMensaje
@onready var temporizadorMensaje = $TemporizadorMensaje
@onready var panelInventario = $PanelInventario
@onready var etiquetaLista = $PanelInventario/EtiquetaLista
func agregarLlave(idLlave, nombre):
	if not llaves.has(idLlave):
		llaves.append(idLlave)
		nombresLlaves[idLlave] = nombre
func tieneLlave(idLlave):
	return llaves.has(idLlave)
func quitarLlave(idLlave):
	llaves.erase(idLlave)
	nombresLlaves.erase(idLlave)
func agregarGanzua():
	ganzuas += 1
func quitarGanzua():
	ganzuas -= 1
func tieneGanzua():
	return ganzuas > 0
func marcarRecogido(idObjeto):
	if not objetosRecogidos.has(idObjeto):
		objetosRecogidos.append(idObjeto)
func yaRecogido(idObjeto):
	return objetosRecogidos.has(idObjeto)
func mostrarMensaje(texto):
	etiquetaMensaje.text = texto
	etiquetaMensaje.visible = true
	temporizadorMensaje.start()
func ocultarMensaje():
	etiquetaMensaje.visible = false
func _process(delta):
	if Input.is_action_just_pressed("inventario"):
		alternarInventario()
	elif inventarioAbierto and Input.is_action_just_pressed("ui_cancel"):
		cerrarInventario()
func alternarInventario():
	if inventarioAbierto:
		cerrarInventario()
	elif not get_tree().paused:
		abrirInventario()
func abrirInventario():
	inventarioAbierto = true
	etiquetaLista.text = textoInventario()
	panelInventario.visible = true
	get_tree().paused = true
func cerrarInventario():
	inventarioAbierto = false
	panelInventario.visible = false
	get_tree().paused = false
func textoInventario():
	var texto = ""
	if llaves.has("sube"):
		texto += "SUBE: conseguida\n\n"
	texto += "Llaves:\n"
	var hayLlaves = false
	for idLlave in llaves:
		if idLlave != "sube":
			texto += "  - " + nombresLlaves[idLlave] + "\n"
			hayLlaves = true
	if not hayLlaves:
		texto += "  ninguna\n"
	return texto + "\nGanzuas: " + str(ganzuas)
