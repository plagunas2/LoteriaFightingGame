class_name Player extends CharacterBody3D

const SPEED = 5.0

@onready
var animations = $AnimatedSprite3D
@onready
var state_machine = $StateMachine

var health = 50
var power = 0

func _ready() -> void:
	
	if not is_multiplayer_authority(): return
	$Camera3D.current = true
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
