--// AETHER UI - FULL EXAMPLE
--// UI demonstration using the Aether library

local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jaylensotufffff/aether-ui-release-v1.00/main/library.lua"))()

--// WINDOW

local Window = Lib:CreateWindow({
    Title = "Aether",
    Subtitle = "Full UI Example",
    Icon = "zap",
    Folder = "Aether",
    Version = "1.0.0",
    EnvKey = "__AetherUI",
})

--// MAIN TAB

local Main = Window:AddTab("Main", "sparkles")

local Welcome = Main:AddLeftGroupbox("Welcome", {
    Icon = "sparkles"
})

Welcome:AddParagraph(
    "Welcome to Aether",
    "A fully featured Roblox UI with a clean interface, mobile support, customization and configuration options."
)

Welcome:AddLabel("Version: 1.0.0")
Welcome:AddLabel("Status: Loaded")

Welcome:AddButton({
    Text = "Test Notification",
    Icon = "bell",
    Func = function()
        Lib:Notify({
            Title = "Aether",
            Text = "Everything is working!",
            Type = "success",
            Duration = 4
        })
    end
})

local Player = Main:AddRightGroupbox("Player Information", {
    Icon = "user"
})

Player:AddToggle("PlayerExample", {
    Text = "Example Toggle",
    Default = false
})

Player:AddSlider("PlayerValue", {
    Text = "Example Value",
    Min = 0,
    Max = 100,
    Default = 50,
    Suffix = "%"
})

Player:AddDropdown("PlayerMode", {
    Text = "Mode",
    Values = {
        "Default",
        "Performance",
        "Quality"
    },
    Default = 1
})

--// COMBAT TAB

local Combat = Window:AddTab("Combat", "swords")

local Aimbot = Combat:AddSubTab("Aimbot")

local AimSettings = Aimbot:AddLeftGroupbox("Aimbot Settings", {
    Icon = "crosshair"
})

AimSettings:AddToggle("AimbotEnabled", {
    Text = "Enabled",
    Default = false
})

AimSettings:AddToggle("AimbotTeamCheck", {
    Text = "Team Check",
    Default = true
})

AimSettings:AddSlider("AimbotFOV", {
    Text = "Field Of View",
    Min = 10,
    Max = 500,
    Default = 120,
    Suffix = "px"
})

AimSettings:AddDropdown("AimbotPart", {
    Text = "Target Part",
    Values = {
        "Head",
        "Torso",
        "HumanoidRootPart"
    },
    Default = 1
})

AimSettings:AddToggle("AimbotPrediction", {
    Text = "Prediction",
    Default = false
})

local AimExtra = Aimbot:AddRightGroupbox("Extra Settings", {
    Icon = "settings"
})

AimExtra:AddToggle("AimbotDrawFOV", {
    Text = "Draw FOV",
    Default = true
})

AimExtra:AddSlider("AimbotSmoothness", {
    Text = "Smoothness",
    Min = 1,
    Max = 20,
    Default = 5
})

AimExtra:AddLabel("Aim Key"):AddKeyPicker("AimbotKey", {
    Default = "MB2",
    Mode = "Hold"
})

--// TRIGGERBOT SUBTAB

local Triggerbot = Combat:AddSubTab("Triggerbot")

local TriggerSettings = Triggerbot:AddLeftGroupbox("Trigger Settings", {
    Icon = "target"
})

TriggerSettings:AddToggle("TriggerbotEnabled", {
    Text = "Enabled",
    Default = false
})

TriggerSettings:AddSlider("TriggerbotDelay", {
    Text = "Delay",
    Min = 0,
    Max = 1000,
    Default = 100,
    Suffix = "ms"
})

--// VISUALS TAB

local Visuals = Window:AddTab("Visuals", "eye")

local ESP = Visuals:AddSubTab("ESP")

local ESPSettings = ESP:AddLeftGroupbox("ESP Settings", {
    Icon = "scan"
})

ESPSettings:AddToggle("ESPEnabled", {
    Text = "Enabled",
    Default = false
})

ESPSettings:AddToggle("ESPNames", {
    Text = "Names",
    Default = true
})

ESPSettings:AddToggle("ESPBoxes", {
    Text = "Boxes",
    Default = true
})

ESPSettings:AddToggle("ESPHealth", {
    Text = "Health",
    Default = true
})

ESPSettings:AddToggle("ESPDistance", {
    Text = "Distance",
    Default = false
})

ESPSettings:AddToggle("ESPTracers", {
    Text = "Tracers",
    Default = false
})

local ESPAppearance = ESP:AddRightGroupbox("Appearance", {
    Icon = "palette"
})

