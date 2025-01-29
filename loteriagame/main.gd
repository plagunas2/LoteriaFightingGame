extends Node

@onready var main_menu = $Menu

const PORT = 3000

var enet_peer = ENetMultiplayerPeer.new()
const CharacterSelection = preload("res://Menus/character_selection_screen.tscn")

func _ready():
	main_menu.connect("addressEntered", joinAddressEntered)
	main_menu.connect("hostWorldStart", startHost)
	main_menu.connect("startOfflineGame", startOfflineGame)
	
func startOfflineGame(num_players):
	print("signal received to start offline game")
	main_menu.hide()
	var players = CharacterSelection.instantiate()
	players.offline = true
	players.set_num_players(num_players)
	players.name = "Player"
	add_child(players)
	

func joinAddressEntered(address):
	main_menu.hide()
	enet_peer.create_client(address, PORT)
	multiplayer.multiplayer_peer = enet_peer
	
func startHost():
	main_menu.hide()
	enet_peer.create_server(PORT)
	#multiplayer is the name of the server variable
	multiplayer.multiplayer_peer = enet_peer
	add_player(multiplayer.get_unique_id())
	multiplayer.peer_disconnected.connect(remove_player)
	
	#when a new player connects run add_player
	multiplayer.peer_connected.connect(add_player)

func add_player(peer_id):
	var player = CharacterSelection.instantiate()
	print(peer_id)
	player.name = str(peer_id)
	add_child(player)

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
