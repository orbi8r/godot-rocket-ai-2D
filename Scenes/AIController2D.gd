extends AIController2D

@onready var rocket = $".."
@onready var ship = $"../../Scene/Ship"


func get_obs() -> Dictionary:
	return {"obs": [
		rocket.ai_input,
		rocket.is_dead,
		rocket.global_position.x,
		rocket.rotation,
		rocket.angular_velocity,
		rocket.linear_velocity.y,
		rocket.linear_velocity.x,
		rocket.position.y - ship.global_position.y,
		rocket.position.x - ship.global_position.x - 800,
	]}


func get_reward() -> float:
	return reward


func get_action_space() -> Dictionary:
	return {
		"AIinput": {"size": 4, "action_type": "discrete"},
	}


func set_action(action) -> void:

	
	if action["AIinput"] == 0:
		rocket.ai_input = 0
		rocket.is_thrusting = false
	elif action["AIinput"] == 1:
		rocket.ai_input = 1
		rocket.is_thrusting = true
	elif action["AIinput"] == 2:
		rocket.ai_input = 2
		rocket.is_thrusting = true
	elif action["AIinput"] == 3:
		rocket.ai_input = 3
		rocket.is_thrusting = true
