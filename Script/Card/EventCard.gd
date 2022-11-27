extends KinematicBody2D
class_name EventCard

#---------------------------------------------------------------------------------------------------
# Properties
#---------------------------------------------------------------------------------------------------
# Logic
enum TYPE { LAND, WATER, DEF, COIN }
enum EventCard { STORM, DEFOREST }

var conditions = []
var conditions_value = []

var isReady: bool = true
export var disaster_type: = EventCard.STORM
var timer_time: float = 600.0

var human = null

var maxValue = 0
var value1 = 0 setget setValue1
var value2 = 0 setget setValue2
# Node 
var flood = preload("res://Resource/Graphic/Card/flood.png")
var drought = preload("res://Resource/Graphic/Card/drought.png")
var water = preload("res://Resource/Graphic/Card/water.png")
var land = preload("res://Resource/Graphic/Card/land.png")
var def = preload("res://Resource/Graphic/Card/def.png")

onready var resource_snap_area = $ResourceSnapPos
onready var spawn_position = $SpawnPosition
onready var nameLabel = $Name
onready var disaster = $Disaster
onready var custom_timer = $CustomTimer
onready var condition1 = $Information/Condition1
onready var condition2 = $Information/Condition2
onready var icon1 = $Information/Icon1
onready var icon2 = $Information/Icon2
onready var information = $Information
#---------------------------------------------------------------------------------------------------
# Properties
#---------------------------------------------------------------------------------------------------
func _ready():
	match(disaster_type):
		EventCard.STORM:
			conditions.append(TYPE.LAND)
			conditions_value.append(15)
			
			nameLabel.text = "Lũ lụt"
			disaster.texture = flood
			icon1.texture = land
			icon2.texture = def
			maxValue = 100
			setValue1(0)
			setValue2(0)

func setValue1(newvalue):
	value1 += newvalue
	
	if value1 >= maxValue:
		value1 = maxValue
	elif value1 < 0: 
		value1 = 0
	
	condition1.text = String(value1) + "/" + String(maxValue)
	checkIfWin()

func setValue2(newvalue):
	value2 += newvalue
	
	if value2 >= maxValue:
		value2 = maxValue
	elif value2 < 0: 
		value2 = 0
	
	condition2.text = String(value2) + "/" + String(maxValue)
	checkIfWin()

func checkIfWin():
	if value1 == maxValue and value2 == maxValue:
		return

func getValueForUpdateCard():
	var values = conditions
	values.append(maxValue)
	values.append(value1)
	values.append(value2)
	return values

func startTimer():
	custom_timer.runTimer()

func _customTimer_time_out():
	pass

func _on_ResourceSnapArea_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("mouse_click") and isReady:
		isReady = false
		get_parent().get_parent().setDisaster(self)

func setVisibleBack():
	information.visible = true
	custom_timer.visible = true
