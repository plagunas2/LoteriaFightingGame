extends Control

var my_peer_id
var player
var type
var num_players = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	my_peer_id = self.name.to_int()

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	if !is_multiplayer_authority():
		self.hide()

func _on_confirm_button_pressed():
	print(type)
	for i in range(0,num_players):
		if num_players > 1:
			$Label.text = "Choose Character for Player "+str(i+1)
		player = load(type).instantiate()
		player.position = Vector3(0,5,0)
		player.name = name+str(i+1)
		print(player.name)
		player.id = str(i+1)
		add_child(player)
	self.hide()

func _on_cigar_guy_button_pressed():
	type = "res://Characters/player_1.tscn"
	$ConfirmButton.show()

func set_num_players(num):
	num_players = num
	
func set_player_id(id):
	$Label.text = "Choose Character for player "+id
