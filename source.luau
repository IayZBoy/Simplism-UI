local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local UD2_N = UDim2.new
local C3_FRGB = Color3.fromRGB

local Library = {}

local COLORS = {
	Background = Color3.fromRGB(25, 25, 35),
	TopBar = Color3.fromRGB(30, 30, 45),
	TabBar = Color3.fromRGB(22, 22, 32),
	TabActive = Color3.fromRGB(88, 101, 242),
	TabInactive = Color3.fromRGB(40, 40, 55),
	TabHover = Color3.fromRGB(50, 50, 70),
	Section = Color3.fromRGB(32, 32, 48),
	SectionHeader = Color3.fromRGB(38, 38, 56),
	Element = Color3.fromRGB(40, 40, 58),
	ElementHover = Color3.fromRGB(48, 48, 68),
	Accent = Color3.fromRGB(88, 101, 242),
	AccentHover = Color3.fromRGB(108, 121, 255),
	Text = Color3.fromRGB(220, 220, 235),
	TextDim = Color3.fromRGB(140, 140, 165),
	TextMuted = Color3.fromRGB(90, 90, 115),
	Border = Color3.fromRGB(50, 50, 70),
	SliderTrack = Color3.fromRGB(50, 50, 70),
	SliderFill = Color3.fromRGB(88, 101, 242),
	ToggleOff = Color3.fromRGB(60, 60, 80),
	ToggleOn = Color3.fromRGB(88, 101, 242),
	InputBg = Color3.fromRGB(28, 28, 42),
	DropdownBg = Color3.fromRGB(28, 28, 42),
	DropdownHover = Color3.fromRGB(45, 45, 65),
	Shadow = Color3.fromRGB(0, 0, 0),
	CloseBtn = Color3.fromRGB(255, 75, 75),
	CloseBtnHover = Color3.fromRGB(255, 100, 100),
	NotificationBg = Color3.fromRGB(32, 32, 48),
	NotificationBorder = Color3.fromRGB(88, 101, 242),
}

local PRESET_COLORS = {
	Color3.fromRGB(255, 0, 0),
	Color3.fromRGB(255, 85, 0),
	Color3.fromRGB(255, 170, 0),
	Color3.fromRGB(255, 255, 0),
	Color3.fromRGB(170, 255, 0),
	Color3.fromRGB(85, 255, 0),
	Color3.fromRGB(0, 255, 0),
	Color3.fromRGB(0, 255, 85),
	Color3.fromRGB(0, 255, 170),
	Color3.fromRGB(0, 255, 255),
	Color3.fromRGB(0, 170, 255),
	Color3.fromRGB(0, 85, 255),
	Color3.fromRGB(0, 0, 255),
	Color3.fromRGB(85, 0, 255),
	Color3.fromRGB(170, 0, 255),
	Color3.fromRGB(255, 0, 255),
	Color3.fromRGB(255, 0, 170),
	Color3.fromRGB(255, 0, 85),
	Color3.fromRGB(255, 255, 255),
	Color3.fromRGB(190, 190, 190),
	Color3.fromRGB(128, 128, 128),
	Color3.fromRGB(64, 64, 64),
	Color3.fromRGB(32, 32, 32),
	Color3.fromRGB(0, 0, 0),
}

type ThemeColors = {
	Background: Color3?,
	TopBar: Color3?,
	TabBar: Color3?,
	TabActive: Color3?,
	TabInactive: Color3?,
	TabHover: Color3?,
	Section: Color3?,
	SectionHeader: Color3?,
	Element: Color3?,
	ElementHover: Color3?,
	Accent: Color3?,
	AccentHover: Color3?,
	Text: Color3?,
	TextDim: Color3?,
	TextMuted: Color3?,
	Border: Color3?,
	SliderTrack: Color3?,
	SliderFill: Color3?,
	ToggleOff: Color3?,
	ToggleOn: Color3?,
	InputBg: Color3?,
	DropdownBg: Color3?,
	DropdownHover: Color3?,
	Shadow: Color3?,
	CloseBtn: Color3?,
	CloseBtnHover: Color3?,
	NotificationBg: Color3?,
	NotificationBorder: Color3?,
}

type SectionConfig = {
	Title: string?,
	StartCollapsed: boolean?,
	ListConfig: { [string]: any }?,
}

type ButtonConfig = {
	Text: string?,
	ListOrder: number?,
	Callback: (() -> ())?,
}

type ButtonElement = {
	Frame: Frame,
	Button: TextButton,
	SetVisible: (self: ButtonElement, visible: boolean) -> (),
	SetText: (self: ButtonElement, text: string) -> (),
	Destroy: (self: ButtonElement) -> (),
}

type SliderConfig = {
	Text: string?,
	Min: number?,
	Max: number?,
	Default: number?,
	Increment: number?,
	Decimals: number?,
	ListOrder: number?,
	Callback: ((number) -> ())?,
}

type SliderElement = {
	Frame: Frame,
	SetVisible: (self: SliderElement, visible: boolean) -> (),
	SetValue: (self: SliderElement, num: number) -> (),
	GetValue: (self: SliderElement) -> number,
	Destroy: (self: SliderElement) -> (),
}

type ToggleConfig = {
	Text: string?,
	Default: boolean?,
	ListOrder: number?,
	Callback: ((boolean) -> ())?,
}

type ToggleElement = {
	Frame: Frame,
	Label: TextLabel,
	SetVisible: (self: ToggleElement, visible: boolean) -> (),
	SetValue: (self: ToggleElement, val: boolean) -> (),
	GetValue: (self: ToggleElement) -> boolean,
	Destroy: (self: ToggleElement) -> (),
}

type LabelConfig = {
	Text: string?,
	ListOrder: number?,
}

type LabelElement = {
	Frame: Frame,
	Label: TextLabel,
	SetVisible: (self: LabelElement, visible: boolean) -> (),
	SetText: (self: LabelElement, text: string) -> (),
	GetText: (self: LabelElement) -> string,
	Destroy: (self: LabelElement) -> (),
}

type DropdownConfig = {
	Text: string?,
	Options: { string },
	Searchable: boolean?,
	ListOrder: number?,
	Callback: ((string) -> ())?,
}

type DropdownElement = {
	Frame: Frame,
	Label: TextLabel,
	SetVisible: (self: DropdownElement, visible: boolean) -> (),
	AddOption: (self: DropdownElement, option: string) -> (),
	RemoveOption: (self: DropdownElement, option: string) -> (),
	SetOptions: (self: DropdownElement, list: { string }) -> (),
	SetSelectedOption: (self: DropdownElement, option: string) -> (),
	GetSelected: (self: DropdownElement) -> string?,
	Destroy: (self: DropdownElement) -> (),
}

type MultiSelectDropdownConfig = {
	Text: string?,
	Options: { string },
	MaxSelected: number?,
	Searchable: boolean?,
	ListOrder: number?,
	Callback: (({ string }) -> ())?,
}

type MultiSelectDropdownElement = {
	Frame: Frame,
	Label: TextLabel,
	SetVisible: (self: MultiSelectDropdownElement, visible: boolean) -> (),
	AddOption: (self: MultiSelectDropdownElement, option: string) -> (),
	RemoveOption: (self: MultiSelectDropdownElement, option: string) -> (),
	SetOptions: (self: MultiSelectDropdownElement, list: { string }) -> (),
	SetSelected: (self: MultiSelectDropdownElement, list: { string }) -> (),
	GetSelected: (self: MultiSelectDropdownElement) -> { string },
	ClearSelected: (self: MultiSelectDropdownElement) -> (),
	Destroy: (self: MultiSelectDropdownElement) -> (),
}

type TextBoxConfig = {
	Text: string?,
	PlaceHolder: string?,
	ListOrder: number?,
	Callback: ((string) -> ())?,
}

type TextBoxElement = {
	Frame: Frame,
	TextBox: TextBox,
	SetVisible: (self: TextBoxElement, visible: boolean) -> (),
	SetText: (self: TextBoxElement, text: string) -> (),
	GetText: (self: TextBoxElement) -> string,
	Destroy: (self: TextBoxElement) -> (),
}

type KeyInputConfig = {
	Text: string?,
	Default: Enum.KeyCode?,
	ListOrder: number?,
	Clearable: boolean?,
	ListenForInputEnded: boolean?,
	Callback: ((Enum.KeyCode?) -> ())?,
}

type KeyInputElement = {
	Frame: Frame,
	Button: TextButton,
	Label: TextLabel,
	_CurrentKey: Enum.KeyCode?,
	ListenForInputEnded: boolean,
	Clearable: boolean,
	SetVisible: (self: KeyInputElement, visible: boolean) -> (),
	SetInput: (self: KeyInputElement, key: Enum.KeyCode?) -> (),
	GetInput: (self: KeyInputElement) -> Enum.KeyCode?,
	ClearInput: (self: KeyInputElement) -> (),
	Destroy: (self: KeyInputElement) -> (),
}

type ColorPickerConfig = {
	Text: string?,
	Default: Color3?,
	ListOrder: number?,
	Callback: ((Color3) -> ())?,
}

type ColorPickerElement = {
	Frame: Frame,
	Preview: Frame,
	Title: TextLabel,
	Window: any,
	SetVisible: (self: ColorPickerElement, visible: boolean) -> (),
	SetColor: (self: ColorPickerElement, color: Color3) -> (),
	GetColor: (self: ColorPickerElement) -> Color3,
	_Close: (self: ColorPickerElement) -> (),
	Destroy: (self: ColorPickerElement) -> (),
}

type TabConfig = {
	Title: string?,
}

type SectionObject = {
	Title: string,
	Visible: boolean,
	Collapsed: boolean,
	Frame: Frame,
	Header: TextButton,
	ContentHolder: Frame,
	Elements: { any },
	Tab: any,
	Window: any,
	SetVisible: (self: SectionObject, visible: boolean) -> (),
	AddButton: (self: SectionObject, config: ButtonConfig) -> ButtonElement,
	AddSlider: (self: SectionObject, config: SliderConfig) -> SliderElement,
	AddToggle: (self: SectionObject, config: ToggleConfig) -> ToggleElement,
	AddLabel: (self: SectionObject, config: LabelConfig) -> LabelElement,
	AddDropdown: (self: SectionObject, config: DropdownConfig) -> DropdownElement,
	AddMultiSelectDropdown: (self: SectionObject, config: MultiSelectDropdownConfig) -> MultiSelectDropdownElement,
	AddTextBox: (self: SectionObject, config: TextBoxConfig) -> TextBoxElement,
	AddColorPicker: (self: SectionObject, config: ColorPickerConfig) -> ColorPickerElement,
	AddKeybind: (self: SectionObject, config: KeyInputConfig) -> KeyInputElement,
}

type TabObject = {
	Title: string,
	Active: boolean,
	Visible: boolean,
	Button: TextButton,
	ButtonLabel: TextLabel,
	ContentCanvas: CanvasGroup,
	ScrollFrame: ScrollingFrame,
	Sections: { SectionObject },
	Window: any,
	NewSection: (self: TabObject, config: SectionConfig) -> SectionObject,
	SetActive: (self: TabObject, active: boolean) -> (),
	SetVisible: (self: TabObject, visible: boolean) -> (),
}

type VisibilityButtonConfig = {
	Button: TextButton | ImageButton,
	ShowText: string?,
	HideText: string?,
}

type WindowConfig = {
	Title: string?,
	Size: UDim2?,
	OverrideSize: boolean?,
	Parent: ScreenGui?,
	StartVisible: boolean?,
}

type WindowObject = {
	Title: string,
	Size: UDim2,
	IsOpen: boolean,
	IsMinimized: boolean,
	Tabs: { TabObject },
	ActiveTab: TabObject?,
	MainFrame: CanvasGroup,
	MainFrameStroke: UIStroke,
	ScreenGui: ScreenGui,
	TopBar: Frame,
	TitleLabel: TextLabel,
	TabBar: Frame,
	TabScroller: ScrollingFrame,
	TabHolder: Frame,
	ContentArea: Frame,
	ColorPickerShadow: Frame,
	ShowText: string,
	HideText: string,
	AddTab: (self: WindowObject, config: TabConfig) -> TabObject,
	SwitchTab: (self: WindowObject, tab: TabObject) -> (),
	SetVisible: (self: WindowObject, visible: boolean?) -> (),
	Toggle: (self: WindowObject) -> (),
	Minimize: (self: WindowObject) -> (),
	AttachVisibilityButton: (self: WindowObject, config: VisibilityButtonConfig) -> (),
	Destroy: (self: WindowObject) -> (),
}

type NotifyConfig = {
	Title: string?,
	TitleTextSize: number?,
	Content: string?,
	ContentTextSize: number?,
	Duration: number?,
	NotificationColor: Color3?,
	NotificationBorderColor: Color3?,
	TitleTextColor: Color3?,
	ContentTextColor: Color3?,
	DurationBarColor: Color3?,
}

type NewAuthConfig = {
	Title: string?,
	GetKey: (() -> ())?,
	Auth: ((string) -> any)?,
	Freeze: boolean?,
}

local function CalculateWindowSize()
	local screenSize = workspace.CurrentCamera.ViewportSize
	local idealWidth = 460
	local idealHeight = 520
	if screenSize.X >= 1200 then
		return UD2_N(0, idealWidth, 0, idealHeight)
	end
	local paddingX = 20
	local paddingY = 40
	local availableWidth = screenSize.X - paddingX
	local availableHeight = screenSize.Y - paddingY
	local scale = math.min(1, availableWidth / idealWidth, availableHeight / idealHeight)
	local width = math.max(math.floor(idealWidth * scale), 240)
	local height = math.max(math.floor(idealHeight * scale), 240)
	width = math.clamp(width, 240, availableWidth)
	height = math.clamp(height, 240, availableHeight)
	return UD2_N(0, width, 0, height)
