extends CharacterBody3D

@onready var animation = $AnimatedSprite3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	$Camera3D.current = true

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if (Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("up")) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		animation.play("Walk")
		velocity.x = direction.x * SPEED
		animation.flip_h = direction.x > 0
		#velocity.z = direction.z * SPEED
	else:
		animation.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	#checkAttack() #this is not quite working
	
func checkAttack():
	if (Input.is_action_just_pressed("attack")) and is_on_floor():
		animation.play("basicPunch")
