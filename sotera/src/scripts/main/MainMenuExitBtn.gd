extends MainMenuBtn

class_name MainMenuExitBtn


@onready var crossed_texture: TextureRect = $"Exit Blocker"

func _on_click() -> void:
	super._on_click()
	crossed_texture.visible = false
	curtain_system.open_full()
	jump_scare.start_jumpscare()