end

local function Create(className, props, children)
	local inst = Instance.new(className)
	for k, v in (props or {}) do
		inst[k] = v
	end
	for _, child in (children or {}) do
		child.Parent = inst
	end
	return inst
end

local function Tween(obj, duration, props, style, direction)
	local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

local function AddCorner(parent, radius)
	return Create("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = parent })
end

local function AddStroke(parent, color, thickness)
	return Create("UIStroke", { Color = color or COLORS.Border, Thickness = thickness or 1, Parent = parent })
end

local function AddPadding(parent, all)
	local padding = all or 8
	return Create("UIPadding", {
		PaddingTop = UDim.new(0, padding),
		PaddingBottom = UDim.new(0, padding),
		PaddingLeft = UDim.new(0, padding),
		PaddingRight = UDim.new(0, padding),
		Parent = parent,
	})
end

local function AddListLayout(parent, padding, direction, sortOrder)
	return Create("UIListLayout", {
		Padding = UDim.new(0, padding or 6),
		FillDirection = direction or Enum.FillDirection.Vertical,
		SortOrder = sortOrder or Enum.SortOrder.LayoutOrder,
		Parent = parent,
	})
end

local function Clamp01(n)
	return math.clamp(n, 0, 1)
end

local function Lerp(a, b, t)
	return a + (b - a) * t
end

local function RoundTo(value, increment)
	if increment == 0 then return value end
	return math.floor(value / increment + 0.5) * increment
end

local function Color3ToHex(c)
	return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end

local function HexToColor3(hex)
	hex = hex:gsub("#", "")
	if #hex == 3 then
		hex = hex:sub(1, 1):rep(2) .. hex:sub(2, 2):rep(2) .. hex:sub(3, 3):rep(2)
	end
	if #hex ~= 6 then return nil end
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)
	if not r or not g or not b then return nil end
	return C3_FRGB(r, g, b)
end

local function Color3ToHSV(c)
	return c:ToHSV()
end

local function HSVToColor3(h, s, v)
	return Color3.fromHSV(h, s, v)
end

local function FormatNumber(value, decimals)
	decimals = decimals or 2
	if math.floor(value) == value then
		return tostring(value)
	end
	return string.format("%." .. decimals .. "f", value)
end

local Maid = {}
Maid.__index = Maid

function Maid.new()
	return setmetatable({ _list = {} }, Maid)
end

function Maid:Add(item)
	table.insert(self._list, item)
	return item
end

function Maid:Destroy()
	for _, item in self._list do
		if typeof(item) == "RBXScriptConnection" then
			item:Disconnect()
		end
	end
	table.clear(self._list)
end

local ButtonElement = {}
ButtonElement.__index = ButtonElement

function ButtonElement.new(section, config: ButtonConfig): ButtonElement
	local self = setmetatable({}, ButtonElement)
	self._maid = Maid.new()

	local frame = section:_CreateElementFrame(config, 36, "Button")
	frame.BackgroundColor3 = COLORS.Accent

	local btn = Create("TextButton", {
		Size = UD2_N(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = config.Text or "Button",
		TextColor3 = C3_FRGB(255, 255, 255),
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		Parent = frame,
	})
	AddCorner(btn, 8)

	self._maid:Add(btn.MouseEnter:Connect(function()
		Tween(frame, 0.2, { BackgroundColor3 = COLORS.AccentHover })
	end))
	self._maid:Add(btn.MouseLeave:Connect(function()
		Tween(frame, 0.2, { BackgroundColor3 = COLORS.Accent })
	end))
	self._maid:Add(btn.MouseButton1Down:Connect(function()
		Tween(frame, 0.1, { Size = UD2_N(1, -4, 0, 34) })
		if config.Callback then
			config.Callback()
		end
	end))
	self._maid:Add(btn.MouseButton1Up:Connect(function()
		Tween(frame, 0.1, { Size = UD2_N(1, 0, 0, 36) })
	end))

	self.Frame = frame
	self.Button = btn
	return self
end

function ButtonElement:SetVisible(visible: boolean)
	self.Frame.Visible = visible
end

function ButtonElement:SetText(text: string)
	self.Button.Text = text
end

function ButtonElement:Destroy()
	self._maid:Destroy()
	if self.Frame and self.Frame.Parent then
		self.Frame:Destroy()
	end
end

local SliderElement = {}
SliderElement.__index = SliderElement

function SliderElement.new(section, config: SliderConfig): SliderElement
	local self = setmetatable({}, SliderElement)
	self._maid = Maid.new()

	local min = config.Min or 0
	local max = config.Max or 100
	local default = config.Default or min
	local increment = config.Increment or 1
	local decimals = config.Decimals or (increment < 1 and 2 or 0)
	local currentValue = default
	local dragging = false

	local frame = section:_CreateElementFrame(config, 50, "Slider")
	AddPadding(frame, 8)

	local topRow = Create("Frame", {
		Size = UD2_N(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Parent = frame,
	})

	Create("TextLabel", {
		Size = UD2_N(0.6, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = config.Text or "Slider",
		TextColor3 = COLORS.Text,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = topRow,
	})

	local valueInputHolder = Create("Frame", {
		Size = UD2_N(0.35, 0, 1, 0),
		Position = UD2_N(0.65, 0, 0, 0),
		BackgroundColor3 = COLORS.InputBg,
		BorderSizePixel = 0,
		Parent = topRow,
	})
	AddCorner(valueInputHolder, 4)
	AddStroke(valueInputHolder, COLORS.Border, 1)

	local valueInput = Create("TextBox", {
		Size = UD2_N(1, -8, 1, 0),
		Position = UD2_N(0, 4, 0, 0),
		BackgroundTransparency = 1,
		Text = FormatNumber(currentValue, decimals),
		TextColor3 = COLORS.Accent,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Right,
		ClearTextOnFocus = false,
		Parent = valueInputHolder,
	})

	local stroke = valueInputHolder:FindFirstChildOfClass("UIStroke")

	local trackHolder = Create("Frame", {
		Size = UD2_N(1, 0, 0, 8),
		Position = UD2_N(0, 0, 0, 28),
		BackgroundColor3 = COLORS.SliderTrack,
		BorderSizePixel = 0,
		Parent = frame,
	})
	AddCorner(trackHolder, 4)

	local fillBar = Create("Frame", {
		Size = UD2_N((default - min) / (max - min), 0, 1, 0),
		BackgroundColor3 = COLORS.SliderFill,
		BorderSizePixel = 0,
		Parent = trackHolder,
	})
	AddCorner(fillBar, 4)

	local knob = Create("Frame", {
		Size = UD2_N(0, 16, 0, 16),
		Position = UD2_N((default - min) / (max - min), -8, 0.5, -8),
		BackgroundColor3 = C3_FRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = trackHolder,
	})
	AddCorner(knob, 8)

	Create("Frame", {
		Size = UD2_N(0, 20, 0, 20),
		Position = UD2_N(0.5, -10, 0.5, -10),
		BackgroundColor3 = COLORS.Accent,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		ZIndex = 1,
		Parent = knob,
	})
	AddCorner(knob:FindFirstChild("Frame"), 10)

	local function updateSlider(ratio)
		ratio = Clamp01(ratio)
		local raw = Lerp(min, max, ratio)
		local rounded = RoundTo(raw, increment)
		rounded = math.clamp(rounded, min, max)
		currentValue = rounded
		local actualRatio = (rounded - min) / (max - min)
		Tween(fillBar, 0.08, { Size = UD2_N(actualRatio, 0, 1, 0) }, Enum.EasingStyle.Linear)
		Tween(knob, 0.08, { Position = UD2_N(actualRatio, -8, 0.5, -8) }, Enum.EasingStyle.Linear)
		valueInput.Text = FormatNumber(rounded, decimals)
		if config.Callback then
			config.Callback(rounded)
		end
	end

	self._maid:Add(valueInput.Focused:Connect(function()
		if stroke then Tween(stroke, 0.2, { Color = COLORS.Accent }) end
	end))

	self._maid:Add(valueInput.FocusLost:Connect(function()
		if stroke then Tween(stroke, 0.2, { Color = COLORS.Border }) end
		local num = tonumber(valueInput.Text)
		if num then
			num = math.clamp(num, min, max)
			num = RoundTo(num, increment)
			local ratio = (num - min) / (max - min)
			updateSlider(ratio)
		else
			valueInput.Text = FormatNumber(currentValue, decimals)
		end
	end))

	self._maid:Add(trackHolder.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			local ratio = Clamp01((input.Position.X - trackHolder.AbsolutePosition.X) / trackHolder.AbsoluteSize.X)
			updateSlider(ratio)
		end
	end))

	self._maid:Add(knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end))

	self._maid:Add(UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local ratio = Clamp01((input.Position.X - trackHolder.AbsolutePosition.X) / trackHolder.AbsoluteSize.X)
			updateSlider(ratio)
		end
	end))

	self._maid:Add(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end))

	self.Frame = frame
	self._updateSlider = updateSlider
	self._min = min
	self._max = max
	self._increment = increment
	self._currentValue = function() return currentValue end
	return self
end

function SliderElement:SetVisible(visible: boolean)
	self.Frame.Visible = visible
end

function SliderElement:SetValue(num: number)
	if type(num) ~= "number" then return end
	num = math.clamp(num, self._min, self._max)
	num = RoundTo(num, self._increment)
	local ratio = (num - self._min) / (self._max - self._min)
	self._updateSlider(ratio)
end

function SliderElement:GetValue(): number
	return self._currentValue()
end

function SliderElement:Destroy()
	self._maid:Destroy()
	if self.Frame and self.Frame.Parent then
		self.Frame:Destroy()
	end
end

local ToggleElement = {}
ToggleElement.__index = ToggleElement

