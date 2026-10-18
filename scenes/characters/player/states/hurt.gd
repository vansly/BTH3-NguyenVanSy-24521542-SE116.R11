extends PlayerState

const KNOCKBACK_SPEED := 8.0
const HOP_SPEED := 5.0

func _enter() -> void:
	obj.change_animation("hurt")
	obj.is_invulnerable = true
	var push: Vector3 = -obj.forward() * KNOCKBACK_SPEED
	obj.velocity.x = push.x
	obj.velocity.z = push.z
	obj.velocity.y = HOP_SPEED
	timer = 0.5

func _exit() -> void:
	obj.is_invulnerable = false

func _update(delta: float) -> void:
	if update_timer(delta):
		change_state(fsm.states.idle)