extends EnemyState


func _enter() -> void:
	obj.change_animation("run")


func _update(_delta: float) ->void:
	var step: Vector3 = obj.forward() * obj.current_movement_speed
	obj.velocity.x  = step.x
	obj.velocity.z  = step.z
	if _should_turn_around():
		obj.turn_around()
	


func _should_turn_around() ->bool:
	if obj.is_touch_wall():
		return true
	if obj.is_on_floor() and obj.is_can_fall():
		return true
	return false
