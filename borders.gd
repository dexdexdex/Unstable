
extends Polygon2D

export(Color, RGBA) var OutLine = Color(1, 1, 1) 
var polygonData 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	polygonData = get_polygon()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# this works but it's stupid
	#self.look_at(get_parent().velocity*2000)
	#rotation_degrees = rad2deg(get_parent().normalized_velocity.angle_to_point(Vector2(0,0)))
	update()
	pass

func _draw():
	for i in range(1 , polygonData.size()):
		draw_line(polygonData[i-1] , polygonData[i], OutLine , 1)
	draw_line(polygonData[polygonData.size() - 1] , polygonData[0], OutLine , 1)	
