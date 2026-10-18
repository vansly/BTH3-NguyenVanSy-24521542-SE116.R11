extends PlayerState


func _enter() -> void:
	obj.change_animation("attack")
	obj.stop_horizontal()
	obj.allow_input = false
	var forward: Vector3 = obj.forward()
	var push: float = 2.0
	obj.velocity.x = forward.x * push
	obj.velocity.z = forward.z * push
		
	_hit_shape().disabled = false


func _exit() -> void:
	_hit_shape().disabled = true
	obj.stop_horizontal() #stop moving forward
	obj.allow_input = true


func _update(_delta: float) -> void:
	pass

func _hit_shape() -> CollisionShape3D:
	return obj.get_node("Direction/HitArea3D/CollisionShape3D")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if fsm.current_state == self and anim_name.begins_with("attack_"):
		change_state(fsm.previous_state)
