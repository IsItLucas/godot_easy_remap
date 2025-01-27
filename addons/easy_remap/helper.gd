class_name RemapHelper extends Node


## The prefix of the project settings related to the addon.
const SETTINGS_NAME := "remap"


## Sets a given GEIP [param setting] to the given [param value].
static func set_setting(setting: String, value: Variant) -> void:
	var path := get_setting_path(setting)
	if not ProjectSettings.has_setting(path):
		push_error("Couldn't find custom setting \"%s\"." % setting)
	
	ProjectSettings.set_setting(path, value)


## Returns the current [param value] of a GEIP project [param setting].
static func get_setting(setting: String, default: Variant = null) -> Variant:
	var path := get_setting_path(setting)
	return ProjectSettings.get_setting(path, default)


## Returns the Project Setting path for the given GEIP [param setting].
static func get_setting_path(setting: String) -> String:
	return "godot_easy/" + SETTINGS_NAME + "/" + setting


## Returns an InputEvent based.
static func get_action_event_from_id(action: String, id: int) -> InputEvent:
	assert(InputMap.has_action(action), "Action \"%s\" doesn't exists." % action)
	
	var action_list := InputMap.action_get_events(action)[id]
	assert(action_list.size() >= id - 1, "Couldn't get index %s on action \"%s\"." % [str(id), action])
	
	return InputMap.action_get_events(action)[id]
