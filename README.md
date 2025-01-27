# GEIP - Godot Easy Input Remap 🎮✨💡
GEIP (Godot Easy Input Remap) is a lightweight addon for the Godot Engine that makes it easy to implement customizable input remapping systems.
With GEIP, players can dynamically rebind their controls, enabling a flexible and user-friendly experience. 🌟🎮

## Features 🛠️🚀
- Dynamic Input Remapping: Players can remap inputs at runtime without restarting the game.
- Modifier Support: Includes optional support for modifiers (Alt, Shift, Ctrl) in key bindings.
- Conflict Prevention: Built-in system to prevent input conflicts when remapping.
- Signal-Based Architecture: Emit signals on successful or failed remaps for easy integration.
- Helper Functions: Simplify input management with utility functions for settings and events.
- No Code Setup: Fully configurable via Godot's Project Settings interface.

## Installation 💾📥
### Download or Clone the Repository
- Download the latest version from the repository.
- Or clone it: `git clone https://github.com/your-repo-link.git`

### Add to Your Project
- Extract the files into the `addons/` directory in your Godot project.

### Enable the Plugin
- In Godot, go to `Project > Project Settings > Plugins`.
- Locate `GEIP - Godot Easy Input Remap` and set it to `Enabled`. ✅✨

## Configuration ⚙️🔧
- Access the plugin settings at `Project > Project Settings > General > Godot Easy > Remap`. 🛠️

## Usage 🎯📖

- Call `listen_start(action: String, event: InputEvent, allow_modifiers: bool)` to begin listening for input to remap a specific action and event.
- Use `listen_stop()` to cancel remapping if needed.
- Connect to signals like `remap_success` and `remap_fail` to handle input remapping dynamically.

## Signals 📡✨
### `remap_success(action: String, old_event: InputEvent, new_event: InputEvent)`
Emitted when an action's input is successfully remapped. ✅

### `remap_fail(action: String)`
Emitted when remapping fails (e.g., due to listen_stop). ❌

## Contributions 🤝🌍
Contributions are welcome! Feel free to open issues or submit pull requests to improve this addon.
See `CODE OF CONDUCT` for more details. 🌟

## License 📜⚖️
This project is licensed under the MIT License. See the `LICENSE` file for more details. ✅
