extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MessageOverlay/Button.visible = false
	$MessageOverlay/MissionFailed.visible = false
	$MessageOverlay/MissionSuccess.visible = false
	$WinBG.visible = false
	$MessageOverlay/MissionCollectSamples.visible = false
	$CanvasGroup/PlayAgain.visible = false
	$CanvasGroup/PlayAgain.top_level = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if Global.start && !Global.paused:
		$Button.play()
		Global.paused=true
		$MessageOverlay/MissionGetOut.visible = true
		Global.can_warp = false
		Global.can_move = false
		await get_tree().create_timer(2.5).timeout
		Global.can_move = true
		Global.can_warp = true
		$MessageOverlay/MissionGetOut.visible = false
	
	if !Global.alive && !Global.retry && Input.is_action_just_pressed("Go"):
		retry()
	
	if Global.alive == false:
		lose()
	if Global.retry == true:
		retry()
	

func _on_exit_body_entered(_body: Node2D) -> void:
	credits()
	
func credits():
	get_tree().call_group("enemies", "queue_free")
	$WinBG.visible = true
	$Player/UI.visible = false
	$MessageOverlay/MissionSuccess.visible = true
	Global.can_move = false
	$CanvasGroup/PlayAgain.visible = true
	$Music.volume_db = -5

func lose():
	await get_tree().create_timer(1.8).timeout
	$Music.stop()
	$MessageOverlay/Button.visible = true
	$MessageOverlay/MissionFailed.visible = true
	
func retry():
	$Button.play()
	$MessageOverlay/Button.visible = false
	$MessageOverlay/MissionFailed.visible = false
	get_tree().reload_current_scene()
	reset_globals()
	
	
func reset_globals():
	Global.can_move = true
	Global.can_attack = true
	Global.can_be_hit = true
	Global.alive = true
	Global.retry = false
	Global.start = true
	Global.paused = false


func _on_play_again_pressed() -> void:
	$Button.play()
	get_tree().reload_current_scene()
	reset_globals()
	Global.start=false
