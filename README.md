## THIS WAS MADE COMPLETELY USING CLAUDE


# Aether UI

A full-featured Roblox UI library for script hubs. It runs on PC and mobile and ships with everything built in: tabs, a settings page, configs, a 3D ESP preview, a keybind list, a watermark, pinned on-screen buttons, a profile page and a live Discord-style chat (channels, DMs, groups, friends, reactions).

## Quick start

```lua
local Lib = loadstring(game:HttpGet("https://github.com/jaylensotufffff/aether-ui-release-v1.00/blob/main/library.lua"))()

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
```

That's all you need. The Settings tab, ESP preview, chat, watermark, keybind list and config autoload are **built automatically** right after your script finishes adding its own tabs. You no longer have to call `BuildSettingsTab`, `CreateWatermark`, `CreateKeybindList` or `LoadAutoload` yourself. If you still do (old scripts), the calls are safe: they won't build anything twice.

Press **RightShift** to hide or show the menu (changeable in Settings). On mobile, use the floating button.

## CreateWindow options

Every option is optional.

```lua
local Window = Lib:CreateWindow({
    Title = "MyHub",               -- becomes Lib.Name
    Subtitle = "My script hub",
    Icon = "zap",                  -- Lucide icon name
    Folder = "MyHub",              -- config folder
    Version = "1.0.0",             -- stored as Lib.Version
    Accent = Color3.fromRGB(139, 92, 246), -- starting accent color
    ToggleKey = Enum.KeyCode.RightShift,
    Sidebar = "icons",             -- "icons" (compact rail, default) or "full" (icons + names)
    Size = UDim2.fromOffset(640, 440), -- fixed size; leave out to auto-size for the screen
    MinSize = Vector2.new(400, 280),
    SearchPlaceholder = "Search settings...",

    EnvKey = "__MyHubUI",          -- getgenv() key used to stop double-loading
    ChannelsKey = "MyHubChannels", -- getgenv() key for extra chat channels
    ChatUrl = "https://your-worker.workers.dev", -- chat relay, or false for no chat server

    -- built-ins: all on by default, set to false to skip one
    Settings = true,               -- Settings + ESP + Configs tabs
    ESPPreview = true,
    Chat = true,                   -- or a table of CreateChat options, see Chat below
    Watermark = true,
    KeybindList = true,
    Autoload = true,               -- load the config you picked as autoload
})
```

- `EnvKey` unloads the previous instance stored under that key, so re-running the script replaces the old UI instead of stacking a second one.
- `ChannelsKey`: another script can fill `getgenv().MyHubChannels` with `{ ["Channel name"] = placeId }` before this one loads, and those channels show up in the chat.
- `ChatUrl` sets the chat relay for the whole library. The default baked into the source points at the original author's worker, so set your own here. `ChatUrl = false` runs the UI with no chat server at all.
- `Chat = false` skips the chat panel entirely. `ESPPreview = false` also stops anything from building the preview later.
- Want a fully rebranded source? Find and replace the `"[Aether] "` console prefixes (there are quite a few `warn` calls now, so use a global find and replace) and change `DefaultChatUrl`.

## Features

