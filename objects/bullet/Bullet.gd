extends Area2D

const VELOCITY_MULTIPLIER = 100
const RANGE_MULTIPLIER = 5000

var velocity: int = 800
var max_range: float = 100.0
var distance_travelled: float = 0.0
var direction: Vector2

func setup(dir, bullet_speed, bullet_range):
	direction = dir
	velocity = VELOCITY_MULTIPLIER * bullet_speed
	max_range = RANGE_MULTIPLIER * bullet_range

func _ready():
	set_process(true)
	look_at(direction)
	
func _process(delta):
	move(delta)
	collide()
	range_check()
	
	
func move(delta):
	var motion = direction * velocity
	set_position(get_position() + motion * delta)
	# TODO: cap at max range if greater then max
	distance_travelled += motion.length()
	
func collide():
	var ob = get_overlapping_bodies()
	if ob.size() > 0:
		for o in ob:
			if o.name == "TileMap":
				queue_free()


func range_check():
	if distance_travelled >= max_range:
		queue_free()
