extends StaticBody2D
@export var rota = false
func _ready():
	if rota:
		$Sprite2D.texture = load("res://assets/plaza/farola_1.png")
		$Luz.parpadea = false
		$Luz.visible = false
