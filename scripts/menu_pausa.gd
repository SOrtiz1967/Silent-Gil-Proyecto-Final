extends CanvasLayer
#menu de pausa (autoload), se abre y se cierra con Esc
var menu_abierto = false

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_cancel") or CambioNivel.en_menu():
		return
	if menu_abierto:
		continuar()
	elif not get_tree().paused:
		abrir()
	get_viewport().set_input_as_handled()

func abrir() -> void:
	menu_abierto = true
	visible = true
	get_tree().paused = true

func continuar() -> void:
	menu_abierto = false
	visible = false
	get_tree().paused = false

func _on_boton_continuar_pressed() -> void:
	continuar()

func _on_boton_reiniciar_pressed() -> void:
	continuar()
	Inventario.vida = -1.0
	Inventario.piedras = 0
	get_tree().reload_current_scene()

func _on_boton_salir_pressed() -> void:
	get_tree().quit()
