extends KinematicBody2D
class_name ActionCard

#---------------------------------------------------------------------------------------------------
# Properties
#---------------------------------------------------------------------------------------------------
# Logic
enum TYPE { LAND, WATER, DEF, COIN }
enum DISASTER { FLOOD, DROUGHT }
enum ACTION { BUILD, PLANT, PROPAGATE, CLEAN, RENOVATE, SAVE }

onready var action = $Action
onready var namelbl = $Name

export(int) var disaster_type 
export(int) var action_type
export(float) var timer_time = 1.0

var human = null

# Texture
var build = preload("res://Resource/Graphic/Card/build.png")
var plant = preload("res://Resource/Graphic/Card/plant.png")
var propagate = preload("res://Resource/Graphic/Card/aware_spread.png")
var clean = preload("res://Resource/Graphic/Card/clean.png")
var renovate = preload("res://Resource/Graphic/Card/renovate.png")
var save = preload("res://Resource/Graphic/Card/save.png")


# Node
onready var audio_player = $AudioStreamPlayer
onready var human_snap_pos = $HumanSnapPos
onready var custom_timer = $CustomTimer
onready var spawn_position = $SpawnPosition

var resource_card = preload("res://Scene/Card/Card.tscn")
#---------------------------------------------------------------------------------------------------
# Methods
#---------------------------------------------------------------------------------------------------
func _init(type = DISASTER.FLOOD, action = ACTION.BUILD, time = 1.0, pos = Vector2.ZERO):
	disaster_type = type
	action_type = action 
	timer_time = time
	global_position = pos

func _ready():
	match(action_type):
		ACTION.BUILD:
			action.texture = build
			namelbl.text = "Xây đê"
		ACTION.PLANT:
			action.texture = plant
			namelbl.text = "Trồng rừng"
		ACTION.PROPAGATE:
			action.texture = propagate
			namelbl.text = "Tuyên truyền"
		ACTION.RENOVATE:
			action.texture = renovate
			namelbl.text = "Cải tạo đất"
		ACTION.CLEAN:
			action.texture = clean
			namelbl.text = "Dọn rác"
		ACTION.SAVE:
			action.texture = save
			namelbl.text = "Tiết kiệm"

func _customTimer_time_out():
	spawnResourceCard()

func spawnResourceCard():
	if disaster_type == DISASTER.FLOOD:
		match(action_type):
			ACTION.BUILD:
				if GlobalVariables.getMoney() >= 10:
					GlobalVariables.setMoney(-10)
					for i in range(12):
						var resource = resource_card.instance()
						resource._init(TYPE.DEF, global_position)
						get_tree().get_root().add_child(resource)
						resource.moveToPosition(spawn_position.global_position)
						audio_player.play()
						yield(get_tree().create_timer(0.3), "timeout")
			ACTION.PLANT: 
				if GlobalVariables.getMoney() >= 10:
					GlobalVariables.setMoney(-10)
					for i in range(5):
						var resource = resource_card.instance()
						resource._init(TYPE.LAND, global_position)
						get_tree().get_root().add_child(resource)
						resource.moveToPosition(spawn_position.global_position)
						audio_player.play()
						yield(get_tree().create_timer(0.3), "timeout")
					for i in range(5):
						var resource = resource_card.instance()
						resource._init(TYPE.DEF, global_position)
						get_tree().get_root().add_child(resource)
						resource.moveToPosition(spawn_position.global_position)
						audio_player.play()
						yield(get_tree().create_timer(0.3), "timeout")
			ACTION.PROPAGATE: 
				GlobalVariables.setAwareness(6)
				audio_player.play()
			ACTION.CLEAN: 
				var resource = resource_card.instance()
				resource._init(TYPE.LAND, global_position)
				get_tree().get_root().add_child(resource)
				resource.moveToPosition(spawn_position.global_position)
				GlobalVariables.setAwareness(2)
				audio_player.play()
			ACTION.RENOVATE: 
				for i in range(2):
					var resource = resource_card.instance()
					resource._init(TYPE.LAND, global_position)
					get_tree().get_root().add_child(resource)
					resource.moveToPosition(spawn_position.global_position)
					audio_player.play()
					yield(get_tree().create_timer(0.3), "timeout")
	elif disaster_type == DISASTER.DROUGHT:
		match(action_type):
			ACTION.BUILD:
				if GlobalVariables.getMoney() >= 10:
					GlobalVariables.setMoney(-10)
					for i in range(12):
						var resource = resource_card.instance()
						resource._init(TYPE.WATER, global_position)
						get_tree().get_root().add_child(resource)
						resource.moveToPosition(spawn_position.global_position)
						audio_player.play()
						yield(get_tree().create_timer(0.3), "timeout")
			ACTION.PLANT: 
				if GlobalVariables.getMoney() >= 10:
					GlobalVariables.setMoney(-10)
					for i in range(5):
						var resource = resource_card.instance()
						resource._init(TYPE.LAND, global_position)
						get_tree().get_root().add_child(resource)
						resource.moveToPosition(spawn_position.global_position)
						audio_player.play()
						yield(get_tree().create_timer(0.3), "timeout")
					for i in range(5):
						var resource = resource_card.instance()
						resource._init(TYPE.WATER, global_position)
						get_tree().get_root().add_child(resource)
						resource.moveToPosition(spawn_position.global_position)
						audio_player.play()
						yield(get_tree().create_timer(0.3), "timeout")
			ACTION.PROPAGATE: 
				GlobalVariables.setAwareness(6)
			ACTION.CLEAN: 
				var resource = resource_card.instance()
				resource._init(TYPE.LAND, global_position)
				get_tree().get_root().add_child(resource)
				resource.moveToPosition(spawn_position.global_position)
				GlobalVariables.setAwareness(6)
				audio_player.play()
			ACTION.RENOVATE: 
				if GlobalVariables.getMoney() >= 10:
					GlobalVariables.setMoney(-10)
					for i in range(12):
						var resource = resource_card.instance()
						resource._init(TYPE.LAND, global_position)
						get_tree().get_root().add_child(resource)
						resource.moveToPosition(spawn_position.global_position)
						audio_player.play()
						yield(get_tree().create_timer(0.3), "timeout")
			ACTION.SAVE: 
				var resource = resource_card.instance()
				resource._init(TYPE.WATER, global_position)
				get_tree().get_root().add_child(resource)
				resource.moveToPosition(spawn_position.global_position)
				GlobalVariables.setAwareness(6)
				audio_player.play()
	
	if human != null:
		startTimer()

func startTimer():
	custom_timer.runTimer()

func _on_HumanSnapArea_area_entered(area):
	human = area.owner

func _on_HumanSnapArea_area_exited(area):
	human = null
	custom_timer.stopTimer()



