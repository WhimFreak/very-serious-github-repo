extends MainMenuBtn

class_name MainMenuPlayBtn

@export var root: MenuRoot

func _on_click() -> void:
	super._on_click()
	curtain_system.open_full()
	root._on_play_pressed()
