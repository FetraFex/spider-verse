extends Node
class_name VisualController

var player: CharacterBody3D


@onready var animation_tree: AnimationTree = $"../Miles/AnimationTree"
var animation_playback: AnimationNodeStateMachinePlayback

func _ready() -> void:
	animation_playback = animation_tree.get("parameters/playback")



func play_idle() -> void:
	animation_playback.travel("Idle")


func play_run() -> void:
	animation_playback.travel("Run")
