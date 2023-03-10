extends Camera2D


var _target_zoom: float =1.0
const MIN_ZOOM: float =1.0
const MAX_ZOOM: float = 200.0
const ZOOM_INCREMENT: float =0.125

var zoom_rate: float =64.0

func _physics_process(delta:float)-> void:
	
	zoom = lerp(
		zoom,
		_target_zoom*Vector2.ONE,zoom_rate*delta)
	set_physics_process(not is_equal_approx(zoom.x,_target_zoom))

func _ready():
	_target_zoom=zoom.x/4
	pass
func _unhandled_input(event)->void:
	if event is InputEventMouseMotion:
		if event.button_mask==BUTTON_MASK_MIDDLE:
			
			position-=event.relative*zoom
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index==BUTTON_WHEEL_UP:
				zoom_in()
			if event.button_index==BUTTON_WHEEL_DOWN:
				zoom_out()
func zoom_in()->void:
	_target_zoom = max(_target_zoom-ZOOM_INCREMENT,MIN_ZOOM)
	set_physics_process(true)
func zoom_out()->void:
	_target_zoom=min(_target_zoom+ZOOM_INCREMENT,MAX_ZOOM)
	set_physics_process(true)
