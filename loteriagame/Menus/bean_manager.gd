extends Node

#@onready var character_selection = get_parent()
@onready var bean = "res://Assets/Cursor/bean.tscn"
@onready var character_button = $"../CigarGuyButton"
#var num_players


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#num_players = character_selection.num_players
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func create_bean():
	var new_bean = load(bean).instantiate()
	add_child(new_bean)
	
	
