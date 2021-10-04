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
var server_nodes

var new_ghost_object

var ghost_number = 0

var have_reset = false

export(PackedScene) var ghost_object
export(int)var border_val
export (PackedScene) var Server

var player_steps = 0

var detected = false

var objective = Vector2(0,0)
var rng = RandomNumberGenerator.new()

var camera_posn


signal reset_ghosts

var temporal_instability = 0
var active_server

# the game states go from splash -> setup -> story -> timeloop -> story (ad naseum
# end states are victory or unstable
var game_state = "splash"

var time_loop_node
var splash_node
var story_node
var game_over_node
var victory_node

var keys_obtained = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	player_node = get_node("/root/controller/player")
	current_position_text_node = get_node("/root/controller/CanvasLayer/time_loop/current_position")
	splash_node = get_node("/root/controller/CanvasLayer/splash")
	story_node = get_node("/root/controller/CanvasLayer/story")
	time_loop_node = get_node("/root/controller/CanvasLayer/time_loop")
	game_over_node = get_node("/root/controller/CanvasLayer/game_over")
	victory_node = get_node("/root/controller/CanvasLayer/victory")

	temporal_instability_text_node = get_node("/root/controller/CanvasLayer/time_loop/temporal_instability")

	var server_width = 64
	var server_height = 64
	
	var num_servers_per_row = 1024/server_width
	var num_rows = 1024/server_height
	
	for row in range(-num_rows, num_rows):
		if row % 4 == 0:
			for col in range(-num_servers_per_row,num_servers_per_row):
				if col % 4 == 0:
					var server = Server.instance()
					server.position.x = col * server_width
					server.position.y = row * server_height
					add_child(server)

	# make one of the servers random
	server_nodes = get_tree().get_nodes_in_group("servers")
	
	active_server = rng.randi_range(0, server_nodes.size() - 1)

	# deactivate everywhere
	for servers in server_nodes:
		servers.deactivate()

	# activate one
	server_nodes[active_server].activate()

	pass # Replace with function body.


func _input(event):
	
	if(game_state == "splash" or game_state == "story"):
		if event is InputEventKey:
			if event.pressed:
				game_state = "time_loop"
				
		if event is InputEventJoypadButton:
			if event.pressed:
				game_state = "time_loop"

	if(game_state == "game_over" or game_state == "victory"):
		temporal_instability = 0
		keys_obtained = 0
		story_node.resetCode()
		if event is InputEventKey:
			if event.pressed:
				game_state = "splash"

				var ghosts = get_tree().get_nodes_in_group("ghost")
				for ghost in ghosts:
					ghost.queue_free()
				
				
		if event is InputEventJoypadButton:
			if event.pressed:
				game_state = "splash"
				
				

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if(game_state == "splash"):
		splash_node.visible = true
		story_node.visible = false
		time_loop_node.visible = false
		game_over_node.visible = false		
		victory_node.visible = false
		pass	

	if(game_state == "story"):
		splash_node.visible = false
		story_node.visible = true
		time_loop_node.visible = false
		game_over_node.visible = false		
		victory_node.visible = false
		pass	

	if(game_state == "game_over"):
		splash_node.visible = false
		story_node.visible = false
		time_loop_node.visible = false
		game_over_node.visible = true
		victory_node.visible = false
		
		pass	

	if(game_state == "victory"):
		splash_node.visible = false
		story_node.visible = false
		time_loop_node.visible = false
		game_over_node.visible = false
		victory_node.visible = true
		
		pass	
	
	if(game_state == "time_loop"):	
		splash_node.visible = false
		story_node.visible = false
		time_loop_node.visible = true
		game_over_node.visible = false
		victory_node.visible = false
	
		camera_posn = $player/Camera2D.get_camera_position()

		if(temporal_instability > 200):
			game_state = "game_over"

		if(have_reset == true):
			player_steps = 0
			player_state = []
			have_reset = false
				
		
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

		var vector_to_waypoint_x = server_nodes[active_server].get_global_position().x - player_node.get_global_position().x 
		var vector_to_waypoint_y = server_nodes[active_server].get_global_position().y - player_node.get_global_position().y 

		var clamped_vector = Vector2(vector_to_waypoint_x, vector_to_waypoint_y).clamped(100)

		server_nodes[active_server].get_node("indicator").global_position = Vector2(clamped_vector.x + camera_posn.x, clamped_vector.y + camera_posn.y)

		server_nodes[active_server].get_node("indicator").look_at(server_nodes[active_server].get_global_position())

		
	pass	


func objective_reset():
	story_node.update_code()
	var ghost_player_steps = player_steps
	var ghost_player_state = player_state
	new_ghost_object = ghost_object.instance()
	new_ghost_object.load_ghost_data(ghost_player_state)
	new_ghost_object.set_ghost_max_steps(ghost_player_steps)
	new_ghost_object.position.x = ghost_player_state[0].x
	new_ghost_object.position.y = ghost_player_state[0].y
	new_ghost_object.set_ghost_number(ghost_number)
		
	active_server = rng.randi_range(0, server_nodes.size() - 1)

	# deactivate everywhere
	for servers in server_nodes:
		servers.deactivate()

	# activate one
	server_nodes[active_server].activate()

	add_child(new_ghost_object)
	
	ghost_number = ghost_number + 1
	
	player_node.set_global_position(Vector2(rng.randi_range(-border_val, border_val), rng.randi_range(-border_val, border_val)))
		
	# this is a weird flag that we use to get past some weird race conditions I think
	# this is a weird flag that we use to get past some weird race conditions I think
	have_reset = true
	emit_signal("reset_ghosts")	
	
	keys_obtained += 1
	
	if(keys_obtained >= 7):
		game_state = "victory"
	else:
		game_state = "story"
	#player_steps = 0
	#player_state = []		


