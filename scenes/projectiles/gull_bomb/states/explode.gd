extends FSMState

var is_exploded: bool = false

# Called when the node enters the scene tree for the first time.
func _enter() -> void:
	is_exploded = false
	timer = obj.explosion_wait_time

func _update(_delta):
	if update_timer(_delta):
		if is_exploded:
			obj.explosion_area.set_collision_mask_value(3, false)
			
		else:
			is_exploded = true
			obj.change_animation("explode")
			obj.explosion_area.set_collision_mask_value(3, true)
			timer = obj.explosion_exist_time
	

	