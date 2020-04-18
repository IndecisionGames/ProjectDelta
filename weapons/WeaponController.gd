extends Node2D


const GunBuilder = preload("res://weapons/builder/GunBuilder.gd")

# Stats
export var medium_ammo: int = 60
export var light_ammo: int = 90
export var shotgun_ammo: int = 12

# Assets
onready var br = GunBuilder.build(self, "BattleRifle")
onready var pistol = GunBuilder.build(self, "Pistol")
onready var smg = GunBuilder.build(self, "SMG")
onready var shotgun = GunBuilder.build(self, "Shotgun")
onready var sniper = GunBuilder.build(self, "Sniper")

onready var gunList = [br, pistol, smg, shotgun, sniper]
onready var equipedGun = 0

signal reload
signal ammo_change


func _ready():
	equiped().connect("reload", self, "_on_EquipedGun_reload")
	equiped().connect("ammo_change", self, "_on_EquipedGun_ammo_change")
	equiped().make_active()
	
# Interface (only the following functions should be called)
# - press_trigger
# - release_trigger
# - reload
# - weapon_up
# - weapon_down
# - process <- should be called by weapon user in _process

func process(delta, position, direction):
	equiped().process(delta, position, direction)

func press_trigger():
	equiped().press_trigger()

func release_trigger():
	equiped().release_trigger()

func reload():
	equiped().reload()
	
func weapon_up():
	var new_gun_num = equipedGun + 1
	if new_gun_num == len(gunList):
		new_gun_num = 0
	switch_weapon(new_gun_num)
	
func weapon_down():
	var new_gun_num = equipedGun - 1
	if new_gun_num < 0:
		new_gun_num = len(gunList) - 1
	switch_weapon(new_gun_num)


# Internal
func equiped():
	return gunList[equipedGun]

func switch_weapon(num):
	if num in range(len(gunList)):
		equiped().disconnect("reload", self, "_on_EquipedGun_reload")
		equiped().disconnect("ammo_change", self, "_on_EquipedGun_ammo_change")
		equipedGun = num
		equiped().connect("reload", self, "_on_EquipedGun_reload")
		equiped().connect("ammo_change", self, "_on_EquipedGun_ammo_change")
		equiped().make_active()


# Ammo Controller
func get_ammo_medium() -> int:
	return medium_ammo
func update_ammo_medium(ammo):
	medium_ammo += ammo

func get_ammo_light() -> int:
	return light_ammo
func update_ammo_light(ammo):
	light_ammo += ammo

func get_ammo_shotgun() -> int:
	return shotgun_ammo
func update_ammo_shotgun(ammo):
	shotgun_ammo += ammo


# Signal Relay
func _on_EquipedGun_reload(is_reloading):
	emit_signal("reload", is_reloading)

func _on_EquipedGun_ammo_change(current_mag, reserve_count):
	emit_signal("ammo_change", current_mag, reserve_count)
