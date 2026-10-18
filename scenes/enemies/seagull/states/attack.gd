extends FSMState

func _enter() -> void:
	obj.bomb_factory.create() as CharacterBody3D
	change_state(fsm.states.fly)

func _update(_delta):
	pass