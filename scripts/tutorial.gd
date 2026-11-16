extends CanvasLayer
#autoload. muestra los cuadros de texto (tutoriales, carteles, historia) y pausa el juego mientras estan abiertos
#los textos se pueden editar desde el inspector. el id del tutorial es lo que va despues de "texto_"
@export_multiline var texto_llave = "Encontraste una llave. Se guarda sola en tu inventario, que abris con T. Acercate a la puerta que le corresponde y apreta F para abrirla."
@export_multiline var texto_ganzua = "Las ganzuas sirven para forzar cerraduras. Si fallas se rompen, asi que usalas con cuidado. Con T ves cuantas te quedan. Sin ganzuas tambien podes intentarlo, pero es mas dificil."
@export_multiline var texto_cerradura = "Si no encontras la llave o la SUBE, podes forzar la cerradura con este juego. La aguja va y viene por la barra: apreta F cuando este sobre la zona verde. Necesitas 3 aciertos y la zona se achica con cada uno. Si fallas se rompe una ganzua. Esc para salir."
@export_multiline var texto_pernos = "Sin ganzua tenes que forzarla a mano, y asi tambien podes pasar si no tenes la llave. La linea roja se ve solo un instante: acordate donde esta. Apreta F cuando la punta del perno toque la linea. Si fallas se caen todos. Esc para salir."
@export_multiline var texto_intro = "Usa WASD o las flechas para moverte. Con T abris el inventario y con H ves todos los controles. Arriba a la derecha de la pantalla siempre tenes el objetivo y hacia donde ir. Busca la SUBE para poder pasar los molinetes."
@export_multiline var texto_sube = "Conseguiste la SUBE. Funciona como una ganzua: te deja pasar los molinetes. Acercate y apreta F."
@export_multiline var texto_molinete = "Pasaste los molinetes. Segui explorando la estacion."
@export_multiline var texto_combate = "Pasaste los molinetes. Afuera te esperan los fisuras: vagabundos agresivos que te persiguen y te golpean. Espacio para golpear de cerca, E para tirar piedras. Al caer, algunos sueltan una bebida que te cura. Si necesitas curarte, volve: dentro de la estacion hay un kiosco con provisiones."
@export_multiline var texto_celular = "Tu celular es tu linterna y su bateria se gasta mientras esta prendida. Apreta Q para apagarla y ahorrar. Busca los puntos de carga (los postes celestes) y mantene F para cargarlo."
@export_multiline var texto_powerbank = "Un powerbank. Con esto el celular se carga solo, de a poco, hasta llegar al 100%, y ahi se queda: la bateria ya no se gasta."
@export_multiline var texto_hamburguesa = "Encontraste una de las hamburguesas del Cliente. Si se la llevas (F cerca de el) te acercas a la llave del subte. Si te la comes con C te cura toda la vida, pero rompes el trato y el Cliente te pelea a muerte."
@export_multiline var texto_fin = "Llegaste a tu casa. El reloj de la cocina marca las 3:07 y no hay nadie. Fin."
@export_multiline var texto_guardia = "Antes de bajar: después del subte te espera un guardia muy fuerte, que te puede matar en pocos golpes. Sin la pistola de bengalas va a ser muy difícil matarlo. La pistola está en el depósito de la comisaría, abajo a la derecha de la plaza."
@export_multiline var texto_ayuda = "WASD o flechas: moverte\nEspacio: golpear\nE: tirar piedras o bengalas\nF: agarrar, abrir, leer, entrar y cargar el celular (mantener)\nT: inventario\nC: comer una hamburguesa (cura toda la vida)\nQ: prender o apagar la linterna del celular\nH: esta ayuda      Esc: pausa"
@export_multiline var texto_final = "Llegaste al final de este recorrido de prueba."

var activo = false
var vistos = []
var pauso_el_juego = false
var cuadro_apertura = -1

@onready var etiqueta_titulo = $Panel/EtiquetaTitulo
@onready var etiqueta_texto = $Panel/EtiquetaTexto

#los tutoriales con id solo salen una vez
func mostrar(id_tutorial: String) -> void:
	if activo or vistos.has(id_tutorial):
		return
	vistos.append(id_tutorial)
	abrir(titulo_de(id_tutorial), texto_de(id_tutorial))

func mostrar_texto(titulo: String, texto: String) -> void:
	if activo:
		return
	abrir(titulo, texto)

func abrir(titulo: String, texto: String) -> void:
	etiqueta_titulo.text = titulo
	etiqueta_texto.text = texto
	pauso_el_juego = not get_tree().paused
	get_tree().paused = true
	#guardo el frame para que el mismo F que abre el cuadro no lo cierre enseguida
	cuadro_apertura = Engine.get_process_frames()
	activo = true
	visible = true

func titulo_de(id_tutorial: String) -> String:
	if id_tutorial == "combate":
		return "LOS FISURAS"
	return id_tutorial.to_upper()

func texto_de(id_tutorial: String) -> String:
	#truquito: busca la variable "texto_" + id. si no existe devuelve null
	var texto = get("texto_" + id_tutorial)
	if texto == null:
		return ""
	return texto

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ayuda") and not activo and not get_tree().paused:
		mostrar_texto("CONTROLES", texto_ayuda)
	if puede_cerrar() and Input.is_action_just_pressed("interactuar"):
		cerrar()

func puede_cerrar() -> bool:
	return activo and Engine.get_process_frames() != cuadro_apertura

func cerrar() -> void:
	visible = false
	set_deferred("activo", false)
	if pauso_el_juego:
		get_tree().set_deferred("paused", false)
