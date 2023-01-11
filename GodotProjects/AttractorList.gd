extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var planet_node : PackedScene =preload("res://PhysicsPlanet.tscn")
var canvasToEdit

var attractors =[]
func _process(delta):
	if attractors.size()<=0:
		StartArray()	
	
		
func StartArray():
	var p = get_children()
	for s in p:
		attractors.append(s)

func InstancePlanet(position):

	var spawner = planet_node.instance()
	add_child(spawner)
	spawner.position = position
	attractors.append(spawner)
	return spawner


func remove_lastFromArray():
	attractors.remove(attractors.size()-1)

func addTo_attractors(planet):
	attractors.append(planet)
	pass



func get_attractors():
	return attractors
