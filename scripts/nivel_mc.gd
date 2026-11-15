extends Node2D
func _ready():
	CambioNivel.ubicarJugador(self)
	if not Inventario.yaRecogido("intro_nivel_mc"):
		Inventario.marcarRecogido("intro_nivel_mc")
		Tutorial.mostrarTexto("McDONALD'S", "Está a oscuras y el parlante repite el pedido 307. Sentado a la derecha de la planta baja hay un fisura comiendo: el Cliente. Tiene la llave del candado del subte. Hablale con F. Leé la nota de la entrada antes. En el piso de arriba hay un powerbank (escalera, F).")
