extends Area2D


func _on_area_entered(area):
	var root = get_node("../")
	print(root.name)
	Utils.loadScene(root, "test")
