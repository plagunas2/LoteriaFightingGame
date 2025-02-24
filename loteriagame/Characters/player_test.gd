class_name Player extends CharacterBody3D

const SPEED = 5.0
const MAX_HEALTH = 50

var starting_position = Vector3(0,1,0)

@onready
var animations = $AnimatedSprite3D
@onready
var state_machine = $StateMachine

var health = 50
var lives = 1
var power = 0

var player_id = 1

func _ready() -> void:
	
	if not is_multiplayer_authority(): return
	#$Camera3D.current = true
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	self.position = starting_position
	state_machine.init(self)
	
#	Set position of health bar
	if player_id == 1:
		$CanvasLayer/HealthBar.position = Vector2(8, 616)
	elif player_id == 2:
		$CanvasLayer/HealthBar.position = Vector2(952, 616)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func set_health(new_health):
	health = new_health
	$CanvasLayer/HealthBar.value = health
	if health > MAX_HEALTH:
		health = 50
	if health < 0:
		health = 0
	print(health)
	if health == 0:
		die()

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
