extends Node
class_name GunConfig

# Assignable Variables
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

# Internal Variables
var ammo_count_func_name: String
var update_ammo_count_func_name: String

# Defaults
const DEFAULT_NAME = "UNKNOWN"
const DEFAULT_DAMAGE = 1.0

const DEFAULT_MAG_SIZE = 8
const DEFAULT_RELOAD_TIME = 2.0
const DEFAULT_AMMO_TYPE = "light"

const DEFAULT_FIRE_RANGE = 10.0
const DEFAULT_SPREAD = 2.0
const DEFAULT_BULLET_VELOCITY = 20.0

const DEFAULT_AUTO = false
const DEFAULT_BURST_SIZE = 1

const DEFAULT_FIRE_RATE = 3.0
const DEFAULT_BULLETS_PER_SHOT = 1

const DEFAULT_BULLET_PREFAB_FILEPATH = "res://objects/bullet/Bullet.tscn"

const DEFAULT_FIRE_SOUND_FILE_PATH = "res://assets/audio/gun_sounds/smg.wav"
const DEFAULT_RELOAD_START_SOUND_FILE_PATH = "res://assets/audio/gun_sounds/reload_start.wav"
const DEFAULT_RELOAD_END_SOUND_FILE_PATH = "res://assets/audio/gun_sounds/reload_end.wav"


func _init(dict):
	gun_name = dict.get("gun_name", DEFAULT_NAME)
	damage = dict.get("damage", DEFAULT_DAMAGE)

	mag_size = dict.get("mag_size", DEFAULT_MAG_SIZE)
	reload_time = dict.get("reload_time", DEFAULT_RELOAD_TIME)
	var ammo_type = dict.get("ammo_type", DEFAULT_AMMO_TYPE)

	fire_range = dict.get("fire_range", DEFAULT_FIRE_RANGE)
	spread = dict.get("spread", DEFAULT_SPREAD)
	bullet_velocity = dict.get("bullet_velocity", DEFAULT_BULLET_VELOCITY)

	auto = dict.get("auto", DEFAULT_AUTO)
	burst_size = dict.get("burst_size", DEFAULT_BURST_SIZE)

	fire_rate = dict.get("fire_rate", DEFAULT_FIRE_RATE)
	bullets_per_shot = dict.get("bullets_per_shot", DEFAULT_BULLETS_PER_SHOT)

	bullet_prefab_filepath = dict.get("bullet_prefab_filepath", DEFAULT_BULLET_PREFAB_FILEPATH)
	
	fire_sound_filepath = dict.get("fire_sound_filepath", DEFAULT_FIRE_SOUND_FILE_PATH)
	reload_start_sound_filepath = dict.get("reload_start_sound_filepath", DEFAULT_RELOAD_START_SOUND_FILE_PATH)
	reload_end_sound_filepath = dict.get("reload_end_sound_filepath", DEFAULT_RELOAD_END_SOUND_FILE_PATH)
	
	ammo_count_func_name = 'get_ammo_%s' % ammo_type
	update_ammo_count_func_name = 'update_ammo_%s' % ammo_type
