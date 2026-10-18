extends EnemyState

func _enter() -> void:
	obj.change_animation("run")
	timer = 0.2

func _exit() -> void:
	obj.stop_horizontal()

func _update(delta: float) -> void:
	if update_timer(delta):
		if obj.health <= 0:
			change_state(fsm.states.dead)
		else:
			change_state(fsm.default_state)

func take_damage(_damage_dir: Vector3, _damage: float) -> void:
	pass