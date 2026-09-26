extends CanvasLayer
@export_multiline var textoLlave = "Encontraste una llave. Se guarda sola en tu inventario, que abris con T. Acercate a la puerta que le corresponde y apreta F para abrirla."
@export_multiline var textoGanzua = "Las ganzuas sirven para forzar cerraduras. Si fallas se rompen, asi que usalas con cuidado. Con T ves cuantas te quedan. Sin ganzuas tambien podes intentarlo, pero es mas dificil."
@export_multiline var textoCerradura = "La aguja va y viene por la barra. Apreta F cuando este sobre la zona verde. Necesitas 3 aciertos y la zona se achica con cada uno. Si fallas se rompe una ganzua. Esc para salir."
@export_multiline var textoPernos = "Sin ganzua tenes que forzarla a mano. La linea roja se ve solo un instante: acordate donde esta. Apreta F cuando la punta del perno toque la linea. Si fallas se caen todos. Esc para salir."
@export_multiline var textoIntro = "Usa WASD para moverte. Busca la SUBE para poder pasar los molinetes."
@export_multiline var textoSube = "Conseguiste la SUBE. Funciona como una ganzua: te deja pasar los molinetes. Acercate y apreta F."
@export_multiline var textoMolinete = "Pasaste los molinetes. Segui explorando la estacion."
@export_multiline var textoCombate = "Cuidado, hay fisuras en la plaza. Espacio para golpear de cerca, E para disparar de lejos."
@export_multiline var textoFinal = "Llegaste al final de este recorrido de prueba."
var activo = false
var vistos = []
var pausoElJuego = false
var cuadroApertura = -1
@onready var etiquetaTitulo = $Panel/EtiquetaTitulo
@onready var etiquetaTexto = $Panel/EtiquetaTexto
func mostrar(idTutorial):
	if activo or vistos.has(idTutorial):
		return
	vistos.append(idTutorial)
	etiquetaTitulo.text = idTutorial.to_upper()
	etiquetaTexto.text = textoDe(idTutorial)
	pausoElJuego = not get_tree().paused
	get_tree().paused = true
	cuadroApertura = Engine.get_process_frames()
	activo = true
	visible = true
func textoDe(idTutorial):
	match idTutorial:
		"llave":
			return textoLlave
		"ganzua":
			return textoGanzua
		"cerradura":
			return textoCerradura
		"pernos":
			return textoPernos
		"intro":
			return textoIntro
		"sube":
			return textoSube
		"molinete":
			return textoMolinete
		"combate":
			return textoCombate
		"final":
			return textoFinal
		_:
			return ""
func _process(delta):
	if puedeCerrar() and Input.is_action_just_pressed("interactuar"):
		cerrar()
func puedeCerrar():
	return activo and Engine.get_process_frames()!=cuadroApertura
func cerrar():
	visible = false
	set_deferred("activo", false)
	if pausoElJuego:
		get_tree().set_deferred("paused", false)
