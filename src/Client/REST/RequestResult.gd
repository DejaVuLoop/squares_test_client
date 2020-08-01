class_name RequestResult extends Resource;

var code: int;
var body;

func _init():
	pass;

func to_string() -> String:
	return "CODE: " + str(code) + "\nBODY: \n\t" + str(body);
