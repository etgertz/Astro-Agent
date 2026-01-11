extends CharacterBody2D
class_name enemy


@onready var agent = $NavigationAgent2D
var speed = 52.5
const DETECT_DIST = 2000
var player_detected = false
var direction: Vector2
var health =70
var hit = false
var can_move=true
var has_attacked=false
var alive=true

func _ready() -> void:
	$HealthBar.value=70

func _physics_process(delta: float) -> void:
	if !alive:
		return
	
	if Global.player==null:
		return
	
	if Global.alive==false:
		can_move=false
		Global.can_move=false
		play_attack()
		
	if alive==false:
		return
	
	if player_detected==false:
		$LineOfSight.look_at(Global.player.global_position)
		var collider = $LineOfSight.get_collider()
		if collider && collider==Global.player:
			player_detected = true
		return
	direction = (agent.get_next_path_position() - global_position).normalized()
	
	velocity = velocity.lerp(direction * speed,1)
	if can_move:
		move_and_slide()
		if hit==false:
			animate_run()


func _on_timer_timeout() -> void:
	if Global.player!=null:
		agent.target_position = Global.player.global_position

func animate_run():
	if $RunningAudio.playing==false:
		$RunningAudio.play()
	if direction.x <.5 && direction.x>-.5:
		if direction.y >0:
			$AnimatedSprite2D.play("Run")
		else:
			$AnimatedSprite2D.play("RunBack")
	elif direction.x > 0:
		$AnimatedSprite2D.play("Run_SideR")
	else:
		$AnimatedSprite2D.play("Run_SideL")


func _on_hitbox_area_entered(area: Area2D) -> void:
	if !area.name == "Attack":
		return
	$RunningAudio.stop()
	health-= randi_range(5,10)
	$HealthBar.value = health
	hit = true
	if health<=0:
		die()
		$DeathAudio.play()
		return
	$HitAudio.play()
	speed=0
	velocity = velocity.lerp(direction * -560,1) #knockbck
	hit_animation()
	move_and_slide()
	await get_tree().create_timer(.20).timeout
	hit = false
	speed=50

func die():
	$HealthBar.visible=false
	$AnimatedSprite2D.play("Death")
	$Attack.set_deferred("disabled", true) #stop player from dying to it
	$EnemyHitbox/CollisionShape2D.set_deferred("disabled", true)
	alive=false
	can_move=false
	await get_tree().create_timer(2).timeout
	queue_free()
	
func play_attack():
	if has_attacked:
		return
	else:
		has_attacked=true
	$AttackAudio.play()
	if direction.x <.5 && direction.x>-.5:
		if direction.y >0:
			$AnimatedSprite2D.play("Attack")
		else:
			$AnimatedSprite2D.play("RunBack")
	elif direction.x > 0:
		$AnimatedSprite2D.play("AttackRight")
	else:
		$AnimatedSprite2D.play("Run_SideR")
	
	
func hit_animation():
	if direction.x <.5 && direction.x>-.5:
		if direction.y >0:
			$AnimatedSprite2D.play("Hit")
		else:
			$AnimatedSprite2D.play("HitBack")
	elif direction.x > 0:
		$AnimatedSprite2D.play("HitRight")
	else:
		$AnimatedSprite2D.play("HitLeft")
