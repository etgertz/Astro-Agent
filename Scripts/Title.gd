extends Node2D
var r1 = randf_range(-.01,.05)
var r2 = randf_range(-.01,.05)
var r3 = randf_range(-.01,.05)
var r4 = randf_range(-.01,.05)
var r5 = randf_range(-.01,.05)
var r6 = randf_range(-.01,.05)
var p1
var p2
var p3
var p4
var p5
var p6
var d1 = Vector2(randf_range(-1,1),randf_range(-1,1))
var d2 = Vector2(randf_range(-1,1),randf_range(-1,1))
var d3 = Vector2(randf_range(-1,1),randf_range(-1,1))
var d4 = Vector2(randf_range(-1,1),randf_range(-1,1))
var d5 = Vector2(randf_range(-1,1),randf_range(-1,1))
var d6 = Vector2(randf_range(-1,1),randf_range(-1,1))
var s1 = randi_range(30,150)
var s2 = randi_range(30,150)
var s3 = randi_range(30,150)
var s4 = randi_range(30,150)
var s5 = randi_range(30,150)
var s6 = randi_range(30,150)
var screen_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.start:
		$CanvasLayer.visible = false
	screen_size = get_viewport_rect().size
	$CanvasLayer/Title.global_position = Vector2(screen_size.x/2,screen_size.y/2-100)
	$"CanvasLayer/Start Game".global_position = Vector2(screen_size.x/2-110,screen_size.y/2+100)
	p1 = $CanvasLayer/Green
	p2 = $CanvasLayer/Dark
	p3 = $CanvasLayer/Orange
	p4 = $CanvasLayer/Pink
	p5 = $CanvasLayer/Yellow
	p6 = $CanvasLayer/Blue
	p1.global_position = Vector2(randi_range(0,screen_size.x),randi_range(0,screen_size.y))
	p2.global_position = Vector2(randi_range(0,screen_size.x),randi_range(0,screen_size.y))
	p3.global_position = Vector2(randi_range(0,screen_size.x),randi_range(0,screen_size.y))
	p4.global_position = Vector2(randi_range(0,screen_size.x),randi_range(0,screen_size.y))
	p5.global_position = Vector2(randi_range(0,screen_size.x),randi_range(0,screen_size.y))
	p6.global_position = Vector2(randi_range(0,screen_size.x),randi_range(0,screen_size.y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		_move_and_wrap(p1,delta,s1,d1,r1)
		_move_and_wrap(p2,delta,s2,d2,r2)
		_move_and_wrap(p3,delta,s3,d3,r3)
		_move_and_wrap(p4,delta,s4,d4,r4)
		_move_and_wrap(p5,delta,s5,d5,r5)
		_move_and_wrap(p6,delta,s6,d6,r6)
		if Input.is_action_just_pressed("Go"):
			Global.start = true
			$CanvasLayer.visible = false

func _move_and_wrap(sprite: Node2D, delta, speed, direction, rotation):
	# Move using direction + speed
	sprite.global_position += direction.normalized() * speed * delta
	sprite.rotate(rotation)
	# Wrap using fposmod
	sprite.global_position.x = fposmod(sprite.global_position.x, screen_size.x+50)
	sprite.global_position.y = fposmod(sprite.global_position.y, screen_size.y+50)



func _on_start_game_pressed() -> void:
	Global.start = true
	$CanvasLayer.visible = false
