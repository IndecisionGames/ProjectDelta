extends Node2D


# Stats
# export var reserve_count: int = 80

# Assets
onready var br = get_node("BR")
onready var pistol = get_node("Pistol")
onready var shotgun = get_node("Shotgun")

onready var gunList = [br, pistol, shotgun]
onready var equipedGun = 0

signal reload
signal ammo_change


func _ready():
	switch_weapon(0)
	
# Only the following functions should be called
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


func equiped():
	return gunList[equipedGun]

func switch_weapon(num):
	if num in range(len(gunList)):
		equipedGun = num
		equiped().connect("reload", self, "_on_EquipedGun_reload")
		equiped().connect("ammo_change", self, "_on_EquipedGun_ammo_change")
		equiped().make_active()

func _on_EquipedGun_reload(is_reloading):
	emit_signal("reload", is_reloading)

func _on_EquipedGun_ammo_change(current_mag, reserve_count):
	emit_signal("ammo_change", current_mag, reserve_count)
