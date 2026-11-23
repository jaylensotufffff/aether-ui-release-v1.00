
--// AETHER UI - SCRIPT HUB
--// UI ONLY - NO FEATURE LOGIC

local Lib = loadstring(game:HttpGet("https://pastefy.app/5DinBZr1/raw"))()

--// WINDOW

local Window = Lib:CreateWindow({
    Title = "Aether",
    Subtitle = "Universal Script Hub",
    Icon = "zap",
    Folder = "Aether",
    Version = "1.0.0",
    EnvKey = "__AetherUI",
    ChannelsKey = "AetherChannels",
    ChatUrl = "https://aether-chat.j6n7.workers.dev",
})

--// MAIN

local Main = Window:AddTab("Main", "sparkles")

local Welcome = Main:AddLeftGroupbox("Welcome", {
    Icon = "sparkles"
})

Welcome:AddParagraph(
    "Aether",
    "Welcome to Aether. Your universal script hub."
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
            Type = "success"
        })
    end
})

local Player = Main:AddRightGroupbox("Player", {
    Icon = "user"
})

Player:AddToggle("PlayerEnabled", {
    Text = "Player Feature",
    Default = false
})

Player:AddSlider("PlayerSpeed", {
    Text = "Walk Speed",
    Min = 0,
    Max = 100,
    Default = 16
})

Player:AddSlider("PlayerJump", {
    Text = "Jump Power",
    Min = 0,
    Max = 200,
    Default = 50
})

--// COMBAT

local Combat = Window:AddTab("Combat", "swords")

-- AIMBOT

local Aim = Combat:AddSubTab("Aimbot")

