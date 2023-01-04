extends Node

class_name colorPooper

var color = []
func get_Color_Array():
	return color
func get_Color(a: Color):
	if(color.size()>0):
		return color[a]
	else:
		print(a)

func appendToArray(a:Color):
	color.append(a)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
