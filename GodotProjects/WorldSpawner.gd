extends Node2D

var MAX_POINTS = 1000
var line :Line2D
var G = 0.6
var sunGravity:RigidBody2D
var attractor
var attractorList=[]
var currentMass =5.9
var pressed :bool=false
var velocity = Vector2(0,6700)
var g_base =.0006
var checker :Sprite
var g_constant = 0.00006
var for_loop_running=false


var canvas_planet_node

var thread
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mousePosition:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	attractor=get_parent().get_node("KeepAttractors")
	attractorList=attractor.get_attractors()
	
	
	thread =Thread.new()
	checker = get_node("SpriteChecker")
	line = get_node("Line2D")
	pass # Replace with function body.

#input function
#detects drag
func _unhandled_input(event):

	if event is InputEventMouseButton:
		
		if event.button_index == BUTTON_LEFT and event.pressed:
			
			
			mousePosition=get_global_mouse_position()
			pressed=true
				
		else:
			pressed= false		
			


#Function that update the line2D trajectory 
#returns nothing
#called from process function
func _update_trajectory(delta):
	line.clear_points()
	
	var line_points = []
	var pos = mousePosition
	
	
	var vel = velocity
	var end: bool = false
# create new intersection and sort
	var i =1
	# loop to draw points for prediction line of orbit
	while end == false:
		line_points.append(pos)
		
		
		vel+=Rigidbody_test(pos)
		
		
		pos += vel*delta
		
		var check = IntersectionCheck(pos,line_points[line_points.size()-1],line_points)
		
		
		if(check):
			
			line_points.append(pos)
			end=true
			
		
	
	
	line.points=line_points	
	
	#call_deferred("_thread_done")
func IntersectionCheck(currentPos,lastPos,linePoints):
	
	var checked:bool =false
	for i in range(0,linePoints.size()-2):
		var vec1 = linePoints[i]
		var vec2 = linePoints[i+1]
		
		if(Geometry.segment_intersects_segment_2d(lastPos,currentPos,vec1,vec2)!=null):
			checked=true
	return checked
	


		
func Rigidbody_test(pos1:Vector2):

	var planetPos = attractorList[0].position
	var dir=(planetPos-pos1)
	var dis = dir.length()
	var forceMag= 2*G*((attractorList[0].mass*currentMass)/dis)
	var force =dir.normalized()*forceMag
	return force

func _thread_done():
	thread.wait_to_finish()

func _process(delta):
	
	if pressed == true:
		#var canvas = canvas_planet_node.instace()
		attractor.InstancePlanet(mousePosition)
		get_tree().paused=true
		_update_trajectory(delta)
	pressed=false
	
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

