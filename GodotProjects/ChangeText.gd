extends SpinBox


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var currentText:String
var spinBox :SpinBox
var stringToAnnounce= "Change_Mass"
# Called when the node enters the scene tree for the first time.
func _ready():
	spinBox=self
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpinBox_value_changed(value):
	emit_signal("Change_Mass",value)
	pass # Replace with function body.
