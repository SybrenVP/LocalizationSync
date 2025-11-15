@tool
extends Button

@export var urlField : LineEdit
@export var sheetOptions : OptionButton

const SETTINGS_URL_KEY = "localization_sync_url"
const SETTINGS_SHEET_KEY = "localization_sync_sheet"

const connectUrl = "{0}"

signal connected

func _ready():	
	var settings = EditorInterface.get_editor_settings()
	var savedUrl = settings.get_setting(SETTINGS_URL_KEY)
	urlField.text = savedUrl if savedUrl else ""
	
	if !urlField.text.is_empty():
		_on_pressed()

func _on_pressed() -> void:	
	if (urlField.text.is_empty()):
		return
	
	print("Connecting to Google Sheets..")
	sheetOptions.clear()
	var url = urlField.text
	$HTTPRequest.request(connectUrl.format([url]))

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("Connected!")
	
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Failed to connect ({0})".format([response_code]))
		return
	
	var settings = EditorInterface.get_editor_settings()
	settings.set_setting(SETTINGS_URL_KEY, urlField.text)
	var savedSheet = settings.get_setting(SETTINGS_SHEET_KEY)
	
	var spreadsheets = JSON.parse_string(body.get_string_from_utf8())
	
	for i in len(spreadsheets):
		sheetOptions.add_item(spreadsheets[i].Name)
		sheetOptions.set_item_metadata(i, spreadsheets[i].Id)
		if spreadsheets[i].Name == savedSheet:
			sheetOptions.select(i)
	
	connected.emit()


func _save_download_sheet_name():
	var settings = EditorInterface.get_editor_settings()
	settings.set_setting(SETTINGS_SHEET_KEY, sheetOptions.get_item_text(sheetOptions.selected))

func _on_option_button_item_selected(index: int) -> void:
	_save_download_sheet_name()

func _on_download_spreadsheet() -> void:
	_save_download_sheet_name()
