extends Node2D

var MAX_POINTS = 360
var line :Line2D
var G = 9.8
var sunGravity:RigidBody2D
var currentMass =5.9
var pressed :bool=false
var velocity = Vector2(0,1600)
var g_base =.0006
var checker :Sprite
var g_constant = 0.00006
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mousePosition:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	sunGravity = get_parent().get_node("KeepAttractors/Sun")
	checker = get_node("SpriteChecker")
	line = get_node("Line2D")
	pass # Replace with function body.

func _unhandled_input(event):

	if event is InputEventMouse:
		if event.button_mask==BUTTON_MASK_LEFT:
			#Spawn a new node of type node wiht settings youve created
			
			mousePosition=get_global_mouse_position()
			pressed=true
	else:
		pressed= false		
			



func _update_trajectory(delta):
	line.clear_points()
	var line_points = []
	var pos = mousePosition
	
	#starting velocity 200 for now
	var xAxis=200
	var yAxis =200
	
	var vel = velocity
	var vecR = sunGravity.position-pos
	var gravityForce = (vecR).normalized()
	var angle= 0
	
	var r = find_r(mousePosition,sunGravity.position,delta,angle)
	var lastPos = pos +velocity.normalized()
	for i in range(1,MAX_POINTS-1):
		line_points.append(pos)
		
		vel+=Accel_return(pos,lastPos)*delta
		lastPos=pos
		pos += vel*delta
		
		
	for l in line_points:
		line.add_point(l)		
		
		
		
	
		
		
		
		
func Accel_return(pos1:Vector2,lastPos:Vector2):
	var forceDir =(lastPos-pos1).normalized()
	var sqrDist = pow(forceDir.length(),2)
	var acceleration = forceDir*g_constant*currentMass/sqrDist
	return acceleration
		
func Rigidbody_test(pos1:Vector2):
	var rb :RigidBody2D
	rb = sunGravity
	
	var dir:Vector2
	dir = rb.position-pos1
	var dis = dir.length()
	var distanceSize = (rb.get_node("CollisionShape2D").scale.x+1)*10
	
	var ds = dis-distanceSize
	
	if(ds < 1):
		return
	var forceMagnitude = -2*G*((rb.mass*currentMass)/dis)
	
	var force:Vector2
	force =dir.normalized()*forceMagnitude
	
	return force
		
		
func r_Path(angle:float, pos1:Vector2):
	
	var distance = (pos1-sunGravity.position).length()
	var v= velocity.length()
	var bottom = 2*(G*sunGravity.mass)-distance*pow(v,2)
	var top =  G*sunGravity.mass*distance
	var a = top/bottom
	var inside_e =1+((distance*pow(v,2)/(G*sunGravity.mass))*((distance*pow(v,2)-2)))
	var e= sqrt(inside_e)
	var r = a*(1-pow(e,2))/(1+e*cos(angle))
	return r

func find_r(pos1:Vector2,pos2:Vector2,delta:float,angle:float):
	var distance = (pos1-pos2).length()
	var v= velocity.length()
	var bottom = 2*(G*sunGravity.mass)-distance*pow(v,2)
	var top =  G*sunGravity.mass*distance
	var a = top/bottom
	var inside_e =1+((distance*pow(v,2)/(G*sunGravity.mass))*((distance*pow(v,2)-2)))
	var e= sqrt(inside_e)
	var theta = find_offset_angle(a,e,pos1,v)
	var r = a*(1-pow(e,2))/(1+e*cos(angle))
	var offsetandR = Vector2(r,theta)
	return offsetandR
	pass
func find_offset_angle(a:float,e:float,pos1:Vector2,v:float):
	var top = a*(1-pow(e,2))-sqrt(pow(pos1.x,2)+pow(pos1.x,2))
	var bottom = e*sqrt(pow(pos1.x,2)+pow(pos1.x,2))
	var inside_cos = top/bottom
	
	var v_theta=((pos1.x*velocity.y)-(pos1.y*velocity.x))/sqrt(pow(pos1.x,2)+pow(pos1.x,2))
	var v_r=((pos1.x*velocity.x)-(pos1.y*velocity.y))/sqrt(pow(pos1.x,2)+pow(pos1.x,2))
	var theta = sign(v_theta*v_r)*acos(inside_cos)-atan2(pos1.y,pos1.x)
	return theta

func _process(delta):
	if pressed == true:
		_update_trajectory(delta)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
