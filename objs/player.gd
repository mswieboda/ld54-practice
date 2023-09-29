extends CharacterBody3D


const SPEED = 7
const JUMP_VELOCITY = 13
const MOUSE_SENSITIVITY = 0.0013
const MAX_VERTICAL_LOOK = 0.3
const FAKE_EXTRA_GRAVITY = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var inventory_keys = 0

func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
  movement(delta)

func _unhandled_input(event):
  unhandled_input_actions(event)
  camera_movement(event)
  mouse_capture(event)

func movement(delta):
  # add the gravity
  if not is_on_floor():
    velocity.y -= gravity * delta * FAKE_EXTRA_GRAVITY

  # handle jump
  if Input.is_action_just_pressed("jump") and is_on_floor():
    velocity.y = JUMP_VELOCITY

  # get input direction and handle the movement/deceleration
  var input_dir = Input.get_vector("left", "right", "up", "down")
  var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
  if direction:
    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)

  move_and_slide()

func camera_movement(event : InputEvent):
  if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
    return

  if event is InputEventMouseMotion:
    rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
    $cam_pivot.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
    $cam_pivot.rotation.x = clamp($cam_pivot.rotation.x, -MAX_VERTICAL_LOOK, MAX_VERTICAL_LOOK)

func mouse_capture(event : InputEvent):
  if event.is_action_pressed("ui_cancel"):
    if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
      Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    else:
      Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func unhandled_input_actions(event : InputEvent):
  if event.is_action_pressed("action"):
    Action.perform()
