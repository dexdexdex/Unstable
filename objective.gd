extends Node2D

export(Color, RGBA) var objective_color

export(int) var objective_border

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player_node
var control_node

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	player_node = get_node("/root/controller/player")
	control_node = get_node("/root/controller")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance_to_player = (self.get_global_position()).distance_to(player_node.get_position())
	if(distance_to_player < 20):
		control_node.objective_reset()
		var new_position = Vector2(rng.randi_range(-objective_border, objective_border), rng.randi_range(-objective_border, objective_border))
		set_global_position(new_position)
	
	pass

func _draw():
	draw_circle(Vector2(0,0), 20, objective_color)
