class_name BaseObject
extends CharacterBody3D

#region Exports
@export_group("Physics")
@export var gravity: float = 24.0

@export_group("When carried")
## Values the CARRIER switches to while holding this object (heavy things slow the fox down).
@export var alternative_movement_speed: float = 1.0
@export var alternative_animation_speed_scale: float = 0.5
@export var alternative_jump_speed: float = 6.0
@export_group("")
#endregion

#region Runtime state
var carrying_player: Node3D = null
var fsm: FSM = null
var movement_enabled: bool = true
#endregion

#region Nodes
@onready var hit_area: Area3D = $Direction/HitArea3D
#endregion


#region Lifecycle
func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Idle)

func _physics_process(delta: float) -> void:
	if fsm != null:
		fsm._update(delta)
	_update_movement(delta)
#endregion


#region Movement
func _update_movement(delta: float) -> void:
	if not movement_enabled:
		return
	# Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()

func stop_horizontal() -> void:
	velocity.x = 0.0
	velocity.z = 0.0
#endregion


#region Carrying
func can_be_carried() -> bool:

	if fsm == null or not fsm.states.has("carried") or not fsm.states.has("thrown"):
		return false
	return fsm.current_state != fsm.states.carried and fsm.current_state != fsm.states.thrown

func be_picked_up(hold_point: Marker3D) -> void:
	if not hold_point:
		return

	reparent(hold_point)
	carrying_player = hold_point.get_parent()
	if carrying_player.has_method("change_movement_speed"):
		carrying_player.change_movement_speed(alternative_movement_speed)
	if carrying_player.has_method("change_animation_speed_scale"):
		carrying_player.change_animation_speed_scale(alternative_animation_speed_scale)
	if carrying_player.has_method("change_jump_speed"):
		carrying_player.change_jump_speed(alternative_jump_speed)

	carrying_player.add_collision_exception_with(self)
	fsm.change_state(fsm.states.carried)
	movement_enabled = false

func be_thrown() -> void:
	hit_area.set_collision_mask_value(5, true) #enable collision with enemies' hurt

	be_dropped()

func be_dropped() -> void:
	reparent(get_tree().current_scene)
	if carrying_player:
		carrying_player.remove_collision_exception_with(self)
	carrying_player.reset_movement_speed()
	carrying_player.reset_animation_speed_scale()
	carrying_player.reset_jump_speed()
	carrying_player = null
	movement_enabled = true

	fsm.change_state(fsm.states.thrown)
#endregion
