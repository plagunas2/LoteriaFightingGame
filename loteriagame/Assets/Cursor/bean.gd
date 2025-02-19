extends Control

var mouse_position
var card_selected
@onready var button = $"../CigarGuyButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_selected = false
	#print(str(is_connected("_on_cigar_guy_button_pressed")))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !card_selected:
		mouse_position = get_global_mouse_position()
		position = mouse_position


func _on_cigar_guy_button_pressed() -> void:
	card_selected = true
