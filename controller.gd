extends Node2D

# we will use a cool dictionary to record player positions
# each entry will be:

# x position
# y position

# playback will be according to dictionary that is closest to elapsed time I think

var player_state = []
var player_node

var new_ghost_object

var ghost_number = 0

export(PackedScene) var ghost_object

var player_steps = 0

var detected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player_node = get_node("/root/controller/player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
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
		
	pass	
