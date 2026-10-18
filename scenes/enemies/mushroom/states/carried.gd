extends EnemyState

func _enter() -> void:
	pass


func _update(_delta: float) ->void:
	#update mushroom direction corresponding to player direction
	obj.change_direction(obj.carrying_player.direction)

func _exit() -> void:
	pass
