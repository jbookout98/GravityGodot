extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var attractors =[]
func _process(delta):
	if attractors.size()<=0:
		StartArray()	
	
		
func StartArray():
	var p = get_children()
	for s in p:
		attractors.append(s)
	
func addTo_attractors():
	pass



func get_attractors():
	return attractors