- **Tabs and sub-tabs** with icons (Lucide icon names), a compact scrollable sidebar and a search box that finds any option
- **Live search:** results show an inline control (toggle, slider, button, `< value >` stepper) so you can change a setting without leaving the search popup
- **Two-column groupboxes**, collapsible with an animation, that switch to one column on small screens
- **Many elements:** toggles, checkboxes, buttons, button rows, sliders, ranges, inputs, text areas, dropdowns (single, multi, searchable, player list), segmented controls, color pickers (HSV / RGB sliders, preset swatches, copy hex, rainbow), keybinds, labels, paragraphs, callouts, images, stats, progress bars, logs and a 3D avatar
- **Dependency boxes** that show or hide options based on a toggle
- **Pinned on-screen buttons:** right-click (or long-press on mobile) a toggle or keybind to pin it as a draggable button on your screen
- **Settings tab** with 6 themes, accent colors, UI fonts, UI scale, transparency, configs and autoload
- **Profile page** (click your avatar at the bottom of the sidebar): 3D avatar, account info, session stats, Anti AFK, FPS cap, server info and server hopping
- **Fonts:** every Roblox font (`Enum.Font`). Change the font of the whole UI in Settings > Interface > Typography (saved between sessions) and style your chat name with any of them
- **Configs** saved to your executor's workspace, with import/export by text, and **sharing in chat** (people can preview which features are on before copying)
- **ESP preview:** a real 3D viewport you can rotate and zoom, wired to your ESP options
- **Fullscreen mode** for the window and the chat, plus dockable side panels
- **Chat** with channels, DMs, group chats, friends, reactions, replies, mentions, formatting, code blocks, join-me cards, pins, image search, link previews, message search and editing / deleting your own messages
- **Mobile friendly:** touch dragging, automatic touch calibration, larger hit areas, long-press menus
- **Notifications, dialogs and prompts**

## Window, tabs and groupboxes

```lua
local Tab = Window:AddTab("Combat", "swords")       -- name, icon
local Hidden = Window:AddTab("Secret", "lock", true) -- third arg = hidden from the sidebar (open it with Tab:Show())

-- sub-tabs: pills at the top of the tab
local Aim = Tab:AddSubTab("Aim")
local Box = Aim:AddLeftGroupbox("Aimbot", { Icon = "crosshair", Collapsible = true })
Aim:AddRightGroupbox("Extras", { Icon = "sliders-horizontal" })

-- without sub-tabs, a tab has one default page
Tab:AddLeftGroupbox("Title", { Icon = "sparkles" })
Tab:AddRightGroupbox("Title")
```

```lua
Window:SetTitle("New title")
Window:SetSubtitle("New subtitle")
Window:SelectTab(Tab)            -- or Tab:Show()
Window:SetMinimized(true)        -- or Window:ToggleMinimize()
Window:SetFullscreen(true)       -- or Window:ToggleFullscreen()
Window:SetLocked(true)           -- stop the window from being dragged
Window:SetTransparency(0.2)      -- 0 to 0.8
Window:ResetPosition()
Window:AutoFit()                 -- size and scale for the current screen

Box:SetTitle("New name")
Box:SetVisible(false)
Box:SetCollapsed(true)           -- only on Collapsible groupboxes
```

## Elements

Every element has an index (its first argument), which is also its config key. Pass `nil` for a one-off element you don't need to save. Indexes that start with `__` are never saved to configs.

Options every element understands: `Tooltip = "..."`, `Callback = function(value) end`, `IgnoreConfig = true` (leave it out of configs), `Keywords = "extra search words"`.

