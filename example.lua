

local Lib = loadstring(game:HttpGet("https://pastefy.app/Y9mMGj4P/raw"))()

local Window = Lib:CreateWindow({
	Title = "Aether",
	Subtitle = "Expires: 17/09/2026",
	Icon = "zap",
	Folder = "Aether",
})

local Combat = Window:AddTab("Combat", "swords")
local Aim = Combat:AddSubTab("Aimbot")
local Targeting = Aim:AddLeftGroupbox("Targeting", { Icon = "crosshair" })
Targeting:AddToggle("AimEnabled", { Text = "Enabled", Default = true }):AddKeyPicker("AimKey", { Default = "MB2", Mode = "Hold" })
Targeting:AddDropdown("AimPart", { Text = "Target part", Values = { "Head", "Torso", "Closest" }, Default = 1 })
Targeting:AddDropdown("AimFilters", { Text = "Filters", Values = { "Teams", "Friends", "Visible", "Alive", "Forcefield" }, Default = { "Teams", "Alive" }, Multi = true })
Targeting:AddSlider("AimFov", { Text = "FOV", Min = 10, Max = 500, Default = 120, Suffix = "px" })
Targeting:AddSlider("AimSmooth", { Text = "Smoothing", Min = 0, Max = 1, Default = 0.35, Rounding = 2 })
Targeting:AddRange("AimDistance", { Text = "Distance range", Min = 0, Max = 1000, Default = { 0, 400 }, Suffix = "m" })

local Extra = Aim:AddRightGroupbox("Extras", { Icon = "sliders-horizontal", Collapsible = true })
Extra:AddToggle("ShowFov", { Text = "Draw FOV circle", Default = true }):AddColorPicker("FovColor", { Default = Color3.new(1, 1, 1) })
local Dep = Extra:AddDependencyBox()
Dep:AddSlider("FovThickness", { Text = "Circle thickness", Min = 1, Max = 5, Default = 1 })
Dep:SetupDependencies({ { Lib.Toggles.ShowFov, true } })
Extra:AddButtonRow({
	{ Text = "Say hi", Func = function() Lib:Notify({ Title = "Hello", Text = "Buttons work", Type = "info" }) end },
	{ Text = "Ask me", Func = function() Lib:Prompt({ Title = "Hey", Text = "What's your name?", Placeholder = "name" }, function(t) Lib:Notify({ Text = "Hi " .. t, Type = "success" }) end) end },
})

local Trig = Combat:AddSubTab("Triggerbot")
local T = Trig:AddLeftGroupbox("Trigger", { Icon = "mouse-pointer-click" })
T:AddToggle("TrigEnabled", { Text = "Enabled" })
T:AddSlider("TrigDelay", { Text = "Delay", Min = 0, Max = 500, Default = 50, Suffix = "ms" })

Lib:CreateChat({
	Url = "https://aether-chat.j6n7.workers.dev",
	Channels = {
		["Blox Fruits"] = 2753915549,
		["Arsenal"] = 286090429,
		-- 142823291, -- plain ids work too
	},
})


local Misc = Window:AddTab("Misc", "wrench")
local U = Misc:AddLeftGroupbox("Utility", { Icon = "toolbox" })
U:AddToggle("AntiAFK", { Text = "Anti AFK" }):AddKeyPicker("AntiAFKKey", { Default = "None", Mode = "Toggle", SyncToggleState = true })
U:AddInput("Note", { Text = "Note", Placeholder = "type something" })
U:AddDropdown("PlayerPicker", { Text = "Player", SpecialType = "Player", ExcludeLocalPlayer = true, AllowNull = true, Placeholder = "Pick a player" })
U:AddTextArea("Notes", { Text = "Scratchpad", Placeholder = "write anything...", Height = 70 })

local Visuals = Window:AddTab("Visuals", "eye")
local Preview
local function Opt(n) return function(v) if Preview then Preview:SetOption(n, v) end end end

