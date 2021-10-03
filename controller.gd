extends Node2D

# we will use a cool dictionary to record player positions
# each entry will be:

# x position
# y position

# playback will be according to dictionary that is closest to elapsed time I think

var player_state = []
var player_node
var current_position_text_node 
var temporal_instability_text_node

var new_ghost_object

var ghost_number = 0

var have_reset = false

export(PackedScene) var ghost_object
export(PackedScene) var objective_object
export(int)var border_val

var player_steps = 0

var detected = false

var objective = Vector2(0,0)
var rng = RandomNumberGenerator.new()

var camera_posn

var objective_object_instance

signal reset_ghosts

var temporal_instability = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	objective.x = rng.randi_range(-border_val, border_val)
	objective.y = rng.randi_range(-border_val, border_val)
	
	objective_object_instance = objective_object.instance()
	objective_object_instance.position = objective
	
	add_child(objective_object_instance)
	
	player_node = get_node("/root/controller/player")
	current_position_text_node = get_node("/root/controller/CanvasLayer/current_position")
	temporal_instability_text_node = get_node("/root/controller/CanvasLayer/temporal_instability")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	camera_posn = $player/Camera2D.get_camera_position()

	if(have_reset == true):
		player_steps = 0
		player_state = []
		have_reset = false
			
	var distance_to_objective = (objective_object_instance.get_global_position()).distance_to(player_node.get_position())	
	
	current_position_text_node.set_text("Current position is " + str(player_node.get_global_position()))
	temporal_instability_text_node.set_text("Temporal Instability at " + str(temporal_instability))
	
	player_steps = player_steps + 1
	# we are just gonna playback based off of number of frames
	# print ('current player position is ', player_node.get_global_position())
	var frame_data = {
		"x": player_node.get_global_position().x,
		"y": player_node.get_global_position().y
	}
	
	player_state.append(frame_data)

	if Input.is_action_pressed("ui_q"):
		
		var ghost_player_steps = player_steps
		var ghost_player_state = player_state
		new_ghost_object = ghost_object.instance()
		new_ghost_object.load_ghost_data(ghost_player_state)
		new_ghost_object.set_ghost_max_steps(ghost_player_steps)
		new_ghost_object.position.x = ghost_player_state[0].x
		new_ghost_object.position.y = ghost_player_state[0].y
		new_ghost_object.set_ghost_number(ghost_number)
			
		add_child(new_ghost_object)
		ghost_number = ghost_number + 1
		
	pass
	
	
	if Input.is_action_pressed("ui_w"):
		player_steps = 0
		player_state = []		

	var vector_to_waypoint_x = objective_object_instance.get_global_position().x - player_node.get_global_position().x 
	var vector_to_waypoint_y = objective_object_instance.get_global_position().y - player_node.get_global_position().y 

	var clamped_vector = Vector2(vector_to_waypoint_x, vector_to_waypoint_y).clamped(100)

	objective_object_instance.get_node("indicator").global_position = Vector2(clamped_vector.x + camera_posn.x, clamped_vector.y + camera_posn.y)

	objective_object_instance.get_node("indicator").look_at(objective_object_instance.get_global_position())

		
	pass	


func objective_reset():
	var ghost_player_steps = player_steps
	var ghost_player_state = player_state
	new_ghost_object = ghost_object.instance()
	new_ghost_object.load_ghost_data(ghost_player_state)
	new_ghost_object.set_ghost_max_steps(ghost_player_steps)
	new_ghost_object.position.x = ghost_player_state[0].x
	new_ghost_object.position.y = ghost_player_state[0].y
	new_ghost_object.set_ghost_number(ghost_number)
		
		
	add_child(new_ghost_object)
	
	print('finished spawning')
	ghost_number = ghost_number + 1
	
	player_node.set_global_position(Vector2(rng.randi_range(-border_val, border_val), rng.randi_range(-border_val, border_val)))
		
	# this is a weird flag that we use to get past some weird race conditions I think
	have_reset = true
	emit_signal("reset_ghosts")	
	#player_steps = 0
	#player_state = []		


