extends KinematicBody2D

onready var tween = $Tween
const MOVE_SPEED = 130
const STAMINA_REC_SPEED = 5
const BULLET_SCENE = preload("res://objects/bullet/Bullet.tscn")
const MAG_SIZE = 8
var stamina = 100
var ammo = 8
var reloading = false
var total_ammo = 36

onready var muzzle_flash = get_node("MuzzleLight")
onready var muzzle_ambient = get_node("MuzzleAmbientLight")
onready var torch = get_node("TorchLight")
onready var torch_ambient = get_node("TorchLightAmbient")

signal stamina_changed
signal ammo_changed
signal reloading

func _ready():
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)
	emit_signal("ammo_changed", ammo, total_ammo)

func _physics_process(delta):
	move(delta)
	
	var look_vec = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vec.y, look_vec.x)
	
	if Input.is_action_just_pressed("torch"):
		toggle_torch()
		
	if Input.is_action_just_pressed("reload"):
		trigger_reload()
	
	if Input.is_action_just_pressed("shoot"):
		if ammo > 0 and !reloading:
			ammo -= 1
			emit_signal("ammo_changed", ammo, total_ammo)
			var b = BULLET_SCENE.instance()
			b.position(look_vec)
			get_parent().add_child(b)
			b.set_position(get_node("Position2D").get_global_position())
			toggle_muzzle_flash()
			tween.interpolate_callback(self, 0.05, "toggle_muzzle_flash")
			tween.start()
	#		var coll = raycast.get_collider()
	#		if raycast.is_colliding() and coll.has_method("kill"):
	#			coll.kill()
		if ammo == 0 and !reloading:
			trigger_reload()
	
func trigger_reload():
	if !reloading and ammo < MAG_SIZE and total_ammo > 0:
		reloading = true
		emit_signal("reloading", reloading)
		tween.interpolate_callback(self, 2, "reload")
		tween.start()
	
func reload():
	reloading = false
	emit_signal("reloading", reloading)
	if total_ammo + ammo >= MAG_SIZE:
		total_ammo -= (MAG_SIZE - ammo)
		ammo = MAG_SIZE
	else:
		ammo += total_ammo
		total_ammo = 0 
	emit_signal("ammo_changed", ammo, total_ammo)

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
	move_vec = move_vec.normalized()
	move_and_slide(move_vec * speed)

func toggle_muzzle_flash():
	muzzle_flash.set_visible(!muzzle_flash.is_visible())
	muzzle_ambient.set_visible(!muzzle_ambient.is_visible())
	
func toggle_torch():
	torch.set_visible(!torch.is_visible())
	torch_ambient.set_visible(!torch_ambient.is_visible())
	
func kill():
	get_tree().reload_current_scene()