local E = Visuals:AddLeftGroupbox("ESP", { Icon = "scan" })
E:AddToggle("ESPBox", { Text = "Box", Default = true, Callback = Opt("Box") }):AddColorPicker("ESPBoxColor", { Default = Color3.new(1, 1, 1), Callback = Opt("BoxColor") })
E:AddSegmented("ESPBoxStyle", { Text = "", Values = { "Corner", "Full" }, Default = 1, Callback = Opt("BoxStyle") })
E:AddToggle("ESPBoxFill", { Text = "Box fill", Default = false, Callback = Opt("BoxFill") }):AddColorPicker("ESPFillColor", { Default = Lib.Theme.Accent, Callback = Opt("FillColor") })
E:AddToggle("ESPName", { Text = "Name", Default = true, Callback = Opt("Name") }):AddColorPicker("ESPNameColor", { Default = Color3.new(1, 1, 1), Callback = Opt("NameColor") })
E:AddToggle("ESPHealth", { Text = "Health bar", Default = true, Callback = Opt("Health") })
E:AddToggle("ESPDist", { Text = "Distance", Default = true, Callback = Opt("Distance") })
E:AddToggle("ESPTool", { Text = "Held tool", Default = true, Callback = Opt("Tool") })
E:AddToggle("ESPSkeleton", { Text = "Skeleton", Default = true, Callback = Opt("Skeleton") }):AddColorPicker("ESPSkelColor", { Default = Color3.fromRGB(215, 215, 225), Callback = Opt("SkeletonColor") })
E:AddToggle("ESPFlags", { Text = "Flags", Default = true, Callback = Opt("Flags") })
E:AddToggle("ESPChams", { Text = "Chams", Default = false, Callback = Opt("Chams") }):AddColorPicker("ESPChamsColor", { Default = Color3.fromRGB(190, 200, 255), Callback = Opt("ChamsColor") })
E:AddToggle("ESPTracer", { Text = "Tracer", Default = false, Callback = Opt("Tracer") }):AddColorPicker("ESPTracerColor", { Default = Lib.Theme.Accent, Callback = Opt("TracerColor") })
E:AddToggle("ESPHeadDot", { Text = "Head dot", Default = false, Callback = Opt("HeadDot") }):AddColorPicker("ESPHeadDotColor", { Default = Color3.new(1, 1, 1), Callback = Opt("HeadDotColor") })

local P = Visuals:AddRightGroupbox("Preview", { Icon = "scan-face" })
P:AddToggle("Rotate", { Text = "Auto rotate", Default = true, Callback = Opt("Rotate") })
P:AddSlider("Speed", { Text = "Rotate speed", Min = 0.2, Max = 4, Default = 1, Rounding = 1, Callback = Opt("RotateSpeed") })
P:AddButton({ Text = "Refresh character", Icon = "refresh-cw", Func = function() if Preview then Preview:Rebuild() end end })

local Demo = Window:AddTab("Components", "layout-grid")

local Inputs = Demo:AddSubTab("Inputs")
local Tog = Inputs:AddLeftGroupbox("Toggles and buttons", { Icon = "toggle-right" })
Tog:AddToggle("DemoToggle", { Text = "Toggle", Default = true, Tooltip = "A normal on/off switch." })
Tog:AddToggle("DemoRisky", { Text = "Risky toggle", Risky = true })
Tog:AddToggle("DemoDisabled", { Text = "Disabled toggle", Disabled = true })
Tog:AddCheckbox("DemoCheck", { Text = "Checkbox", Default = true })
Tog:AddButton({ Text = "Button", Icon = "mouse-pointer-click", Func = function() Lib:Notify({ Text = "Button pressed", Type = "success" }) end })
Tog:AddButton({ Text = "Double-tap button", DoubleClick = true, Func = function() Lib:Notify({ Text = "Confirmed", Type = "warn" }) end })
Tog:AddButtonRow({
	{ Text = "One", Func = function() Lib:Notify({ Text = "One" }) end },
	{ Text = "Two", Func = function() Lib:Notify({ Text = "Two" }) end },
	{ Text = "Three", Func = function() Lib:Notify({ Text = "Three" }) end },
})

local Sld = Inputs:AddRightGroupbox("Sliders and text", { Icon = "sliders-horizontal" })
Sld:AddSlider("DemoSlider", { Text = "Slider", Min = 0, Max = 100, Default = 40, Suffix = "%" })
Sld:AddSlider("DemoDecimal", { Text = "Decimal slider", Min = 0, Max = 1, Default = 0.5, Rounding = 2 })
Sld:AddRange("DemoRange", { Text = "Range", Min = 0, Max = 100, Default = { 20, 70 } })
Sld:AddInput("DemoInput", { Text = "Text input", Placeholder = "type here" })
Sld:AddInput("DemoNumeric", { Text = "Numeric input", Numeric = true, Default = "10" })
Sld:AddTextArea("DemoArea", { Text = "Text area", Placeholder = "multi-line...", Height = 64 })

local Pick = Demo:AddSubTab("Pickers")
local Drop = Pick:AddLeftGroupbox("Dropdowns", { Icon = "list" })
Drop:AddDropdown("DemoDrop", { Text = "Single select", Values = { "Alpha", "Beta", "Gamma" }, Default = 1 })
Drop:AddDropdown("DemoMulti", { Text = "Multi select", Values = { "Red", "Green", "Blue", "Yellow" }, Multi = true, Default = { "Red" } })
Drop:AddDropdown("DemoNull", { Text = "Optional", Values = { "One", "Two" }, AllowNull = true, Placeholder = "Nothing picked" })
Drop:AddDropdown("DemoPlayers", { Text = "Players", SpecialType = "Player", AllowNull = true, Placeholder = "Pick a player" })
Drop:AddSegmented("DemoSeg", { Text = "Segmented", Values = { "Low", "Mid", "High" }, Default = 2 })

