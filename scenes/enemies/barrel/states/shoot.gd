extends EnemyState

#region Exports
@export_group("Burst")
## Volleys fired per Shoot state (each volley is a 3-bullet cone).
@export var shot_per_time: int = 3
@export var delay_between_shots: float = 0.2
@export_group("")
#endregion

#region Runtime state
var _next_shot_fire_timer: float = 0.0
var shot_fired: int = 0
var start_shooting: bool = false
#endregion


func _enter() -> void:
	shot_fired = 0
	obj.change_animation("shoot")
	obj.stop_move()
	start_shooting = false
	# Length taken from the animation itself - see the same kind of note in the fox's Attack state.
	timer = obj.anim_player.get_animation("shoot_%s" % obj.direction).length
	

func _update(delta: float) -> void:
	if update_timer(delta):
		start_shooting = true
	if not start_shooting:
		return
	
	if shot_fired >= shot_per_time:
		
		change_state(fsm.states.idle)
		return
	
	_next_shot_fire_timer += delta
	if _next_shot_fire_timer >= delay_between_shots:
		fire_like_cone()
		_next_shot_fire_timer -= delay_between_shots
		shot_fired += 1
		
func fire_like_cone()->void:
	var forward: Vector3 = obj.forward()
	var second: = forward.rotated(Vector3.UP, deg_to_rad(20))
	var third = forward.rotated(Vector3.UP, deg_to_rad(-20))
	obj.fire_direction(forward)
	obj.fire_direction(second)
	obj.fire_direction(third)
	
	