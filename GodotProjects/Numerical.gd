extends LineEdit

var regex = RegEx.new()
var oldtext = ""
func _ready():
	regex.compile("^[0-9]*$")
func _on_LineEdit_QTY_text_changed(new_text):
	var textInt = int(new_text)
	text = textInt
		
func get_value():
	return(int(text))
