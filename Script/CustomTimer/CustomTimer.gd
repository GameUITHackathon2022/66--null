extends Node2D

var speed_factor = 1.0
var old_speed_factor = speed_factor
var timer_wait_time

onready var timer = $Timer

func _ready():
	timer.wait_time = get_parent().timer_time

func _process(_delta):
	# Show Time
	$Val.set_text("%.f" % timer.time_left)
	
func slow_down(val: bool, factor: float):
	speed_factor = factor
	var time_left = timer.time_left
	timer.stop()
	if val:
		# Change wait time speed
		timer.wait_time = time_left * (1.0 / speed_factor)
	else:
		timer.wait_time = time_left * (speed_factor)
	
	old_speed_factor = speed_factor
	timer.start()
	
func _on_Timer_timeout():
#	timer.stop()
#	if speed_factor != 1.0:
#		# Change speed for time out event
#		timer.wait_time = timer_wait_time * (1.0/speed_factor)
#	else:
#		timer.wait_time = timer_wait_time
#
#	timer.start()
	get_parent()._customTimer_time_out()

func runTimer():
	timer.start()

func stopTimer():
	timer.stop()
