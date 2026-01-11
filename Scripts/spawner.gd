extends Node2D

var enemy = preload("res://Scenes/enemy.tscn")
var started_spawn = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_children().is_empty() && !started_spawn:
		var countdown = randi_range(28,65)
		started_spawn = true
		await get_tree().create_timer(countdown).timeout
		spawn()
		started_spawn = false

func spawn():
	var enemy_inst = enemy.instantiate()
	add_child(enemy_inst)
	enemy_inst.global_position = global_position
	enemy_inst.add_to_group("enemies")
	
