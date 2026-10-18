extends CharacterBody3D

#region Exports
@export_group("Flight")
## Box (CollisionShape3D with a BoxShape3D) that random destinations are picked from.
@export var fly_zone: CollisionShape3D
## Node whose Marker3D children are the destinations the seagull cycles through.
@export var destination_container: Node3D
@export var movement_speed: float = 2.5
@export var gravity: float = 24.0

@export_group("Combat")
@export var attack_damage: int = 1
@export var max_health: int = 3
## Seconds of flying between two bomb drops.
@export var dropbomb_interval: float = 3.0
@export_group("")
#endregion

#region Runtime state
var health: int
var fsm: FSM = null
var movement_enabled: bool = true

var destination_list: Array= []
var current_destination: Vector3
var current_dest_idx: int = 0
#endregion

#region Nodes
@onready var bomb_factory: Marker3D = $Direction/BombFactory
@onready var anim_player: AnimationPlayer = $AnimationPlayer
#endregion


#region Lifecycle
func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Fly)
	health = max_health
	create_n_random_destinations(2) #demo

	var destinations = destination_container.get_children()
	for i in destinations:
		destination_list.append(i.position)
	if destination_list.size() == 0:
		push_error("No destinations in the destination container")
	current_destination = destination_list[0]
	self.global_position = current_destination

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
	if anim_player.current_animation != new_animation:
		anim_player.play(new_animation)
#endregion


#region Destinations
func create_n_random_destinations(n: int) -> void:
	destination_list.clear()
	for i in range(n):
		var new_marker = Marker3D.new()
		new_marker.set_position(get_random_position_inside_zone())
		destination_container.add_child(new_marker)


func get_random_position_inside_zone() -> Vector3:
	var box := fly_zone.shape as BoxShape3D
	var size: Vector3 = box.size
	var center = fly_zone.global_position
	var rand_x: float = center.x + randf_range(-size.x / 2, size.x / 2)
	var rand_z: float = center.z + randf_range(-size.z / 2, size.z / 2)
	return Vector3(rand_x, center.y, rand_z)
#endregion
