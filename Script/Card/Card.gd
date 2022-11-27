extends KinematicBody2D
class_name ResourceCard

#---------------------------------------------------------------------------------------------------
# Properties
#---------------------------------------------------------------------------------------------------
# Logic
enum TYPE { LAND, WATER, DEF, COIN }
export(int) var card_type
var card_holder: bool = false
var movePos: bool = false
var moveSpawn: bool = false
var moveDes:= Vector2.ZERO
var moveDes2:= Vector2(500, 300)
var value: int = 1
var disaster = null

onready var count = $Count
# Dragging Logic
var draggingDistance
var dir
var dragging
var newPosition = Vector2()

var mouse_in = false
var chosen = false

onready var lerp_timer = $LerpTimer
onready var lerp_timer2 = $LerpTimer2
onready var resource = $Resource
onready var namelabel = $Name

var land = preload("res://Resource/Graphic/Card/land.png")
var water = preload("res://Resource/Graphic/Card/water.png")
var def = preload("res://Resource/Graphic/Card/def.png")
#---------------------------------------------------------------------------------------------------
# Method
#---------------------------------------------------------------------------------------------------
func _init(type = TYPE.LAND, pos = Vector2.ZERO):
	self.card_type = type
	global_position = pos

func _ready():
	match (card_type):
		TYPE.LAND:
			resource.texture = land
			namelabel.text = "Đất"
		TYPE.WATER:
			resource.texture = water
			namelabel.text = "Nước"
		TYPE.DEF:
			resource.texture = def
			namelabel.text = "Sức chắn"
	
	if (get_tree().get_nodes_in_group(TYPE.keys()[card_type]).size() == 0):
		card_holder = true
		add_to_group(TYPE.keys()[card_type])

func _input(event):
	if event is InputEventMouseButton:
		if chosen and event.is_pressed() && mouse_in:
			draggingDistance = position.distance_to(get_viewport().get_mouse_position())
			dir = (get_viewport().get_mouse_position() - position).normalized()
			dragging = true
			newPosition = get_viewport().get_mouse_position() - draggingDistance * dir
		else:
			if disaster != null: 
				global_position = disaster.resource_snap_area.global_position
				var array = disaster.getValueForUpdateCard() #condition 1, condition 2, maxvalue, value1, value2
				
				if card_type == array[0]:
					var remain = value + array[3] - array[2]
					if  remain <= 0: 
						disaster.setValue1(value)
						valuePlus(-value)
					else: 
						disaster.setValue1(value)
						valuePlus(-value)
						valuePlus(remain)
					disaster = null
					moveSpawn = true
				elif card_type == array[1]:
					var remain = value + array[4] - array[2]
					if  remain <= 0: 
						disaster.setValue2(value)
						valuePlus(-value)
					else: 
						disaster.setValue2(value)
						valuePlus(-value)
						valuePlus(remain)
					disaster = null
					moveSpawn = true
			dragging = false
			chosen = false
			
	elif event is InputEventMouseMotion:
		if dragging:
			newPosition = get_viewport().get_mouse_position() - draggingDistance * dir

func _physics_process(delta):
	if dragging:
# warning-ignore:return_value_discarded
		move_and_slide((newPosition - position) * Vector2(30, 30))
	
	if not card_holder:
		global_position = lerp(global_position, get_tree().get_nodes_in_group(TYPE.keys()[card_type])[0].global_position, 2 * delta)
	
	if movePos:
		global_position = lerp(global_position, moveDes, 2 * delta)
		if lerp_timer.is_stopped():
			lerp_timer.start()
	
	if moveSpawn:
		global_position = lerp(global_position, moveDes2, 2 * delta)
		if lerp_timer2.is_stopped():
			lerp_timer2.start()

func chooseThisCard():
	chosen = true

func _on_Card_mouse_entered():
	mouse_in = true

func _on_Card_mouse_exited():
	mouse_in = false

func moveToPosition(pos):
	moveDes = pos
	movePos = true

func valuePlus(plusValue):
	self.value += plusValue
	count.text = "x" + String(value)

func _on_CardCollision_area_entered(area):
	if area.owner is DisasterCard:
		disaster = area.owner
		return
	if area.owner.card_type == card_type:
		if not card_holder and area.owner.card_holder:
			area.owner.valuePlus(value)
			queue_free()

func _on_LerpTimer_timeout():
	movePos = false

func _on_CardCollision_area_exited(area):
	disaster = null

func _on_LerpTimer2_timeout():
	moveSpawn = false
