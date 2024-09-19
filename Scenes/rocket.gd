extends RigidBody2D

@onready var thrusterpoint = $Thrusterpoint
@onready var rocket_nozzle = $Thrusterpoint/RocketNozzle
@onready var rocket_body = $RocketBody

@export var thrustforce = 60

var is_thrusting = false

var landgear_up = true
var landgear_up_animationplayed = false
var landgear_down_animationplayed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	# Human inputs
	if Input.is_action_pressed("Left") and thrusterpoint.rotation < deg_to_rad(45):
		thrusterpoint.rotate(deg_to_rad(1))
	elif Input.is_action_pressed("Right") and thrusterpoint.rotation > deg_to_rad(-45):
		thrusterpoint.rotate(deg_to_rad(-1))
		
	if Input.is_action_just_pressed("thrust"):
		is_thrusting = true
	elif Input.is_action_just_released("thrust"):
		is_thrusting = false
		
	
	# Thrust force
	if is_thrusting:
		rocket_nozzle.play("fire")
		apply_force(thrustforce*(thrusterpoint.global_position-rocket_nozzle.global_position),(thrusterpoint.global_position-global_position))
	else:
		rocket_nozzle.play("default")
	
	# Land gear animation
	if global_position.y > -500:
		landgear_up = true
		landgear_down_animationplayed = false
	elif global_position.y < -500:
		landgear_up = false
		landgear_up_animationplayed = false
	
	if landgear_up == true and rocket_body.is_playing() == false and landgear_up_animationplayed == false:
		rocket_body.play_backwards("LandingGear")
		landgear_up_animationplayed = true
	elif landgear_up == false and rocket_body.is_playing() == false and landgear_down_animationplayed == false:
		rocket_body.play("LandingGear")
		landgear_down_animationplayed = true
