class_name Player
extends BaseCharacter

#region Exports
@export_group("Carry & throw")
## Velocity (x = forward, y = up) given to a held object when it's dropped instead of thrown.
@export var DROP_SPEED : Vector2 = Vector2(0.5, 0.2)
## Throw velocity (x = forward, y = up) for a quick tap of the throw key.
@export var press_throw_force: Vector2 = Vector2(8.0, 5.0)
## Throw velocity after holding the key for max_hold_down_carry_time or longer.
@export var max_throw_force: Vector2 = Vector2(16.0, 10.0)
@export var max_hold_down_carry_time: float = 1.0

@export_group("Jump attack")
@export var jump_attack_damage: float = 3.0
@export var jump_attack_fall_speed: float = -10.0
@export_group("")
#endregion

#region Runtime state
## Turned on throughout the Hurt state so one hit doesn't drain health every single frame in a row.
var is_invulnerable: bool = false

var held: Node3D = null
var found_grab: Node3D = null

var hold_down_throw_force: Vector2
#endregion

#region Nodes
@onready var hold_point: Marker3D = $HoldPoint
@onready var hurt_area: Area3D = $Direction/HurtArea3D
@onready var grab_area: Area3D = $Direction/GrabArea3D
@onready var hit_area: Area3D = $Direction/HitArea3D
#endregion


func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Idle)
	hold_down_throw_force = max_throw_force - press_throw_force
	super._ready()


#region Signal handlers
func _on_hurt_area_3d_hurt(_direction: Vector3, damage: float) -> void:
	if is_invulnerable:
		return
	fsm.current_state.take_damage(int(damage))


func _on_grab_area_3d_body_entered(body: Node3D) -> void:
	if body and body and body.has_method("can_be_carried"):
		found_grab = body

func _on_grab_area_3d_body_exited(body: Node3D) -> void:
	if body and body == found_grab:
		found_grab = null
#endregion


#region Combat
func change_damage(damage: float) -> void:
	hit_area.damage = damage

func reset_damage() -> void:
	change_damage(attack_damage)
#endregion
