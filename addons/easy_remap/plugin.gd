@tool extends EditorPlugin


# Added constants to make the creation of new "Godot Easy ..." plugins easier.
const AUTOLOAD_NAME := "Remap"
const FOLDER_NAME := "easy_remap"
const SETTINGS_NAME := "remap"

# All custom project settings created by the addon should be in here for an easy clean up and addition.
const CUSTOM_SETTINGS: Array[Array] = [
	["debug_log", true]
]


func _enter_tree() -> void:
	# Add GEIP autoload.
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/" + FOLDER_NAME + "/autoload.gd")
	
	# Add GES settings with compatibility for other "Godot Easy ..." plugins.
	for pair: Array in CUSTOM_SETTINGS:
		var setting_name: String = pair[0]
		var setting_value: Variant = pair[1]
		set_setting(setting_name, setting_value)


func _exit_tree() -> void:
	# Remove GEIP autoload.
	remove_autoload_singleton(AUTOLOAD_NAME)
	
	# Remove custom settings.
	for pair: Array in CUSTOM_SETTINGS:
		var setting_name: String = pair[0]
		var path := RemapHelper.get_setting_path(setting_name)
		ProjectSettings.set_setting(path, null)


func set_setting(setting_name: String, setting_value: Variant) -> void:
	# Add / remove a project setting. What this line does is defined by setting_value.
	# If the value is null, the setting will be removed. But if not, the setting is going to be added.
	var path := RemapHelper.get_setting_path(setting_name)
	if not ProjectSettings.has_setting(path):
		ProjectSettings.set_setting(path, ProjectSettings.get_setting(path, setting_value))
		ProjectSettings.set_initial_value(path, setting_value)
