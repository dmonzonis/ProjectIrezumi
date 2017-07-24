extends TileMap

const bullet = preload("res://bullet.tscn")

func _ready():
	var bulletNode = bullet.instance()
	add_child(bulletNode)
	bulletNode.initialize(Vector2(200, 200), Vector2(-1, -1), 350, 20, true)
