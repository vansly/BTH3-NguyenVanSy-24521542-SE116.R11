extends FSMState

func _enter() -> void:
	pass


func _exit() -> void:
	pass


func _update(_delta: float) -> void:
	if obj.is_on_floor():
		change_state(fsm.states.idle)
		obj.stop_horizontal()
		if obj.hit_area:
			obj.hit_area.set_collision_mask_value(5, false) #disable collision with enemies' hurt