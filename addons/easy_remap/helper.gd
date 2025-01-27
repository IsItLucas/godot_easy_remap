class_name RemapHelper extends Node


## Prefix for all Godot Easy Input Remap settings in Project Settings.
const SETTINGS_NAME := "remap"


## Updates a specific [param setting] with a new [param value].
static func set_setting(setting: String, value: Variant) -> void:
	var path := get_setting_path(setting)
	if not ProjectSettings.has_setting(path):
		push_error("Failed to update setting \"%s\": the setting does not exist in the Project Settings. Verify the configuration in Project > Project Settings > General > Godot Easy > Remap." % setting)
	
	ProjectSettings.set_setting(path, value)


## Retrieves the value of a [param setting] or returns a [param default] value.
static func get_setting(setting: String, default: Variant = null) -> Variant:
	var path := get_setting_path(setting)
	return ProjectSettings.get_setting(path, default)


## Generates the full path for a given [param setting].
static func get_setting_path(setting: String) -> String:
	return "godot_easy/" + SETTINGS_NAME + "/" + setting


## Retrieves an InputEvent by its [param id] in an [param action]'s event list.
static func get_action_event_from_id(action: String, id: int) -> InputEvent:
	assert(InputMap.has_action(action), "Action \"%s\" doesn't exists." % action)
	
	var action_list := InputMap.action_get_events(action)[id]
	assert(id < action_list.size(), "Failed to retrieve input event at index %s for action \"%s\": index is out of bounds. Ensure the action has enough events assigned in the InputMap." % [str(id), action])
	
	return InputMap.action_get_events(action)[id]
