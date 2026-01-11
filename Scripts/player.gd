extends CharacterBody2D
class_name player

const SPEED = 52.0
var input: Vector2	
var last_facing: Vector2 = Vector2(0,1)
var dash_distance = 100
var warps = 3
var is_dead=false

func _ready() -> void:
	$UI/RechargeBar.value=41
	$UI/Charges.frame = 3
	$CoolDownBar.value=0
	Global.player = self
	disable_attack_hitboxes()

func _process(delta):
	if !Global.start:
		$UI/HealthBar.visible = false
		$UI/Charges.visible = false
		$UI/RechargeBar.visible = false
		return
	else:
		$UI/HealthBar.visible = true
		$UI/Charges.visible = true
		$UI/RechargeBar.visible = true
	
	if Global.alive==false:
		$UI/HealthBar.play("Dead")
		if is_dead==false: #prevent playing animation again
			die()
			is_dead=true
		return
	
	if(Input.is_action_just_pressed("Warp") && Global.can_warp):
		warp()
	if(Input.is_action_just_pressed("attack") && Global.can_attack):
		attack()
	
	#Player movement
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	var playerInput = input.normalized()
	
	velocity = playerInput*SPEED
	if (Global.can_move):
		move_and_slide()
	
	if !velocity.x && !velocity.y: play_Idle_Animation()
	else: 
		last_facing = playerInput
		play_Run_Animation()
	
	if warps<3:
		$UI/RechargeBar.value = ($WarpTimer.wait_time - $WarpTimer.time_left)*6.8*41/48
	else:
		$UI/RechargeBar.value = 41
	
	if Global.can_attack==false:
		$CoolDownBar.value = round(($AttackCoolDown.wait_time - $AttackCoolDown.time_left)/.3*100)
	
func play_Idle_Animation():
	$RunningAudio.stop()
	if last_facing.x == 0:
		if last_facing.y >0:
			$AnimatedSprite2D.play("Idle")
		else:
			$AnimatedSprite2D.play("IdleBack")
	elif last_facing.x > 0:
		$AnimatedSprite2D.play("IdleRight")
	else:
		$AnimatedSprite2D.play("IdleLeft")
	
func play_Run_Animation():
	if $RunningAudio.playing == false:
		$RunningAudio.play()
	if last_facing.x == 0:
		$CoolDownBar.position.y=-10
		if last_facing.y >0:
			$AnimatedSprite2D.play("Run")
		else:
			$AnimatedSprite2D.play("RunBack")
	elif last_facing.x > 0:
		$CoolDownBar.position.y=-11
		$AnimatedSprite2D.play("RunRight")
	else:
		$CoolDownBar.position.y=-11
		$AnimatedSprite2D.play("RunLeft")
		
func warp():
	Global.can_be_hit = false #gives player some immunity
	Global.can_warp = false
	if ($WarpTimer.is_stopped()):
		$WarpTimer.start()
	$PortalAudio.play()
	$PortalStart/Animation.play("Green")
	$UI/RechargeBar.value=1
	var dash_vector = last_facing*dash_distance
	warps-=1
	
	$UI/Charges.frame = warps #update ui
	await get_tree().create_timer(.2).timeout
	Global.can_move = false
	
	velocity = dash_vector*dash_distance
	move_and_slide()
	
	await get_tree().create_timer(.25).timeout
	Global.can_move = true
	Global.can_be_hit = true
	if (warps>0):
		Global.can_warp = true

func attack():
	$AttackAudio.play()
	Global.can_attack = false
	$AttackCoolDown.start()
	var rot=0
	if last_facing.x == 0:
		if last_facing.y >0:
			$Attack/AttackHitbox2.disabled = false
			rot=PI/2
		else:
			$Attack/AttackHitbox4.disabled = false
			rot=3*PI/2
	elif last_facing.x > 0:
		$Attack/AttackHitbox1.disabled = false
		rot=0
	else:
		$Attack/AttackHitbox3.disabled = false
		rot=PI
	$Attack/AttackAnimation.rotation = rot
	$Attack/AttackAnimation.play("Attack")
	await get_tree().create_timer(.12).timeout
	disable_attack_hitboxes()
	await get_tree().create_timer(.15).timeout
	$Attack/AttackAnimation.play("NoAttack")
	Global.can_attack=true
	$CoolDownBar.value=0
	

func _on_warp_timer_timeout() -> void:
	if warps<3:
		warps+=1
		$UI/Charges.frame = warps
		$WarpTimer.start()
		if (warps==1):#Let player warp again
			Global.can_warp = true

func disable_attack_hitboxes():
	$Attack/AttackHitbox1.disabled = true
	$Attack/AttackHitbox2.disabled = true
	$Attack/AttackHitbox3.disabled = true
	$Attack/AttackHitbox4.disabled = true

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "EnemyHitbox" && Global.can_be_hit==true:
		Global.alive=false

func die():
	$RunningAudio.stop()
	$AttackAudio.stop()
	$DeathAudio.play()
	$AnimatedSprite2D.play("Death")
