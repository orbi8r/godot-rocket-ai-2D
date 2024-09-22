extends AIController2D

@onready var rocket = $".."


func get_obs() -> Dictionary:
	return {"obs": []}


func get_reward() -> float:
	return reward


func get_action_space() -> Dictionary:
	return {
		"thrust": {"size": 2, "action_type": "discrete"},
		"leftright": {"size": 3, "action_type": "discrete"},
	}


func set_action(action) -> void:
	
	if action["thrust"] >= 1:
		rocket.is_thrusting = true
	else:
		rocket.is_thrusting = false
	
	if action["leftright"] == 2:
		rocket.is_left = true
		rocket.is_right = false
	elif action["leftright"] == 0:
		rocket.is_right = true
		rocket.is_left = false
	else:
		rocket.is_left = false
		rocket.is_right = false
