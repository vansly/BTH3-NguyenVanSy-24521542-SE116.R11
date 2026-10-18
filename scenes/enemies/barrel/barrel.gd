extends EnemyCharacter

#region Exports
@export_group("Shooting")
## Impulse given to each bullet.
@export var bullet_speed: float = 12.0
@export_group("")
#endregion

#region Nodes
@onready var bullet_factory: Node3DFactory = $Direction/BulletFactory
#endregion


func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Idle)
	super._ready()


#region Shooting
## Spawns a bullet at the muzzle then pushes it along the facing direction.
func fire() -> void:
	var bullet := bullet_factory.create() as RigidBody3D
	bullet.apply_impulse(forward() * bullet_speed)

func fire_direction(direction: Vector3) -> void:
	var bullet := bullet_factory.create() as RigidBody3D
	bullet.apply_impulse(direction * bullet_speed)
#endregion


#region Signal handlers
func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		found_player = body
		_on_player_in_sight(body.global_position)


func _on_body_exited(_body: Node3D) -> void:
	if _body is Player:
		found_player = null
		_on_player_not_in_sight()
#endregion
