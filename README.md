# SimplismUI

SimplismUI is a client-side Roblox Luau UI library built around a straightforward hierarchy:

**Library → Window → Tab → Column → Section → Elements**

Tabs default to one column; `tab:NewSection(...)` creates a section in column 1.

It provides animated windows, scrollable tabs and sections, common settings controls, searchable and multi-select dropdowns, keybinds, a full color picker, notifications, theming, preset colors, and an optional key-authentication interface.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Windows](#windows)
- [Tabs](#tabs)
- [Sections](#sections)
- [UI Elements](#ui-elements)
  - [Button](#button)
  - [Slider](#slider)
  - [Toggle](#toggle)
  - [Label](#label)
  - [Dropdown](#dropdown)
  - [Multi-Select Dropdown](#multi-select-dropdown)
  - [Option Grid](#option-grid)
  - [TextBox](#textbox)
  - [Keybind](#keybind)
  - [Color Picker](#color-picker)
- [Theming](#theming)
- [Preset Colors](#preset-colors)
- [Notifications](#notifications)
  - [Window Toasts](#window-toasts)
  - [Global Notifications](#global-notifications)
- [Authentication UI](#authentication-ui)
- [Cleanup](#cleanup)
- [Complete Example](#complete-example)
- [Edge Cases & Notes](#edge-cases--notes)

## Features

- Draggable, animated, responsive windows (or fixed-size)
- Show, hide, toggle, and minimize controls, with an optional rebindable toggle key
- Top, left, bottom, or right tab bars with upright, text-sized buttons and automatic sidebar width
- External visibility-button integration
- Scrolling tab bar and responsive multi-column tabs with indexed section creation
- Collapsible sections and ordered elements via `ListOrder`
- Option grids with responsive square cells or custom `UDim` dimensions
- Buttons, sliders, toggles, labels, single/multi-select dropdowns (with search), text boxes, keybinds
- HSV/RGB/HEX color picker with configurable presets
- Window-local toast notifications and global notifications
- Optional authentication/key-system UI
- Configurable theme palette
- Mouse and touch support throughout
- Cleanup and destruction methods

## Requirements

SimplismUI is intended for client-side Roblox code and should be required from a `LocalScript` or equivalent client context.

## Installation

The repository's `source.luau` returns the `Library` table directly. Place it inside a `ModuleScript` and require it from client-side code:

```lua
local Library = require(script.Parent.SimplismUI)
```

There is no package manager or HTTP-loading API — just require the module.

## Quick Start

```lua
local Library = require(script.Parent.SimplismUI)

local window = Library:Window({
	Title = "SimplismUI Example",
	ToggleKeybind = Enum.KeyCode.RightShift,
})

local mainTab = window:AddTab({
	Title = "Main",
})

local generalSection = mainTab:NewSection({
	Title = "General",
})

generalSection:AddLabel({
	Text = "Welcome to SimplismUI",
})

generalSection:AddToggle({
	Text = "Enabled",
	Default = true,
	Callback = function(enabled)
		print("Enabled:", enabled)
	end,
})

generalSection:AddSlider({
	Text = "Volume",
	Min = 0,
	Max = 100,
	Default = 50,
	Increment = 1,
	Callback = function(value)
		print("Volume:", value)
	end,
})

generalSection:AddButton({
	Text = "Notify",
	Callback = function()
		window:Toast({
			Text = "Button pressed",
			Type = "Success",
		})
	end,
})
```

The first tab added to a window becomes active automatically.

# Windows

```lua
local window = Library:Window({
	Title = "Settings",
})
```

`Library:Window()` also accepts no configuration table.

### Configuration

| Field           | Type            | Default          | Description                                           |
| --------------- | --------------- | ---------------- | ----------------------------------------------------- |
| `Title`         | `string?`       | `"Settings"`     | Window title                                          |
| `TabBarLocation` | `"Top" \| "Left" \| "Bottom" \| "Right"?` | `"Top"` | Positions the tab bar; other values raise an assertion |
| `Size`          | `UDim2?`        | None             | Custom size, used when `OverrideSize` is enabled      |
| `OverrideSize`  | `boolean?`      | `false`          | Uses `Size` as the base size; sidebar width is still added    |
| `Parent`        | `ScreenGui?`    | New `UUID`       | Existing `ScreenGui` to contain the window            |
| `StartVisible`  | `boolean?`      | `true`           | Initial open state                                    |
| `ToggleKeybind` | `Enum.KeyCode?` | None             | Adds a rebindable top-bar key that toggles the window |

If no custom `Parent` is supplied, SimplismUI creates its own `ScreenGui` with a `UUID` as name under `Players.LocalPlayer.PlayerGui`.

### Responsive sizing

Without `OverrideSize`, the window targets `UDim2.fromOffset(460, 520)` and automatically shrinks on narrower viewports, updating live as the viewport changes. Set `OverrideSize = true` and provide `Size` to use a fixed base size instead. Left and right tab bars add their measured width to that base size:

```lua
local window = Library:Window({
	Title = "Custom Window",
	OverrideSize = true,
	Size = UDim2.fromOffset(600, 450),
})
```

### Tab bar location and button sizing

```lua
local window = Library:Window({
	Title = "Settings",
	TabBarLocation = "Left",
	ToggleKeybind = Enum.KeyCode.RightShift,
})

window:AddTab({ Title = "Main" })
window:AddTab({ Title = "Appearance" })
```

| Location | Tab layout | Space used |
| -------- | ---------- | ---------- |
| `Top` | Horizontal, below the title bar | 40-pixel tab bar; default placement |
| `Bottom` | Horizontal, along the bottom | 40-pixel tab bar |
| `Left` | Vertical, below the title bar | Width of the widest visible tab button plus 16 pixels of horizontal padding |
| `Right` | Vertical, below the title bar | Width of the widest visible tab button plus 16 pixels of horizontal padding |

Buttons stay upright in every position and are 32 pixels high. Their widths use the title's measured text width plus 38 pixels, clamped to 38–100 pixels. Long titles truncate with an ellipsis. Buttons are separated by 4 pixels; overflowing tab lists scroll horizontally for top/bottom bars and vertically for side bars.

Side bars expand the window by their actual required width, preserving the base content width. This is not a fixed 116-pixel increase: 116 pixels is only the maximum, reached with a 100-pixel button. Adding, hiding, or showing tabs recalculates the sidebar and window width from the visible buttons. An empty sidebar adds no width. This adjustment also applies when `OverrideSize = true`; viewport-driven responsive sizing continues to apply when it is false.

`TabBarLocation` is a construction option; there is no public setter to relocate the bar after creation.

### Methods

| Method                           | Parameters               | Returns       | Description                                      |
| --------------------------------- | ------------------------ | ------------- | ------------------------------------------------ |
| `AddTab(config)`                 | `TabConfig`              | `TabObject`   | Creates a tab                                    |
| `SwitchTab(tab)`                 | `TabObject`              | `nil`         | Activates a tab and deactivates the previous one, keeping `window.ActiveTab` in sync |
| `SetVisible(visible?)`           | `boolean?`               | `nil`         | Shows, hides, or toggles when omitted            |
| `GetVisible()`                   | None                     | `boolean`     | Current open state                               |
| `Toggle()`                       | None                     | `nil`         | Toggles visibility                               |
| `Minimize()`                     | None                     | `nil`         | Toggles minimized state                          |
| `AttachVisibilityButton(config)` | `VisibilityButtonConfig` | `nil`         | Connects an external button to toggle the window |
| `Toast(config?)`                 | `ToastConfig?`           | `ToastObject` | Creates a window-local toast (see Notifications) |
| `Destroy()`                      | None                     | `nil`         | Destroys the window and its managed content      |

`SetVisible(false)` hides the window and preserves the object for later use; the close button in the top bar calls this rather than destroying the window. `Minimize()` shrinks the window to just its top bar; calling it again restores the full window.

### Window toggle keybind

```lua
local window = Library:Window({
	Title = "Settings",
	ToggleKeybind = Enum.KeyCode.RightShift,
})
```

The current key is shown in the top bar; clicking it enters rebinding mode (keyboard only, `Escape` cancels). There is no public getter/setter for this key after construction — it can only be rebound through its top-bar UI.

### External visibility buttons

```lua
local button = Instance.new("TextButton")
button.Size = UDim2.fromOffset(120, 36)
button.Parent = window.ScreenGui

window:AttachVisibilityButton({
	Button = button,
	ShowText = "Open UI",
	HideText = "Close UI",
})
```

| Field      | Type        | Default  | Description                      |
| ---------- | ----------- | -------- | --------------------------------- |
| `Button`   | `GuiButton` | Required | External button to wire up        |
| `ShowText` | `string?`   | `"Show"` | Text while the window is hidden   |
| `HideText` | `string?`   | `"Hide"` | Text while the window is visible  |

For a `TextButton`, SimplismUI updates its `Text`. For an `ImageButton`, it dims the image while the window is hidden and restores it when visible. Other `GuiButton` subclasses still toggle the window but get no built-in visual feedback.

`ShowText`/`HideText` are stored per-window, not per-button — attaching a second button with different text replaces the pair used for all attached `TextButton`s. There's no detach method, and the connection isn't cleaned up by the window's own `Destroy()`; stop using or destroy an external button yourself if it can outlive the window.

# Tabs

```lua
local generalTab = window:AddTab({
	Title = "General",
	Columns = 3,
})
```

### Configuration

| Field | Type | Default | Description |
| ----- | ---- | ------- | ----------- |
| `Title` | `string?` | `"Tab"` | Tab title |
| `Columns` | `number?` | `1` | Positive finite integer; creates this many columns |
| `MaxColumnWidth` | `UDim?` | None | Caps each column's width, subject to the minimum width; scale is relative to `window.ContentArea.AbsoluteSize.X` |

### Columns and responsive sizing

Use one-based indexing to choose a column. `tab:NewSection(config)` is equivalent to `tab[1]:NewSection(config)`:

```lua
local controls = generalTab:NewSection({ Title = "Controls" })
local inputs = generalTab[2]:NewSection({ Title = "Inputs" })
local selection = generalTab[3]:NewSection({ Title = "Selection" })

controls:AddToggle({ Text = "Enabled", Default = true })
inputs:AddTextBox({ Text = "Name" })
selection:AddOptionGrid({
	Text = "Mode",
	CellsInFillDirection = 3,
	Options = {
		{ Name = "Normal" },
		{ Name = "Fast" },
		{ Name = "Precise" },
	},
})
```

Columns share the tab's scroll frame and stack their own sections vertically. Their widths update when the content area or scroll viewport resizes. Available width is divided equally after subtracting 8-pixel outer padding on each side and 8-pixel gaps between columns. Each column has a minimum width of `math.max(200, window.ContentArea.AbsoluteSize.X / 2.5)`.

`MaxColumnWidth` resolves to `contentWidth * Scale + Offset` and caps the calculated width. The minimum takes precedence if that cap is smaller. For example, `MaxColumnWidth = UDim.new(0, 400)` limits columns to 400 pixels only when the minimum permits it.

The tab scroll frame uses `AutomaticCanvasSize = Enum.AutomaticSize.XY` and `ScrollingDirection = Enum.ScrollingDirection.XY` when there are more than two columns or the combined widths, gaps, and padding exceed the viewport. Otherwise both use `Y`. The viewport itself stays fixed; its `AutomaticSize` is not changed.

Valid indices run from `1` through `Columns`; indexing does not create additional columns. Each column exposes `Index`, `Frame`, `Tab`, and `NewSection(config)`. All sections remain tracked in `tab.Sections`, and `section.Tab` still refers to the owning tab. There is no public column-count setter.

### Methods

| Method                | Parameters      | Returns         | Description                                    |
| --------------------- | --------------- | --------------- | ----------------------------------------------- |
| `NewSection(config)`  | `SectionConfig` | `SectionObject` | Creates a section in column 1                  |
| `SetActive(active)`   | `boolean`       | `nil`           | Changes this tab's own active/visual state only — does not update `window.ActiveTab`; prefer `window:SwitchTab(tab)` for normal navigation |
| `SetVisible(visible)` | `boolean`       | `nil`           | Shows or hides the tab                         |
| `Destroy()`           | None            | `nil`           | Cleans up sections and managed tab connections |

The first tab added to a window becomes active automatically. Hiding the currently active tab deactivates its content but does not select another tab or clear `window.ActiveTab` — switch away first if that matters:

```lua
window:SwitchTab(generalTab)
playerTab:SetVisible(false)
```

# Sections

```lua
local section = generalTab:NewSection({
	Title = "General Settings",
	StartCollapsed = false,
	ListConfig = {
		Padding = UDim.new(0, 8),
	},
})
```

### Configuration

| Field            | Type                 | Default     | Description                                            |
| ---------------- | -------------------- | ----------- | -------------------------------------------------------- |
| `Title`          | `string?`            | `"Section"` | Section title                                          |
| `StartCollapsed` | `boolean?`           | `false`     | Starts the section collapsed                           |
| `ListConfig`     | `{ [string]: any }?` | None        | Raw properties applied directly to the section's `UIListLayout` (e.g. to change `SortOrder`, which changes how `ListOrder` behaves) |

### Methods

| Method                           | Returns                      |
| -------------------------------- | ---------------------------- |
| `SetVisible(visible)`            | `nil`                        |
| `AddButton(config)`              | `ButtonElement`               |
| `AddSlider(config)`              | `SliderElement`               |
| `AddToggle(config)`              | `ToggleElement`                |
| `AddLabel(config)`               | `LabelElement`                 |
| `AddDropdown(config)`            | `DropdownElement`              |
| `AddMultiSelectDropdown(config)` | `MultiSelectDropdownElement`   |
| `AddOptionGrid(config)`          | `OptionGridElement`             |
| `AddTextBox(config)`             | `TextBoxElement`                |
| `AddKeybind(config)`             | `KeyInputElement`               |
| `AddColorPicker(config)`         | `ColorPickerElement`             |
| `Destroy()`                      | `nil`                        |

Sections auto-resize to their content, animate when collapsed/expanded, and clip their content while collapsed. There is no public `SetCollapsed` method — the header is clicked by the user to toggle it.

### Element ordering

Every element accepts `ListOrder` (default `0`), which controls layout order within the section:

```lua
section:AddLabel({ Text = "First", ListOrder = 1 })
section:AddButton({ Text = "Second", ListOrder = 2, Callback = function() end })
```

# UI Elements

All element constructors take a configuration table. Most elements expose a root `Frame`, type-specific Roblox instances, `SetVisible(boolean)` (hides/shows without invoking any callback), and `Destroy()`.

### Callback timing

| Element      | User interaction | Programmatic setter                  | Initial default                      |
| ------------ | ----------------- | ------------------------------------- | ------------------------------------- |
| Button       | Yes               | N/A                                   | No                                    |
| Slider       | Yes               | `SetValue` fires                      | No, including NaN defaults |
| Toggle       | Yes               | `SetValue` fires                      | No                                    |
| Label        | None              | N/A                                    | N/A                                    |
| Dropdown     | Yes               | `SetSelectedOption` fires             | No                     |
| Multi-select | Yes               | `SetSelected` / `ClearSelected` fire  | No                     |
| Option Grid  | Yes               | `SetSelectedOption` fires             | No                     |
| TextBox      | On focus loss     | `SetText` fires                       | No                                     |
| Keybind      | Binding changes   | `SetInput` / `ClearInput` fire        | No                                     |
| Color picker | Color changes     | `SetColor` fires                      | No                                     |

Callbacks run synchronously, directly from the triggering event or setter — a long-running callback occupies that thread.

## Button

```lua
local button = section:AddButton({
	Text = "Run",
	Callback = function()
		print("Run")
	end,
})

button:SetText("Run Again")
```

### Configuration

| Field       | Type          | Default    | Description                     |
| ----------- | ------------- | ---------- | -------------------------------- |
| `Text`      | `string?`     | `"Button"` | Button text                     |
| `ListOrder` | `number?`     | `0`        | Layout order                    |
| `Callback`  | `(() -> ())?` | None       | Runs when the button is pressed |

### Methods

`SetVisible(boolean)`, `SetText(string)`, `Destroy()`

### Exposed instances

`Frame` (`Frame`), `Button` (`TextButton`)

## Slider

```lua
local slider = section:AddSlider({
	Text = "Speed",
	Min = 0,
	Max = 20,
	Default = 5,
	Increment = 0.5,
	Decimals = 1,
	Callback = function(value)
		print(value)
	end,
})

slider:SetValue(7.5)
local value = slider:GetValue()
```

### Configuration

| Field       | Type                | Default                                 | Description                |
| ----------- | ------------------- | ---------------------------------------- | ---------------------------- |
| `Text`      | `string?`           | `"Slider"`                               | Slider title               |
| `Min`       | `number?`           | `0`                                      | Minimum                    |
| `Max`       | `number?`           | `100`                                    | Maximum (must be `> Min`)  |
| `Default`   | `number?`           | `Min`                                    | Initial value               |
| `Increment` | `number?`           | `1`                                       | Rounding increment; `0` disables rounding |
| `Decimals`  | `number?`           | `2` when `Increment < 1`, otherwise `0`  | Display precision only     |
| `ListOrder` | `number?`           | `0`                                       | Layout order                |
| `Callback`  | `((number) -> ())?` | None                                      | Receives the current value  |

Interactive changes and `SetValue` round to the nearest multiple of `Increment` (anchored to zero, not `Min`) and clamp to `[Min, Max]`. `Default` is used as-is at construction and is **not** passed through this rounding/clamping — keep it within range and aligned to your increment.

Construction never invokes the slider callback, including when `Default = 0/0`.

The slider also has a numeric text entry (invalid text on focus loss reverts to the current value) and supports mouse/touch dragging, firing the callback continuously while dragging.

### Methods

`SetVisible(boolean)`, `SetValue(number)` (fires `Callback`), `GetValue()` → `number`, `Destroy()`

## Toggle

```lua
local toggle = section:AddToggle({
	Text = "Auto Save",
	Default = false,
	Callback = function(enabled)
		print(enabled)
	end,
})

toggle:SetValue(true)
local enabled = toggle:GetValue()
```

### Configuration

| Field       | Type                 | Default    |
| ----------- | -------------------- | ---------- |
| `Text`      | `string?`            | `"Toggle"` |
| `Default`   | `boolean?`           | `false`    |
| `ListOrder` | `number?`            | `0`        |
| `Callback`  | `((boolean) -> ())?` | None       |

The initial state does not invoke the callback.

### Methods

`SetVisible(boolean)`, `SetValue(boolean)` (fires `Callback`), `GetValue()` → `boolean`, `Destroy()`

### Exposed instances

`Frame` (`Frame`), `Label` (`TextLabel`)

## Label

```lua
local label = section:AddLabel({
	Text = "Status: Ready",
})

label:SetText("Status: Running")
local text = label:GetText()
```

### Configuration

| Field       | Type      | Default   |
| ----------- | --------- | --------- |
| `Text`      | `string?` | `"Label"` |
| `ListOrder` | `number?` | `0`       |

### Methods

`SetVisible(boolean)`, `SetText(string)`, `GetText()` → `string`, `Destroy()`

### Exposed instances

`Frame` (`Frame`), `Label` (`TextLabel`)

## Dropdown

```lua
local dropdown = section:AddDropdown({
	Text = "Mode",
	Options = { "Normal", "Fast", "Safe" },
	Default = "Normal",
	Searchable = true,
	Callback = function(option)
		print(option)
	end,
})

dropdown:AddOption("Custom")
dropdown:SetSelectedOption("Fast")
local selected = dropdown:GetSelected()
```

### Configuration

| Field        | Type                | Default         | Description                          |
| ------------ | ------------------- | ---------------- | -------------------------------------- |
| `Text`       | `string?`           | `"Select..."`    | Placeholder when nothing is selected |
| `Options`    | `{string}`          | `{}` if omitted  | Available options                    |
| `Default`    | `string?`           | None             | Initial selection                    |
| `Searchable` | `boolean?`          | `false`          | Adds a search field when open        |
| `ListOrder`  | `number?`           | `0`              | Layout order                          |
| `Callback`   | `((string) -> ())?` | None             | Receives the selected option         |

A valid `Default` initializes the selection without invoking `Callback`; an invalid one is silently ignored.

### Methods

| Method              | Parameters | Returns   | Fires callback? |
| ------------------- | ---------- | --------- | ---------------- |
| `SetVisible`        | `boolean`  | `nil`     | No               |
| `AddOption`         | `string`   | `nil`     | No               |
| `RemoveOption`       | `string`   | `nil`     | No — if the removed option was selected, selection is cleared without firing the callback |
| `SetOptions`        | `{string}` | `nil`     | No — replaces options and clears selection |
| `SetSelectedOption` | `string`   | `nil`     | Yes, if the option exists (silently ignored otherwise) |
| `GetSelected`       | None       | `string?` | No               |
| `Destroy`           | None       | `nil`     | —                |

When `Searchable = true`, matching is case-insensitive substring search; the query clears each time the dropdown opens or closes. The option list becomes scrollable once it's long.

## Multi-Select Dropdown

```lua
local dropdown = section:AddMultiSelectDropdown({
	Text = "Targets",
	Options = { "Players", "NPCs", "Objects" },
	Default = { "Players" },
	MaxSelected = 2,
	Searchable = true,
	Callback = function(selected)
		print(table.concat(selected, ", "))
	end,
})

dropdown:SetSelected({ "Players", "Objects" })
local selected = table.clone(dropdown:GetSelected())
```

### Configuration

| Field         | Type                  | Default         | Description                    |
| ------------- | --------------------- | ----------------- | --------------------------------- |
| `Text`        | `string?`             | `"Select..."`     | Placeholder with no selections |
| `Options`     | `{string}`            | `{}` if omitted   | Available options              |
| `Default`     | `{string} \| string?` | None              | Initial selection(s); invalid entries are dropped |
| `MaxSelected` | `number?`             | `math.huge`       | Maximum selected entries       |
| `Searchable`  | `boolean?`            | `false`           | Adds search                    |
| `ListOrder`   | `number?`             | `0`               | Layout order                   |
| `Callback`    | `(({string}) -> ())?` | None              | Receives the full selection table |

Selected values display joined with `", "`. The dropdown stays open when toggling a selection. A valid `Default` initializes the selections without invoking `Callback`.

Once `MaxSelected` is reached, clicking an unselected option doesn't add it — but the callback still fires with the unchanged selection.

### Methods

| Method          | Parameters | Returns    | Fires callback? |
| --------------- | ---------- | ---------- | ---------------- |
| `SetVisible`    | `boolean`  | `nil`      | No               |
| `AddOption`     | `string`   | `nil`      | No               |
| `RemoveOption`  | `string`   | `nil`      | No               |
| `SetOptions`    | `{string}` | `nil`      | No               |
| `SetSelected`   | `{string}` | `nil`      | Yes              |
| `GetSelected`   | None       | `{string}` | No               |
| `ClearSelected` | None       | `nil`      | Yes              |
| `Destroy`       | None       | `nil`      | —                |

`SetSelected` replaces the whole selection: unknown values are ignored and it stops adding once `MaxSelected` is hit. It does not deduplicate its input, so pass a list of unique values.

**`GetSelected()` returns the library's actual internal table, and the callback receives that same table** — clone it before mutating (`table.clone(dropdown:GetSelected())`). Mutating it directly bypasses `MaxSelected`, option validation, and UI updates.

## Option Grid

```lua
local optionGrid = section:AddOptionGrid({
	Text = "Sword Selector",
	CellsInFillDirection = 3,
	Options = {
		{
			Name = "Base Sword",
			Icon = "rbxassetid://1234567890",
			Color = Color3.fromRGB(60, 60, 80),
		},
		{
			Name = "Fire Sword",
			Icon = "rbxassetid://1234567891",
		},
	},
	Default = "Base Sword",
	Searchable = true,
	Callback = function(name)
		print(name)
	end,
})

optionGrid:AddOption({
	Name = "Ice Sword",
	Icon = "rbxassetid://1234567892",
})

optionGrid:AddOptions({
	{ Name = "Storm Sword", Icon = "rbxassetid://1234567893" },
	{ Name = "Shadow Sword", Icon = "rbxassetid://1234567894" },
})

optionGrid:RemoveOption("Ice Sword")
optionGrid:SetSelectedOption("Fire Sword")
local selected = optionGrid:GetSelected()
```

### Configuration

| Field                  | Type                 | Default        | Description                          |
| ---------------------- | -------------------- | ---------------- | --------------------------------------- |
| `Text`                 | `string?`            | `"Option Grid"`  | Title shown above the grid            |
| `Options`              | `{OptionGridItem}`   | `{}` if omitted  | Available options, each with `Name`, optional `Icon`, and optional `Color` |
| `Default`              | `string?`            | None             | Initial selection; must match a `Name` in `Options` |
| `Searchable`           | `boolean?`           | `false`          | Adds a search field above the grid, same matching as Dropdown/Multi-Select |
| `CellSizeX` | `UDim?` | `UDim.new(0, 64)` | Cell width; overridden by `CellsInFillDirection` |
| `CellSizeY` | `UDim?` | `UDim.new(0, 64)` without automatic sizing; otherwise matches computed width | Cell height; an explicit value overrides automatic square sizing |
| `CellsInFillDirection` | `number?` | None | Positive finite integer; automatically fits this many cells across a row and overrides `MaxCellsX` |
| `HorizontalAlignment`  | `"Left" \| "Center" \| "Right"?` | `"Left"` | Grid's horizontal alignment within the section |
| `VerticalAlignment`    | `"Top" \| "Center" \| "Bottom"?` | `"Top"`  | Grid's vertical alignment within the section |
| `FillDirectionX`       | `"Left" \| "Right"?` | `"Right"`        | Direction cells fill across a row      |
| `FillDirectionY`       | `"Up" \| "Down"?`    | `"Down"`         | Direction rows stack                   |
| `MaxCellsX`            | `number?`            | None             | Maximum columns per row (see Layout below) |
| `ListOrder`            | `number?`            | `0`              | Layout order                            |
| `Callback`             | `((string) -> ())?`  | None  | Receives the selected option's `Name`  |

Each `Options` entry:

| Field   | Type      | Default                              | Description                              |
| ------- | --------- | --------------------------------------- | ------------------------------------------- |
| `Name`  | `string`  | Required                                | Unique identifier and display text; used as the lookup key for `AddOption`/`RemoveOption`/`SetSelectedOption`, so keep values unique |
| `Icon`  | `string?` | None                                     | Asset ID for the cell's image. If present, `Name` renders as a label docked to the bottom-center of the cell. If absent, `Name` renders centered in the cell instead |
| `Color` | `Color3?` | Theme `Element` color                   | Cell background color                     |

A valid `Default` initializes the selection without invoking `Callback`. An unmatched `Default` logs a warning and leaves the grid with nothing selected rather than erroring.

### Layout

The grid fills horizontally. `FillDirectionX` and `FillDirectionY` select the starting corner and direction; they do not switch the layout to vertical filling.

With `CellsInFillDirection = n`, cell width is calculated as `(gridWidth - 8 - 6 * (n - 1)) / n`, with a minimum of 1 pixel. The grid has 4-pixel outer padding on each side and 6-pixel gaps. Width calculations use the scroll frame's full width, independently of scrollbar visibility, so a scrollbar appearing cannot repeatedly shrink and enlarge square cells. Extremely narrow containers cannot fit arbitrary counts once cells reach the 1-pixel minimum.

When `CellSizeY` is omitted, automatic sizing makes cells square and updates both dimensions on resize. Provide `CellSizeY` to keep automatic widths with a custom height:

```lua
local flatGrid = section:AddOptionGrid({
	Text = "Mode",
	CellsInFillDirection = 3,
	CellSizeY = UDim.new(0, 28),
	Options = {
		{ Name = "Normal" },
		{ Name = "Fast" },
		{ Name = "Precise" },
	},
})
```

Without `CellsInFillDirection`, `CellSizeX` and `CellSizeY` supply the `UIGridLayout.CellSize` dimensions directly, including their scale and offset components. `MaxCellsX` only limits the number of cells per row; it does not stretch cells. For manually sized rectangular cells:

```lua
local customGrid = section:AddOptionGrid({
	Text = "Custom Cells",
	CellSizeX = UDim.new(0, 90),
	CellSizeY = UDim.new(0, 28),
	MaxCellsX = 3,
	Options = {
		{ Name = "One" },
		{ Name = "Two" },
		{ Name = "Three" },
	},
})
```

The expanded cell viewport is capped at 200 pixels high, with an additional 38 pixels for search when enabled. Offset-only heights use the calculated row count, gaps, and outer padding; a nonzero `CellSizeY.Scale` uses the full 200-pixel viewport to give relative heights a stable reference. Content exceeding the viewport scrolls vertically. Resizing recalculates the open dropdown's height.

Automatic sizing applies to the dropdown cells, not the selected-option preview in the header. The preview continues to use the configured dimension offsets, defaulting to 64 pixels per axis.

**Migration:** `CellSize` is no longer a supported configuration field. Replace `CellSize = UDim2.new(xScale, xOffset, yScale, yOffset)` with `CellSizeX = UDim.new(xScale, xOffset)` and `CellSizeY = UDim.new(yScale, yOffset)`. Omit `CellSizeY` when using `CellsInFillDirection` if you want automatic squares.

### Methods

| Method              | Parameters      | Returns   | Fires callback? |
| ------------------- | --------------- | --------- | ---------------- |
| `SetVisible`        | `boolean`       | `nil`     | No               |
| `AddOption`         | `OptionGridItem` | `nil`    | No               |
| `AddOptions`        | `{OptionGridItem}` | `nil`  | No — adds many options and rebuilds the grid once; use this instead of calling `AddOption` in a loop for large batches |
| `RemoveOption`      | `string`        | `nil`     | No — if the removed option was selected, selection clears silently |
| `SetSelectedOption` | `string`        | `nil`     | Yes, if the option exists (silently ignored otherwise) |
| `GetSelected`       | None            | `string?` | No               |
| `Destroy`           | None            | `nil`     | —                |

When `Searchable = true`, matching is case-insensitive substring search, same as Dropdown.

## TextBox

```lua
local input = section:AddTextBox({
	Text = "Username",
	PlaceHolder = "Type here...",
	Callback = function(text)
		print(text)
	end,
})

input:SetText("Simplism")
local text = input:GetText()
```

### Configuration

| Field         | Type                | Default          |
| ------------- | ------------------- | ----------------- |
| `Text`        | `string?`           | `"Input"`         |
| `PlaceHolder` | `string?`           | `"Type here..."`  |
| `ListOrder`   | `number?`           | `0`               |
| `Callback`    | `((string) -> ())?` | None              |

There's no field for initial input text — the input starts empty. The callback fires on focus loss (Enter is not required) and on `SetText`, but not during construction. The control widens into a two-line layout automatically if the title no longer fits alongside the input.

### Methods

`SetVisible(boolean)`, `SetText(string)`, `GetText()` → `string`, `Destroy()`

### Exposed instances

`Frame` (`Frame`), `TextBox` (`TextBox`)

## Keybind

```lua
local keybind = section:AddKeybind({
	Text = "Open Menu",
	Default = Enum.KeyCode.F,
	Clearable = true,
	ListenForInputEnded = false,
	Callback = function(key)
		print("Binding:", key)
	end,
	InputPressedCallback = function(key)
		print("Pressed:", key)
	end,
})

keybind:SetInput(Enum.KeyCode.G)
local key = keybind:GetInput()
```

### Configuration

| Field                  | Type                       | Default     | Description                        |
| ---------------------- | -------------------------- | ------------- | ------------------------------------ |
| `Text`                 | `string?`                  | `"Keybind"`   | Label                              |
| `Default`              | `Enum.KeyCode?`            | `nil`         | Initial key                        |
| `ListOrder`            | `number?`                  | `0`           | Layout order                       |
| `Clearable`            | `boolean?`                 | `false`       | Shows a clear (`×`) button          |
| `ListenForInputEnded`  | `boolean?`                 | `false`       | Capture the new key on release rather than press |
| `Callback`             | `((Enum.KeyCode?) -> ())?` | None          | Runs when the binding changes      |
| `InputPressedCallback` | `((Enum.KeyCode) -> ())?`  | None          | Runs when the bound key is pressed |

The initial `Default` does not invoke `Callback`. Rebinding is keyboard-only; `Escape` cancels. `InputPressedCallback` never fires while rebinding and ignores `gameProcessed` input.

`keybind:ClearInput()` works regardless of `Clearable` — that option only controls whether the visible clear button is shown, and clearing invokes `Callback(nil)`.

### Methods

| Method                    | Parameters                 | Returns          |
| ------------------------- | --------------------------- | ------------------ |
| `SetVisible`              | `boolean`                   | `nil`              |
| `SetInput`                | `Enum.KeyCode?`              | `nil`              |
| `GetInput`                | None                        | `Enum.KeyCode?`    |
| `ClearInput`              | None                        | `nil`              |
| `SetInputPressedCallback` | `((Enum.KeyCode) -> ())?`    | `nil`              |
| `Destroy`                 | None                        | `nil`              |

`SetInput` and `ClearInput` fire `Callback`. `SetInputPressedCallback` replaces the pressed-key callback without invoking it.

### Exposed instances

`Frame` (`Frame`), `Button` (`TextButton`), `Label` (`TextLabel`)

## Color Picker

```lua
local picker = section:AddColorPicker({
	Text = "Accent Color",
	Default = Color3.fromRGB(88, 101, 242),
	Callback = function(color)
		print(color)
	end,
})

picker:SetColor(Color3.fromRGB(255, 100, 100))
local color = picker:GetColor()
```

### Configuration

| Field       | Type                | Default                      |
| ----------- | ------------------- | ------------------------------- |
| `Text`      | `string?`           | `"Color"`                       |
| `Default`   | `Color3?`           | `Color3.fromRGB(255, 0, 0)`     |
| `ListOrder` | `number?`           | `0`                              |
| `Callback`  | `((Color3) -> ())?` | None                             |

The initial default does not invoke the callback.

Opening the picker shows a saturation/value field, a hue strip, HSV/RGB/HEX text inputs, and preset swatches (see Preset Colors below). Hue accepts `0–360`; saturation, value, and RGB channels accept `0–100`/`0–255` respectively and are clamped. HEX accepts `RGB`, `#RGB`, `RRGGBB`, or `#RRGGBB` (case-insensitive); invalid text reverts to the current color. The callback fires on any change — dragging, valid text input, preset selection, or `SetColor`.

Only one picker panel can be open per window; opening another, or clicking outside, closes the current one. The panel positions itself near the picker element and adapts if there isn't room.

### Methods

`SetVisible(boolean)`, `SetColor(Color3)`, `GetColor()` → `Color3`, `Destroy()`

### Exposed instances

`Frame` (`Frame`), `Preview` (`Frame`), `Title` (`TextLabel`), `Window` (the owning window object)

# Theming

```lua
Library:SetTheme({
	Accent = Color3.fromRGB(120, 90, 255),
	AccentHover = Color3.fromRGB(145, 120, 255),
	Background = Color3.fromRGB(20, 20, 28),
})
```

`SetTheme` requires a table, warns on unknown keys, and does not validate that supplied values are actually `Color3`s (bad values can cause later property/tween errors). **It does not repaint already-created UI** — set the theme before constructing windows and elements for consistent styling; some already-created elements may still pick up new values later since some tween paths read the palette at interaction time.

### Theme properties

| Property             | Default                         | Primary usage                         |
| --------------------- | -------------------------------- | ---------------------------------------- |
| `Background`         | `Color3.fromRGB(25, 25, 35)`     | Window/auth backgrounds                |
| `TopBar`              | `Color3.fromRGB(30, 30, 45)`     | Window/auth title bars                 |
| `TabBar`              | `Color3.fromRGB(22, 22, 32)`     | Tab-bar background                      |
| `TabActive`           | `Color3.fromRGB(88, 101, 242)`   | Active tabs                             |
| `TabInactive`         | `Color3.fromRGB(40, 40, 55)`     | Inactive tab controls                   |
| `TabHover`            | `Color3.fromRGB(50, 50, 70)`     | Tab/control hover states                |
| `Section`             | `Color3.fromRGB(32, 32, 48)`     | Section body                            |
| `SectionHeader`       | `Color3.fromRGB(38, 38, 56)`     | Section headers                         |
| `Element`             | `Color3.fromRGB(40, 40, 58)`     | Element surfaces                        |
| `ElementHover`        | `Color3.fromRGB(48, 48, 68)`     | Element hover/listening state           |
| `Accent`              | `Color3.fromRGB(88, 101, 242)`   | Main accent color                       |
| `AccentHover`         | `Color3.fromRGB(108, 121, 255)`  | Accent hover state                      |
| `Text`                | `Color3.fromRGB(220, 220, 235)`  | Primary text                            |
| `TextDim`             | `Color3.fromRGB(140, 140, 165)`  | Secondary text                          |
| `TextMuted`           | `Color3.fromRGB(90, 90, 115)`    | Placeholder/muted text                  |
| `Border`              | `Color3.fromRGB(50, 50, 70)`     | General strokes/borders                 |
| `SliderTrack`         | `Color3.fromRGB(50, 50, 70)`     | Slider track                            |
| `SliderFill`          | `Color3.fromRGB(88, 101, 242)`   | Slider fill                             |
| `ToggleOff`           | `Color3.fromRGB(60, 60, 80)`     | Disabled toggles/checks                 |
| `ToggleOn`            | `Color3.fromRGB(88, 101, 242)`   | Enabled toggles/checks                  |
| `InputBg`             | `Color3.fromRGB(28, 28, 42)`     | Input backgrounds                       |
| `DropdownBg`          | `Color3.fromRGB(28, 28, 42)`     | Dropdown/picker panels                  |
| `DropdownHover`       | `Color3.fromRGB(45, 45, 65)`     | Dropdown option hover                   |
| `Shadow`              | `Color3.fromRGB(0, 0, 0)`        | Window shadow                           |
| `CloseBtn`            | `Color3.fromRGB(255, 75, 75)`    | Close controls                          |
| `CloseBtnHover`       | `Color3.fromRGB(255, 100, 100)`  | Close-control hover                     |
| `NotificationBg`      | `Color3.fromRGB(32, 32, 48)`     | Toast/notification background default   |
| `NotificationBorder`  | `Color3.fromRGB(88, 101, 242)`   | Global notification border default      |

### Toast theme defaults

`Library.Theme` (`{ TextSize = 14, TextColor = Color3.fromRGB(220, 220, 235) }`) supplies default text size/color for `Window:Toast()`. It's independent from the palette above — changing `Library:SetTheme({ Text = ... })` does **not** update `Library.Theme.TextColor`; set both if you want them to match. `Library:Notify()` uses the `Text`/`TextDim` palette directly instead.

# Preset Colors

```lua
Library:SetPresetColors({
	Color3.fromRGB(255, 0, 0),
	Color3.fromRGB(0, 255, 0),
	Color3.fromRGB(0, 0, 255),
	Color3.fromRGB(255, 255, 255),
})
```

SimplismUI includes a default rainbow-style preset palette shown in every color picker. `SetPresetColors` replaces it, stores the table directly (see Notes on ownership), and does not rebuild color pickers that already exist — set presets before constructing pickers that should use them.

# Notifications

SimplismUI has two independent notification systems:

1. `Window:Toast()` — configurable, window-local, stacked toasts.
2. `Library:Notify()` — simpler global bottom-right notifications.

## Window Toasts

```lua
local toast = window:Toast({
	Text = "Settings saved",
	Type = "Success",
	Position = "BottomRight",
	Duration = 4,
})
```

`Window:Toast()` may be called with no configuration table.

### Configuration

| Field              | Type             | Default                    | Description                  |
| ------------------ | ----------------- | ----------------------------- | ------------------------------ |
| `Text`             | `string?`         | `""`                          | Toast text (supports rich text) |
| `Duration`         | `number?`         | `5`                           | Auto-dismiss duration; `0` or negative disables auto-dismiss and the duration bar |
| `Position`         | `ToastPosition?`  | `"Bottom"`                    | `Top`/`TopLeft`/`TopRight`/`Bottom`/`BottomLeft`/`BottomRight`, or a `Vector2` for a custom centered scale position |
| `Type`             | `ToastType?`      | `"Library"`                   | `Library`/`Info`/`Success`/`Warning`/`Error` — sets the default border color |
| `TextSize`         | `number?`         | `Library.Theme.TextSize`      | Text size                     |
| `TextColor`        | `Color3?`         | `Library.Theme.TextColor`     | Text color                     |
| `BackgroundColor`  | `Color3?`         | `NotificationBg`              | Background                     |
| `BorderColor`      | `Color3?`         | Type's default color          | Border/accent                  |
| `ShowDurationBar`  | `boolean?`        | `true`                        | Enables the duration bar        |
| `DurationBarColor` | `Color3?`         | `BorderColor`                 | Duration-bar color              |
| `Dismissible`      | `boolean?`        | `true`                        | Allow mouse/touch dismissal      |
| `MaxWidth`         | `number?`         | `360`                          | Maximum width                    |
| `Spacing`          | `number?`         | `8`                            | Stack spacing                    |
| `SafeAreaPadding`  | `number?`         | `16`                          | Edge padding for named positions |
| `MaxStackSize`     | `number?`         | `8`                            | Maximum toasts stacked at once — oldest is dropped once exceeded |
| `PauseOnHover`     | `boolean?`        | `true`                        | Hovering pauses the countdown and duration bar |

Toasts sharing a position share one stack container; the first active toast at that position effectively sets `Spacing`/`SafeAreaPadding` for the whole stack until it empties — configure those consistently for toasts at the same position.

### Methods

| Method          | Parameters | Returns | Description                                     |
| --------------- | ---------- | ------- | -------------------------------------------------- |
| `Dismiss`       | None       | `nil`   | Plays the exit animation, then removes the toast    |
| `Destroy`       | None       | `nil`   | Removes it immediately                              |
| `ResetDuration` | None       | `nil`   | Restarts its configured duration                    |
| `SetText`       | `string`   | `nil`   | Updates text and recalculates width                 |

A persistent toast: `Duration = 0, Dismissible = false`, removed later with `toast:Dismiss()`.

## Global Notifications

```lua
Library:Notify({
	Title = "Success",
	Content = "Configuration saved.",
	Duration = 3,
})
```

Unlike `Window:Toast`, `Library:Notify` requires a configuration table. It uses a separate shared `NotificationUI` bottom-right container, animates in, can be dismissed by mouse/touch, auto-closes after `Duration`, and does not return a controller object. Its auto-close timer starts immediately at creation (`Window:Toast`'s starts after the entrance animation finishes), so very short durations can dismiss before the entrance/duration-bar animation has fully played.

### Configuration

| Field                     | Type      | Default                    |
| -------------------------- | --------- | ----------------------------- |
| `Title`                   | `string?` | `"Notification"`               |
| `TitleTextSize`           | `number?` | `14`                            |
| `Content`                 | `string?` | `""`                            |
| `ContentTextSize`         | `number?` | `12`                            |
| `Duration`                | `number?` | `3`                              |
| `NotificationColor`       | `Color3?` | Theme `NotificationBg`          |
| `NotificationBorderColor` | `Color3?` | Theme `NotificationBorder`      |
| `TitleTextColor`          | `Color3?` | Theme `Text`                     |
| `ContentTextColor`        | `Color3?` | Theme `TextDim`                  |
| `DurationBarColor`        | `Color3?` | `NotificationBorderColor`       |

# Authentication UI

```lua
local auth = Library:NewAuth({
	Title = "Access",
	GetKey = function()
		print("Provide the key acquisition flow")
	end,
	Auth = function(key)
		return key == "example-key"
	end,
	OnSuccess = function()
		print("Authenticated")
	end,
})
```

The configuration table is optional.

### Configuration

| Field       | Type                 | Default         | Description                          |
| ----------- | --------------------- | ------------------ | --------------------------------------- |
| `Title`     | `string?`             | `"Key System"`     | UI title                              |
| `GetKey`    | `(() -> ())?`         | None               | Runs (via `task.spawn`) when `GET KEY` is pressed |
| `Auth`      | `((string) -> any)?`  | None               | Validates the entered key; a truthy return means success. Without this, activation always fails |
| `OnSuccess` | `(() -> ())?`         | None               | Runs after successful authentication  |

Pressing `ACTIVATE` calls `Auth(key)` (wrapped in `pcall`, so a thrown error counts as failure) in a spawned task; on success it shows a success state, waits briefly, then runs `OnSuccess` and closes the UI. `Auth` must be a real Luau function — a C function is rejected at construction.

Returns `{ Close = closeFunction }`. `Close()` animates the UI out and destroys it. Authentication UI is **not** tracked with normal windows — `Library:Unload()` does not close it; call `Close()` yourself.

# Cleanup

- `element:Destroy()` — removes that element and its UI, disconnecting its own connections.
- `section:Destroy()` — destroys its tracked elements, connections, and frame.
- `window:Destroy()` — destroys tracked tabs/sections, window-local toasts, and connections; closes any open color picker. If SimplismUI created the window's `ScreenGui`, that `ScreenGui` is destroyed too; if you supplied your own via `Parent`, it's preserved.
- `Library:Unload()` — destroys every tracked window, the global `NotificationUI`, clears the active-window list, and resets preset colors to SimplismUI's defaults. It does **not** reset theme colors set via `SetTheme`, does **not** reset `Library.Theme`, and does **not** close authentication UI (use its `Close()`).

# Complete Example

```lua
local Library = require(script.Parent.SimplismUI)

local window = Library:Window({
	Title = "SimplismUI",
	TabBarLocation = "Left",
	ToggleKeybind = Enum.KeyCode.RightShift,
})

local mainTab = window:AddTab({ Title = "Main", Columns = 3 })
local section = mainTab[1]:NewSection({ Title = "Settings" })
local selection = mainTab[2]:NewSection({ Title = "Selection" })
local actions = mainTab[3]:NewSection({ Title = "Actions" })

local statusLabel = section:AddLabel({ Text = "Status: Ready" })

section:AddToggle({
	Text = "Enabled",
	Default = false,
	Callback = function(enabled)
		statusLabel:SetText(enabled and "Status: Enabled" or "Status: Disabled")
	end,
})

section:AddSlider({
	Text = "Power",
	Min = 0,
	Max = 100,
	Default = 50,
	Increment = 5,
	Callback = function(value)
		print("Power:", value)
	end,
})

selection:AddDropdown({
	Text = "Mode",
	Options = { "Normal", "Fast", "Precise" },
	Searchable = true,
	Callback = function(mode)
		print("Mode:", mode)
	end,
})

selection:AddOptionGrid({
	Text = "Profile",
	CellsInFillDirection = 3,
	CellSizeY = UDim.new(0, 28),
	Options = {
		{ Name = "One" },
		{ Name = "Two" },
		{ Name = "Three" },
	},
	Callback = function(name)
		print("Profile:", name)
	end,
})

actions:AddButton({
	Text = "Save",
	Callback = function()
		window:Toast({
			Text = "Settings saved",
			Type = "Success",
			Position = "BottomRight",
		})
	end,
})
```

# Edge Cases & Notes

**Silent defaults.** Dropdown, multi-select dropdown, and Option Grid defaults initialize their selections without invoking `Callback`. Slider defaults are also silent, including `Default = 0/0` (NaN). User interactions and callback-firing programmatic setters retain their documented behavior; explicitly invoke your application logic if it must run once for initial values.

**Slider `NaN`.** Explicitly setting a slider to NaN (`slider:SetValue(0/0)`) puts it in a special state: `GetValue()` returns NaN, the display shows `"nan"`, and the callback receives NaN. This is only reachable by deliberately passing NaN.

**Multi-select internal table.** `GetSelected()` returns the library's live internal table (the callback gets the same reference) — clone before mutating externally.

**Preset table ownership.** `SetPresetColors` stores your table by reference, and `Library:Unload()` clears and repopulates the active preset table with defaults — which mutates your table if you passed it directly. Pass `table.clone(myPresets)` if you need to keep your own copy independent.

**Color picker switching quickly.** Opening a new picker while another is closing can occasionally leave the shared dimming overlay hidden while the new picker is still open; the picker itself still works normally.

**Duplicate dropdown option strings.** Options are used as internal lookup keys — keep them unique, especially when using search, multi-select, or dynamic option changes.

**Theme value types aren't validated.** `SetTheme` checks for unknown keys but not that values are actually `Color3`s; bad values can cause errors later when a tween or property assignment runs.

**`AddOption` in a loop is O(n²).** Each `AddOption` call rebuilds the entire grid (destroying and recreating every existing cell), so adding options one at a time in a loop costs quadratic time as the list grows. Use `AddOptions` to add many options in one rebuild.
