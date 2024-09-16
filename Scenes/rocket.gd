extends RigidBody2D

@onready var thrusterpoint = $Thrusterpoint
@onready var rocket_nozzle = $Thrusterpoint/RocketNozzle

@export var thrustforce = 200

var is_thrusting = false

var skewtime = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	# Human inputs
	if Input.is_action_pressed("Left") and thrusterpoint.rotation < deg_to_rad(15):
		thrusterpoint.rotate(deg_to_rad(3))
	elif Input.is_action_pressed("Right") and thrusterpoint.rotation > deg_to_rad(-15):
		thrusterpoint.rotate(deg_to_rad(-3))
		
	if Input.is_action_just_pressed("thrust"):
		is_thrusting = true
	elif Input.is_action_just_released("thrust"):
		is_thrusting = false
		
	
	# Thrust force
	if is_thrusting:
		apply_force(thrustforce*(thrusterpoint.global_position-rocket_nozzle.global_position),(thrusterpoint.global_position-global_position))
	
	# Thrust animation
	if is_thrusting:
		skewtime += delta * 100
		rocket_nozzle.skew = sin(skewtime)/15
	else:
		rocket_nozzle.skew = 0
		skewtime = 0
