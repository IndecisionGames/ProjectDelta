extends Node2D
class_name GunBase

var rng = RandomNumberGenerator.new()

# Stats
var gun_name: String

var damage: float

var mag_size: int
var reload_time: float         # Seconds
var ammo_type

var fire_range: float
var bullet_velocity: float
var spread: float
var movement_penalty: float

var auto: bool
var burst_size: int

var fire_rate: float = 1.0          # Rounds Per Second
var bullets_per_shot: int

# Assets
onready var bullet_prefab
onready var bullet_node: Node

onready var fire_sound: AudioStreamPlayer2D
onready var reload_start_sound: AudioStreamPlayer2D
onready var reload_end_sound: AudioStreamPlayer2D

onready var tween: Tween
onready var muzzle_flash: Light2D
onready var muzzle_ambient: Light2D

# Getters
var ammo_count: FuncRef
var update_ammo_count: FuncRef

signal reload
signal ammo_change

# Internal values
var current_mag: int
var is_reloading: bool
var time_since_reload: float

var is_trigger_held: bool
onready var time_per_shot: float
onready var burst_bullets_left: int
var time_since_fire: float

func _ready():
	rng.randomize()
	is_trigger_held = false
	is_reloading = false
	
	time_since_reload = 0.0
	current_mag = mag_size

	time_per_shot = 1.0/fire_rate
	burst_bullets_left = burst_size
	time_since_fire = 0.0

# Interface(only the following functions should be called)
# - press_trigger
# - release_trigger
# - reload
# - make_active
# - process <- should be called by weapon user in _process

# TODO Improve Burst Functionality (add burst delay)
# TODO Improve valid shot and time since fire logic

func press_trigger():
	is_trigger_held = true
	if time_since_fire > time_per_shot:
		time_since_fire = time_per_shot
	if burst_bullets_left == 0:
		burst_bullets_left = burst_size

func release_trigger():
	is_trigger_held = false

func reload():
	if !is_reloading:
		if current_mag != mag_size and ammo_count.call_func(ammo_type) > 0:
			is_reloading = true
			time_since_reload = 0.0

			reload_start_sound.play()
			emit_signal("reload", is_reloading)


func make_active():
	print(gun_name + " Equiped")
	time_since_fire = time_per_shot
	emit_signal("reload", is_reloading)
	emit_signal("ammo_change", current_mag, ammo_count.call_func(ammo_type))
	
func process(delta, position, direction, move_speed):
	time_since_fire += delta
	process_reload(delta)

	if is_reloading:
		return

	process_fire(position, direction, move_speed)

func process_reload(delta):
	if !is_reloading:
		return

	time_since_reload += delta
	var reserve_count = ammo_count.call_func(ammo_type)
	var original_reserve_count = reserve_count

	if time_since_reload >= reload_time:
		is_reloading = false
		time_since_reload = 0.0
		time_since_fire = time_per_shot
		burst_bullets_left = burst_size
		is_trigger_held = false

		if reserve_count + current_mag >= mag_size:
			reserve_count -= (mag_size - current_mag)
			current_mag = mag_size
		else:
			current_mag += reserve_count
			reserve_count = 0

		reload_end_sound.play()
		update_ammo_count.call_func(ammo_type, reserve_count - original_reserve_count)
		emit_signal("reload", is_reloading)
		emit_signal("ammo_change", current_mag, reserve_count)

func process_fire(position, direction, move_speed):
	if !valid_shot():
		return

	if time_since_fire < time_per_shot:
		return
	
	time_since_fire -= time_per_shot
	create_bullets(time_since_fire, position, direction, move_speed)

	while time_since_fire >= time_per_shot and valid_shot():
		time_since_fire -= time_per_shot
		create_bullets(time_since_fire, position, direction, move_speed)

func create_bullets(backdate_time, position, direction, move_speed):
	current_mag -= 1
	if !auto:
		burst_bullets_left -= 1

	for i in range(bullets_per_shot):
		
		
		var direction_with_spread = direction.rotated(calculate_spread(move_speed))
		
		# TODO actually back date the bullet spawn
		var b = bullet_prefab.instance()
		b.setup(direction_with_spread, bullet_velocity, fire_range)
		bullet_node.add_child(b)
		b.set_position(position)

	toggle_muzzle_flash()
	tween.interpolate_callback(self, 0.05, "toggle_muzzle_flash")
	tween.start()
	emit_signal("ammo_change", current_mag, ammo_count.call_func(ammo_type))
	fire_sound.play()

func valid_shot():
	if is_reloading:
		return false

	if current_mag == 0:
		return false

	if !auto and burst_bullets_left == 0:
		return false

	if !auto and burst_bullets_left != burst_size:
		return true

	if !is_trigger_held:
		return false

	return true

func calculate_spread(move_speed):
	var random_spread = rng.randf_range(-1.0, 1.0)
	var natural_spread = spread/100.0
	var movement_multiplier = movement_penalty*move_speed/5000.0
	print(random_spread)
	print (movement_multiplier+natural_spread)
	return random_spread*min(movement_multiplier+natural_spread, deg2rad(145))

func toggle_muzzle_flash():
	muzzle_flash.set_visible(!muzzle_flash.is_visible())
	muzzle_ambient.set_visible(!muzzle_ambient.is_visible())
