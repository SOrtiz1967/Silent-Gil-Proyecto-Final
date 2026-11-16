extends StaticBody2D
#si esta rota se cambia el sprite y se apaga la luz
@export var rota = false

func _ready() -> void:
	if rota:
		$Sprite2D.texture = load("res://assets/plaza/farola_1.png")
		$Luz.parpadea = false
		$Luz.visible = false
