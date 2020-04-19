extends Area2D

var time_to_live = 30
var time_live = 0.0

var sprit_filepath = "res://assets/sprites/pickups/ammo/light_ammo.png"
var pickup_method_call = "pickup_ammo"
var pickup_method_params = [AmmoType.LIGHT, 40]

func setup(position, ttl, method_call, method_params):
	set_position(position)
	time_to_live = ttl
	pickup_method_call = method_call
	pickup_method_params = method_params

func _ready():
	var sprite = get_node("Sprite")
	sprite.set_texture(load(sprit_filepath))
	
	connect("body_entered", self, "_on_Pickup_body_entered")
	time_live = 0.0

func _process(delta):
	time_live += delta
	despawn_timer(delta)

func despawn_timer(delta):
	if time_live >= time_to_live:
		queue_free()

func _on_Pickup_body_entered(body):
	if body.has_method(pickup_method_call):
		body.callv(pickup_method_call, pickup_method_params)
		queue_free()
