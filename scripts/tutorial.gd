extends CanvasLayer
@export_multiline var textoLlave = "Encontraste una llave. Se guarda sola en tu inventario, que abris con T. Acercate a la puerta que le corresponde y apreta F para abrirla."
@export_multiline var textoGanzua = "Las ganzuas sirven para forzar cerraduras. Si fallas se rompen, asi que usalas con cuidado. Con T ves cuantas te quedan. Sin ganzuas tambien podes intentarlo, pero es mas dificil."
@export_multiline var textoCerradura = "Si no encontras la llave o la SUBE, podes forzar la cerradura con este juego. La aguja va y viene por la barra: apreta F cuando este sobre la zona verde. Necesitas 3 aciertos y la zona se achica con cada uno. Si fallas se rompe una ganzua. Esc para salir."
@export_multiline var textoPernos = "Sin ganzua tenes que forzarla a mano, y asi tambien podes pasar si no tenes la llave. La linea roja se ve solo un instante: acordate donde esta. Apreta F cuando la punta del perno toque la linea. Si fallas se caen todos. Esc para salir."
@export_multiline var textoIntro = "Usa WASD o las flechas para moverte. Con T abris el inventario y con H ves todos los controles. Busca la SUBE para poder pasar los molinetes."
@export_multiline var textoSube = "Conseguiste la SUBE. Funciona como una ganzua: te deja pasar los molinetes. Acercate y apreta F."
@export_multiline var textoMolinete = "Pasaste los molinetes. Segui explorando la estacion."
@export_multiline var textoCombate = "Pasaste los molinetes. Afuera te esperan los fisuras: vagabundos agresivos que te persiguen y te golpean. Espacio para golpear de cerca, E para tirar piedras. Al caer, algunos sueltan una bebida que te cura. Si necesitas curarte, volve: dentro de la estacion hay un kiosco con provisiones."
@export_multiline var textoCelular = "Tu celular es tu linterna y su bateria se gasta mientras esta prendida. Apreta Q para apagarla y ahorrar. Busca los puntos de carga (los postes celestes) y mantene F para cargarlo."
@export_multiline var textoPowerbank = "Un powerbank. Con esto el celular se carga solo, de a poco, hasta llegar al 100%, y ahi se queda: la bateria ya no se gasta."
@export_multiline var textoFin = "Llegaste a tu casa. El reloj de la cocina marca las 3:07 y no hay nadie. Fin."
@export_multiline var textoAyuda = "WASD o flechas: moverte\nEspacio: golpear\nE: tirar piedras o bengalas\nF: agarrar, abrir, leer, entrar y cargar el celular (mantener)\nT: inventario\nQ: prender o apagar la linterna del celular\nH: esta ayuda      Esc: pausa"
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
	abrir(tituloDe(idTutorial), textoDe(idTutorial))
func mostrarTexto(titulo, texto):
	if activo:
		return
	abrir(titulo, texto)
func abrir(titulo, texto):
	etiquetaTitulo.text = titulo
	etiquetaTexto.text = texto
	pausoElJuego = not get_tree().paused
	get_tree().paused = true
	cuadroApertura = Engine.get_process_frames()
	activo = true
	visible = true
func tituloDe(idTutorial):
	match idTutorial:
		"combate":
			return "LOS FISURAS"
		_:
			return idTutorial.to_upper()
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
		"celular":
			return textoCelular
		"powerbank":
			return textoPowerbank
		"final":
			return textoFinal
		"fin":
			return textoFin
		_:
			return ""
func _process(delta):
	if Input.is_action_just_pressed("ayuda") and not activo and not get_tree().paused:
		mostrarTexto("CONTROLES", textoAyuda)
	if puedeCerrar() and Input.is_action_just_pressed("interactuar"):
		cerrar()
func puedeCerrar():
	return activo and Engine.get_process_frames()!=cuadroApertura
func cerrar():
	visible = false
	set_deferred("activo", false)
	if pausoElJuego:
		get_tree().set_deferred("paused", false)
