extends Node2D

#---------------------------------------------------------------------------------------------------
# Properties
#---------------------------------------------------------------------------------------------------
enum DISASTER { FLOOD, DROUGHT }
enum ACTION { BUILD, PLANT, PROPAGATE, CLEAN, RENOVATE, SAVE }

var isReady: bool = false
var isWin: bool = false

var card_stack = []
var disasters = []
var chosen_disaster

var card_scene = preload("res://Scene/Card/Card.tscn")
var disaster_scene = preload("res://Scene/Card/DisasterCard.tscn")
var action_scene = preload("res://Scene/Card/ActionCard.tscn")

onready var human = $HumanCard
onready var pos1 = $Actions/Pos1
onready var pos2 = $Actions/Pos2
onready var pos3 = $Actions/Pos3
onready var pos4 = $Actions/Pos4
onready var pos5 = $Actions/Pos5
onready var pos6 = $Actions/Pos6
onready var pos7 = $Actions/Pos7
onready var dis_pos = $Disaster/DisasterPos
onready var work1 = $Works/WorkCard
onready var work2 = $Works/WorkCard2
onready var work3 = $Works/WorkCard3
onready var stat_border = $StatBorder
onready var win = $Win
#---------------------------------------------------------------------------------------------------
# Methods
#---------------------------------------------------------------------------------------------------
func _ready():
#	var card1 = card_scene.instance()
#	card1._init(0, Vector2(100, 100))
#
#	var card2 = card_scene.instance()
#	card2._init(1, Vector2(500, 500))
#	add_child(card1)
#	add_child(card2)
#	add_card(card1)
#	add_card(card2)
	disasters.append(get_node("Disaster/Flood"))
	disasters.append(get_node("Disaster/Drought"))
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("mouse_click") and not isReady:
		$ColorRect.queue_free()
		$RichTextLabel.queue_free()
		isReady = true
	elif Input.is_action_just_pressed("mouse_click") and isWin:
		get_tree().quit()
func add_card(card):
	if (card_stack.size() == 0):
		card_stack.append(card)
	
	for c in card_stack:
		if c.card_type != card.card_type:
			card_stack.append(card)
	
	var count = 2
	for c in card_stack:
		c.z_index = count
		count += 1

func push_card_to_top(card):
	card_stack.erase(card)
	add_card(card)

func setDisaster(dis):
	var count:int = 0
	for i in disasters:
		if i != dis: 
			disasters.remove(count)
			i.queue_free()
			count -= 1
		count += 1
	start_game()

func start_game():
	#disasters[0].global_position = dis_pos.global_position
	var tween = create_tween()
	tween.tween_property(disasters[0], "global_position", $Disaster/AnimationAppear.global_position, 0.5)
	tween.tween_property(disasters[0], "scale", Vector2(2, 2), 1)
	yield(tween, "finished")
	tweenCallBack()
	
	disasters[0].startTimer()
	disasters[0].setVisibleBack()
	human.show()
	spawnAction()
	showHUD()
	setWork()

func tweenCallBack():
	var tween = create_tween()
	tween.tween_property(disasters[0], "scale", Vector2(0.35, 0.35), 0.5)
	tween.tween_property(disasters[0], "global_position", dis_pos.global_position, 0.5)
	
	yield(tween, "finished")

func setWork():
	match(disasters[0].disaster_type):
		DISASTER.FLOOD:
			work1.disaster_type = DISASTER.FLOOD
			work2.disaster_type = DISASTER.FLOOD
			work3.disaster_type = DISASTER.FLOOD
		DISASTER.DROUGHT:
			work1.disaster_type = DISASTER.DROUGHT
			work2.disaster_type = DISASTER.DROUGHT
			work3.disaster_type = DISASTER.DROUGHT
	
	$Works.show()

func spawnAction():
	match(disasters[0].disaster_type):
		DISASTER.FLOOD:
			var action = action_scene.instance()
			action._init(DISASTER.FLOOD, ACTION.BUILD, 5, pos1.global_position)
			var action2 = action_scene.instance()
			action2._init(DISASTER.FLOOD, ACTION.PLANT, 5, pos2.global_position)
			var action3 = action_scene.instance()
			action3._init(DISASTER.FLOOD, ACTION.PROPAGATE, 5, pos7.global_position)
			var action4 = action_scene.instance()
			action4._init(DISASTER.FLOOD, ACTION.RENOVATE, 2, pos5.global_position)
			var action5 = action_scene.instance()
			action5._init(DISASTER.FLOOD, ACTION.CLEAN, 2, pos6.global_position)
			
			get_node("Actions").add_child(action)
			get_node("Actions").add_child(action2)
			get_node("Actions").add_child(action3)
			get_node("Actions").add_child(action4)
			get_node("Actions").add_child(action5)

		DISASTER.DROUGHT:
			var action = action_scene.instance()
			action._init(DISASTER.FLOOD, ACTION.BUILD, 5, pos1.global_position)
			var action2 = action_scene.instance()
			action2._init(DISASTER.FLOOD, ACTION.PLANT, 5, pos2.global_position)
			var action3 = action_scene.instance()
			action3._init(DISASTER.FLOOD, ACTION.PROPAGATE, 5, pos3.global_position)
			var action4 = action_scene.instance()
			action4._init(DISASTER.FLOOD, ACTION.RENOVATE, 2, pos5.global_position)
			var action5 = action_scene.instance()
			action5._init(DISASTER.FLOOD, ACTION.CLEAN, 2, pos6.global_position)
			var action6 = action_scene.instance()
			action6._init(DISASTER.FLOOD, ACTION.SAVE, 2, pos4.global_position)
			
			get_node("Actions").add_child(action)
			get_node("Actions").add_child(action2)
			get_node("Actions").add_child(action3)
			get_node("Actions").add_child(action4)
			get_node("Actions").add_child(action5)
			get_node("Actions").add_child(action6)

func showHUD():
	stat_border.show()
