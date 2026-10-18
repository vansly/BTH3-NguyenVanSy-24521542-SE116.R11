extends FSMState

func _enter() -> void:
	obj.change_animation("fall")
	timer = obj.max_time_before_explode

func _update(_delta):	
	if update_timer(_delta) or obj.is_on_floor():
		obj.hit_area.set_collision_mask_value(3, false)
		change_state(fsm.states.explode)