ESPAppearance:AddDropdown("ESPBoxStyle", {
    Text = "Box Style",
    Values = {
        "2D",
        "Corner",
        "3D"
    },
    Default = 1
})

ESPAppearance:AddSlider("ESPThickness", {
    Text = "Thickness",
    Min = 1,
    Max = 5,
    Default = 2
})

ESPAppearance:AddLabel("ESP Color"):AddColorPicker("ESPColor", {
    Default = Color3.fromRGB(170, 100, 255)
})

--// OTHER VISUALS

local OtherVisuals = Visuals:AddSubTab("Other")

local OtherSettings = OtherVisuals:AddLeftGroupbox("Other Visuals", {
    Icon = "eye"
})

OtherSettings:AddToggle("Fullbright", {
    Text = "Fullbright",
    Default = false
})

OtherSettings:AddToggle("NoFog", {
    Text = "Remove Fog",
    Default = false
})

OtherSettings:AddToggle("Crosshair", {
    Text = "Crosshair",
    Default = false
})

--// INTERFACE TAB

local Interface = Window:AddTab("Interface", "monitor")

local InterfaceSettings = Interface:AddLeftGroupbox("Interface Settings", {
    Icon = "sliders-horizontal"
})

InterfaceSettings:AddParagraph(
    "Customization",
    "Change the appearance and behavior of your Aether interface in the Settings tab."
)

InterfaceSettings:AddButton({
    Text = "Show Notification",
    Func = function()
        Lib:Notify({
            Title = "Interface",
            Text = "Notification test successful.",
            Type = "info"
        })
    end
})

--// COMPONENT SHOWCASE

local Showcase = Window:AddTab("Showcase", "layout")

local Components = Showcase:AddLeftGroupbox("Components", {
    Icon = "component"
})

Components:AddToggle("ShowcaseToggle", {
    Text = "Toggle Example",
    Default = true
})

Components:AddCheckbox("ShowcaseCheckbox", {
    Text = "Checkbox Example",
    Default = false
})

Components:AddSlider("ShowcaseSlider", {
    Text = "Slider Example",
    Min = 0,
    Max = 100,
    Default = 40
})

Components:AddRange("ShowcaseRange", {
    Text = "Range Example",
    Min = 0,
    Max = 100,
    Default = {20, 80}
})

Components:AddInput("ShowcaseInput", {
    Text = "Input Example",
    Placeholder = "Enter something..."
})

Components:AddTextArea("ShowcaseTextArea", {
    Text = "Text Area",
    Height = 80
})

local Pickers = Showcase:AddRightGroupbox("Pickers", {
    Icon = "palette"
})

Pickers:AddDropdown("ShowcaseDropdown", {
    Text = "Dropdown",
    Values = {
        "Option 1",
        "Option 2",
        "Option 3"
    },
    Default = 1
})

Pickers:AddSegmented("ShowcaseSegmented", {
    Text = "Segmented Control",
    Values = {
        "Low",
        "Medium",
        "High"
    },
    Default = 2
})

Pickers:AddLabel("Color Picker"):AddColorPicker("ShowcaseColor", {
    Default = Color3.fromRGB(170, 100, 255)
})

Pickers:AddLabel("Keybind"):AddKeyPicker("ShowcaseKey", {
    Default = "F",
    Mode = "Toggle"
})

Pickers:AddDivider()

Pickers:AddCallout(
    "This is an example callout.",
    "success"
)

--// LOGS TAB

local Logs = Window:AddTab("Logs", "scroll-text")

local LogBox = Logs:AddLeftGroupbox("Activity Logs", {
    Icon = "terminal"
})

local ActivityLog = LogBox:AddLog({
    Height = 150
})

LogBox:AddButton({
    Text = "Add Log Entry",
    Func = function()
        ActivityLog:AddLog("Aether UI test successful.")
    end
})

--// ESP PREVIEW

Lib:HookESP(function(option, value)
    print("[Aether ESP]", option, value)
end)

Lib:CreateESPPreview()

Lib:SetPreviewData({
    Name = game:GetService'Players'.LocalPlayer.Name
    Health = 75,
    MaxHealth = 100,
    Distance = 25
})

--// SETTINGS

Lib:BuildSettingsTab(Window)

--// BUILT-IN EXTRAS

Lib:CreateWatermark()
Lib:CreateKeybindList()

--// LOAD CONFIG

Lib:LoadAutoload()

--// FINISHED

Lib:Notify({
    Title = "Aether",
    Text = "Full UI successfully loaded!",
    Type = "success",
    Duration = 5
})
