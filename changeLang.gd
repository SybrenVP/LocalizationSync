extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_changeLanguage()
	pass # Replace with function body.

func _changeLanguage() -> void:
	var language = "NL"
# Load here language from the user settings file
	if language == "automatic":
		var preferred_language = OS.get_locale_language()
		TranslationServer.set_locale(preferred_language)
	else:
		TranslationServer.set_locale(language)
