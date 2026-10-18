extends RigidBody3D

@export var lifetime: float = 4.0

func _ready() -> void:
	$HitArea3D.hitted.connect(_on_hitted)
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _on_hitted(_area: Area3D) -> void:
	queue_free()
