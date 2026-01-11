extends Node2D

var drip1 =600
var drip2 = 1258
var drip3 = 980
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	drip1-=1
	drip2-=1
	drip3-=1
	if drip1==0:
		drip1=600
		$Drip.play()
	if drip2==0:
		drip2=1258
		$Drip2.play()
	if drip3==0:
		drip3=980
		$Drip3.play()
