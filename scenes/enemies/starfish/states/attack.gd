extends EnemyState

#region Exports
@export_group("Charge")
## Pause before charging, in seconds.
@export var wind_up: float = 0.3
## How long the charge lasts, in seconds.
@export var charge_time: float = 0.9
## Charge speed as a multiple of the starfish's movement speed.
@export var charge_multiplier: float = 3.0
@export_group("")
#endregion

#region Runtime state
var _charging: bool = false
var _charge_direction: Vector3 = Vector3.ZERO
#endregion

func _enter() -> void:
	obj.change_animation("attack")
	obj.stop_horizontal()
	_charge_direction = _aim_at_player()
	obj.disable_check_player_in_sight()
	_charging = false
	timer = wind_up

func _exit() -> void:
	obj.enable_check_player_in_sight()

func _aim_at_player() -> Vector3:
	if obj.found_player == null or not is_instance_valid(obj.found_player):
		return obj.forward()
	var aim: Vector3 = obj.found_player.global_position - obj.global_position
	aim.y = 0.0
	if aim.length_squared() < 0.0001:
		return obj.forward()
	return aim.normalized()

func _update(delta: float) -> void:
	if not _charging:
		if update_timer(delta):
			_charging = true
			timer = charge_time
		return
	var step: Vector3 = _charge_direction * obj.current_movement_speed * charge_multiplier
	obj.velocity.x = step.x
	obj.velocity.z = step.z
	if obj.is_touch_wall() or (obj.is_on_floor() and obj.is_can_fall()):
		change_state(fsm.states.run)
		return
	if update_timer(delta):
		change_state(fsm.states.run)