extends Sprite

onready var awarenessLabel = $AwarenessLabel
onready var moneyLabel = $MoneyLabel

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	awarenessLabel.text = String(GlobalVariables.awarenessPoint) + "/" + "100"
	moneyLabel.text = String(GlobalVariables.moneyPoint) + "/" + "100"
