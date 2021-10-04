extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var control_node
var camera_posn
var int_velocity = Vector2(0,0)
var speed = 300
var velocity = Vector2(0,0)

export(int) var border_boundary

# Called when the node enters the scene tree for the first time.
func _ready():
	control_node = get_node("/root/controller")
	camera_posn =  get_node("/root/controller/player/Camera2D").get_camera_position()	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(control_node.game_state == "time_loop"):
		int_velocity = Vector2(0,0)
		if Input.get_connected_joypads().size() > 0:
			var xAxis = Input.get_joy_axis(0,JOY_AXIS_0)
			var yAxis = Input.get_joy_axis(0,JOY_AXIS_1)
			if(abs(xAxis) > 0.2):
				int_velocity.x = xAxis
			if(abs(yAxis) > 0.2):
				int_velocity.y = yAxis

		if Input.is_action_pressed("ui_right"):
			int_velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			int_velocity.x -= 1
		if Input.is_action_pressed("ui_down"):
			int_velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			int_velocity.y -= 1
			
			
		if int_velocity.length() > 0:		
			int_velocity = int_velocity.normalized() * speed * 2.5

		velocity = int_velocity	

		var collision = move_and_slide(velocity)
		if collision:
			pass
			#print("I collided with ", collision.collider.name)

		if(position.x > border_boundary-10):
			position.x = border_boundary-10
		
		if(position.x < -border_boundary+10):
			position.x = -border_boundary+10
		
		if(position.y > border_boundary-10):
			position.y = border_boundary-10
		
		if(position.y < -border_boundary+10):
			position.y = -border_boundary+10

						
		pass


func _draw():
	draw_circle(Vector2(0,0), 10, Color(1,1,1,0.8))
