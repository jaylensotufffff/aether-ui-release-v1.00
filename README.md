## THIS WAS MADE COMPLETELY USING CLAUDE 


# Aether UI

A full-featured Roblox UI library for script hubs. It runs on PC and mobile and ships with everything built in: tabs, a settings page, configs, a 3D ESP preview, a keybind list, a watermark and a live chat.

## Quick start

```lua
local Lib = loadstring(game:HttpGet("https://pastefy.app/Y9mMGj4P/raw"))()

local Window = Lib:CreateWindow({
    Title = "Aether",
    Subtitle = "My script hub",
    Icon = "zap",
    Folder = "Aether", -- config folder name
})

local Main = Window:AddTab("Main", "home")
local Box = Main:AddLeftGroupbox("Hello", { Icon = "sparkles" })

Box:AddToggle("MyToggle", { Text = "Enabled", Default = true })
Box:AddSlider("MySlider", { Text = "Speed", Min = 0, Max = 100, Default = 40, Suffix = "%" })
Box:AddButton({ Text = "Click me", Func = function()
    Lib:Notify({ Title = "Hi", Text = "It works", Type = "success" })
end })

Lib:BuildSettingsTab(Window)
Lib:CreateWatermark()
Lib:CreateKeybindList()
Lib:LoadAutoload()
```

Press **RightShift** to hide or show the menu. On mobile, use the floating button.

## Features

- **Tabs and sub-tabs** with icons (Lucide icon names) and a scrollable sidebar
- **Two-column groupboxes**, collapsible with an animation, that switch to one column on small screens
- **Many elements:** toggles, checkboxes, buttons, sliders, ranges, inputs, text areas, dropdowns (single, multi, searchable, player list), segmented controls, color pickers, keybinds, labels, paragraphs, callouts, images, stats, progress bars and logs
- **Dependency boxes** that show or hide options based on a toggle
- **Settings tab** with themes, accent colors, UI scale, transparency, configs and autoload
- **Configs** saved to your executor's workspace, with import/export by text
- **ESP preview:** a real 3D viewport you can rotate and zoom, wired to your ESP options
- **Fullscreen mode** for the window and the chat
- **Chat** with channels, DMs, group chats, friends, replies, mentions, image search, link previews and message search
- **Mobile friendly:** touch dragging, touch calibration and larger hit areas
- **Notifications, dialogs and prompts**

## Elements

Every element has an index (its first argument), which is also its config key. Pass `nil` for a one-off element you don't need to save.

```lua
-- Toggles and buttons
Box:AddToggle("Id", { Text = "Toggle", Default = false, Risky = false, Tooltip = "..." })
Box:AddCheckbox("Id", { Text = "Checkbox", Default = true })
Box:AddButton({ Text = "Button", Icon = "mouse-pointer-click", Func = function() end })
Box:AddButton({ Text = "Confirm first", DoubleClick = true, Func = function() end })
Box:AddButtonRow({ { Text = "One", Func = f }, { Text = "Two", Func = f } })

-- Numbers and text
Box:AddSlider("Id", { Text = "FOV", Min = 10, Max = 500, Default = 120, Rounding = 0, Suffix = "px" })
Box:AddRange("Id", { Text = "Distance", Min = 0, Max = 1000, Default = { 0, 400 } })
Box:AddInput("Id", { Text = "Name", Placeholder = "type here", Numeric = false })
Box:AddTextArea("Id", { Text = "Notes", Height = 70 })

-- Pickers
Box:AddDropdown("Id", { Text = "Part", Values = { "Head", "Torso" }, Default = 1 })
Box:AddDropdown("Id", { Text = "Filters", Values = { "A", "B", "C" }, Multi = true, Default = { "A" } })
Box:AddDropdown("Id", { Text = "Player", SpecialType = "Player", ExcludeLocalPlayer = true, AllowNull = true })
Box:AddSegmented("Id", { Text = "Style", Values = { "Low", "Mid", "High" }, Default = 2 })
Box:AddLabel("Color"):AddColorPicker("Id", { Default = Color3.new(1, 1, 1), Transparency = 0.2 })
Box:AddLabel("Key"):AddKeyPicker("Id", { Default = "F", Mode = "Toggle" }) -- Toggle | Hold | Always

-- Add-ons chain on toggles too
Box:AddToggle("Aim", { Text = "Aimbot" }):AddKeyPicker("AimKey", { Default = "MB2", Mode = "Hold" })

-- Display
Box:AddSection("Title")
Box:AddLabel("Text that wraps when it is long")
Box:AddParagraph("Title", "Body text")
Box:AddDivider()
Box:AddCallout("Heads up", "warn") -- info | success | warn | error
Box:AddImage({ Image = "rbxassetid://7733715400", Height = 60 })
local stat = Box:AddStat("Id", { Text = "Kills", Default = "0" })
local bar  = Box:AddProgress("Id", { Text = "Progress", Default = 25 })
local log  = Box:AddLog("Id", { Height = 100 })
```

