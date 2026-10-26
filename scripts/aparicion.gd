extends Node2D
@export var escena:PackedScene
@export var idLlaveDisparadora = ""
@export var idAparicion = ""
@export var vida = 2
@export var velocidad = 120.0
@export var dano = 0.5
@export var escala = 0.6
@export var rangoDeteccion = 3000.0
var hecho = false
func _ready():
	hecho = Inventario.yaRecogido(idAparicion)
func _process(delta):
	if hecho or not Inventario.tieneLlave(idLlaveDisparadora):
		return
	hecho = true
	Inventario.marcarRecogido(idAparicion)
	Inventario.mostrarMensaje("Algo se mueve en la cocina")
	for punto in get_children():
		invocar(punto.global_position)
func invocar(posicion):
	var bicho = escena.instantiate()
	bicho.vida = vida
	bicho.velocidad = velocidad
	bicho.dano = dano
	bicho.rangoDeteccion = rangoDeteccion
	bicho.scale = Vector2(escala, escala)
	bicho.variante = 2
	get_parent().add_child(bicho)
	bicho.global_position = posicion
