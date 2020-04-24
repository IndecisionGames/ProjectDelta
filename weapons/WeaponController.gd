extends Node2D

const GunBuilder = preload("res://weapons/builder/GunBuilder.gd")

# Ammo
export var light_ammo: int = 90
export var medium_ammo: int = 60
export var shotgun_ammo: int = 12

# Guns
export var gun_list = ["BattleRifle", "Pistol", "SMG", "Shotgun", "Sniper"]
onready var equipped_guns = []
onready var equipped_gun = 0

signal reload
signal ammo_change
signal weapon_change

func _ready():
	for gun_name in gun_list:
		var gun = GunBuilder.build(self, gun_name)
		equipped_guns.append(gun)
	
	equipped().connect("reload", self, "_on_equippedGun_reload")
	equipped().connect("ammo_change", self, "_on_equippedGun_ammo_change")
	equipped().make_active()
	
# Interface (only the following functions should be called)
# - press_trigger
# - release_trigger
# - reload
# - weapon_up
# - weapon_down
# - process <- should be called by weapon user in _process

func process(delta, position, direction, move_speed):
	equipped().process(delta, position, direction, move_speed)
	emit_signal("weapon_change", equipped().current_spread)

func press_trigger():
	equipped().press_trigger()

func release_trigger():
	equipped().release_trigger()

func reload():
	equipped().reload()
	
func weapon_up():
	var new_gun_num = equipped_gun + 1
	if new_gun_num == len(equipped_guns):
		new_gun_num = 0
	switch_weapon(new_gun_num)
	
func weapon_down():
	var new_gun_num = equipped_gun - 1
	if new_gun_num < 0:
		new_gun_num = len(equipped_guns) - 1
	switch_weapon(new_gun_num)


# Internal
func equipped():
	return equipped_guns[equipped_gun]

func switch_weapon(num):
	if num in range(len(equipped_guns)):
		equipped().disconnect("reload", self, "_on_equippedGun_reload")
		equipped().disconnect("ammo_change", self, "_on_equippedGun_ammo_change")
		equipped_gun = num
		equipped().connect("reload", self, "_on_equippedGun_reload")
		equipped().connect("ammo_change", self, "_on_equippedGun_ammo_change")
		equipped().make_active()


# Ammo Controller
func get_ammo(type) -> int:
	if type == AmmoType.LIGHT:
		return light_ammo
	if type == AmmoType.MEDIUM:
		return medium_ammo
	if type == AmmoType.SHOTGUN:
		return shotgun_ammo
		
	return light_ammo

func update_ammo(type, ammo):
	if type == AmmoType.LIGHT:
		light_ammo += ammo
	if type == AmmoType.MEDIUM:
		medium_ammo += ammo
	if type == AmmoType.SHOTGUN:
		shotgun_ammo += ammo


# Signal Relay
func _on_equippedGun_reload(is_reloading):
	emit_signal("reload", is_reloading)

func _on_equippedGun_ammo_change(current_mag, reserve_count):
	emit_signal("ammo_change", current_mag, reserve_count)
