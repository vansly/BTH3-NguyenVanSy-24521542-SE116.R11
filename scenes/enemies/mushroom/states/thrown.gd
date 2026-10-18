extends EnemyState

func _enter() -> void:
	obj.change_animation("run")
	obj.anim_player.speed_scale = 1.0


func _exit() -> void:
	pass


func _update(_delta: float) -> void:
	if obj.is_on_floor():
		change_state(fsm.states.run)
		if obj.hit_area:
			obj.hit_area.set_collision_mask_value(5, false) #disable collision with enemies' hurt
			obj.hit_area.set_collision_mask_value(3, true) #re-enable collision with player's hurt
		if obj.hurt_area:
			obj.hurt_area.set_collision_layer_value(5, true) #re-enable self collision layer