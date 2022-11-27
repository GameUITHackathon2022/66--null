extends KinematicBody2D
class_name HumanCard

#---------------------------------------------------------------------------------------------------
# Properties
#---------------------------------------------------------------------------------------------------
# Logic

# Value
var action_card = null

# Dragging Logic
var draggingDistance
var dir
var dragging
var newPosition = Vector2()

var mouse_in = false
#---------------------------------------------------------------------------------------------------
# Methods
#---------------------------------------------------------------------------------------------------
func _input(event):
	if event is InputEventMouseButton:
		if  event.is_pressed() && mouse_in:
			draggingDistance = position.distance_to(get_viewport().get_mouse_position())
			dir = (get_viewport().get_mouse_position() - position).normalized()
			dragging = true
			newPosition = get_viewport().get_mouse_position() - draggingDistance * dir
		else:
			if action_card != null: 
				global_position = action_card.human_snap_pos.global_position 
				action_card.startTimer()
			dragging = false
	elif event is InputEventMouseMotion:
		if dragging:
			newPosition = get_viewport().get_mouse_position() - draggingDistance * dir

func _physics_process(_delta):
	if dragging:
# warning-ignore:return_value_discarded
		move_and_slide((newPosition - position) * Vector2(30, 30))

func _on_HumanCollision_mouse_entered():
	mouse_in = true

func _on_HumanCollision_mouse_exited():
	mouse_in = false

func _on_HumanCollision_area_entered(area):
	action_card = area.owner

func _on_HumanCollision_area_exited(area):
	action_card = null
