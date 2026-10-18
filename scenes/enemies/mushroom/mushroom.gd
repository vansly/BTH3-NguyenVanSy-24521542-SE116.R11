extends EnemyCharacter

class_name Mushroom

#region Exports
@export_group("When carried")
## Values the CARRIER switches to while holding this mushroom.
@export var alternative_movement_speed: float = 1.0
@export var alternative_animation_speed_scale: float = 0.5
@export var alternative_jump_speed: float = 6.0
@export_group("")
#endregion

#region Runtime state
var carrying_player: Node3D = null
#endregion

#region Nodes
@onready var hit_area: Area3D = $Direction/HitArea3D
@onready var hurt_area: Area3D = $Direction/HurtArea3D
#endregion


func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Run)
	super._ready()


#region Carrying
func be_picked_up(hold_point: Marker3D) -> void:
	if not hold_point:
		return
	if hit_area:
		hit_area.set_collision_mask_value(3, false) #disable collision with player's hurt

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
	hurt_area.set_collision_layer_value(5, false) #disable self collision layer first
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
