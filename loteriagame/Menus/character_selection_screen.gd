extends Control

var my_peer_id
var player
var type
var num_players = 1
var player_list = []
@export var offline = false
var player_id = 1 #used for offline play, leave at 1 otherwise
@onready var bean_manager = $BeanManager

# Called when the node enters the scene tree for the first time.
func _ready():
	if not offline:
		my_peer_id = self.name.to_int()

func _enter_tree():
	if not offline:
		set_multiplayer_authority(str(name).to_int())
		if !is_multiplayer_authority():
			self.hide()



func _on_confirm_button_pressed():
	print(type)
	player = load(type).instantiate()
	player.starting_position = Vector3(0,1,0)
	player.name = name+str(player_id)
	print(player.name)
	player.id = str(player_id)
	player.offline = true
	player_list.append(player)
	player_id += 1
	if player_id > num_players:
		for p in player_list:
			add_child(p)
		self.hide()
	else:
		bean_manager.create_bean()
		$Label.text = "Choose Character for Player "+str(player_id)
		$ConfirmButton.hide()

func _on_cigar_guy_button_pressed():
	type = "res://Characters/player_test.tscn"
	$ConfirmButton.show()

func set_num_players(num):
	num_players = num
	if num_players > 1:
		$Label.text = "Choose Character for Player 1"
	else:
		$Label.text = "Choose Character"
