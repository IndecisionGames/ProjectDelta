extends Area2D

const BULLET_SPEED = 800
var direction: Vector2

func position(pos):
	direction = pos.normalized()

func _ready():
	set_process(true)
	look_at(direction)
	
func _process(delta):
	move(delta)
	collide()
	
func move(delta):
	var motion = direction * BULLET_SPEED
	set_position(get_position() + motion * delta)
	
func collide():
	var ob = get_overlapping_bodies()
	if ob.size() > 0:
		for o in ob:
			if o.name == "TileMap":
				queue_free()
