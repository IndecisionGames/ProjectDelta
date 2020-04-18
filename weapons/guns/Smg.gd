extends GunBase

func _ready():
	self.gun_name = "SMG"

	self.damage = 5.0

	self.mag_size = 25
	self.reload_time = 2.2

	self.fire_range = 10.0
	self.spread = 5.0
	self.bullet_velocity = 8

	self.auto = true
	self.burst_size = 1

	self.fire_rate = 12.0
	self.bullets_per_shot = 1
	
	self.bullet_prefab = preload("res://objects/bullet/Bullet.tscn")

	self.tween = get_node("Tween")
	self.muzzle_flash = get_node("MuzzleLight")
	self.muzzle_ambient = get_node("MuzzleAmbientLight")
	
	self.fire_sound = get_node("FireSound")
	self.reload_start_sound = get_node("ReloadStartSound")
	self.reload_end_sound = get_node("ReloadEndSound")
	
	# Move to Setup
	self.bullet_node = get_parent().get_parent().get_parent()
	self.ammo_count = funcref(get_parent(), 'get_light_ammo')
	self.update_ammo_count = funcref(get_parent(), 'update_light_ammo')

	._ready()
