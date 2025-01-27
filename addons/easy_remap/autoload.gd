extends Node


## Emitted when [param action]'s [param old_event] is remapped successfully to the given [param new_event].
signal remap_success(action: String, old_event: InputEvent, new_event: InputEvent)

## Emitted when [param action] couldn't be remapped because of [method listen_stop].
signal remap_fail(action: String)


## A list with all possible modifiers for inputs.
const MODIFIERS: Array = [
	KEY_ALT,
	KEY_SHIFT,
	KEY_CTRL,
]


## Determines if modifiers for inputs are allowed or not.
var listen_modifiers := false

## The action that is about to be remapped.
var listen_action := ""

## The input event that is about to be remapped.
var listen_event: InputEvent

## The modifiers currently active.
var active_modifiers: Array[Key] = []


func _ready() -> void:
	# Make sure this autoload runs even when the game is paused.
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Disable input function by default.
	set_process_input(false)


func _input(event: InputEvent) -> void:
	# Get variables.
	var debug_log: bool = RemapHelper.get_setting("debug_log", true)
	
	# Ignore mouse motion.
	if event is InputEventMouseMotion:
		return
	
	# Check if an action is ready to be remapped.
	if not InputMap.has_action(listen_action):
		return
	
	# Check for modifiers.
	var mod_callable := func update_modifiers(event: InputEvent) -> bool:
		# Check if the event is a key press - modifiers can only be key presses.
		if not event is InputEventKey:
			return false
		
		# Check if the key pressed is one of the supported event keys.
		if not event.keycode in MODIFIERS:
			return false
		
		# Key pressed - add modifier if it doesn't exists.
		if event.pressed:
			if not event.keycode in active_modifiers:
				active_modifiers.push_back(event.keycode)
			else:
				return true # Return true here because it is a valid modifier but we don't want to spam the log.
		
		# Key released - remove modifier if it exists.
		else:
			if event.keycode in active_modifiers:
				active_modifiers.erase(event.keycode)
			else:
				return true  # Return true here because it is a valid modifier but we don't want to spam the log.
		
		# Debug log.
		if debug_log:
			var str_modifiers: PackedStringArray = []
			for key: Key in active_modifiers: 
				str_modifiers.push_back(OS.get_keycode_string(key))
			
			print("Active modifiers: " + str(str_modifiers))
		
		# Returning true because a valid modifier was found
		return true
	
	if listen_modifiers:
		if mod_callable.call(event):
			return
	
	# Create new event.
	var new_event: InputEvent = event.duplicate()
	
	if listen_modifiers:
		# Add modifiers.
		for key: Key in active_modifiers:
			match key:
				KEY_ALT: new_event.alt_pressed = true
				KEY_SHIFT: new_event.shift_pressed = true
				KEY_CTRL: new_event.ctrl_pressed = true
	
	# Remap.
	InputMap.action_erase_event(listen_action, listen_event)
	InputMap.action_add_event(listen_action, new_event)
	
	# Emit signal.
	remap_success.emit(listen_action, listen_event, new_event)
	
	# Debug log.
	if debug_log:
		print("Event \"%s\" from \"%s\" was replaced by \"%s\"." % [listen_event.as_text(), listen_action, new_event.as_text()])
	
	# Invalidate action.
	listen_action = ""
	listen_event = null


## Starts listening to inputs to remap [param action].
func listen_start(action: String, event: InputEvent, allow_modifiers: bool) -> void:
	# Check if action exists.
	if not InputMap.has_action(action):
		push_warning("Action \"%s\" doesn't exists." % action)
		return
	
	# Check if event exists.
	if not InputMap.action_has_event(action, event):
		push_warning("Action \"%s\" doesn't have event \"%s\"." % [action, event])
		return
	
	# Update listening action.
	listen_action = action
	listen_event = event
	listen_modifiers = allow_modifiers
	
	# Enable input function.
	set_process_input(true)


## Cancels the action remap.
func listen_stop() -> void:
	# Emit a signal.
	remap_fail.emit(listen_action)
	
	# Invalidate action.
	listen_action = ""
	listen_event = null
	
	# Disable input function.
	set_process_input(false)
