extends GunBase
class_name GunInstance

var parent: Node

var fire_sound_filepath: String
var reload_start_sound_filepath: String
var reload_end_sound_filepath: String

var ammo_count_func_name: String
var update_ammo_count_func_name: String

func setup(parent_node: Node, gun_config: GunConfig):
	self.parent = parent_node
	
	self.gun_name = gun_config.gun_name
	self.damage = gun_config.damage
	
	self.mag_size = gun_config.mag_size
	self.reload_time = gun_config.reload_time
	self.ammo_type = gun_config.ammo_type

	self.fire_range = gun_config.fire_range
	self.spread = gun_config.spread
	self.bullet_velocity = gun_config.bullet_velocity

	self.auto = gun_config.auto
	self.burst_size = gun_config.burst_size

	self.fire_rate = gun_config.fire_rate
	self.bullets_per_shot = gun_config.bullets_per_shot
	
	self.bullet_prefab = load(gun_config.bullet_prefab_filepath)
	
	self.ammo_count_func_name = gun_config.ammo_count_func_name
	self.update_ammo_count_func_name = gun_config.update_ammo_count_func_name
	
	self.fire_sound_filepath = gun_config.fire_sound_filepath
	self.reload_start_sound_filepath = gun_config.reload_start_sound_filepath
	self.reload_end_sound_filepath = gun_config.reload_end_sound_filepath

func _ready():

	self.tween = get_node("Tween")
	self.muzzle_flash = get_node("MuzzleLight")
	self.muzzle_ambient = get_node("MuzzleAmbientLight")
	
	self.fire_sound = get_node("FireSound")
	self.reload_start_sound = get_node("ReloadStartSound")
	self.reload_end_sound = get_node("ReloadEndSound")
	self.fire_sound.stream = load(fire_sound_filepath)
	self.reload_start_sound.stream = load(reload_start_sound_filepath)
	self.reload_end_sound.stream = load(reload_end_sound_filepath)
	
	self.bullet_node = parent.get_parent().get_parent()
	
	self.ammo_count = funcref(parent, ammo_count_func_name)
	self.update_ammo_count = funcref(parent, update_ammo_count_func_name)

	._ready()
