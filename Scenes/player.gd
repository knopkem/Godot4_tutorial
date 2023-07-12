### Player.gd
extends CharacterBody2D
# Player movement speed
@export var speed = 50

var new_direction = Vector2(0, 1)
var animation

func _physics_process(delta):

	# Get player input (left, right, up/down)
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	# Apply movement
	var movement = speed * direction * delta
	# moves our player around, whilst enforcing collisions so that they come to a stop 
	# when colliding with another object.
	move_and_collide(movement)
	#plays animations
	player_animations(direction)

func player_animations(direction: Vector2):
	#Vector2.ZERO is the shorthand for writing Vector2(0, 0).
	if direction != Vector2.ZERO:
		#update our direction with the new_direction
		new_direction = direction
		#play walk animation because we are moving
		animation = "walk_" + returned_direction(new_direction)
		$AnimatedSprite2D.play(animation)
	else:
		#play idle animation because we are still
		animation = "idle_" + returned_direction(new_direction)
		$AnimatedSprite2D.play(animation)

#returns the animation direction
func returned_direction(direction : Vector2):
	#it normalizes the direction vector to make sure it has length 1 (1, or -1 up, down, left, and right) 
	var normalized_direction = direction.normalized()
	if normalized_direction.y >= 1:
		return "down"
	elif normalized_direction.y <= -1:
		return "up"
	elif normalized_direction.x >= 1:
		#(right)
		$AnimatedSprite2D.flip_h = false
		return "side"
	elif normalized_direction.x <= -1:
		#flip the animation for reusability (left)
		$AnimatedSprite2D.flip_h = true
		return "side"
	#default value emptz
	return ""
