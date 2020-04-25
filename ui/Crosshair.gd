extends Node2D

var color = Color.white;
var error = 30;

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	set_global_position(get_global_mouse_position())

func updateCrosshairColor(new_color):
	color = new_color
	update()
	
func updateCrosshairError(new_error):
	error = new_error * 200
	update()	

func _draw():
	draw_circular_crosshair()
	draw_standard_crosshair()

func draw_circular_crosshair():
	draw_circle(Vector2(0,0), 2, color) # center dot
	draw_arc(Vector2(0,0), error, 0, deg2rad(360), 360, color, 1.0) # error circle
	
func draw_standard_crosshair():
	draw_line(Vector2(error,0), Vector2(error+13,0), color, 1)
	draw_line(Vector2(-error,0), Vector2(-error-13,0), color, 1)
	draw_line(Vector2(0,error), Vector2(0,error+13), color, 1)
	draw_line(Vector2(0,-error), Vector2(0,-error-13), color, 1)
