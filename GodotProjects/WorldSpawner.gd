extends Node2D

var MAX_POINTS = 1000
var line :Line2D
var G = 9.8
var sunGravity:RigidBody2D
var attractorList=[]
var currentMass =5.9
var pressed :bool=false
var velocity = Vector2(0,6700)
var g_base =.0006
var checker :Sprite
var g_constant = 0.00006
var for_loop_running=false

var thread
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mousePosition:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	attractorList=get_parent().get_node("KeepAttractors").get_attractors()
	
	thread =Thread.new()
	checker = get_node("SpriteChecker")
	line = get_node("Line2D")
	pass # Replace with function body.

#input function
#detects drag
func _input(event):

	if event is InputEventMouseButton:
		
		if event.pressed:
			match event.button_index:
			#Spawn a new node of type node wiht settings youve created
				BUTTON_LEFT:
					print(attractorList.size())
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
	

	
	var i =1
	# loop to draw points for prediction line of orbit
	while i< MAX_POINTS:
		line_points.append(pos)
		
		
		vel+=Rigidbody_test(pos)
		
		
		pos += vel*delta
		
		i+=1
	
	line.points=line_points	
	
	call_deferred("_thread_done")
		


func Rigidbody_test(pos1:Vector2):

	var planetPos = attractorList[0].position
	var dir=(planetPos-pos1)
	var dis = dir.length()
	var forceMag= 2*G*((attractorList[0].mass*currentMass)/dis)
	var force =dir.normalized()*forceMag
	return force

func _thread_done():
	thread.wait_to_finish()
var pro=0
func _process(delta):
	if pressed == true:
		if thread.is_active()==false:
			
			thread.start(self,"_update_trajectory",delta)
	
	
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
