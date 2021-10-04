extends KinematicBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

export(Color, RGBA) var objective_color

export(int) var objective_border

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player_node
var control_node

var rng = RandomNumberGenerator.new()

var active = false

func activate():
	print('making this guy at ', self.get_global_position(), 'super active')
	active = true
	$active_flair.visible = true

func deactivate():
	active = false
	$active_flair.visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("servers")
	rng.randomize()
	player_node = get_node("/root/controller/player")
	control_node = get_node("/root/controller")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(active == true):
		var distance_to_player = (self.get_global_position()).distance_to(player_node.get_position())
		# print('active and I am only ', distance_to_player, ' away')
		
		if(distance_to_player < 55):
			control_node.objective_reset()
	
	pass

#func _draw():
#	draw_circle(Vector2(0,0), 20, objective_color)