```lua
-- Toggles and buttons
Box:AddToggle("Id", { Text = "Toggle", Default = false, Risky = false, Tooltip = "..." })
Box:AddCheckbox("Id", { Text = "Checkbox", Default = true })
Box:AddButton({ Text = "Button", Icon = "mouse-pointer-click", Func = function() end })
Box:AddButton({ Text = "Confirm first", DoubleClick = true, Func = function() end })
Box:AddButtonRow({ { Text = "One", Func = f }, { Text = "Two", Func = f } })

-- Numbers and text
Box:AddSlider("Id", { Text = "FOV", Min = 10, Max = 500, Default = 120, Rounding = 0, Suffix = "px" })
Box:AddSlider("Id", { Text = "Scale", Min = 0, Max = 1, Default = 0.5, Rounding = 2, Prefix = "x", Display = function(v) return v * 100 .. "%" end })
Box:AddRange("Id", { Text = "Distance", Min = 0, Max = 1000, Default = { 0, 400 } })
Box:AddInput("Id", { Text = "Name", Placeholder = "type here", Numeric = false, Finished = false, MaxLength = 200 })
Box:AddTextArea("Id", { Text = "Notes", Height = 70 })

-- Pickers
Box:AddDropdown("Id", { Text = "Part", Values = { "Head", "Torso" }, Default = 1 })
Box:AddDropdown("Id", { Text = "Filters", Values = { "A", "B", "C" }, Multi = true, Default = { "A" } })
Box:AddDropdown("Id", { Text = "Player", SpecialType = "Player", ExcludeLocalPlayer = true, AllowNull = true })
Box:AddDropdown("Id", { Text = "Long list", Values = bigList, Searchable = true, MaxVisible = 7 }) -- lists over 7 are searchable automatically
Box:AddSegmented("Id", { Text = "Style", Values = { "Low", "Mid", "High" }, Default = 2 })
Box:AddLabel("Color"):AddColorPicker("Id", { Default = Color3.new(1, 1, 1), Transparency = 0.2, Rainbow = true })
-- popup: color square, hue + alpha bars, hex box, Rainbow, HSV / RGB sliders, presets and copy hex
Box:AddLabel("Key"):AddKeyPicker("Id", { Default = "F", Mode = "Toggle" }) -- Toggle | Hold | Always

-- Add-ons chain on toggles and checkboxes too
Box:AddToggle("Aim", { Text = "Aimbot" }):AddKeyPicker("AimKey", { Default = "MB2", Mode = "Hold" })
Box:AddToggle("Esp", { Text = "ESP" }):AddColorPicker("EspColor", { Default = Color3.new(1, 0, 0) })

-- Display
Box:AddSection("Title")
Box:AddLabel("Text that wraps when it is long")
Box:AddParagraph("Title", "Body text")
Box:AddDivider()            -- or Box:AddDivider("with text")
Box:AddBlank(8)             -- empty space (height in pixels)
Box:AddCallout("Heads up", "warn") -- info | success | warn | error
Box:AddImage({ Image = "rbxassetid://7733715400", Height = 60 })
Box:AddAvatar3D(160)        -- rotatable 3D copy of your character
local stat = Box:AddStat("Id", { Text = "Kills", Default = "0" })
local bar  = Box:AddProgress("Id", { Text = "Progress", Default = 25 })
local log  = Box:AddLog("Id", { Height = 100 })
```

