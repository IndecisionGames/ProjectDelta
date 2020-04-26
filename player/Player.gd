extends KinematicBody2D

const MOVE_SPEED = 130
const STAMINA_REC_SPEED = 5
var stamina = 100
var current_move_speed

onready var weaponController = get_node("WeaponController")

signal stamina_changed
signal ammo_change
signal reload
signal spread_change

# Networking
var player_id
var control = false

func _ready():
	yield(get_tree(), "idle_frame")
	# get_tree().call_group("zombies", "set_player", self)
	
func _physics_process(delta):
	if control == true:
		var look_vec = get_global_mouse_position() - global_position
		global_rotation = atan2(look_vec.y, look_vec.x)
		
		move(delta)
		
		weaponController.process(delta, get_node("Position2D").get_global_position(), look_vec.normalized(), current_move_speed)
		
		if Input.is_action_just_pressed("change_weapon_up"):
			weaponController.weapon_up()
			rpc_unreliable("n_input", "change_weapon_up", player_id)
			
		if Input.is_action_just_pressed("change_weapon_down"):
			weaponController.weapon_down()
			rpc_unreliable("n_input", "change_weapon_down", player_id)
			
		if Input.is_action_just_pressed("reload"):
			weaponController.reload()
			rpc_unreliable("n_input", "reload", player_id)
			
		if Input.is_action_just_released("shoot"):
			weaponController.release_trigger()
			rpc_unreliable("n_input", "shoot_release", player_id)
		
		if Input.is_action_just_pressed("shoot"):
			weaponController.press_trigger()
			rpc_unreliable("n_input", "shoot", player_id)
		#		var coll = raycast.get_collider()
		#		if raycast.is_colliding() and coll.has_method("kill"):
		#			coll.kill()

func sprint(delta):
	if Input.is_action_pressed("sprint"):
		if stamina <= 0:
			stamina = 0
			emit_signal("stamina_changed", stamina)
			return false
		stamina -= STAMINA_REC_SPEED * 4 * delta
		emit_signal("stamina_changed", stamina)
		return true
	if stamina >= 100:
		stamina = 100
	else:
		stamina += STAMINA_REC_SPEED * delta
	emit_signal("stamina_changed", stamina)
	return false
	
func move(delta):
	var speed = MOVE_SPEED
	
	if sprint(delta):
		speed = MOVE_SPEED * 1.8
		
	var move_vec = Vector2()
	
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
		
	move_vec = move_vec.normalized() * speed
	move_and_slide(move_vec)
	current_move_speed = move_vec.length()
	
	rpc_unreliable("n_move", get_position(), global_rotation, player_id)
	
remote func n_move(pos, rot, pid):
	var root = get_parent()
	var pnode = root.get_node(str(pid))
	
	pnode.set_position(pos)
	pnode.set_global_rotation(rot)
	
remote func n_input(input, pid):
	var root = get_parent()
	var pnode = root.get_node(str(pid))
	
	match input:
		"change_weapon_up":
			pnode.weaponController.weapon_up()
		"change_weapon_down":
			pnode.weaponController.weapon_down()
		"reload":
			pnode.weaponController.reload()
		"shoot":
			pnode.weaponController.release_trigger()
		"shoot_release":
			pnode.weaponController.press_trigger()
	
func process_ghost_player():
	$TorchLight.set_visible(false)
	
func kill():
	get_tree().reload_current_scene()
	
func pickup_ammo(type, amount):
	weaponController.update_ammo(type, amount)

func _on_WeaponController_reload(is_reloading):
	emit_signal("reload", is_reloading)

func _on_WeaponController_ammo_change(current_mag, reserve_count):
	emit_signal("ammo_change", current_mag, reserve_count)
	
func _on_WeaponController_spread_change(new_spread):
	emit_signal("spread_change", new_spread)
