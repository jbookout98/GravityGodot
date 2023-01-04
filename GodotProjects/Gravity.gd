

extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var attractor =[]
var attractorParent
var G = 9.8
var area=[]
func getName():
	return self.na
# Called when the node enters the scene tree for the first time.
func _ready():
	attractorParent =self.get_parent()
	
func _process(delta):
	if(area.size()<=0):
		area = attractorParent.get_attractors()
	

	 # Replace with function body.


func _physics_process(delta):
	for g in area:
		if(g != self):
			Attract(g)

func Attract(planet:Node2D):
	var rb :RigidBody2D
	rb = planet
	var rbSelf:RigidBody2D
	rbSelf = self
	var dir:Vector2
	dir = rb.position-rbSelf.position
	var dis = dir.length()
	var distanceSize = (rb.get_node("CollisionShape2D").scale.x+rbSelf.get_node("CollisionShape2D").scale.x)*10
	
	var ds = dis-distanceSize
	
	if(ds < 1):
		return
	var forceMagnitude = -2*G*((rb.mass*rbSelf.mass)/dis)
	
	var force:Vector2
	force =dir.normalized()*forceMagnitude
	
	rb.apply_central_impulse(force)
	
	#gravity


