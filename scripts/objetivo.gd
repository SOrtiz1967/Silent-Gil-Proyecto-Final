extends CanvasLayer
#autoload. cartel de arriba a la derecha que dice que hay que hacer
var tiempo = 0.0

@onready var fondo = $Fondo
@onready var etiqueta = $Fondo/EtiquetaObjetivo

func _process(delta: float) -> void:
	#no hace falta actualizarlo todos los frames
	tiempo -= delta
	if tiempo <= 0.0:
		tiempo = 0.4
		actualizar()

func actualizar() -> void:
	var nivel = get_tree().current_scene
	var jugador = get_tree().get_first_node_in_group("jugador")
	var paso = []
	if nivel != null and jugador != null:
		paso = paso_de(nivel.scene_file_path.get_file(), nivel, jugador)
	fondo.visible = not paso.is_empty()
	if fondo.visible:
		etiqueta.text = "OBJETIVO: " + paso[0]

func tiene(id_llave: String) -> bool:
	return Inventario.tiene_llave(id_llave)

func existe(nivel: Node, nombre: String) -> bool:
	return nivel.get_node_or_null(nombre) != null

#devuelve [texto, nodo al que apuntar] segun el nivel y lo que ya se consiguio
func paso_de(archivo: String, nivel: Node, jugador: Node2D) -> Array:
	match archivo:
		"nivel_1.tscn":
			return paso_plaza(jugador)
		"nivel_mc.tscn":
			return paso_mc(nivel, jugador)
		"nivel_3.tscn":
			return paso_comisaria()
		"nivel_3_celda.tscn":
			return paso_celda(nivel)
		"nivel_5.tscn":
			return paso_subte()
		"nivel_6.tscn":
			return paso_estacion_fantasma(nivel, jugador)
		"nivel_7.tscn":
			return paso_casa(nivel)
	return []

func paso_plaza(jugador: Node2D) -> Array:
	var adentro = jugador.global_position.y < 2100.0
	if adentro and not tiene("sube"):
		return ["Buscá la SUBE para pasar los molinetes (F para agarrarla). Si no la encontrás, podés forzar los molinetes.", "SUBE"]
	if adentro:
		return ["Pasá los molinetes (F). Necesitás la SUBE, una ganzúa o los pernos.", "ZonaMolinetes"]
	if not tiene("llaveMc"):
		return ["Buscá la llave del McDonald's tirada en la plaza. Tirá piedras (E) o golpeá (Espacio) a los vagabundos.", "LlaveMcDonalds"]
	if not tiene("llaveSubte"):
		return ["Entrá al McDonald's (puerta amarilla, F). La comisaría, abajo a la derecha, tiene una pistola de bengalas: la vas a necesitar más adelante.", "EntradaMcDonalds"]
	#antes de bajar se avisa del guardia si todavia no tiene la pistola
	if not Inventario.pistola:
		return ["Antes de bajar al subte buscá la pistola de bengalas en la comisaría (abajo a la derecha). Más adelante te espera un guardia muy fuerte y sin la pistola va a ser muy difícil matarlo.", "EntradaComisaria"]
	var texto = "Bajá al subte por la reja de la plaza (F)."
	if not tiene("powerbank"):
		texto += " Antes conviene tener el powerbank del McDonald's: en el subte no hay dónde cargar."
	return [texto, "EntradaSubte"]

func paso_mc(nivel: Node, jugador: Node2D) -> Array:
	var arriba = jugador.global_position.x > 2000.0
	if not tiene("llaveSubte"):
		var paso_cliente = paso_hamburguesas(nivel)
		if not paso_cliente.is_empty():
			return paso_cliente
	if not tiene("powerbank") and not arriba:
		return ["Recomendado: subí al segundo piso (escalera, F) y buscá el powerbank en la oficina.", "ZonaEscaleraSubir"]
	if not tiene("powerbank"):
		return ["Agarrá el powerbank en la oficina (F). Cuando lo tengas salen los bichos: corré a la escalera.", "Powerbank"]
	if arriba:
		return ["Bajá por la escalera (F).", "ZonaEscaleraBajar"]
	return ["Salí del McDonald's (puerta de abajo) y andá a la reja del subte, en la plaza.", "ZonaSalida"]

