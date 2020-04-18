extends Node2D


onready var pistol = get_node("Gun")

onready var gunList = [pistol]
onready var equipedGun = 0

signal reload
signal ammo_change


func _ready():
	switch_weapon(0)
	pass

func process(delta, position, direction):
	equipedGun().process(delta, position, direction)

func press_trigger():
	equipedGun().press_trigger()

func release_trigger():
	equipedGun().release_trigger()

func reload():
	equipedGun().reload()
	
	
func equipedGun():
	return gunList[equipedGun]
	
	
func switch_weapon(num):
	if num in range(len(gunList)):
		equipedGun = num
		equipedGun().connect("reload", self, "_on_EquipedGun_reload")
		equipedGun().connect("ammo_change", self, "_on_EquipedGun_ammo_change")
		equipedGun().make_active()
		
func _on_EquipedGun_reload(is_reloading):
	emit_signal("reload", is_reloading)

func _on_EquipedGun_ammo_change(current_mag, reserve_count):
	emit_signal("ammo_change", current_mag, reserve_count)
