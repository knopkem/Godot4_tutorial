### Player.gd
extends CharacterBody2D
# Player movement speed
@export var speed = 50

var new_direction = Vector2(0, 1)
var animation

var is_attacking = false

func _physics_process(delta):

	# Get player input (left, right, up/down)
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
		
	#sprinting 
	if Input.is_action_pressed("ui_sprint"):
		speed = 100
	elif Input.is_action_just_released("ui_sprint"):
		speed = 50
		
	# Apply movement
	var movement = speed * direction * delta
	#plays animations
	if !is_attacking:
		player_animations(direction)
		move_and_collide(movement)
		
	if is_attacking and !$AnimatedSprite2D.is_playing():
		is_attacking = false
		
func _input(event):
	if event.is_action_pressed("ui_attack"):
		is_attacking = true
		var animation = "attack_" + returned_direction(new_direction)
		$AnimatedSprite2D.play(animation)

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


func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
	
