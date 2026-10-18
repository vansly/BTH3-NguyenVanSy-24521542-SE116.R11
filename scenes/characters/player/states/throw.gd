extends PlayerState

## The throw pose.

func _enter() -> void:
	#Switch the animation to "throw", stop horizontal movement, set the timer to 0.25 seconds
	obj.change_animation("throw")
	#Doesn't touch the object — it already left the hand in Carry._update()
	timer = 0.15


func _update(_delta: float) -> void:
	if update_timer(_delta):
		done_throwing()

func _exit() -> void:
	pass
	

func done_throwing() -> void:
	obj.held = null
	change_state(fsm.states.idle)
	