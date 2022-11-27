extends TextureButton

enum BUTTON_TYPE { START, QUIT }
export var type = BUTTON_TYPE.START

var start = preload("res://Resource/Graphic/TitleScreen/start.png")
var quit = preload("res://Resource/Graphic/TitleScreen/quit.png")

var world = "res://Scene/Map/World.tscn"
func _ready():
	match (type):
		BUTTON_TYPE.START:
			texture_normal = start
		BUTTON_TYPE.QUIT:
			texture_normal = quit

func _on_TextureButton_pressed(): 
	match (type):
		BUTTON_TYPE.START:
			SceneChanger.change_scene(world, 0)
		BUTTON_TYPE.QUIT:
			get_tree().quit()
