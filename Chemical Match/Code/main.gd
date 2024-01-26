extends Node2D

var base_screen_size
var current_screen_size
var times = []
var ingame = false

func _ready():
	base_screen_size = get_viewport_rect()
	current_screen_size = get_viewport_rect()
	
	$"Start Menu".show()
	$Clock.hide()


func _process(delta):
	var ss = get_viewport_rect()
	if current_screen_size != ss:
		scale = ss.size/base_screen_size.size
		current_screen_size = ss
	
	if ingame:
		$Clock.process(delta)


func start_game():
	ingame = true
	$Clock.start()
	$TileMap.start()
	$"Start Menu".hide()

func end_game():
	ingame = false
	$"Start Menu".show()
	var new_label = Label.new()
	new_label.text = str($Clock.text)
	$"Start Menu/Times/VBoxContainer".add_child(new_label)

func _on_button_button_down():
	start_game()
