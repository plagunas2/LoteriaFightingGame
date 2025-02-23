extends Control

var my_peer_id
var player
var type

# Called when the node enters the scene tree for the first time.
func _ready():
	my_peer_id = self.name.to_int()

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	if !is_multiplayer_authority():
		self.hide()

func _on_confirm_button_pressed():
	print(type)
	player = load(type).instantiate()
	player.starting_position = Vector3(0,1,0)
	player.name = name
	add_child(player)
	self.hide()

func _on_cigar_guy_button_pressed():
	type = "res://Characters/player_test.tscn"
	$ConfirmButton.show()
