extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mousePosition:Vector2
var pressed:bool
var attractor
var currentPlanet:RigidBody2D
var is_generating:bool=true
var canvas_to_spawn =preload("res://Control.tscn")

var canvas_spawned:Control
var currentSpeed =0.0
var camera_Controller
var current_mouse_pos

var planet_generate=false
var checkingForDrag=false
var dragging:bool =false
var mouseDrag : Line2D
var line:Line2D
var timerPressed=0.0
var attractorList 
var dir:Vector2
var trajectoryRunning=false
var G = 0.6
var currentMass=2.0
var currentSize =4.0
var currentDir:Vector2

var thread

#use 0.5
# Called when the node enters the scene tree for the first time.
func _ready():
	mouseDrag =get_node("Line2D")
	
	
	line = get_node("Trajectory")
	attractor=get_parent().get_node("KeepAttractors")
	thread =Thread.new()
	attractorList=attractor.get_attractors()
	canvas_spawned=get_child(0)
	pass # Replace with function body.

func _process(delta):
	if(is_generating):
		if pressed:
			if(currentPlanet!=null):
				pass
				#currentPlanet.position = mousePosition
			else:
				currentPlanet = attractor.planet_node.instance()
				attractor.add_child(currentPlanet)
				currentPlanet.position =mousePosition
				
		pressed=false
		
		if(checkingForDrag):
			timerPressed+=delta
			if(timerPressed>0.25):
				dragging=true
		if dragging:
			currentMass+=delta
			currentSize+=delta
			
			if currentMass>2.0:
				currentMass=.056
			if currentSize>=7.0:
				currentSize =1.0
			current_mouse_pos=get_global_mouse_position()
			dir = mousePosition-current_mouse_pos
			currentSpeed=dir.length()
			
			mouseDrag.clear_points()
			mouseDrag.add_point(mousePosition)
			mouseDrag.add_point(current_mouse_pos)
			
			
			currentPlanet.scale=Vector2(currentSize,currentSize)
			currentPlanet.mass = currentMass
			
			
			
			if(trajectoryRunning==false):
				
				if thread.is_alive()==false:
					thread.start(self, "_update_trajectory", delta)
				
				
	pass
	
func _exit_tree():
	thread.wait_to_finish()
	
	
func _unhandled_input(event):

	if event is InputEventMouseButton:
		
		if event.is_action_pressed("click"):
			get_tree().paused=true
			trajectoryRunning=false
			mousePosition=get_global_mouse_position()
			checkingForDrag=true
			pressed=true
		
		if event.is_action_released("click"):
			dragging=false
			planetCall()
			get_tree().paused=false
			checkingForDrag=false
	
	


func planetCall():
	print(currentSpeed)
	currentPlanet.mass =currentMass
	currentPlanet.get_child(1).scale=Vector2(currentSize,currentSize)		
	currentPlanet.get_child(0).scale=Vector2(currentSize,currentSize)	
	print(dir.normalized()*currentSpeed)
	attractor.addTo_attractors(currentPlanet)
	currentPlanet.linear_velocity=dir.normalized()*currentSpeed
	currentPlanet=null
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _update_trajectory(delta):
	line.clear_points()
	print("Thread Started")
	trajectoryRunning=true
	var line_points = []
	var pos = mousePosition
	
	
	var vel = currentSpeed*dir.normalized()
	var end: bool = false
# create new intersection and sort
	var i =1
	# loop to draw points for prediction line of orbit
	while end == false:
		line_points.append(pos)
		
		
		vel+=Rigidbody_test(pos)
		
		
		pos += vel*delta
		
		var check = IntersectionCheck(pos,line_points[line_points.size()-1],line_points)
		
		i+=1
		if(i>3000):
			check=true
		
		if(check):
			
			line_points.append(pos)
			end=true
			
		
	trajectoryRunning=false
		
	line.points=line_points	
	
	call_deferred("_thread_done")
	
func _thread_done():
	thread.wait_to_finish()

func IntersectionCheck(currentPos,lastPos,linePoints):
	
	var checked:bool =false
	for i in range(0,linePoints.size()-2):
		var vec1 = linePoints[i]
		var vec2 = linePoints[i+1]
		
		if(Geometry.segment_intersects_segment_2d(lastPos,currentPos,vec1,vec2)!=null):
			checked=true
	if(checked==false):
		checked = CheckIfPointIsInSpace(currentPos)
	
	return checked
	

func CheckIfPointIsInSpace(point):
	var checker=false
	for i in attractorList:
		if(i== currentPlanet):
			continue
		var size = i.get_node("CollisionShape2D").scale.x/2
		var pos = i.position

		
		if Geometry.is_point_in_circle(point,pos,size):
			return true
	
		
	return checker
func Rigidbody_test(pos1:Vector2):
	var force = Vector2(0.0,0.0)
	for i in attractorList:
		if i == currentPlanet:
			continue
		var planetPos = i.position
		var dire=(planetPos-pos1)
		var dis = dire.length()
		var forceMag= 2*G*((i.mass*currentPlanet.mass)/dis)
		force +=dire.normalized()*forceMag
	return force





