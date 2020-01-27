extends Area2D

const BULLET_SPEED = 800
var direction: Vector2

func position(pos):
	direction = pos.normalized()

func _ready():
	set_process(true)
	look_at(direction)
	
func _process(delta):
	pass
	var motion = direction * BULLET_SPEED
	set_position(get_position() + motion * delta)