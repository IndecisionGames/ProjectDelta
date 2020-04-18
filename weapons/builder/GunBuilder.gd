extends Node

const br = {
	gun_name = "BattleRifle",

	damage = 5.0,

	mag_size = 30,
	reload_time = 2.2,
	ammo_type = 'medium',

	fire_range = 20.0,
	spread = 5.0,
	bullet_velocity = 20,

	auto = false,
	burst_size = 3,

	fire_rate = 10.0,
	bullets_per_shot = 1,

	bullet_prefab_filepath = "res://objects/bullet/Bullet.tscn",
	
	fire_sound_filepath = "res://assets/audio/gun_sounds/smg.wav",
	reload_start_sound_filepath = "res://assets/audio/gun_sounds/reload_start.wav",
	reload_end_sound_filepath = "res://assets/audio/gun_sounds/reload_end.wav",
}

const pistol = {
	gun_name = "Pistol",

	damage = 5.0,

	mag_size = 8,
	reload_time = 1.4,
	ammo_type = 'light',

	fire_range = 10.0,
	spread = 2.0,
	bullet_velocity = 10,

	auto = false,

	fire_rate = 5.0,
	bullets_per_shot = 1,

	bullet_prefab_filepath = "res://objects/bullet/Bullet.tscn",
	
	fire_sound_filepath = "res://assets/audio/gun_sounds/pistol.wav",
	reload_start_sound_filepath = "res://assets/audio/gun_sounds/reload_start.wav",
	reload_end_sound_filepath = "res://assets/audio/gun_sounds/reload_end.wav",

}

const smg = {
	gun_name = "SMG",

	damage = 5.0,

	mag_size = 25,
	reload_time = 2.2,
	ammo_type = 'light',

	fire_range = 10.0,
	spread = 5.0,
	bullet_velocity = 8,

	auto = true,

	fire_rate = 12.0,
	bullets_per_shot = 1,

	bullet_prefab_filepath = "res://objects/bullet/Bullet.tscn",
	
	fire_sound_filepath = "res://assets/audio/gun_sounds/smg.wav",
	reload_start_sound_filepath = "res://assets/audio/gun_sounds/reload_start.wav",
	reload_end_sound_filepath = "res://assets/audio/gun_sounds/reload_end.wav",
}

const shotgun = {
	gun_name = "Shotgun",

	damage = 5.0,

	mag_size = 5,
	reload_time = 3.0,
	ammo_type = 'shotgun',

	fire_range = 8.0,
	spread = 25.0,
	bullet_velocity = 8,

	auto = false,

	fire_rate = 0.8,
	bullets_per_shot = 8,

	bullet_prefab_filepath = "res://objects/bullet/Bullet.tscn",
	
	fire_sound_filepath = "res://assets/audio/gun_sounds/shotgun.wav",
	reload_start_sound_filepath = "res://assets/audio/gun_sounds/reload_start.wav",
	reload_end_sound_filepath = "res://assets/audio/gun_sounds/reload_end.wav",
}

const sniper = {
	gun_name = "Sniper",

	damage = 20.0,

	mag_size = 5,
	reload_time = 2.5,
	ammo_type = 'medium',

	fire_range = 50.0,
	spread = 0.0,
	bullet_velocity = 50,

	auto = true,

	fire_rate = 0.8,

	bullet_prefab_filepath = "res://objects/bullet/Bullet.tscn",
	
	fire_sound_filepath = "res://assets/audio/gun_sounds/sniper.wav",
	reload_start_sound_filepath = "res://assets/audio/gun_sounds/reload_start.wav",
	reload_end_sound_filepath = "res://assets/audio/gun_sounds/reload_end.wav",
}

const data = {
	"BattleRifle": br,
	"Pistol": pistol,
	"SMG": smg,
	"Shotgun": shotgun,
	"Sniper": sniper,
}

const GunConfig = preload("res://weapons/builder/GunConfig.gd")
const GunInstance = preload("res://weapons/Gun.tscn")

static func build(node, gun_to_build) -> GunInstance:
	var gun_dict = data.get(gun_to_build, pistol)
	var gun_config = GunConfig.new(gun_dict)
	
	var gun = GunInstance.instance()
	gun.setup(node, gun_config)
	node.add_child(gun)
	return gun