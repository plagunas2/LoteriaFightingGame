class_name Player extends CharacterBody3D

const SPEED = 5.0
const MAX_HEALTH = 50

var starting_position = Vector3(0,1,0)

@onready
var animations = $AnimatedSprite3D
@onready
var state_machine = $StateMachine
@onready
var punch_hitbox = $PunchHitBox/HitCollision
@onready
var kick_hitbox = $KickHitBox/HitCollision
@onready
var fall_kick_hitbox1 = $FallKickHitBox1/HitCollision
@onready
var fall_kick_hitbox2 = $FallKickHitBox2/HitCollision

var health = 50
var lives = 1
var power = 0
var id = 0
@export var offline = false

func _ready() -> void:
	
	if not is_multiplayer_authority(): return
	#$Camera3D.current = true
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	self.position = starting_position
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	
func id_set(player_id):
	id = str(player_id)
	print(id)
	$PlayerName.text = "P"+id
	if id=="1":
		starting_position = Vector3(-6,1,0)
		$CanvasLayer/HealthBar.position = Vector2(8, 616)
	elif id=="2":
		starting_position = Vector3(6,1,0)
		$CanvasLayer/HealthBar.position = Vector2(952, 616)
	elif id =="3":
		starting_position = Vector3(-3,1,0)
		$CanvasLayer/HealthBar.position = Vector2(210, 616)
	elif id == "4":
		starting_position = Vector3(3,1,0)
		$CanvasLayer/HealthBar.position = Vector2(752, 616)
	
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

func set_health(new_health):
	health = new_health
	$CanvasLayer/HealthBar.value = health
	if health > MAX_HEALTH:
		health = MAX_HEALTH
	if health < 0:
		health = 0
	print(health)
	if health == 0:
		die()
	
func take_damage(damage):
	set_health(health-damage)

func die():
	lives -= 1
	if lives <= 0:
		self.queue_free()
	else:
		self.position = starting_position
		health = MAX_HEALTH
	
func out_of_bounds():
	$OutOfBoundsTimer.start()

func in_bounds():
	$OutOfBoundsTimer.stop()
	
func in_void():
	set_health(0)

func _on_out_of_bounds_timer_timeout():
	$OutOfBoundsTimer.start()
	set_health(health - 10)
