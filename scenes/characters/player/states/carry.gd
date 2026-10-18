extends PlayerState

## Currently carrying something overhead.
var grab_tween: Tween = null

var current_throw_force: Vector2 = Vector2.ZERO

var is_holding_throw: bool = false
var hold_time: float = 0.0

func _enter() -> void:
	#Call obj.held.be_picked_up(obj.hold_point): the object becomes a child of HoldPoint but stays
	#where it was
	#Tween the object's position to Vector3.ZERO over 0.18 seconds to lift it from the ground into
	#hand
	#While lifting, the fox stands still and ignores input
	
	obj.movement_enabled = false #disable gravity and movement while lifting
	
	obj.change_animation("carry")
	obj.stop_move()
	obj.held.be_picked_up(obj.hold_point)
	
	grab_tween = create_tween()
	grab_tween.tween_property(obj.held, "position", Vector3.ZERO, 0.18)
	timer = 0.18
	current_throw_force = Vector2.ZERO

func _exit() -> void:
	obj.held = null
	
func drop_carry() -> void:
	#Stop the lift tween if it's still running
	if grab_tween != null and grab_tween.is_running():
		grab_tween.stop()
	#If the hand is still full (got hit, died...), drop the object right where it is:
	var pop: Vector3 = obj.forward() * obj.DROP_SPEED.x
	obj.held.velocity = Vector3(pop.x, obj.DROP_SPEED.y, pop.z)
	obj.held.be_dropped()
	obj.held = null

func throw_carry(throw_force: Vector2) -> void:
	if grab_tween != null and grab_tween.is_running():
		return
	var push: Vector3 = obj.forward() * throw_force.x
	obj.held.velocity.x = push.x
	obj.held.velocity.z = push.z
	obj.held.velocity.y = throw_force.y
	obj.held.be_thrown()
	change_state(fsm.states.throw)

func take_damage(damage: int = 1) -> void:
	drop_carry()
	obj.take_damage(damage)
	if obj.health <= 0:
		change_state(fsm.states.dead)
	else:
		change_state(fsm.states.hurt)

func control_moving() -> bool:
	#create inherited func to prevent changing state
	var is_moving := move_by_input()
	return is_moving

func control_jump() -> bool:
	if Input.is_action_just_pressed("jump"):
		obj.jump()
		return true
	return false

func _update(_delta: float) -> void:
	if update_timer(_delta):
		obj.movement_enabled = true #unlock movement
	
	var is_moving: bool = control_moving()
	control_jump()
	if not is_moving:
		obj.change_animation("carry_idle")
	else:
		obj.change_animation("carry")
	#do not allow attacking while carrying
	if Input.is_action_just_pressed("carry") and obj.held != null:
		is_holding_throw = true
		current_throw_force += obj.press_throw_force
		hold_time = 0.0
	if Input.is_action_pressed("carry") and obj.held != null:
		hold_time += _delta
	
	if Input.is_action_just_released("carry") and obj.held != null:
		var charge: float = clampf(hold_time / obj.max_hold_down_carry_time, 0.0, 1.0)
		var additional_throw_force = charge * obj.hold_down_throw_force
		current_throw_force += additional_throw_force
		is_holding_throw = false
		throw_carry(current_throw_force)
