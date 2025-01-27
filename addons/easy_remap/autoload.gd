extends Node


## Emitted when [param action]'s [param input] event is successfully remapped to a [param new_event].
signal remap_success(action: String, old_event: InputEvent, new_event: InputEvent)

## Emitted when the remapping of [param action] fails due to [method listen_stop] being called.
signal remap_fail(action: String)


## A list of all supported modifier keys (e.g., Alt, Shift, Ctrl).
const MODIFIERS: Array = [
	## LEFT ALT or RIGHT ALT key.
	KEY_ALT,
	
	## LEFT SHIFT or RIGHT SHIFT key.
	KEY_SHIFT,
	
	## LEFT CTRL or RIGHT CTRL key
	KEY_CTRL,
]


## Determines if modifier keys are allowed during input remapping.
var listen_modifiers := false

## The name of the action currently being remapped.
var listen_action := ""

## The input event associated with the action being remapped.
var listen_event: InputEvent

## A list of currently active modifier keys.
var active_modifiers: Array[Key] = []


func _ready() -> void:
	# Ensure this autoload processes input even when the game is paused.
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Disable input processing by default.
	set_process_input(false)


func _input(event: InputEvent) -> void:
	# Debug log configuration.
	var debug_log: bool = RemapHelper.get_setting("debug_log", true)
	
	# Ignore mouse motion events.
	if event is InputEventMouseMotion:
		return
	
	# Ensure the action exists in the InputMap before proceeding.
	if not InputMap.has_action(listen_action):
		return
	
	# Handle modifier keys.
	var mod_callable := func update_modifiers(event: InputEvent) -> bool:
		# Only handle key press events for modifiers.
		if not event is InputEventKey:
			return false
		
		# Check if the pressed key is a valid modifier.
		if not event.keycode in MODIFIERS:
			return false
		
		# Add or remove modifiers based on key press/release state.
		if event.pressed:
			if not event.keycode in active_modifiers:
				active_modifiers.push_back(event.keycode)
		else:
			active_modifiers.erase(event.keycode)
		
		# Debug log active modifiers.
		if debug_log:
			var str_modifiers: PackedStringArray = []
			for key: Key in active_modifiers:
				str_modifiers.push_back(OS.get_keycode_string(key))
			
			print("Modifiers currently active: %s." % str_modifiers)
		
		return true
	
	# Process modifiers if enabled.
	if listen_modifiers:
		if mod_callable.call(event):
			return
	
	# Duplicate the event and apply active modifiers if necessary.
	var new_event: InputEvent = event.duplicate()
	if listen_modifiers:
		for key: Key in active_modifiers:
			match key:
				KEY_ALT: new_event.alt_pressed = true
				KEY_SHIFT: new_event.shift_pressed = true
				KEY_CTRL: new_event.ctrl_pressed = true
	
	# Remap the action's input event.
	InputMap.action_erase_event(listen_action, listen_event)
	InputMap.action_add_event(listen_action, new_event)
	
	# Emit the success signal and log the remapping.
	remap_success.emit(listen_action, listen_event, new_event)
	if debug_log:
		print("Successfully remapped action '%s': '%s' replaced with '%s'." % [listen_action, listen_event.as_text(), new_event.as_text()])
	
	# Reset remapping variables.
	listen_action = ""
	listen_event = null


## Starts listening for input to remap the specified action.
## - [param action]: The name of the action to be remapped.
## - [param event]: The current input event assigned to the action.
## - [param allow_modifiers]: Whether modifiers (Alt, Shift, Ctrl) are allowed.
func listen_start(action: String, event: InputEvent, allow_modifiers: bool) -> void:
	# Ensure the action exists in the InputMap.
	if not InputMap.has_action(action):
		push_warning("Cannot remap action '%s': it does not exist in the InputMap." % action)
		return
	
	# Ensure the event exists for the action.
	if not InputMap.action_has_event(action, event):
		push_warning("Cannot remap action '%s': the event '%s' is not assigned to this action." % [action, event.as_text()])
		return
	
	# Set remapping variables.
	listen_action = action
	listen_event = event
	listen_modifiers = allow_modifiers
	
	# Enable input processing to listen for the next input.
	set_process_input(true)


## Stops listening for input and cancels the remapping process.
func listen_stop() -> void:
	# Emit the failure signal if a remap was in progress.
	if listen_action != "":
		remap_fail.emit(listen_action)
	else:
		push_warning("listen_stop() was called, but no remapping was in progress.")
		return
	
	# Reset remapping variables.
	listen_action = ""
	listen_event = null
	
	# Disable input processing.
	set_process_input(false)