local AimSettings = Aim:AddLeftGroupbox("Aimbot", {
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

AimSettings:AddToggle("AimbotVisibleCheck", {
    Text = "Visible Check",
    Default = false
})

AimSettings:AddToggle("AimbotPrediction", {
    Text = "Prediction",
    Default = false
})

AimSettings:AddSlider("AimbotFOV", {
    Text = "FOV",
    Min = 10,
    Max = 500,
    Default = 120,
    Suffix = "px"
})

AimSettings:AddSlider("AimbotSmoothness", {
    Text = "Smoothness",
    Min = 1,
    Max = 20,
    Default = 5
})

local AimExtra = Aim:AddRightGroupbox("Target Settings", {
    Icon = "settings"
})

AimExtra:AddDropdown("AimbotPart", {
    Text = "Target Part",
    Values = {
        "Head",
        "Torso",
        "HumanoidRootPart"
    },
    Default = 1
})

AimExtra:AddLabel("Aimbot Key"):AddKeyPicker("AimbotKey", {
    Default = "MB2",
    Mode = "Hold"
})

AimExtra:AddToggle("AimbotDrawFOV", {
    Text = "Draw FOV",
    Default = true
})

-- SILENT AIM

local SilentAim = Combat:AddSubTab("Silent Aim")

local SilentSettings = SilentAim:AddLeftGroupbox("Silent Aim", {
    Icon = "target"
})

SilentSettings:AddToggle("SilentAimEnabled", {
    Text = "Enabled",
    Default = false
})

SilentSettings:AddToggle("SilentTeamCheck", {
    Text = "Team Check",
    Default = true
})

SilentSettings:AddToggle("SilentPrediction", {
    Text = "Prediction",
    Default = false
})

SilentSettings:AddSlider("SilentFOV", {
    Text = "FOV",
    Min = 10,
    Max = 500,
    Default = 100
})

local SilentExtra = SilentAim:AddRightGroupbox("Settings", {
    Icon = "sliders-horizontal"
})

SilentExtra:AddDropdown("SilentPart", {
    Text = "Target Part",
    Values = {
        "Head",
        "Torso",
        "Random"
    },
    Default = 1
})

SilentExtra:AddLabel("Activation Key"):AddKeyPicker("SilentKey", {
    Default = "Q",
    Mode = "Toggle"
})

-- TRIGGERBOT

local Trigger = Combat:AddSubTab("Triggerbot")

local TriggerSettings = Trigger:AddLeftGroupbox("Triggerbot", {
    Icon = "crosshair"
})

TriggerSettings:AddToggle("TriggerEnabled", {
    Text = "Enabled",
    Default = false
})

TriggerSettings:AddToggle("TriggerTeamCheck", {
    Text = "Team Check",
    Default = true
})

TriggerSettings:AddSlider("TriggerDelay", {
    Text = "Trigger Delay",
    Min = 0,
    Max = 1000,
    Default = 100,
    Suffix = "ms"
})

TriggerSettings:AddSlider("TriggerDistance", {
    Text = "Max Distance",
    Min = 0,
    Max = 1000,
    Default = 200
})

local TriggerExtra = Trigger:AddRightGroupbox("Options", {
    Icon = "settings"
})

TriggerExtra:AddLabel("Trigger Key"):AddKeyPicker("TriggerKey", {
    Default = "T",
    Mode = "Toggle"
})

--// VISUALS

local Visuals = Window:AddTab("Visuals", "eye")

-- ESP

local ESP = Visuals:AddSubTab("ESP")

local ESPSettings = ESP:AddLeftGroupbox("ESP Features", {
    Icon = "scan"
})

ESPSettings:AddToggle("ESPEnabled", {
    Text = "Enabled",
    Default = false
})

ESPSettings:AddToggle("ESPNames", {
    Text = "Name ESP",
    Default = true
})

ESPSettings:AddToggle("ESPBoxes", {
    Text = "Box ESP",
    Default = true
})

ESPSettings:AddToggle("ESPHealth", {
    Text = "Health ESP",
    Default = true
})

ESPSettings:AddToggle("ESPDistance", {
    Text = "Distance ESP",
    Default = false
})

ESPSettings:AddToggle("ESPSkeleton", {
    Text = "Skeleton ESP",
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

ESPAppearance:AddSlider("ESPMaxDistance", {
    Text = "Max Distance",
    Min = 100,
    Max = 5000,
    Default = 2000
})

ESPAppearance:AddLabel("ESP Color"):AddColorPicker("ESPColor", {
    Default = Color3.fromRGB(170, 100, 255)
})

ESPAppearance:AddLabel("Text Color"):AddColorPicker("ESPTextColor", {
    Default = Color3.fromRGB(255, 255, 255)
})

-- CHAMS

local Chams = Visuals:AddSubTab("Chams")

local ChamsSettings = Chams:AddLeftGroupbox("Chams", {
    Icon = "layers"
})

ChamsSettings:AddToggle("ChamsEnabled", {
    Text = "Enabled",
    Default = false
})

ChamsSettings:AddToggle("ChamsTeamCheck", {
    Text = "Team Check",
    Default = true
})

ChamsSettings:AddToggle("ChamsOutline", {
    Text = "Outline",
    Default = true
})

local ChamsAppearance = Chams:AddRightGroupbox("Appearance", {
    Icon = "palette"
})

ChamsAppearance:AddLabel("Chams Color"):AddColorPicker("ChamsColor", {
    Default = Color3.fromRGB(170, 100, 255)
})

ChamsAppearance:AddLabel("Outline Color"):AddColorPicker("ChamsOutlineColor", {
    Default = Color3.fromRGB(255, 255, 255)
})

-- OTHER VISUALS

local OtherVisuals = Visuals:AddSubTab("Other")

local OtherSettings = OtherVisuals:AddLeftGroupbox("World", {
    Icon = "sun"
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

OtherSettings:AddToggle("FOVChanger", {
    Text = "FOV Changer",
    Default = false
})

OtherSettings:AddSlider("CameraFOV", {
    Text = "Camera FOV",
    Min = 30,
    Max = 120,
    Default = 70
})

--// MOVEMENT

local Movement = Window:AddTab("Movement", "move")

local MovementMain = Movement:AddLeftGroupbox("Movement", {
    Icon = "footprints"
})

MovementMain:AddToggle("SpeedEnabled", {
    Text = "Speed",
    Default = false
})

MovementMain:AddSlider("SpeedValue", {
    Text = "Speed Amount",
    Min = 16,
    Max = 150,
    Default = 32
})

MovementMain:AddToggle("JumpEnabled", {
    Text = "Infinite Jump",
    Default = false
})

MovementMain:AddToggle("FlyEnabled", {
    Text = "Fly",
    Default = false
})

MovementMain:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Min = 1,
    Max = 200,
    Default = 50
})

local MovementExtra = Movement:AddRightGroupbox("Extra Movement", {
    Icon = "settings"
})

MovementExtra:AddToggle("NoclipEnabled", {
    Text = "Noclip",
    Default = false
})

MovementExtra:AddToggle("BunnyHop", {
    Text = "Bunny Hop",
    Default = false
})

MovementExtra:AddToggle("NoSlow", {
    Text = "No Slow",
    Default = false
})

--// MISC

local Misc = Window:AddTab("Misc", "package")

local MiscMain = Misc:AddLeftGroupbox("General", {
    Icon = "wrench"
})

MiscMain:AddToggle("AntiAFK", {
    Text = "Anti AFK",
    Default = false
})

MiscMain:AddToggle("AutoFarm", {
    Text = "Auto Farm",
    Default = false
})

MiscMain:AddToggle("AutoCollect", {
    Text = "Auto Collect",
    Default = false
})

MiscMain:AddToggle("AutoRejoin", {
    Text = "Auto Rejoin",
    Default = false
})

local MiscExtra = Misc:AddRightGroupbox("Server", {
    Icon = "server"
})

MiscExtra:AddButton({
    Text = "Server Hop",
    Func = function()
        Lib:Notify({
            Title = "Server Hop",
            Text = "UI placeholder - no logic connected.",
            Type = "info"
        })
    end
})

MiscExtra:AddButton({
    Text = "Rejoin",
    Func = function()
        Lib:Notify({
            Title = "Rejoin",
            Text = "UI placeholder - no logic connected.",
            Type = "info"
        })
    end
})

--// SETTINGS TAB

Lib:BuildSettingsTab(Window)

--// ESP PREVIEW

Lib:HookESP(function(option, value)
    print("[Aether ESP]", option, value)
end)

Lib:CreateESPPreview()

Lib:SetPreviewData({
    Name = "Preview Player",
    Health = 75,
    MaxHealth = 100,
    Distance = 25
})

--// WATERMARK + KEYBINDS

Lib:CreateWatermark()
Lib:CreateKeybindList()

--// CHAT

Lib:CreateChat({
    Url = "https://aether-chat.j6n7.workers.dev",
    Channels = {
        ["Blox Fruits"] = 2753915549,
        ["Arsenal"] = 286090429,
    }
})

--// AUTOLOAD

Lib:LoadAutoload()

--// LOADED

Lib:Notify({
    Title = "Aether",
    Text = "Aether Script Hub successfully loaded!",
    Type = "success",
    Duration = 5
})