func paso_hamburguesas(nivel: Node) -> Array:
	var cliente = nivel.get_node_or_null("Cliente")
	if Inventario.cliente_enojado:
		if cliente != null:
			return ["Rompiste el trato: el Cliente pelea a muerte. Derrotalo para quedarte con la llave (Espacio, piedras o bengalas).", "Cliente"]
		return ["Agarrá la llave del candado que soltó el Cliente (F).", ""]
	if cliente == null:
		return []
	if Inventario.hamburguesas > 0:
		return ["Llevale la hamburguesa al Cliente (F cerca de él). Si te la comés (C) te cura todo, pero rompés el trato.", "Cliente"]
	var revisados = 0
	for nombre in ["EsconditeHorno", "EsconditeBano", "EsconditeSillon"]:
		var escondite = nivel.get_node_or_null(nombre)
		if escondite != null and escondite.revisado:
			revisados += 1
	if revisados == 0 and Inventario.hamburguesas_entregadas == 0:
		return ["Hablá con el Cliente, el fisura sentado a la derecha de la planta baja (F).", "Cliente"]
	return ["Buscá la hamburguesa que falta (" + str(Inventario.hamburguesas_entregadas) + "/3). El Cliente dijo: «" + cliente.pista_siguiente() + "»", ""]

func paso_comisaria() -> Array:
	if not Inventario.pistola:
		return ["Entrá a los calabozos (arriba a la derecha, F). Desde la celda hay un camino al depósito de evidencia, donde está la pistola de bengalas.", "EntradaCalabozos"]
	return ["Ya tenés la pistola (E). Salí a la plaza por la puerta de abajo (F).", "SalidaCalle"]

func paso_celda(nivel: Node) -> Array:
	if Inventario.pistola:
		return ["Salí por la puerta del depósito (F).", "SalidaDeposito"]
	if existe(nivel, "GanzuaColchon"):
		return ["Estás encerrado. Agarrá la ganzúa que está en la celda (F).", "GanzuaColchon"]
	if existe(nivel, "RejillaPernos") and not nivel.get_node("RejillaPernos").abierta:
		return ["Sacá los pernos de la rejilla del fondo de la celda (F).", "RejillaPernos"]
	return ["Arrastrate por el conducto hasta el depósito y agarrá la pistola de bengalas.", "PistolaBengalas"]

func paso_subte() -> Array:
	if not tiene("powerbank") and Inventario.bateria < 35.0:
		return ["Te queda poca batería. Volvé a la plaza (escalera, F) y buscá el powerbank en el McDonald's.", "SubirPlaza"]
	if not tiene("llaveServicio"):
		return ["La puerta de servicio está cerrada. Buscá la llave en la cabina de señales del ramal: cruzá la pasarela al andén sur y seguí el túnel. Apagá la linterna (Q) para que los malvivientes del subte no se muevan.", "PuertaCabina"]
	return ["Con la llave de servicio, seguí el túnel hasta la puerta de servicio (al fondo, a la derecha).", "PuertaServicio"]

func paso_estacion_fantasma(nivel: Node, jugador: Node2D) -> Array:
	if not tiene("silbato") and jugador.global_position.x < 2850.0:
		return ["Buscá el andén: seguí el túnel largo que sale hacia abajo. Si te devuelve al principio, cruzalo con la linterna apagada (Q).", "MARCADORES/TUNEL_META"]
	if not tiene("silbato") and existe(nivel, "Guarda"):
		return ["Derrotá al Guardia. Con luz te ve de lejos; a oscuras va hacia donde vio tu luz, y si le pegás toca el silbato y te persigue. Suelta un silbato.", "Guarda"]
	if not tiene("silbato"):
		return ["Agarrá el silbato que soltó el Guardia (F).", ""]
	if not tiene("sube"):
		return ["Te falta la SUBE: hay una en la alacena detrás de la rejilla, en el cuarto de arriba (F para sacar los pernos).", "RejillaAlacena"]
	return ["Pasá el molinete de salida (F) con la SUBE y el silbato.", "MolineteSalida"]

#cuando empieza el apagon de la casa el objetivo desaparece
func paso_casa(nivel: Node) -> Array:
	if nivel.get("final_empezado"):
		return []
	return ["Entrá a la cocina.", "ZonaFin"]
