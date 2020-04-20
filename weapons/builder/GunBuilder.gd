extends Node

# Premade Guns
# Not all settings need to be provided, if they are empty a default value is used

const br = {
	gun_name = "BattleRifle",

	damage = 5.0,

	mag_size = 30,
	reload_time = 2.2,
	ammo_type = AmmoType.MEDIUM,

	fire_range = 20.0,
	bullet_velocity = 10,
	spread = 5.0,
	movement_penalty = 8.0,

	auto = false,
	burst_size = 3,

	fire_rate = 10.0,
}

const pistol = {
	gun_name = "Pistol",

	damage = 5.0,

	mag_size = 8,
	reload_time = 1.4,

	fire_range = 10.0,
	bullet_velocity = 6,
	spread = 2.0,
	movement_penalty = 5.0,

	auto = false,

	fire_rate = 5.0,

	fire_sound_filepath = "res://assets/audio/gun_sounds/pistol.wav",
}

const smg = {
	gun_name = "SMG",

	damage = 5.0,

	mag_size = 25,
	reload_time = 2.2,

	fire_range = 10.0,
	spread = 5.0,
	bullet_velocity = 8,
	movement_penalty = 10.0,

	auto = true,

	fire_rate = 12.0,

	fire_sound_filepath = "res://assets/audio/gun_sounds/smg.wav",
}

const shotgun = {
	gun_name = "Shotgun",

	damage = 5.0,

	mag_size = 5,
	reload_time = 3.0,
	ammo_type = AmmoType.SHOTGUN,

	fire_range = 8.0,
	bullet_velocity = 6,
	spread = 25.0,

	auto = false,

	fire_rate = 1,
	bullets_per_shot = 8,

	fire_sound_filepath = "res://assets/audio/gun_sounds/shotgun.wav",
}

const sniper = {
	gun_name = "Sniper",

	damage = 20.0,

	mag_size = 5,
	reload_time = 2.5,
	ammo_type = AmmoType.MEDIUM,

	fire_range = 50.0,
	bullet_velocity = 25,
	spread = 0.0,
	movement_penalty = 20.0,

	auto = false,

	fire_rate = 0.8,

	fire_sound_filepath = "res://assets/audio/gun_sounds/sniper.wav",
}

# Add gun to data to register it
const data = {
	"BattleRifle": br,
	"Pistol": pistol,
	"SMG": smg,
	"Shotgun": shotgun,
	"Sniper": sniper,
}

const GunConfig = preload("res://weapons/builder/GunConfig.gd")
const GunInstance = preload("res://weapons/prefab/Gun.tscn")

static func build(node, gun_to_build) -> GunInstance:
	var gun_dict = data.get(gun_to_build, pistol)
	var gun_config = GunConfig.new(gun_dict)
	
	var gun = GunInstance.instance()
	gun.setup(node, gun_config)
	node.add_child(gun)
	return gun