local Col = Pick:AddRightGroupbox("Colors and keys", { Icon = "palette" })
Col:AddLabel("Color picker"):AddColorPicker("DemoColor", { Default = Color3.fromRGB(116, 148, 242) })
Col:AddLabel("With transparency"):AddColorPicker("DemoColorAlpha", { Default = Color3.fromRGB(240, 90, 90), Transparency = 0.2 })
Col:AddLabel("Key: toggle"):AddKeyPicker("DemoKeyToggle", { Default = "F", Mode = "Toggle" })
Col:AddLabel("Key: hold"):AddKeyPicker("DemoKeyHold", { Default = "G", Mode = "Hold" })
Col:AddLabel("Key: always"):AddKeyPicker("DemoKeyAlways", { Default = "None", Mode = "Always" })
Col:AddColorPicker("DemoStandalone", { Text = "Standalone color", Default = Color3.fromRGB(90, 200, 140) })
Col:AddKeyPicker("DemoStandaloneKey", { Text = "Standalone key", Default = "H", Mode = "Toggle" })

local Disp = Demo:AddSubTab("Display")
local Info = Disp:AddLeftGroupbox("Text and layout", { Icon = "type" })
Info:AddSection("Section header")
Info:AddLabel("A normal label that wraps onto more lines when the text is long enough to need it.")
Info:AddParagraph("Paragraph", "A bold title with smaller body text underneath.")
Info:AddDivider()
Info:AddDivider("Divider with text")
Info:AddCallout("Info callout", "info")
Info:AddCallout("Success callout", "success")
Info:AddCallout("Warning callout", "warn")
Info:AddCallout("Error callout", "error")
Info:AddBlank(8)
Info:AddImage({ Image = "rbxassetid://7733715400", Height = 60 })

local Live = Disp:AddRightGroupbox("Live widgets", { Icon = "gauge" })
local DemoStat = Live:AddStat("DemoStat", { Text = "Stat", Default = "0" })
local DemoProg = Live:AddProgress("DemoProgress", { Text = "Progress", Default = 25 })
local DemoLog = Live:AddLog("DemoLog", { Height = 100 })
Live:AddButtonRow({
	{ Text = "Add log", Func = function() DemoLog:Log("Something happened", "info") end },
	{ Text = "Warn", Func = function() DemoLog:Log("Careful now", "warn") end },
	{ Text = "Error", Func = function() DemoLog:Log("It broke", "bad") end },
})
Live:AddButtonRow({
	{ Text = "Stat +1", Func = function() DemoStat:SetValue(tostring((tonumber(DemoStat.Value) or 0) + 1), Lib.Theme.Good) end },
	{ Text = "Progress +10", Func = function() DemoProg:SetValue((DemoProg.Value + 10) % 110) end },
})

local Pop = Demo:AddSubTab("Popups")
local Dlg = Pop:AddLeftGroupbox("Dialogs and notices", { Icon = "message-square" })
Dlg:AddButton({ Text = "Notify: info", Func = function() Lib:Notify({ Title = "Info", Text = "Something to know", Type = "info" }) end })
Dlg:AddButton({ Text = "Notify: success", Func = function() Lib:Notify({ Title = "Done", Text = "That worked", Type = "success" }) end })
Dlg:AddButton({ Text = "Notify: warning", Func = function() Lib:Notify({ Title = "Careful", Text = "Check this first", Type = "warn" }) end })
Dlg:AddButton({ Text = "Notify: error", Func = function() Lib:Notify({ Title = "Failed", Text = "Something went wrong", Type = "error" }) end })
Dlg:AddButton({ Text = "Confirm dialog", Func = function()
	Lib:Dialog({ Title = "Are you sure?", Text = "This is a two-button dialog.", Buttons = { { Text = "No" }, { Text = "Yes", Primary = true, Callback = function() Lib:Notify({ Text = "You said yes", Type = "success" }) end } } })
end })
Dlg:AddButton({ Text = "Text prompt", Func = function()
	Lib:Prompt({ Title = "Rename", Text = "Pick a new name", Default = "Aether", Confirm = "Save" }, function(t) Lib:Notify({ Text = "Saved: " .. t, Type = "success" }) end)
end })

local Opts = Pop:AddRightGroupbox("Reading values", { Icon = "book-open" })
Opts:AddLabel("Every element supports Callback, OnChanged and SetValue. Values are also in Lib.Options, Lib.Toggles and Lib.Flags.")
Opts:AddButton({ Text = "Print toggle + slider to log", Func = function()
	DemoLog:Log("Toggle = " .. tostring(Lib.Toggles.DemoToggle.Value) .. ", Slider = " .. tostring(Lib.Options.DemoSlider.Value), "good")
end })

Lib:BuildSettingsTab(Window)
Lib:CreateWatermark()
Lib:CreateKeybindList()
Preview = Lib:CreateESPPreview()

Lib:CreateChat({ Url = "https://aether-chat.j6n7.workers.dev" })

Lib:Notify({ Title = Lib.Name, Text = Lib.Touch and "Loaded. Tap the floating button to hide or show." or "Loaded. Press RightShift to hide or show.", Type = "success" })
Lib:LoadAutoload()