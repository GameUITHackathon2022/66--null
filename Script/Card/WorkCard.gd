extends KinematicBody2D
class_name WorkCard

#---------------------------------------------------------------------------------------------------
# Properties
#---------------------------------------------------------------------------------------------------
# Logic
enum DISASTER { FLOOD, DROUGHT }
enum WORKTYPE { RAISE, DEFOREST, MINE }
enum TYPE { LAND, WATER, DEF, COIN }

export(int) var disaster_type = DISASTER.FLOOD
export(int) var work_type = WORKTYPE.RAISE
export(float) var timer_time = 1.0

var human = null

# Node 
onready var human_snap_pos = $HumanSnapPos
onready var custom_timer = $CustomTimer
onready var spawn_position = $SpawnPosition
onready var namelbl = $Name

var resource_card = preload("res://Scene/Card/Card.tscn")
#---------------------------------------------------------------------------------------------------
# Methods
#---------------------------------------------------------------------------------------------------
func _ready():
	match(work_type):
		WORKTYPE.RAISE:
			namelbl.text = "Lầm việc"
		WORKTYPE.DEFOREST:
			namelbl.text = "Đốn rừng"
		WORKTYPE.MINE:
			namelbl.text = "Khai thác"
func _customTimer_time_out():
	workValue()

func workValue():
	if disaster_type == DISASTER.FLOOD:
		match (work_type):
			WORKTYPE.RAISE:
				GlobalVariables.setMoney(2)
			WORKTYPE.DEFOREST:
				if (get_tree().get_nodes_in_group(TYPE.keys()[TYPE.DEF]).size() == 1):
					if get_tree().get_nodes_in_group(TYPE.keys()[TYPE.DEF])[0].value >= 3:
						GlobalVariables.setMoney(5)
						GlobalVariables.setAwareness(-5)
						get_tree().get_nodes_in_group(TYPE.keys()[TYPE.DEF])[0].valuePlus(-3)
			WORKTYPE.MINE:
				if (get_tree().get_nodes_in_group(TYPE.keys()[TYPE.LAND]).size() == 1):
					if get_tree().get_nodes_in_group(TYPE.keys()[TYPE.LAND])[0].value >= 3:
						GlobalVariables.setMoney(5)
						GlobalVariables.setAwareness(-5)
						get_tree().get_nodes_in_group(TYPE.keys()[TYPE.LAND])[0].valuePlus(-3)
	elif disaster_type == DISASTER.DROUGHT:
		match (work_type):
			WORKTYPE.RAISE:
				GlobalVariables.setMoney(2)
			WORKTYPE.DEFOREST:
				if (get_tree().get_nodes_in_group(TYPE.keys()[TYPE.WATER]).size() == 1):
					if get_tree().get_nodes_in_group(TYPE.keys()[TYPE.WATER])[0].value >= 3:
						GlobalVariables.setMoney(5)
						GlobalVariables.setAwareness(-5)
						get_tree().get_nodes_in_group(TYPE.keys()[TYPE.WATER])[0].valuePlus(-3)
			WORKTYPE.MINE:
				if (get_tree().get_nodes_in_group(TYPE.keys()[TYPE.LAND]).size() == 1):
					if get_tree().get_nodes_in_group(TYPE.keys()[TYPE.LAND])[0].value >= 3:
						GlobalVariables.setMoney(5)
						GlobalVariables.setAwareness(-5)
						get_tree().get_nodes_in_group(TYPE.keys()[TYPE.LAND])[0].valuePlus(-3)
	
	if human != null:
		startTimer()

func startTimer():
	custom_timer.runTimer()

func _on_HumanSnapArea_area_entered(area):
	human = area.owner

func _on_HumanSnapArea_area_exited(area):
	human = null
	custom_timer.stopTimer()



