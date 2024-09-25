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


var reward_velocity_change = 0

func rewards(delta):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	rewards(delta)
	
	# Human inputs and AI
	if (Input.is_action_pressed("Left") or ai_input == 1) and thrusterpoint.rotation < deg_to_rad(60):
		thrusterpoint.rotate(deg_to_rad(1))
	elif (Input.is_action_pressed("Right") or ai_input == 2) and thrusterpoint.rotation > deg_to_rad(-60):
		thrusterpoint.rotate(deg_to_rad(-1))
	elif thrusterpoint.rotation != 0 and thrusterpoint.rotation > 0:
		thrusterpoint.rotate(deg_to_rad(-5))
	elif thrusterpoint.rotation != 0 and thrusterpoint.rotation < 0:
		thrusterpoint.rotate(deg_to_rad(5))
		
	if Input.is_action_just_pressed("thrust"):
		is_thrusting = true
	elif Input.is_action_just_released("thrust"):
		is_thrusting = false
		
	
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

	
