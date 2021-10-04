# ghost object, play back and draw where you are

extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Color, RGBA) var ghost_color = Color(1,1,1,1)
export(Color, RGBA) var ghost_circle_color

var ghost_state = []
var counter = 0
var ghost_max_steps = 0

var player_node
var ghost_number
var control_node 
var reverse = false

func load_ghost_data(data):
	ghost_state = data
	pass

func set_ghost_max_steps(count):
	ghost_max_steps = count

func set_ghost_number(number):
	ghost_number = number

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

# Called when the node enters the scene tree for the first time.
func _ready():
	player_node = get_node("/root/controller/player")
	control_node = get_node("/root/controller")
	control_node.connect("reset_ghosts", self, "_on_reset_ghosts")
	# load_ghost_data(data)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if(control_node.game_state == "time_loop"):	
		if reverse:
			if (counter == 0):
				counter += 1
				reverse = false
			else:
				counter -= 1
		else:	
			if(counter < ghost_max_steps - 1):
				counter += 1
			else:
				counter -= 1
				reverse = true
			
		position.x = ghost_state[counter].x
		position.y = ghost_state[counter].y


		var distance_to_player = (self.get_global_position()).distance_to(player_node.get_position())
		if(distance_to_player <= 100):
			control_node.temporal_instability += (100 - distance_to_player) * delta * 5


func _draw():
	draw_circle(Vector2(0,0), 10, ghost_color)
	
	var angle_from = 0
	var angle_to = 360
	var radius = 100
	draw_circle_arc(Vector2(0,0), radius, angle_from, angle_to, ghost_circle_color)	


func _on_reset_ghosts():
	counter = 0
