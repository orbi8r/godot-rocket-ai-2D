extends RigidBody2D

@onready var ship = $"../Scene/Ship"

@onready var ai_controller_2d = $AIController2D

@onready var thrusterpoint = $Thrusterpoint
@onready var rocket_nozzle = $Thrusterpoint/RocketNozzle
@onready var rocket_body = $RocketBody
@onready var gpu_particles_2d = $Thrusterpoint/GPUParticles2D


@export var thrustforce = 60
var thrustdir = Vector2.ZERO

var is_thrusting = false
var is_dead = false
var ai_input = 0

var landgear_up = true
var landgear_up_animationplayed = false
var landgear_down_animationplayed = false

var prev_velocity_length = 0
var prev_rotation_squared = 0
var prev_xdist_to_ship_squared = 0
var prev_ydist_to_ship_squared = 0

var reward_velocity_change = 0

func rewards(delta):
	
	
	# Reward based on Position on Ship or Out of bounds
	if int(global_position.y) == 28411:
		ai_controller_2d.reward += delta * 50
	elif (global_position.y <= 28450 or global_position.y >= 28400) and (int(global_position.x)-int(ship.global_position.x)-800) <= 2000:
		ai_controller_2d.reward += delta * 15
	elif global_position.y >= 29200:
		ai_controller_2d.reward += delta * (1+prev_rotation_squared) * (1000000-(prev_xdist_to_ship_squared+prev_ydist_to_ship_squared)) / 100000000
	else:
		
		# Reward based on Rotation
		ai_controller_2d.reward -= delta * (rotation**2)
		
		# Reward based on x and y distance to ship
		ai_controller_2d.reward -= delta * ((int(global_position.x)-int(ship.global_position.x)-800)**2) / 100000000
		ai_controller_2d.reward -= delta * ((int(global_position.y)-int(ship.global_position.y)-800)**2) / 1000000000000
		

		# Reward for speed
		#if prev_velocity_length-linear_velocity.length() >= 0:
			#reward_velocity_change = 0.1
		#else:
			#reward_velocity_change = -0.1
		#ai_controller_2d.reward += delta * (prev_velocity_length-linear_velocity.length())# * (reward_velocity_change)
	
	
	prev_xdist_to_ship_squared = (int(global_position.x)-int(ship.global_position.x)-800)**2
	prev_ydist_to_ship_squared = (int(global_position.y)-int(ship.global_position.y)-800)**2
	prev_rotation_squared = rotation ** 2
	prev_velocity_length = linear_velocity.length()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	rewards(delta)
	
	# Human inputs
	if Input.is_action_pressed("Left") and thrusterpoint.rotation < deg_to_rad(60):
		thrusterpoint.rotate(deg_to_rad(0.5))
	elif Input.is_action_pressed("Right") and thrusterpoint.rotation > deg_to_rad(-60):
		thrusterpoint.rotate(deg_to_rad(-0.5))
	elif thrusterpoint.rotation != 0 and thrusterpoint.rotation > 0:
		thrusterpoint.rotate(deg_to_rad(-1))
	elif thrusterpoint.rotation != 0 and thrusterpoint.rotation < 0:
		thrusterpoint.rotate(deg_to_rad(1))
		
	if Input.is_action_just_pressed("thrust"):
		is_thrusting = true
	elif Input.is_action_just_released("thrust"):
		is_thrusting = false
		
	
	# AI inputs
	
	if ai_input == 1 :
		thrusterpoint.rotation = deg_to_rad(0)
	elif ai_input == 2:
		thrusterpoint.rotation = deg_to_rad(-5)
	elif ai_input == 3:
		thrusterpoint.rotation = deg_to_rad(5)
	
	
	# Thrust force
	if is_thrusting:
		gpu_particles_2d.emitting = true
		rocket_nozzle.play("fire")
		thrustdir = thrusterpoint.global_position-rocket_nozzle.global_position
		apply_force(thrustforce*(thrustdir),(thrusterpoint.global_position-global_position))
	else:
		gpu_particles_2d.emitting = false
		rocket_nozzle.play("default")
	
	# Land gear animation
	if global_position.y > 27500:
		landgear_up = true
		landgear_down_animationplayed = false
	elif global_position.y < 27500:
		landgear_up = false
		landgear_up_animationplayed = false
	
	if landgear_up == true and rocket_body.is_playing() == false and landgear_up_animationplayed == false:
		rocket_body.play_backwards("LandingGear")
		landgear_up_animationplayed = true
	elif landgear_up == false and rocket_body.is_playing() == false and landgear_down_animationplayed == false:
		rocket_body.play("LandingGear")
		landgear_down_animationplayed = true
		
	# Is dead? Cuz I am
	if global_position.y > 30000:
		is_dead = true
	else:
		is_dead = false
	
