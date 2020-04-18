extends Node
class_name GunConfig

var gun_name: String

var damage: float

var mag_size: int
var reload_time: float

var fire_range: float
var spread: float
var bullet_velocity: float

var auto: bool
var burst_size: int

var fire_rate: float
var bullets_per_shot: int

var bullet_prefab_filepath: String

var fire_sound_filepath: String
var reload_start_sound_filepath: String
var reload_end_sound_filepath: String

var ammo_count_func_name: String
var update_ammo_count_func_name: String


# values on right are default values
func _init(dict):
	gun_name = dict.get("gun_name", "unknown")
	damage = dict.get("damage", 1.0)

	mag_size = dict.get("mag_size", 8)
	reload_time = dict.get("reload_time", 2.0)

	fire_range = dict.get("fire_range", 10.0)
	spread = dict.get("spread", 0.0)
	bullet_velocity = dict.get("bullet_velocity", 20.0)

	auto = dict.get("auto", false)
	burst_size = dict.get("burst_size", 1)

	fire_rate = dict.get("fire_rate", 3.0)
	bullets_per_shot = dict.get("bullets_per_shot", 1)

	bullet_prefab_filepath = dict.get("bullet_prefab_filepath", "res://objects/bullet/Bullet.tscn")
	
	fire_sound_filepath = dict.get("fire_sound_filepath", "res://assets/audio/gun_sounds/smg.wav")
	reload_start_sound_filepath = dict.get("reload_start_sound_filepath", "res://assets/audio/gun_sounds/reload_start.wav")
	reload_end_sound_filepath = dict.get("reload_end_sound_filepath", "res://assets/audio/gun_sounds/reload_end.wav")
	
	var ammo_type = dict.get("ammo_type", "light")
	ammo_count_func_name = 'get_ammo_%s' % ammo_type
	update_ammo_count_func_name = 'update_ammo_%s' % ammo_type
