extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var code = []

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.

func resetCode():
	code = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func update_code():
	code.push_back(char(floor(rng.randi_range(65, 90))))
	var newCode = []
	for i in range(0, code.size()):
		newCode.push_back(code[i])
	for i in range(code.size(), 8):
		newCode.push_back('_')
	var finalStr = ''
	for i in range(0, newCode.size()):
		finalStr += newCode[i] + ' '
	print('this is my code code code ', code)
	$MarginContainer/VBoxContainer/Code.text = finalStr
