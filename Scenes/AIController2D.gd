extends AIController2D

@onready var rocket = $".."


func get_obs() -> Dictionary:
	return {"obs": [
		rocket.ai_input,
		rocket.is_thrusting,
		rocket.is_dead,
		rocket.global_position.x,
		rocket.rotation,
		rocket.angular_velocity,
		rocket.linear_velocity.y,
		rocket.linear_velocity.x,
	]}


func get_reward() -> float:
	return reward


func get_action_space() -> Dictionary:
	return {
		"Thrust": {"size": 2, "action_type": "discrete"},
		"AIinput": {"size": 3, "action_type": "discrete"},
	}


func set_action(action) -> void:

	
	if action["Thrust"] == 0:
		rocket.is_thrusting = false
	elif action["Thrust"] == 1:
		rocket.is_thrusting = true
		
	rocket.ai_input = action["AIinput"]
