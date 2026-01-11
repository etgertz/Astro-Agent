extends Node

var player
var can_move = true
var can_attack = true
var can_be_hit = true
var alive = true
var retry=false
var can_warp = true
var paused = false
var start = true

func _ready() -> void:
	start = false
