extends CanvasLayer
#autoload. ademas de mostrar el inventario guarda lo que tiene que sobrevivir al cambiar de nivel
var llaves = []
var nombres_llaves = {}
var objetos_recogidos = []
var ganzuas = 0
var bateria = 100.0
var vida = -1.0
var piedras = 0
var pistola = false
var bengalas = 0
var hamburguesas = 0
var hamburguesas_entregadas = 0
var cliente_enojado = false
var muertes = 0
var inventario_abierto = false

@onready var etiqueta_mensaje = $EtiquetaMensaje
@onready var etiqueta_aviso = $EtiquetaAviso
@onready var temporizador_mensaje = $TemporizadorMensaje
@onready var panel_inventario = $PanelInventario
@onready var etiqueta_lista = $PanelInventario/EtiquetaLista

#las llaves se guardan por id y el nombre es el que se ve en el inventario
func agregar_llave(id_llave: String, nombre: String) -> void:
	if not llaves.has(id_llave):
		llaves.append(id_llave)
		nombres_llaves[id_llave] = nombre

func tiene_llave(id_llave: String) -> bool:
	return llaves.has(id_llave)

func quitar_llave(id_llave: String) -> void:
	llaves.erase(id_llave)
	nombres_llaves.erase(id_llave)

func agregar_ganzua() -> void:
	ganzuas += 1

func quitar_ganzua() -> void:
	ganzuas -= 1

func tiene_ganzua() -> bool:
	return ganzuas > 0

func cargar_bateria(cantidad: float) -> void:
	bateria = min(bateria + cantidad, 100.0)

#cada objeto del mapa se marca con su id para que no vuelva a aparecer cuando se recarga el nivel
func marcar_recogido(id_objeto: String) -> void:
	if not objetos_recogidos.has(id_objeto):
		objetos_recogidos.append(id_objeto)

func ya_recogido(id_objeto: String) -> bool:
	return objetos_recogidos.has(id_objeto)

#se usa cuando se pierden las 3 vidas: todo vuelve a como estaba al empezar el juego
func reiniciar() -> void:
	llaves.clear()
	nombres_llaves.clear()
	objetos_recogidos.clear()
	ganzuas = 0
	bateria = 100.0
	vida = -1.0
	piedras = 0
	pistola = false
	bengalas = 0
	hamburguesas = 0
	hamburguesas_entregadas = 0
	cliente_enojado = false
	muertes = 0
	cerrar_inventario()
	ocultar_aviso()
	etiqueta_mensaje.visible = false

func mostrar_mensaje(texto: String) -> void:
	etiqueta_mensaje.text = texto
	etiqueta_mensaje.visible = true
	temporizador_mensaje.start()

func ocultar_aviso() -> void:
	etiqueta_aviso.visible = false

func mostrar_aviso(texto: String) -> void:
	etiqueta_aviso.text = texto
	etiqueta_aviso.visible = true

func _on_temporizador_mensaje_timeout() -> void:
	etiqueta_mensaje.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventario") and not CambioNivel.en_menu():
		alternar_inventario()
	elif inventario_abierto and Input.is_action_just_pressed("ui_cancel"):
		cerrar_inventario()

func alternar_inventario() -> void:
	if inventario_abierto:
		cerrar_inventario()
	elif not get_tree().paused:
		abrir_inventario()

func abrir_inventario() -> void:
	inventario_abierto = true
	etiqueta_lista.text = texto_inventario()
	panel_inventario.visible = true
	get_tree().paused = true

func cerrar_inventario() -> void:
	inventario_abierto = false
	panel_inventario.visible = false
	get_tree().paused = false

func texto_inventario() -> String:
	var texto = ""
	if llaves.has("sube"):
		texto += "SUBE: conseguida\n\n"
	if llaves.has("powerbank"):
		texto += "POWERBANK: conseguido (el celular se queda al 100%)\n\n"
	else:
		texto += "Celular: " + str(int(bateria)) + "%\n\n"
	if pistola:
		texto += "Pistola de bengalas: " + str(bengalas) + " bengalas\n\n"
	if hamburguesas > 0:
		texto += "Hamburguesas: " + str(hamburguesas) + " (C para comer, cura toda la vida)\n\n"
	if hamburguesas_entregadas > 0 and hamburguesas_entregadas < 3 and not cliente_enojado:
		texto += "Hamburguesas entregadas al Cliente: " + str(hamburguesas_entregadas) + "/3\n\n"
	texto += "Llaves:\n"
	var hay_llaves = false
	for id_llave in llaves:
		#la sube y el powerbank ya se mostraron arriba
		if id_llave != "sube" and id_llave != "powerbank":
			texto += "  - " + nombres_llaves[id_llave] + "\n"
			hay_llaves = true
	if not hay_llaves:
		texto += "  ninguna\n"
	return texto + "\nGanzuas: " + str(ganzuas)
