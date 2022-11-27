extends CanvasLayer

var rotate_speed: float = 0.5
var button1: bool = false
var button2: bool = false

onready var globe = $Globe

func _ready():
	pass

func _physics_process(delta):
	globe.rotate(rotate_speed * delta)
