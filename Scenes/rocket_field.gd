extends Node2D

@onready var rocketmain = $Rocket
@onready var camera_2d = $Rocket/Camera2D


@export var rockettscn = preload("res://Scenes/rocket.tscn")
var rocketside
var rocketpos_lastframe
var camzoom = Vector2(1,1)

	
func spawnside():
	rocketside = rockettscn.instantiate()
	add_child(rocketside)

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.max_fps = 60
	
	rocketmain.global_position = Vector2(565, 220)
	rocketpos_lastframe = rocketmain.global_position
	camera_2d.zoom = Vector2(0.7,0.7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Camera
	if (rocketpos_lastframe.y-rocketmain.global_position.y)**2 < 1:
		camzoom = Vector2(1,1)
	else:
		camzoom = Vector2(0.2,0.2)
	rocketpos_lastframe = rocketmain.global_position
	camera_2d.zoom = lerp(camera_2d.zoom, camzoom, 0.008)
