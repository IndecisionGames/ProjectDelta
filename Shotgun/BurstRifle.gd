extends GunBase

func _ready():
	self.gun_name = "BR"

	self.damage = 5.0

	self.mag_size = 30
	self.reload_time = 2.2

	self.fire_range = 20.0
	self.spread = 5.0
	self.bullet_velocity = 10

	self.auto = false
	self.burst_size = 3

	self.fire_rate = 10.0
	self.bullets_per_shot = 1

	self.reserve_count = 90
	
	self.bullet_prefab = preload("res://objects/bullet/Bullet.tscn")
	self.bullet_node = get_parent().get_parent().get_parent()

	self.tween = get_node("Tween")
	self.muzzle_flash = get_node("MuzzleLight")
	self.muzzle_ambient = get_node("MuzzleAmbientLight")
	
	self.fire_sound = get_node("FireSound")
	self.reload_start_sound = get_node("ReloadStartSound")
	self.reload_end_sound = get_node("ReloadEndSound")

	._ready()