extends Node2D

@onready var rocketmain = $Rocket
@onready var camera_2d = $Rocket/Camera2D
@onready var ship_sprite = $Ship/ShipSprite

var time = 0

@export var rockettscn = preload("res://Scenes/rocket.tscn")
var rocketside
var rocketpos_lastframe
var camzoom = Vector2(1,1)

	
func spawn():
	rocketside = rockettscn.instantiate()
	add_child(rocketside)
	
func reset(roc):
	roc.global_position = Vector2(randi_range(-300, 900), 220)
	roc.rotation = 0
	roc.linear_velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.max_fps = 60
	
	spawn()
	spawn()
	
	for roc in get_tree().get_nodes_in_group("Rockets"):
		reset(roc)
	
	#rocketmain.global_position = Vector2(565, 220)
	rocketpos_lastframe = rocketmain.global_position
	camera_2d.zoom = Vector2(0.7,0.7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	# Camera
	if (rocketpos_lastframe.y-rocketmain.global_position.y)**2 < 1:
		camzoom = Vector2(1,1)
	else:
		camzoom = Vector2(0.2,0.2)
	rocketpos_lastframe = rocketmain.global_position
	camera_2d.zoom = lerp(camera_2d.zoom, camzoom, 0.008)
	
	# Ship animation
	ship_sprite.rotation_degrees = sin(time*5)
	
	# Respawn
	for roc in get_tree().get_nodes_in_group("Rockets"):
		if roc.global_position.x < -15000 or roc.global_position.x > 15000 or roc.global_position.y < -30000 or roc.global_position.y > 500:
			reset(roc)
