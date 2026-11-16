extends Node2D
#cuando el jugador consigue cierta llave, hace aparecer un enemigo en cada punto (los hijos de este nodo)
@export var escena: PackedScene
@export var llave_disparadora = ""
@export var id_aparicion = ""
@export var vida = 2
@export var velocidad = 120.0
@export var dano = 0.5
@export var escala = 0.6
@export var rango_deteccion = 3000.0

var hecho = false

func _ready() -> void:
	hecho = Inventario.ya_recogido(id_aparicion)

func _process(delta: float) -> void:
	if hecho or not Inventario.tiene_llave(llave_disparadora):
		return
	hecho = true
	Inventario.marcar_recogido(id_aparicion)
	Inventario.mostrar_mensaje("Algo se mueve en la cocina")
	for punto in get_children():
		invocar(punto.global_position)

func invocar(posicion: Vector2) -> void:
	var bicho = escena.instantiate()
	bicho.vida = vida
	bicho.velocidad = velocidad
	bicho.dano = dano
	bicho.rango_deteccion = rango_deteccion
	bicho.scale = Vector2(escala, escala)
	bicho.variante = 2
	get_parent().add_child(bicho)
	bicho.global_position = posicion
