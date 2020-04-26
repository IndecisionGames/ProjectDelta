extends Node

const DEFAULT_PORT = 31416
const MAX_PEERS    = 8
var   players      = {}
var   player_name

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	start_server()
	
func start_server():
	player_name = 'Server'
	var host = NetworkedMultiplayerENet.new()
	
	var err = host.create_server(DEFAULT_PORT, MAX_PEERS)
	
	if (err!=OK):
		join_server()
		return
		
	get_tree().set_network_peer(host)
	
func join_server():
	player_name = 'Client'
	var host = NetworkedMultiplayerENet.new()
	
	host.create_client('127.0.0.1', DEFAULT_PORT)
	get_tree().set_network_peer(host)
	
func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	print("Player " + str(id) + " connected")
	rpc_id(id, "register_player", player_name)

func _player_disconnected(id):
	players.erase(id) # Erase player from info.
	print("Player " + str(id) + " left")
	update_lobby()

func _connected_ok():
	pass # Only called on clients, not server. Will go unused; not useful here.

func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.

remote func register_player(info):
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	players[id] = info

	update_lobby()
	# Call function to update lobby UI here

func update_lobby():
	print(players)
