extends Control
class_name MenuPrincipal
#primera pantalla del juego. Jugar arranca una partida nueva desde la intro del tren

@onready var boton_jugar = $CenterContainer/VBoxContainer/BotonJugar
@onready var controles = $CenterContainer/VBoxContainer/Controles

func _ready() -> void:
	get_tree().paused = false
	controles.visible = false
	#para poder elegir con el teclado sin usar el mouse
	boton_jugar.grab_focus()

func _on_boton_jugar_pressed() -> void:
	CambioNivel.reiniciar_partida()

func _on_boton_controles_pressed() -> void:
	controles.visible = not controles.visible

func _on_boton_salir_pressed() -> void:
	get_tree().quit()
