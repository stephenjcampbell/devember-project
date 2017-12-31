extends Panel

func _ready():
	pass

func _on_Button_pressed():
	get_tree().set_pause(false)
	self.queue_free()
