extends CharacterBody3D

#region Exports
@export_group("Physics")
@export var gravity : float = 24.0

@export_group("Timing")
## Falling longer than this explodes the bomb even if it never touches the floor.
@export var max_time_before_explode: float = 5.0
## Fuse: seconds between landing and the explosion.
@export var explosion_wait_time: float = 3.0
## How long the explosion's hit area stays active.
@export var explosion_exist_time: float = 0.2
@export_group("")
#endregion

#region Runtime state
var fsm: FSM = null
var movement_enabled: bool = true
#endregion

#region Nodes
@onready var explosion_area: Area3D = $Direction/ExplosionHitArea3D
@onready var hit_area: Area3D = $Direction/HitArea3D
@onready var anim_sprite: AnimatedSprite3D = $AnimatedSprite3D
#endregion


#region Lifecycle
func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Fall)
	explosion_area.set_collision_mask_value(3, false) #disable collision with player's hurt


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

func stop_move() -> void:
	velocity = Vector3.ZERO

# Stop horizontal movement, keep the falling velocity as-is
func stop_horizontal() -> void:
	velocity.x = 0.0
	velocity.z = 0.0
#endregion


#region Animation
func change_animation(new_animation: String) -> void:
	if anim_sprite.get_animation() != new_animation:
		anim_sprite.play(new_animation)

func _on_animated_sprite_3d_animation_finished() -> void:
	if anim_sprite.get_animation() == "explode":
		queue_free()
#endregion
