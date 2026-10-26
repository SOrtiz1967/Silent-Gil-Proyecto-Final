extends Node2D
func _ready():
	CambioNivel.ubicarJugador(self)
	if not Inventario.yaRecogido("intro_nivel_mc"):
		Inventario.marcarRecogido("intro_nivel_mc")
		Tutorial.mostrarTexto("McDONALD'S", "Está vacío y el parlante repite el pedido 307. El Cliente, sentado a la derecha de la planta baja, tiene la llave del candado del subte: pegale con Espacio (se pone rojo antes de pegar). En el piso de arriba hay un powerbank: escalera con F.")
