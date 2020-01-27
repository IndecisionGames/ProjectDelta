extends MarginContainer

onready var stamina_bar = $BottomRight/StaminaBar
onready var ammo_text = $BottomRight/Ammo
onready var reloading_progress = $BottomRight/AmmoContainer/Reloading
onready var tween = $Tween

func _ready():
	var player_max_stamina = 100
	stamina_bar.max_value = player_max_stamina
	stamina_bar.value = player_max_stamina

func update_stamina(new_value):
	stamina_bar.value = new_value

func _on_Player_stamina_changed(player_stamina):
	update_stamina(player_stamina)

func _on_Player_ammo_changed(ammo, total_ammo):
#	var ammo_format = "%s/%s"
#	var ammoText = ammo_format % [ammo,total_ammo]
#	ammo_text.text = ammoText
	pass


func _on_Player_reloading(reloading):
	reloading_progress.set_visible(reloading)
