extends Node2D

@onready var rockets_left_text = $UI/BoxContainer/RocketsLeft
@onready var generation = $UI/BoxContainer/Generation
@onready var height = $UI/BoxContainer/Height
@onready var velocity = $UI/BoxContainer/Velocity
@onready var time_left = $UI/BoxContainer/TimeLeft
@onready var landings = $UI/BoxContainer/SuccessfulLandings


@onready var ship_sprite = $Scene/Ship/ShipSprite
@onready var ship = $Scene/Ship
@onready var anchor_icon = $Scene/AnchorIcon


var time = 0
var rocketmain
var selected_rocket = 0
@export var number_of_rockets = 1
var alive_rocket = []

var camera_2d

var gen = 0
var landed = 0
var rockets_left = 0

@export var rockettscn = preload("res://Scenes/rocket.tscn")
@export var camera = preload("res://Scenes/camera.tscn")
var rocketpos_lastframe = Vector2(0,0)
var camzoom = Vector2(1,1)

	
func spawn():
	var rocketside = rockettscn.instantiate()
	add_child(rocketside)


func cam():
	for roc in get_tree().get_nodes_in_group("Rockets"):
		if (roc.get_child(4) == null):
			var newcam = camera.instantiate()
			roc.add_child(newcam)
			
	for roc in get_tree().get_nodes_in_group("Rockets"):
		if (roc.get_child(4) != null):
			if roc == rocketmain:
				camera_2d = get_node_or_null(roc.get_child(4).get_path())
				get_node_or_null(roc.get_child(4).get_path()).enabled = true
			else:
				get_node_or_null(roc.get_child(4).get_path()).enabled = false
		else:
			var newcam = camera.instantiate()
			roc.add_child(newcam)
	
	
	if (rocketpos_lastframe.y-rocketmain.global_position.y)**2 < 1:
		camzoom = Vector2(1,1)
	else:
		camzoom = Vector2(0.2,0.2)
	rocketpos_lastframe = rocketmain.global_position
	camera_2d.zoom = lerp(camera_2d.zoom, camzoom, 0.008)


func reset():
	
	for i in number_of_rockets:
		alive_rocket[i-1] = 1
	
	ship.global_position.x = randi_range(-13000,13000)
	
	for roc in get_tree().get_nodes_in_group("Rockets"):
		roc.global_position = Vector2(randi_range(-10000, 10000), randi_range(1000, -500))
		roc.rotation = 0
		roc.linear_velocity = Vector2(0,0)
	
	selected_rocket = 0
	rocketmain = get_tree().get_nodes_in_group("Rockets")[selected_rocket]
	
	landed = round(landed)
	time = 0
	gen += 1

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.max_fps = 60
	for i in number_of_rockets:
		spawn()
	
	for i in number_of_rockets:
		alive_rocket.append(0)
	reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	# Setting Main rocket
	rockets_left = alive_rocket.count(1)
	if selected_rocket >= number_of_rockets:
		selected_rocket = 0
	rocketmain = get_tree().get_nodes_in_group("Rockets")[selected_rocket]
	
	# Setting Camera
	cam()
	
	ship_sprite.rotation_degrees = sin(time*5)
	
	# Anchor Icon
	anchor_icon.global_position = rocketmain.global_position
	var rocket_to_ship_vector = rocketmain.global_position - ship.global_position - Vector2(800,800)
	anchor_icon.rotation = (rocket_to_ship_vector).angle() + deg_to_rad(270)
	if (rocket_to_ship_vector.x**2 + rocket_to_ship_vector.y**2) < 1300000:
		anchor_icon.visible = false
	else:
		anchor_icon.visible = true
	
	# Respawn
	for rocindex in range(0,number_of_rockets):
		var roc = get_tree().get_nodes_in_group("Rockets")[rocindex]
		
		if alive_rocket[rocindex] == 0:
			roc.global_position = Vector2(0,31000)
			roc.linear_velocity = Vector2.ZERO
			if selected_rocket >= number_of_rockets:
				selected_rocket = 0
			if rocindex == selected_rocket:
				selected_rocket += 1
			continue
		
		if roc.global_position.x < -15000 or roc.global_position.x > 15000 or roc.global_position.y < -2000 or roc.global_position.y > 28500 :
			alive_rocket[rocindex] = 0
			break
		
		if int(roc.global_position.y) == 28411 and int(time) == 49:
			landed += delta
	if alive_rocket.count(0) == number_of_rockets or time > 50:
		reset()
	
	
	# text elements for UI
	rockets_left_text.text = "Rockets Left: " + str(rockets_left)
	generation.text = "Gen: " + str(gen)
	height.text = "Height: " + str(28411 -int(rocketmain.global_position.y))
	velocity.text = "Velocity: " + str((int(rocketmain.linear_velocity.y)**2 + int(rocketmain.linear_velocity.x)**2)/1000)
	time_left.text = "Time Left: " + str(int(50 - time))
	landings.text = "Landings: " + str(round(landed))




func _on_prev_pressed():
	while(true):
		if selected_rocket == 0:
			selected_rocket = number_of_rockets - 1
		else:
			selected_rocket -= 1
		
		if alive_rocket[selected_rocket] == 1:
			break


func _on_next_pressed():
	while(true):
		if selected_rocket == number_of_rockets - 1:
			selected_rocket = 0
		else:
			selected_rocket += 1
			
		if alive_rocket[selected_rocket] == 1:
			break

