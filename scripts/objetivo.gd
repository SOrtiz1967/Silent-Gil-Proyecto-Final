extends CanvasLayer
const direcciones = ["a la derecha", "abajo a la derecha", "abajo", "abajo a la izquierda", "a la izquierda", "arriba a la izquierda", "arriba", "arriba a la derecha"]
var tiempo = 0.0
@onready var fondo = $Fondo
@onready var etiqueta = $Fondo/EtiquetaObjetivo
func _process(delta):
	tiempo -= delta
	if tiempo <= 0.0:
		tiempo = 0.4
		actualizar()
func actualizar():
	var nivel = get_tree().current_scene
	var jugador = get_tree().get_first_node_in_group("jugador")
	var paso = []
	if nivel != null and jugador != null:
		paso = pasoDe(nivel.scene_file_path.get_file(), nivel, jugador)
	fondo.visible = not paso.is_empty()
	if fondo.visible:
		etiqueta.text = "OBJETIVO: " + paso[0] + indicacion(nivel, jugador, paso[1])
func indicacion(nivel, jugador, ruta):
	var objetivo = nivel.get_node_or_null(ruta) if ruta != "" else null
	if objetivo == null:
		return ""
	var vector = objetivo.global_position - jugador.global_position
	var metros = int(vector.length() / 32.0)
	if metros < 3:
		return "\n(estás justo acá)"
	var indice = posmod(int(round(vector.angle() / (PI / 4.0))), 8)
	return "\n(" + direcciones[indice] + ", a unos " + str(metros) + " metros)"
func tiene(id):
	return Inventario.tieneLlave(id)
func existe(nivel, nombre):
	return nivel.get_node_or_null(nombre) != null
func pasoDe(archivo, nivel, jugador):
	match archivo:
		"nivel_1.tscn":
			return pasoPlaza(nivel, jugador)
		"nivel_mc.tscn":
			return pasoMc(nivel, jugador)
		"nivel_3.tscn":
			return pasoComisaria(nivel)
		"nivel_3_celda.tscn":
			return pasoCelda(nivel)
		"nivel_5.tscn":
			return pasoSubte()
		"nivel_6.tscn":
			return pasoEstacionFantasma(nivel, jugador)
		"nivel_7.tscn":
			return pasoCasa()
	return []
func pasoPlaza(nivel, jugador):
	var adentro = jugador.global_position.y < 2100.0
	if adentro and not tiene("sube"):
		return ["Buscá la SUBE para pasar los molinetes (F para agarrarla). Si no la encontrás, podés forzar los molinetes.", "SUBE"]
	if adentro:
		return ["Pasá los molinetes (F). Necesitás la SUBE, una ganzúa o los pernos.", "ZonaMolinetes"]
	if not tiene("llaveMc"):
		return ["Buscá la llave del McDonald's tirada en la plaza. Tirá piedras (E) o golpeá (Espacio) a los vagabundos.", "LlaveMcDonalds"]
	if not tiene("llaveSubte"):
		return ["Entrá al McDonald's (puerta amarilla, F). Opcional: la comisaría, abajo a la derecha, tiene una pistola de bengalas.", "EntradaMcDonalds"]
	var texto = "Bajá al subte por la reja de la plaza (F)."
	if not tiene("powerbank"):
		texto += " Antes conviene tener el powerbank del McDonald's: en el subte no hay dónde cargar."
	return [texto, "EntradaSubte"]
func pasoMc(nivel, jugador):
	var arriba = jugador.global_position.x > 2000.0
	if not tiene("llaveSubte") and existe(nivel, "Cliente"):
		return ["Encontrá al Cliente (planta baja, a la derecha): tiene la llave del subte. Pegale con Espacio; se pone rojo un instante antes de pegar.", "Cliente"]
	if not tiene("llaveSubte"):
		return ["Agarrá la llave del candado que soltó el Cliente (F).", ""]
	if not tiene("powerbank") and not arriba:
		return ["Recomendado: subí al segundo piso (escalera, F) y buscá el powerbank en la oficina.", "ZonaEscaleraSubir"]
	if not tiene("powerbank"):
		return ["Agarrá el powerbank en la oficina (F). Cuando lo tengas salen los bichos: corré a la escalera.", "Powerbank"]
	if arriba:
		return ["Bajá por la escalera (F).", "ZonaEscaleraBajar"]
	return ["Salí del McDonald's (puerta de abajo) y andá a la reja del subte, en la plaza.", "ZonaSalida"]
func pasoComisaria(nivel):
	if not Inventario.pistola:
		return ["Entrá a los calabozos (arriba a la derecha, F). Desde la celda hay un camino al depósito de evidencia, donde está la pistola de bengalas.", "EntradaCalabozos"]
	return ["Ya tenés la pistola (E). Salí a la plaza por la puerta de abajo (F).", "SalidaCalle"]
func pasoCelda(nivel):
	if Inventario.pistola:
		return ["Salí por la puerta del depósito (F).", "SalidaDeposito"]
	if existe(nivel, "GanzuaColchon"):
		return ["Estás encerrado. Agarrá la ganzúa que está en la celda (F).", "GanzuaColchon"]
	if existe(nivel, "RejillaPernos") and not nivel.get_node("RejillaPernos").abierta:
		return ["Sacá los pernos de la rejilla del fondo de la celda (F).", "RejillaPernos"]
	return ["Arrastrate por el conducto hasta el depósito y agarrá la pistola de bengalas.", "PistolaBengalas"]
func pasoSubte():
	if not tiene("powerbank") and Inventario.bateria < 35.0:
		return ["Te queda poca batería. Volvé a la plaza (escalera, F) y buscá el powerbank en el McDonald's.", "SubirPlaza"]
	return ["Seguí el andén y los túneles hasta la puerta de servicio (al fondo, a la derecha). Apagá la linterna (Q) para que los pálidos no se muevan.", "PuertaServicio"]
func pasoEstacionFantasma(nivel, jugador):
	if not tiene("silbato") and jugador.global_position.x < 2850.0:
		return ["Buscá el andén: seguí el túnel largo que sale hacia abajo. Si te devuelve al principio, cruzalo con la linterna apagada (Q).", "MARCADORES/TUNEL_META"]
	if not tiene("silbato") and existe(nivel, "Guarda"):
		return ["Derrotá al Guarda: te ve solo con la linterna prendida. Suelta un silbato.", "Guarda"]
	if not tiene("silbato"):
		return ["Agarrá el silbato que soltó el Guarda (F).", ""]
	if not tiene("sube"):
		return ["Te falta la SUBE: hay una en la alacena detrás de la rejilla, en el cuarto de arriba (F para sacar los pernos).", "RejillaAlacena"]
	return ["Pasá el molinete de salida (F) con la SUBE y el silbato.", "MolineteSalida"]
func pasoCasa():
	if Tutorial.vistos.has("fin"):
		return ["Fin. Gracias por jugar.", ""]
	return ["Entrá a la cocina.", "ZonaFin"]
