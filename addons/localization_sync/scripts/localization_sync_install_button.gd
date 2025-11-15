extends Button

const installUrl = "https://script.google.com/d/1IL41CvkjEm3Xn2hYrT98iDPzNASVngsRVCkVrISt7OjX-Os-2d-iQqiO/copy"

func _on_pressed() -> void:
	OS.shell_open(installUrl)
