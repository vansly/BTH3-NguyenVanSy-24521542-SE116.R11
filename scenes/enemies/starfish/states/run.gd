extends EnemyState

func _enter() -> void:
	obj.change_animation("run")
	obj.enable_check_player_in_sight()

func _update(_delta: float) -> void:
	var step: Vector3 = obj.forward() * obj.current_movement_speed
	obj.velocity.x = step.x
	obj.velocity.z = step.z

	if obj.found_player != null:
		obj.change_direction(BaseCharacter.direction_to(
				obj.global_position, obj.found_player.global_position))
		change_state(fsm.states.attack)
		return

	if obj.is_touch_wall() or (obj.is_on_floor() and obj.is_can_fall()):
		obj.turn_around()