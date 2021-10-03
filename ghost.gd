# ghost object, play back and draw where you are

extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Color, RGBA) var ghost_color = Color(1,1,1,1)
var ghost_state = []
var counter = 0
var ghost_max_steps = 0

func load_ghost_data(data):
	ghost_state = data
	pass

func set_ghost_max_steps(count):
	print('setting max steps for ghost at ', count)
	ghost_max_steps = count

# Called when the node enters the scene tree for the first time.
func _ready():
	# load_ghost_data(data)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(counter < ghost_max_steps):
		counter += 1
		
	position.x = ghost_state[counter].x
	position.y = ghost_state[counter].y
	
	print('hello i am a ghost at ', position)
	
	pass


func _draw():
	draw_circle(Vector2(0,0), 10, ghost_color)
