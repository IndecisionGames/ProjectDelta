extends MarginContainer

onready var stamina_bar = get_node("BottomRight/StaminaBar")
onready var ammo_text = get_node("BottomRight/AmmoContainer/Ammo")
onready var reloading_progress = get_node("BottomRight/AmmoContainer/Reloading")
onready var tween = get_node("Tween")

func _ready():
	print("test")
	var player_max_stamina = 100
	stamina_bar.max_value = player_max_stamina
	stamina_bar.value = player_max_stamina
	reloading_progress.set_visible(false)

func update_stamina(new_value):
	stamina_bar.value = new_value

func _on_Player_stamina_changed(player_stamina):
	update_stamina(player_stamina)

func _on_Player_ammo_change(current_mag, reserve_count):
	var ammo_format = "%s/%s"
	var ammoText = ammo_format % [current_mag, reserve_count]
	set_ammo_text(ammoText)

func set_ammo_text(ammo_count):
	ammo_text.text = ammo_count
	
func _on_Player_reload(is_reloading):
	reloading_progress.set_visible(is_reloading)
