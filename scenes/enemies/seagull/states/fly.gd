extends FSMState

## How close (in meters) counts as "arrived". Must stay bigger than one frame of movement
## (movement_speed / 60), or the seagull overshoots the point and jitters back and forth.
@export_range(0.05, 2.0, 0.05) var arrive_radius: float = 0.1


func _enter() -> void:
	obj.change_animation("fly")
	timer = obj.dropbomb_interval
	# Always start with a fresh destination, also when coming back from Attack
	_pick_new_destination()


func _update(_delta: float) -> void:
	var to_target: Vector3 = obj.current_destination - obj.global_position
	if to_target.length_squared() <= arrive_radius * arrive_radius:
		_pick_new_destination()
		return
	obj.velocity = to_target.normalized() * obj.movement_speed
	if update_timer(_delta):
		change_state(fsm.states.attack)


func _pick_new_destination() -> void:
	var size = obj.destination_list.size()
	obj.current_dest_idx = (obj.current_dest_idx + 1) % size
	obj.current_destination = obj.destination_list[obj.current_dest_idx]
	_face(obj.current_destination)




func _face(target: Vector3) -> void:
	var flat_target := Vector3(target.x, obj.global_position.y, target.z)
	# look_at() errors when the target is (almost) the node's own position
	if obj.global_position.distance_squared_to(flat_target) < 0.0001:
		return
	# true = point the model's front (+Z) at the target. If it flies tail-first, remove it.
	obj.look_at(flat_target, Vector3.UP, true)
