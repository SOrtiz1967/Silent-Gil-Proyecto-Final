extends CanvasLayer
var menuAbierto=false
func _unhandled_input(event):
	if not event.is_action_pressed("ui_cancel"):
		return
	if menuAbierto:
		continuar()
	elif not get_tree().paused:
		abrir()
	get_viewport().set_input_as_handled()
func abrir():
	menuAbierto=true
	visible=true
	get_tree().paused=true
func continuar():
	menuAbierto=false
	visible=false
	get_tree().paused=false
func _on_boton_continuar_pressed():
	continuar()
func _on_boton_reiniciar_pressed():
	continuar()
	get_tree().reload_current_scene()
func _on_boton_salir_pressed():
	get_tree().quit()
