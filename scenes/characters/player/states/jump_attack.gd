extends PlayerState

func _enter() -> void:
	obj.change_animation("attack")
	obj.stop_horizontal()
	obj.allow_input = false
	obj.change_damage(obj.jump_attack_damage)
	var forward: Vector3 = obj.forward()
	var push: float = 2.0
	obj.velocity.x = forward.x * push
	obj.velocity.z = forward.z * push
	obj.velocity.y = obj.jump_attack_fall_speed

	_hit_shape().disabled = false


func _exit() -> void:
	_hit_shape().disabled = true
	obj.stop_horizontal() #stop moving forward
	obj.allow_input = true
	obj.reset_damage()
	change_state(fsm.states.idle)


func _update(_delta: float) -> void:
	if obj.is_on_floor():
		change_state(fsm.states.idle)
			

func _hit_shape() -> CollisionShape3D:
	return obj.get_node("Direction/HitArea3D/CollisionShape3D")


