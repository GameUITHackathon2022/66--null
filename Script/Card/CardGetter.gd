extends Area2D

#---------------------------------------------------------------------------------------------------
# Methods
#---------------------------------------------------------------------------------------------------
func _process(_delta):
	position = get_global_mouse_position()

	var count = len(get_overlapping_bodies())
	if get_overlapping_bodies().size() != 0 and get_overlapping_bodies()[0] is ResourceCard:
		if count == 0:
			pass
		elif count == 1:
			get_overlapping_bodies()[0].chooseThisCard()
			if (Input.is_action_just_pressed("mouse_click")):
				get_parent().push_card_to_top(get_overlapping_bodies()[0])
		else:
			var max_index = -1
			var top_card = null
			for card in get_overlapping_bodies():
				if (card.z_index > max_index):
					max_index = card.z_index
					top_card = card
			
			top_card.chooseThisCard()
			for card in get_overlapping_bodies():
				if card!= top_card:
					card.chosen = false
			if (Input.is_action_just_pressed("mouse_click")):
				get_parent().push_card_to_top(top_card)