Key picker options: `Default` (key name like `"F"`, `"MB2"`, or an Enum), `Mode`, `SyncToggleState = true` (a Toggle-mode key also flips the toggle it's attached to), `Callback`, `ChangedCallback`. Right-click (or long-press) a keybind button for the mode menu, which also has **Pin to screen**.

### Updating display elements

```lua
stat:SetValue("12", Color3.fromRGB(92, 184, 128)) -- optional color
bar:SetValue(60)
log:Log("Something happened", "good")  -- info | good | warn | bad
log:Clear()
label:SetText("New text")
button:SetText("New label")
button:SetDisabled(true)
toggle:SetText("New label")
dropdown:SetValues({ "New", "List" })
dropdown:GetActive()                   -- multi dropdowns: array of picked values
slider:SetMin(0) slider:SetMax(200)
colorpicker:SetRainbow(true)
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

Setting only `DisabledText` already notifies. `DisabledNotify = false` silences it. Works on toggles, checkboxes and buttons.

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
Lib.Toggles.MyToggle:SetValue(true, true) -- second arg = silent (no callback)

-- every element has Callback and OnChanged
Box:AddToggle("X", { Text = "X", Callback = function(v) print(v) end })
Lib.Toggles.X:OnChanged(function(v) print(v) end)

-- keybinds
local state = Lib.Options.AimKey:GetState() -- true while active
Lib.Options.AimKey:SetMode("Hold")
```

## Pinned on-screen buttons

Right-click (PC) or long-press (mobile) any **toggle or keybind that has an index** and pick **Pin to screen**. A small button appears on your screen:

- Toggles flip when tapped. Hold-mode keybinds follow your finger, Toggle-mode keybinds flip.
- While the menu is open you can drag pins around. Positions are saved.
- Settings > Configs > Pinned buttons has: show / hide all pins, lock positions, button size, idle opacity and Unpin all.

```lua
Lib:Pin(Lib.Toggles.MyToggle) -- pin from code
Lib:Unpin("MyToggle")
Lib:IsPinned("MyToggle")
```

## Notifications and dialogs

```lua
Lib:Notify({ Title = "Done", Text = "That worked", Type = "success", Duration = 4 }) -- info | success | warn | error
Lib:Notify("Short text")

Lib:Dialog({
    Title = "Are you sure?",
    Text = "This is a two-button dialog.",
    Buttons = { { Text = "No" }, { Text = "Yes", Primary = true, Callback = function() end } },
})

Lib:Prompt({ Title = "Rename", Text = "Pick a name", Default = "Aether", Confirm = "Save" }, function(text)
    print(text)
end)
```

The Settings > Notifications toggle mutes everything except errors.

## Themes, accent and fonts

```lua
Lib:SetTheme("Midnight")          -- Dark | Midnight | Graphite | Mocha | Forest | Light
Lib:SetAccent(Color3.fromRGB(232, 110, 140))
Lib:SetScale(1.1)                 -- 0.5 to 1.5 (the UI sizes itself for your screen by default)
Lib:SetUIFont("GothamBold")       -- any Enum.Font name, or "Default"
Lib.Presets                       -- Blue, Teal, Violet, Rose, Amber, Red, Green, Mono
```

## Icons

Icons use Lucide names (`"home"`, `"swords"`, `"settings"`). If the icon pack can't be loaded or a name doesn't exist, a letter shows instead of a dot, and renamed Lucide icons are matched automatically.

```lua
Lib:AddIcon("my-icon", 1234567890)                    -- your own image asset id
Lib:AddIcon("sheet-icon", sheetId, Vector2.new(0, 0), Vector2.new(48, 48)) -- from a spritesheet
Lib:AliasIcon("my-name", "real-lucide-name")
Lib:AddIconSource("https://.../Main.lua")             -- extra Lucide-compatible pack
Lib:HasIcon("crown")
Lib:IconReport({ "swords", "crown" })                 -- prints names that can't be found
Lib:ReloadIcons()
```

## Built-in extras

| Call | What it does |
| --- | --- |
| `Lib:BuildSettingsTab(Window)` | Settings, ESP and Configs tabs (built automatically) |
| `Lib:CreateWatermark({ Title, Position, ShowGame, ShowFPS, ShowPing })` | Game name, FPS and ping bar (built automatically) |
| `Lib:CreateKeybindList()` | Live list of active keybinds (built automatically) |
| `Lib:CreateESPPreview()` | 3D ESP preview panel (built automatically) |
| `Lib:CreateChat({ ... })` | Chat panel (built automatically, see below) |
| `Lib:LoadAutoload()` | Loads the config you set as autoload (runs automatically) |
| `Lib:SetVisible(bool)` / `Lib:ToggleVisible()` | Show or hide the whole UI |
| `Lib:Unload()` | Removes the UI and stops everything it started |

`Lib.Watermark:SetVisible(false)`, `Lib.KeybindList:SetVisible(false)` and `Lib.Preview:SetVisible(true)` control the built-in widgets. Set `Lib.OnUnload = function() ... end` to clean up your own stuff when the UI is unloaded.

### Settings tab

- **Interface:** menu keybind, watermark / keybind list / ESP preview / chat panel switches, notifications, share-my-game-in-chat, hide my name, re-dock panels, reset position, reset all options, unload; appearance (theme, accent preset and color, UI size, auto fit, transparency, lock window, cursor offset); chat options; typography; chat name style.
- **ESP:** every ESP option, plus preview rotate / speed / refresh.
- **Configs:** save, load, overwrite, delete, autoload, import / export by text, share in chat, pinned buttons.

### Profile page

Click your avatar at the bottom of the sidebar. Account (3D avatar, names, ID, account age, membership, team), Session (executor, platform, session time, FPS, ping, **Anti AFK**, **FPS cap** when your executor supports it) and Server (game info, copy PlaceId / JobId / join script, rejoin, join a new / smallest / busiest server).

### Connecting your ESP to the preview

```lua
Lib:HookESP(function(option, value)
    -- fires for every ESP option: "Box", "BoxStyle", "Name", "Health", "Chams", "Tracer", ...
    -- and "Target" whenever the preview subject changes. It is replayed once on registration so you sync immediately.
end)

Lib:SetPreviewTarget("workspace.Boss")            -- a path, Player, Model, BasePart or function (re-resolved live). nil = you
Lib:SetPreviewData({ Name = "Boss", Health = 62, MaxHealth = 100, Distance = 34, Tool = "Sword", Flags = { "Hostile" } })
Lib:SetPreviewData(nil)                           -- clear it
Lib:UnhookESP()
```

Option names you receive: `Box, BoxStyle ("Corner" | "Full"), BoxColor, BoxFill, FillColor, FillTransparency, Name, NameColor, Health, Distance, Tool, Skeleton, SkeletonColor, Flags, Chams, ChamsColor, Tracer, TracerColor, HeadDot, HeadDotColor, Rotate, RotateSpeed`.

The matching flags in `Lib.Toggles` / `Lib.Options` are `ESPBox`, `ESPBoxStyle`, `ESPBoxColor`, `ESPBoxFill`, `ESPFillColor`, `ESPName`, `ESPNameColor`, `ESPHealth`, `ESPDist`, `ESPTool`, `ESPSkeleton`, `ESPSkelColor`, `ESPFlags`, `ESPChams`, `ESPChamsColor`, `ESPTracer`, `ESPTracerColor`, `ESPHeadDot`, `ESPHeadDotColor`, `PreviewRotate`, `PreviewSpeed`, so your own ESP can read them directly.

## Chat

The chat is a dockable panel (toggle it in Settings or from the sidebar). Wide layouts get a **Discord-style sidebar** (favorites, channels, DMs, groups); the **Compact** layout is the small single-column chat (Settings > Interface > Chat > Chat layout).

```lua
-- in CreateWindow:
Chat = {
    Channels = {
        ["Blox Fruits"] = 2753915549, -- name = place id
        ["Arsenal"] = 286090429,
    },
}

-- or call it yourself (it never builds a second chat; extra channels are added to the existing one)
Lib:CreateChat({
    Url = "https://your-worker.workers.dev",
    Channels = { ["Blox Fruits"] = 2753915549 },
})
Lib.ChatObj:AddChannel("Arsenal", 286090429)
```

The `Url` here beats `ChatUrl` from `CreateWindow`, which beats the default relay baked into the library. Pass `ChatUrl = false` in `CreateWindow` if you don't want a chat server at all.

What it can do:

- **Channels:** Global plus one per game you set. Unread badges, per-channel notification settings (All / Only @mentions / Nothing) and favorites.
- **Direct messages and group chats** (up to 10 people). Owners can rename, hand over ownership, invite several people at once and set a **group icon**. Drafts are saved per conversation.
- **Friends:** requests, online status, message and **Join** a friend's server.
- **Messages:** replies, @mentions (with suggestions), edit and delete your own, hide for yourself, block users, "NEW" divider, typing indicator, read receipts in DMs (toggle in Settings), pins in DMs and groups.
- **Reactions:** hover bar on PC, long-press sheet on mobile, **double-tap / double-click** to react with your chosen emoji, full searchable emoji picker.
- **Formatting:** `**bold**`, `*italic*`, `***both***`, `~~strike~~`, `` `inline code` ``, `||spoilers||`, and triple-backtick code blocks (with a Copy button). Use the **+** button for a code composer, **Share My Server** (a "Join me" card) and image search. `:fire:` style emoji shortcuts autocomplete.
- **Media:** image search (no GIFs), link previews and shared config cards with a preview of the enabled features.
- **Tools:** message search (`from:name` works), a bell for mentions and replies, profile cards, optional auto correct (off by default), your own **chat display name**, bio and **name style** (color, gradient, font).
- **Fullscreen** and a docking button to snap the panel back next to the menu.

Message actions: right-click a message (PC) or long-press it (mobile).

Helpers: `Lib:JoinServer(placeId, jobId, label)`, `Lib:CheckServer(placeId, jobId, cb)`, `Lib:Block(uid, name)`, `Lib:Unblock(uid)`, `Lib:IsBlocked(uid)`.

The chat needs the relay (a Cloudflare Worker with one Durable Object). It must be a recent version of the worker: reactions, read receipts, typing, pins, friends, group owners / icons, auto correct, config sharing and message deleting each use their own endpoint, and anything the worker doesn't support just shows an error in chat. The Cloudflare free plan has daily limits, so a busy chat may need the paid plan.

## Configs

Configs are saved to `<workspace>/<Folder>/configs/*.json`. Use the **Settings > Configs** tab to create, load, overwrite and delete them, set an autoload config, copy and paste a config as text, or share one in chat (to any channel, DM or group). A config someone shares lands in your saved configs as a copy, it is never applied automatically. Add `IgnoreConfig = true` to an element to leave it out.

```lua
Lib:SaveConfig("name")      -- returns ok, err
Lib:LoadConfig("name")
Lib:DeleteConfig("name")
Lib:ListConfigs()           -- array of names
Lib:SetAutoload("name")     -- "" clears it
Lib:GetAutoload()
Lib:SerializeConfig()       -- table, use HttpService:JSONEncode to export
Lib:ApplyConfig(tbl)
Lib:ResetAll()              -- every option back to its default
```

Other files the library keeps in `<Folder>`: `pins.json`, `chatstate.json` (drafts, favorites), `chatprefs.json`, `chatnotif.json`, `chatname.txt`, `namestyle.json`, `uifont.txt`, `bio.txt`, `blocked.json`, `convos.json`, `groupicons.json`, `touchauto.json` and a `cache/` folder for images and emoji.

## Controls

| Action | PC | Mobile |
| --- | --- | --- |
| Show / hide | RightShift (changeable in Settings) | Floating button |
| Move window | Drag the title area | Drag the title area |
| Resize | Drag the bottom-right corner | Drag the bottom-right corner |
| Minimize | Double-click the header, or the minus button | Double-tap the header |
| Fullscreen | Header button | Header button |
| Pin a toggle / keybind | Right-click it | Long-press it |
| Message menu | Right-click a message | Long-press a message |
| React to a message | Double-click, or the hover bar | Double-tap |

Touch input is calibrated automatically (the offset is learned from your taps and saved), and **Settings > Interface > Appearance > Cursor offset** is a manual override if clicks ever land away from your cursor.

## Requirements

- An executor with `loadstring` and `game:HttpGet` (or a `request` function)
- File functions (`writefile`, `readfile`, `isfile`, `isfolder`, `listfiles`, `makefolder`) for configs, pins, chat settings and image caching. Without them the UI still works, but nothing can be saved.
- `getcustomasset` for showing chat images and group icons
- `setclipboard` for the copy buttons
- Optional: `setfpscap` (FPS cap slider), `gethui` / `syn.protect_gui` (safer GUI parent), `delfile`

## Full example

A complete demo with every element, a combat and visuals setup and a components showcase is in [`example.lua`](example.lua).

## Open Source Code

[`library.lua`](library.lua)

## License