### Disabled elements

```lua
Box:AddToggle("VIPFly", {
    Text = "Fly",
    Disabled = true,
    DisabledNotify = true,         -- show a notification when clicked
    DisabledText = "Paid feature", -- what it says
    -- optional: DisabledTitle, DisabledType = "info" | "success" | "warn" | "error", DisabledDuration
})
```

### Dependency boxes

```lua
local Extra = Tab:AddRightGroupbox("Extras", { Icon = "sliders-horizontal", Collapsible = true })
Extra:AddToggle("ShowFov", { Text = "Draw FOV circle", Default = true })

local Dep = Extra:AddDependencyBox()
Dep:AddSlider("FovThickness", { Text = "Thickness", Min = 1, Max = 5, Default = 1 })
Dep:SetupDependencies({ { Lib.Toggles.ShowFov, true } }) -- only visible while the toggle is on
```

## Reading and setting values

```lua
Lib.Toggles.MyToggle.Value        -- boolean
Lib.Options.MySlider.Value        -- number
Lib.Options.AimDistance.Value.Min -- ranges use Min / Max
Lib.Flags.MyToggle                -- same value, plain table

Lib.Toggles.MyToggle:SetValue(true)
Lib.Options.MySlider:SetValue(80)

-- every element has Callback and OnChanged
Box:AddToggle("X", { Text = "X", Callback = function(v) print(v) end })
Lib.Toggles.X:OnChanged(function(v) print(v) end)

-- keybinds
local state = Lib.Options.AimKey:GetState() -- true while active
```

## Notifications and dialogs

```lua
Lib:Notify({ Title = "Done", Text = "That worked", Type = "success", Duration = 4 }) -- info | success | warn | error

Lib:Dialog({
    Title = "Are you sure?",
    Text = "This is a two-button dialog.",
    Buttons = { { Text = "No" }, { Text = "Yes", Primary = true, Callback = function() end } },
})

Lib:Prompt({ Title = "Rename", Text = "Pick a name", Default = "Aether", Confirm = "Save" }, function(text)
    print(text)
end)
```

## Built-in extras

| Call | What it does |
| --- | --- |
| `Lib:BuildSettingsTab(Window)` | Settings, ESP and Configs tabs |
| `Lib:CreateWatermark()` | Game name, FPS and ping bar |
| `Lib:CreateKeybindList()` | Live list of active keybinds |
| `Lib:CreateESPPreview()` | 3D ESP preview panel |
| `Lib:CreateChat({ ... })` | Chat panel (see below) |
| `Lib:LoadAutoload()` | Loads the config you set as autoload |
| `Lib:Unload()` | Removes the UI and stops everything it started |

### Connecting your ESP to the preview

```lua
Lib:HookESP(function(option, value)
    -- fires for every ESP option: "Box", "BoxStyle", "Name", "Health", "Chams", "Tracer", ...
end)

Lib:SetPreviewTarget("workspace.Boss")            -- a path, Player, Model or function
Lib:SetPreviewData({ Name = "Boss", Health = 62, MaxHealth = 100, Distance = 34 })
```

### Chat

```lua
Lib:CreateChat({
    Url = "https://your-worker.workers.dev",
    Channels = {
        ["Blox Fruits"] = 2753915549, -- name = place id
        ["Arsenal"] = 286090429,
    },
})
```

The chat needs the relay (a Cloudflare Worker with one Durable Object). The Cloudflare free plan has daily limits, so a busy chat may need the paid plan.

## Configs

Configs are saved to `<workspace>/<Folder>/configs/*.json`. Use the **Settings > Configs** tab to create, load, overwrite and delete them, set an autoload config, or copy and paste a config as text. Add `IgnoreConfig = true` to an element to leave it out.

## Controls

| Action | PC | Mobile |
| --- | --- | --- |
| Show / hide | RightShift (changeable in Settings) | Floating button |
| Move window | Drag the title area | Drag the title area |
| Resize | Drag the bottom-right corner | Drag the bottom-right corner |
| Minimize | Double-click the header, or the minus button | Double-tap the header |
| Fullscreen | Header button | Header button |

## Requirements

- An executor with `loadstring` and `game:HttpGet` (or a `request` function)
- File functions (`writefile`, `readfile`, `isfile`, `listfiles`, `makefolder`) for configs and chat image caching. Without them the UI still works, but configs can't be saved.
- `getcustomasset` for showing chat images

## Full example

A complete demo with every element, a combat and visuals setup and a components showcase is in [`example.lua`](example.lua).

## Open Source Code

[`library.lua`](library.lua)

## License

Add your license here.
