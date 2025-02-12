class_name Player extends CharacterBody3D

const SPEED = 5.0

@onready
var animations = $AnimatedSprite3D
@onready
var state_machine = $StateMachine
@onready
var punch_hitbox = $PunchHitBox/HitCollision
@onready
var kick_hitbox = $KickHitBox/HitCollision
#var original_kick_hitbox_pos = kick_hitbox.position.x

var health = 50
var power = 0
var id = 0
@export var offline = false

func _enter_tree():
	if not offline:
		set_multiplayer_authority(str(name).to_int())
	
func _ready() -> void:
	
	if not is_multiplayer_authority() and not offline: return
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
	
#networking funcs

@rpc("any_peer", "call_local")
func sync_movement(new_position: Vector3, new_velocity: Vector3, anim_name: String, flip_h: bool):
	if not is_multiplayer_authority():  # Only non-authority clients update
		global_transform.origin = new_position
		velocity = new_velocity
		animations.play(anim_name)
		animations.flip_h = flip_h
		
@rpc("any_peer", "call_local")
func sync_attack_animation():
	# All clients should see the attack animation
	animations.play("basicPunch")
