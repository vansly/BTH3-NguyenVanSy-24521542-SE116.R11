extends Node3D

## Plays its animations one after another, waiting `interval` seconds after each one finishes.
## After the last animation in the list, it starts over from the first.

#region Exports
@export_group("Animation cycle")
## The animations to cycle through, in order. Names must match the ones in the AnimationPlayer.
@export var animations: Array[StringName] = [&"spike_up", &"spike_down"]
## Which animation in the list to start with.
@export var initial_animation: StringName = &"spike_down"
## Seconds to wait after an animation finishes before playing the next one.
@export var interval: float = 1.0
@export_group("")
#endregion

#region Runtime state
var _index: int = 0
var _waiting: bool = false
var _wait_timer: float = 0.0
#endregion

#region Nodes
@onready var anim_player: AnimationPlayer = $AnimationPlayer
#endregion


func _ready() -> void:
	if animations.is_empty():
		push_warning("%s: no animations to play" % name)
		return
	_index = animations.find(initial_animation)
	if _index == -1:
		push_warning("%s: '%s' is not in the animations list, starting from the first one" % [name, initial_animation])
		_index = 0
	anim_player.animation_finished.connect(_on_animation_finished)
	_play_current()


func _physics_process(delta: float) -> void:
	if not _waiting:
		return
	_wait_timer -= delta
	if _wait_timer <= 0.0:
		_waiting = false
		# Wrap back to 0 after the last animation
		_index = (_index + 1) % animations.size()
		_play_current()


func _play_current() -> void:
	anim_player.play(animations[_index])


func _on_animation_finished(_anim_name: StringName) -> void:
	_waiting = true
	_wait_timer = interval
