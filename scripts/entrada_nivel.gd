extends Area2D
#puerta para pasar a otro nivel. punto_destino es el nodo del otro nivel donde aparece el jugador
@export var llave_requerida = ""
@export var llave_extra = ""
@export var ruta_nivel = ""
@export var punto_destino = ""
@export var mensaje_bloqueada = "Esta cerrada con llave"
@export var texto_aviso = "F para entrar"

var jugador_cerca = false

func _process(delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		intentar_entrar()

func intentar_entrar() -> void:
	if llave_requerida != "" and not Inventario.tiene_llave(llave_requerida):
		Inventario.mostrar_mensaje(mensaje_bloqueada)
		return
	if llave_extra != "" and not Inventario.tiene_llave(llave_extra):
		Inventario.mostrar_mensaje(mensaje_bloqueada)
		return
	jugador_cerca = false
	Inventario.ocultar_aviso()
	CambioNivel.ir(ruta_nivel, punto_destino)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = true
		Inventario.mostrar_aviso(texto_aviso)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = false
		Inventario.ocultar_aviso()