function ToggleElement.new(section, config: ToggleConfig): ToggleElement
	local self = setmetatable({}, ToggleElement)
	self._maid = Maid.new()

	local toggled = config.Default or false
	local frame = section:_CreateElementFrame(config, 36, "Toggle")
	local Padding = AddPadding(frame, 0)

	local label = Create("TextLabel", {
		Size = UD2_N(1, -56, 1, 0),
		BackgroundTransparency = 1,
		Text = config.Text or "Toggle",
		TextColor3 = COLORS.Text,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame,
	})

	local toggleBg = Create("Frame", {
		Size = UD2_N(0, 40, 0, 22),
		Position = UD2_N(1, -47, 0.5, -11),
		BackgroundColor3 = toggled and COLORS.ToggleOn or COLORS.ToggleOff,
		BorderSizePixel = 0,
		Parent = frame,
	})
	AddCorner(toggleBg, 11)

	local toggleCircle = Create("Frame", {
		Size = UD2_N(0, 16, 0, 16),
		Position = toggled and UD2_N(0, 21, 0.5, -8) or UD2_N(0, 3, 0.5, -8),
		BackgroundColor3 = C3_FRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = toggleBg,
	})
	AddCorner(toggleCircle, 8)

	local btn = Create("TextButton", {
		Size = UD2_N(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		Parent = frame,
	})

	Padding.PaddingLeft = UDim.new(0, 12)

	local function setState(val, noCallback)
		toggled = not not val
		if toggled then
			Tween(toggleBg, 0.3, { BackgroundColor3 = COLORS.ToggleOn })
			Tween(toggleCircle, 0.3, { Position = UD2_N(0, 21, 0.5, -8) })
		else
			Tween(toggleBg, 0.3, { BackgroundColor3 = COLORS.ToggleOff })
			Tween(toggleCircle, 0.3, { Position = UD2_N(0, 3, 0.5, -8) })
		end
		if config.Callback and not noCallback then
			config.Callback(toggled)
		end
	end

	self._maid:Add(btn.MouseButton1Click:Connect(function()
		setState(not toggled)
	end))

	self.Frame = frame
	self.Label = label
	self._setState = setState
	self._getToggled = function() return toggled end
	return self
end

function ToggleElement:SetVisible(visible: boolean)
	self.Frame.Visible = visible
end

function ToggleElement:SetValue(val: boolean)
	self._setState(val)
end

function ToggleElement:GetValue(): boolean
	return self._getToggled()
end

function ToggleElement:Destroy()
	self._maid:Destroy()
	if self.Frame and self.Frame.Parent then
		self.Frame:Destroy()
	end
end

local LabelElement = {}
LabelElement.__index = LabelElement

function LabelElement.new(section, config: LabelConfig): LabelElement
	local self = setmetatable({}, LabelElement)
	self._maid = Maid.new()

	local frame = section:_CreateElementFrame(config, 28, "Label")
	frame.BackgroundTransparency = 1

	local txt = Create("TextLabel", {
		Size = UD2_N(1, -16, 1, 0),
		Position = UD2_N(0, 8, 0, 0),
		BackgroundTransparency = 1,
		Text = config.Text or "Label",
		TextColor3 = COLORS.TextDim,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame,
	})

	self.Frame = frame
	self.Label = txt
	return self
end

function LabelElement:SetVisible(visible: boolean)
	self.Frame.Visible = visible
end

function LabelElement:SetText(text: string)
	self.Label.Text = text
end

function LabelElement:GetText(): string
	return self.Label.Text
end

function LabelElement:Destroy()
	self._maid:Destroy()
	if self.Frame and self.Frame.Parent then
		self.Frame:Destroy()
	end
end

local DropdownElement = {}
DropdownElement.__index = DropdownElement

function DropdownElement.new(section, config: DropdownConfig): DropdownElement
	local self = setmetatable({}, DropdownElement)
	self._maid = Maid.new()

	local options = {}
	for _, v in (config.Options or {}) do
		table.insert(options, v)
	end
	local selected = nil
	local isOpen = false
	local searchable = config.Searchable ~= nil and config.Searchable or false
	local searchQuery = ""

	local frame = Create("Frame", {
		Name = "Dropdown",
		Size = UD2_N(1, 0, 0, 36),
		BackgroundColor3 = COLORS.Element,
		BorderSizePixel = 0,
		LayoutOrder = config.ListOrder or 0,
		ClipsDescendants = false,
		Parent = section.ContentHolder,
	})
	AddCorner(frame, 8)

	local mainBtn = Create("TextButton", {
		Size = UD2_N(1, 0, 0, 36),
		BackgroundTransparency = 1,
		Text = "",
		Parent = frame,
	})

	local label = Create("TextLabel", {
		Size = UD2_N(1, -40, 1, 0),
		Position = UD2_N(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text = config.Text or "Select...",
		TextColor3 = COLORS.Text,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = mainBtn,
	})

	local arrow = Create("TextLabel", {
		Size = UD2_N(0, 20, 0, 20),
		Position = UD2_N(1, -30, 0.5, -10),
		BackgroundTransparency = 1,
		Text = "▼",
		TextColor3 = COLORS.TextDim,
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		Parent = mainBtn,
	})

	local dropFrame = Create("Frame", {
		Name = "DropFrame",
		Size = UD2_N(1, 0, 0, 0),
		Position = UD2_N(0, 0, 0, 38),
		BackgroundColor3 = COLORS.DropdownBg,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 10,
		Visible = false,
		Parent = frame,
	})
	AddCorner(dropFrame, 8)
	local dropStroke = AddStroke(dropFrame, COLORS.Border, 1)
	dropStroke.Transparency = 1

	local searchBox
	if searchable then
		local searchHolder = Create("Frame", {
			Size = UD2_N(1, -8, 0, 30),
			Position = UD2_N(0, 4, 0, 4),
			BackgroundColor3 = COLORS.InputBg,
			BorderSizePixel = 0,
			ZIndex = 11,
			Parent = dropFrame,
		})
		AddCorner(searchHolder, 6)
		AddStroke(searchHolder, COLORS.Border, 1)

		searchBox = Create("TextBox", {
			Size = UD2_N(1, -12, 1, 0),
			Position = UD2_N(0, 6, 0, 0),
			BackgroundTransparency = 1,
			Text = "",
			PlaceholderText = "Search...",
			PlaceholderColor3 = COLORS.TextMuted,
			TextColor3 = COLORS.Text,
			TextSize = 12,
			Font = Enum.Font.GothamMedium,
			TextXAlignment = Enum.TextXAlignment.Left,
			ClearTextOnFocus = false,
			ZIndex = 12,
			Parent = searchHolder,
		})
	end

	local dropScroll = Create("ScrollingFrame", {
		Size = searchable and UD2_N(1, 0, 1, -38) or UD2_N(1, 0, 1, 0),
		Position = searchable and UD2_N(0, 0, 0, 38) or UD2_N(0, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = COLORS.Accent,
		CanvasSize = UD2_N(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ZIndex = 10,
		Parent = dropFrame,
	})

	local dropList = Create("Frame", {
		Size = UD2_N(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 10,
		Parent = dropScroll,
	})
	AddPadding(dropList, 4)
	AddListLayout(dropList, 2)

	local optionButtons = {}

	local function filterOptions()
		local visibleCount = 0
		for _, btn in (optionButtons) do
			local optText = btn.Text:lower()
			if searchQuery == "" or optText:find(searchQuery:lower(), 1, true) then
				btn.Visible = true
				visibleCount = visibleCount + 1
			else
				btn.Visible = false
			end
		end
		return visibleCount
	end

	local function rebuildList()
		for _, child in (dropList:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end
		optionButtons = {}
		for _, opt in (options) do
			local optBtn = Create("TextButton", {
				Size = UD2_N(1, 0, 0, 30),
				BackgroundColor3 = COLORS.DropdownBg,
				BorderSizePixel = 0,
				Text = opt,
				TextColor3 = COLORS.Text,
				TextSize = 13,
				Font = Enum.Font.GothamMedium,
				AutoButtonColor = false,
				ZIndex = 11,
				Parent = dropList,
			})
			AddCorner(optBtn, 6)
			optionButtons[opt] = optBtn

			optBtn.MouseEnter:Connect(function()
				Tween(optBtn, 0.15, { BackgroundColor3 = COLORS.DropdownHover })
			end)
			optBtn.MouseLeave:Connect(function()
				Tween(optBtn, 0.15, { BackgroundColor3 = COLORS.DropdownBg })
			end)
			optBtn.MouseButton1Click:Connect(function()
				selected = opt
				label.Text = opt
				label.TextColor3 = COLORS.Accent
				isOpen = false
				if searchable then
					searchBox.Text = ""
					searchQuery = ""
				end
				Tween(frame, 0.25, { Size = UD2_N(1, 0, 0, 36) })
				Tween(dropFrame, 0.25, { Size = UD2_N(1, 0, 0, 0) })
				Tween(dropStroke, 0.25, { Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				Tween(arrow, 0.25, { Rotation = 0 })
				task.delay(0.25, function()
					dropFrame.Visible = false
				end)
				if config.Callback then
					config.Callback(opt)
				end
			end)
		end
		filterOptions()
	end

	rebuildList()

	if searchable and searchBox then
		self._maid:Add(searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			searchQuery = searchBox.Text
			filterOptions()
		end))
	end

	self._maid:Add(mainBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		if isOpen then
			if searchable then
				searchBox.Text = ""
				searchQuery = ""
				filterOptions()
			end
			local visibleCount = 0
			for _, btn in (optionButtons) do
				if btn.Visible then
					visibleCount = visibleCount + 1
				end
			end
			local listHeight = math.min(visibleCount * 32 + 8, 200)
			local baseHeight = searchable and 38 or 0
			local totalHeight = baseHeight + listHeight
			dropFrame.Visible = true
			dropFrame.Size = UD2_N(1, 0, 0, 0)
			dropStroke.Transparency = 1
			Tween(frame, 0.3, { Size = UD2_N(1, 0, 0, 36 + totalHeight + 2) })
			Tween(dropFrame, 0.3, { Size = UD2_N(1, 0, 0, totalHeight) })
			Tween(dropStroke, 0.3, { Transparency = 0 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			Tween(arrow, 0.3, { Rotation = 180 })
			if searchable then
				task.wait(0.1)
				searchBox:CaptureFocus()
			end
		else
			if searchable then
				searchBox.Text = ""
				searchQuery = ""
			end
			Tween(frame, 0.25, { Size = UD2_N(1, 0, 0, 36) })
			Tween(dropFrame, 0.25, { Size = UD2_N(1, 0, 0, 0) })
			Tween(dropStroke, 0.25, { Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			Tween(arrow, 0.25, { Rotation = 0 })
			task.delay(0.25, function()
				dropFrame.Visible = false
			end)
		end
	end))

	self.Frame = frame
	self.Label = label
	self._options = options
	self._getSelected = function() return selected end
	self._setSelected = function(opt)
		selected = opt
		label.Text = opt
		label.TextColor3 = COLORS.Accent
	end
	self._clearSelected = function()
		selected = nil
		label.Text = config.Text or "Select..."
		label.TextColor3 = COLORS.Text
	end
	self._rebuildList = rebuildList
	self._configText = config.Text
	self._configCallback = config.Callback
	return self
end

function DropdownElement:SetVisible(visible: boolean)
	self.Frame.Visible = visible
end

function DropdownElement:AddOption(option: string)
	if not option then return end
	table.insert(self._options, option)
	self._rebuildList()
end

function DropdownElement:RemoveOption(option: string)
	for i, v in (self._options) do
		if v == option then
			table.remove(self._options, i)
			break
		end
	end
	if self._getSelected() == option then
		self._clearSelected()
	end
	self._rebuildList()
end

function DropdownElement:SetOptions(list: { string })
	table.clear(self._options)
	for _, v in (list or {}) do
		table.insert(self._options, v)
	end
	self._clearSelected()
	self._rebuildList()
end

function DropdownElement:SetSelectedOption(option: string)
	for _, v in (self._options) do
		if v == option then
			self._setSelected(option)
			if self._configCallback then
				self._configCallback(option)
			end
			return
		end
	end
end

function DropdownElement:GetSelected(): string?
	return self._getSelected()
end

function DropdownElement:Destroy()
	self._maid:Destroy()
	if self.Frame and self.Frame.Parent then
		self.Frame:Destroy()
	end
end

local MultiSelectDropdownElement = {}
MultiSelectDropdownElement.__index = MultiSelectDropdownElement

function MultiSelectDropdownElement.new(section, config: MultiSelectDropdownConfig): MultiSelectDropdownElement
	local self = setmetatable({}, MultiSelectDropdownElement)
	self._maid = Maid.new()

	local options = {}
	for _, v in (config.Options or {}) do
		table.insert(options, v)
	end
	local selected = {}
	local isOpen = false
	local maxSelected = config.MaxSelected or math.huge
	local searchable = config.Searchable ~= nil and config.Searchable or false
	local searchQuery = ""

	local frame = Create("Frame", {
		Name = "MultiSelectDropdown",
		Size = UD2_N(1, 0, 0, 36),
		BackgroundColor3 = COLORS.Element,
		BorderSizePixel = 0,
		LayoutOrder = config.ListOrder or 0,
		ClipsDescendants = false,
		Parent = section.ContentHolder,
	})
	AddCorner(frame, 8)

	local mainBtn = Create("TextButton", {
		Size = UD2_N(1, 0, 0, 36),
		BackgroundTransparency = 1,
		Text = "",
		Parent = frame,
	})

	local label = Create("TextLabel", {
		Size = UD2_N(1, -40, 1, 0),
		Position = UD2_N(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text = config.Text or "Select...",
		TextColor3 = COLORS.Text,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = mainBtn,
	})

	local arrow = Create("TextLabel", {
		Size = UD2_N(0, 20, 0, 20),
		Position = UD2_N(1, -30, 0.5, -10),
		BackgroundTransparency = 1,
		Text = "▼",
		TextColor3 = COLORS.TextDim,
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		Parent = mainBtn,
	})

	local dropFrame = Create("Frame", {
		Name = "DropFrame",
		Size = UD2_N(1, 0, 0, 0),
		Position = UD2_N(0, 0, 0, 38),
		BackgroundColor3 = COLORS.DropdownBg,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 10,
		Visible = false,
		Parent = frame,
	})
	AddCorner(dropFrame, 8)
	local dropStroke = AddStroke(dropFrame, COLORS.Border, 1)
	dropStroke.Transparency = 1

	local searchBox
	if searchable then
		local searchHolder = Create("Frame", {
			Size = UD2_N(1, -8, 0, 30),
			Position = UD2_N(0, 4, 0, 4),
			BackgroundColor3 = COLORS.InputBg,
			BorderSizePixel = 0,
			ZIndex = 11,
			Parent = dropFrame,
		})
		AddCorner(searchHolder, 6)
		AddStroke(searchHolder, COLORS.Border, 1)

		searchBox = Create("TextBox", {
			Size = UD2_N(1, -12, 1, 0),
			Position = UD2_N(0, 6, 0, 0),
			BackgroundTransparency = 1,
			Text = "",
			PlaceholderText = "Search...",
			PlaceholderColor3 = COLORS.TextMuted,
			TextColor3 = COLORS.Text,
			TextSize = 12,
			Font = Enum.Font.GothamMedium,
			TextXAlignment = Enum.TextXAlignment.Left,
			ClearTextOnFocus = false,
			ZIndex = 12,
			Parent = searchHolder,
		})
	end

	local dropScroll = Create("ScrollingFrame", {
		Size = searchable and UD2_N(1, 0, 1, -38) or UD2_N(1, 0, 1, 0),
		Position = searchable and UD2_N(0, 0, 0, 38) or UD2_N(0, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = COLORS.Accent,
		CanvasSize = UD2_N(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ZIndex = 10,
		Parent = dropFrame,
	})

	local dropList = Create("Frame", {
		Size = UD2_N(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 10,
		Parent = dropScroll,
	})
	AddPadding(dropList, 4)
	AddListLayout(dropList, 2)

	local optionButtons = {}
	local checkboxes = {}

	local function updateLabel()
		if #selected == 0 then
			label.Text = config.Text or "Select..."
			label.TextColor3 = COLORS.Text
		else
			label.Text = table.concat(selected, ", ")
			label.TextColor3 = COLORS.Accent
		end
	end

	local function isSelected(opt)
		for _, v in (selected) do
			if v == opt then return true end
		end
		return false
	end

	local function filterOptions()
		local visibleCount = 0
		for opt, btn in (optionButtons) do
			local optText = opt:lower()
			if searchQuery == "" or optText:find(searchQuery:lower(), 1, true) then
				btn.Visible = true
				visibleCount = visibleCount + 1
			else
				btn.Visible = false
			end
		end
		return visibleCount
	end

	local function rebuildList()
		for _, child in (dropList:GetChildren()) do
			if child:IsA("Frame") and child.Name == "OptionRow" then
				child:Destroy()
			end
		end
		optionButtons = {}
		checkboxes = {}

		for _, opt in (options) do
			local optRow = Create("Frame", {
				Name = "OptionRow",
				Size = UD2_N(1, 0, 0, 30),
				BackgroundColor3 = COLORS.DropdownBg,
				BorderSizePixel = 0,
				ZIndex = 11,
				Parent = dropList,
			})
			AddCorner(optRow, 6)

			local checkbox = Create("Frame", {
				Size = UD2_N(0, 18, 0, 18),
				Position = UD2_N(0, 8, 0.5, -9),
				BackgroundColor3 = isSelected(opt) and COLORS.ToggleOn or COLORS.ToggleOff,
				BorderSizePixel = 0,
				ZIndex = 12,
				Parent = optRow,
			})
			AddCorner(checkbox, 4)
			checkboxes[opt] = checkbox

			local checkmark = Create("TextLabel", {
				Size = UD2_N(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = isSelected(opt) and "✓" or "",
				TextColor3 = C3_FRGB(255, 255, 255),
				TextSize = 14,
				Font = Enum.Font.GothamBold,
				ZIndex = 13,
				Parent = checkbox,
			})

			local optLabel = Create("TextLabel", {
				Size = UD2_N(1, -38, 1, 0),
				Position = UD2_N(0, 32, 0, 0),
				BackgroundTransparency = 1,
				Text = opt,
				TextColor3 = COLORS.Text,
				TextSize = 13,
				Font = Enum.Font.GothamMedium,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 12,
				Parent = optRow,
			})
			optLabel.Text = opt
			optionButtons[opt] = optRow

			local optBtn = Create("TextButton", {
				Size = UD2_N(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 12,
				Parent = optRow,
			})

			optBtn.MouseEnter:Connect(function()
				Tween(optRow, 0.15, { BackgroundColor3 = COLORS.DropdownHover })
			end)
			optBtn.MouseLeave:Connect(function()
				Tween(optRow, 0.15, { BackgroundColor3 = COLORS.DropdownBg })
			end)
			optBtn.MouseButton1Click:Connect(function()
				local alreadySelected = isSelected(opt)
				if alreadySelected then
					for i, v in (selected) do
						if v == opt then
							table.remove(selected, i)
							break
						end
					end
					Tween(checkbox, 0.2, { BackgroundColor3 = COLORS.ToggleOff })
					checkmark.Text = ""
				else
					if #selected < maxSelected then
						table.insert(selected, opt)
						Tween(checkbox, 0.2, { BackgroundColor3 = COLORS.ToggleOn })
						checkmark.Text = "✓"
					end
				end
				updateLabel()
				if config.Callback then
					config.Callback(selected)
				end
			end)
		end
		filterOptions()
	end

	rebuildList()

	if searchable and searchBox then
		self._maid:Add(searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			searchQuery = searchBox.Text
			filterOptions()
		end))
	end

	self._maid:Add(mainBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		if isOpen then
			if searchable then
				searchBox.Text = ""
				searchQuery = ""
				filterOptions()
			end
			local visibleCount = 0
			for _, btn in (optionButtons) do
				if btn.Visible then
					visibleCount = visibleCount + 1
				end
			end
			local listHeight = math.min(visibleCount * 32 + 8, 200)
			local baseHeight = searchable and 38 or 0
			local totalHeight = baseHeight + listHeight
			dropFrame.Visible = true
			dropFrame.Size = UD2_N(1, 0, 0, 0)
			dropStroke.Transparency = 1
			Tween(frame, 0.3, { Size = UD2_N(1, 0, 0, 36 + totalHeight + 2) })
			Tween(dropFrame, 0.3, { Size = UD2_N(1, 0, 0, totalHeight) })
			Tween(dropStroke, 0.3, { Transparency = 0 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			Tween(arrow, 0.3, { Rotation = 180 })
			if searchable then
				task.wait(0.1)
				searchBox:CaptureFocus()
			end
		else
			if searchable then
				searchBox.Text = ""
				searchQuery = ""
			end
			Tween(frame, 0.25, { Size = UD2_N(1, 0, 0, 36) })
			Tween(dropFrame, 0.25, { Size = UD2_N(1, 0, 0, 0) })
			Tween(dropStroke, 0.25, { Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			Tween(arrow, 0.25, { Rotation = 0 })
			task.delay(0.25, function()
				dropFrame.Visible = false
			end)
		end
	end))

	self.Frame = frame
	self.Label = label
	self._options = options
	self._selected = selected
	self._maxSelected = maxSelected
	self._updateLabel = updateLabel
	self._rebuildList = rebuildList
	self._isSelected = isSelected
	self._configText = config.Text
	self._configCallback = config.Callback
	return self
end

function MultiSelectDropdownElement:SetVisible(visible: boolean)
	self.Frame.Visible = visible
end

function MultiSelectDropdownElement:AddOption(option: string)
	if not option then return end
	table.insert(self._options, option)
	self._rebuildList()
end

function MultiSelectDropdownElement:RemoveOption(option: string)
	for i, v in (self._options) do
		if v == option then
			table.remove(self._options, i)
			break
		end
	end
	for i, v in (self._selected) do
		if v == option then
			table.remove(self._selected, i)
			break
		end
	end
	self._updateLabel()
	self._rebuildList()
end

function MultiSelectDropdownElement:SetOptions(list: { string })
	table.clear(self._options)
	for _, v in (list or {}) do
		table.insert(self._options, v)
	end
	table.clear(self._selected)
	self._updateLabel()
	self._rebuildList()
end

function MultiSelectDropdownElement:SetSelected(list: { string })
	table.clear(self._selected)
	for _, v in (list or {}) do
		if #self._selected < self._maxSelected then
			for _, opt in (self._options) do
				if opt == v then
					table.insert(self._selected, v)
					break
				end
			end
		end
	end
	self._updateLabel()
	self._rebuildList()
	if self._configCallback then
		self._configCallback(self._selected)
	end
end

function MultiSelectDropdownElement:GetSelected(): { string }
	return self._selected
end

function MultiSelectDropdownElement:ClearSelected()
	table.clear(self._selected)
	self._updateLabel()
	self._rebuildList()
	if self._configCallback then
		self._configCallback(self._selected)
	end
end

function MultiSelectDropdownElement:Destroy()
	self._maid:Destroy()
	if self.Frame and self.Frame.Parent then
		self.Frame:Destroy()
	end
end

local TextBoxElement = {}
TextBoxElement.__index = TextBoxElement

function TextBoxElement.new(section, config: TextBoxConfig): TextBoxElement
	local self = setmetatable({}, TextBoxElement)
	self._maid = Maid.new()

	local COMPACT_HEIGHT = 36
	local EXPANDED_HEIGHT = 66
	local isExpanded = false

	local frame = section:_CreateElementFrame(config, COMPACT_HEIGHT, "TextBox")
	AddPadding(frame, 12)

	local titleLabel = Create("TextLabel", {
		Name = "TitleLabel",
		Size = UD2_N(0.4, 0, 1, 0),
		Position = UD2_N(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = config.Text or "Input",
		TextColor3 = COLORS.Text,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.None,
		Parent = frame,
	})

	local inputHolder = Create("Frame", {
		Name = "InputHolder",
		AnchorPoint = Vector2.new(1, 0),
		Size = UD2_N(0.55, 0, 0, 26),
		Position = UD2_N(1, 7, 0.5, -13),
		BackgroundColor3 = COLORS.InputBg,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = frame,
	})
	AddCorner(inputHolder, 6)
	AddStroke(inputHolder, COLORS.Border, 1)

	local textBox = Create("TextBox", {
		Size = UD2_N(1, -12, 1, 0),
		Position = UD2_N(0, 6, 0, 0),
		BackgroundTransparency = 1,
		Text = "",
		PlaceholderText = config.PlaceHolder or "Type here...",
		PlaceholderColor3 = COLORS.TextMuted,
		TextColor3 = COLORS.Text,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		Parent = inputHolder,
	})

	local stroke = inputHolder:FindFirstChildOfClass("UIStroke")

	local function applyCompact(instant)
		isExpanded = false
		local dur = instant and 0 or 0.25
		if instant then
			frame.Size = UD2_N(1, 0, 0, COMPACT_HEIGHT)
			titleLabel.Size = UD2_N(0.4, 0, 1, 0)
			titleLabel.Position = UD2_N(0, 0, 0, 0)
			inputHolder.AnchorPoint = Vector2.new(1, 0)
			inputHolder.Size = UD2_N(0.55, 0, 0, 26)
			inputHolder.Position = UD2_N(1, 7, 0.5, -13)
		else
			Tween(frame, dur, { Size = UD2_N(1, 0, 0, COMPACT_HEIGHT) })
			Tween(titleLabel, dur, { Size = UD2_N(0.4, 0, 1, 0), Position = UD2_N(0, 0, 0, 0) })
			Tween(inputHolder, dur, { Size = UD2_N(0.55, 0, 0, 26), Position = UD2_N(1, 7, 0.5, -13) })
			task.delay(dur, function()
				if not isExpanded then
					inputHolder.AnchorPoint = Vector2.new(1, 0)
				end
			end)
		end
	end

	local function applyExpanded(instant)
		isExpanded = true
		inputHolder.AnchorPoint = Vector2.new(0, 0)
		local dur = instant and 0 or 0.25
		if instant then
			frame.Size = UD2_N(1, 0, 0, EXPANDED_HEIGHT)
			titleLabel.Size = UD2_N(1, 0, 0, 20)
			titleLabel.Position = UD2_N(0, 0, 0, 0)
			inputHolder.Size = UD2_N(1, 0, 0, 26)
			inputHolder.Position = UD2_N(0, 0, 0, 28)
		else
			Tween(frame, dur, { Size = UD2_N(1, 0, 0, EXPANDED_HEIGHT) })
			Tween(titleLabel, dur, { Size = UD2_N(1, 0, 0, 20), Position = UD2_N(0, 0, 0, 0) })
			Tween(inputHolder, dur, { Size = UD2_N(1, 0, 0, 26), Position = UD2_N(0, 0, 0, 28) })
		end
	end

	local function checkOverflow()
		local labelWidth = titleLabel.AbsoluteSize.X
		if labelWidth <= 0 then return end
		local textWidth = titleLabel.TextBounds.X
		local overflow = textWidth > labelWidth + 1
		if overflow and not isExpanded then
			applyExpanded(false)
		elseif not overflow and isExpanded then
			applyCompact(false)
		end
	end

	self._maid:Add(titleLabel:GetPropertyChangedSignal("TextBounds"):Connect(checkOverflow))
	self._maid:Add(titleLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(checkOverflow))

	task.defer(function()
		checkOverflow()
	end)

	self._maid:Add(textBox.Focused:Connect(function()
		if stroke then Tween(stroke, 0.2, { Color = COLORS.Accent }) end
	end))

	self._maid:Add(textBox.FocusLost:Connect(function()
		if stroke then Tween(stroke, 0.2, { Color = COLORS.Border }) end
		if config.Callback then
			config.Callback(textBox.Text)
		end
	end))

	self.Frame = frame
	self.TextBox = textBox
	return self
end

function TextBoxElement:SetVisible(visible: boolean)
	self.Frame.Visible = visible
end

function TextBoxElement:SetText(text: string)
	self.TextBox.Text = text
end

function TextBoxElement:GetText(): string
	return self.TextBox.Text
end

function TextBoxElement:Destroy()
	self._maid:Destroy()
	if self.Frame and self.Frame.Parent then
		self.Frame:Destroy()
	end
end

local KeyInputElement = {}
KeyInputElement.__index = KeyInputElement

function KeyInputElement.new(section, config: KeyInputConfig): KeyInputElement
	local self = setmetatable({}, KeyInputElement)
	self._maid = Maid.new()

	self._currentKey = config.Default or nil
	self.ListenForInputEnded = config.ListenForInputEnded ~= nil and config.ListenForInputEnded or false
	self.Clearable = config.Clearable ~= nil and config.Clearable or false

	local listening = false

	local frame = section:_CreateElementFrame(config, 36, "KeyInput")
	local padding = AddPadding(frame, 0)

	local label = Create("TextLabel", {
		Size = UD2_N(1, -96, 1, 0),
		BackgroundTransparency = 1,
		Text = config.Text or "Keybind",
		TextColor3 = COLORS.Text,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame,
	})

	padding.PaddingLeft = UDim.new(0, 12)

	local keyBtnHolder = Create("Frame", {
		Size = UD2_N(0, 74, 0, 24),
		Position = UD2_N(1, self.Clearable and -100 or -80, 0.5, -12),
		BackgroundColor3 = COLORS.InputBg,
		BorderSizePixel = 0,
		Parent = frame,
	})
	AddCorner(keyBtnHolder, 6)
	local keyBtnStroke = AddStroke(keyBtnHolder, COLORS.Border, 1)

	local keyBtn = Create("TextButton", {
		Size = UD2_N(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = self._currentKey and self._currentKey.Name or "None",
		TextColor3 = self._currentKey and COLORS.Accent or COLORS.TextMuted,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		Parent = keyBtnHolder,
	})
	AddCorner(keyBtn, 6)

	local function setKeyDisplay(key)
		keyBtn.Text = key and key.Name or "None"
		keyBtn.TextColor3 = key and COLORS.Accent or COLORS.TextMuted
	end

	local function stopListening()
		listening = false
		setKeyDisplay(self._currentKey)
		Tween(keyBtnHolder, 0.2, { BackgroundColor3 = COLORS.InputBg })
		Tween(keyBtnStroke, 0.2, { Color = COLORS.Border })
	end

	local function startListening()
		listening = true
		keyBtn.Text = "..."
		keyBtn.TextColor3 = COLORS.Text
		Tween(keyBtnHolder, 0.2, { BackgroundColor3 = COLORS.ElementHover })
		Tween(keyBtnStroke, 0.2, { Color = COLORS.Accent })
	end

	self._maid:Add(keyBtn.MouseButton1Click:Connect(function()
		if listening then
			stopListening()
		else
			startListening()
		end
	end))

	local eventName = self.ListenForInputEnded and "InputEnded" or "InputBegan"

	self._maid:Add(UserInputService[eventName]:Connect(function(input, gameProcessed)
		if not listening then return end

		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

		local key = input.KeyCode
		if key == Enum.KeyCode.Escape then
			stopListening()
			return
		end

		if key == Enum.KeyCode.Unknown then return end

		self._currentKey = key
		listening = false
		stopListening()
		if config.Callback then
			config.Callback(self._currentKey)
		end
	end))

	if self.Clearable then
		local clearBtn = Create("TextButton", {
			Size = UD2_N(0, 18, 0, 18),
			Position = UD2_N(1, -22, 0.5, -9),
			BackgroundTransparency = 1,
			Text = "×",
			TextColor3 = COLORS.TextMuted,
			TextSize = 16,
			Font = Enum.Font.GothamBold,
			Parent = frame,
		})

		self._maid:Add(clearBtn.MouseEnter:Connect(function()
			clearBtn.TextColor3 = COLORS.Text
		end))
		self._maid:Add(clearBtn.MouseLeave:Connect(function()
			clearBtn.TextColor3 = COLORS.TextMuted
		end))
		self._maid:Add(clearBtn.MouseButton1Click:Connect(function()
			self._currentKey = nil
			if listening then
				stopListening()
			else
				setKeyDisplay(nil)
			end
			if config.Callback then
				config.Callback(nil)
			end
		end))
	end

	self.Frame = frame
	self.Button = keyBtn
	self.Label = label
	self._setKeyDisplay = setKeyDisplay
	self._configCallback = config.Callback
	return self
end

function KeyInputElement:SetVisible(visible: boolean)
	self.Frame.Visible = visible
end

function KeyInputElement:SetInput(key: Enum.KeyCode?)
	self._currentKey = key
	self._setKeyDisplay(key)
	if self._configCallback then
		self._configCallback(key)
	end
end

function KeyInputElement:GetInput(): Enum.KeyCode?
	return self._currentKey
end

function KeyInputElement:ClearInput()
	self._currentKey = nil
	self._setKeyDisplay(nil)
	if self._configCallback then
		self._configCallback(nil)
	end
end

function KeyInputElement:Destroy()
	self._maid:Destroy()
	if self.Frame and self.Frame.Parent then
		self.Frame:Destroy()
	end
end

local ColorPickerElement = {}
ColorPickerElement.__index = ColorPickerElement

function ColorPickerElement.new(section, config: ColorPickerConfig): ColorPickerElement
	local self = setmetatable({}, ColorPickerElement)
	self._maid = Maid.new()

	local defaultColor = config.Default or C3_FRGB(255, 0, 0)
	local h, s, v = Color3ToHSV(defaultColor)
	local currentColor = defaultColor
	local pickerOpen = false
	local svDragging = false
	local hueDragging = false

	local frame = Create("Frame", {
		Name = "ColorPicker",
		Size = UD2_N(1, 0, 0, 36),
		BackgroundColor3 = COLORS.Element,
		BorderSizePixel = 0,
		LayoutOrder = config.ListOrder or 0,
		ClipsDescendants = false,
		Parent = section.ContentHolder,
	})
	AddCorner(frame, 8)

	local mainRow = Create("TextButton", {
		Size = UD2_N(1, 0, 0, 36),
		BackgroundTransparency = 1,
		Text = "",
		Parent = frame,
	})

	local title = Create("TextLabel", {
		Size = UD2_N(1, -56, 1, 0),
		Position = UD2_N(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text = config.Text or "Color",
		TextColor3 = COLORS.Text,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = mainRow,
	})

	local preview = Create("Frame", {
		Size = UD2_N(0, 28, 0, 20),
		Position = UD2_N(1, -37, 0.5, -10),
		BackgroundColor3 = currentColor,
		BorderSizePixel = 0,
		Parent = mainRow,
	})
	AddCorner(preview, 6)
	AddStroke(preview, COLORS.Border, 1)

	local pickerPanel = Create("Frame", {
		Name = "PickerPanel",
		Size = UD2_N(0, 0, 0, 0),
		Position = UD2_N(0, 0, 0, 0),
		BackgroundColor3 = COLORS.DropdownBg,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 1001,
		Visible = false,
		Parent = section.Window.ScreenGui,
	})
	AddCorner(pickerPanel, 10)
	local pickerStroke = AddStroke(pickerPanel, COLORS.Border, 1)
	pickerStroke.Transparency = 1

	local pickerContent = Create("Frame", {
		Size = UD2_N(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 1002,
		Parent = pickerPanel,
	})
	AddPadding(pickerContent, 10)

	local svBox = Create("Frame", {
		Name = "SVBox",
		Size = UD2_N(1, -30, 0, 140),
		BackgroundColor3 = HSVToColor3(h, 1, 1),
		BorderSizePixel = 0,
		ZIndex = 1003,
		Parent = pickerContent,
	})
	AddCorner(svBox, 6)

	local satOverlay = Create("Frame", {
		Size = UD2_N(1, 0, 1, 0),
		BackgroundColor3 = C3_FRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 1004,
		Parent = svBox,
	})
	AddCorner(satOverlay, 6)

	Create("UIGradient", {
		Color = ColorSequence.new(C3_FRGB(255, 255, 255), C3_FRGB(255, 255, 255)),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Rotation = 0,
		Parent = satOverlay,
	})

	local valOverlay = Create("Frame", {
		Size = UD2_N(1, 0, 1, 0),
		BackgroundColor3 = C3_FRGB(0, 0, 0),
		BorderSizePixel = 0,
		ZIndex = 1005,
		Parent = svBox,
	})
	AddCorner(valOverlay, 6)

	Create("UIGradient", {
		Color = ColorSequence.new(C3_FRGB(0, 0, 0), C3_FRGB(0, 0, 0)),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0),
		}),
		Rotation = 90,
		Parent = valOverlay,
	})

	local svCursor = Create("Frame", {
		Size = UD2_N(0, 14, 0, 14),
		Position = UD2_N(s, -7, 1 - v, -7),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 1007,
		Parent = svBox,
	})
	local svCursorInner = Create("Frame", {
		Size = UD2_N(0, 10, 0, 10),
		Position = UD2_N(0.5, -5, 0.5, -5),
		BackgroundColor3 = currentColor,
		BorderSizePixel = 0,
		ZIndex = 1008,
		Parent = svCursor,
	})
	AddCorner(svCursorInner, 5)
	AddStroke(svCursorInner, C3_FRGB(255, 255, 255), 2)

	local svInput = Create("TextButton", {
		Size = UD2_N(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 1006,
		Parent = svBox,
	})

	local hueBar = Create("Frame", {
		Name = "HueBar",
		Size = UD2_N(0, 18, 0, 140),
		Position = UD2_N(1, -18, 0, 0),
		BackgroundColor3 = C3_FRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 1003,
		Parent = pickerContent,
	})
	AddCorner(hueBar, 6)

	Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, C3_FRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.167, C3_FRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.333, C3_FRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.5, C3_FRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.667, C3_FRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.833, C3_FRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1, C3_FRGB(255, 0, 0)),
		}),
		Rotation = 90,
		Parent = hueBar,
	})

	local hueCursor = Create("Frame", {
		Size = UD2_N(1, 4, 0, 6),
		Position = UD2_N(0, -2, h, -3),
		BackgroundColor3 = C3_FRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 1005,
		Parent = hueBar,
	})
	AddCorner(hueCursor, 3)
	AddStroke(hueCursor, C3_FRGB(40, 40, 40), 1)

	local hueInput = Create("TextButton", {
		Size = UD2_N(1, 6, 1, 0),
		Position = UD2_N(0, -3, 0, 0),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 1004,
		Parent = hueBar,
	})

	local inputsFrame = Create("Frame", {
		Size = UD2_N(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UD2_N(0, 0, 0, 148),
		BackgroundTransparency = 1,
		ZIndex = 1003,
		Parent = pickerContent,
	})
	AddListLayout(inputsFrame, 6)

	local function makeInputRow(labelText, fields, yOrder)
		local row = Create("Frame", {
			Size = UD2_N(1, 0, 0, 24),
			BackgroundTransparency = 1,
			LayoutOrder = yOrder or 0,
			ZIndex = 1003,
			Parent = inputsFrame,
		})
		Create("TextLabel", {
			Size = UD2_N(0, 42, 1, 0),
			BackgroundTransparency = 1,
			Text = labelText,
			TextColor3 = COLORS.TextDim,
			TextSize = 11,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 1003,
			Parent = row,
		})
		local boxes = {}
		local count = #fields
		local spacing = 4
		local labelWidth = 42
		for i, field in (fields) do
			local w = (1 - (labelWidth / 260)) / count
			local holder = Create("Frame", {
				Size = UD2_N(w, -spacing, 1, 0),
				Position = UD2_N((i - 1) * w, labelWidth + 4 + (i - 1) * spacing, 0, 0),
				BackgroundColor3 = COLORS.InputBg,
				BorderSizePixel = 0,
				ZIndex = 1003,
				Parent = row,
			})
			AddCorner(holder, 4)
			local tb = Create("TextBox", {
				Size = UD2_N(1, -8, 1, 0),
				Position = UD2_N(0, 4, 0, 0),
				BackgroundTransparency = 1,
				Text = field.Default or "",
				PlaceholderText = field.Placeholder or "",
				PlaceholderColor3 = COLORS.TextMuted,
				TextColor3 = COLORS.Text,
				TextSize = 11,
				Font = Enum.Font.GothamMedium,
				ClearTextOnFocus = true,
				ZIndex = 1004,
				Parent = holder,
			})
			boxes[field.Name] = tb
		end
		return boxes
	end

	local hsvBoxes = makeInputRow("HSV", {
		{ Name = "H", Default = tostring(math.floor(h * 360)), Placeholder = "H" },
		{ Name = "S", Default = tostring(math.floor(s * 100)), Placeholder = "S" },
		{ Name = "V", Default = tostring(math.floor(v * 100)), Placeholder = "V" },
	}, 1)

	local rgbBoxes = makeInputRow("RGB", {
		{ Name = "R", Default = tostring(math.floor(currentColor.R * 255)), Placeholder = "R" },
		{ Name = "G", Default = tostring(math.floor(currentColor.G * 255)), Placeholder = "G" },
		{ Name = "B", Default = tostring(math.floor(currentColor.B * 255)), Placeholder = "B" },
	}, 2)

	local hexBoxes = makeInputRow("HEX", {
		{ Name = "Hex", Default = Color3ToHex(currentColor), Placeholder = "#FFFFFF" },
	}, 3)

	local presetsFrame = Create("Frame", {
		Size = UD2_N(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UD2_N(0, 0, 0, 248),
		BackgroundTransparency = 1,
		ZIndex = 1003,
		Parent = pickerContent,
	})

	Create("TextLabel", {
		Size = UD2_N(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Text = "Presets",
		TextColor3 = COLORS.TextDim,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 1003,
		LayoutOrder = 0,
		Parent = presetsFrame,
	})

	local presetsGrid = Create("Frame", {
		Size = UD2_N(1, 0, 0, 44),
		Position = UD2_N(0, 0, 0, 18),
		BackgroundTransparency = 1,
		ZIndex = 1003,
		Parent = presetsFrame,
	})

	Create("UIGridLayout", {
		CellSize = UD2_N(0, 18, 0, 18),
		CellPadding = UD2_N(0, 4, 0, 4),
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = presetsGrid,
	})

	local function updateAllInputs()
		hsvBoxes.H.Text = tostring(math.floor(h * 360))
		hsvBoxes.S.Text = tostring(math.floor(s * 100))
		hsvBoxes.V.Text = tostring(math.floor(v * 100))
		rgbBoxes.R.Text = tostring(math.floor(currentColor.R * 255))
		rgbBoxes.G.Text = tostring(math.floor(currentColor.G * 255))
		rgbBoxes.B.Text = tostring(math.floor(currentColor.B * 255))
		hexBoxes.Hex.Text = Color3ToHex(currentColor)
	end

	local function applyColor()
		currentColor = HSVToColor3(h, s, v)
		preview.BackgroundColor3 = currentColor
		svBox.BackgroundColor3 = HSVToColor3(h, 1, 1)
		svCursor.Position = UD2_N(s, -7, 1 - v, -7)
		svCursorInner.BackgroundColor3 = currentColor
		hueCursor.Position = UD2_N(0, -2, h, -3)
		updateAllInputs()
		if config.Callback then
			config.Callback(currentColor)
		end
	end

	for i, presetColor in ipairs(PRESET_COLORS) do
		local pBtn = Create("TextButton", {
			Size = UD2_N(0, 18, 0, 18),
			BackgroundColor3 = presetColor,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			LayoutOrder = i,
			ZIndex = 1004,
			Parent = presetsGrid,
		})
		AddCorner(pBtn, 4)
		pBtn.MouseButton1Click:Connect(function()
			h, s, v = Color3ToHSV(presetColor)
			applyColor()
		end)
	end

	self._maid:Add(svInput.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			svDragging = true
			s = Clamp01((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X)
			v = 1 - Clamp01((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y)
			applyColor()
		end
	end))

	self._maid:Add(hueInput.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			hueDragging = true
			h = Clamp01((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y)
			applyColor()
		end
	end))

	self._maid:Add(UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if svDragging then
				s = Clamp01((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X)
				v = 1 - Clamp01((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y)
				applyColor()
			end
			if hueDragging then
				h = Clamp01((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y)
				applyColor()
			end
		end
	end))

	self._maid:Add(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			svDragging = false
			hueDragging = false
		end
	end))

	self._maid:Add(hsvBoxes.H.FocusLost:Connect(function()
		local val = tonumber(hsvBoxes.H.Text)
		if val then h = Clamp01(val / 360); applyColor() else updateAllInputs() end
	end))
	self._maid:Add(hsvBoxes.S.FocusLost:Connect(function()
		local val = tonumber(hsvBoxes.S.Text)
		if val then s = Clamp01(val / 100); applyColor() else updateAllInputs() end
	end))
	self._maid:Add(hsvBoxes.V.FocusLost:Connect(function()
		local val = tonumber(hsvBoxes.V.Text)
		if val then v = Clamp01(val / 100); applyColor() else updateAllInputs() end
	end))
	self._maid:Add(rgbBoxes.R.FocusLost:Connect(function()
		local rr = tonumber(rgbBoxes.R.Text)
		if rr then
			local c = C3_FRGB(math.clamp(rr, 0, 255), currentColor.G * 255, currentColor.B * 255)
			h, s, v = Color3ToHSV(c)
			applyColor()
		else updateAllInputs() end
	end))
	self._maid:Add(rgbBoxes.G.FocusLost:Connect(function()
		local gg = tonumber(rgbBoxes.G.Text)
		if gg then
			local c = C3_FRGB(currentColor.R * 255, math.clamp(gg, 0, 255), currentColor.B * 255)
			h, s, v = Color3ToHSV(c)
			applyColor()
		else updateAllInputs() end
	end))
	self._maid:Add(rgbBoxes.B.FocusLost:Connect(function()
		local bb = tonumber(rgbBoxes.B.Text)
		if bb then
			local c = C3_FRGB(currentColor.R * 255, currentColor.G * 255, math.clamp(bb, 0, 255))
			h, s, v = Color3ToHSV(c)
			applyColor()
		else updateAllInputs() end
	end))
	self._maid:Add(hexBoxes.Hex.FocusLost:Connect(function()
		local c = HexToColor3(hexBoxes.Hex.Text)
		if c then
			h, s, v = Color3ToHSV(c)
			applyColor()
		else updateAllInputs() end
	end))

	local function calculatePickerPosition()
		local screenSize = section.Window.ScreenGui.AbsoluteSize
		local pickerSize = Vector2.new(280, 330)
		local btnPos = mainRow.AbsolutePosition
		local btnSize = mainRow.AbsoluteSize
		local preferredX = btnPos.X + (btnSize.X / 2) - (pickerSize.X / 2)
		local preferredY = btnPos.Y + btnSize.Y + 8
		local maxX = math.max(10, screenSize.X - pickerSize.X - 10)
		local maxY = math.max(10, screenSize.Y - pickerSize.Y - 10)
		local finalX = math.clamp(preferredX, 10, maxX)
		local finalY = preferredY
		if finalY + pickerSize.Y > screenSize.Y - 10 then
			finalY = btnPos.Y - pickerSize.Y - 8
		end
		if finalY < 10 then
			finalY = (screenSize.Y - pickerSize.Y) / 2
			finalX = (screenSize.X - pickerSize.X) / 2
		end
		finalX = math.clamp(finalX, 10, maxX)
		finalY = math.clamp(finalY, 10, maxY)
		return UD2_N(0, finalX, 0, finalY)
	end

	local window = section.Window

	self._maid:Add(mainRow.MouseButton1Click:Connect(function()
		pickerOpen = not pickerOpen
		if pickerOpen then
			if window._currentColorPicker and window._currentColorPicker ~= self then
				window._currentColorPicker:_Close()
			end
			window._currentColorPicker = self
			window.ColorPickerShadow.Visible = true
			Tween(window.ColorPickerShadow, 0.35, { BackgroundTransparency = 0.5 }, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
			local targetPos = calculatePickerPosition()
			pickerPanel.Position = targetPos
			pickerPanel.Visible = true
			pickerStroke.Transparency = 1
			Tween(pickerPanel, 0.35, { Size = UD2_N(0, 280, 0, 330) })
			Tween(pickerStroke, 0.35, { Transparency = 0 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		else
			if window._currentColorPicker == self then
				window._currentColorPicker = nil
			end
			Tween(window.ColorPickerShadow, 0.25, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
			task.delay(0.25, function()
				window.ColorPickerShadow.Visible = false
			end)
			Tween(pickerPanel, 0.25, { Size = UD2_N(0, 0, 0, 0) })
			Tween(pickerStroke, 0.25, { Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			task.delay(0.25, function()
				pickerPanel.Visible = false
			end)
		end
	end))

	self._maid:Add(UserInputService.InputBegan:Connect(function(input)
		if pickerOpen and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			local mousePos = input.Position
			local panelPos = pickerPanel.AbsolutePosition
			local panelSize = pickerPanel.AbsoluteSize
			local inPanel = mousePos.X >= panelPos.X and mousePos.X <= panelPos.X + panelSize.X
				and mousePos.Y >= panelPos.Y and mousePos.Y <= panelPos.Y + panelSize.Y
			local btnPos = mainRow.AbsolutePosition
			local btnSize = mainRow.AbsoluteSize
			local inButton = mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + btnSize.X
				and mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + btnSize.Y
			if not inPanel and not inButton then
				self:_Close()
			end
		end
	end))

	self.Frame = frame
	self.Preview = preview
	self.Title = title
	self.Window = window
	self._pickerPanel = pickerPanel
	self._pickerStroke = pickerStroke
	self._pickerOpen = function() return pickerOpen end
	self._setPickerOpen = function(val) pickerOpen = val end
	self._getColor = function() return currentColor end
	self._setHSV = function(nh, ns, nv)
		h = nh
		s = ns
		v = nv
		applyColor()
	end
	return self
end

function ColorPickerElement:_Close()
	if not self._pickerOpen() then return end
	self._setPickerOpen(false)

	if self.Window and self.Window._currentColorPicker == self then
		self.Window._currentColorPicker = nil
	end

	Tween(self.Window.ColorPickerShadow, 0.25, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	task.delay(0.25, function()
		self.Window.ColorPickerShadow.Visible = false
	end)

	Tween(self._pickerPanel, 0.25, { Size = UD2_N(0, 0, 0, 0) })
	Tween(self._pickerStroke, 0.25, { Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	task.delay(0.25, function()
		self._pickerPanel.Visible = false
	end)
end

function ColorPickerElement:SetVisible(visible: boolean)
	self.Frame.Visible = visible
end

function ColorPickerElement:SetColor(color: Color3)
	if type(color) ~= "userdata" then return end
	local nh, ns, nv = Color3ToHSV(color)
	self._setHSV(nh, ns, nv)
end

function ColorPickerElement:GetColor(): Color3
	return self._getColor()
end

function ColorPickerElement:Destroy()
	self:_Close()
	self._maid:Destroy()
	if self._pickerPanel and self._pickerPanel.Parent then
		self._pickerPanel:Destroy()
	end
	if self.Frame and self.Frame.Parent then
		self.Frame:Destroy()
	end
end

local Section = {}
Section.__index = Section

function Section.new(tab, config: SectionConfig): SectionObject
	local self = setmetatable({}, Section)
	self._maid = Maid.new()
	self.Tab = tab
	self.Window = tab.Window
	self.Title = config.Title or "Section"
	self.Visible = true
	self.Elements = {}

	self.Frame = Create("Frame", {
		Name = "Section_" .. self.Title,
		Size = UD2_N(1, 0, 0, 36),
		BackgroundColor3 = COLORS.Section,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = tab.ScrollFrame,
	})
	AddCorner(self.Frame, 10)
	AddStroke(self.Frame, COLORS.Border, 1)

	self.Header = Create("TextButton", {
		Name = "Header",
		Size = UD2_N(1, 0, 0, 36),
		BackgroundColor3 = COLORS.SectionHeader,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = self.Frame,
	})
	AddCorner(self.Header, 10)

	self.HeaderLabel = Create("TextLabel", {
		Size = UD2_N(1, -40, 1, 0),
		Position = UD2_N(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text = self.Title,
		TextColor3 = COLORS.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self.Header,
	})

	self.Arrow = Create("TextLabel", {
		Size = UD2_N(0, 20, 0, 20),
		Position = UD2_N(1, -30, 0.5, -10),
		BackgroundTransparency = 1,
		Text = "▼",
		TextColor3 = COLORS.TextDim,
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		Parent = self.Header,
	})

	self.ContentHolder = Create("Frame", {
		Name = "ContentHolder",
		Size = UD2_N(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UD2_N(0, 0, 0, 36),
		BackgroundTransparency = 1,
		Parent = self.Frame,
	})
	AddPadding(self.ContentHolder, 8)
	local ListLayout = AddListLayout(self.ContentHolder, 6)
	if config.ListConfig then
		for prop, value in config.ListConfig do
			ListLayout[prop] = value
		end
	end

	local activeTween = nil

	local function setCollapsed(collapsed, instant)
		self.Collapsed = collapsed
		task.defer(function()
			local contentHeight = self.ContentHolder.AbsoluteSize.Y
			local targetHeight = 36 + (collapsed and 0 or contentHeight)
			if activeTween then
				activeTween:Cancel()
			end
			Tween(self.Arrow, 0.3, { Rotation = collapsed and -90 or 0 })
			if instant then
				self.Frame.Size = UD2_N(1, 0, 0, targetHeight)
			else
				activeTween = Tween(
					self.Frame,
					0.35,
					{ Size = UD2_N(1, 0, 0, targetHeight) },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				)
			end
		end)
	end

	self._maid:Add(self.ContentHolder:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if not self.Collapsed then
			self.Frame.Size = UD2_N(1, 0, 0, 36 + self.ContentHolder.AbsoluteSize.Y)
		end
	end))

	self.Collapsed = config.StartCollapsed ~= nil and config.StartCollapsed or false
	setCollapsed(self.Collapsed, true)

	self._maid:Add(self.Header.MouseButton1Click:Connect(function()
		setCollapsed(not self.Collapsed, false)
	end))

	return self
end

function Section:SetVisible(visible: boolean)
	self.Visible = visible
	self.Frame.Visible = visible
end

function Section:_CreateElementFrame(config, height, ElementType)
	local frame = Create("Frame", {
		Name = ElementType or "Element",
		Size = UD2_N(1, 0, 0, height or 36),
		BackgroundColor3 = COLORS.Element,
		BorderSizePixel = 0,
		LayoutOrder = config and config.ListOrder or 0,
		Parent = self.ContentHolder,
	})
	AddCorner(frame, 8)
	return frame
end

function Section:AddButton(config: ButtonConfig): ButtonElement
	local element = ButtonElement.new(self, config)
	table.insert(self.Elements, element)
	return element
end

function Section:AddSlider(config: SliderConfig): SliderElement
	local element = SliderElement.new(self, config)
	table.insert(self.Elements, element)
	return element
end

function Section:AddToggle(config: ToggleConfig): ToggleElement
	local element = ToggleElement.new(self, config)
	table.insert(self.Elements, element)
	return element
end

function Section:AddLabel(config: LabelConfig): LabelElement
	local element = LabelElement.new(self, config)
	table.insert(self.Elements, element)
	return element
end

function Section:AddDropdown(config: DropdownConfig): DropdownElement
	local element = DropdownElement.new(self, config)
	table.insert(self.Elements, element)
	return element
end

function Section:AddMultiSelectDropdown(config: MultiSelectDropdownConfig): MultiSelectDropdownElement
	local element = MultiSelectDropdownElement.new(self, config)
	table.insert(self.Elements, element)
	return element
end

function Section:AddTextBox(config: TextBoxConfig): TextBoxElement
	local element = TextBoxElement.new(self, config)
	table.insert(self.Elements, element)
	return element
end

function Section:AddColorPicker(config: ColorPickerConfig): ColorPickerElement
	local element = ColorPickerElement.new(self, config)
	table.insert(self.Elements, element)
	return element
end

function Section:AddKeybind(config: KeyInputConfig): KeyInputElement
	local element = KeyInputElement.new(self, config)
	table.insert(self.Elements, element)
	return element
end

function Section:Destroy()
	for _, element in self.Elements do
		if element.Destroy then
			element:Destroy()
		end
	end
	self._maid:Destroy()
	if self.Frame and self.Frame.Parent then
		self.Frame:Destroy()
	end
end

local Tab = {}
Tab.__index = Tab

function Tab.new(window, config: TabConfig): TabObject
	local self = setmetatable({}, Tab)
	self._maid = Maid.new()
	self.Window = window
	self.Title = config.Title or "Tab"
	self.Sections = {}
	self.Active = false
	self.Visible = true

	self.Button = Create("TextButton", {
		Name = "Tab_" .. self.Title,
		Size = UD2_N(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = COLORS.TabInactive,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = window.TabHolder,
	})
	AddCorner(self.Button, 6)
	AddPadding(self.Button, 14)

	self.ButtonLabel = Create("TextLabel", {
		Size = UD2_N(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Text = self.Title,
		TextColor3 = COLORS.TextDim,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		Parent = self.Button,
	})

	self.ContentCanvas = Create("CanvasGroup", {
		Name = "TabCanvas_" .. self.Title,
		Size = UD2_N(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Visible = false,
		Parent = window.ContentArea,
	})

	self.ScrollFrame = Create("ScrollingFrame", {
		Name = "TabScroll_" .. self.Title,
		Size = UD2_N(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = COLORS.Accent,
		CanvasSize = UD2_N(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = self.ContentCanvas,
	})
	AddPadding(self.ScrollFrame, 8)
	AddListLayout(self.ScrollFrame, 8)

	self._maid:Add(self.Button.MouseEnter:Connect(function()
		if not self.Active then
			Tween(self.Button, 0.2, { BackgroundColor3 = COLORS.TabHover })
		end
	end))

	self._maid:Add(self.Button.MouseLeave:Connect(function()
		if not self.Active then
			Tween(self.Button, 0.2, { BackgroundColor3 = COLORS.TabInactive })
		end
	end))

	self._maid:Add(self.Button.MouseButton1Click:Connect(function()
		window:SwitchTab(self)
	end))

	return self
end

function Tab:NewSection(config: SectionConfig): SectionObject
	local section = Section.new(self, config)
	table.insert(self.Sections, section)
	return section
end

function Tab:SetActive(active: boolean)
	self.Active = active
	if active then
		Tween(self.Button, 0.3, { BackgroundColor3 = COLORS.TabActive })
		Tween(self.ButtonLabel, 0.3, { TextColor3 = C3_FRGB(255, 255, 255) })
		self.ContentCanvas.Visible = true
		self.ContentCanvas.GroupTransparency = 1
		Tween(self.ContentCanvas, 0.35, { GroupTransparency = 0 })
	else
		Tween(self.Button, 0.3, { BackgroundColor3 = COLORS.TabInactive })
		Tween(self.ButtonLabel, 0.3, { TextColor3 = COLORS.TextDim })
		local canvas = self.ContentCanvas
		Tween(canvas, 0.2, { GroupTransparency = 1 })
		task.delay(0.2, function()
			if not self.Active then
				canvas.Visible = false
			end
		end)
	end
end

function Tab:SetVisible(visible: boolean)
	self.Visible = visible
	self.Button.Visible = visible
	if not visible then
		if self.Active then
			self:SetActive(false)
		end
	end
	self.ContentCanvas.Visible = visible and self.ContentCanvas.Visible or false
end

function Tab:Destroy()
	for _, section in self.Sections do
		section:Destroy()
	end
	self._maid:Destroy()
end

local Window = {}
Window.__index = Window

function Window.new(config: WindowConfig): WindowObject
	local self = setmetatable({}, Window)
	self._maid = Maid.new()
	self.Title = config.Title or "Settings"

	if config.OverrideSize then
		self.Size = config.Size
	else
		self.Size = CalculateWindowSize()
		self._maid:Add(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			self.Size = CalculateWindowSize()
			if self.IsOpen and (self.MainFrame and self.MainFrame:IsA("GuiObject")) then
				if self.IsMinimized then
					Tween(self.MainFrame, 0.3, { Size = UD2_N(self.Size.X.Scale, self.Size.X.Offset, 0, 40) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				else
					Tween(self.MainFrame, 0.3, { Size = self.Size }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				end
			end
		end))
	end

	self.Parent = config.Parent or nil
	self.Tabs = {}
	self.ActiveTab = nil
	self._visibilityButtons = {}
	self._currentColorPicker = nil
	self.IsMinimized = false

	local startVisible = true
	if config.StartVisible ~= nil then
		startVisible = not not config.StartVisible
	end
	self.IsOpen = startVisible

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	if not self.Parent then
		self.ScreenGui = Create("ScreenGui", {
			Name = "SettingsUI",
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			Parent = playerGui,
		})
	else
		self.ScreenGui = self.Parent
	end

	self.MainFrame = Create("CanvasGroup", {
		Name = "MainFrame",
		Size = self.Size,
		Position = UD2_N(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = COLORS.Background,
		BorderSizePixel = 0,
		GroupTransparency = 0,
		ClipsDescendants = true,
		Parent = self.ScreenGui,
	})
	AddCorner(self.MainFrame, 12)

	self.MainFrameStroke = AddStroke(self.MainFrame, COLORS.Border, 1)
	self.MainFrameStroke.Transparency = startVisible and 0 or 1

	Create("Frame", {
		Name = "Shadow",
		Size = UD2_N(1, 30, 1, 30),
		Position = UD2_N(0.5, 0, 0.5, 5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = COLORS.Shadow,
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0,
		ZIndex = 0,
		Parent = self.MainFrame,
	})
	AddCorner(self.MainFrame:FindFirstChild("Shadow"), 16)

	self.TopBar = Create("Frame", {
		Name = "TopBar",
		Size = UD2_N(1, 0, 0, 40),
		BackgroundColor3 = COLORS.TopBar,
		BorderSizePixel = 0,
		Parent = self.MainFrame,
	})
	AddCorner(self.TopBar, 12)

	Create("Frame", {
		Size = UD2_N(1, 0, 0, 12),
		Position = UD2_N(0, 0, 1, -12),
		BackgroundColor3 = COLORS.TopBar,
		BorderSizePixel = 0,
		Parent = self.TopBar,
	})

	self.TitleLabel = Create("TextLabel", {
		Size = UD2_N(1, -90, 1, 0),
		Position = UD2_N(0, 14, 0, 0),
		BackgroundTransparency = 1,
		Text = self.Title,
		TextColor3 = COLORS.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self.TopBar,
	})

	local closeBtn = Create("TextButton", {
		Size = UD2_N(0, 28, 0, 28),
		Position = UD2_N(1, -36, 0.5, -14),
		BackgroundColor3 = COLORS.CloseBtn,
		BorderSizePixel = 0,
		Text = "×",
		TextColor3 = C3_FRGB(255, 255, 255),
		TextSize = 24,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		Parent = self.TopBar,
	})
	AddCorner(closeBtn, 6)

	closeBtn.MouseEnter:Connect(function()
		Tween(closeBtn, 0.15, { BackgroundColor3 = COLORS.CloseBtnHover })
	end)
	closeBtn.MouseLeave:Connect(function()
		Tween(closeBtn, 0.15, { BackgroundColor3 = COLORS.CloseBtn })
	end)
	closeBtn.MouseButton1Click:Connect(function()
		self:SetVisible(false)
	end)

	local minimizeBtn = Create("TextButton", {
		Size = UD2_N(0, 28, 0, 28),
		Position = UD2_N(1, -68, 0.5, -14),
		BackgroundColor3 = COLORS.TabInactive,
		BorderSizePixel = 0,
		Text = "-",
		TextColor3 = COLORS.Text,
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		Parent = self.TopBar,
	})
	AddCorner(minimizeBtn, 6)

	minimizeBtn.MouseEnter:Connect(function()
		Tween(minimizeBtn, 0.15, { BackgroundColor3 = COLORS.TabHover })
	end)
	minimizeBtn.MouseLeave:Connect(function()
		Tween(minimizeBtn, 0.15, { BackgroundColor3 = COLORS.TabInactive })
	end)
	minimizeBtn.MouseButton1Click:Connect(function()
		self:Minimize()
	end)

	self.TabBar = Create("Frame", {
		Name = "TabBar",
		Size = UD2_N(1, 0, 0, 40),
		Position = UD2_N(0, 0, 0, 40),
		BackgroundColor3 = COLORS.TabBar,
		BorderSizePixel = 0,
		Parent = self.MainFrame,
	})

	self.TabScroller = Create("ScrollingFrame", {
		Size = UD2_N(1, -16, 1, -8),
		Position = UD2_N(0, 8, 0, 4),
		BackgroundTransparency = 1,
		Parent = self.TabBar,
		ScrollingDirection = Enum.ScrollingDirection.X,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		ScrollBarImageColor3 = COLORS.Accent,
		ClipsDescendants = true,
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasSize = UD2_N(0, 0, 0, 0),
	})

	self.TabHolder = Create("Frame", {
		Size = UD2_N(1, 0, 1, 0),
		Position = UD2_N(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Parent = self.TabScroller,
	})
	AddListLayout(self.TabHolder, 4, Enum.FillDirection.Horizontal)

	self.ContentArea = Create("Frame", {
		Name = "ContentArea",
		Size = UD2_N(1, 0, 1, -80),
		Position = UD2_N(0, 0, 0, 80),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = self.MainFrame,
	})

	self.ColorPickerShadow = Create("Frame", {
		Name = "ColorPickerShadow",
		Size = UD2_N(1, 0, 1, 0),
		BackgroundColor3 = C3_FRGB(0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 1000,
		Visible = false,
		Parent = self.MainFrame,
	})
	AddCorner(self.ColorPickerShadow, 12)

	local shadowBtn = Create("TextButton", {
		Size = UD2_N(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 1000,
		Parent = self.ColorPickerShadow,
	})

	shadowBtn.MouseButton1Click:Connect(function()
		if self._currentColorPicker then
			self._currentColorPicker:_Close()
		end
	end)

	local dragging = false
	local dragStart = nil
	local startPos = nil

	self._maid:Add(self.TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = self.MainFrame.Position
		end
	end))

	self._maid:Add(UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			self.MainFrame.Position = UD2_N(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end))

	self._maid:Add(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end))

	self._minimizeBtn = minimizeBtn

	if startVisible then
		self.MainFrame.Size = UD2_N(0, 0, 0, 0)
		self.MainFrame.GroupTransparency = 1
		Tween(self.MainFrame, 0.5, { Size = self.Size, GroupTransparency = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	else
		self.MainFrame.Size = UD2_N(0, 0, 0, 0)
		self.MainFrame.GroupTransparency = 1
	end

	return self
end

function Window:Minimize()
	if self.IsMinimized then
		self.IsMinimized = false
		self._minimizeBtn.Text = "-"
		Tween(self.MainFrame, 0.4, { Size = self.Size }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	else
		self.IsMinimized = true
		self._minimizeBtn.Text = "+"
		Tween(self.MainFrame, 0.35, { Size = UD2_N(self.Size.X.Scale, self.Size.X.Offset, 0, 40) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	end
end

function Window:Destroy()
	for _, tab in self.Tabs do
		tab:Destroy()
	end
	self._maid:Destroy()
	self.ScreenGui:Destroy()
end

function Window:AddTab(config: TabConfig): TabObject
	local tab = Tab.new(self, config)
	table.insert(self.Tabs, tab)
	if #self.Tabs == 1 then
		self:SwitchTab(tab)
	end
	return tab
end

function Window:SwitchTab(newTab: TabObject)
	if self.ActiveTab == newTab then return end
	if self.ActiveTab then
		self.ActiveTab:SetActive(false)
	end
	self.ActiveTab = newTab
	newTab:SetActive(true)
end

function Window:SetVisible(visible: boolean?)
	if visible == nil then visible = not self.IsOpen end
	if visible == self.IsOpen then return end
	self.IsOpen = visible
	for _, btn in (self._visibilityButtons or {}) do
		if btn and btn.Parent then
			if btn:IsA("TextButton") then
				btn.Text = self.IsOpen and self.HideText or self.ShowText
			elseif btn:IsA("ImageButton") then
				if btn:GetAttribute("OriginalImageTransparency") == nil then
					btn:SetAttribute("OriginalImageTransparency", btn.ImageTransparency)
				end
				btn.ImageTransparency = self.IsOpen and btn:GetAttribute("OriginalImageTransparency") or 0.5
			end
		end
	end
	if self.IsOpen then
		local targetSize = self.IsMinimized and UD2_N(self.Size.X.Scale, self.Size.X.Offset, 0, 40) or self.Size
		Tween(self.MainFrame, 0.5, { Size = targetSize, GroupTransparency = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		Tween(self.MainFrameStroke, 0.4, { Transparency = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	else
		if self.IsMinimized then
			self.IsMinimized = false
			self._minimizeBtn.Text = "-"
		end
		Tween(self.MainFrame, 0.4, { Size = UD2_N(0, 0, 0, 0), GroupTransparency = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		Tween(self.MainFrameStroke, 0.4, { Transparency = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	end
end

function Window:Toggle()
	self:SetVisible(not self.IsOpen)
end

function Window:AttachVisibilityButton(config: VisibilityButtonConfig)
	local button = config.Button
	self.ShowText = config.ShowText or "Show"
	self.HideText = config.HideText or "Hide"
	if not button then return end
	table.insert(self._visibilityButtons, button)
	if button:IsA("TextButton") then
		button.Text = self.IsOpen and self.HideText or self.ShowText
	elseif button:IsA("ImageButton") then
		if button:GetAttribute("OriginalImageTransparency") == nil then
			button:SetAttribute("OriginalImageTransparency", button.ImageTransparency)
		end
		button.ImageTransparency = self.IsOpen and button:GetAttribute("OriginalImageTransparency") or 0.5
	end
	button.MouseButton1Click:Connect(function()
		self:SetVisible(not self.IsOpen)
	end)
end

function Library:Window(config: WindowConfig): WindowObject
	return Window.new(config or {})
end

function Library:Notify(config: NotifyConfig)
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local notifGui = playerGui:FindFirstChild("NotificationUI")
	if not notifGui then
		notifGui = Create("ScreenGui", {
			Name = "NotificationUI",
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			Parent = playerGui,
		})
		local container = Create("Frame", {
			Name = "NotificationContainer",
			Size = UD2_N(0, 320, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UD2_N(1, -10, 1, -10),
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			ZIndex = 2000,
			Parent = notifGui,
		})
		AddListLayout(container, 8, Enum.FillDirection.Vertical, Enum.SortOrder.LayoutOrder)
		container.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	end
	local container = notifGui:FindFirstChild("NotificationContainer")
	local title = config.Title or "Notification"
	local titleSize = config.TitleTextSize or 14
	local content = config.Content or ""
	local contentSize = config.ContentTextSize or 12
	local duration = config.Duration or 3
	local hasContent = content ~= ""
	local notifHeight = hasContent and 70 or 50
	local notificationColor = config.NotificationColor or COLORS.NotificationBg
	local notificationBorderColor = config.NotificationBorderColor or COLORS.NotificationBorder
	local titleTextColor = config.TitleTextColor or COLORS.Text
	local contentTextColor = config.ContentTextColor or COLORS.TextDim
	local durationBarColor = config.DurationBarColor or notificationBorderColor or COLORS.Accent or C3_FRGB(88, 101, 242)

	local notif = Create("CanvasGroup", {
		Name = "Notification",
		Size = UD2_N(1, 0, 0, 0),
		BackgroundColor3 = notificationColor,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		LayoutOrder = 1,
		Parent = container,
	})
	AddCorner(notif, 10)
	AddStroke(notif, notificationBorderColor, 2)

	local contentFrame = Create("Frame", {
		Size = UD2_N(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = notif,
	})
	AddPadding(contentFrame, 12)

	Create("TextLabel", {
		Size = UD2_N(1, 0, 0, titleSize + 4),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = titleTextColor,
		TextSize = titleSize,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = contentFrame,
	})

	if hasContent then
		Create("TextLabel", {
			Size = UD2_N(1, 0, 1, -(titleSize + 8)),
			Position = UD2_N(0, 0, 0, titleSize + 4),
			BackgroundTransparency = 1,
			Text = content,
			TextColor3 = contentTextColor,
			TextSize = contentSize,
			Font = Enum.Font.GothamMedium,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			Parent = contentFrame,
		})
	end

	local durationBar = Create("Frame", {
		Name = "DurationBar",
		Size = UD2_N(1, 0, 0, 3),
		Position = UD2_N(0, 0, 1, -3),
		BackgroundColor3 = durationBarColor,
		BorderSizePixel = 0,
		Parent = notif,
	})
	AddCorner(durationBar, 10)

	Tween(notif, 0.4, { Size = UD2_N(1, 0, 0, notifHeight), GroupTransparency = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	task.delay(0.4, function()
		Tween(durationBar, duration, { Size = UD2_N(0, 0, 0, 3) }, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	end)

	local function shrinkNotification()
		Tween(notif, 0.3, { Size = UD2_N(1, 0, 0, 0), GroupTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
		task.delay(0.3, function()
			notif:Destroy()
		end)
	end

	notif.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			shrinkNotification()
		end
	end)

	task.delay(duration, shrinkNotification)
end

function Library:NewAuth(config: NewAuthConfig)
	config = config or {}
	local title = config.Title or "Key System"
	local getKey = config.GetKey
	local authFn = config.Auth
	local freeze = config.Freeze

	if authFn then
		local ok = pcall(function()
			if debug.info(authFn, "s") == "[C]" then
				error("native")
			end
		end)
		if not ok then
			warn("[NewAuth] Auth function must not be a C function.")
			return
		end
	end

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local authGui = Create("ScreenGui", {
		Name = "AuthUI",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = playerGui,
	})

	local overlay = Create("Frame", {
		Size = UD2_N(1, 0, 1, 0),
		BackgroundColor3 = C3_FRGB(0, 0, 0),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ZIndex = 1,
		Parent = authGui,
	})
	Tween(overlay, 0.6, { BackgroundTransparency = 0.55 }, Enum.EasingStyle.Quint)

	local cardW, cardH = 360, 192

	local card = Create("CanvasGroup", {
		Name = "AuthCard",
		Size = UD2_N(0, cardW, 0, 0),
		Position = UD2_N(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = COLORS.Background,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		ClipsDescendants = true,
		ZIndex = 10,
		Parent = authGui,
	})
	AddCorner(card, 12)
	AddStroke(card, COLORS.Border, 1)

	Create("ImageLabel", {
		Name = "Shadow",
		Size = UD2_N(1, 40, 1, 40),
		Position = UD2_N(0.5, 0, 0.5, 6),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 0,
		Image = "rbxassetid://6015897843",
		ImageColor3 = C3_FRGB(0, 0, 0),
		ImageTransparency = 0.45,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		Parent = card,
	})

	local topBar = Create("Frame", {
		Name = "TopBar",
		Size = UD2_N(1, 0, 0, 44),
		BackgroundColor3 = COLORS.TopBar,
		BorderSizePixel = 0,
		ZIndex = 11,
		Parent = card,
	})
	AddCorner(topBar, 12)
	Create("Frame", {
		Size = UD2_N(1, 0, 0, 12),
		Position = UD2_N(0, 0, 1, -12),
		BackgroundColor3 = COLORS.TopBar,
		BorderSizePixel = 0,
		ZIndex = 11,
		Parent = topBar,
	})

	local titleLabel = Create("TextLabel", {
		Size = UD2_N(1, -52, 1, 0),
		Position = UD2_N(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = COLORS.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 12,
		Parent = topBar,
	})
	Create("UIGradient", {
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.75, 0.15),
			NumberSequenceKeypoint.new(1, 0.5),
		}),
		Parent = titleLabel,
	})

	local closeBtn = Create("TextButton", {
		Size = UD2_N(0, 26, 0, 26),
		Position = UD2_N(1, -36, 0.5, -13),
		BackgroundColor3 = COLORS.CloseBtn,
		BorderSizePixel = 0,
		Text = "×",
		TextColor3 = C3_FRGB(255, 255, 255),
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		ZIndex = 12,
		Parent = topBar,
	})
	AddCorner(closeBtn, 6)

	closeBtn.MouseEnter:Connect(function()
		Tween(closeBtn, 0.15, { BackgroundColor3 = COLORS.CloseBtnHover })
	end)
	closeBtn.MouseLeave:Connect(function()
		Tween(closeBtn, 0.15, { BackgroundColor3 = COLORS.CloseBtn })
	end)

	local sep = Create("Frame", {
		Size = UD2_N(1, -24, 0, 1),
		Position = UD2_N(0, 12, 0, 57),
		BackgroundColor3 = COLORS.Border,
		BorderSizePixel = 0,
		ZIndex = 11,
		Parent = card,
	})
	AddCorner(sep, 1)
	Create("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.08, 0),
			NumberSequenceKeypoint.new(0.92, 0),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Parent = sep,
	})

	Create("TextLabel", {
		Size = UD2_N(1, -24, 0, 20),
		Position = UD2_N(0.5, 0, 0, 65),
		BackgroundTransparency = 1,
		Text = "Enter your license key below to continue.",
		TextColor3 = COLORS.TextMuted,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		ZIndex = 11,
		Parent = card,
		AnchorPoint = Vector2.new(0.5, 0),
	})

	local inputHolder = Create("Frame", {
		Name = "InputHolder",
		Size = UD2_N(1, -24, 0, 36),
		Position = UD2_N(0, 12, 0, 96),
		BackgroundColor3 = COLORS.InputBg,
		BorderSizePixel = 0,
		ZIndex = 11,
		Parent = card,
		ClipsDescendants = true,
	})
	AddCorner(inputHolder, 8)
	local inputStroke = AddStroke(inputHolder, COLORS.Border, 1)

	local keyInput = Create("TextBox", {
		Size = UD2_N(1, -20, 1, 0),
		Position = UD2_N(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Text = "",
		PlaceholderText = "Paste or type your key here...",
		PlaceholderColor3 = COLORS.TextMuted,
		TextColor3 = COLORS.Text,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		ClearTextOnFocus = false,
		ZIndex = 12,
		Parent = inputHolder,
	})

	local inputFocused = false
	keyInput.Focused:Connect(function()
		inputFocused = true
		Tween(inputStroke, 0.2, { Color = COLORS.Accent })
	end)
	keyInput.FocusLost:Connect(function()
		inputFocused = false
		Tween(inputStroke, 0.2, { Color = COLORS.Border })
	end)

	local btnY = 144
	local btnH = 36
	local gap = 8

	local getKeyFrame = Create("Frame", {
		Size = UD2_N(0, 0, 0, btnH),
		Position = UD2_N(0, 12, 0, btnY),
		BackgroundColor3 = COLORS.TabInactive,
		BorderSizePixel = 0,
		ZIndex = 11,
		Parent = card,
	})
	AddCorner(getKeyFrame, 8)
	AddStroke(getKeyFrame, COLORS.Border, 1)

	local getKeyBtn = Create("TextButton", {
		Size = UD2_N(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "GET KEY",
		TextColor3 = COLORS.TextDim,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		ZIndex = 12,
		Parent = getKeyFrame,
	})
	AddCorner(getKeyBtn, 8)

	local activateFrame = Create("Frame", {
		Size = UD2_N(0, 0, 0, btnH),
		Position = UD2_N(0, 12, 0, btnY),
		BackgroundColor3 = COLORS.Accent,
		BorderSizePixel = 0,
		ZIndex = 11,
		Parent = card,
	})
	AddCorner(activateFrame, 8)

	local activateBtn = Create("TextButton", {
		Size = UD2_N(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "ACTIVATE",
		TextColor3 = C3_FRGB(255, 255, 255),
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		ZIndex = 12,
		Parent = activateFrame,
	})
	AddCorner(activateBtn, 8)

	local function layoutButtons()
		local totalW = cardW - 24
		local getW = math.floor(totalW * 0.42)
		local actW = totalW - getW - gap
		getKeyFrame.Size = UD2_N(0, getW, 0, btnH)
		getKeyFrame.Position = UD2_N(0, 12, 0, btnY)
		activateFrame.Size = UD2_N(0, actW, 0, btnH)
		activateFrame.Position = UD2_N(0, 12 + getW + gap, 0, btnY)
	end
	layoutButtons()

	local statusLabel = Create("TextLabel", {
		Size = UD2_N(1, -24, 0, 16),
		Position = UD2_N(0, 12, 0, btnY + btnH + 12),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = C3_FRGB(255, 85, 85),
		TextSize = 11,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 11,
		Parent = card,
	})

	local successEvent = Instance.new("BindableEvent")
	local authed = false
	local activating = false
	local errorToken = 0

	local function setStatus(text, isError)
		statusLabel.TextColor3 = isError and C3_FRGB(255, 85, 85) or C3_FRGB(85, 220, 130)
		statusLabel.Text = text
	end

	local function shakeCard()
		local steps = { 8, -12, 9, -7, 4, -2, 0 }
		local shakeInfo = TweenInfo.new(0.055, Enum.EasingStyle.Linear)
		task.spawn(function()
			for _, offset in ipairs(steps) do
				TweenService:Create(card, shakeInfo, {
					Position = UD2_N(0.5, offset, 0.5, 0),
				}):Play()
				task.wait(0.058)
			end
			card.Position = UD2_N(0.5, 0, 0.5, 0)
		end)
	end

	local function closeAuth()
		Tween(overlay, 0.35, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quint)
		Tween(card, 0.4, { Size = UD2_N(0, cardW, 0, 0), GroupTransparency = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		task.delay(0.45, function()
			authGui:Destroy()
		end)
	end

	closeBtn.MouseButton1Click:Connect(function()
		closeAuth()
	end)

	getKeyBtn.MouseEnter:Connect(function()
		Tween(getKeyFrame, 0.2, { BackgroundColor3 = COLORS.TabHover })
		Tween(getKeyBtn, 0.2, { TextColor3 = COLORS.Text })
	end)
	getKeyBtn.MouseLeave:Connect(function()
		Tween(getKeyFrame, 0.2, { BackgroundColor3 = COLORS.TabInactive })
		Tween(getKeyBtn, 0.2, { TextColor3 = COLORS.TextDim })
	end)
	getKeyBtn.MouseButton1Down:Connect(function()
		Tween(getKeyFrame, 0.1, { Size = UD2_N(0, math.floor((cardW - 24) * 0.42) - 2, 0, btnH - 2) })
	end)
	getKeyBtn.MouseButton1Up:Connect(function()
		Tween(getKeyFrame, 0.1, { Size = UD2_N(0, math.floor((cardW - 24) * 0.42), 0, btnH) })
	end)
	getKeyBtn.MouseButton1Click:Connect(function()
		if getKey then task.spawn(getKey) end
	end)

	activateBtn.MouseEnter:Connect(function()
		Tween(activateFrame, 0.2, { BackgroundColor3 = COLORS.AccentHover })
	end)
	activateBtn.MouseLeave:Connect(function()
		if not authed then
			Tween(activateFrame, 0.2, { BackgroundColor3 = COLORS.Accent })
		end
	end)
	activateBtn.MouseButton1Down:Connect(function()
		local totalW = cardW - 24
		local actW = totalW - math.floor(totalW * 0.42) - gap
		Tween(activateFrame, 0.1, { Size = UD2_N(0, actW - 2, 0, btnH - 2) })
	end)
	activateBtn.MouseButton1Up:Connect(function()
		local totalW = cardW - 24
		local actW = totalW - math.floor(totalW * 0.42) - gap
		Tween(activateFrame, 0.1, { Size = UD2_N(0, actW, 0, btnH) })
	end)

	activateBtn.MouseButton1Click:Connect(function()
		if authed or activating then return end
		activating = true
		local inputText = keyInput.Text
		activateBtn.Text = "..."
		setStatus("", false)
		task.spawn(function()
			local ok, result = pcall(function()
				return authFn and authFn(inputText)
			end)
			if ok and result then
				authed = true
				activateBtn.Text = "✓"
				setStatus("Key accepted! Loading...", false)
				Tween(activateFrame, 0.3, { BackgroundColor3 = C3_FRGB(72, 199, 116) })
				Tween(inputStroke, 0.3, { Color = C3_FRGB(72, 199, 116) })
				keyInput.TextSize = 16
				keyInput.Text = string.rep("*", 20)
				task.wait(0.5)
				successEvent:Fire()
			else
				activateBtn.Text = "ACTIVATE"
				setStatus("Invalid key. Please try again.", true)
				errorToken += 1
				local myToken = errorToken
				Tween(inputStroke, 0.2, { Color = C3_FRGB(255, 75, 75) })
				task.delay(0.75, function()
					if myToken == errorToken and not inputFocused then
						Tween(inputStroke, 0.2, { Color = COLORS.Border })
					end
				end)
				shakeCard()
				activating = false
			end
		end)
	end)

	Tween(card, 0.5, { Size = UD2_N(0, cardW, 0, cardH), GroupTransparency = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	if freeze then
		successEvent.Event:Wait()
		task.wait(0.3)
		closeAuth()
	end

	return {
		Close = closeAuth,
		OnSuccess = successEvent.Event,
	}
end

function Library:SetTheme(Colors: ThemeColors)
	if not Colors then
		warn("No theme provided")
		return
	end
	if typeof(Colors) ~= "table" then
		warn("Invalid theme format")
		return
	end
	for key, value in Colors do
		if COLORS[key] ~= nil then
			COLORS[key] = value
		else
			warn("Unknown color key:", key)
		end
	end
end

function Library:SetPresetColors(Colors: { Color3 })
	if not Colors then
		warn("No preset colors provided")
		return
	end
	if typeof(Colors) ~= "table" then
		warn("Invalid preset colors format")
		return
	end
	PRESET_COLORS = Colors
end

return Library
