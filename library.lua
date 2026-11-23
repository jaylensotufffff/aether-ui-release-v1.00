local cloneref = cloneref or function(o) return o end
local function Svc(n) return cloneref(game:GetService(n)) end

local Players = Svc("Players")
local RunService = Svc("RunService")
local UIS = Svc("UserInputService")
local TweenService = Svc("TweenService")
local HttpService = Svc("HttpService")
local CoreGui = Svc("CoreGui")
local Stats = Svc("Stats")
local GuiService = Svc("GuiService")
local Market = Svc("MarketplaceService")
local Teleport = Svc("TeleportService")
local TextService = Svc("TextService")
local LocalPlayer = Players.LocalPlayer

local function PickFont(...)
        for _, n in ipairs({ ... }) do
                local ok, f = pcall(function() return Enum.Font[n] end)
                if ok and f then return f end
        end
        return Enum.Font.Gotham
end

local Lib = {
        Version = "4.0.0", Name = "Aether", ConfigFolder = "Aether",
        Flags = {}, Options = {}, Toggles = {}, Registry = {}, Connections = {}, Keybinds = {}, Panels = {}, Rainbows = {},
        Unloaded = false, Visible = true, Popup = nil, Scale = 1, NotifyEnabled = true, UserScaled = false,
        ESPOptions = {}, ESPHooks = {}, PreviewTarget = nil,
        ImgAssets = {}, PreviewCache = {}, BlockList = {}, LinkPreviews = true, ShowImages = true,
        Touch = UIS.TouchEnabled and not UIS.KeyboardEnabled,
        ToggleKey = Enum.KeyCode.RightShift,
        Font = PickFont("BuilderSansMedium", "GothamMedium"), FontBold = PickFont("BuilderSansBold", "GothamBold"),
        IconSources = {
                "https://raw.githubusercontent.com/Footagesus/Icons/main/Main.lua",
                "https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua",
        },
        CustomIcons = {},
        DefaultChatUrl = "https://aether-chat.j6n7.workers.dev",
        PtrShift = Vector2.zero,
        StartTime = os.clock(),
}

Lib.Theme = {
        Bg = Color3.fromRGB(14, 14, 17), Surface = Color3.fromRGB(18, 18, 22), Card = Color3.fromRGB(21, 21, 26),
        Field = Color3.fromRGB(29, 29, 35), FieldHover = Color3.fromRGB(37, 37, 44), Stroke = Color3.fromRGB(40, 40, 48),
        Accent = Color3.fromRGB(139, 92, 246), OnAccent = Color3.fromRGB(16, 12, 24),
        Text = Color3.fromRGB(226, 228, 234), SubText = Color3.fromRGB(140, 144, 157), Dim = Color3.fromRGB(92, 95, 107),
        Good = Color3.fromRGB(92, 184, 128), Bad = Color3.fromRGB(224, 96, 104), Warn = Color3.fromRGB(222, 174, 86),
}

Lib.Themes = {
        Dark = { Bg = Color3.fromRGB(14, 14, 17), Surface = Color3.fromRGB(18, 18, 22), Card = Color3.fromRGB(21, 21, 26), Field = Color3.fromRGB(29, 29, 35),
                FieldHover = Color3.fromRGB(37, 37, 44), Stroke = Color3.fromRGB(40, 40, 48), Text = Color3.fromRGB(226, 228, 234), SubText = Color3.fromRGB(140, 144, 157), Dim = Color3.fromRGB(92, 95, 107) },
        Midnight = { Bg = Color3.fromRGB(9, 11, 20), Surface = Color3.fromRGB(13, 16, 28), Card = Color3.fromRGB(16, 20, 34), Field = Color3.fromRGB(24, 29, 48),
                FieldHover = Color3.fromRGB(32, 38, 62), Stroke = Color3.fromRGB(36, 43, 68), Text = Color3.fromRGB(224, 230, 245), SubText = Color3.fromRGB(135, 146, 175), Dim = Color3.fromRGB(86, 96, 125) },
        Graphite = { Bg = Color3.fromRGB(24, 24, 26), Surface = Color3.fromRGB(30, 30, 33), Card = Color3.fromRGB(35, 35, 38), Field = Color3.fromRGB(45, 45, 49),
                FieldHover = Color3.fromRGB(56, 56, 61), Stroke = Color3.fromRGB(62, 62, 68), Text = Color3.fromRGB(235, 235, 238), SubText = Color3.fromRGB(160, 160, 168), Dim = Color3.fromRGB(110, 110, 118) },
        Mocha = { Bg = Color3.fromRGB(19, 15, 14), Surface = Color3.fromRGB(25, 20, 18), Card = Color3.fromRGB(30, 24, 22), Field = Color3.fromRGB(41, 33, 30),
                FieldHover = Color3.fromRGB(53, 43, 39), Stroke = Color3.fromRGB(60, 49, 45), Text = Color3.fromRGB(240, 230, 224), SubText = Color3.fromRGB(165, 148, 139), Dim = Color3.fromRGB(115, 99, 91) },
        Forest = { Bg = Color3.fromRGB(12, 17, 14), Surface = Color3.fromRGB(16, 22, 18), Card = Color3.fromRGB(19, 27, 22), Field = Color3.fromRGB(27, 38, 31),
                FieldHover = Color3.fromRGB(35, 49, 40), Stroke = Color3.fromRGB(40, 56, 46), Text = Color3.fromRGB(222, 236, 227), SubText = Color3.fromRGB(135, 160, 144), Dim = Color3.fromRGB(88, 109, 96) },
        Light = { Bg = Color3.fromRGB(244, 245, 248), Surface = Color3.fromRGB(236, 238, 243), Card = Color3.fromRGB(255, 255, 255), Field = Color3.fromRGB(230, 233, 240),
                FieldHover = Color3.fromRGB(218, 222, 232), Stroke = Color3.fromRGB(206, 211, 223), Text = Color3.fromRGB(28, 31, 40), SubText = Color3.fromRGB(88, 94, 110), Dim = Color3.fromRGB(140, 146, 162) },
}

local function Merge(d, g)
        local o = {}
        for k, v in pairs(d) do o[k] = v end
        for k, v in pairs(g or {}) do o[k] = v end
        return o
end
local function Round(n, d) local m = 10 ^ (d or 0) return math.floor(n * m + 0.5) / m end
local function Clamp(n, a, b) return math.max(a, math.min(b, n)) end
local function Lerp(a, b, t) return a + (b - a) * t end
local function Map(n, a, b, c, d) if b == a then return c end return c + (n - a) * (d - c) / (b - a) end
local function Trim(s) return (tostring(s):gsub("^%s+", ""):gsub("%s+$", "")) end
local function IndexOf(t, v) for i, x in ipairs(t) do if x == v then return i end end end
local function H(n) return Lib.Touch and math.floor(n * 1.1 + 0.5) or n end
local function ToHex(c) return string.format("%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)) end
local function FromHex(hex)
        hex = tostring(hex):gsub("#", "")
        if #hex == 3 then hex = hex:sub(1, 1):rep(2) .. hex:sub(2, 2):rep(2) .. hex:sub(3, 3):rep(2) end
        if #hex ~= 6 then return nil end
        local r, g, b = tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
        if not (r and g and b) then return nil end
        return Color3.fromRGB(r, g, b)
end
local function Clock(sec)
        sec = math.max(0, math.floor(sec))
        local h, m, s = math.floor(sec / 3600), math.floor(sec % 3600 / 60), sec % 60
        if h > 0 then return string.format("%dh %02dm %02ds", h, m, s) end
        return string.format("%dm %02ds", m, s)
end
local function Measure(text, size, font, maxW)
        local ok, v = pcall(function() return TextService:GetTextSize(text, size, font, Vector2.new(maxW, 10000)) end)
        if ok and v then return v end
        return Vector2.new(maxW, size + 2)
end

-- Clones a character even if the game marked parts as non-archivable (those get silently dropped by Clone otherwise).
local function CloneChar(char)
        local saved = {}
        for _, d in ipairs(char:GetDescendants()) do
                if not d.Archivable then
                        table.insert(saved, d)
                        pcall(function() d.Archivable = true end)
                end
        end
        local was = char.Archivable
        pcall(function() char.Archivable = true end)
        local ok, clone = pcall(function() return char:Clone() end)
        pcall(function() char.Archivable = was end)
        for _, d in ipairs(saved) do pcall(function() d.Archivable = false end) end
        if ok and clone then return clone end
end

Lib.Util = { Merge = Merge, Round = Round, Clamp = Clamp, Lerp = Lerp, Map = Map, Trim = Trim, ToHex = ToHex, FromHex = FromHex, Clock = Clock }

local function Safe(fn, ...)
        if type(fn) ~= "function" then return end
        local ok, err = pcall(fn, ...)
        if not ok then warn("[Aether] " .. tostring(err)) end
        return ok
end

local Signal = {}
Signal.__index = Signal
function Signal.new() return setmetatable({ _h = {} }, Signal) end
function Signal:Connect(fn)
        local h = { fn = fn, alive = true }
        table.insert(self._h, h)
        return { Disconnect = function() h.alive = false end }
end
function Signal:Fire(...)
        for i = #self._h, 1, -1 do if not self._h[i].alive then table.remove(self._h, i) end end
        for _, h in ipairs(self._h) do if h.alive then Safe(h.fn, ...) end end
end

function Lib:Connect(signal, fn)
        local c = signal:Connect(fn)
        table.insert(self.Connections, c)
        return c
end

function Lib:Themed(inst, prop, key)
        table.insert(self.Registry, { inst, prop, key })
        inst[prop] = self.Theme[key]
end

function Lib:SetThemeColor(key, color)
        self.Theme[key] = color
        for i = #self.Registry, 1, -1 do
                local r = self.Registry[i]
                if r[1].Parent == nil then
                        table.remove(self.Registry, i)
                elseif r[3] == key then
                        pcall(function() r[1][r[2]] = color end)
                end
        end
end

function Lib:SetAccent(color)
        local lum = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
        self:SetThemeColor("OnAccent", lum > 0.55 and Color3.fromRGB(10, 12, 16) or Color3.new(1, 1, 1))
        self:SetThemeColor("Accent", color)
        local w = self.MainWindow
        if w and w._RestyleDock then w:_RestyleDock() end
end

Lib.Glass, Lib.GlassT = {}, 0

function Lib:_Glass(inst, mult)
        table.insert(self.Glass, { inst, mult or 1 })
        inst.BackgroundTransparency = Clamp(self.GlassT * (mult or 1), 0, 1)
end

function Lib:SetGlass(t)
        self.GlassT = Clamp(tonumber(t) or 0, 0, 0.8)
        for i = #self.Glass, 1, -1 do
                local g = self.Glass[i]
                if g[1].Parent == nil then table.remove(self.Glass, i)
                else g[1].BackgroundTransparency = Clamp(self.GlassT * g[2], 0, 1) end
        end
end

function Lib:SetTheme(name)
        local t = self.Themes[name]
        if not t then return false end
        for k, v in pairs(t) do self:SetThemeColor(k, v) end
        return true
end

local TextClasses = { TextLabel = true, TextButton = true, TextBox = true }
local BorderClasses = { Frame = true, ScrollingFrame = true, TextButton = true, TextLabel = true, TextBox = true,
        ImageLabel = true, ImageButton = true, ViewportFrame = true }

local function New(class, props, children)
        local inst = Instance.new(class)
        props = props or {}
        local theme, parent = props.Theme, props.Parent
        if BorderClasses[class] then inst.BorderSizePixel = 0 end
        if TextClasses[class] then
                inst.BackgroundTransparency = 1
                inst.Font = Lib.Font
                inst.TextSize = 13
                if class == "TextButton" then inst.AutoButtonColor = false end
                if class == "TextBox" then inst.ClearTextOnFocus = false end
                if props.TextColor3 == nil and not (theme and theme.TextColor3) then
                        theme = theme or {}
                        theme.TextColor3 = "Text"
                end
        end
        if class == "ImageLabel" or class == "ImageButton" then inst.BackgroundTransparency = 1 end
        if class == "ScrollingFrame" then
                inst.BackgroundTransparency = 1
                inst.ScrollBarImageColor3 = Lib.Theme.Stroke
                inst.ScrollBarThickness = 3
                inst.CanvasSize = UDim2.new()
                inst.ScrollingDirection = Enum.ScrollingDirection.Y
                inst.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
                inst.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
                inst.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        end
        for k, v in pairs(props) do if k ~= "Theme" and k ~= "Parent" then inst[k] = v end end
        if theme then for prop, key in pairs(theme) do Lib:Themed(inst, prop, key) end end
        for _, child in ipairs(children or {}) do child.Parent = inst end
        if parent then inst.Parent = parent end
        return inst
end

local function Corner(p, r) return New("UICorner", { CornerRadius = UDim.new(0, r or 5), Parent = p }) end
local function Stroke(p, key, th, tr)
        return New("UIStroke", { Thickness = th or 1, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Theme = { Color = key or "Stroke" }, Parent = p })
end
local function Pad(p, l, t, r, b)
        return New("UIPadding", { PaddingLeft = UDim.new(0, l or 0), PaddingTop = UDim.new(0, t or l or 0),
                PaddingRight = UDim.new(0, r or l or 0), PaddingBottom = UDim.new(0, b or t or l or 0), Parent = p })
end
local function List(p, pad, dir, ha, va)
        return New("UIListLayout", { Padding = UDim.new(0, pad or 0), FillDirection = dir or Enum.FillDirection.Vertical,
                HorizontalAlignment = ha or Enum.HorizontalAlignment.Left, VerticalAlignment = va or Enum.VerticalAlignment.Top,
                SortOrder = Enum.SortOrder.LayoutOrder, Parent = p })
end
local function Tween(inst, props, d, style, dir)
        local t = TweenService:Create(inst, TweenInfo.new(d or 0.14, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
        t:Play()
        return t
end
local function Sink(f) f.Active = true return f end

Lib.New, Lib.Corner, Lib.Stroke, Lib.Pad, Lib.List, Lib.Tween, Lib.Sink = New, Corner, Stroke, Pad, List, Tween, Sink

local X, Y = Enum.AutomaticSize.X, Enum.AutomaticSize.Y
local LEFT, CENTER, RIGHT = Enum.TextXAlignment.Left, Enum.TextXAlignment.Center, Enum.TextXAlignment.Right
local WHITE = Color3.new(1, 1, 1)

-- Sizes a wrapped label to its real text height. AutomaticSize misbehaves under UIScale / after resizes, which is what cut sentences off.
-- Optionally also resizes a container to (text height + extra).
local function Wrap(label, container, extra, minH)
        label.TextWrapped = true
        label.AutomaticSize = Enum.AutomaticSize.None
        minH = minH or 14
        local function Fit()
                if not label.Parent then return end
                local h = math.max(math.ceil(label.TextBounds.Y), minH)
                local sx = label.Size.X
                if label.Size.Y.Offset ~= h then label.Size = UDim2.new(sx.Scale, sx.Offset, 0, h) end
                if container and container.Parent then
                        local cs = container.Size
                        container.Size = UDim2.new(cs.X.Scale, cs.X.Offset, 0, h + (extra or 0))
                end
        end
        label:GetPropertyChangedSignal("TextBounds"):Connect(Fit)
        label:GetPropertyChangedSignal("AbsoluteSize"):Connect(Fit)
        Fit()
        task.defer(Fit)
end

function Lib.KnobOn()
        local c = Lib.Theme.Accent
        return (0.299 * c.R + 0.587 * c.G + 0.114 * c.B) > 0.6 and Lib.Theme.OnAccent or WHITE
end

local function Fetch(url)
        local ok, body = pcall(function() return game:HttpGet(url) end)
        if ok and type(body) == "string" and #body > 0 then return body end
        local req = (syn and syn.request) or request or http_request or (http and http.request) or (fluxus and fluxus.request)
        if req then
                local ok2, res = pcall(req, { Url = url, Method = "GET" })
                if ok2 and type(res) == "table" and res.StatusCode == 200 and type(res.Body) == "string" then return res.Body end
        end
end

local IconMod, IconInit, IconCache = nil, false, {}

local function Probe(mod)
        local ok, r = pcall(function() local fn = mod.Icon or mod.GetIcon or mod.icon return fn("x") end)
        return ok and r ~= nil
end

local function InitIcons()
        if IconInit then return end
        IconInit = true
        for _, src in ipairs(Lib.IconSources) do
                local body = Fetch(src)
                local fn = body and loadstring(body)
                if fn then
                        local ok, mod = pcall(fn)
                        if ok and type(mod) == "table" then
                                if mod.SetIconsType then pcall(mod.SetIconsType, "lucide") end
                                if Probe(mod) then IconMod = mod break end
                        end
                end
        end
end

local function ToAsset(i) if type(i) == "number" then return "rbxassetid://" .. i end return tostring(i) end

local function ResolveIcon(name)
        name = tostring(name)
        if IconCache[name] ~= nil then return IconCache[name] or nil end
        local res = false
        if Lib.CustomIcons[name] then
                res = { Image = Lib.CustomIcons[name] }
        elseif name:find("rbxasset") then
                res = { Image = name }
        elseif IconMod then
                local ok, r = pcall(function()
                        local fn = IconMod.Icon or IconMod.GetIcon or IconMod.icon
                        return fn(name)
                end)
                if ok and r then
                        if type(r) == "string" then
                                res = { Image = r }
                        elseif type(r) == "table" then
                                local img = r[1] or r.Image or r.Id or r.id
                                local rect = type(r[2]) == "table" and r[2] or r
                                local pos = rect.ImageRectPosition or rect.ImageRectOffset or rect.Position
                                local sz = rect.ImageRectSize or rect.Size
                                if img then res = { Image = img, Pos = pos, Size = sz } end
                        end
                end
        end
        IconCache[name] = res
        return res or nil
end

function Lib.Icon(name, size, key, props, fallback)
        local img = New("ImageLabel", Merge({ Size = UDim2.fromOffset(size, size), Theme = { ImageColor3 = key or "SubText" } }, props))
        local r = ResolveIcon(name)
        if r then
                img.Image = ToAsset(r.Image)
                if r.Pos then img.ImageRectOffset = r.Pos end
                if r.Size then img.ImageRectSize = r.Size end
        else
                New("TextLabel", { Text = fallback or "•", Font = Lib.FontBold, TextSize = math.max(size - 2, 8),
                        Size = UDim2.fromScale(1, 1), Theme = { TextColor3 = key or "SubText" }, Parent = img })
        end
        return img
end

local function Tint(img, color, d)
        Tween(img, { ImageColor3 = color }, d or 0.14)
        local t = img:FindFirstChildOfClass("TextLabel")
        if t then Tween(t, { TextColor3 = color }, d or 0.14) end
end

-- Small icon button with a hover highlight + tooltip. hover = theme key the icon turns on hover ("Bad" also tints the background red).
-- restT < 1 gives it a visible field background (used for toolbar buttons).
local function IconButton(parent, icon, fallback, size, tip, hover, restT)
        restT = restT or 1
        local b = New("TextButton", { Text = "", Size = UDim2.fromOffset(size, size), ZIndex = 3, Parent = parent })
        local fill = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = restT, Theme = { BackgroundColor3 = hover == "Bad" and "Bad" or "Field" }, Parent = b })
        Corner(fill, 6)
        if restT < 1 then Stroke(fill, "Stroke", 1, 0.4) end
        local img = Lib.Icon(icon, 14, "SubText", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 4, Parent = b }, fallback)
        local api = { Button = b, Icon = img, Rest = "SubText", Fill = fill }
        b.MouseEnter:Connect(function()
                if restT < 1 then Tween(fill, { BackgroundColor3 = Lib.Theme.FieldHover }, 0.08)
                else Tween(fill, { BackgroundTransparency = hover == "Bad" and 0.8 or 0.35 }, 0.08) end
                Tint(img, Lib.Theme[hover or "Text"], 0.1)
        end)
        b.MouseLeave:Connect(function()
                if restT < 1 then Tween(fill, { BackgroundColor3 = Lib.Theme.Field }, 0.1)
                else Tween(fill, { BackgroundTransparency = 1 }, 0.1) end
                Tint(img, Lib.Theme[api.Rest], 0.1)
        end)
        if tip then Lib:AddTooltip(b, tip) end
        return api
end

local function GetGuiParent()
        local ok, parent = pcall(function() if gethui then return gethui() end end)
        if ok and parent then return parent end
        ok, parent = pcall(function() return CoreGui end)
        if ok and parent then
                local test = Instance.new("Folder")
                local okp = pcall(function() test.Parent = parent end)
                test:Destroy()
                if okp then return parent end
        end
        return LocalPlayer:WaitForChild("PlayerGui")
end

local function MakeGui(order)
        local c = {}
        for i = 1, 12 do c[i] = string.char(math.random(97, 122)) end
        local gui = Instance.new("ScreenGui")
        gui.Name, gui.ResetOnSpawn, gui.IgnoreGuiInset = table.concat(c), false, true
        gui.ZIndexBehavior, gui.DisplayOrder = Enum.ZIndexBehavior.Sibling, order
        if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
        gui.Parent = GetGuiParent()
        return gui
end

Lib.Gui, Lib.Overlay = MakeGui(900), MakeGui(960)

if getgenv then
        local env = getgenv()
        if type(env.__AetherUI) == "table" and env.__AetherUI.Unload and env.__AetherUI ~= Lib then pcall(function() env.__AetherUI:Unload() end) end
        env.__AetherUI = Lib
end

local function GetViewport()
        local s = Lib.Gui.AbsoluteSize
        if s.X > 0 and s.Y > 0 then return s end
        local cam = workspace.CurrentCamera
        return cam and cam.ViewportSize or Vector2.new(1280, 720)
end

local function IsPress(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end
local function IsMove(i) return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch end

local function Pointer(input)
        if input and input.UserInputType == Enum.UserInputType.Touch then
                return Vector2.new(input.Position.X, input.Position.Y + (Lib.TouchDY or GuiService:GetGuiInset().Y))
        end
        return UIS:GetMouseLocation() + Lib.PtrShift
end

local function IsOver(frame, pos)
        if not frame or not frame.Parent then return false end
        local m = pos or Pointer()
        local p, s = frame.AbsolutePosition, frame.AbsoluteSize
        return m.X >= p.X and m.X <= p.X + s.X and m.Y >= p.Y and m.Y <= p.Y + s.Y
end

-- Fires on mouse-down (instant) AND on Activated (touch / gamepad); debounced so it never double-fires.
local function Press(btn, fn)
        local last = 0
        local function Go()
                if os.clock() - last < 0.25 then return end
                last = os.clock()
                fn()
        end
        btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Go() end end)
        btn.Activated:Connect(Go)
end

local function LockScroll(inst, locked)
        local sf = inst:FindFirstAncestorWhichIsA("ScrollingFrame")
        if sf then sf.ScrollingEnabled = not locked end
        local w = Lib.MainWindow
        if w then for _, t in ipairs(w.Tabs) do t.Scroll.ScrollingEnabled = not locked end end
end

Lib.IsOver, Lib.IsPress, Lib.IsMove, Lib.Pointer, Lib.GetViewport, Lib.Press = IsOver, IsPress, IsMove, Pointer, GetViewport, Press

if not Lib.Touch then
        local insetY = GuiService:GetGuiInset().Y
        local cands, seen = {}, {}
        for _, y in ipairs({ 0, insetY, -insetY, 36, -36, 58, -58 }) do
                if not seen[y] then seen[y] = true table.insert(cands, y) end
        end
        local pg = MakeGui(995)
        Lib.ProbeGui = pg
        local votes, probes, total, frames, done = {}, {}, 0, 0, false
        for i = 1, #cands do
                votes[i] = 0
                local p = Instance.new("Frame")
                p.AnchorPoint, p.Size = Vector2.new(0.5, 0.5), UDim2.fromOffset(12, 12)
                p.BackgroundTransparency, p.BorderSizePixel = 1, 0
                p.Parent = pg
                p.MouseMoved:Connect(function() votes[i] = votes[i] + 1 total = total + 1 end)
                probes[i] = p
        end
        Lib:Connect(RunService.RenderStepped, function()
                if done then return end
                frames = frames + 1
                local m, o = UIS:GetMouseLocation(), pg.AbsolutePosition
                for i, y in ipairs(cands) do probes[i].Position = UDim2.fromOffset(m.X - o.X, m.Y + y - o.Y) end
                if total >= 30 then
                        local best = 1
                        for i = 2, #cands do if votes[i] > votes[best] then best = i end end
                        if votes[best] >= total * 0.6 then Lib.PtrShift = Vector2.new(0, cands[best]) end
                        done = true
                elseif frames > 2400 then
                        done = true
                end
                if done then pcall(function() pg:Destroy() end) Lib.ProbeGui = nil end
        end)
end

local function OverlayOrigin()
        local ok, p = pcall(function() return Lib.Overlay.AbsolutePosition end)
        return (ok and p) or Vector2.zero
end

-- The area popups (menus, search results) are allowed to live in: inside the main window.
local function WinBounds()
        local w = Lib.MainWindow
        if not w or not w.Main or not w.Main.Parent or w.Minimized then return nil end
        local o = OverlayOrigin()
        local p, s = w.Main.AbsolutePosition - o, w.Main.AbsoluteSize
        return { p.X + 6, p.Y + 6, p.X + s.X - 6, p.Y + s.Y - 6 }
end

local function PlaceBelow(anchor, w, h, gap, alignRight, bounds)
        local origin = OverlayOrigin()
        local ap, as = anchor.AbsolutePosition - origin, anchor.AbsoluteSize
        local vp = Lib.Overlay.AbsoluteSize
        gap = gap or 4
        local function Room(b)
                local minX, minY, maxX, maxY = 4, 4, vp.X - 4, vp.Y - 4
                if b then
                        minX, minY = math.max(minX, b[1]), math.max(minY, b[2])
                        maxX, maxY = math.min(maxX, b[3]), math.min(maxY, b[4])
                end
                return minX, minY, maxX, maxY, maxY - (ap.Y + as.Y) - gap, ap.Y - gap - minY
        end
        local minX, minY, maxX, maxY, below, above = Room(bounds)
        if bounds and math.max(below, above) < math.min(h, 90) then
                minX, minY, maxX, maxY, below, above = Room(nil)
        end
        local useBelow
        if below >= h then useBelow = true elseif above >= h then useBelow = false else useBelow = below >= above end
        local hh = math.min(h, math.max(useBelow and below or above, 24))
        local y = useBelow and (ap.Y + as.Y + gap) or (ap.Y - gap - hh)
        local x = alignRight and (ap.X + as.X - w) or ap.X
        x = Clamp(x, minX, math.max(minX, maxX - w))
        return Vector2.new(x, y), hh
end

local function PlaceAt(pos, w, h)
        local vp = Lib.Overlay.AbsoluteSize
        local p = pos - OverlayOrigin()
        return Vector2.new(Clamp(p.X, 4, math.max(4, vp.X - w - 4)), Clamp(p.Y, 4, math.max(4, vp.Y - h - 4)))
end

function Lib:MakeDraggable(handle, target, opts)
        opts = opts or {}
        handle.InputBegan:Connect(function(input)
                if not IsPress(input) then return end
                if opts.Check and not opts.Check() then return end
                local isTouch = input.UserInputType == Enum.UserInputType.Touch
                local startPtr, startPos = Pointer(input), target.Position
                local abs0 = target.AbsolutePosition
                local threshold = isTouch and 6 or 3
                local moved, moveConn, endConn = false, nil, nil
                moveConn = UIS.InputChanged:Connect(function(i)
                        if isTouch then
                                if i ~= input then return end
                        elseif i.UserInputType ~= Enum.UserInputType.MouseMovement then
                                return
                        end
                        local d = Pointer(i) - startPtr
                        if not moved then
                                if d.Magnitude < threshold then return end
                                moved = true
                                if opts.OnMove then Safe(opts.OnMove) end
                        end
                        local vp, sz = GetViewport(), target.AbsoluteSize
                        -- free dragging: it can go partly off every edge, only the grab handle is kept reachable
                        local hb = math.min(handle.AbsolutePosition.Y + handle.AbsoluteSize.Y - abs0.Y, sz.Y)
                        local nx = Clamp(abs0.X + d.X, 44 - sz.X, vp.X - 44)
                        local ny = Clamp(abs0.Y + d.Y, 14 - hb, vp.Y - 24)
                        target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (nx - abs0.X), startPos.Y.Scale, startPos.Y.Offset + (ny - abs0.Y))
                end)
                endConn = UIS.InputEnded:Connect(function(i)
                        local fin = isTouch and (i == input) or (not isTouch and i.UserInputType == Enum.UserInputType.MouseButton1)
                        if fin then
                                moveConn:Disconnect() endConn:Disconnect()
                                if moved and opts.OnEnd then Safe(opts.OnEnd) end
                                if not moved and opts.OnTap then Safe(opts.OnTap) end
                        end
                end)
        end)
end

-- Context menus / search results sit on the overlay. A full-screen invisible "catcher" sits under them so any outside press closes them.
function Lib:_Catcher()
        if self._catcher and self._catcher.Parent then return self._catcher end
        local c = New("TextButton", { Name = "PopupCatcher", Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 2, Visible = false, Active = true, Parent = self.Overlay })
        c.InputBegan:Connect(function(i) if IsPress(i) then Lib:ClosePopup() end end)
        c.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseWheel then Lib:ClosePopup() end end)
        self._catcher = c
        return c
end

function Lib:OpenPopup(frame, closeFn, ignore, noCatch)
        self:ClosePopup()
        self.Popup = { Frame = frame, Close = closeFn, Ignore = ignore, NoCatch = noCatch }
        if not noCatch then self:_Catcher().Visible = true end
end

function Lib:ClosePopup()
        local p = self.Popup
        self.Popup = nil
        if self._catcher then self._catcher.Visible = false end
        if p then Safe(p.Close) end
end

Lib:Connect(UIS.InputBegan, function(input)
        local p = Lib.Popup
        if p and p.NoCatch and IsPress(input) then
                local pos = Pointer(input)
                if not IsOver(p.Frame, pos) and not (p.Ignore and IsOver(p.Ignore, pos)) then
                        task.defer(function() if Lib.Popup == p then Lib:ClosePopup() end end)
                end
        end
end)

-- safety net: the catcher can never stay on screen without a live popup behind it
Lib:Connect(RunService.Heartbeat, function()
        local c, p = Lib._catcher, Lib.Popup
        if p and (not p.Frame or not p.Frame.Parent or not p.Frame.Visible) then
                Lib.Popup, p = nil, nil
        end
        if c and c.Visible and (not p or p.NoCatch) then c.Visible = false end
end)

do
        local tip = New("TextLabel", { Name = "Tooltip", Visible = false, AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.new(), TextSize = 12,
                BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Surface" }, ZIndex = 50, Parent = Lib.Overlay })
        Corner(tip, 4) Stroke(tip) Pad(tip, 7, 4, 7, 4)
        -- text can be a string or a function returning one (for tooltips that change, e.g. Minimize / Restore)
        local source = nil
        function Lib:AddTooltip(inst, text)
                if Lib.Touch or not text or text == "" then return end
                local hover = false
                inst.MouseEnter:Connect(function()
                        hover = true
                        task.delay(0.3, function()
                                if hover and not Lib.Unloaded then
                                        source = text
                                        tip.Text = tostring(type(text) == "function" and text() or text)
                                        tip.Visible = true
                                end
                        end)
                end)
                inst.MouseLeave:Connect(function() hover = false tip.Visible = false source = nil end)
                -- clicking hides the tip, so it can never keep showing the old state (Minimize / Restore)
                inst.InputBegan:Connect(function(i) if IsPress(i) then hover = false tip.Visible = false source = nil end end)
        end
        Lib:Connect(RunService.RenderStepped, function()
                if tip.Visible then
                        if type(source) == "function" then tip.Text = tostring(source()) end
                        local m = UIS:GetMouseLocation()
                        tip.Position = UDim2.fromOffset(m.X + 14, m.Y + 12)
                end
        end)
end

Lib.FPS = 60
do
        local frames, last = 0, os.clock()
        Lib:Connect(RunService.RenderStepped, function()
                frames = frames + 1
                local now = os.clock()
                if now - last >= 0.5 then Lib.FPS = math.floor(frames / (now - last) + 0.5) frames, last = 0, now end
        end)
end

function Lib:GetPing()
        local ok, v = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
        return (ok and v) and math.floor(v + 0.5) or 0
end

Lib:Connect(RunService.RenderStepped, function()
        if next(Lib.Rainbows) == nil then return end
        local hue = (os.clock() % 6) / 6
        for p in pairs(Lib.Rainbows) do
                p.Hue = hue
                p:_Display()
                p:_Fire(p.Transparency)
        end
end)

local KeyShort = { LeftControl = "LCtrl", RightControl = "RCtrl", LeftShift = "LShift", RightShift = "RShift", LeftAlt = "LAlt",
        RightAlt = "RAlt", Return = "Enter", Backspace = "Bksp", Escape = "Esc", Insert = "Ins", Delete = "Del", PageUp = "PgUp",
        PageDown = "PgDn", CapsLock = "Caps", Zero = "0", One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6",
        Seven = "7", Eight = "8", Nine = "9" }

local function KeyName(key)
        if key == nil or key == "None" then return "None" end
        if typeof(key) == "EnumItem" then
                local n = key.Name
                if key.EnumType == Enum.UserInputType then
                        if n == "MouseButton1" then return "MB1" elseif n == "MouseButton2" then return "MB2" elseif n == "MouseButton3" then return "MB3" end
                end
                return KeyShort[n] or n
        end
        return tostring(key)
end

local function ResolveKey(name)
        if name == nil or name == "None" then return nil end
        if typeof(name) == "EnumItem" then return name end
        if name == "MB1" then return Enum.UserInputType.MouseButton1 end
        if name == "MB2" then return Enum.UserInputType.MouseButton2 end
        if name == "MB3" then return Enum.UserInputType.MouseButton3 end
        local ok, k = pcall(function() return Enum.KeyCode[name] end)
        if ok and k then return k end
        for full, short in pairs(KeyShort) do
                if short == name then
                        local ok2, k2 = pcall(function() return Enum.KeyCode[full] end)
                        if ok2 and k2 then return k2 end
                end
        end
end

local AvatarCache = {}
local function GetAvatar(userId, cb, kind, size)
        local key = userId .. ":" .. tostring(kind or "HeadShot")
        if AvatarCache[key] then cb(AvatarCache[key]) return end
        task.spawn(function()
                local ok, url = pcall(function()
                        return (Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType[kind or "HeadShot"], Enum.ThumbnailSize[size or "Size48x48"]))
                end)
                if ok and url then AvatarCache[key] = url cb(url) end
        end)
end

function Lib:_NewPanel(name, frame, startShown)
        local scale = New("UIScale", { Scale = Lib.Scale, Parent = frame })
        local p = { Name = name, Frame = frame, Scale = scale, Enabled = startShown and true or false, _shown = startShown and true or false, _gen = 0 }
        frame.Visible = p._shown
        function p:Refresh(instant)
                local win = Lib.MainWindow
                local hiddenByMin = self.Side and not self.Moved and win and win.Minimized
                local want = Lib.Visible and self.Enabled and not hiddenByMin
                if want == self._shown then return end
                self._shown = want
                self._gen = self._gen + 1
                local gen, base = self._gen, Lib.Scale
                if instant then frame.Visible = want scale.Scale = base return end
                if want then
                        frame.Visible = true
                        scale.Scale = base * 0.96
                        Tween(scale, { Scale = base }, 0.2, Enum.EasingStyle.Quint)
                else
                        Tween(scale, { Scale = base * 0.97 }, 0.12)
                        task.delay(0.13, function() if self._gen == gen then frame.Visible = false scale.Scale = Lib.Scale end end)
                end
        end
        function p:Set(state, instant)
                self.Enabled = state and true or false
                self:Refresh(instant)
                if self.OnChanged then Safe(self.OnChanged, self.Enabled) end
        end
        Lib.Panels[name] = p
        if name ~= "Window" then Lib:_Glass(frame, 1) end
        return p
end

function Lib:SetVisible(state)
        self.Visible = state and true or false
        if not self.Visible then self:ClosePopup()
        elseif self.MainWindow then task.defer(function() self.MainWindow:Clamp() end) end
        for _, p in pairs(self.Panels) do p:Refresh() end
end

function Lib:ToggleVisible() self:SetVisible(not self.Visible) end

Lib:Connect(UIS.InputBegan, function(input)
        if UIS:GetFocusedTextBox() then return end
        if Lib.ToggleKey ~= Enum.KeyCode.Unknown and input.KeyCode == Lib.ToggleKey then Lib:ToggleVisible() end
end)

function Lib:_ApplyScale(s)
        local w = self.MainWindow
        local old, cx, cy = self.Scale, nil, nil
        if w and w.Main then
                local p = w.Main.Position
                cx, cy = p.X.Offset + w.W * old / 2, p.Y.Offset + (w.Minimized and 46 or w.H) * old / 2
        end
        self.Scale = Clamp(tonumber(s) or 1, 0.5, 1.5)
        for _, p in pairs(self.Panels) do p.Scale.Scale = self.Scale end
        if w then
                w:_Fit()
                if cx then -- keep the window centred where it was instead of growing from the top-left corner
                        local hh = w.Minimized and 46 or w.H
                        w.Main.Position = UDim2.fromOffset(cx - w.W * self.Scale / 2, cy - hh * self.Scale / 2)
                        w:Clamp(true)
                end
                for _, p in pairs(self.Panels) do if p.Side then self:_Place(p) end end
        end
end

function Lib:SetScale(s)
        self.UserScaled = true
        self:_ApplyScale(s)
end

function Lib:_Metrics()
        local vp = GetViewport()
        local scale, w, h
        if self.Touch then
                scale = Clamp(math.min(vp.X / 820, vp.Y / 470), 0.55, 1)
                w = Clamp(vp.X * 0.78 / scale, 440, 780)
                h = Clamp(vp.Y * 0.84 / scale, 270, 500)
        else
                scale = Clamp(math.min(vp.X / 1600, vp.Y / 900), 0.8, 1.35)
                w = Clamp(vp.X * 0.44 / scale, 560, 800)
                h = Clamp(vp.Y * 0.62 / scale, 380, 540)
        end
        return scale, w, h
end

function Lib:_DockPos(panel)
        local win, s = self.MainWindow, self.Scale
        local pos = win.Main.Position
        local ax, ay, aw = pos.X.Offset, pos.Y.Offset, win.W * s
        local vp = GetViewport()
        local pw, ph = (panel.CW or panel.W) * s, (panel.CH or panel.H) * s
        local x = (panel.Side == "left") and (ax - 12 - pw) or (ax + aw + 12)
        if win.Dragged then return Vector2.new(x, ay) end
        return Vector2.new(Clamp(x, 4, math.max(4, vp.X - pw - 4)), Clamp(ay, 4, math.max(4, vp.Y - ph - 4)))
end

function Lib:_HasRoom(panel)
        local win, s = self.MainWindow, self.Scale
        local pos = win.Main.Position
        local vp = GetViewport()
        local pw = (panel.CW or panel.W) * s
        if win.Dragged then return true end
        if panel.Side == "left" then return pos.X.Offset - 12 - pw >= 4 end
        return pos.X.Offset + win.W * s + 12 + pw <= vp.X - 4
end

function Lib:_Place(panel, animate)
        local win = self.MainWindow
        if not win or panel.Moved or not panel.Side then return end
        local vp, s = GetViewport(), self.Scale
        local w, h = math.min(panel.W, (vp.X - 8) / s), math.min(panel.H, (vp.Y - 8) / s)
        panel.CW, panel.CH = w, h
        panel.Frame.Size = UDim2.fromOffset(w, h)
        local p
        if self:_HasRoom(panel) then
                p = self:_DockPos(panel)
        else
                p = Vector2.new(Clamp((vp.X - w * s) / 2, 4, math.max(4, vp.X - w * s - 4)), Clamp((vp.Y - h * s) / 2, 4, math.max(4, vp.Y - h * s - 4)))
        end
        local target = UDim2.fromOffset(p.X, p.Y)
        if animate then Tween(panel.Frame, { Position = target }, 0.22, Enum.EasingStyle.Quint) else panel.Frame.Position = target end
end

function Lib:_MakePanel(name, title, icon, w, h, side, short)
        local vp, s = GetViewport(), self.Scale
        w, h = math.min(w, (vp.X - 8) / s), math.min(h, (vp.Y - 8) / s)
        local frame = Sink(New("Frame", { Name = name, Size = UDim2.fromOffset(w, h), Theme = { BackgroundColor3 = "Bg" }, Parent = self.Gui }))
        Corner(frame, 8) Stroke(frame)
        local panel = self:_NewPanel(name, frame, false)
        panel.Side, panel.W, panel.H = side, w, h
        local head = New("Frame", { Name = "Head", Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1, Parent = frame })
        New("Frame", { Size = UDim2.new(1, -24, 0, 1), Position = UDim2.fromOffset(12, 37), BackgroundTransparency = 0.35, Theme = { BackgroundColor3 = "Stroke" }, Parent = frame })
        Lib.Icon(icon, 14, "SubText", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0), Parent = head })
        panel.TitleLabel = New("TextLabel", { Text = title, Font = Lib.FontBold, TextSize = 13, Size = UDim2.new(1, -100, 1, 0), Position = UDim2.fromOffset(33, 0), TextXAlignment = LEFT, Parent = head })
        local close = IconButton(head, "x", "×", H(26), "Close", "Bad")
        close.Button.AnchorPoint, close.Button.Position = Vector2.new(1, 0.5), UDim2.new(1, -8, 0.5, 0)
        close.Button.Activated:Connect(function() panel.UserSet = true panel:Set(false) end)
        local dock = IconButton(head, "link", "o", H(26), "Snap back to the menu", "Accent")
        dock.Button.AnchorPoint, dock.Button.Position, dock.Button.Visible = Vector2.new(1, 0.5), UDim2.new(1, -(8 + H(26) + 2), 0.5, 0), false
        function panel:Dock(animate)
                self.Moved = false
                dock.Button.Visible = false
                Lib:_Place(self, animate ~= false)
                self:Refresh()
        end
        dock.Button.Activated:Connect(function() panel:Dock(true) end)
        self:MakeDraggable(head, frame, {
                OnMove = function() panel.Moved = true dock.Button.Visible = true end,
                OnEnd = function()
                        if not self.MainWindow then return end
                        if (frame.AbsolutePosition - self:_DockPos(panel)).Magnitude < 36 then panel:Dock(true) end
                end,
        })
        panel.Head = head
        if self.MainWindow then self.MainWindow:_AddPanelButton(panel, icon, short or title, title) end
        return panel, frame
end

function Lib:_FinishPanel(panel)
        self:_Place(panel)
        panel:Set(self:_HasRoom(panel) and not self.Touch, true)
end

local Elements, Groupbox, SubTab, Tab, Window = {}, {}, {}, {}, {}
SubTab.__index, Tab.__index, Window.__index = SubTab, Tab, Window
local BoxMT = { __index = function(_, k) local v = Groupbox[k] if v ~= nil then return v end return Elements[k] end }
Lib.Elements, Lib.Window, Lib.Tab, Lib.SubTab, Lib.Groupbox = Elements, Window, Tab, SubTab, Groupbox

local function SideButton(parent, icon, text, order, compact)
        local b = {}
        b.Button = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, H(32)), LayoutOrder = order, Parent = parent })
        b.Fill = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Theme = { BackgroundColor3 = "Field" }, Parent = b.Button })
        Corner(b.Fill, 5)
        b.Bar = New("Frame", { Size = UDim2.fromOffset(2, 14), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), BackgroundTransparency = 1,
                Theme = { BackgroundColor3 = "Accent" }, Parent = b.Button })
        Corner(b.Bar, 1)
        b.Icon = Lib.Icon(icon, 16, "SubText", { AnchorPoint = Vector2.new(0.5, 0.5), Position = compact and UDim2.fromScale(0.5, 0.5) or UDim2.new(0, 22, 0.5, 0), ZIndex = 2, Parent = b.Button })
        if not compact then
                b.Label = New("TextLabel", { Text = text, TextSize = 13, Size = UDim2.new(1, -44, 1, 0), Position = UDim2.fromOffset(40, 0), TextXAlignment = LEFT, ZIndex = 2,
                        TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = b.Button })
        end
        b.Active = false
        function b:Style(active)
                self.Active = active
                Tween(self.Fill, { BackgroundTransparency = active and 0 or 1 }, 0.14)
                Tween(self.Bar, { BackgroundTransparency = active and 0 or 1 }, 0.14)
                Tint(self.Icon, active and Lib.Theme.Text or Lib.Theme.SubText)
                if self.Label then Tween(self.Label, { TextColor3 = active and Lib.Theme.Text or Lib.Theme.SubText }, 0.14) end
        end
        b.Button.MouseEnter:Connect(function() if not b.Active then Tween(b.Fill, { BackgroundTransparency = 0.6 }, 0.08) end end)
        b.Button.MouseLeave:Connect(function() if not b.Active then Tween(b.Fill, { BackgroundTransparency = 1 }, 0.1) end end)
        return b
end

local function Chip(parent, icon, text, order)
        local b = { Active = false, Count = 0, Compact = false }
        local tw, th = Lib.Touch and 38 or 30, Lib.Touch and 22 or 16
        local kn = th - 6
        local function KX(on) return on and (tw - kn - 3) or 3 end
        b.Button = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, H(32)), LayoutOrder = order, Parent = parent })
        b.Fill = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.6, Theme = { BackgroundColor3 = "Field" }, Parent = b.Button })
        Corner(b.Fill, 7)
        b.Icon = Lib.Icon(icon, 15, "SubText", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 19, 0.5, 0), ZIndex = 2, Parent = b.Button })
        b.Label = New("TextLabel", { Text = text, TextSize = 13, Size = UDim2.new(1, -(38 + tw + 14), 1, 0), Position = UDim2.fromOffset(38, 0), TextXAlignment = LEFT, ZIndex = 2,
                TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = b.Button })
        b.Track = New("Frame", { Size = UDim2.fromOffset(tw, th), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -9, 0.5, 0), ZIndex = 2,
                Theme = { BackgroundColor3 = "Stroke" }, Parent = b.Button })
        Corner(b.Track, th / 2)
        b.Knob = New("Frame", { Size = UDim2.fromOffset(kn, kn), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), ZIndex = 3,
                Theme = { BackgroundColor3 = "Dim" }, Parent = b.Track })
        Corner(b.Knob, kn / 2)
        b.Dot = New("Frame", { Size = UDim2.fromOffset(6, 6), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -4, 1, -4), Visible = false, ZIndex = 3,
                Theme = { BackgroundColor3 = "Accent" }, Parent = b.Button })
        Corner(b.Dot, 3)
        b.BadgeFrame = New("Frame", { Size = UDim2.fromOffset(15, 15), Position = UDim2.new(0, 24, 0, -3), Visible = false, ZIndex = 6, Theme = { BackgroundColor3 = "Bad" }, Parent = b.Button })
        Corner(b.BadgeFrame, 8)
        b.BadgeText = New("TextLabel", { Text = "1", Font = Lib.FontBold, TextSize = 9, Size = UDim2.fromScale(1, 1), TextColor3 = WHITE, ZIndex = 7, Parent = b.BadgeFrame })
        function b:Layout(_, compact)
                self.Compact = compact and true or false
                self.Label.Visible = not self.Compact
                self.Track.Visible = not self.Compact
                self.Dot.Visible = self.Compact and self.Active
                self.Icon.Position = self.Compact and UDim2.fromScale(0.5, 0.5) or UDim2.new(0, 19, 0.5, 0)
                self.BadgeFrame.AnchorPoint = self.Compact and Vector2.new(1, 0) or Vector2.new(0, 0)
                self.BadgeFrame.Position = self.Compact and UDim2.new(1, -1, 0, 1) or UDim2.new(0, 24, 0, -3)
        end
        function b:Style(on)
                self.Active = on
                if self.Compact then
                        -- icon-only rail: a lit accent tile instead of a switch
                        Tween(self.Fill, { BackgroundColor3 = on and Lib.Theme.FieldHover or Lib.Theme.Field, BackgroundTransparency = on and 0 or 0.6 }, 0.14)
                else
                        Tween(self.Fill, { BackgroundTransparency = on and 0.3 or 0.6 }, 0.14)
                end
                Tween(self.Track, { BackgroundColor3 = on and Lib.Theme.Accent or Lib.Theme.Stroke }, 0.14)
                Tween(self.Knob, { Position = UDim2.new(0, KX(on), 0.5, 0), BackgroundColor3 = on and Lib.KnobOn() or Lib.Theme.Dim }, 0.18, Enum.EasingStyle.Quint)
                Tint(self.Icon, on and Lib.Theme.Accent or Lib.Theme.SubText)
                Tween(self.Label, { TextColor3 = on and Lib.Theme.Text or Lib.Theme.SubText }, 0.14)
                self.Dot.Visible = self.Compact and on
        end
        function b:SetBadge(n)
                self.Count = n
                self.BadgeFrame.Visible = n > 0
                self.BadgeText.Text = n > 9 and "9+" or tostring(n)
        end
        function b:AddBadge() self:SetBadge(self.Count + 1) end
        b.Button.MouseEnter:Connect(function() if not b.Active then Tween(b.Fill, { BackgroundTransparency = 0.35 }, 0.08) end end)
        b.Button.MouseLeave:Connect(function() if not b.Active then Tween(b.Fill, { BackgroundTransparency = 0.6 }, 0.1) end end)
        return b
end

function Lib:CreateWindow(cfg)
        cfg = Merge({ Title = "Aether", Subtitle = "", Icon = "layout-grid", Size = nil, ToggleKey = Enum.KeyCode.RightShift,
                Folder = nil, Accent = nil, SearchPlaceholder = "Search settings...", MinSize = Vector2.new(400, 280), Sidebar = "icons" }, cfg)
        self.Name = cfg.Title
        self.ConfigFolder = cfg.Folder or cfg.Title
        if cfg.ToggleKey then self.ToggleKey = cfg.ToggleKey end
        InitIcons()
        if cfg.Accent then self:SetAccent(cfg.Accent) end
        local scale, aw, ah = self:_Metrics()
        local explicit = typeof(cfg.Size) == "UDim2"
        self.Scale = scale
        local win = setmetatable({ Cfg = cfg, Tabs = {}, PanelButtons = {}, Locked = false, Auto = not explicit, UserSized = false,
                BaseW = explicit and cfg.Size.X.Offset or aw, BaseH = explicit and cfg.Size.Y.Offset or ah }, Window)
        self.MainWindow = win
        local vp, s = GetViewport(), self.Scale
        local W, Hh = math.min(win.BaseW, (vp.X - 16) / s), math.min(win.BaseH, (vp.Y - 16) / s)
        win.W, win.H = W, Hh
        local compact = cfg.Sidebar ~= "full"
        local SW = compact and 54 or 156
        win.SW, win.Compact = SW, compact
        win.OneCol = (W - SW - 24) * s < 440
        local main = Sink(New("Frame", { Name = "Window", Size = UDim2.fromOffset(W, Hh), Position = UDim2.fromOffset((vp.X - W * s) / 2, (vp.Y - Hh * s) / 2),
                Theme = { BackgroundColor3 = "Bg" }, Parent = self.Gui }))
        Corner(main, 8) Stroke(main)
        win.Main = main
        self:_Glass(main, 1)
        win.Panel = self:_NewPanel("Window", main, true)
        local side = New("Frame", { Name = "Sidebar", Size = UDim2.new(0, SW, 1, 0), Theme = { BackgroundColor3 = "Surface" }, Parent = main })
        Corner(side, 8)
        win.Side = side
        win.SideFill = New("Frame", { Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), Theme = { BackgroundColor3 = "Surface" }, Parent = side })
        self:_Glass(side, 1)
        self:_Glass(win.SideFill, 1)
        New("Frame", { Size = UDim2.new(0, 1, 1, 0), Position = UDim2.fromOffset(SW, 0), Theme = { BackgroundColor3 = "Stroke" }, Parent = main })
        local brand = New("Frame", { Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1, Parent = side })
        local dragOpts = { Check = function() return not win.Locked end, OnMove = function() win.Dragged = true end, OnEnd = function() win:Clamp() end }
        self:MakeDraggable(brand, main, dragOpts)
        win.Logo = Lib.Icon(cfg.Icon, 20, "Accent", { AnchorPoint = Vector2.new(0.5, 0.5), Position = win.Compact and UDim2.fromScale(0.5, 0.5) or UDim2.new(0, 24, 0.5, 0), Parent = brand }, tostring(cfg.Title):sub(1, 1):upper())
        if not win.Compact then
                win.BrandLabel = New("TextLabel", { Text = cfg.Title, Font = Lib.FontBold, TextSize = 15, Size = UDim2.new(1, -52, 1, 0), Position = UDim2.fromOffset(42, 0),
                        TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Parent = brand })
        end
        if win.Compact then Lib:AddTooltip(brand, cfg.Title) end
        win.TabList = New("Frame", { Position = UDim2.fromOffset(8, 56), Size = UDim2.new(1, -16, 1, -64), BackgroundTransparency = 1, Parent = side })
        List(win.TabList, 3)
        win.Bottom = New("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 8, 1, -8), Size = UDim2.new(1, -16, 0, 0), AutomaticSize = Y, BackgroundTransparency = 1, ZIndex = 2, Parent = side })
        List(win.Bottom, 6, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Bottom)
        local me = New("TextButton", { Name = "Profile", Text = "", Size = UDim2.new(1, 0, 0, H(36)), LayoutOrder = 99, Parent = win.Bottom })
        New("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromOffset(0, -4), BackgroundTransparency = 0.4, Theme = { BackgroundColor3 = "Stroke" }, Parent = me })
        win.MeFill = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Theme = { BackgroundColor3 = "Field" }, Parent = me })
        Corner(win.MeFill, 6)
        local av = New("ImageLabel", { Size = UDim2.fromOffset(24, 24), AnchorPoint = Vector2.new(0, 0.5), Position = win.Compact and UDim2.new(0.5, -12, 0.5, 0) or UDim2.new(0, 8, 0.5, 0),
                BackgroundTransparency = 0, ZIndex = 2, Theme = { BackgroundColor3 = "Field" }, Parent = me })
        Corner(av, 12)
        win.Avatar = av
        GetAvatar(LocalPlayer.UserId, function(url) if av.Parent and not win.NameHidden then av.Image = url end end)
        if win.Compact then
                Lib:AddTooltip(me, "Profile")
        else
                win.NameLabel = New("TextLabel", { Text = LocalPlayer.DisplayName, TextSize = 12, Size = UDim2.new(1, -66, 0, 14), Position = UDim2.fromOffset(40, 4), TextXAlignment = LEFT,
                        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 2, Parent = me })
                New("TextLabel", { Text = "Profile & server", TextSize = 10, Size = UDim2.new(1, -66, 0, 12), Position = UDim2.fromOffset(40, 18), TextXAlignment = LEFT,
                        ZIndex = 2, Theme = { TextColor3 = "Dim" }, Parent = me })
                Lib.Icon("chevron-right", 12, "Dim", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), ZIndex = 2, Parent = me }, ">")
        end
        me.MouseEnter:Connect(function() if win.ActiveTab ~= win.ProfileTab then Tween(win.MeFill, { BackgroundTransparency = 0.6 }, 0.08) end end)
        me.MouseLeave:Connect(function() if win.ActiveTab ~= win.ProfileTab then Tween(win.MeFill, { BackgroundTransparency = 1 }, 0.1) end end)
        me.Activated:Connect(function() win:OpenProfile() end)
        local header = New("Frame", { Name = "Header", Position = UDim2.fromOffset(SW + 1, 0), Size = UDim2.new(1, -(SW + 1), 0, 46), BackgroundTransparency = 1, Parent = main })
        local lastTap = 0
        self:MakeDraggable(header, main, Merge(dragOpts, { OnTap = function()
                if os.clock() - lastTap < 0.35 then lastTap = 0 win:ToggleMinimize() else lastTap = os.clock() end
        end }))
        win.TitleLabel = New("TextLabel", { Text = "", Font = Lib.FontBold, TextSize = 15, Size = UDim2.new(0.5, -10, 0, 18), Position = UDim2.fromOffset(14, 7),
                TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Parent = header })
        win.SubLabel = New("TextLabel", { Text = "", TextSize = 11, Size = UDim2.new(0.5, -10, 0, 13), Position = UDim2.fromOffset(14, 25),
                TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Dim" }, Parent = header })
        local closeB = IconButton(header, "x", "×", H(26), "Close", "Bad")
        closeB.Button.AnchorPoint, closeB.Button.Position = Vector2.new(1, 0.5), UDim2.new(1, -12, 0, 23)
        closeB.Button.Activated:Connect(function() Lib:SetVisible(false) end)
        local minB = IconButton(header, "minus", "-", H(26), function() return win.Minimized and "Restore" or "Minimize" end, "Accent")
        minB.Button.AnchorPoint, minB.Button.Position = Vector2.new(1, 0.5), UDim2.new(1, -(12 + H(26) + 6), 0, 23)
        minB.Button.Activated:Connect(function() win:ToggleMinimize() end)
        win.MinBtn, win.MinIcon = minB, minB.Icon
        local sw = Clamp((W - SW) * 0.38, 100, 220)
        local search = New("Frame", { Size = UDim2.fromOffset(sw, H(26)), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -(12 + (H(26) + 6) * 2), 0, 23),
                BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Field" }, Parent = header })
        Lib:_Glass(search, 0.7)
        Corner(search, 5)
        local searchStroke = Stroke(search, "Stroke", 1, 0.4)
        Lib.Icon("search", 13, "Dim", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), Parent = search }, "?")
        win.SearchBox = New("TextBox", { Text = "", PlaceholderText = cfg.SearchPlaceholder, PlaceholderColor3 = Lib.Theme.Dim, TextSize = 12, Size = UDim2.new(1, -48, 1, 0),
                Position = UDim2.fromOffset(28, 0), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Parent = search })
        local clear = New("TextButton", { Text = "×", TextSize = 15, Size = UDim2.fromOffset(20, 20), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -3, 0.5, 0),
                Visible = false, Theme = { TextColor3 = "SubText" }, Parent = search })
        clear.Activated:Connect(function() win.SearchBox.Text = "" end)
        win.SearchBox.Focused:Connect(function() Tween(searchStroke, { Color = Lib.Theme.Accent, Transparency = 0.2 }, 0.1) end)
        win.SearchBox.FocusLost:Connect(function() Tween(searchStroke, { Color = Lib.Theme.Stroke, Transparency = 0.4 }, 0.1) end)
        win:_BuildSearch(search, clear)
        win.SubBar = New("Frame", { Name = "SubBar", Position = UDim2.fromOffset(SW + 14, 46), Size = UDim2.new(1, -(SW + 28), 0, 30), BackgroundTransparency = 1, Visible = false, Parent = main })
        win.Pages = New("Frame", { Name = "Pages", Position = UDim2.fromOffset(SW + 12, 52), Size = UDim2.new(1, -(SW + 20), 1, -60), BackgroundTransparency = 1, ClipsDescendants = true, Parent = main })
        win.Pages:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() win:_Relayout() end)
        local grip = New("TextButton", { Text = "", Size = UDim2.fromOffset(H(20), H(20)), AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromScale(1, 1), ZIndex = 10, Parent = main })
        Lib.Icon("move-diagonal-2", 10, "Dim", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 1, 0.5, 1), ZIndex = 11, Parent = grip }, "")
        grip.InputBegan:Connect(function(input)
                if not IsPress(input) then return end
                local isTouch = input.UserInputType == Enum.UserInputType.Touch
                local sc = Lib.Scale
                local start, size0 = Pointer(input), main.AbsoluteSize / sc
                LockScroll(grip, true)
                local mc, ec
                mc = UIS.InputChanged:Connect(function(i)
                        if isTouch then if i ~= input then return end elseif i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
                        local d, v = (Pointer(i) - start) / sc, GetViewport()
                        local maxW, maxH = (v.X - 16) / sc, (v.Y - 16) / sc
                        local nw = Clamp(size0.X + d.X, math.min(cfg.MinSize.X, maxW), maxW)
                        local nh = Clamp(size0.Y + d.Y, math.min(cfg.MinSize.Y, maxH), maxH)
                        win.W, win.H, win.BaseW, win.BaseH, win.UserSized = nw, nh, nw, nh, true
                        main.Size = UDim2.fromOffset(nw, nh)
                end)
                ec = UIS.InputEnded:Connect(function(i)
                        local fin = isTouch and (i == input) or (not isTouch and i.UserInputType == Enum.UserInputType.MouseButton1)
                        if fin then mc:Disconnect() ec:Disconnect() LockScroll(grip, false) win:Clamp() end
                end)
        end)
        win.Grip = grip
        local function Replace() for _, p in pairs(Lib.Panels) do if p.Side then Lib:_Place(p) end end end
        main:GetPropertyChangedSignal("Position"):Connect(Replace)
        main:GetPropertyChangedSignal("Size"):Connect(Replace)
        Lib:Connect(self.Gui:GetPropertyChangedSignal("AbsoluteSize"), function()
                if win.Auto and not win.UserSized and not Lib.UserScaled then win:AutoFit() else win:_Fit() end
        end)
        if self.Touch then self:CreateMobileButton() end
        return win
end

function Window:_Fit()
        local vp, s = GetViewport(), Lib.Scale
        local w, h = math.min(self.BaseW, (vp.X - 16) / s), math.min(self.BaseH, (vp.Y - 16) / s)
        self.W, self.H = w, h
        self.Main.Size = UDim2.fromOffset(w, self.Minimized and 46 or h)
        self:Clamp(true)
end

function Window:AutoFit(resetPosition)
        local s, w, h = Lib:_Metrics()
        self.BaseW, self.BaseH = w, h
        Lib:_ApplyScale(s)
        local sl = Lib.Options.UiScale
        if sl then sl:SetValue(math.floor(Lib.Scale * 100 + 0.5), true) end
        if resetPosition then self:ResetPosition() end
end

function Window:Clamp(strict)
        local vp, s = GetViewport(), Lib.Scale
        local sz = Vector2.new(self.W * s, self.H * s)
        local pos = self.Main.Position
        local x, y
        if strict then
                x = Clamp(pos.X.Offset, 4, math.max(4, vp.X - sz.X - 4))
                y = Clamp(pos.Y.Offset, 4, math.max(4, vp.Y - sz.Y - 4))
        else
                x = Clamp(pos.X.Offset, 44 - sz.X, vp.X - 44)
                y = Clamp(pos.Y.Offset, 14 - 52 * s, vp.Y - 24)
        end
        if x ~= pos.X.Offset or y ~= pos.Y.Offset then
                self.Main.Position = UDim2.new(pos.X.Scale, x, pos.Y.Scale, y)
        end
end

function Window:ResetPosition()
        self.Dragged = false
        local vp, s = GetViewport(), Lib.Scale
        self.Main.Position = UDim2.fromOffset((vp.X - self.W * s) / 2, (vp.Y - self.H * s) / 2)
        self:Clamp(true)
end

function Window:SetMinimized(state, instant)
        state = state and true or false
        if self.Minimized == state then return end
        self.Minimized = state
        self._minGen = (self._minGen or 0) + 1
        local gen = self._minGen
        Lib:ClosePopup()
        local main, MINH = self.Main, 46
        if self.MinBtn then
                self.MinBtn.Rest = state and "Accent" or "SubText"
                Tint(self.MinBtn.Icon, Lib.Theme[self.MinBtn.Rest], 0.12)
        end
        for _, p in pairs(Lib.Panels) do p:Refresh() end
        -- the body is hidden outright while minimized, so no sliver of the window can show under the header
        local function Body(v)
                for _, f in ipairs({ self.Pages, self.TabList, self.Bottom, self.Grip }) do f.Visible = v end
                if v then self:_UpdateSubBar() else self.SubBar.Visible = false end
        end
        if state then
                self.Bottom.Position = UDim2.new(0, 8, 0, self.H - 8)
                main.ClipsDescendants = true
                local function Done() if self._minGen == gen then Body(false) end end
                if instant then main.Size = UDim2.fromOffset(self.W, MINH) Done() return end
                local t = Tween(main, { Size = UDim2.fromOffset(self.W, MINH) }, 0.3, Enum.EasingStyle.Quint)
                t.Completed:Connect(Done)
        else
                Body(true)
                main.ClipsDescendants = true
                local function Done()
                        if self._minGen ~= gen then return end
                        main.ClipsDescendants = false
                        self.Bottom.Position = UDim2.new(0, 8, 1, -8)
                        self.Grip.Visible = true
                end
                if instant then main.Size = UDim2.fromOffset(self.W, self.H) Done() return end
                local t = Tween(main, { Size = UDim2.fromOffset(self.W, self.H) }, 0.34, Enum.EasingStyle.Quint)
                t.Completed:Connect(Done)
        end
end

function Window:ToggleMinimize() self:SetMinimized(not self.Minimized) end
function Window:SetTransparency(t) Lib:SetGlass(t) end
function Window:SetLocked(s) self.Locked = s and true or false end

function Window:SetNameHidden(s)
        self.NameHidden = s and true or false
        if self.NameLabel then self.NameLabel.Text = s and "Hidden" or LocalPlayer.DisplayName end
        local key = LocalPlayer.UserId .. ":HeadShot"
        if s then self.Avatar.Image = "" elseif AvatarCache[key] then self.Avatar.Image = AvatarCache[key] end
end

function Window:_Relayout()
        local one = self.Pages.AbsoluteSize.X < 440
        if one == self.OneCol then return end
        self.OneCol = one
        for _, t in ipairs(self.Tabs) do for _, s in ipairs(t.Subs) do s:_SetColumns(one) end end
end

function Window:SetTitle(t) self.Cfg.Title = t if self.BrandLabel then self.BrandLabel.Text = t end Lib.Name = t self:_UpdateSub() end
function Window:SetSubtitle(t) self.Cfg.Subtitle = t self:_UpdateSub() end

function Window:_UpdateSub()
        local tab = self.ActiveTab
        self.TitleLabel.Text = tab and tab.Name or ""
        local s = self.Cfg.Title
        if self.Cfg.Subtitle ~= "" then s = s .. " · " .. self.Cfg.Subtitle end
        self.SubLabel.Text = s
end

function Window:_LayoutDock()
        if self.DockTitle and self.DockTitle:IsA("TextLabel") then self.DockTitle.Visible = not self.Compact end
        for _, b in ipairs(self.PanelButtons) do b:Layout(nil, self.Compact) end
end

function Window:_RestyleDock() for _, b in ipairs(self.PanelButtons) do b:Style(b.Active) end end

function Window:_AddPanelButton(panel, icon, label, tip)
        if not self.Dock then
                self.Dock = New("Frame", { Name = "Dock", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Y, LayoutOrder = 50, BackgroundTransparency = 1, Parent = self.Bottom })
                List(self.Dock, 4)
                if self.Compact then
                        self.DockTitle = New("Frame", { Size = UDim2.new(1, 0, 0, 1), LayoutOrder = 0, BackgroundTransparency = 0.4, Theme = { BackgroundColor3 = "Stroke" }, Parent = self.Dock })
                else
                        self.DockTitle = New("TextLabel", { Text = "PANELS", Font = Lib.FontBold, TextSize = 10, Size = UDim2.new(1, 0, 0, 14), LayoutOrder = 0, TextXAlignment = LEFT,
                                Visible = true, Theme = { TextColor3 = "Dim" }, Parent = self.Dock })
                        Pad(self.DockTitle, 6, 0, 0, 0)
                end
        end
        local b = Chip(self.Dock, icon, label, #self.PanelButtons + 1)
        table.insert(self.PanelButtons, b)
        self:_LayoutDock()
        Lib:AddTooltip(b.Button, tip or label)
        b.Button.Activated:Connect(function() panel.UserSet = true panel:Set(not panel.Enabled) end)
        panel.RailButton = b
        panel.OnChanged = function(state)
                b:Style(state)
                if state then b:SetBadge(0) end
                local t = Lib.Toggles["Show" .. panel.Name]
                if t and t.Value ~= state then t:SetValue(state, true) end
        end
        return b
end

function Window:AddTab(name, icon, hidden)
        local tab = setmetatable({ Window = self, Name = name, Subs = {}, Default = nil, ActiveSub = nil, Hidden = hidden }, Tab)
        tab.Rail = SideButton(self.TabList, icon or "circle", name, #self.Tabs + 1, self.Compact)
        if hidden then tab.Rail.Button.Visible = false end
        if self.Compact and not hidden then Lib:AddTooltip(tab.Rail.Button, name) end
        tab.Rail.Button.Activated:Connect(function() self:SelectTab(tab) end)
        tab.Scroll = New("ScrollingFrame", { Name = "Page_" .. name, Size = UDim2.fromScale(1, 1), AutomaticCanvasSize = Y, Visible = false, Parent = self.Pages })
        Pad(tab.Scroll, 0, 0, 8, 12)
        tab.Stack = New("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Y, BackgroundTransparency = 1, Parent = tab.Scroll })
        List(tab.Stack, 8)
        tab.PillHolder = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Parent = self.SubBar })
        List(tab.PillHolder, 18, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Top)
        table.insert(self.Tabs, tab)
        if not self.ActiveTab and not hidden then self:SelectTab(tab) end
        return tab
end

function Window:_UpdateSubBar()
        local tab = self.ActiveTab
        local multi = tab ~= nil and #tab.Subs > 1
        local top = multi and 82 or 52
        self.SubBar.Visible = multi and not self.Minimized
        self.Pages.Position = UDim2.fromOffset(self.SW + 12, top)
        self.Pages.Size = UDim2.new(1, -(self.SW + 20), 1, -(top + 8))
        for _, t in ipairs(self.Tabs) do t.PillHolder.Visible = (t == tab) end
end

function Window:SelectTab(tab)
        if self.ActiveTab == tab then return end
        local first = self.ActiveTab == nil
        Lib:ClosePopup()
        for _, t in ipairs(self.Tabs) do
                t.Scroll.Visible = (t == tab)
                t.Rail:Style(t == tab)
        end
        self.ActiveTab = tab
        if self.MeFill then Tween(self.MeFill, { BackgroundTransparency = (tab == self.ProfileTab) and 0.3 or 1 }, 0.14) end
        self:_UpdateSub()
        self:_UpdateSubBar()
        if not first then
                tab.Scroll.Position = UDim2.fromOffset(0, 8)
                Tween(tab.Scroll, { Position = UDim2.new() }, 0.22, Enum.EasingStyle.Quint)
        end
end

function Window:OpenProfile()
        if not self.ProfileTab then self.ProfileTab = Lib:_BuildProfile(self) end
        self:SelectTab(self.ProfileTab)
end

function Tab:Show() self.Window:SelectTab(self) end

function Window:_BuildSearch(field, clear)
        local win, box = self, self.SearchBox
        local results = Sink(New("Frame", { Visible = false, BackgroundTransparency = 0, ZIndex = 90, Theme = { BackgroundColor3 = "Surface" }, Parent = Lib.Overlay }))
        Corner(results, 6) Stroke(results)
        local rlist = New("ScrollingFrame", { Size = UDim2.new(1, -8, 1, -8), Position = UDim2.fromOffset(4, 4), ZIndex = 91, ScrollBarThickness = 2, AutomaticCanvasSize = Y, Parent = results })
        List(rlist, 2)
        local first
        local function Hide() results.Visible = false end
        local function Pick(gb, e)
                Hide()
                if Lib.Popup and Lib.Popup.Frame == results then Lib.Popup = nil end
                box.Text = ""
                pcall(function() box:ReleaseFocus() end)
                task.defer(function() pcall(function() win:Goto(gb, e.row) end) end)
        end
        local function Rebuild()
                for _, c in ipairs(rlist:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
                first = nil
                local q = box.Text:lower()
                clear.Visible = q ~= ""
                if q == "" then Hide() return end
                local n = 0
                for _, tab in ipairs(win.Tabs) do for _, sub in ipairs(tab.Subs) do for _, gb in ipairs(sub.Groupboxes) do
                        for _, e in ipairs(gb.Entries) do
                                if n < 12 and not e.static and (e.text:find(q, 1, true) or gb.Name:lower():find(q, 1, true)) then
                                        n = n + 1
                                        if not first then first = { gb, e } end
                                        local b = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, 36), LayoutOrder = n, ZIndex = 92, Theme = { BackgroundColor3 = "Field" }, Parent = rlist })
                                        Corner(b, 4)
                                        New("TextLabel", { Text = e.name, TextSize = 13, Size = UDim2.new(1, -16, 0, 16), Position = UDim2.fromOffset(8, 3), TextXAlignment = LEFT, ZIndex = 93,
                                                TextTruncate = Enum.TextTruncate.AtEnd, Parent = b })
                                        New("TextLabel", { Text = tab.Name .. " › " .. sub.Name .. " › " .. gb.Name, TextSize = 10, Size = UDim2.new(1, -16, 0, 12), Position = UDim2.fromOffset(8, 20),
                                                TextXAlignment = LEFT, ZIndex = 93, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Dim" }, Parent = b })
                                        b.MouseEnter:Connect(function() Tween(b, { BackgroundColor3 = Lib.Theme.FieldHover }, 0.06) end)
                                        b.MouseLeave:Connect(function() Tween(b, { BackgroundColor3 = Lib.Theme.Field }, 0.08) end)
                                        local fired = false
                                        local function Go() if fired then return end fired = true Pick(gb, e) end
                                        b.InputBegan:Connect(function(i) if IsPress(i) then Go() end end)
                                        b.Activated:Connect(Go)
                                end
                        end
                end end end
                if n == 0 then
                        New("TextLabel", { Text = "No matches", TextSize = 12, Size = UDim2.new(1, 0, 0, 30), ZIndex = 92, Theme = { TextColor3 = "Dim" }, Parent = rlist })
                        n = 1
                end
                local w = Clamp(math.max(field.AbsoluteSize.X, 270), 200, Lib.Overlay.AbsoluteSize.X - 8)
                local pos, hh = PlaceBelow(field, w, math.min(n, 7) * 38 + 8, 4, true)
                results.Size = UDim2.fromOffset(w, hh)
                results.Position = UDim2.fromOffset(pos.X, pos.Y)
                if not results.Visible then
                        results.Visible = true
                        Lib:OpenPopup(results, Hide, field, true)
                end
        end
        box:GetPropertyChangedSignal("Text"):Connect(Rebuild)
        box.FocusLost:Connect(function(enter) if enter and first then Pick(first[1], first[2]) end end)
end

function Window:Goto(gb, row)
        if self.Minimized then self:SetMinimized(false, true) end
        local sub = gb.Sub
        local tab = sub.Tab
        self:SelectTab(tab)
        tab:SelectSub(sub)
        if gb.Collapsed then gb:SetCollapsed(false) end
        task.spawn(function()
                task.wait(0.12)
                if not row.Parent then return end
                local sc = tab.Scroll
                local y = row.AbsolutePosition.Y - sc.AbsolutePosition.Y + sc.CanvasPosition.Y - 28
                Tween(sc, { CanvasPosition = Vector2.new(0, math.max(0, y)) }, 0.25)
                local hl = New("Frame", { Size = UDim2.new(1, 10, 1, 6), Position = UDim2.fromOffset(-5, -3), BackgroundTransparency = 0.7, ZIndex = 0, Theme = { BackgroundColor3 = "Accent" }, Parent = row })
                Corner(hl, 4)
                Tween(hl, { BackgroundTransparency = 1 }, 1.4)
                task.delay(1.5, function() hl:Destroy() end)
        end)
end

function Lib:CreateMobileButton()
        if self.MobileButton then return self.MobileButton end
        local btn = New("TextButton", { Name = "MobileToggle", Text = "", Size = UDim2.fromOffset(44, 44), Position = UDim2.new(0, 12, 0.55, 0),
                BackgroundTransparency = 0, ZIndex = 20, Theme = { BackgroundColor3 = "Surface" }, Parent = self.Gui })
        Corner(btn, 12) Stroke(btn, "Accent", 1, 0.4)
        local win = self.MainWindow
        Lib.Icon(win and win.Cfg.Icon or "menu", 22, "Accent", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 21, Parent = btn })
        self:MakeDraggable(btn, btn, { OnTap = function() Lib:ToggleVisible() end })
        self.MobileButton = btn
        return btn
end

function Tab:AddSubTab(name, icon)
        local win = self.Window
        local sub = setmetatable({ Tab = self, Name = name, Groupboxes = {} }, SubTab)
        sub.Frame = New("Frame", { Name = "Sub_" .. name, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Y, BackgroundTransparency = 1, LayoutOrder = #self.Subs + 1,
                Visible = false, Parent = self.Stack })
        sub.Layout = List(sub.Frame, 8, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Top)
        local function Col(order)
                local c = New("Frame", { Size = UDim2.new(0.5, -4, 0, 0), AutomaticSize = Y, BackgroundTransparency = 1, LayoutOrder = order, Parent = sub.Frame })
                List(c, 8)
                return c
        end
        sub.Left, sub.Right = Col(1), Col(2)
        sub.Pill = New("TextButton", { Name = "Pill_" .. name, Text = name, TextSize = 13, Size = UDim2.fromOffset(0, H(28)), AutomaticSize = X,
                LayoutOrder = #self.Subs + 1, Theme = { TextColor3 = "SubText" }, Parent = self.PillHolder })
        sub.Under = New("Frame", { Size = UDim2.new(1, 0, 0, 2), AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), BackgroundTransparency = 1,
                Theme = { BackgroundColor3 = "Accent" }, Parent = sub.Pill })
        sub.Pill.Activated:Connect(function() self:SelectSub(sub) end)
        table.insert(self.Subs, sub)
        sub:_SetColumns(win.OneCol)
        if not self.ActiveSub then self:SelectSub(sub) end
        if win.ActiveTab == self then win:_UpdateSubBar() end
        return sub
end

function SubTab:_SetColumns(one)
        if one then
                self.Layout.FillDirection = Enum.FillDirection.Vertical
                self.Left.Size, self.Right.Size = UDim2.new(1, 0, 0, 0), UDim2.new(1, 0, 0, 0)
        else
                self.Layout.FillDirection = Enum.FillDirection.Horizontal
                self.Left.Size, self.Right.Size = UDim2.new(0.5, -4, 0, 0), UDim2.new(0.5, -4, 0, 0)
        end
end

function Tab:SelectSub(sub)
        self.ActiveSub = sub
        for _, s in ipairs(self.Subs) do
                local on = (s == sub)
                s.Frame.Visible = on
                Tween(s.Pill, { TextColor3 = on and Lib.Theme.Text or Lib.Theme.SubText }, 0.14)
                Tween(s.Under, { BackgroundTransparency = on and 0 or 1 }, 0.14)
        end
        if self.Window.ActiveTab == self then
                sub.Frame.Position = UDim2.fromOffset(0, 6)
                Tween(sub.Frame, { Position = UDim2.new() }, 0.2, Enum.EasingStyle.Quint)
        end
end

function Tab:_Default()
        if not self.Default then self.Default = self:AddSubTab("General") end
        return self.Default
end
function Tab:AddGroupbox(n, side, o) return self:_Default():AddGroupbox(n, side, o) end
function Tab:AddLeftGroupbox(n, o) return self:_Default():AddGroupbox(n, "Left", o) end
function Tab:AddRightGroupbox(n, o) return self:_Default():AddGroupbox(n, "Right", o) end
function SubTab:AddLeftGroupbox(n, o) return self:AddGroupbox(n, "Left", o) end
function SubTab:AddRightGroupbox(n, o) return self:AddGroupbox(n, "Right", o) end

function SubTab:AddGroupbox(name, side, opts)
        opts = opts or {}
        local column = (side == "Right") and self.Right or self.Left
        local box = setmetatable({ Name = name, Sub = self, Order = 0, Entries = {}, Collapsed = false }, BoxMT)
        box.Groupbox = box
        local frame = New("Frame", { Name = "Groupbox_" .. name, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Y, LayoutOrder = #self.Groupboxes + 1,
                Theme = { BackgroundColor3 = "Card" }, Parent = column })
        Lib:_Glass(frame, 1)
        Corner(frame, 6) Stroke(frame, "Stroke", 1, 0.3)
        local head = New("TextButton", { Name = "Head", Text = "", Size = UDim2.new(1, 0, 0, 30), Parent = frame })
        local tx = 12
        if opts.Icon then
                Lib.Icon(opts.Icon, 13, "SubText", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0), Parent = head })
                tx = 32
        end
        box.TitleLabel = New("TextLabel", { Text = name, Font = Lib.FontBold, TextSize = 12, Size = UDim2.new(1, -(tx + 30), 1, 0), Position = UDim2.fromOffset(tx, 0),
                TextXAlignment = LEFT, Parent = head })
        New("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromOffset(0, 30), BackgroundTransparency = 0.3, Theme = { BackgroundColor3 = "Stroke" }, Parent = frame })
        local container = New("Frame", { Name = "Container", Size = UDim2.new(1, 0, 0, 0), Position = UDim2.fromOffset(0, 31), AutomaticSize = Y, BackgroundTransparency = 1, Parent = frame })
        Pad(container, 12, 9, 12, 12)
        List(container, 8)
        box.Frame, box.Container = frame, container
        local arrow
        if opts.Collapsible then
                arrow = Lib.Icon("chevron-down", 14, "Dim", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Parent = head }, "v")
                head.Activated:Connect(function() box:SetCollapsed(not box.Collapsed) end)
        end
        function box:SetCollapsed(state)
                if not arrow then return end
                self.Collapsed = state
                container.Visible = not state
                Tween(arrow, { Rotation = state and -90 or 0 }, 0.15)
        end
        table.insert(self.Groupboxes, box)
        return box
end

function Groupbox:SetTitle(t) self.TitleLabel.Text = t self.Name = t end
function Groupbox:SetVisible(s) self.Frame.Visible = s end
-- LayoutOrder steps by 10 so inline panels (dropdown lists, color pickers) can slot in right under the row that owns them
function Groupbox:_NextOrder() self.Order = self.Order + 10 return self.Order end

local DepBox = {}

function Elements:AddDependencyBox()
        local box = setmetatable({ Order = 0, Dependencies = {} }, { __index = function(_, k) local v = DepBox[k] if v ~= nil then return v end return Elements[k] end })
        box.Groupbox = self.Groupbox
        box.Holder = New("Frame", { Name = "DependencyBox", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Y, BackgroundTransparency = 1, LayoutOrder = self:_NextOrder(), Parent = self.Container })
        List(box.Holder, 8)
        box.Container = box.Holder
        function box:_NextOrder() self.Order = self.Order + 10 return self.Order end
        return box
end

function DepBox:Update()
        local visible = true
        for _, dep in ipairs(self.Dependencies) do
                local v = dep[1].Value
                if type(v) == "table" then
                        if not v[dep[2]] then visible = false break end
                elseif v ~= dep[2] then visible = false break end
        end
        self.Holder.Visible = visible
        self.Holder.AutomaticSize = visible and Y or Enum.AutomaticSize.None
        if not visible then self.Holder.Size = UDim2.new(1, 0, 0, 0) end
end

function DepBox:SetupDependencies(deps)
        self.Dependencies = deps
        for _, d in ipairs(deps) do d[1]:OnChanged(function() self:Update() end) end
        self:Update()
end

function Elements:_Row(height)
        return New("Frame", { Name = "Row", Size = UDim2.new(1, 0, 0, height), BackgroundTransparency = 1, LayoutOrder = self:_NextOrder(), Parent = self.Container })
end

local function NewObject(kind, idx, info, row, owner, text)
        local obj = { Type = kind, Index = idx, Info = info, Row = row, Changed = Signal.new(), Visible = true, _ok = true }
        function obj:OnChanged(fn) return self.Changed:Connect(fn) end
        function obj:_Fire(...)
                if self.Index then Lib.Flags[self.Index] = self.Value end
                Safe(self.Info.Callback, self.Value, ...)
                self.Changed:Fire(self.Value, ...)
        end
        function obj:SetVisible(s) self.Visible = s and true or false self.Row.Visible = self.Visible end
        if idx then
                Lib.Options[idx] = obj
                if kind == "Toggle" then Lib.Toggles[idx] = obj end
        end
        if owner and owner.Groupbox and text then
                table.insert(owner.Groupbox.Entries, { row = row, obj = obj, name = tostring(text), text = (tostring(text) .. " " .. tostring(info.Keywords or "")):lower() })
        end
        return obj
end

local function Static(owner, row)
        if owner.Groupbox then table.insert(owner.Groupbox.Entries, { row = row, obj = { Visible = true, _ok = true }, name = "", text = "", static = true }) end
end

local function AddonHolder(obj)
        if obj.AddonFrame then return obj.AddonFrame end
        local f = New("Frame", { Name = "Addons", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -(obj.AddonOffset or 0), 0, 0), Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = X, BackgroundTransparency = 1, ZIndex = 3, Parent = obj.Row })
        List(f, 5, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
        obj.AddonFrame = f
        f:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                local l = obj.Label
                if l and l.Parent then
                        l.Size = UDim2.new(1, -((obj.LabelLeft or 0) + (obj.AddonOffset or 0) + f.AbsoluteSize.X + 8), l.Size.Y.Scale, l.Size.Y.Offset)
                end
        end)
        return f
end

-- A collapsible area that lives in the layout right under its owner row, so opening it pushes everything below down
-- instead of floating on top of other controls.
local function InlinePanel(row)
        local n = (row:GetAttribute("PanelCount") or 0) + 1
        row:SetAttribute("PanelCount", n)
        local p = New("Frame", { Name = "Inline", Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 0, ClipsDescendants = true, Visible = false,
                LayoutOrder = row.LayoutOrder + n, Theme = { BackgroundColor3 = "Surface" }, Parent = row.Parent })
        Corner(p, 6) Stroke(p, "Stroke", 1, 0.2)
        local o = { Frame = p, Open = false, _gen = 0 }
        function o:Set(state, h)
                self.Open = state
                self._gen = self._gen + 1
                local gen = self._gen
                if state then
                        p.Visible = true
                        Tween(p, { Size = UDim2.new(1, 0, 0, h) }, 0.18, Enum.EasingStyle.Quint)
                else
                        local t = Tween(p, { Size = UDim2.new(1, 0, 0, 0) }, 0.14, Enum.EasingStyle.Quint)
                        t.Completed:Connect(function() if self._gen == gen then p.Visible = false end end)
                end
        end
        function o:Resize(h) if self.Open then Tween(p, { Size = UDim2.new(1, 0, 0, h) }, 0.1) end end
        return o
end

function Elements:AddLabel(text, wrap)
        local row = New("Frame", { Name = "Label", Size = UDim2.new(1, 0, 0, 16), AutomaticSize = Y, BackgroundTransparency = 1, LayoutOrder = self:_NextOrder(), Parent = self.Container })
        local label = New("TextLabel", { Text = text, TextSize = 13, Size = UDim2.new(1, 0, 0, 16),
                TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top, Theme = { TextColor3 = "SubText" }, Parent = row })
        if wrap ~= false then Wrap(label, nil, nil, 16) else label.TextTruncate = Enum.TextTruncate.AtEnd end
        local obj = NewObject("Label", nil, {}, row, self, text)
        obj.TextLabel, obj.Label, obj.Text = label, label, text
        function obj:SetText(t) label.Text = t self.Text = t end
        function obj:AddColorPicker(i, inf) return Lib:_CreateColorPicker(self, i, inf) end
        function obj:AddKeyPicker(i, inf) return Lib:_CreateKeyPicker(self, i, inf) end
        return obj
end

function Elements:AddParagraph(title, text)
        local row = New("Frame", { Name = "Paragraph", Size = UDim2.new(1, 0, 0, 16), AutomaticSize = Y, BackgroundTransparency = 1, LayoutOrder = self:_NextOrder(), Parent = self.Container })
        List(row, 3)
        local t = New("TextLabel", { Text = title, Font = Lib.FontBold, TextSize = 13, Size = UDim2.new(1, 0, 0, 16), TextXAlignment = LEFT, LayoutOrder = 1, Parent = row })
        local b = New("TextLabel", { Text = text or "", TextSize = 12, Size = UDim2.new(1, 0, 0, 14), TextXAlignment = LEFT,
                TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = 2, Theme = { TextColor3 = "SubText" }, Parent = row })
        Wrap(b)
        local obj = NewObject("Paragraph", nil, {}, row, self, title)
        function obj:SetTitle(v) t.Text = v end
        function obj:SetText(v) b.Text = v end
        return obj
end

function Elements:AddSection(text)
        local row = self:_Row(18)
        New("TextLabel", { Text = string.upper(text), Font = Lib.FontBold, TextSize = 10, Size = UDim2.fromScale(1, 1), TextXAlignment = LEFT, Position = UDim2.fromOffset(0, 3),
                Theme = { TextColor3 = "Dim" }, Parent = row })
        Static(self, row)
        return row
end

function Elements:AddDivider(text)
        local row = self:_Row(text and 14 or 5)
        if text then
                New("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromScale(0, 0.5), Theme = { BackgroundColor3 = "Stroke" }, Parent = row })
                local l = New("TextLabel", { Text = text, TextSize = 10, AutomaticSize = X, Size = UDim2.fromOffset(0, 14), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, 0),
                        BackgroundTransparency = 0, Theme = { TextColor3 = "Dim", BackgroundColor3 = "Card" }, Parent = row })
                Pad(l, 6, 0, 6, 0)
                Lib:_Glass(l, 1)
        else
                New("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromOffset(0, 2), BackgroundTransparency = 0.35, Theme = { BackgroundColor3 = "Stroke" }, Parent = row })
        end
        Static(self, row)
        return row
end

function Elements:AddBlank(h)
        local row = self:_Row(h or 6)
        Static(self, row)
        return row
end

function Elements:AddCallout(text, kind)
        local key = ({ info = "Accent", success = "Good", warn = "Warn", error = "Bad" })[kind or "info"] or "Accent"
        local row = New("Frame", { Name = "Callout", Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 0.88, LayoutOrder = self:_NextOrder(),
                Theme = { BackgroundColor3 = key }, Parent = self.Container })
        Corner(row, 5)
        New("Frame", { Size = UDim2.new(0, 2, 1, -10), Position = UDim2.fromOffset(6, 5), Theme = { BackgroundColor3 = key }, Parent = row })
        local l = New("TextLabel", { Text = text, TextSize = 12, Size = UDim2.new(1, -28, 0, 14), Position = UDim2.fromOffset(18, 8), TextXAlignment = LEFT,
                TextYAlignment = Enum.TextYAlignment.Top, Parent = row })
        Wrap(l, row, 16)
        Static(self, row)
        local o = { Row = row }
        function o:SetText(t) l.Text = t end
        return o
end

function Elements:AddImage(info)
        info = Merge({ Image = "", Height = 90, Fit = true, Round = 6 }, type(info) == "table" and info or { Image = info })
        local row = self:_Row(info.Height)
        local img = New("ImageLabel", { Image = ToAsset(info.Image), Size = UDim2.fromScale(1, 1), ScaleType = info.Fit and Enum.ScaleType.Fit or Enum.ScaleType.Crop, Parent = row })
        Corner(img, info.Round)
        Static(self, row)
        local o = { Row = row, Image = img }
        function o:SetImage(v) img.Image = ToAsset(v) end
        return o
end

-- The hitbox is only the switch and the label text, never the empty space between them.
local function FitLabelHit(row, label, lhit, obj, reserve)
        local function Fit()
                if not row.Parent then return end
                local sc = math.max(Lib.Scale, 0.01)
                local addon = obj.AddonFrame and (obj.AddonFrame.AbsoluteSize.X / sc) or 0
                local avail = math.max(row.AbsoluteSize.X / sc - reserve - addon - 8, 0)
                lhit.Size = UDim2.new(0, math.min(label.TextBounds.X + 8, avail), 1, 0)
        end
        label:GetPropertyChangedSignal("TextBounds"):Connect(Fit)
        label:GetPropertyChangedSignal("AbsoluteSize"):Connect(Fit)
        row:GetPropertyChangedSignal("AbsoluteSize"):Connect(Fit)
        task.defer(Fit)
end

function Elements:AddToggle(idx, info)
        info = Merge({ Text = idx or "Toggle", Default = false, Risky = false, Disabled = false }, info)
        local row = self:_Row(H(26))
        local obj = NewObject("Toggle", idx, info, row, self, info.Text)
        obj.Value = info.Default and true or false
        obj._def = obj.Value
        if idx then Lib.Flags[idx] = obj.Value end
        local tw, th = Lib.Touch and 42 or 32, Lib.Touch and 24 or 18
        local kn = th - 6
        local function KX(on) return on and (tw - kn - 3) or 3 end
        obj.AddonOffset = tw + 10
        local label = New("TextLabel", { Text = info.Text, TextSize = 13, Size = UDim2.new(1, -(tw + 8), 1, 0), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd,
                TextColor3 = info.Risky and Lib.Theme.Bad or (obj.Value and Lib.Theme.Text or Lib.Theme.SubText), Parent = row })
        local track = New("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(tw, th), Theme = { BackgroundColor3 = "Field" }, Parent = row })
        Corner(track, th / 2)
        Lib:_Glass(track, 0.7)
        local tStroke = Stroke(track, "Stroke", 1, obj.Value and 1 or 0.15)
        local fill = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = obj.Value and 0 or 1, Theme = { BackgroundColor3 = "Accent" }, Parent = track })
        Corner(fill, th / 2)
        local knob = New("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, KX(obj.Value), 0.5, 0), Size = UDim2.fromOffset(kn, kn), ZIndex = 2,
                BackgroundColor3 = obj.Value and Lib.KnobOn() or Lib.Theme.Dim, Parent = track })
        Corner(knob, kn / 2)
        local hit = New("TextButton", { Name = "SwitchHit", Text = "", Size = UDim2.new(0, tw + 8, 1, 0), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 4, 0, 0), ZIndex = 2, Parent = row })
        local lhit = New("TextButton", { Name = "LabelHit", Text = "", Size = UDim2.new(0, 0, 1, 0), ZIndex = 2, Parent = row })
        FitLabelHit(row, label, lhit, obj, tw + 10)
        obj.Label = label
        local function Render()
                Tween(fill, { BackgroundTransparency = obj.Value and 0 or 1 }, 0.14)
                Tween(tStroke, { Transparency = obj.Value and 1 or 0.15 }, 0.14)
                Tween(knob, { Position = UDim2.new(0, KX(obj.Value), 0.5, 0), BackgroundColor3 = obj.Value and Lib.KnobOn() or Lib.Theme.Dim }, 0.18, Enum.EasingStyle.Quint)
                if not info.Risky then Tween(label, { TextColor3 = obj.Value and Lib.Theme.Text or Lib.Theme.SubText }, 0.12) end
        end
        function obj:SetValue(v, silent)
                v = v and true or false
                if self.Value == v then return end
                self.Value = v
                Render()
                if silent then if idx then Lib.Flags[idx] = v end else self:_Fire() end
        end
        function obj:SetText(t) label.Text = t end
        function obj:SetDisabled(s) info.Disabled = s label.TextTransparency = s and 0.55 or 0 track.BackgroundTransparency = s and 0.5 or 0 end
        function obj:Toggle() self:SetValue(not self.Value) end
        function obj:AddColorPicker(i, inf) return Lib:_CreateColorPicker(self, i, inf) end
        function obj:AddKeyPicker(i, inf) return Lib:_CreateKeyPicker(self, i, inf) end
        local function Flip() if not info.Disabled then obj:SetValue(not obj.Value) end end
        hit.Activated:Connect(Flip)
        lhit.Activated:Connect(Flip)
        obj:SetDisabled(info.Disabled)
        Lib:AddTooltip(row, info.Tooltip)
        return obj
end

function Elements:AddCheckbox(idx, info)
        info = Merge({ Text = idx or "Checkbox", Default = false, Disabled = false }, info)
        local row = self:_Row(H(24))
        local obj = NewObject("Toggle", idx, info, row, self, info.Text)
        obj.Value = info.Default and true or false
        obj._def = obj.Value
        if idx then Lib.Flags[idx] = obj.Value end
        local bs = Lib.Touch and 20 or 16
        obj.AddonOffset, obj.LabelLeft = 0, bs + 10
        local box = New("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(bs, bs), Theme = { BackgroundColor3 = "Field" }, Parent = row })
        Corner(box, 4) Stroke(box, "Stroke", 1, 0.2)
        local fill = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = obj.Value and 0 or 1, Theme = { BackgroundColor3 = "Accent" }, Parent = box })
        Corner(fill, 4)
        local tick = Lib.Icon("check", bs - 4, "OnAccent", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 3, Visible = obj.Value, Parent = box }, "✓")
        local label = New("TextLabel", { Text = info.Text, TextSize = 13, Size = UDim2.new(1, -(bs + 10), 1, 0), Position = UDim2.fromOffset(bs + 10, 0), TextXAlignment = LEFT,
                TextTruncate = Enum.TextTruncate.AtEnd, TextColor3 = obj.Value and Lib.Theme.Text or Lib.Theme.SubText, Parent = row })
        local hit = New("TextButton", { Name = "BoxHit", Text = "", Size = UDim2.new(0, bs + 6, 1, 0), ZIndex = 2, Parent = row })
        local lhit = New("TextButton", { Name = "LabelHit", Text = "", Size = UDim2.new(0, 0, 1, 0), Position = UDim2.fromOffset(bs + 6, 0), ZIndex = 2, Parent = row })
        FitLabelHit(row, label, lhit, obj, bs + 10)
        obj.Label = label
        local function Render()
                Tween(fill, { BackgroundTransparency = obj.Value and 0 or 1 }, 0.12)
                tick.Visible = obj.Value
                Tween(label, { TextColor3 = obj.Value and Lib.Theme.Text or Lib.Theme.SubText }, 0.12)
        end
        function obj:SetValue(v, silent)
                v = v and true or false
                if self.Value == v then return end
                self.Value = v
                Render()
                if silent then if idx then Lib.Flags[idx] = v end else self:_Fire() end
        end
        function obj:SetText(t) label.Text = t end
        function obj:SetDisabled(s) info.Disabled = s label.TextTransparency = s and 0.55 or 0 end
        function obj:AddColorPicker(i, inf) return Lib:_CreateColorPicker(self, i, inf) end
        function obj:AddKeyPicker(i, inf) return Lib:_CreateKeyPicker(self, i, inf) end
        local function Flip() if not info.Disabled then obj:SetValue(not obj.Value) end end
        hit.Activated:Connect(Flip)
        lhit.Activated:Connect(Flip)
        Lib:AddTooltip(row, info.Tooltip)
        return obj
end

function Elements:AddButton(textOrInfo, func)
        local info = type(textOrInfo) == "table" and textOrInfo or { Text = textOrInfo, Func = func }
        info = Merge({ Text = "Button", Func = function() end, DoubleClick = false, Disabled = false, Icon = nil }, info)
        local row = self:_Row(H(28))
        local obj = NewObject("Button", nil, info, row, self, info.Text)
        local button = New("TextButton", { Text = info.Text, TextSize = 13, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0, ClipsDescendants = true,
                TextTruncate = Enum.TextTruncate.AtEnd, Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = row })
        Corner(button, 5)
        -- padding: text keeps clear of the edges, and of the icon when one is set
        if info.Icon then
                button.TextXAlignment = LEFT
                Pad(button, 30, 3, 10, 3)
        else
                Pad(button, 10, 3, 10, 3)
        end
        Lib:_Glass(button, 0.7)
        local stroke = Stroke(button, "Stroke", 1, 0.3)
        -- the button has a UIPadding, which insets children too. Undo it so the flash fills the whole button.
        local padL, padT, padR, padB = info.Icon and 30 or 10, 3, 10, 3
        local flash = New("Frame", { Size = UDim2.new(1, padL + padR, 1, padT + padB), Position = UDim2.fromOffset(-padL, -padT),
                BackgroundTransparency = 1, Theme = { BackgroundColor3 = "Accent" }, Parent = button })
        Corner(flash, 5)
        if info.Icon then
                -- UIPadding insets child elements too, so the icon's own position is measured from inside the
                -- padded text area. Pull it back by the text padding (30) so it really sits at x=10, left of the
                -- text with an 6px gap - before this fix the icon rendered on top of the first letters.
                Lib.Icon(info.Icon, 14, "SubText", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, -20, 0.5, 0), Parent = button })
        end
        button.MouseEnter:Connect(function()
                if info.Disabled then return end
                Tween(button, { BackgroundColor3 = Lib.Theme.FieldHover, TextColor3 = Lib.Theme.Text }, 0.08)
        end)
        button.MouseLeave:Connect(function()
                Tween(button, { BackgroundColor3 = Lib.Theme.Field, TextColor3 = Lib.Theme.SubText }, 0.12)
        end)
        local armed = false
        button.Activated:Connect(function()
                if info.Disabled then return end
                if info.DoubleClick then
                        if not armed then
                                armed = true
                                button.Text = "Tap again to confirm"
                                stroke.Color, stroke.Transparency = Lib.Theme.Warn, 0
                                task.delay(2, function() if armed then armed = false button.Text = info.Text stroke.Color, stroke.Transparency = Lib.Theme.Stroke, 0.3 end end)
                                return
                        end
                        armed = false
                        button.Text = info.Text
                        stroke.Color, stroke.Transparency = Lib.Theme.Stroke, 0.3
                end
                flash.BackgroundTransparency = 0.86
                Tween(flash, { BackgroundTransparency = 1 }, 0.3)
                Safe(info.Func)
                obj.Changed:Fire()
        end)
        function obj:SetText(t) info.Text = t button.Text = t end
        function obj:SetDisabled(s) info.Disabled = s button.TextTransparency = s and 0.6 or 0 end
        function obj:Click() Safe(info.Func) end
        Lib:AddTooltip(row, info.Tooltip)
        return obj
end

function Elements:AddButtonRow(buttons)
        local n = math.max(#buttons, 1)
        local row = self:_Row(H(28))
        List(row, 6, Enum.FillDirection.Horizontal)
        local out = {}
        for i, bi in ipairs(buttons) do
                local b = New("TextButton", { Text = bi.Text or "Button", TextSize = 12, Size = UDim2.new(1 / n, -(6 * (n - 1)) / n, 1, 0), LayoutOrder = i, BackgroundTransparency = 0,
                        TextTruncate = Enum.TextTruncate.AtEnd, Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = row })
                Corner(b, 5) Stroke(b, "Stroke", 1, 0.3)
                Pad(b, 8, 2, 8, 2)
                Lib:_Glass(b, 0.7)
                b.MouseEnter:Connect(function() Tween(b, { BackgroundColor3 = Lib.Theme.FieldHover, TextColor3 = Lib.Theme.Text }, 0.08) end)
                b.MouseLeave:Connect(function() Tween(b, { BackgroundColor3 = Lib.Theme.Field, TextColor3 = Lib.Theme.SubText }, 0.12) end)
                b.Activated:Connect(function() Safe(bi.Func) end)
                out[i] = b
        end
        Static(self, row)
        return out
end

function Elements:AddSlider(idx, info)
        info = Merge({ Text = idx or "Slider", Min = 0, Max = 100, Default = 0, Rounding = 0, Prefix = "", Suffix = "", Display = nil, Disabled = false }, info)
        local row = self:_Row(H(38))
        local obj = NewObject("Slider", idx, info, row, self, info.Text)
        obj.Min, obj.Max = info.Min, info.Max
        obj.Value = Clamp(info.Default, info.Min, info.Max)
        obj._def = obj.Value
        if idx then Lib.Flags[idx] = obj.Value end
        local label = New("TextLabel", { Text = info.Text, TextSize = 13, Size = UDim2.new(1, -72, 0, 18), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = row })
        local valueBox = New("TextBox", { Text = "", TextSize = 12, Size = UDim2.fromOffset(66, 18), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
                TextXAlignment = RIGHT, ClearTextOnFocus = true, Theme = { BackgroundColor3 = "Field" }, Parent = row })
        Corner(valueBox, 4)
        Pad(valueBox, 8, 0, 8, 0)
        local vStroke = Stroke(valueBox, "Stroke", 1, 1)
        local th = Lib.Touch and 6 or 4
        local track = New("Frame", { Size = UDim2.new(1, 0, 0, th), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0, H(30)), Theme = { BackgroundColor3 = "Field" }, Parent = row })
        Corner(track, 2)
        Lib:_Glass(track, 0.7)
        local fill = New("Frame", { Size = UDim2.fromScale(0, 1), Theme = { BackgroundColor3 = "Accent" }, Parent = track })
        Corner(fill, 2)
        local kw, kh = Lib.Touch and 8 or 5, Lib.Touch and 18 or 13
        local knob = New("Frame", { Size = UDim2.fromOffset(kw, kh), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), ZIndex = 2, BackgroundColor3 = WHITE, Parent = track })
        Corner(knob, 2)
        local hit = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, H(22)), Position = UDim2.fromOffset(0, H(19)), ZIndex = 3, Parent = row })
        local function Format(v)
                if info.Display then return tostring(info.Display(v)) end
                local s = info.Rounding > 0 and string.format("%." .. info.Rounding .. "f", v) or tostring(math.floor(v + 0.5))
                return info.Prefix .. s .. info.Suffix
        end
        local function Render()
                local ratio = Clamp(Map(obj.Value, obj.Min, obj.Max, 0, 1), 0, 1)
                if obj._drag then
                        fill.Size = UDim2.fromScale(ratio, 1) knob.Position = UDim2.fromScale(ratio, 0.5)
                else
                        Tween(fill, { Size = UDim2.fromScale(ratio, 1) }, 0.1) Tween(knob, { Position = UDim2.fromScale(ratio, 0.5) }, 0.1)
                end
                if not valueBox:IsFocused() then valueBox.Text = Format(obj.Value) end
        end
        function obj:SetValue(v, silent)
                v = tonumber(v)
                if not v then return end
                v = Clamp(Round(v, info.Rounding), self.Min, self.Max)
                if v == self.Value then Render() return end
                self.Value = v
                Render()
                if silent then if idx then Lib.Flags[idx] = v end else self:_Fire() end
        end
        function obj:SetMin(v) self.Min = v self:SetValue(self.Value, true) Render() end
        function obj:SetMax(v) self.Max = v self:SetValue(self.Value, true) Render() end
        function obj:SetText(t) label.Text = t end
        local function FromPos(pos)
                obj:SetValue(Lerp(obj.Min, obj.Max, Clamp((pos.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)))
        end
        hit.InputBegan:Connect(function(input)
                if info.Disabled or not IsPress(input) then return end
                local isTouch = input.UserInputType == Enum.UserInputType.Touch
                obj._drag = true
                LockScroll(row, true)
                Tween(label, { TextColor3 = Lib.Theme.Text }, 0.08)
                FromPos(Pointer(input))
                local mc, ec
                mc = UIS.InputChanged:Connect(function(i)
                        if isTouch then if i == input then FromPos(Pointer(i)) end
                        elseif i.UserInputType == Enum.UserInputType.MouseMovement then FromPos(Pointer(i)) end
                end)
                ec = UIS.InputEnded:Connect(function(i)
                        local fin = isTouch and (i == input) or (not isTouch and i.UserInputType == Enum.UserInputType.MouseButton1)
                        if fin then
                                obj._drag = false
                                LockScroll(row, false)
                                Tween(label, { TextColor3 = Lib.Theme.SubText }, 0.12)
                                mc:Disconnect() ec:Disconnect()
                        end
                end)
        end)
        valueBox.Focused:Connect(function() valueBox.BackgroundTransparency = 0 Tween(vStroke, { Transparency = 0.2, Color = Lib.Theme.Accent }, 0.08) valueBox.Text = tostring(obj.Value) end)
        valueBox.FocusLost:Connect(function()
                valueBox.BackgroundTransparency = 1
                Tween(vStroke, { Transparency = 1 }, 0.08)
                local n = tonumber(valueBox.Text:match("%-?[%d%.]+"))
                if n then obj:SetValue(n) end
                valueBox.Text = Format(obj.Value)
        end)
        Render()
        Lib:AddTooltip(row, info.Tooltip)
        return obj
end

function Elements:AddRange(idx, info)
        info = Merge({ Text = idx or "Range", Min = 0, Max = 100, Default = { 25, 75 }, Rounding = 0, Prefix = "", Suffix = "", Disabled = false }, info)
        local row = self:_Row(H(38))
        local obj = NewObject("Range", idx, info, row, self, info.Text)
        obj.Min, obj.Max = info.Min, info.Max
        local lo, hi = tonumber(info.Default[1]) or info.Min, tonumber(info.Default[2]) or info.Max
        obj.Value = { Min = Clamp(math.min(lo, hi), info.Min, info.Max), Max = Clamp(math.max(lo, hi), info.Min, info.Max) }
        obj._def = { Min = obj.Value.Min, Max = obj.Value.Max }
        if idx then Lib.Flags[idx] = obj.Value end
        local label = New("TextLabel", { Text = info.Text, TextSize = 13, Size = UDim2.new(1, -110, 0, 18), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = row })
        local vl = New("TextLabel", { Text = "", TextSize = 12, Size = UDim2.fromOffset(106, 18), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), TextXAlignment = RIGHT, Parent = row })
        local th = Lib.Touch and 6 or 4
        local track = New("Frame", { Size = UDim2.new(1, 0, 0, th), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0, H(30)), Theme = { BackgroundColor3 = "Field" }, Parent = row })
        Corner(track, 2)
        Lib:_Glass(track, 0.7)
        local fill = New("Frame", { Size = UDim2.fromScale(1, 1), Theme = { BackgroundColor3 = "Accent" }, Parent = track })
        Corner(fill, 2)
        local kw, kh = Lib.Touch and 8 or 5, Lib.Touch and 18 or 13
        local k1 = New("Frame", { Size = UDim2.fromOffset(kw, kh), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), ZIndex = 2, BackgroundColor3 = WHITE, Parent = track })
        local k2 = New("Frame", { Size = UDim2.fromOffset(kw, kh), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(1, 0.5), ZIndex = 2, BackgroundColor3 = WHITE, Parent = track })
        Corner(k1, 2) Corner(k2, 2)
        local hit = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, H(22)), Position = UDim2.fromOffset(0, H(19)), ZIndex = 3, Parent = row })
        local function Fmt(v)
                local s = info.Rounding > 0 and string.format("%." .. info.Rounding .. "f", v) or tostring(math.floor(v + 0.5))
                return info.Prefix .. s .. info.Suffix
        end
        local function Render()
                local a = Clamp(Map(obj.Value.Min, obj.Min, obj.Max, 0, 1), 0, 1)
                local b = Clamp(Map(obj.Value.Max, obj.Min, obj.Max, 0, 1), 0, 1)
                fill.Position, fill.Size = UDim2.fromScale(a, 0), UDim2.fromScale(b - a, 1)
                k1.Position, k2.Position = UDim2.fromScale(a, 0.5), UDim2.fromScale(b, 0.5)
                vl.Text = Fmt(obj.Value.Min) .. " - " .. Fmt(obj.Value.Max)
        end
        function obj:SetValue(v, silent)
                if type(v) ~= "table" then return end
                local a, b = tonumber(v.Min or v[1]), tonumber(v.Max or v[2])
                if not (a and b) then return end
                a, b = Clamp(Round(a, info.Rounding), self.Min, self.Max), Clamp(Round(b, info.Rounding), self.Min, self.Max)
                if a > b then a, b = b, a end
                self.Value = { Min = a, Max = b }
                Render()
                if silent then if idx then Lib.Flags[idx] = self.Value end else self:_Fire() end
        end
        hit.InputBegan:Connect(function(input)
                if info.Disabled or not IsPress(input) then return end
                local isTouch = input.UserInputType == Enum.UserInputType.Touch
                LockScroll(row, true)
                local function Ratio(pos) return Clamp((pos.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1) end
                local r = Ratio(Pointer(input))
                local ra, rb = Map(obj.Value.Min, obj.Min, obj.Max, 0, 1), Map(obj.Value.Max, obj.Min, obj.Max, 0, 1)
                local which
                if ra == rb then which = r < ra and "Min" or "Max" else which = (math.abs(r - ra) <= math.abs(r - rb)) and "Min" or "Max" end
                local function Upd(pos)
                        local v = Lerp(obj.Min, obj.Max, Ratio(pos))
                        local a, b = obj.Value.Min, obj.Value.Max
                        if which == "Min" then a = math.min(v, b) else b = math.max(v, a) end
                        obj:SetValue({ Min = a, Max = b })
                end
                Upd(Pointer(input))
                local mc, ec
                mc = UIS.InputChanged:Connect(function(i)
                        if isTouch then if i == input then Upd(Pointer(i)) end
                        elseif i.UserInputType == Enum.UserInputType.MouseMovement then Upd(Pointer(i)) end
                end)
                ec = UIS.InputEnded:Connect(function(i)
                        local fin = isTouch and (i == input) or (not isTouch and i.UserInputType == Enum.UserInputType.MouseButton1)
                        if fin then LockScroll(row, false) mc:Disconnect() ec:Disconnect() end
                end)
        end)
        Render()
        Lib:AddTooltip(row, info.Tooltip)
        return obj
end

function Elements:AddInput(idx, info)
        info = Merge({ Text = idx or "Input", Default = "", Placeholder = "", Numeric = false, Finished = false, MaxLength = 200 }, info)
        local fh = H(26)
        local row = self:_Row(info.Text ~= "" and (fh + 20) or fh)
        local obj = NewObject("Input", idx, info, row, self, info.Text)
        obj.Value = tostring(info.Default)
        obj._def = obj.Value
        if idx then Lib.Flags[idx] = obj.Value end
        local y = 0
        if info.Text ~= "" then
                New("TextLabel", { Text = info.Text, TextSize = 13, Size = UDim2.new(1, 0, 0, 16), TextXAlignment = LEFT, Theme = { TextColor3 = "SubText" }, Parent = row })
                y = 20
        end
        local field = New("Frame", { Size = UDim2.new(1, 0, 0, fh), Position = UDim2.fromOffset(0, y), BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Field" }, Parent = row })
        Corner(field, 5)
        Lib:_Glass(field, 0.7)
        local stroke = Stroke(field, "Stroke", 1, 0.3)
        local box = New("TextBox", { Text = obj.Value, PlaceholderText = info.Placeholder, PlaceholderColor3 = Lib.Theme.Dim, TextSize = 13, Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.fromOffset(10, 0), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Parent = field })
        box.Focused:Connect(function() Tween(stroke, { Color = Lib.Theme.Accent, Transparency = 0.1 }, 0.1) end)
        local function Clean(t)
                if info.Numeric then t = t:gsub("[^%d%.%-]", "") end
                return t:sub(1, info.MaxLength)
        end
        box.FocusLost:Connect(function(enter)
                Tween(stroke, { Color = Lib.Theme.Stroke, Transparency = 0.3 }, 0.1)
                if info.Finished and not enter then return end
                box.Text = Clean(box.Text)
                obj.Value = box.Text
                obj:_Fire()
        end)
        if not info.Finished then
                box:GetPropertyChangedSignal("Text"):Connect(function()
                        if not box:IsFocused() then return end
                        local c = Clean(box.Text)
                        if c ~= box.Text then box.Text = c return end
                        obj.Value = c
                        obj:_Fire()
                end)
        end
        function obj:SetValue(v, silent)
                v = tostring(v or "")
                self.Value = v
                box.Text = v
                if silent then if idx then Lib.Flags[idx] = v end else self:_Fire() end
        end
        Lib:AddTooltip(row, info.Tooltip)
        return obj
end

function Elements:AddTextArea(idx, info)
        info = Merge({ Text = idx or "Text", Default = "", Placeholder = "", Height = 80, MaxLength = 2000 }, info)
        local y = info.Text ~= "" and 20 or 0
        local row = self:_Row(info.Height + y)
        local obj = NewObject("Input", idx, info, row, self, info.Text)
        obj.Value = tostring(info.Default)
        obj._def = obj.Value
        if idx then Lib.Flags[idx] = obj.Value end
        if info.Text ~= "" then
                New("TextLabel", { Text = info.Text, TextSize = 13, Size = UDim2.new(1, 0, 0, 16), TextXAlignment = LEFT, Theme = { TextColor3 = "SubText" }, Parent = row })
        end
        local field = New("Frame", { Size = UDim2.new(1, 0, 0, info.Height), Position = UDim2.fromOffset(0, y), BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Field" }, Parent = row })
        Corner(field, 5)
        Lib:_Glass(field, 0.7)
        local stroke = Stroke(field, "Stroke", 1, 0.3)
        local box = New("TextBox", { Text = obj.Value, PlaceholderText = info.Placeholder, PlaceholderColor3 = Lib.Theme.Dim, TextSize = 13, Size = UDim2.new(1, -20, 1, -14),
                Position = UDim2.fromOffset(10, 7), TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top, MultiLine = true, TextWrapped = true, ClipsDescendants = true, Parent = field })
        box.Focused:Connect(function() Tween(stroke, { Color = Lib.Theme.Accent, Transparency = 0.1 }, 0.1) end)
        box.FocusLost:Connect(function()
                Tween(stroke, { Color = Lib.Theme.Stroke, Transparency = 0.3 }, 0.1)
                box.Text = box.Text:sub(1, info.MaxLength)
                obj.Value = box.Text
                obj:_Fire()
        end)
        function obj:SetValue(v, silent)
                v = tostring(v or "")
                self.Value = v
                box.Text = v
                if silent then if idx then Lib.Flags[idx] = v end else self:_Fire() end
        end
        return obj
end

-- Dropdown: the list opens inline, directly under the field, and pushes the controls below it down (no floating overlay).
function Elements:AddDropdown(idx, info)
        info = Merge({ Text = idx or "Dropdown", Values = {}, Default = nil, Multi = false, AllowNull = false, MaxVisible = 7, Searchable = nil,
                Placeholder = "Select...", SpecialType = nil, ExcludeLocalPlayer = false, Disabled = false }, info)
        local hasText = info.Text ~= ""
        local fh = H(26)
        local row = self:_Row(hasText and (fh + 20) or fh)
        local obj = NewObject("Dropdown", idx, info, row, self, info.Text)
        local function PlayerValues()
                local out = {}
                for _, p in ipairs(Players:GetPlayers()) do
                        if not (info.ExcludeLocalPlayer and p == LocalPlayer) then table.insert(out, p.Name) end
                end
                table.sort(out)
                return out
        end
        obj.Values = info.SpecialType == "Player" and PlayerValues() or info.Values
        if info.Searchable == nil then info.Searchable = info.SpecialType == "Player" or #obj.Values > 7 end
        local function InitValue()
                local def = info.Default
                if info.Multi then
                        local t = {}
                        if type(def) == "table" then
                                for k, v in pairs(def) do
                                        if type(k) == "number" then t[type(v) == "number" and obj.Values[v] or v] = true elseif v then t[k] = true end
                                end
                        elseif type(def) == "string" then t[def] = true
                        elseif type(def) == "number" and obj.Values[def] then t[obj.Values[def]] = true end
                        return t
                end
                if type(def) == "number" then return obj.Values[def] end
                if type(def) == "string" then return def end
                if info.AllowNull then return nil end
                return obj.Values[1]
        end
        obj.Value = InitValue()
        if info.Multi then
                obj._def = {}
                for k, v in pairs(obj.Value) do obj._def[k] = v end
        else
                obj._def = obj.Value
        end
        if idx then Lib.Flags[idx] = obj.Value end
        local y = 0
        if hasText then
                New("TextLabel", { Text = info.Text, TextSize = 13, Size = UDim2.new(1, 0, 0, 16), TextXAlignment = LEFT, Theme = { TextColor3 = "SubText" }, Parent = row })
                y = 20
        end
        local field = New("TextButton", { Name = "Field", Text = "", Size = UDim2.new(1, 0, 0, fh), Position = UDim2.fromOffset(0, y), BackgroundTransparency = 0,
                Theme = { BackgroundColor3 = "Field" }, Parent = row })
        Corner(field, 5)
        Lib:_Glass(field, 0.7)
        local fieldStroke = Stroke(field, "Stroke", 1, 0.3)
        local valueLabel = New("TextLabel", { Text = "", TextSize = 13, Size = UDim2.new(1, -34, 1, 0), Position = UDim2.fromOffset(10, 0), TextXAlignment = LEFT,
                TextTruncate = Enum.TextTruncate.AtEnd, Parent = field })
        local chevron = Lib.Icon("chevron-down", 14, "Dim", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Parent = field }, "v")
        local function DisplayText()
                if info.Multi then
                        local picked = {}
                        for _, v in ipairs(obj.Values) do if obj.Value[v] then table.insert(picked, v) end end
                        if #picked == 0 then return info.Placeholder, true end
                        if #picked <= 2 then return table.concat(picked, ", "), false end
                        return #picked .. " selected", false
                end
                if obj.Value == nil then return info.Placeholder, true end
                return tostring(obj.Value), false
        end
        local panel = InlinePanel(row)
        local pf = panel.Frame
        local optH = H(26)
        local searchH = info.Searchable and 34 or 0
        local search
        if info.Searchable then
                local sb = New("Frame", { Size = UDim2.new(1, -12, 0, 24), Position = UDim2.fromOffset(6, 5), BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Field" }, Parent = pf })
                Corner(sb, 4)
                search = New("TextBox", { Text = "", PlaceholderText = "Search...", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 12, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(8, 0),
                        TextXAlignment = LEFT, Parent = sb })
        end
        local scroll = New("ScrollingFrame", { Size = UDim2.new(1, -8, 1, -(8 + searchH)), Position = UDim2.fromOffset(4, 4 + searchH), AutomaticCanvasSize = Y,
                ScrollBarThickness = 2, Parent = pf })
        List(scroll, 2)
        local buttons = {}
        local function IsSelected(v) if info.Multi then return obj.Value[v] == true end return obj.Value == v end
        local function PanelH()
                local count = 0
                for _, b in ipairs(buttons) do if b.Visible then count = count + 1 end end
                return math.min(math.max(count, 1), info.MaxVisible) * (optH + 2) + 8 + searchH
        end
        local function Style(open)
                Tween(fieldStroke, { Color = open and Lib.Theme.Accent or Lib.Theme.Stroke, Transparency = open and 0.1 or 0.3 }, 0.1)
                Tween(chevron, { Rotation = open and 180 or 0 }, 0.12)
        end
        local function Select(v)
                if info.Multi then
                        obj.Value[v] = (not obj.Value[v]) or nil
                        obj:_Refresh() obj:_Fire()
                else
                        if obj.Value == v and info.AllowNull then obj.Value = nil else obj.Value = v end
                        obj:_Refresh() obj:_Fire() obj:Close()
                end
        end
        local function BuildButtons()
                for _, b in ipairs(buttons) do b:Destroy() end
                buttons = {}
                for i, v in ipairs(obj.Values) do
                        local b = New("TextButton", { Name = tostring(v), Text = "", Size = UDim2.new(1, 0, 0, optH), BackgroundTransparency = 1, LayoutOrder = i,
                                Theme = { BackgroundColor3 = "Field" }, Parent = scroll })
                        Corner(b, 4)
                        New("TextLabel", { Name = "T", Text = tostring(v), TextSize = 13, Size = UDim2.new(1, -40, 1, 0), Position = UDim2.fromOffset(10, 0), TextXAlignment = LEFT,
                                TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = b })
                        if info.Multi then
                                local box = New("Frame", { Name = "Mark", Size = UDim2.fromOffset(13, 13), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -9, 0.5, 0),
                                        BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Field" }, Parent = b })
                                Corner(box, 3) Stroke(box, "Stroke", 1, 0.2)
                                New("TextLabel", { Name = "Tick", Text = "✓", Font = Enum.Font.GothamBold, TextSize = 10, Size = UDim2.fromScale(1, 1), TextTransparency = 1,
                                        Theme = { TextColor3 = "OnAccent" }, Parent = box })
                        else
                                local dot = New("Frame", { Name = "Mark", Size = UDim2.fromOffset(6, 6), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -11, 0.5, 0),
                                        BackgroundTransparency = 1, Theme = { BackgroundColor3 = "Accent" }, Parent = b })
                                Corner(dot, 3)
                        end
                        b.MouseEnter:Connect(function() if not IsSelected(v) then Tween(b, { BackgroundTransparency = 0.4 }, 0.06) end end)
                        b.MouseLeave:Connect(function() if not IsSelected(v) then Tween(b, { BackgroundTransparency = 1 }, 0.06) end end)
                        Press(b, function() Select(v) end)
                        table.insert(buttons, b)
                end
                obj:_Refresh()
        end
        if search then
                search:GetPropertyChangedSignal("Text"):Connect(function()
                        local q = search.Text:lower()
                        for _, b in ipairs(buttons) do b.Visible = q == "" or b.Name:lower():find(q, 1, true) ~= nil end
                        panel:Resize(PanelH())
                end)
        end
        function obj:_Refresh()
                local t, empty = DisplayText()
                valueLabel.Text = t
                valueLabel.TextColor3 = empty and Lib.Theme.Dim or Lib.Theme.Text
                for i, b in ipairs(buttons) do
                        local v = obj.Values[i]
                        local sel = IsSelected(v)
                        b.BackgroundTransparency = sel and 0.5 or 1
                        local tl = b:FindFirstChild("T")
                        if tl then tl.TextColor3 = sel and Lib.Theme.Text or Lib.Theme.SubText end
                        local m = b:FindFirstChild("Mark")
                        if m then
                                if info.Multi then
                                        m.BackgroundColor3 = sel and Lib.Theme.Accent or Lib.Theme.Field
                                        local tk = m:FindFirstChild("Tick")
                                        if tk then tk.TextTransparency = sel and 0 or 1 end
                                else
                                        m.BackgroundTransparency = sel and 0 or 1
                                end
                        end
                end
        end
        function obj:Open()
                if info.Disabled or panel.Open then return end
                BuildButtons()
                if search then search.Text = "" end
                panel:Set(true, PanelH())
                Style(true)
        end
        function obj:Close()
                if not panel.Open then return end
                panel:Set(false)
                Style(false)
        end
        function obj:SetValue(v, silent)
                if info.Multi then
                        local t = {}
                        if type(v) == "table" then
                                for k, val in pairs(v) do if type(k) == "number" then t[val] = true elseif val then t[k] = true end end
                        end
                        self.Value = t
                else
                        self.Value = v
                end
                self:_Refresh()
                if silent then if idx then Lib.Flags[idx] = self.Value end else self:_Fire() end
        end
        function obj:SetValues(values)
                self.Values = values
                if info.Multi then
                        for k in pairs(self.Value) do if not IndexOf(values, k) then self.Value[k] = nil end end
                elseif self.Value ~= nil and not IndexOf(values, self.Value) then
                        self.Value = (not info.AllowNull) and values[1] or nil
                end
                self:_Refresh()
                if panel.Open then BuildButtons() panel:Resize(PanelH()) end
        end
        function obj:GetActive()
                local out = {}
                if info.Multi then for _, v in ipairs(self.Values) do if self.Value[v] then table.insert(out, v) end end end
                return out
        end
        function obj:SetDisabled(s) info.Disabled = s valueLabel.TextTransparency = s and 0.6 or 0 end
        field.Activated:Connect(function() if panel.Open then obj:Close() else obj:Open() end end)
        field.MouseEnter:Connect(function() if not panel.Open then Tween(field, { BackgroundColor3 = Lib.Theme.FieldHover }, 0.08) end end)
        field.MouseLeave:Connect(function() Tween(field, { BackgroundColor3 = Lib.Theme.Field }, 0.1) end)
        if info.SpecialType == "Player" then
                local function Update() obj:SetValues(PlayerValues()) end
                Lib:Connect(Players.PlayerAdded, Update)
                Lib:Connect(Players.PlayerRemoving, function() task.defer(Update) end)
        end
        obj:_Refresh()
        Lib:AddTooltip(row, info.Tooltip)
        return obj
end

function Elements:AddSegmented(idx, info)
        info = Merge({ Text = idx or "Segmented", Values = {}, Default = 1, Disabled = false }, info)
        local hasText = info.Text ~= ""
        local fh = H(26)
        local row = self:_Row(hasText and (fh + 20) or fh)
        local obj = NewObject("Segmented", idx, info, row, self, info.Text)
        obj.Values = info.Values
        obj.Value = type(info.Default) == "number" and obj.Values[info.Default] or info.Default or obj.Values[1]
        obj._def = obj.Value
        if idx then Lib.Flags[idx] = obj.Value end
        local y = 0
        if hasText then
                New("TextLabel", { Text = info.Text, TextSize = 13, Size = UDim2.new(1, 0, 0, 16), TextXAlignment = LEFT, Theme = { TextColor3 = "SubText" }, Parent = row })
                y = 20
        end
        local bar = New("Frame", { Size = UDim2.new(1, 0, 0, fh), Position = UDim2.fromOffset(0, y), BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Field" }, Parent = row })
        Corner(bar, 5) Stroke(bar, "Stroke", 1, 0.3)
        Lib:_Glass(bar, 0.7)
        local n = math.max(#obj.Values, 1)
        local sel = New("Frame", { Size = UDim2.new(1 / n, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2), BackgroundTransparency = 0.8, Theme = { BackgroundColor3 = "Accent" }, Parent = bar })
        Corner(sel, 4)
        local buttons = {}
        local function Render()
                local i = IndexOf(obj.Values, obj.Value) or 1
                Tween(sel, { Position = UDim2.new((i - 1) / n, 2, 0, 2) }, 0.14, Enum.EasingStyle.Quint)
                for j, b in ipairs(buttons) do Tween(b, { TextColor3 = (j == i) and Lib.Theme.Text or Lib.Theme.SubText }, 0.12) end
        end
        for i, v in ipairs(obj.Values) do
                local b = New("TextButton", { Text = tostring(v), TextSize = 12, Size = UDim2.new(1 / n, 0, 1, 0), Position = UDim2.new((i - 1) / n, 0, 0, 0), ZIndex = 2,
                        TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = bar })
                Pad(b, 4, 0, 4, 0)
                b.Activated:Connect(function() if not info.Disabled then obj:SetValue(v) end end)
                buttons[i] = b
        end
        function obj:SetValue(v, silent)
                if not IndexOf(self.Values, v) or self.Value == v then return end
                self.Value = v
                Render()
                if silent then if idx then Lib.Flags[idx] = v end else self:_Fire() end
        end
        function obj:SetDisabled(s) info.Disabled = s end
        task.defer(Render)
        Lib:AddTooltip(row, info.Tooltip)
        return obj
end

function Elements:AddStat(idx, info)
        info = Merge({ Text = idx or "Stat", Default = "-" }, info)
        local row = self:_Row(H(20))
        local obj = NewObject("Stat", idx, info, row, self, info.Text)
        obj.Value = info.Default
        New("TextLabel", { Text = info.Text, TextSize = 13, Size = UDim2.new(0.42, 0, 1, 0), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = row })
        local v = New("TextLabel", { Text = tostring(obj.Value), TextSize = 13, Size = UDim2.new(0.58, 0, 1, 0), Position = UDim2.fromScale(0.42, 0), TextXAlignment = RIGHT,
                TextTruncate = Enum.TextTruncate.AtEnd, Parent = row })
        function obj:SetValue(val, color) self.Value = val v.Text = tostring(val) v.TextColor3 = color or Lib.Theme.Text end
        return obj
end

function Elements:AddProgress(idx, info)
        info = Merge({ Text = idx or "Progress", Min = 0, Max = 100, Default = 0, Suffix = "%", Rounding = 0 }, info)
        local row = self:_Row(H(30))
        local obj = NewObject("Progress", idx, info, row, self, info.Text)
        obj.Value = Clamp(info.Default, info.Min, info.Max)
        New("TextLabel", { Text = info.Text, TextSize = 13, Size = UDim2.new(1, -60, 0, 16), TextXAlignment = LEFT, Theme = { TextColor3 = "SubText" }, Parent = row })
        local vl = New("TextLabel", { Text = "", TextSize = 12, Size = UDim2.fromOffset(60, 16), AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), TextXAlignment = RIGHT, Parent = row })
        local back = New("Frame", { Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 1, -6), Theme = { BackgroundColor3 = "Field" }, Parent = row })
        Corner(back, 2)
        local fill = New("Frame", { Size = UDim2.fromScale(0, 1), Theme = { BackgroundColor3 = "Accent" }, Parent = back })
        Corner(fill, 2)
        local function Render()
                Tween(fill, { Size = UDim2.fromScale(Clamp(Map(obj.Value, info.Min, info.Max, 0, 1), 0, 1), 1) }, 0.2)
                vl.Text = (info.Rounding > 0 and string.format("%." .. info.Rounding .. "f", obj.Value) or tostring(math.floor(obj.Value + 0.5))) .. info.Suffix
        end
        function obj:SetValue(v) self.Value = Clamp(tonumber(v) or self.Value, info.Min, info.Max) Render() end
        Render()
        return obj
end

function Elements:AddLog(idx, info)
        info = Merge({ Text = "", Height = 110, MaxLines = 100 }, info)
        local row = self:_Row(info.Height)
        local obj = NewObject("Log", idx, info, row, self, info.Text ~= "" and info.Text or nil)
        local scroll = New("ScrollingFrame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0, AutomaticCanvasSize = Y, Theme = { BackgroundColor3 = "Field" }, Parent = row })
        Corner(scroll, 5) Stroke(scroll, "Stroke", 1, 0.3) List(scroll, 1) Pad(scroll, 8, 6, 8, 6)
        Lib:_Glass(scroll, 0.7)
        local count = 0
        local colors = { info = "SubText", good = "Good", warn = "Warn", bad = "Bad" }
        function obj:Log(text, kind)
                count = count + 1
                local l = New("TextLabel", { Text = os.date("%H:%M:%S") .. " " .. tostring(text), TextSize = 11, Size = UDim2.new(1, 0, 0, 13),
                        TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = count, Theme = { TextColor3 = colors[kind or "info"] or "SubText" }, Parent = scroll })
                Wrap(l, nil, nil, 13)
                local kids = {}
                for _, c in ipairs(scroll:GetChildren()) do if c:IsA("TextLabel") then table.insert(kids, c) end end
                if #kids > info.MaxLines then table.sort(kids, function(a, b) return a.LayoutOrder < b.LayoutOrder end) kids[1]:Destroy() end
                task.defer(function() scroll.CanvasPosition = Vector2.new(0, 1e6) end)
        end
        function obj:Clear() for _, c in ipairs(scroll:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end end
        return obj
end

-- Interactive 3D copy of your character (used in the Profile tab)
function Elements:AddAvatar3D(height)
        local S = height or 160
        local row = self:_Row(S)
        Static(self, row)
        local sub = self.Groupbox.Sub
        local holder = New("Frame", { Name = "Avatar3D", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0, ClipsDescendants = true, Theme = { BackgroundColor3 = "Surface" }, Parent = row })
        Corner(holder, 8) Stroke(holder, "Stroke", 1, 0.3)
        local vp = New("ViewportFrame", { Size = UDim2.fromOffset(S, S), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1,
                Ambient = Color3.fromRGB(165, 165, 178), LightColor = Color3.fromRGB(255, 244, 230), LightDirection = Vector3.new(-0.4, -0.6, -0.7), Parent = holder })
        local cam = Instance.new("Camera")
        cam.FieldOfView = 30
        cam.Parent = vp
        vp.CurrentCamera = cam
        local msg = New("TextLabel", { Text = "Loading avatar...", TextSize = 11, Size = UDim2.fromScale(1, 1), Theme = { TextColor3 = "Dim" }, Parent = holder })
        local hint = New("TextLabel", { Text = "drag to rotate", TextSize = 10, AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -5), Size = UDim2.new(1, 0, 0, 12), ZIndex = 4,
                Theme = { TextColor3 = "Dim" }, Parent = holder })
        task.delay(4, function() if hint.Parent then Tween(hint, { TextTransparency = 1 }, 0.6) end end)
        local st = { model = nil, angle = 0.35, base = 0, vel = 0, dist = 10, drag = false, idle = 0 }
        local function Build()
                if st.model then st.model:Destroy() st.model = nil end
                local char = LocalPlayer.Character
                if not (char and char:FindFirstChild("HumanoidRootPart")) then msg.Text = "Loading avatar..." msg.Visible = true return end
                local clone = CloneChar(char)
                if not clone then msg.Text = "Preview unavailable" msg.Visible = true return end
                for _, d in ipairs(clone:GetDescendants()) do
                        if d:IsA("BaseScript") or d:IsA("Sound") or d:IsA("Highlight") or d:IsA("BillboardGui") or d:IsA("SurfaceGui") or d:IsA("ForceField")
                                or d:IsA("ParticleEmitter") or d:IsA("Fire") or d:IsA("Smoke") or d:IsA("Sparkles") or d:IsA("Beam") or d:IsA("Trail") then
                                d:Destroy()
                        elseif d:IsA("BasePart") then
                                d.Anchored, d.CanCollide, d.Massless = true, false, true
                        end
                end
                local hum = clone:FindFirstChildOfClass("Humanoid")
                if hum then
                        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                end
                clone.Parent = vp
                local cf, size = clone:GetBoundingBox()
                local croot = clone:FindFirstChild("HumanoidRootPart")
                local look = croot and croot.CFrame.LookVector or Vector3.new(0, 0, -1)
                st.base = math.atan2(look.X, look.Z)
                clone:PivotTo(CFrame.new(-cf.Position) * clone:GetPivot())
                st.dist = ((size.Y / 0.8) / 2) / math.tan(math.rad(cam.FieldOfView) / 2) + size.Z / 2
                st.model = clone
                msg.Visible = false
        end
        Build()
        Lib:Connect(LocalPlayer.CharacterAdded, function() task.wait(1.5) if holder.Parent then Build() end end)
        task.delay(2, function() if holder.Parent and not st.model then Build() end end)
        local hit = New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), ZIndex = 5, Parent = holder })
        hit.InputBegan:Connect(function(input)
                if not IsPress(input) then return end
                local isTouch = input.UserInputType == Enum.UserInputType.Touch
                LockScroll(hit, true)
                st.drag = true
                if hint.TextTransparency < 1 then Tween(hint, { TextTransparency = 1 }, 0.3) end
                local last, lastT = Pointer(input).X, os.clock()
                local mc, ec
                mc = UIS.InputChanged:Connect(function(i)
                        if isTouch then if i ~= input then return end elseif i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
                        local x, t = Pointer(i).X, os.clock()
                        local d = (x - last) / math.max(Lib.Scale, 0.01) * 0.014
                        st.angle = st.angle - d
                        st.vel = Lerp(st.vel, Clamp(-d / math.max(t - lastT, 1 / 240), -10, 10), 0.4)
                        last, lastT = x, t
                end)
                ec = UIS.InputEnded:Connect(function(i)
                        local fin = isTouch and (i == input) or (not isTouch and i.UserInputType == Enum.UserInputType.MouseButton1)
                        if not fin then return end
                        mc:Disconnect() ec:Disconnect()
                        LockScroll(hit, false)
                        st.drag = false
                        if os.clock() - lastT > 0.08 then st.vel = 0 end
                        st.idle = os.clock() + 2
                end)
        end)
        Lib:Connect(RunService.RenderStepped, function(dt)
                if not holder.Parent or not st.model then return end
                local w = Lib.MainWindow
                if not (Lib.Visible and sub.Frame.Visible and sub.Tab.Scroll.Visible and not (w and w.Minimized)) then return end
                if not st.drag then
                        st.angle = st.angle + st.vel * dt
                        st.vel = st.vel * math.exp(-dt * 3.5)
                        if os.clock() > st.idle then st.angle = st.angle + 0.55 * dt end
                end
                local a = st.angle + st.base
                cam.CFrame = CFrame.lookAt(Vector3.new(math.sin(a), 0.06, math.cos(a)) * st.dist, Vector3.zero)
        end)
        return row
end

local function DragArea(frame, fn, guard)
        frame.Active = true
        frame.InputBegan:Connect(function(input)
                if not IsPress(input) then return end
                if guard and not guard() then return end
                local isTouch = input.UserInputType == Enum.UserInputType.Touch
                LockScroll(frame, true)
                local function Update(pos)
                        local p, s = frame.AbsolutePosition, frame.AbsoluteSize
                        fn(Clamp((pos.X - p.X) / math.max(s.X, 1), 0, 1), Clamp((pos.Y - p.Y) / math.max(s.Y, 1), 0, 1))
                end
                Update(Pointer(input))
                local mc, ec
                mc = UIS.InputChanged:Connect(function(i)
                        if isTouch then if i == input then Update(Pointer(i)) end
                        elseif i.UserInputType == Enum.UserInputType.MouseMovement then Update(Pointer(i)) end
                end)
                ec = UIS.InputEnded:Connect(function(i)
                        local fin = isTouch and (i == input) or (not isTouch and i.UserInputType == Enum.UserInputType.MouseButton1)
                        if fin then mc:Disconnect() ec:Disconnect() LockScroll(frame, false) end
                end)
        end)
end

local Rainbow = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromHSV(0.00, 1, 1)), ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
        ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)), ColorSequenceKeypoint.new(0.50, Color3.fromHSV(0.50, 1, 1)),
        ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)), ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
        ColorSequenceKeypoint.new(1.00, Color3.fromHSV(1.00, 1, 1)),
})

-- Color picker: the swatch sits on the row; the picker itself opens inline in its own space under the row.
function Lib:_CreateColorPicker(owner, idx, info)
        info = Merge({ Default = Color3.new(1, 1, 1), Transparency = nil, Rainbow = true }, info)
        local holder = AddonHolder(owner)
        local picker = NewObject("ColorPicker", idx, info, owner.Row)
        picker.Hue, picker.Sat, picker.Vib = info.Default:ToHSV()
        picker.Value, picker.Transparency, picker.RainbowOn = info.Default, info.Transparency, false
        picker._def = info.Default
        if idx then Lib.Flags[idx] = picker.Value end
        local swatch = New("TextButton", { Text = "", Size = UDim2.fromOffset(Lib.Touch and 30 or 24, Lib.Touch and 18 or 14), BackgroundTransparency = 0, BackgroundColor3 = picker.Value,
                LayoutOrder = #holder:GetChildren(), Parent = holder })
        Corner(swatch, 3)
        local swStroke = Stroke(swatch, "Stroke", 1)
        local hasAlpha = info.Transparency ~= nil
        local svH = 110
        local height = 8 + svH + 8 + 12 + 8 + (hasAlpha and 20 or 0) + 24 + 10
        local panel = InlinePanel(owner.Row)
        local popup = panel.Frame
        local function Hit(parent) return New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), ZIndex = 5, Parent = parent }) end
        local sv = New("Frame", { Size = UDim2.new(1, -16, 0, svH), Position = UDim2.fromOffset(8, 8), BackgroundTransparency = 0, BackgroundColor3 = Color3.fromHSV(picker.Hue, 1, 1), Parent = popup })
        Corner(sv, 4)
        local white = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0, BackgroundColor3 = WHITE, ZIndex = 2, Parent = sv })
        Corner(white, 4)
        New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }), Parent = white })
        local black = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 3, Parent = sv })
        Corner(black, 4)
        New("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }), Parent = black })
        local svMarker = New("Frame", { Size = UDim2.fromOffset(10, 10), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 4, Parent = sv })
        Corner(svMarker, 5) Stroke(svMarker, "Text", 2)
        local svHit = Hit(sv)
        local hueBar = New("Frame", { Size = UDim2.new(1, -16, 0, 12), Position = UDim2.fromOffset(8, 8 + svH + 8), BackgroundTransparency = 0, BackgroundColor3 = WHITE, Parent = popup })
        Corner(hueBar, 3)
        New("UIGradient", { Color = Rainbow, Parent = hueBar })
        local hueMarker = New("Frame", { Size = UDim2.fromOffset(4, 16), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), BackgroundTransparency = 0, BackgroundColor3 = WHITE, ZIndex = 4, Parent = hueBar })
        Corner(hueMarker, 2) Stroke(hueMarker, "Bg", 1)
        local hueHit = Hit(hueBar)
        local nextY = 8 + svH + 8 + 12 + 8
        local alphaBar, alphaMarker, alphaHit
        if hasAlpha then
                alphaBar = New("Frame", { Size = UDim2.new(1, -16, 0, 12), Position = UDim2.fromOffset(8, nextY), BackgroundTransparency = 0, BackgroundColor3 = picker.Value, Parent = popup })
                Corner(alphaBar, 3)
                New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }), Parent = alphaBar })
                alphaMarker = New("Frame", { Size = UDim2.fromOffset(4, 16), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), BackgroundTransparency = 0, BackgroundColor3 = WHITE, ZIndex = 4, Parent = alphaBar })
                Corner(alphaMarker, 2) Stroke(alphaMarker, "Bg", 1)
                alphaHit = Hit(alphaBar)
                nextY = nextY + 20
        end
        local hexBox = New("TextBox", { Text = "", PlaceholderText = "HEX", TextSize = 12, Size = UDim2.new(1, -(16 + (info.Rainbow and 74 or 0)), 0, 24), Position = UDim2.fromOffset(8, nextY),
                BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Field" }, Parent = popup })
        Corner(hexBox, 4) Stroke(hexBox, "Stroke", 1, 0.3)
        local rbBtn = New("TextButton", { Text = "Rainbow", TextSize = 11, Size = UDim2.fromOffset(66, 24), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, nextY), BackgroundTransparency = 0,
                Visible = info.Rainbow, Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = popup })
        Corner(rbBtn, 4)
        local rbStroke = Stroke(rbBtn, "Stroke", 1, 0.3)
        local function Display()
                picker.Value = Color3.fromHSV(picker.Hue, picker.Sat, picker.Vib)
                swatch.BackgroundColor3 = picker.Value
                sv.BackgroundColor3 = Color3.fromHSV(picker.Hue, 1, 1)
                svMarker.Position = UDim2.fromScale(picker.Sat, 1 - picker.Vib)
                hueMarker.Position = UDim2.fromScale(picker.Hue, 0.5)
                if hexBox ~= UIS:GetFocusedTextBox() then hexBox.Text = "#" .. ToHex(picker.Value) end
                if alphaBar then alphaBar.BackgroundColor3 = picker.Value alphaMarker.Position = UDim2.fromScale(picker.Transparency, 0.5) end
                rbStroke.Color = picker.RainbowOn and Lib.Theme.Accent or Lib.Theme.Stroke
        end
        picker._Display = Display
        function picker:SetValue(color, transparency, silent)
                if typeof(color) ~= "Color3" then return end
                local h, s, v = color:ToHSV()
                if transparency ~= nil and hasAlpha then self.Transparency = transparency end
                self.Hue, self.Sat, self.Vib = h, s, v
                Display()
                if silent then if idx then Lib.Flags[idx] = self.Value end else self:_Fire(self.Transparency) end
        end
        function picker:SetRainbow(s)
                self.RainbowOn = s and true or false
                Lib.Rainbows[self] = self.RainbowOn or nil
                Display()
        end
        DragArea(svHit, function(x, y) picker.Sat, picker.Vib = x, 1 - y Display() picker:_Fire(picker.Transparency) end)
        DragArea(hueHit, function(x) picker.Hue = x if picker.RainbowOn then picker:SetRainbow(false) end Display() picker:_Fire(picker.Transparency) end)
        if alphaHit then DragArea(alphaHit, function(x) picker.Transparency = x Display() picker:_Fire(picker.Transparency) end) end
        hexBox.FocusLost:Connect(function() local c = FromHex(hexBox.Text) if c then picker:SetValue(c) else Display() end end)
        rbBtn.Activated:Connect(function() picker:SetRainbow(not picker.RainbowOn) end)
        function picker:Close()
                if not panel.Open then return end
                panel:Set(false)
                swStroke.Color = Lib.Theme.Stroke
        end
        function picker:Open()
                if panel.Open then return end
                panel:Set(true, height)
                swStroke.Color = Lib.Theme.Accent
        end
        swatch.Activated:Connect(function() if panel.Open then picker:Close() else picker:Open() end end)
        Display()
        return picker
end

local KeyModes = { "Always", "Toggle", "Hold" }

function Lib:_CreateKeyPicker(owner, idx, info)
        info = Merge({ Default = "None", Mode = "Toggle", SyncToggleState = false, Callback = nil, ChangedCallback = nil }, info)
        local holder = AddonHolder(owner)
        local picker = NewObject("KeyPicker", idx, info, owner.Row)
        picker.Key, picker.Mode = ResolveKey(info.Default), info.Mode
        picker.State = (picker.Mode == "Always")
        picker.Title = (owner.Info and owner.Info.Text) or owner.Text or idx or "Keybind"
        picker.Value = { Key = KeyName(picker.Key), Mode = picker.Mode }
        if idx then Lib.Flags[idx] = picker.Value end
        local button = New("TextButton", { Text = "", TextSize = 11, AutomaticSize = X, Size = UDim2.fromOffset(0, H(18)), BackgroundTransparency = 0, LayoutOrder = 100,
                Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = holder })
        Corner(button, 3) Pad(button, 6, 0, 6, 0)
        local binding, bindConn = false, nil
        local function Sync()
                picker.Value = { Key = KeyName(picker.Key), Mode = picker.Mode }
                if idx then Lib.Flags[idx] = picker.Value end
                button.Text = binding and "..." or KeyName(picker.Key)
                button.TextColor3 = binding and Lib.Theme.Accent or Lib.Theme.SubText
        end
        function picker:GetState() if self.Mode == "Always" then return true end return self.State end
        function picker:SetState(state, silent)
                self.State = state and true or false
                if info.SyncToggleState and owner.Type == "Toggle" then owner:SetValue(self.State) end
                if not silent then Safe(info.Callback, self.State) self.Changed:Fire(self.State) end
        end
        function picker:SetValue(data, silent)
                if type(data) == "table" then
                        self.Key = ResolveKey(data.Key or data[1])
                        self.Mode = data.Mode or data[2] or self.Mode
                else
                        self.Key = ResolveKey(data)
                end
                if self.Mode == "Always" then self.State = true elseif self.Mode == "Hold" then self.State = false end
                Sync()
                if not silent then Safe(info.ChangedCallback, self.Key) end
        end
        function picker:SetMode(mode)
                if not IndexOf(KeyModes, mode) then return end
                self.Mode = mode
                self.State = (mode == "Always")
                Sync()
                Safe(info.ChangedCallback, self.Key)
        end
        local menu = Sink(New("Frame", { Visible = false, Size = UDim2.fromOffset(86, #KeyModes * H(26) + 6), BackgroundTransparency = 0, ZIndex = 80, Theme = { BackgroundColor3 = "Surface" }, Parent = Lib.Overlay }))
        Corner(menu, 6) Stroke(menu, "Stroke", 1, 0) List(menu, 0) Pad(menu, 3, 3, 3, 3)
        New("UIScale", { Scale = Lib.Scale, Parent = menu })
        local mbtn = {}
        for i, mode in ipairs(KeyModes) do
                local b = New("TextButton", { Text = mode, TextSize = 12, Size = UDim2.new(1, 0, 0, H(26)), LayoutOrder = i, ZIndex = 81, Theme = { TextColor3 = "SubText" }, Parent = menu })
                Press(b, function() picker:SetMode(mode) Lib:ClosePopup() end)
                mbtn[mode] = b
        end
        local function OpenMenu()
                for mode, b in pairs(mbtn) do b.TextColor3 = (picker.Mode == mode) and Lib.Theme.Accent or Lib.Theme.SubText end
                local pos = PlaceBelow(button, 86 * Lib.Scale, (#KeyModes * H(26) + 6) * Lib.Scale, 4, true, WinBounds())
                menu.Position = UDim2.fromOffset(pos.X, pos.Y)
                menu.UIScale.Scale = Lib.Scale
                menu.Visible = true
                Lib:OpenPopup(menu, function() menu.Visible = false end, button)
        end
        button.MouseButton2Click:Connect(OpenMenu)
        button.InputBegan:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.Touch then return end
                local held, c = true, nil
                c = UIS.InputEnded:Connect(function(i) if i == input then held = false c:Disconnect() end end)
                task.delay(0.45, function() if held then held = false OpenMenu() end end)
        end)
        button.Activated:Connect(function()
                if binding then binding = false if bindConn then bindConn:Disconnect() bindConn = nil end Sync() return end
                binding = true
                Sync()
                task.wait(0.1)
                bindConn = UIS.InputBegan:Connect(function(input)
                        local key
                        if input.UserInputType == Enum.UserInputType.Keyboard then key = input.KeyCode
                        elseif input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then key = input.UserInputType
                        else return end
                        if bindConn then bindConn:Disconnect() bindConn = nil end
                        binding = false
                        if key == Enum.KeyCode.Escape or key == Enum.KeyCode.Backspace then key = nil end
                        picker.Key = key
                        Sync()
                        Safe(info.ChangedCallback, key)
                end)
        end)
        table.insert(Lib.Keybinds, picker)
        Sync()
        return picker
end

local function KeyMatches(p, input)
        if not p.Key then return false end
        if typeof(p.Key) == "EnumItem" and p.Key.EnumType == Enum.UserInputType then return input.UserInputType == p.Key end
        return input.KeyCode == p.Key
end

Lib:Connect(UIS.InputBegan, function(input)
        if UIS:GetFocusedTextBox() then return end
        for _, kb in ipairs(Lib.Keybinds) do
                if KeyMatches(kb, input) then
                        if kb.Mode == "Toggle" then kb:SetState(not kb.State) elseif kb.Mode == "Hold" then kb:SetState(true) end
                end
        end
end)

Lib:Connect(UIS.InputEnded, function(input)
        for _, kb in ipairs(Lib.Keybinds) do if kb.Mode == "Hold" and KeyMatches(kb, input) then kb:SetState(false) end end
end)

function Elements:AddColorPicker(idx, info) info = info or {} return self:AddLabel(info.Text or idx or "Color"):AddColorPicker(idx, info) end
function Elements:AddKeyPicker(idx, info) info = info or {} return self:AddLabel(info.Text or idx or "Keybind"):AddKeyPicker(idx, info) end

function Lib:CreateWatermark(cfg)
        cfg = Merge({ Title = nil, Position = UDim2.new(0.5, 0, 0, 8), ShowGame = true, ShowFPS = true, ShowPing = true }, cfg)
        local frame = New("Frame", { Name = "Watermark", AnchorPoint = Vector2.new(0.5, 0), Position = cfg.Position, Size = UDim2.fromOffset(0, 26), AutomaticSize = X, Theme = { BackgroundColor3 = "Bg" }, Parent = self.Gui })
        Corner(frame, 5) Stroke(frame) Pad(frame, 12, 0, 12, 0)
        New("Frame", { Size = UDim2.fromOffset(2, 12), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, -7, 0.5, 0), Theme = { BackgroundColor3 = "Accent" }, Parent = frame })
        local label = New("TextLabel", { RichText = true, Text = "", TextSize = 12, AutomaticSize = X, Size = UDim2.fromOffset(0, 26), Parent = frame })
        local gameName = ""
        if cfg.ShowGame then
                task.spawn(function()
                        local ok, r = pcall(function() return Market:GetProductInfo(game.PlaceId).Name end)
                        gameName = ok and r or ""
                end)
        end
        local wm = { Frame = frame, Enabled = true }
        local acc = 0
        Lib:Connect(RunService.RenderStepped, function(dt)
                acc = acc + dt
                if acc < 0.25 or not wm.Enabled then return end
                acc = 0
                local parts = { "<b>" .. (cfg.Title or Lib.Name) .. "</b>" }
                if cfg.ShowGame and gameName ~= "" then table.insert(parts, (gameName:gsub("[<>&]", ""))) end
                if cfg.ShowFPS then table.insert(parts, Lib.FPS .. " fps") end
                if cfg.ShowPing then table.insert(parts, Lib:GetPing() .. " ms") end
                label.Text = table.concat(parts, " <font color='#5C5F6B'>|</font> ")
        end)
        self:MakeDraggable(frame, frame)
        function wm:SetVisible(s) self.Enabled = s and true or false frame.Visible = self.Enabled end
        Lib.Watermark = wm
        return wm
end

function Lib:CreateKeybindList(cfg)
        cfg = Merge({ Position = UDim2.new(0, 10, 0.64, 0) }, cfg)
        local frame = New("Frame", { Name = "KeybindList", Position = cfg.Position, Size = UDim2.fromOffset(160, 0), AutomaticSize = Y, Visible = false,
                Theme = { BackgroundColor3 = "Bg" }, Parent = self.Gui })
        Corner(frame, 5) Stroke(frame) Pad(frame, 10, 6, 10, 8) List(frame, 2)
        New("TextLabel", { Text = "Keybinds", Font = Lib.FontBold, TextSize = 12, Size = UDim2.new(1, 0, 0, 16), TextXAlignment = LEFT, LayoutOrder = 0, Parent = frame })
        local lines = {}
        local kl = { Frame = frame, Enabled = true }
        local acc = 0
        Lib:Connect(RunService.RenderStepped, function(dt)
                acc = acc + dt
                if acc < 0.12 then return end
                acc = 0
                local n = 0
                local on, off = ToHex(Lib.Theme.Accent), ToHex(Lib.Theme.Dim)
                for _, kb in ipairs(Lib.Keybinds) do
                        if kb.Key and kb.Mode ~= "Always" then
                                n = n + 1
                                local l = lines[n]
                                if not l then
                                        l = New("TextLabel", { RichText = true, Text = "", TextSize = 12, Size = UDim2.new(1, 0, 0, 14), TextXAlignment = LEFT, LayoutOrder = n, Parent = frame })
                                        lines[n] = l
                                end
                                l.Visible = true
                                local title = (tostring(kb.Title):gsub("[<>&]", ""))
                                local active = kb:GetState()
                                l.Text = "<font color='#" .. (active and on or off) .. "'>[" .. KeyName(kb.Key) .. "]</font> <font color='#" .. (active and ToHex(Lib.Theme.Text) or off) .. "'>" .. title .. "</font>"
                        end
                end
                for i = n + 1, #lines do lines[i].Visible = false end
                frame.Visible = kl.Enabled and n > 0
        end)
        self:MakeDraggable(frame, frame)
        function kl:SetVisible(s) self.Enabled = s and true or false if not self.Enabled then frame.Visible = false end end
        Lib.KeybindList = kl
        return kl
end

do
        local holder
        local function GetHolder()
                if holder and holder.Parent then return holder end
                holder = New("Frame", { Name = "Notifications", Size = UDim2.new(0, 280, 1, -20), Position = UDim2.new(1, -290, 0, 0), BackgroundTransparency = 1, Parent = Lib.Overlay })
                List(holder, 6, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)
                return holder
        end
        local Kinds = { info = "Accent", success = "Good", error = "Bad", warn = "Warn" }
        function Lib:Notify(a, b, c)
                local info = type(a) == "table" and a or { Text = a, Duration = b, Type = c }
                info = Merge({ Title = nil, Text = "", Duration = 4, Type = "info" }, info)
                if self.NotifyEnabled == false and info.Type ~= "error" then return end
                local key = Kinds[info.Type] or "Accent"
                local hold = GetHolder()
                local wrapper = New("Frame", { Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1, ClipsDescendants = true, Parent = hold })
                local card = New("Frame", { Size = UDim2.fromScale(1, 1), Position = UDim2.fromOffset(300, 0), Theme = { BackgroundColor3 = "Bg" }, Parent = wrapper })
                Corner(card, 6) Stroke(card)
                local content = New("Frame", { Size = UDim2.new(1, -30, 0, 0), Position = UDim2.fromOffset(16, 9), AutomaticSize = Y, BackgroundTransparency = 1, Parent = card })
                List(content, 2)
                if info.Title then New("TextLabel", { Text = info.Title, Font = Lib.FontBold, TextSize = 13, Size = UDim2.new(1, 0, 0, 14), TextXAlignment = LEFT, LayoutOrder = 1, Parent = content }) end
                local body = New("TextLabel", { Text = info.Text, TextSize = 12, Size = UDim2.new(1, 0, 0, 14), TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top,
                        Theme = { TextColor3 = info.Title and "SubText" or "Text" }, LayoutOrder = 2, Parent = content })
                Wrap(body)
                New("Frame", { Size = UDim2.new(0, 2, 1, -14), Position = UDim2.fromOffset(7, 7), Theme = { BackgroundColor3 = key }, Parent = card })
                local timer = New("Frame", { Size = UDim2.new(1, -16, 0, 1), AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 8, 1, -2), BackgroundTransparency = 0.5, Theme = { BackgroundColor3 = key }, Parent = card })
                local function Fit() wrapper.Size = UDim2.new(1, 0, 0, math.max(content.AbsoluteSize.Y + 22, 36)) end
                content:GetPropertyChangedSignal("AbsoluteSize"):Connect(Fit)
                task.defer(Fit)
                Tween(card, { Position = UDim2.new() }, 0.3, Enum.EasingStyle.Quint)
                Tween(timer, { Size = UDim2.new(0, 0, 0, 1) }, info.Duration, Enum.EasingStyle.Linear)
                task.delay(info.Duration, function()
                        if not card.Parent then return end
                        Tween(card, { Position = UDim2.fromOffset(300, 0) }, 0.24, Enum.EasingStyle.Quint)
                        task.wait(0.26)
                        wrapper:Destroy()
                end)
        end
        Lib.Toast = Lib.Notify
end

function Lib:Dialog(cfg)
        cfg = Merge({ Title = "Confirm", Text = "", Buttons = { { Text = "OK", Primary = true } } }, cfg)
        local dim = New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.5, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 100, Parent = self.Overlay })
        local card = Sink(New("Frame", { Size = UDim2.fromOffset(310, 0), AutomaticSize = Y, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 101,
                Theme = { BackgroundColor3 = "Bg" }, Parent = dim }))
        Corner(card, 8) Stroke(card) Pad(card, 16, 14, 16, 14) List(card, 8)
        New("UIScale", { Scale = math.min(1, Lib.Overlay.AbsoluteSize.X / 340), Parent = card })
        New("TextLabel", { Text = cfg.Title, Font = Lib.FontBold, TextSize = 15, Size = UDim2.new(1, 0, 0, 20), TextXAlignment = LEFT, LayoutOrder = 1, ZIndex = 102, Parent = card })
        local body = New("TextLabel", { Text = cfg.Text, TextSize = 13, Size = UDim2.new(1, 0, 0, 16), TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top,
                LayoutOrder = 2, ZIndex = 102, Theme = { TextColor3 = "SubText" }, Parent = card })
        Wrap(body, nil, nil, 16)
        local extra = cfg.Extra and cfg.Extra(card) or nil
        local bar = New("Frame", { Size = UDim2.new(1, 0, 0, H(28)), BackgroundTransparency = 1, LayoutOrder = 4, ZIndex = 102, Parent = card })
        List(bar, 6, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
        local d = {}
        function d:Close() if dim.Parent then dim:Destroy() end end
        for i, bt in ipairs(cfg.Buttons) do
                local b = New("TextButton", { Text = bt.Text, TextSize = 13, AutomaticSize = X, Size = UDim2.fromOffset(0, H(28)), BackgroundTransparency = 0, LayoutOrder = i, ZIndex = 103,
                        Theme = bt.Primary and { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" } or { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = bar })
                Corner(b, 5) Pad(b, 14, 0, 14, 0)
                b.Activated:Connect(function() d:Close() Safe(bt.Callback, extra and extra.Text or nil) end)
        end
        return d
end

function Lib:Prompt(cfg, cb)
        cfg = Merge({ Title = "Input", Text = "", Default = "", Placeholder = "", Confirm = "OK", Cancel = "Cancel" }, cfg)
        return self:Dialog({ Title = cfg.Title, Text = cfg.Text,
                Extra = function(card)
                        local f = New("Frame", { Size = UDim2.new(1, 0, 0, H(28)), LayoutOrder = 3, ZIndex = 102, Theme = { BackgroundColor3 = "Field" }, Parent = card })
                        Corner(f, 5) Stroke(f, "Stroke", 1, 0.3)
                        return New("TextBox", { Text = cfg.Default, PlaceholderText = cfg.Placeholder, PlaceholderColor3 = Lib.Theme.Dim, TextSize = 13, Size = UDim2.new(1, -20, 1, 0),
                                Position = UDim2.fromOffset(10, 0), TextXAlignment = LEFT, ZIndex = 103, Parent = f })
                end,
                Buttons = { { Text = cfg.Cancel }, { Text = cfg.Confirm, Primary = true, Callback = function(t) Safe(cb, t or "") end } } })
end

local ESP = {}
ESP.__index = ESP

local R15 = {
        { "Head", "UpperTorso" }, { "UpperTorso", "LowerTorso" },
        { "UpperTorso", "LeftUpperArm" }, { "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" },
        { "UpperTorso", "RightUpperArm" }, { "RightUpperArm", "RightLowerArm" }, { "RightLowerArm", "RightHand" },
        { "LowerTorso", "LeftUpperLeg" }, { "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" },
        { "LowerTorso", "RightUpperLeg" }, { "RightUpperLeg", "RightLowerLeg" }, { "RightLowerLeg", "RightFoot" },
}
local R6 = { { "Head", "Torso" }, { "Torso", "Left Arm" }, { "Torso", "Right Arm" }, { "Torso", "Left Leg" }, { "Torso", "Right Leg" } }
local FeetNames = { "LeftFoot", "RightFoot", "Left Leg", "Right Leg" }

local function SetLine(line, pa, pb, color, thick)
        local d = pb - pa
        line.Visible = true
        line.BackgroundColor3 = color
        line.Size = UDim2.fromOffset(math.max(d.Magnitude, 1), thick or 1)
        line.Position = UDim2.fromOffset((pa.X + pb.X) / 2, (pa.Y + pb.Y) / 2)
        line.Rotation = math.deg(math.atan2(d.Y, d.X))
end

local function Pill(parent, size, z, color)
        local l = New("TextLabel", { Text = "", TextSize = size, Font = Lib.FontBold, AutomaticSize = X, Size = UDim2.fromOffset(0, size + 5), BackgroundTransparency = 0.38,
                BackgroundColor3 = Color3.fromRGB(8, 8, 12), TextColor3 = color or WHITE, ZIndex = z, Parent = parent })
        Corner(l, 4) Pad(l, 5, 0, 5, 0)
        return l
end

local StateNames = { [Enum.HumanoidStateType.Jumping] = "Jumping", [Enum.HumanoidStateType.Freefall] = "Falling", [Enum.HumanoidStateType.Climbing] = "Climbing",
        [Enum.HumanoidStateType.Swimming] = "Swimming", [Enum.HumanoidStateType.Dead] = "Dead", [Enum.HumanoidStateType.Seated] = "Seated" }

local function InBody(self, p)
        return p.X == p.X and p.Y == p.Y and p.X > -10 and p.X < self.BW + 10 and p.Y > -10 and p.Y < self.BH + 10
end

-- ESP options that get mirrored into Lib.ESPOptions and pushed to Lib:HookESP callbacks.
local ESPOptionNames = { Box = true, BoxStyle = true, BoxColor = true, BoxFill = true, FillColor = true, FillTransparency = true,
        Name = true, NameColor = true, Health = true, Distance = true, Tool = true, Skeleton = true, SkeletonColor = true,
        Flags = true, Chams = true, ChamsColor = true, Tracer = true, TracerColor = true, HeadDot = true, HeadDotColor = true,
        Rotate = true, RotateSpeed = true }

-- Resolves an instance path like "LocalPlayer", "Players/friend", "workspace.Shop.Crate" or
-- "game.ReplicatedStorage.Assets". Accepts dots or slashes as separators.
local ServiceAliases = { workspace = "Workspace", players = "Players", lighting = "Lighting", replicatedstorage = "ReplicatedStorage",
        serverstorage = "ServerStorage", teams = "Teams", startergui = "StarterGui", coregui = "CoreGui" }
local function ResolvePath(path)
        if typeof(path) == "Instance" then return path end
        if type(path) ~= "string" then return nil end
        local s = Trim(path)
        if s == "" then return nil end
        local lower = s:lower()
        if lower == "localplayer" or lower == "local player" or lower == "me" or lower == "mycharacter" or lower == "my character" then return LocalPlayer end
        local segs
        if s:find("/", 1, true) then segs = s:split("/")
        elseif s:find("\\", 1, true) then segs = s:split("\\")
        else segs = s:split(".") end
        if segs[1] and segs[1]:lower() == "game" then table.remove(segs, 1) end
        if #segs == 0 then return nil end
        local cur
        for i, seg in ipairs(segs) do
                seg = Trim(seg):gsub("^%[", ""):gsub("%]$", "")
                if seg == "" then return nil end
                if i == 1 then
                        if seg:lower() == "localplayer" then
                                cur = LocalPlayer
                        else
                                local ok, svc = pcall(function() return game:GetService(ServiceAliases[seg:lower()] or seg) end)
                                if ok and svc then cur = svc else cur = game:FindFirstChild(seg) end
                        end
                elseif cur == LocalPlayer then
                        local segl = seg:lower()
                        if segl == "character" then cur = cur.Character -- "LocalPlayer.Character"
                        elseif segl == "backpack" then cur = cur.Backpack -- "LocalPlayer.Backpack"
                        else cur = cur:FindFirstChild(seg) end
                elseif cur and cur:IsA("Player") and seg:lower() == "character" then
                        cur = cur.Character -- "Players/friend/Character"
                else
                        cur = cur and cur:FindFirstChild(seg) or nil
                end
                if not cur then return nil end
        end
        return cur
end
Lib.ResolvePath = ResolvePath

function Lib:CreateESPPreview(cfg)
        if Lib.Preview and Lib.Preview.Alive then return Lib.Preview end
        cfg = Merge({ Title = "ESP Preview", Size = UDim2.fromOffset(280, 420), Box = true, BoxStyle = "Corner", BoxColor = WHITE, BoxFill = false, FillColor = Lib.Theme.Accent, FillTransparency = 0.82,
                Name = true, NameColor = WHITE, Health = true, Distance = true, Tool = true, Rotate = true, RotateSpeed = 1, FOV = 26, Skeleton = true,
                SkeletonColor = Color3.fromRGB(215, 215, 225), Flags = true, Chams = false, ChamsColor = Color3.fromRGB(203, 188, 255),
                Tracer = false, TracerColor = Lib.Theme.Accent, HeadDot = false, HeadDotColor = WHITE, Target = nil }, cfg)
        local barH = H(30)
        local self = setmetatable({ Config = cfg, Target = cfg.Target or Lib.PreviewTarget, Angle = math.pi, Vel = 0, Spin = 0, IdleAt = 0, Zoom = 1, Alive = true, Lines = {}, ChamParts = {}, Pairs = {}, Handles = {}, Corners = {},
                S = 240, BW = 264, BH = 300, Off = Vector2.zero, BarH = barH }, ESP)
        local panel, frame = Lib:_MakePanel("ESPPreview", cfg.Title, "scan-face", cfg.Size.X.Offset, cfg.Size.Y.Offset, "left", "ESP")
        self.PanelObj, self.Frame = panel, frame
        -- flat, theme-coloured background (no gradient) so the preview blends into the panel
        local body = New("Frame", { Size = UDim2.new(1, -16, 1, -(46 + barH + 18)), Position = UDim2.fromOffset(8, 46), BackgroundTransparency = 0, ClipsDescendants = true,
                Theme = { BackgroundColor3 = "Surface" }, Parent = frame })
        Corner(body, 8) Stroke(body, "Stroke", 1, 0.3)
        self.Body = body
        self.Viewport = New("ViewportFrame", { Size = UDim2.fromOffset(240, 240), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1,
                Ambient = Color3.fromRGB(165, 165, 178), LightColor = Color3.fromRGB(255, 244, 230), LightDirection = Vector3.new(-0.4, -0.6, -0.7), Parent = body })
        local cam = Instance.new("Camera")
        cam.FieldOfView = cfg.FOV
        cam.Parent = self.Viewport
        self.Viewport.CurrentCamera = cam
        self.Camera = cam
        local overlay = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 5, Parent = body })
        self.Overlay = overlay
        self.TracerLine = New("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 0, Visible = false, ZIndex = 4, Parent = overlay })
        New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.1) }), Parent = self.TracerLine })
        self.TracerDot = New("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(6, 6), Visible = false, ZIndex = 5, Parent = overlay })
        Corner(self.TracerDot, 3)
        self.HeadDotFrame = New("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(10, 10), BackgroundTransparency = 1, Visible = false, ZIndex = 6, Parent = overlay })
        Corner(self.HeadDotFrame, 20)
        self.HeadDotStroke = New("UIStroke", { Thickness = 1.5, Color = cfg.HeadDotColor, Parent = self.HeadDotFrame })
        local box = New("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(90, 170), BackgroundTransparency = 1, BackgroundColor3 = cfg.FillColor, ZIndex = 6, Parent = overlay })
        self.BoxFrame = box
        self.BoxStroke = New("UIStroke", { Thickness = 1.5, Color = cfg.BoxColor, Parent = box })
        self.Outline = New("Frame", { Size = UDim2.new(1, 4, 1, 4), Position = UDim2.fromOffset(-2, -2), BackgroundTransparency = 1, ZIndex = 5, Parent = box })
        New("UIStroke", { Thickness = 1, Color = Color3.new(0, 0, 0), Transparency = 0.2, Parent = self.Outline })
        for _, c in ipairs({ { 0, 0 }, { 1, 0 }, { 0, 1 }, { 1, 1 } }) do
                local ax, ay = c[1], c[2]
                table.insert(self.Corners, New("Frame", { AnchorPoint = Vector2.new(ax, ay), Position = UDim2.fromScale(ax, ay), Size = UDim2.fromOffset(14, 2), BackgroundColor3 = cfg.BoxColor, Visible = false, ZIndex = 7, Parent = box }))
                table.insert(self.Corners, New("Frame", { AnchorPoint = Vector2.new(ax, ay), Position = UDim2.fromScale(ax, ay), Size = UDim2.fromOffset(2, 14), BackgroundColor3 = cfg.BoxColor, Visible = false, ZIndex = 7, Parent = box }))
        end
        self.NameLabel = Pill(box, 12, 8, cfg.NameColor)
        self.NameLabel.AnchorPoint = Vector2.new(0.5, 1)
        self.NameLabel.Position = UDim2.new(0.5, 0, 0, -5)
        self.NameLabel.Text = LocalPlayer.DisplayName
        self.HealthBack = New("Frame", { Size = UDim2.new(0, 4, 1, 4), Position = UDim2.new(0, -9, 0, -2), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.25, ZIndex = 6, Parent = box })
        Corner(self.HealthBack, 2)
        self.HealthFill = New("Frame", { AnchorPoint = Vector2.new(0, 1), Size = UDim2.new(1, -2, 1, -2), Position = UDim2.new(0, 1, 1, -1), BackgroundColor3 = Lib.Theme.Good, ZIndex = 7, Parent = self.HealthBack })
        Corner(self.HealthFill, 1)
        self.HealthText = New("TextLabel", { Text = "100", TextSize = 10, Font = Lib.FontBold, Size = UDim2.fromOffset(26, 10), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(0, -12, 0, 0),
                TextXAlignment = RIGHT, TextStrokeTransparency = 0.3, ZIndex = 7, Parent = box })
        self.DistLabel = Pill(box, 11, 8, WHITE)
        self.DistLabel.AnchorPoint = Vector2.new(0.5, 0)
        self.DistLabel.Position = UDim2.new(0.5, 0, 1, 5)
        self.DistLabel.Text = "24m"
        self.ToolLabel = Pill(box, 11, 8, Lib.Theme.SubText)
        self.ToolLabel.AnchorPoint = Vector2.new(0.5, 0)
        self.ToolLabel.Position = UDim2.new(0.5, 0, 1, 25)
        self.ToolLabel.Text = "none"
        self.FlagsLabel = New("TextLabel", { Text = "", TextSize = 10, Font = Lib.FontBold, AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.fromOffset(0, 0), Position = UDim2.new(1, 7, 0, 0),
                TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top, BackgroundTransparency = 0.38, BackgroundColor3 = Color3.fromRGB(8, 8, 12), ZIndex = 8, Theme = { TextColor3 = "SubText" }, Parent = box })
        Corner(self.FlagsLabel, 4) Pad(self.FlagsLabel, 5, 2, 5, 2)
        local live = New("Frame", { Size = UDim2.fromOffset(0, 20), AutomaticSize = X, Position = UDim2.fromOffset(8, 8), ZIndex = 8, BackgroundTransparency = 0.25, Theme = { BackgroundColor3 = "Bg" }, Parent = body })
        Corner(live, 10) Pad(live, 8, 0, 10, 0)
        self.LiveDot = New("Frame", { Size = UDim2.fromOffset(6, 6), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), ZIndex = 9, Theme = { BackgroundColor3 = "Good" }, Parent = live })
        Corner(self.LiveDot, 3)
        self.ViewLabel = New("TextLabel", { Text = "Front", TextSize = 10, AutomaticSize = X, Size = UDim2.fromOffset(0, 20), ZIndex = 9, Parent = live })
        Pad(self.ViewLabel, 11, 0, 0, 0)
        self.ZoomLabel = New("TextLabel", { Text = "100%", TextSize = 10, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 11), Size = UDim2.fromOffset(50, 14), TextXAlignment = RIGHT,
                ZIndex = 8, Theme = { TextColor3 = "Dim" }, Parent = body })
        self.Hint = New("TextLabel", { Text = Lib.Touch and "drag to rotate · double tap resets" or "drag to rotate · scroll to zoom · double click resets", TextSize = 10, AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.new(0.5, 0, 1, -6), Size = UDim2.new(1, -16, 0, 12), ZIndex = 8, Theme = { TextColor3 = "Dim" }, Parent = body })
        task.delay(4, function() if self.Hint.Parent then Tween(self.Hint, { TextTransparency = 1 }, 0.6) end end)

        -- control bar: [ Front | Side | Back ]  [auto-rotate] [reset view]
        local bar = New("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 8, 1, -8), Size = UDim2.new(1, -16, 0, barH), BackgroundTransparency = 1, Parent = frame })
        local seg = New("Frame", { Size = UDim2.new(1, -(barH * 2 + 12), 1, 0), BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Field" }, Parent = bar })
        Corner(seg, 6) Stroke(seg, "Stroke", 1, 0.4)
        self.SegSel = New("Frame", { Size = UDim2.new(1 / 3, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2), BackgroundTransparency = 0, Theme = { BackgroundColor3 = "FieldHover" }, Parent = seg })
        Corner(self.SegSel, 5) Stroke(self.SegSel, "Accent", 1, 0.7)
        self.SegBtns = {}
        for i, v in ipairs({ { "Front", math.pi }, { "Side", math.pi / 2 }, { "Back", 0 } }) do
                local b = New("TextButton", { Text = v[1], TextSize = 12, Size = UDim2.new(1 / 3, 0, 1, 0), Position = UDim2.new((i - 1) / 3, 0, 0, 0), ZIndex = 2, Theme = { TextColor3 = "SubText" }, Parent = seg })
                b.Activated:Connect(function() self.Snap, self.Vel = v[2], 0 end)
                self.SegBtns[v[1]] = b
        end
        self.SpinApi = IconButton(bar, "rotate-3d", "↻", barH, "Auto rotate", "Accent", 0)
        self.SpinApi.Button.AnchorPoint, self.SpinApi.Button.Position = Vector2.new(1, 0), UDim2.new(1, -(barH + 6), 0, 0)
        self.SpinApi.Button.Activated:Connect(function()
                self:SetOption("Rotate", not cfg.Rotate)
                local t = Lib.Toggles.PreviewRotate
                if t then t:SetValue(cfg.Rotate, true) end
        end)
        local resetApi = IconButton(bar, "focus", "o", barH, "Reset view", "Accent", 0)
        resetApi.Button.AnchorPoint, resetApi.Button.Position = Vector2.new(1, 0), UDim2.new(1, 0, 0, 0)
        resetApi.Button.Activated:Connect(function() self.Snap, self.Vel, self.Zoom = math.pi, 0, 1 end)

        local drag = New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), ZIndex = 9, Parent = body })
        local lastPress = 0
        drag.InputBegan:Connect(function(input)
                if not IsPress(input) then return end
                local isTouch = input.UserInputType == Enum.UserInputType.Touch
                if os.clock() - lastPress < 0.3 then self.Snap, self.Vel, self.Zoom = math.pi, 0, 1 else self.Snap = nil end
                lastPress = os.clock()
                LockScroll(drag, true)
                self.Dragging = true
                local last, lastT = Pointer(input).X, os.clock()
                if self.Hint.TextTransparency < 1 then Tween(self.Hint, { TextTransparency = 1 }, 0.4) end
                local mc, ec
                mc = UIS.InputChanged:Connect(function(i)
                        if isTouch then if i ~= input then return end elseif i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
                        local x, t = Pointer(i).X, os.clock()
                        local d = (x - last) / math.max(Lib.Scale, 0.01) * 0.012
                        self.Angle = self.Angle + d
                        self.Vel = Lerp(self.Vel, Clamp(d / math.max(t - lastT, 1 / 240), -10, 10), 0.4)
                        last, lastT = x, t
                end)
                ec = UIS.InputEnded:Connect(function(i)
                        local fin = isTouch and (i == input) or (not isTouch and i.UserInputType == Enum.UserInputType.MouseButton1)
                        if not fin then return end
                        mc:Disconnect() ec:Disconnect()
                        LockScroll(drag, false)
                        self.Dragging = false
                        if os.clock() - lastT > 0.08 then self.Vel = 0 end
                        self.IdleAt = os.clock() + 2
                end)
        end)
        Lib:Connect(UIS.InputChanged, function(input)
                if input.UserInputType == Enum.UserInputType.MouseWheel and panel.Frame.Visible and IsOver(body) then
                        self.Zoom = Clamp(self.Zoom - input.Position.Z * 0.08, 0.6, 1.8)
                end
        end)
        frame:GetPropertyChangedSignal("Size"):Connect(function() self:_Layout() end)
        Lib:_FinishPanel(panel)
        self:_Layout()
        self:_StyleSpin()
        self:_SetView("Front")
        self:Rebuild()
        self:_BindTarget()
        Lib:Connect(LocalPlayer.CharacterAdded, function(char)
                task.wait(1)
                local res = self._res
                if res == nil or res.player == LocalPlayer then
                        self:Rebuild()
                        self:_Watch(char)
                end
        end)
        if LocalPlayer.Character then self:_Watch(LocalPlayer.Character) end
        Lib:Connect(RunService.RenderStepped, function(dt) self:_Step(dt) end)
        -- mirror the starting options so Lib:HookESP can replay them into your real ESP
        for k in pairs(ESPOptionNames) do Lib.ESPOptions[k] = cfg[k] end
        Lib.Preview = self
        return self
end

function ESP:_Layout()
        local f = self.Frame
        local bw = math.max(f.Size.X.Offset - 16, 40)
        local bh = math.max(f.Size.Y.Offset - (46 + self.BarH + 18), 40)
        local s = math.min(bw, bh)
        self.BW, self.BH, self.S = bw, bh, s
        self.Off = Vector2.new((bw - s) / 2, (bh - s) / 2)
        self.Viewport.Size = UDim2.fromOffset(s, s)
end

function ESP:_StyleSpin()
        if self.SpinApi then
                self.SpinApi.Rest = self.Config.Rotate and "Accent" or "SubText"
                Tint(self.SpinApi.Icon, Lib.Theme[self.SpinApi.Rest])
        end
end

function ESP:_SetView(name)
        if self._view == name then return end
        self._view = name
        local idx = ({ Front = 1, Side = 2, Back = 3 })[name] or 1
        Tween(self.SegSel, { Position = UDim2.new((idx - 1) / 3, 2, 0, 2) }, 0.16, Enum.EasingStyle.Quint)
        for n, b in pairs(self.SegBtns) do Tween(b, { TextColor3 = (n == name) and Lib.Theme.Text or Lib.Theme.SubText }, 0.12) end
        self.ViewLabel.Text = name
end

function ESP:_Watch(char)
        local pending = false
        local function Queue()
                if pending then return end
                pending = true
                task.delay(1, function() pending = false if self.Alive and not Lib.Unloaded then self:Rebuild() end end)
        end
        char.ChildAdded:Connect(function(c) if c:IsA("Accessory") or c:IsA("Shirt") or c:IsA("Pants") or c:IsA("CharacterMesh") then Queue() end end)
        char.ChildRemoved:Connect(function(c) if c:IsA("Accessory") then Queue() end end)
end

-- ── target handling ─────────────────────────────────────────────────────────
-- Turns whatever the owner set as the preview target into a concrete subject:
-- { kind = "local"/"player"/"char"/"model", player, model, root, humanoid, static, label }
function ESP:_Resolve(raw, depth)
        depth = depth or 0
        if depth > 4 then return nil end
        local t = typeof(raw)
        if raw == nil then
                -- Default target is YOU again: the preview follows the local player's character
                -- (respawns too, via the resolver's model ~= player.Character check below).
                local ch = LocalPlayer.Character
                return { kind = "local", player = LocalPlayer, model = ch,
                        root = ch and (ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChildWhichIsA("BasePart")),
                        humanoid = ch and ch:FindFirstChildOfClass("Humanoid"), label = "LocalPlayer" }
        elseif t == "Instance" then
                if raw:IsA("Player") then
                        local ch = raw.Character
                        local root = ch and (ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChildWhichIsA("BasePart"))
                        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                        return { kind = raw == LocalPlayer and "local" or "player", player = raw, model = ch, root = root, humanoid = hum, label = raw.DisplayName }
                elseif raw:IsA("Model") then
                        local hum = raw:FindFirstChildOfClass("Humanoid")
                        local root = raw:FindFirstChild("HumanoidRootPart") or raw:FindFirstChildWhichIsA("BasePart")
                        if hum and root then
                                return { kind = "char", model = raw, root = root, humanoid = hum, label = raw.Name }
                        end
                        return { kind = "model", model = raw, root = root, static = true, label = raw.Name }
                elseif raw:IsA("BasePart") then
                        local m = raw:FindFirstAncestorOfClass("Model")
                        if m then return self:_Resolve(m, depth + 1) end
                        return { kind = "model", model = raw, root = raw, static = true, label = raw.Name }
                end
                return { kind = "model", model = raw, static = true, label = raw.Name }
        elseif t == "function" then
                local ok, res = pcall(raw)
                if ok then
                        local r = self:_Resolve(res, depth + 1)
                        if r then r.label = r.label or "function" end
                        return r
                end
                return nil
        elseif t == "string" then
                local inst = ResolvePath(raw)
                if inst == nil then return nil end
                local r = self:_Resolve(inst, depth + 1)
                if r then r.label = raw end
                return r
        end
        return nil
end

-- Cached resolution; re-resolves when the subject dies, a player respawns, or - for
-- path/function targets - every couple of seconds so they can follow something new.
function ESP:_Ensure(force)
        local res = self._res
        if res then
                local raw = self.Target
                local t = typeof(raw)
                if res.model and res.model.Parent == nil then res = nil
                elseif res.player and res.model ~= res.player.Character then res = nil
                elseif (t == "function" or t == "string") and (force or os.clock() - (self._resAt or 0) > 2) then res = nil end
        end
        if res == nil then
                if not force and self._resFailAt and os.clock() - self._resFailAt < 2 then return nil end -- failed recently, back off
                self._resAt = os.clock()
                res = self:_Resolve(self.Target)
                self._res = res
                if res then self._resFailAt = nil else self._resFailAt = os.clock() end
        end
        return res
end

function ESP:GetTarget() return self.Target end

-- Point the preview at anything: nil / "LocalPlayer" (you), a path string, a Player,
-- a Model / BasePart, or a function returning one of those (re-resolved live).
function ESP:SetTarget(raw, label)
        self.Target = raw
        self.TargetLabel = label
        self.Override = nil -- stale live data from the old subject shouldn't leak onto the new one
        self._res, self._resFailAt = nil, nil
        self:_Ensure(true)
        self:_BindTarget()
        self:Rebuild()
        Lib:_FireESP("Target", raw)
        local res = self._res
        local name = label or (res and (res.label or (res.player and res.player.DisplayName) or (res.model and res.model.Name))) or nil
        if self.Model then return true, name end
        return false, name or tostring(raw)
end

-- Push live numbers from YOUR ESP onto the preview labels:
-- { Name = "Boss", Health = 62, MaxHealth = 100, Distance = 34, Tool = "Sword", Flags = { "Hostile", "Frozen" } }
function ESP:SetData(data)
        if type(data) == "table" then self.Override = data elseif data == nil then self.Override = nil end
        return self
end

-- Instant respawn handling for player targets; everything else is caught by the resolver timer.
function ESP:_BindTarget()
        if self._tconns then for _, c in ipairs(self._tconns) do pcall(function() c:Disconnect() end) end end
        self._tconns = {}
        local res = self._res
        if res and res.player and res.player ~= LocalPlayer then
                table.insert(self._tconns, Lib:Connect(res.player.CharacterAdded, function(char)
                        task.wait(1)
                        if self.Alive and not Lib.Unloaded then
                                self._res = nil
                                self:Rebuild()
                                if char then self:_Watch(char) end
                        end
                end))
        end
end

function ESP:Rebuild()
        if self.Model then self.Model:Destroy() self.Model = nil end
        self.ChamParts, self.Pairs, self.Handles, self._lastCham = {}, {}, {}, nil
        local res = self:_Ensure(true)
        local char = res and res.model
        if not char then return end
        local clone = CloneChar(char)
        if not clone then return end
        self._lastTry = os.clock()
        self._static, self.Src = res.static == true, char
        -- pair real parts with their clones by walking both trees together (index matching broke on some rigs and left stray parts / bones)
        local Paired = {}
        local function Pair(r, c)
                if r:IsA("BasePart") and c:IsA("BasePart") then
                        table.insert(self.Pairs, { r, c })
                        Paired[c] = true
                end
                local ck = c:GetChildren()
                for i, rc in ipairs(r:GetChildren()) do
                        local cc = ck[i]
                        if cc and cc.Name == rc.Name and cc.ClassName == rc.ClassName then Pair(rc, cc) end
                end
        end
        Pair(char, clone)
        for _, d in ipairs(clone:GetDescendants()) do
                if d:IsA("BaseScript") or d:IsA("Sound") or d:IsA("Highlight") or d:IsA("BillboardGui") or d:IsA("SurfaceGui") or d:IsA("ForceField")
                                or d:IsA("ParticleEmitter") or d:IsA("Fire") or d:IsA("Smoke") or d:IsA("Sparkles") or d:IsA("Beam") or d:IsA("Trail") then
                        d:Destroy()
                elseif d:IsA("BasePart") and not Paired[d] then
                        d:Destroy()
                elseif d:IsA("BasePart") then
                        d.Anchored, d.CanCollide, d.Massless = true, false, true
                        if self.Config.Chams and d.Transparency < 1 then
                                d.Material, d.Transparency = Enum.Material.Neon, 0.3
                                table.insert(self.ChamParts, d)
                        end
                elseif self.Config.Chams and (d:IsA("Decal") or d:IsA("Texture") or d:IsA("SurfaceAppearance")) then
                        d:Destroy()
                end
        end
        local hum = clone:FindFirstChildOfClass("Humanoid")
        if hum then
                hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        end
        if not self._static then
                for _, a in ipairs(clone:GetChildren()) do
                        if a:IsA("Accessory") then
                                local hd = a:FindFirstChild("Handle")
                                if hd and hd:IsA("BasePart") then table.insert(self.Handles, hd) end
                        end
                end
        end
        clone.Parent = self.Viewport
        self.Model = clone
        -- framing bounds
        local minV, maxV
        local function AddPoint(p, s)
                local lo, hi = p - s, p + s
                minV = minV and minV:Min(lo) or lo
                maxV = maxV and maxV:Max(hi) or hi
        end
        if self._static then
                -- any instance: bounds over every part inside it (plus the subject itself when it is one)
                if clone:IsA("BasePart") then AddPoint(clone.Position, clone.Size / 2) end
                for _, d in ipairs(clone:GetDescendants()) do
                        if d:IsA("BasePart") then AddPoint(d.Position, d.Size / 2) end
                end
        else
                -- characters: frame the body parts only (huge accessories used to blow up the bounds and shrink the character)
                for _, d in ipairs(clone:GetChildren()) do
                        if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then AddPoint(d.Position, d.Size / 2) end
                end
        end
        if not minV then self.Model:Destroy() self.Model = nil return end
        local size = maxV - minV
        local center = (minV + maxV) / 2
        local half = size / 2
        self._corners = {}
        for sx = -1, 1, 2 do for sy = -1, 1, 2 do for sz = -1, 1, 2 do
                        table.insert(self._corners, Vector3.new(sx * half.X, sy * half.Y, sz * half.Z))
                end end end
        local fov = math.rad(self.Camera.FieldOfView)
        if self._static then
                -- props: freeze every part where it was, then spin the whole thing around its centre
                self.Center = center
                local base = CFrame.Angles(0, self.Angle, 0) * CFrame.new(-center)
                for _, pr in ipairs(self.Pairs) do
                        pr[3] = pr[1].CFrame
                        if pr[2].Parent then pr[2].CFrame = base * pr[3] end
                end
        else
                local root = res.root or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
                if not root then self.Model:Destroy() self.Model = nil return end
                self.Center = root.CFrame:PointToObjectSpace(center)
        end
        self.Distance = ((size.Y / 0.64) / 2) / math.tan(fov / 2) + size.Z / 2
end

function ESP:_Project(p)
        local cam, S, off = self.Camera, self.S, self.Off
        local tanF = math.tan(math.rad(cam.FieldOfView) / 2)
        local v = cam.CFrame:PointToObjectSpace(p)
        local z = math.max(-v.Z, 0.1)
        return Vector2.new(off.X + (v.X / z / tanF + 1) / 2 * S, off.Y + (1 - v.Y / z / tanF) / 2 * S)
end

function ESP:_Step(dt)
        if not self.Alive or not self.Frame.Visible then return end
        local cfg, model = self.Config, self.Model
        local res = self:_Ensure()
        local static = self._static == true
        local root = res and res.root
        local live = model ~= nil and model.Parent ~= nil and self.Center ~= nil and (static or root ~= nil)
        if not self.Dragging then
                if self.Snap then
                        local d = (self.Snap - self.Angle + math.pi) % (2 * math.pi) - math.pi
                        self.Angle = self.Angle + d * math.min(1, dt * 10)
                        if math.abs(d) < 0.003 then self.Angle, self.Snap = self.Snap, nil self.IdleAt = os.clock() + 2 end
                else
                        self.Angle = self.Angle + self.Vel * dt
                        self.Vel = self.Vel * math.exp(-dt * 3.5)
                        local target = (cfg.Rotate and os.clock() > self.IdleAt) and cfg.RotateSpeed or 0
                        self.Spin = Lerp(self.Spin, target, math.min(1, dt * 2))
                        self.Angle = self.Angle + self.Spin * dt
                end
        end
        if self.Distance then self.Camera.CFrame = CFrame.lookAt(Vector3.new(0, 0, self.Distance * self.Zoom), Vector3.zero) end
        local zt = math.floor(100 / self.Zoom + 0.5) .. "%"
        if self.ZoomLabel.Text ~= zt then self.ZoomLabel.Text = zt end
        local used, extras = 0, false
        local boxVisible = false
        -- the subject changed under us (respawn, live function target, destroyed model, half-loaded rig) -> rebuild
        if os.clock() - (self._lastTry or 0) > 2 then
                local src = res and res.model
                if src ~= self.Src or not live
                                or (not static and model and not (model:FindFirstChild("Head") and (model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso")))) then
                        self._lastTry = os.clock()
                        self:Rebuild()
                        res, model, root, static = self._res, self.Model, self._res and self._res.root, self._static == true
                        live = model ~= nil and model.Parent ~= nil and self.Center ~= nil and (static or root ~= nil)
                end
        end
        if live then
                local rot = CFrame.Angles(0, self.Angle, 0)
                local base = rot * CFrame.new(-self.Center)
                if static then
                        for _, pr in ipairs(self.Pairs) do
                                local c = pr[2]
                                if c.Parent and pr[3] then c.CFrame = base * pr[3] end
                        end
                else
                        local inv = root.CFrame:Inverse()
                        for _, pr in ipairs(self.Pairs) do
                                local r, c = pr[1], pr[2]
                                if r.Parent and c.Parent then c.CFrame = base * (inv * r.CFrame) end
                        end
                end
                local facing = rot.LookVector.Z
                self:_SetView((facing > 0.75 and "Front") or (facing < -0.75 and "Back") or "Side")
                local head = not static and model:FindFirstChild("Head")
                local torso = not static and (model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso"))
                if head and torso then
                        local headTop = head.Position.Y + head.Size.Y / 2
                        local topY, botY = headTop, math.huge
                        for _, hd in ipairs(self.Handles) do
                                if hd.Parent then topY = math.max(topY, math.min(hd.Position.Y + hd.Size.Y / 2, headTop + 1.2)) end
                        end
                        for _, n in ipairs(FeetNames) do
                                local p = model:FindFirstChild(n)
                                if p then botY = math.min(botY, p.Position.Y - p.Size.Y / 2) end
                        end
                        if botY == math.huge then botY = torso.Position.Y - 3 end
                        -- the model rotates around the origin, so the box stays dead-centre horizontally
                        local pt, pb = self:_Project(Vector3.new(0, topY, 0)), self:_Project(Vector3.new(0, botY, 0))
                        local h = math.max(pb.Y - pt.Y, 10)
                        local cxp = math.floor(pt.X + 0.5)
                        self.BoxFrame.Size = UDim2.fromOffset(math.floor(h * 0.55), math.floor(h))
                        self.BoxFrame.Position = UDim2.fromOffset(cxp, math.floor((pt.Y + pb.Y) / 2 + 0.5))
                        boxVisible, extras = true, true
                        local L = Clamp(math.floor(h * 0.17), 8, 24)
                        for i, c in ipairs(self.Corners) do c.Size = (i % 2 == 1) and UDim2.fromOffset(L, 2) or UDim2.fromOffset(2, L) end
                        if cfg.Tracer then
                                SetLine(self.TracerLine, Vector2.new(self.BW / 2, self.BH), Vector2.new(cxp, pb.Y), cfg.TracerColor, 1.5)
                                self.TracerDot.Visible = true
                                self.TracerDot.BackgroundColor3 = cfg.TracerColor
                                self.TracerDot.Position = UDim2.fromOffset(cxp, pb.Y)
                        else
                                self.TracerLine.Visible = false
                                self.TracerDot.Visible = false
                        end
                        if cfg.HeadDot then
                                local pp = self:_Project(head.Position)
                                local d = math.max(6, head.Size.Y * (h / math.max(topY - botY, 0.1)) * 0.9)
                                self.HeadDotFrame.Visible = true
                                self.HeadDotFrame.Size = UDim2.fromOffset(d, d)
                                self.HeadDotFrame.Position = UDim2.fromOffset(pp.X, pp.Y)
                                self.HeadDotStroke.Color = cfg.HeadDotColor
                        else
                                self.HeadDotFrame.Visible = false
                        end
                elseif static and self._corners then
                        -- props: the box wraps the projected bounding box of the spinning model
                        local cA, sA = math.cos(self.Angle), math.sin(self.Angle)
                        local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
                        for _, o in ipairs(self._corners) do
                                local x = o.X * cA + o.Z * sA
                                local z = -o.X * sA + o.Z * cA
                                local p = self:_Project(Vector3.new(x, o.Y, z))
                                if p.X < minX then minX = p.X end
                                if p.Y < minY then minY = p.Y end
                                if p.X > maxX then maxX = p.X end
                                if p.Y > maxY then maxY = p.Y end
                        end
                        if maxX > minX and maxY > minY then
                                local w, h = maxX - minX, maxY - minY
                                local cxp = math.floor((minX + maxX) / 2 + 0.5)
                                self.BoxFrame.Size = UDim2.fromOffset(math.floor(w), math.floor(h))
                                self.BoxFrame.Position = UDim2.fromOffset(cxp, math.floor((minY + maxY) / 2 + 0.5))
                                boxVisible, extras = true, true
                                if cfg.Tracer then
                                        SetLine(self.TracerLine, Vector2.new(self.BW / 2, self.BH), Vector2.new(cxp, maxY), cfg.TracerColor, 1.5)
                                        self.TracerDot.Visible = true
                                        self.TracerDot.BackgroundColor3 = cfg.TracerColor
                                        self.TracerDot.Position = UDim2.fromOffset(cxp, math.floor(maxY + 0.5))
                                else
                                        self.TracerLine.Visible = false
                                        self.TracerDot.Visible = false
                                end
                        end
                end
                if cfg.Chams and self._lastCham ~= cfg.ChamsColor then
                        self._lastCham = cfg.ChamsColor
                        for _, part in ipairs(self.ChamParts) do part.Color = cfg.ChamsColor end
                end
                if cfg.Skeleton and not static then
                        for _, pr in ipairs(model:FindFirstChild("UpperTorso") and R15 or R6) do
                                local a, b = model:FindFirstChild(pr[1]), model:FindFirstChild(pr[2])
                                if a and b then
                                        local pa, pb2 = self:_Project(a.Position), self:_Project(b.Position)
                                        -- drop bones that point outside the preview (a stray part used to draw one long line across it)
                                        if InBody(self, pa) and InBody(self, pb2) and (pa - pb2).Magnitude < self.S * 0.6 then
                                                used = used + 1
                                                local line = self.Lines[used]
                                                if not line then
                                                        line = New("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 0, ZIndex = 6, Parent = self.Overlay })
                                                        self.Lines[used] = line
                                                end
                                                SetLine(line, pa, pb2, cfg.SkeletonColor, 1.5)
                                        end
                                end
                        end
                end
        end
        for i = used + 1, #self.Lines do self.Lines[i].Visible = false end
        if not extras then self.TracerLine.Visible = false self.TracerDot.Visible = false self.HeadDotFrame.Visible = false end
        local style = cfg.BoxStyle
        self.BoxFrame.Visible = boxVisible
        self.BoxStroke.Enabled = cfg.Box and style ~= "Corner"
        self.BoxStroke.Color = cfg.BoxColor
        self.Outline.Visible = cfg.Box and style ~= "Corner"
        for _, c in ipairs(self.Corners) do c.Visible = cfg.Box and style == "Corner" c.BackgroundColor3 = cfg.BoxColor end
        self.BoxFrame.BackgroundColor3 = cfg.FillColor
        self.BoxFrame.BackgroundTransparency = (cfg.Box and cfg.BoxFill) and cfg.FillTransparency or 1
        self.LiveDot.BackgroundColor3 = live and Lib.Theme.Good or Lib.Theme.Bad
        -- labels: data you pushed with ESP:SetData / Lib:SetPreviewData wins, then the subject, then you
        local ov = self.Override
        local char = res and res.model
        local hum = (not static) and char and char:FindFirstChildOfClass("Humanoid") or nil
        local name = ov and ov.Name or (res and ((res.player and res.player.DisplayName) or (char and char.Name))) or LocalPlayer.DisplayName
        self.NameLabel.Visible, self.NameLabel.TextColor3, self.NameLabel.Text = cfg.Name, cfg.NameColor, tostring(name)
        local tool = (not static) and char and char:FindFirstChildOfClass("Tool") or nil
        local toolName = (ov and ov.Tool ~= nil and tostring(ov.Tool)) or (tool and tool.Name) or "none"
        local hp, maxhp = (ov and tonumber(ov.Health)), (ov and tonumber(ov.MaxHealth))
        if hum and hum.MaxHealth > 0 then
                hp, maxhp = hp or hum.Health, maxhp or hum.MaxHealth
        end
        local ratio = 1
        if maxhp and maxhp > 0 and hp then ratio = Clamp(hp / maxhp, 0, 1) end
        self.HealthFill.Size = UDim2.new(1, -2, ratio, -2)
        local hc = Color3.fromHSV(ratio * 0.33, 0.78, 0.9)
        self.HealthFill.BackgroundColor3 = hc
        self.HealthText.TextColor3 = hc
        self.HealthText.Text = tostring(math.floor(ratio * 100 + 0.5))
        self.HealthBack.Visible, self.HealthText.Visible = cfg.Health, cfg.Health
        -- real distance between you and the subject (this used to be a hard-coded "24m")
        local dist = ov and tonumber(ov.Distance)
        if dist == nil and char then
                local myChar = LocalPlayer.Character
                local cam = workspace.CurrentCamera
                local from = (myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar:FindFirstChild("HumanoidRootPart").Position) or (cam and cam.CFrame.Position)
                local to = (root and root.Position) or (self.Pairs[1] and self.Pairs[1][1] and self.Pairs[1][1].Position)
                if from and to then dist = (from - to).Magnitude end
        end
        self.DistLabel.Visible = cfg.Distance
        self.DistLabel.Text = dist and (math.floor(dist + 0.5) .. "m") or "-"
        self.ToolLabel.Visible = cfg.Tool
        self.ToolLabel.Text = toolName
        self.ToolLabel.Position = UDim2.new(0.5, 0, 1, cfg.Distance and 25 or 5)
        self.FlagsLabel.Visible = cfg.Flags
        if cfg.Flags then
                local lines = nil
                if ov and ov.Flags ~= nil then
                        lines = type(ov.Flags) == "table" and table.concat(ov.Flags, "\n") or tostring(ov.Flags)
                elseif hum then
                        lines = StateNames[hum:GetState()] or (hum.MoveDirection.Magnitude > 0.1 and "Moving" or "Idle")
                        if tool then lines = lines .. "\nArmed" end
                end
                if lines and lines ~= "" then self.FlagsLabel.Text = lines end
        end
end

function ESP:SetOption(name, value)
        self.Config[name] = value
        if ESPOptionNames[name] then
                Lib.ESPOptions[name] = value
                Lib:_FireESP(name, value)
        end
        if name == "Chams" then self:Rebuild() end
        if name == "Rotate" then self:_StyleSpin() end
end

function ESP:SetVisible(s) self.PanelObj:Set(s) end
function ESP:Destroy() self.Alive = false if self.Frame then self.Frame:Destroy() end end

-- ── owner-facing ESP integration ─────────────────────────────────────────────
function Lib:_FireESP(name, value)
        for i = #self.ESPHooks, 1, -1 do
                local h = self.ESPHooks[i]
                if h.dead then table.remove(self.ESPHooks, i)
                elseif h.fn then Safe(h.fn, name, value) end
        end
end

-- Connect YOUR real ESP to the ESP settings tab + preview. fn(option, value) fires for every
-- ESP option change ("Box", "BoxStyle", "Name", "Health", "Chams", "Tracer", "Rotate", ...
-- plus "Target" whenever the preview subject changes) and is replayed the current options once
-- on registration so your ESP syncs immediately. Returns a handle with :Disconnect().
function Lib:HookESP(fn)
        if type(fn) ~= "function" then return nil end
        local h = { fn = fn }
        table.insert(self.ESPHooks, h)
        for k, v in pairs(self.ESPOptions) do Safe(fn, k, v) end
        if self.Preview then Safe(fn, "Target", self.Preview.Target) end
        return { Disconnect = function() h.dead = true end }
end

function Lib:UnhookESP() self.ESPHooks = {} end

-- Point the ESP preview at anything: nil / "LocalPlayer" (you), "Players/<name>",
-- "workspace.Folder.Model" (dots or slashes), a Player / Model / BasePart instance, or a
-- function returning one of those (re-resolved live). The panel is a real 3D viewport:
-- drag to rotate, scroll to zoom.
function Lib:SetPreviewTarget(raw, label)
        self.PreviewTarget = raw
        if self.Preview then return self.Preview:SetTarget(raw, label) end
        return true, "queued" -- the preview is created later by Lib:BuildSettingsTab
end

function Lib:GetPreviewTarget() return (self.Preview and self.Preview.Target) or self.PreviewTarget end

-- Push live data from your ESP onto the preview labels (nil to clear):
-- { Name = ..., Health = ..., MaxHealth = ..., Distance = ..., Tool = ..., Flags = { ... } }
function Lib:SetPreviewData(data) if self.Preview then self.Preview:SetData(data) end return self.Preview end

local Chat = {}
Chat.__index = Chat

local function Copy(text, label)
        if type(setclipboard) == "function" then
                setclipboard(text)
                Lib:Notify({ Title = "Copied", Text = label, Type = "success", Duration = 2.5 })
        else
                Lib:Notify({ Text = "Your executor has no clipboard function.", Type = "warn" })
        end
end
local function Short(s, n)
        s = tostring(s)
        if #s <= n then return s end
        return s:sub(1, n - 3) .. "..."
end

local function GetRequest() return (syn and syn.request) or request or http_request or (http and http.request) or (fluxus and fluxus.request) or nil end
local function UrlEncode(s) return (tostring(s):gsub("[^%w%-_%.~]", function(c) return string.format("%%%02X", string.byte(c)) end)) end
local function RichEsc(s) return (tostring(s):gsub("[<>&]", "")) end
local function Decode(res)
        if not res or type(res.Body) ~= "string" then return nil end
        local ok, d = pcall(HttpService.JSONDecode, HttpService, res.Body)
        return ok and type(d) == "table" and d or nil
end

-- ---- base64 (used for image upload/download), asset cache, teleport safety, user blocking
local B64C = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local B64R = {}
for i = 1, 64 do B64R[B64C:byte(i)] = i - 1 end

local function B64Decode(s)
        s = s:gsub("[^%w%+/]", "")
        local out, n = {}, 0
        for i = 1, #s, 4 do
                local a, b, c, d = s:byte(i, i + 3)
                local v = B64R[a] * 262144 + B64R[b] * 4096 + (c and B64R[c] or 0) * 64 + (d and B64R[d] or 0)
                n = n + 1
                if d then out[n] = string.char(math.floor(v / 65536), math.floor(v / 256) % 256, v % 256)
                elseif c then out[n] = string.char(math.floor(v / 65536), math.floor(v / 256) % 256)
                else out[n] = string.char(math.floor(v / 65536)) end
                if n % 3000 == 0 then task.wait() end
        end
        return table.concat(out)
end

local function B64Encode(data)
        local out, n = {}, 0
        for i = 1, #data, 3 do
                local a, b, c = data:byte(i, i + 2)
                local v = a * 65536 + (b or 0) * 256 + (c or 0)
                local c1, c2, c3, c4 = math.floor(v / 262144) % 64, math.floor(v / 4096) % 64, math.floor(v / 64) % 64, v % 64
                n = n + 1
                out[n] = B64C:sub(c1 + 1, c1 + 1) .. B64C:sub(c2 + 1, c2 + 1) .. (b and B64C:sub(c3 + 1, c3 + 1) or "=") .. (c and B64C:sub(c4 + 1, c4 + 1) or "=")
                if n % 3000 == 0 then task.wait() end
        end
        return table.concat(out)
end

local function FsOk()
        return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
                and type(isfolder) == "function" and type(makefolder) == "function"
end

local function CustomAsset(path)
        local f = getcustomasset or getsynasset
        if type(f) ~= "function" then return nil end
        local ok, r = pcall(f, path)
        if ok and r and r ~= "" then return r end
end

local function CachePath(id, mime)
        pcall(function()
                if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                if not isfolder(Lib.ConfigFolder .. "/cache") then makefolder(Lib.ConfigFolder .. "/cache") end
        end)
        return Lib.ConfigFolder .. "/cache/img_" .. id .. (mime == "image/jpeg" and ".jpg" or ".png")
end

-- ---- joining someone: checks the server, and explains a failed teleport instead of doing nothing
local JoinWhy = {
        GameFull = "That server is full right now.",
        GameEnded = "That server has shut down or is closing.",
        GameNotFound = "That server doesn't exist anymore, or the game isn't public.",
        Unauthorized = "You aren't allowed to join it. It's probably a private server, or the game limits who can join.",
        Flooded = "Roblox is rate limiting teleports. Wait about 30 seconds and try again.",
        IsTeleporting = "You are already teleporting. Wait for that one to finish.",
        Failure = "Roblox reported a general teleport failure.",
}

function Lib:JoinFailed(place, job, label, result, detail)
        local name = result and result.Name or nil
        local text = JoinWhy[name or ""] or "Roblox couldn't complete the teleport."
        if detail and tostring(detail) ~= "" then text = text .. "\n\nRoblox said: " .. tostring(detail) end
        if name then text = text .. "\n(" .. name .. ")" end
        local buttons = { { Text = "Close" } }
        if name ~= "Unauthorized" and name ~= "GameNotFound" and name ~= "GameEnded" then
                table.insert(buttons, { Text = "Retry", Callback = function() Lib:JoinServer(place, job, label) end })
        end
        if place and name ~= "IsTeleporting" and name ~= "Flooded" then
                table.insert(buttons, { Text = "Other server", Primary = true, Callback = function()
                        pcall(function() Teleport:Teleport(place, LocalPlayer) end)
                end })
        end
        Lib:Dialog({ Title = "Teleport failed", Text = text, Buttons = buttons })
end

function Lib:JoinServer(place, job, label)
        place, label = tonumber(place), label or "that server"
        if not place or not job or job == "" then
                Lib:Notify({ Title = "Join", Text = "There's no server to join.", Type = "warn" })
                return
        end
        local mine = { place = place, job = job, label = label }
        Lib._joining = mine
        Lib:Notify({ Title = "Join", Text = "Teleporting to " .. label .. "...", Type = "info", Duration = 3 })
        local ok, err = pcall(function() Teleport:TeleportToPlaceInstance(place, job, LocalPlayer) end)
        if not ok then
                Lib._joining = nil
                Lib:JoinFailed(place, job, label, nil, tostring(err))
                return
        end
        task.delay(30, function()
                if Lib.Unloaded or Lib._joining ~= mine then return end
                Lib._joining = nil
                Lib:JoinFailed(place, job, label, nil, "The teleport never started. Roblox didn't respond.")
        end)
end

pcall(function()
        Lib:Connect(Teleport.TeleportInitFailed, function(_, result, msg)
                local j = Lib._joining
                if not j then return end
                Lib._joining = nil
                Lib:JoinFailed(j.place, j.job, j.label, result, msg)
        end)
end)

-- looks the job id up in the public server list (first 400 servers). cb(info) or cb(nil, "unreachable" | "notfound")
function Lib:CheckServer(place, job, cb)
        task.spawn(function()
                local cursor = ""
                for _ = 1, 4 do
                        local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100%s", place,
                                cursor ~= "" and ("&cursor=" .. HttpService:UrlEncode(cursor)) or "")
                        local body = Fetch(url)
                        local ok, d = pcall(function() return HttpService:JSONDecode(body or "") end)
                        if not ok or type(d) ~= "table" or type(d.data) ~= "table" then cb(nil, "unreachable") return end
                        for _, s in ipairs(d.data) do
                                if s.id == job then cb({ playing = s.playing or 0, max = s.maxPlayers or 0 }) return end
                        end
                        if not d.nextPageCursor then break end
                        cursor = d.nextPageCursor
                        task.wait(0.4)
                end
                cb(nil, "notfound")
        end)
end

-- ---- blocking (client side, saved to Aether/blocked.json)
function Lib:SaveBlocks()
        if not FsOk() then return end
        pcall(function()
                if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                writefile(Lib.ConfigFolder .. "/blocked.json", HttpService:JSONEncode(Lib.BlockList))
        end)
end

function Lib:LoadBlocks()
        if self._blocksLoaded or not FsOk() then return end
        self._blocksLoaded = true
        pcall(function()
                local p = Lib.ConfigFolder .. "/blocked.json"
                if isfile(p) then
                        local d = HttpService:JSONDecode(readfile(p))
                        if type(d) == "table" then for k, v in pairs(d) do Lib.BlockList[tostring(k)] = tostring(v) end end
                end
        end)
end

function Lib:IsBlocked(uid) return uid ~= nil and Lib.BlockList[tostring(uid)] ~= nil end

function Lib:_AfterBlockChange()
        if self.ChatObj then self.ChatObj:ApplySearch(true) end
        local dd = self.Options.__BlockedList
        if dd then
                local vals, map = {}, {}
                for uid, name in pairs(self.BlockList) do
                        local label = name .. " (" .. uid .. ")"
                        table.insert(vals, label)
                        map[label] = uid
                end
                table.sort(vals)
                self._blockLabels = map
                dd:SetValues(vals)
        end
end

function Lib:Block(uid, name)
        if tostring(uid) == tostring(LocalPlayer.UserId) then return end
        self.BlockList[tostring(uid)] = tostring(name or uid)
        self:SaveBlocks()
        self:_AfterBlockChange()
        self:Notify({ Title = "Blocked", Text = tostring(name or uid) .. " is hidden from chat.", Type = "success", Duration = 2.5 })
end

function Lib:Unblock(uid)
        self.BlockList[tostring(uid)] = nil
        self:SaveBlocks()
        self:_AfterBlockChange()
end

local KindKey = { info = "Accent", success = "Good", warn = "Warn", error = "Bad" }

-- Channels: "Global" first, then every game set in the loader. Accepts {123, 456}, { ["Name"] = 123 } or { {Name = "x", Id = 123} }.
local function BuildChannels(src, globalRoom)
        local out = { { name = "Global", room = globalRoom or "global" } }
        local function Add(name, id)
                id = tonumber(id) or id
                table.insert(out, { name = tostring(name or id), room = "game-" .. tostring(id), id = id, auto = (name == nil) })
        end
        if type(src) == "table" then
                for _, v in ipairs(src) do
                        if type(v) == "table" then Add(v.Name or v.name, v.Id or v.id or v[1]) else Add(nil, v) end
                end
                local keys = {}
                for k in pairs(src) do if type(k) == "string" then table.insert(keys, k) end end
                table.sort(keys)
                for _, k in ipairs(keys) do Add(k, src[k]) end
        end
        return out
end

function Lib:CreateChat(cfg)
        cfg = Merge({ Title = "Chat", Url = nil, Room = "global", Channels = nil, PollInterval = 3.5, MaxMessages = 100, MaxLength = 200, Size = nil,
                Placeholder = "Message..." }, cfg)
        cfg.Url = cfg.Url or Lib.DefaultChatUrl
        if type(cfg.Url) == "string" then cfg.Url = (cfg.Url:gsub("/+$", "")) end
        local win = self.MainWindow
        local channels = BuildChannels(cfg.Channels or getgenv and getgenv().AetherChannels, cfg.Room)
        local self = setmetatable({ Config = cfg, Alive = true, Online = 0, LastId = -1, LastSend = 0, Items = {}, ByLid = {}, ByBubble = {}, Seen = {}, Fails = 0, Request = GetRequest(),
                Counter = 0, ReplyTo = nil, Loaded = false, Users = {}, Known = {}, Blocked = nil, LastPtr = Vector2.new(200, 200), _inState = "",
                Channels = channels, ChIndex = 1, Room = channels[1].room, Gen = 0, Stick = true, JumpCount = 0, Notifs = {}, Pinned = {}, PinIdx = 1, SearchFilter = false, SearchHits = {}, SearchIdx = 0, Meta = setmetatable({}, { __mode = "k" }) }, Chat)
        local size = cfg.Size or UDim2.fromOffset(310, win and win.H or 440)
        local panel, frame = Lib:_MakePanel("Chat", cfg.Title, "message-square", size.X.Offset, size.Y.Offset, "right", "Chat")
        self.PanelObj, self.Frame = panel, frame
        self.Friends = { friends = {}, incoming = {}, outgoing = {}, byId = {}, online = {}, ver = -1, sig = "" }
        self.HiddenDMs = {}
        panel.TitleLabel.Size = UDim2.new(1, -190, 1, 0)
        self.Pill = New("TextButton", { Text = "Connecting", TextSize = 11, AutomaticSize = X, Size = UDim2.fromOffset(0, 22), AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -(H(26) * 2 + 16), 0.5, 0), BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = panel.Head })
        Corner(self.Pill, 11) Pad(self.Pill, 20, 0, 10, 0)
        self.Dot = New("Frame", { Size = UDim2.fromOffset(6, 6), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, -12, 0.5, 0), Theme = { BackgroundColor3 = "Dim" }, Parent = self.Pill })
        Corner(self.Dot, 3)
        self.Pill.Activated:Connect(function() self:ShowUsers() end)
        local ih = H(32)
        local multi = true -- always interactive now: DMs and group chats get added to this bar live
        local bh = H(26)
        self.BaseTop = 44 + bh + 8
        self.Top = self.BaseTop
        local bar = New("Frame", { Size = UDim2.new(1, -16, 0, bh), Position = UDim2.fromOffset(8, 44), BackgroundTransparency = 1, Parent = frame })
        local region = New("Frame", { Size = UDim2.new(1, -(bh * 3 + 20), 1, 0), BackgroundTransparency = 1, Parent = bar })
        local arrows = multi and (bh + 4) or 0
        if multi then
                local prev = IconButton(region, "chevron-left", "<", bh, "Previous channel", "Text", 0)
                prev.Button.Position = UDim2.fromOffset(0, 0)
                local nxt = IconButton(region, "chevron-right", ">", bh, "Next channel", "Text", 0)
                nxt.Button.AnchorPoint, nxt.Button.Position = Vector2.new(1, 0), UDim2.new(1, 0, 0, 0)
                prev.Button.Activated:Connect(function() self:SetChannel((self.ChIndex - 2) % #self.Channels + 1) end)
                nxt.Button.Activated:Connect(function() self:SetChannel(self.ChIndex % #self.Channels + 1) end)
        end
        self.ChBtn = New("TextButton", { Text = "", Size = UDim2.new(1, -(arrows * 2), 1, 0), Position = UDim2.fromOffset(arrows, 0), BackgroundTransparency = 0,
                Theme = { BackgroundColor3 = "Field" }, Parent = region })
        Corner(self.ChBtn, 6) Stroke(self.ChBtn, "Stroke", 1, 0.4)
        self.ChLabel = New("TextLabel", { Text = "", RichText = true, TextSize = 12, Size = UDim2.new(1, -30, 1, 0), Position = UDim2.fromOffset(10, 0), TextXAlignment = LEFT,
                TextTruncate = Enum.TextTruncate.AtEnd, Parent = self.ChBtn })
        if multi then
                Lib.Icon("chevron-down", 13, "Dim", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Parent = self.ChBtn }, "v")
                self.ChBtn.MouseEnter:Connect(function() Tween(self.ChBtn, { BackgroundColor3 = Lib.Theme.FieldHover }, 0.08) end)
                self.ChBtn.MouseLeave:Connect(function() Tween(self.ChBtn, { BackgroundColor3 = Lib.Theme.Field }, 0.1) end)
                self.ChBtn.Activated:Connect(function() self:ChannelMenu() end)
                for _, ch in ipairs(channels) do
                        if ch.auto and type(ch.id) == "number" then
                                task.spawn(function()
                                        local ok, r = pcall(function() return Market:GetProductInfo(ch.id).Name end)
                                        if ok and r then ch.name = r self:_RefreshChannel() end
                                end)
                        end
                end
        end
        self:_RefreshChannel()
        -- bring back the DMs + groups from last time (the server re-confirms or drops them on the next poll)
        self:LoadConvos()
        self.SearchApi = IconButton(bar, "search", "?", bh, "Search messages", "Accent", 0)
        self.SearchApi.Button.AnchorPoint, self.SearchApi.Button.Position = Vector2.new(1, 0), UDim2.new(1, -(bh + 4), 0, 0)
        self.SearchApi.Button.Activated:Connect(function() self:ToggleSearch(not self.SearchOpen) end)
        self.BellApi = IconButton(bar, "bell", "!", bh, "Mentions & replies", "Accent", 0)
        self.BellApi.Button.AnchorPoint, self.BellApi.Button.Position = Vector2.new(1, 0), UDim2.new(1, 0, 0, 0)
        self.BellApi.Button.Activated:Connect(function() self:ToggleNotifs(not self.NotifOpen) end)
        self.BellBadge = New("Frame", { Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 3, 0, -3), Visible = false, ZIndex = 6,
                Theme = { BackgroundColor3 = "Bad" }, Parent = self.BellApi.Button })
        Corner(self.BellBadge, 7)
        self.BellText = New("TextLabel", { Text = "0", Font = Lib.FontBold, TextSize = 9, Size = UDim2.fromScale(1, 1), TextColor3 = WHITE, ZIndex = 7, Parent = self.BellBadge })
        self.FriendApi = IconButton(bar, "users", "F", bh, "Friends", "Accent", 0)
        self.FriendApi.Button.AnchorPoint, self.FriendApi.Button.Position = Vector2.new(1, 0), UDim2.new(1, -(bh * 2 + 8), 0, 0)
        self.FriendApi.Button.Activated:Connect(function() self:ShowFriends() end)
        self.FrBadge = New("Frame", { Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 3, 0, -3), Visible = false, ZIndex = 6,
                Theme = { BackgroundColor3 = "Bad" }, Parent = self.FriendApi.Button })
        Corner(self.FrBadge, 7)
        self.FrBadgeText = New("TextLabel", { Text = "0", Font = Lib.FontBold, TextSize = 9, Size = UDim2.fromScale(1, 1), TextColor3 = WHITE, ZIndex = 7, Parent = self.FrBadge })
        local list = New("ScrollingFrame", { Size = UDim2.new(1, -16, 1, -(self.Top + ih + 16)), Position = UDim2.fromOffset(8, self.Top), AutomaticCanvasSize = Y, ScrollBarThickness = 2,
                BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Surface" }, Parent = frame })
        Corner(list, 6) List(list, 0) Pad(list, 4, 6, 8, 6)
        self.List, self.ListBottom = list, ih + 16
        self.Jump = New("TextButton", { Text = "↓ Latest", TextSize = 11, AutomaticSize = X, Size = UDim2.fromOffset(0, 22), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -(ih + 16)),
                BackgroundTransparency = 0, Visible = false, ZIndex = 10, Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = frame })
        Corner(self.Jump, 11) Pad(self.Jump, 12, 0, 12, 0)
        self.Jump.Activated:Connect(function() self:ScrollBottom() end)
        list:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                self.Stick = list.CanvasPosition.Y >= list.AbsoluteCanvasSize.Y - list.AbsoluteSize.Y - 30
                if self.Stick then self.JumpCount = 0 end
                self.Jump.Visible = not self.Stick
                self.Jump.Text = self.JumpCount > 0 and ("↓ " .. self.JumpCount .. " new") or "↓ Latest"
        end)
        list:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
                if self.Stick then list.CanvasPosition = Vector2.new(0, math.max(0, list.AbsoluteCanvasSize.Y - list.AbsoluteSize.Y)) end
        end)
        -- message search: highlights matches, jumps between them, optional "only matches" filter, supports from:name
        self.SearchOpen, self.SearchText = false, ""
        self.SearchRow = New("Frame", { Size = UDim2.new(1, -16, 0, 24), Position = UDim2.fromOffset(8, self.BaseTop - 4), BackgroundTransparency = 0, Visible = false,
                Theme = { BackgroundColor3 = "Field" }, Parent = frame })
        Corner(self.SearchRow, 5)
        local sStroke = Stroke(self.SearchRow, "Stroke", 1, 0.3)
        Lib.Icon("search", 12, "Dim", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), Parent = self.SearchRow }, "?")
        self.SearchBox = New("TextBox", { Text = "", PlaceholderText = "Search  ·  from:name", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 12, Size = UDim2.new(1, -150, 1, 0),
                Position = UDim2.fromOffset(26, 0), TextXAlignment = LEFT, Parent = self.SearchRow })
        self.SearchCount = New("TextLabel", { Text = "", TextSize = 10, Size = UDim2.fromOffset(48, 24), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -76, 0, 0),
                TextXAlignment = RIGHT, Theme = { TextColor3 = "Dim" }, Parent = self.SearchRow })
        local function SBtn(icon, fb, x, tip)
                local a = IconButton(self.SearchRow, icon, fb, 20, tip, "Accent", 1)
                a.Button.AnchorPoint, a.Button.Position = Vector2.new(1, 0.5), UDim2.new(1, x, 0.5, 0)
                return a
        end
        SBtn("chevron-up", "^", -52, "Previous match").Button.Activated:Connect(function() self:SearchStep(-1) end)
        SBtn("chevron-down", "v", -28, "Next match").Button.Activated:Connect(function() self:SearchStep(1) end)
        self.FilterApi = SBtn("list-filter", "F", -4, "Only show matching messages")
        self.FilterApi.Button.Activated:Connect(function()
                self.SearchFilter = not self.SearchFilter
                self.FilterApi.Rest = self.SearchFilter and "Accent" or "SubText"
                Tint(self.FilterApi.Icon, Lib.Theme[self.FilterApi.Rest])
                self:ApplySearch(true)
        end)
        self.SearchBox.Focused:Connect(function() Tween(sStroke, { Color = Lib.Theme.Accent, Transparency = 0.1 }, 0.1) end)
        self.SearchBox.FocusLost:Connect(function(enter)
                Tween(sStroke, { Color = Lib.Theme.Stroke, Transparency = 0.3 }, 0.1)
                if enter then self:SearchStep(1) task.defer(function() self.SearchBox:CaptureFocus() end) end
        end)
        self.SearchBox:GetPropertyChangedSignal("Text"):Connect(function() self.SearchText = self.SearchBox.Text self:ApplySearch() end)
        -- pinned message bar
        self.PinBar = New("Frame", { Size = UDim2.new(1, -16, 0, 28), Position = UDim2.fromOffset(8, self.BaseTop - 4), BackgroundTransparency = 0, Visible = false,
                Theme = { BackgroundColor3 = "Field" }, Parent = frame })
        Corner(self.PinBar, 6) Stroke(self.PinBar, "Accent", 1, 0.65)
        Lib.Icon("pin", 13, "Accent", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 9, 0.5, 0), Parent = self.PinBar }, "*")
        self.PinText = New("TextButton", { Text = "", RichText = true, TextSize = 12, Size = UDim2.new(1, -92, 1, 0), Position = UDim2.fromOffset(28, 0), TextXAlignment = LEFT,
                TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = self.PinBar })
        self.PinCount = New("TextButton", { Text = "", TextSize = 11, Size = UDim2.fromOffset(34, 28), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -26, 0, 0), Theme = { TextColor3 = "Dim" }, Parent = self.PinBar })
        self.PinX = IconButton(self.PinBar, "x", "×", 20, "Unpin", "Bad", 1)
        self.PinX.Button.AnchorPoint, self.PinX.Button.Position = Vector2.new(1, 0.5), UDim2.new(1, -4, 0.5, 0)
        self.PinText.Activated:Connect(function() self:GotoPin() end)
        self.PinCount.Activated:Connect(function() if #self.Pinned > 1 then self.PinIdx = self.PinIdx % #self.Pinned + 1 self:_RefreshPin() end end)
        -- notifications panel (bell)
        self.NotifOpen = false
        self.NotifPanel = Sink(New("Frame", { Name = "Notifications", Position = UDim2.fromOffset(8, self.Top), Size = UDim2.new(1, -16, 1, -(self.Top + ih + 16)), BackgroundTransparency = 0,
                Visible = false, ZIndex = 15, Theme = { BackgroundColor3 = "Surface" }, Parent = frame }))
        Corner(self.NotifPanel, 6) Stroke(self.NotifPanel, "Stroke", 1, 0.2)
        New("TextLabel", { Text = "Mentions & replies", Font = Lib.FontBold, TextSize = 12, Size = UDim2.new(1, -130, 0, 28), Position = UDim2.fromOffset(10, 0), TextXAlignment = LEFT, ZIndex = 16, Parent = self.NotifPanel })
        local function TinyBtn(text, x, fn)
                local b = New("TextButton", { Text = text, TextSize = 11, Size = UDim2.fromOffset(56, 20), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, x, 0, 4), BackgroundTransparency = 0, ZIndex = 16,
                        Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = self.NotifPanel })
                Corner(b, 4)
                b.Activated:Connect(fn)
        end
        TinyBtn("Mark read", -66, function() for _, n in ipairs(self.Notifs) do n.read = true end self:_UpdateBell() self:RebuildNotifs() end)
        TinyBtn("Clear", -6, function() self.Notifs = {} self:_UpdateBell() self:RebuildNotifs() end)
        self.NotifList = New("ScrollingFrame", { Size = UDim2.new(1, -8, 1, -34), Position = UDim2.fromOffset(4, 30), AutomaticCanvasSize = Y, ScrollBarThickness = 2, ZIndex = 16, Parent = self.NotifPanel })
        List(self.NotifList, 2)
        self.ReplyBar = New("Frame", { Size = UDim2.new(1, -16, 0, 24), AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 8, 1, -(ih + 12)), BackgroundTransparency = 0, Visible = false,
                Theme = { BackgroundColor3 = "Field" }, Parent = frame })
        Corner(self.ReplyBar, 5)
        New("Frame", { Size = UDim2.new(0, 2, 1, -10), Position = UDim2.fromOffset(7, 5), Theme = { BackgroundColor3 = "Accent" }, Parent = self.ReplyBar })
        self.ReplyText = New("TextLabel", { Text = "", TextSize = 11, Size = UDim2.new(1, -52, 1, 0), Position = UDim2.fromOffset(16, 0), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd,
                RichText = true, Theme = { TextColor3 = "SubText" }, Parent = self.ReplyBar })
        local cancel = New("TextButton", { Text = "×", TextSize = 16, Size = UDim2.fromOffset(H(26), 24), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -2, 0, 0), Theme = { TextColor3 = "SubText" }, Parent = self.ReplyBar })
        cancel.Activated:Connect(function() self:SetReply(nil) end)
        local inputFrame = New("Frame", { Size = UDim2.new(1, -16, 0, ih), AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 8, 1, -8), BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Field" }, Parent = frame })
        Corner(inputFrame, 6)
        local inStroke = Stroke(inputFrame, "Stroke", 1, 0.3)
        local input = New("TextBox", { Text = "", PlaceholderText = cfg.Placeholder, PlaceholderColor3 = Lib.Theme.Dim, TextSize = 13, Size = UDim2.new(1, -(ih * 2 + 14), 1, 0), Position = UDim2.fromOffset(10, 0),
                TextXAlignment = LEFT, Parent = inputFrame })
        self.Input = input
        local sendBtn = New("TextButton", { Text = "", Size = UDim2.fromOffset(ih - 8, ih - 8), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -4, 0.5, 0), BackgroundTransparency = 0,
                Theme = { BackgroundColor3 = "Accent" }, Parent = inputFrame })
        Corner(sendBtn, 4)
        Lib.Icon("send", 13, "OnAccent", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Parent = sendBtn }, ">")
        -- image button: searches the internet for pictures / GIFs (the only way to send images now - no upload/link options)
        local plus = IconButton(inputFrame, "image", "•", ih - 8, "Search images on the internet", "Accent", 1)
        plus.Button.AnchorPoint, plus.Button.Position = Vector2.new(1, 0.5), UDim2.new(1, -ih, 0.5, 0)
        plus.Button.Activated:Connect(function() self:PickSearch() end)
        self.PlusBtn = plus.Button
        input.Focused:Connect(function() Tween(inStroke, { Color = Lib.Theme.Accent, Transparency = 0.1 }, 0.1) end)
        input.FocusLost:Connect(function(enter)
                Tween(inStroke, { Color = Lib.Theme.Stroke, Transparency = 0.3 }, 0.1)
                if enter then self:Send(input.Text) input.Text = "" end
        end)
        sendBtn.Activated:Connect(function() self:Send(input.Text) input.Text = "" end)
        input:GetPropertyChangedSignal("Text"):Connect(function() if #input.Text > cfg.MaxLength + 40 then input.Text = input.Text:sub(1, cfg.MaxLength + 40) end end)
        local sug = Sink(New("Frame", { Name = "Suggest", Visible = false, Size = UDim2.new(1, -16, 0, 0), AutomaticSize = Y, AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.new(0, 8, 1, -(ih + 14)), BackgroundTransparency = 0, ZIndex = 20, Theme = { BackgroundColor3 = "Surface" }, Parent = frame }))
        Corner(sug, 6) Stroke(sug) Pad(sug, 3, 3, 3, 3) List(sug, 0)
        local function Suggest()
                for _, c in ipairs(sug:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                local partial = input.Text:match("@([%w_]*)$")
                if not partial then sug.Visible = false return end
                partial = partial:lower()
                local cands, seen = {}, {}
                local function Add(name, display)
                        local l = tostring(name):lower()
                        if seen[l] or #cands >= 5 then return end
                        if l:sub(1, #partial) == partial or tostring(display or ""):lower():sub(1, #partial) == partial then
                                seen[l] = true
                                table.insert(cands, { name = name, display = display })
                        end
                end
                for _, u in ipairs(self.Users or {}) do
                        if tostring(u.uid) ~= tostring(LocalPlayer.UserId) then Add(u.name, u.display) end
                end
                if #cands == 0 then sug.Visible = false return end
                sug.Position = UDim2.new(0, 8, 1, -(ih + 14 + (self.ReplyTo and 28 or 0)))
                for i, c in ipairs(cands) do
                        local b = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, H(26)), LayoutOrder = i, ZIndex = 21, BackgroundTransparency = 1, BackgroundColor3 = Lib.Theme.FieldHover, Parent = sug })
                        Corner(b, 4)
                        New("TextLabel", { RichText = true, Text = "<b>@" .. RichEsc(c.name) .. "</b> <font color='#" .. ToHex(Lib.Theme.Dim) .. "'>" .. RichEsc(c.display or "") .. "</font>",
                                TextSize = 12, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(9, 0), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 22, Parent = b })
                        b.MouseEnter:Connect(function() Tween(b, { BackgroundTransparency = 0.3 }, 0.06) end)
                        b.MouseLeave:Connect(function() Tween(b, { BackgroundTransparency = 1 }, 0.08) end)
                        local picked = false
                        local function Pick()
                                if picked then return end
                                picked = true
                                input.Text = (input.Text:gsub("@[%w_]*$", function() return "@" .. c.name .. " " end))
                                sug.Visible = false
                                task.defer(function() input:CaptureFocus() end)
                        end
                        b.InputBegan:Connect(function(i) if IsPress(i) then Pick() end end)
                        b.Activated:Connect(Pick)
                end
                sug.Visible = true
        end
        input:GetPropertyChangedSignal("Text"):Connect(Suggest)
        input.FocusLost:Connect(function()
                task.delay(0.3, function()
                        if sug.Parent and not input:IsFocused() then sug.Visible = false end
                end)
        end)
        local acc = 0
        Lib:Connect(RunService.Heartbeat, function(dt)
                acc = acc + dt
                if acc < 0.4 then return end
                acc = 0
                self:_UpdateInput()
        end)
        self:_Relayout()
        Lib:_FinishPanel(panel)
        self:SetStatus("Connecting")
        if not cfg.Url then
                self:SetStatus("No server")
                self:System("No chat server set.")
        elseif not self.Request then
                self:SetStatus("Offline")
                self:System("Your executor has no HTTP request function, so chat can't connect.")
        else
                self:System("Tap a message for options. Type @ to mention someone.")
                self:_StartPolling()
        end
        Lib:LoadBlocks()
        self:_StartPeeking()
        Lib.ChatObj = self
        return self
end

function Chat:_RefreshChannel()
        if not self.ChLabel then return end
        local ch = self.Channels[self.ChIndex]
        if not ch then return end
        local here = ch.id and tonumber(ch.id) == game.PlaceId
        local others = 0
        for i, c in ipairs(self.Channels) do if i ~= self.ChIndex then others = others + (c.unread or 0) end end
        -- # channels, @ direct messages, « » group chats
        local mark, name = "#", tostring(ch.name or "?")
        if ch.kind == "dm" then
                mark = "@"
        elseif ch.kind == "grp" then
                mark, name = "«", name .. "»"
        end
        self.ChLabel.Text = "<font color='#" .. ToHex(Lib.Theme.Accent) .. "'><b>" .. mark .. "</b></font> " .. RichEsc(name)
                .. (here and (" <font color='#" .. ToHex(Lib.Theme.Dim) .. "'>· current game</font>") or "")
                .. (#self.Channels > 1 and (" <font color='#" .. ToHex(Lib.Theme.Dim) .. "'>(" .. self.ChIndex .. "/" .. #self.Channels .. ")</font>") or "")
                .. (others > 0 and (" <font color='#" .. ToHex(Lib.Theme.Bad) .. "'><b>● " .. (others > 9 and "9+" or tostring(others)) .. "</b></font>") or "")
end

function Chat:ChannelMenu()
        local items = {}
        local function Chan(i, ch, label)
                local here = ch.id and tonumber(ch.id) == game.PlaceId
                local n = (i ~= self.ChIndex) and (ch.unread or 0) or 0
                table.insert(items, { Text = (i == self.ChIndex and "• " or "   ") .. label .. (here and "  (here)" or "") .. (n > 0 and ("  [" .. n .. " new]") or ""),
                        Callback = function() self:SetChannel(i) end })
        end
        local nd, ng = 0, 0
        for i, ch in ipairs(self.Channels) do
                if ch.kind == "dm" then nd = nd + 1
                elseif ch.kind == "grp" then ng = ng + 1
                else Chan(i, ch, "#" .. tostring(ch.name)) end
        end
        local cur = self.Channels[self.ChIndex]
        if nd > 0 then
                table.insert(items, { Header = true, Text = "DIRECT MESSAGES" })
                for i, ch in ipairs(self.Channels) do
                        if ch.kind == "dm" then Chan(i, ch, "@" .. Short(ch.name, 16)) end
                end
        end
        if ng > 0 then
                table.insert(items, { Header = true, Text = "GROUP CHATS · MAX 10" })
                for i, ch in ipairs(self.Channels) do
                        if ch.kind == "grp" then Chan(i, ch, "«" .. Short(ch.name, 13) .. "»" .. (#(ch.members or {}) > 0 and ("  " .. #(ch.members or {}) .. "/10") or "")) end
                end
        end
        table.insert(items, { Header = true, Text = "START" })
        table.insert(items, { Text = "New DM...", Callback = function()
                self:PickUser(function(u) self:OpenDM(u.uid, u.name, u.display) end, "DM who?")
        end })
        table.insert(items, { Text = "New group chat...", Callback = function() self:NewGroup() end })
        if cur and cur.kind == "dm" then
                table.insert(items, { Text = "Close this DM", Danger = true, Callback = function()
                        self:_RemoveChannel(cur)
                end })
        end
        if cur and cur.kind == "grp" then
                table.insert(items, { Text = "Rename group...", Callback = function() self:RenameGroup(cur.gid) end })
                table.insert(items, { Text = "Invite member...", Callback = function() self:InviteToGroup(cur.gid) end })
                table.insert(items, { Text = "Leave group", Danger = true, Callback = function()
                        Lib:Dialog({ Title = "Leave group", Text = "Leave «" .. cur.name .. "»? Someone has to invite you back in.",
                                Buttons = { { Text = "Cancel" }, { Text = "Leave", Primary = true, Callback = function()
                                        task.spawn(function()
                                                local d = Decode(self:_Do("/group/leave", nil, "POST", HttpService:JSONEncode({ id = cur.gid })))
                                                if d and d.ok then
                                                        self:_RemoveChannel(cur)
                                                        Lib:Notify({ Title = "Group chat", Text = "You left «" .. cur.name .. "».", Type = "success", Duration = 3 })
                                                else
                                                        Lib:Notify({ Title = "Group chat", Text = (d and d.error) or "Couldn't leave the group.", Type = "error" })
                                                end
                                        end)
                                end } } })
                end })
        end
        self:Menu(items, self.ChBtn)
end

function Chat:SetChannel(i)
        local ch = self.Channels[i]
        if not ch or i == self.ChIndex then return end
        local old = self.Channels[self.ChIndex]
        if old then old.read, old.unread = self.LastId, 0 end
        ch.unread = 0
        self.ChIndex, self.Room = i, ch.room
        self.Gen = self.Gen + 1
        self.LastId, self.Seen, self.Known, self.Loaded, self.Fails = -1, {}, {}, false, 0
        self.JumpCount, self.Stick = 0, true
        self:SetReply(nil)
        if self.SearchOpen then self:ToggleSearch(false) end
        self:_ClearAll()
        self:SetPinned({})
        self:_RefreshChannel()
        if ch.kind == "dm" then
                self:System("Direct messages with " .. tostring(ch.name) .. " — only you two see these.")
        elseif ch.kind == "grp" then
                self:System("Group chat «" .. tostring(ch.name) .. "» — up to 10 members.")
        else
                self:System("Joined #" .. tostring(ch.name))
        end
        if self.Alive then
                task.spawn(function() self:_PollOnce() end)
        else
                self:Reconnect()
        end
end

function Chat:ScrollBottom()
        self.Stick = true
        self.JumpCount = 0
        self.Jump.Visible = false
        self.List.CanvasPosition = Vector2.new(0, math.max(0, self.List.AbsoluteCanvasSize.Y - self.List.AbsoluteSize.Y))
end

function Chat:_UpdateInput()
        local input = self.Input
        local ph, editable = self.Config.Placeholder, true
        if self.Blocked then ph, editable = self.Blocked, false end
        local key = ph .. tostring(editable)
        if key == self._inState then return end
        self._inState = key
        input.PlaceholderText = ph
        input.TextEditable = editable
end

function Chat:SetStatus(state, text)
        local colors = { Connected = "Good", Connecting = "Warn", Offline = "Bad", ["No server"] = "Dim" }
        self.Pill.Text = text or state
        self.Dot.BackgroundColor3 = Lib.Theme[colors[state] or "Good"]
        self.State = state
end

function Chat:SetVisible(s) self.PanelObj:Set(s) end

function Chat:SetReply(msg)
        self.ReplyTo = msg
        if msg then
                self.ReplyBar.Visible = true
                self.ReplyText.Text = "Replying to <b><font color='#" .. ToHex(Lib.Theme.Accent) .. "'>" .. RichEsc(msg.name) .. "</font></b> " .. RichEsc(msg.text)
                self:_Relayout()
                self.Input:CaptureFocus()
        else
                self.ReplyBar.Visible = false
                self:_Relayout()
        end
end

function Chat:_Trim()
        while #self.Items > self.Config.MaxMessages do
                local item = table.remove(self.Items, 1)
                if item then item:Destroy() end
        end
end

function Chat:System(text)
        self.Counter = self.Counter + 1
        self.LastUid, self.LastTs = nil, nil
        local holder = New("Frame", { Name = "System", Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = self.Counter, Parent = self.List })
        local label = New("TextLabel", { Text = tostring(text), TextSize = 11, Size = UDim2.new(1, -16, 0, 14), Position = UDim2.fromOffset(8, 4), TextXAlignment = CENTER,
                TextYAlignment = Enum.TextYAlignment.Top, Theme = { TextColor3 = "Dim" }, Parent = holder })
        Wrap(label, holder, 8, 14)
        table.insert(self.Items, holder)
        self:_Trim()
end

function Chat:_Remove(id)
        local item = self.ByLid[id]
        if not item then return end
        self.ByLid[id], self.ByBubble[id] = nil, nil
        local i = table.find(self.Items, item)
        if i then table.remove(self.Items, i) end
        item:Destroy()
end

function Chat:_ClearAll()
        for _, it in ipairs(self.Items) do it:Destroy() end
        self.Items, self.ByLid, self.ByBubble, self.LastUid, self.LastTs = {}, {}, {}, nil, nil
end

function Chat:_Flash(id)
        local b = self.ByBubble[id]
        if b and b.Parent then
                local rest = b:GetAttribute("rest") or 0
                b.BackgroundTransparency = math.max(rest - 0.5, 0)
                Tween(b, { BackgroundTransparency = rest }, 0.9)
        end
end

function Chat:_JumpTo(id)
        local item = self.ByLid[id]
        if not item or not item.Parent then return end
        local y = item.AbsolutePosition.Y - self.List.AbsolutePosition.Y + self.List.CanvasPosition.Y - 8
        Tween(self.List, { CanvasPosition = Vector2.new(0, math.max(0, y)) }, 0.25, Enum.EasingStyle.Quint)
        self:_Flash(id)
end

function Chat:Menu(items, anchor)
        local usable = {}
        for _, it in ipairs(items) do if it.Text and it.Text ~= "" then table.insert(usable, it) end end
        if #usable == 0 then return end
        local w, rh = 190, H(26)
        local h = 6
        for _, it in ipairs(usable) do h = h + (it.Header and H(18) or rh) end
        local sc = Lib.Scale
        local menu = Sink(New("Frame", { Size = UDim2.fromOffset(w, h), BackgroundTransparency = 0, ZIndex = 85, Theme = { BackgroundColor3 = "Surface" }, Parent = Lib.Overlay }))
        Corner(menu, 6) Stroke(menu, "Stroke", 1, 0) List(menu, 0) Pad(menu, 3, 3, 3, 3)
        New("UIScale", { Scale = sc, Parent = menu })
        for i, it in ipairs(usable) do
                if it.Header then
                        New("TextLabel", { Text = it.Text, Font = Lib.FontBold, TextSize = 9, Size = UDim2.new(1, 0, 0, H(18)), LayoutOrder = i, TextXAlignment = LEFT, ZIndex = 86,
                                Theme = { TextColor3 = "Dim" }, Parent = menu })
                else
                        local b = New("TextButton", { Text = it.Text, TextSize = 12, Size = UDim2.new(1, 0, 0, rh), LayoutOrder = i, TextXAlignment = LEFT, ZIndex = 86,
                                BackgroundTransparency = 1, BackgroundColor3 = Lib.Theme.FieldHover, TextColor3 = it.Danger and Lib.Theme.Bad or Lib.Theme.Text, TextTruncate = Enum.TextTruncate.AtEnd, Parent = menu })
                        Corner(b, 4) Pad(b, 9, 0, 8, 0)
                        b.MouseEnter:Connect(function() Tween(b, { BackgroundTransparency = 0.3 }, 0.06) end)
                        b.MouseLeave:Connect(function() Tween(b, { BackgroundTransparency = 1 }, 0.08) end)
                        Press(b, function() Lib:ClosePopup() Safe(it.Callback) end)
                end
        end
        local pos
        if typeof(anchor) == "Instance" then pos = PlaceBelow(anchor, w * sc, h * sc, 4, false) else pos = PlaceAt(anchor, w * sc, h * sc) end
        menu.Position = UDim2.fromOffset(pos.X, pos.Y)
        Lib:OpenPopup(menu, function() menu:Destroy() end, typeof(anchor) == "Instance" and anchor or nil)
end

function Chat:Prefill(text) self.Input.Text = text self.Input:CaptureFocus() end

-- ── direct messages & group chats ─────────────────────────────────────────────
-- Rooms: channels stay "global"/"game-<id>", DMs live in "dm:<smallerId>|<biggerId>",
-- groups in "grp:<id>" (the relay validates membership server side). Both sides discover
-- their DMs/groups from the /poll response, so the tab list fills itself in.

local MAX_GROUP = 10

function Chat:DMRoom(uid)
        local a = tonumber(uid)
        if not a then return nil end
        return "dm:" .. math.min(a, LocalPlayer.UserId) .. "|" .. math.max(a, LocalPlayer.UserId)
end

function Chat:_RoomIndex(room)
        for i, ch in ipairs(self.Channels) do if ch.room == room then return i end end
        return nil
end

function Chat:_FindRoom(room)
        for _, ch in ipairs(self.Channels) do if ch.room == room then return ch end end
        return nil
end

function Chat:_RemoveChannel(ch)
        local idx
        for i, c in ipairs(self.Channels) do if c == ch or (ch.room and c.room == ch.room) then idx = i break end end
        if not idx then return end
        table.remove(self.Channels, idx)
        if #self.Channels == 0 then return end
        if self.ChIndex == idx then
                self.ChIndex = 0 -- the open channel vanished; SetChannel(1) rebuilds the view
                self:SetChannel(1)
        elseif self.ChIndex > idx then
                self.ChIndex = self.ChIndex - 1 -- the list shifted under the view, same channel still open
                self:_RefreshChannel()
        else
                self:_RefreshChannel()
        end
        self:SaveConvos()
end

-- remembers the DMs + groups you have open, so they're still there next time you load
function Chat:SaveConvos()
        if self._loading or type(writefile) ~= "function" then return end
        local rooms = {}
        for _, ch in ipairs(self.Channels) do
                if ch.kind == "dm" and ch.uid then
                        table.insert(rooms, { kind = "dm", uid = tonumber(ch.uid), name = tostring(ch.name or "") })
                elseif ch.kind == "grp" and ch.gid then
                        local members = {}
                        for _, v in ipairs(ch.members or {}) do
                                local n = tonumber(v)
                                if n then table.insert(members, n) end
                        end
                        table.insert(rooms, { kind = "grp", gid = tostring(ch.gid), name = tostring(ch.name or ""), members = members,
                                owner = tonumber(ch.owner) })
                end
        end
        pcall(function()
                if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                writefile(Lib.ConfigFolder .. "/convos.json", HttpService:JSONEncode({ v = 1, rooms = rooms }))
        end)
end

function Chat:LoadConvos()
        if self._convosLoaded or type(readfile) ~= "function" or type(isfile) ~= "function" then return end
        self._convosLoaded = true
        local ok, raw = pcall(function()
                local p = Lib.ConfigFolder .. "/convos.json"
                if isfile(p) then return readfile(p) end
        end)
        if not (ok and type(raw) == "string" and Trim(raw) ~= "") then return end
        local okd, d = pcall(function() return HttpService:JSONDecode(raw) end)
        if not (okd and type(d) == "table" and type(d.rooms) == "table") then return end
        self._loading = true
        for _, r in ipairs(d.rooms) do
                if r.kind == "dm" then
                        local uid = tonumber(r.uid)
                        if uid and uid ~= LocalPlayer.UserId then
                                local ch = self:AddDM(uid, r.name, r.name)
                                if ch then
                                        -- tell the relay this DM exists again, so the other side finds it too
                                        task.spawn(function()
                                                local q = { after = -1, peer = uid }
                                                if r.name and r.name ~= "" then q.peer_name = tostring(r.name) end
                                                self:_Do("/poll", q, nil, nil, ch.room)
                                        end)
                                end
                        end
                elseif r.kind == "grp" and r.gid ~= nil then
                        -- if you're not a member anymore the next poll says "removed" and cleans it up
                        self:AddGroup({ id = r.gid, name = r.name, members = r.members or {} })
                end
        end
        self._loading = nil
        self:SaveConvos()
        self:_RefreshChannel()
end

function Chat:AddDM(uid, name, display)
        uid = tonumber(uid)
        if not uid or uid == LocalPlayer.UserId then return nil end
        local room = self:DMRoom(uid)
        if not room or self:_RoomIndex(room) then return nil end
        table.insert(self.Channels, { kind = "dm", name = tostring(display ~= "" and display or name or uid), uid = uid, room = room, read = 0, unread = 0 })
        self:_RefreshChannel()
        self:SaveConvos()
        return self.Channels[#self.Channels]
end

function Chat:AddGroup(g)
        if type(g) ~= "table" or g.id == nil then return nil end
        local room = "grp:" .. tostring(g.id)
        local have = self:_RoomIndex(room)
        if have then
                local ch = self.Channels[have]
                if g.name and g.name ~= "" then ch.name = tostring(g.name) end
                ch.members = g.members or ch.members
                self:_RefreshChannel()
                self:SaveConvos()
                return ch
        end
        table.insert(self.Channels, { kind = "grp", name = tostring(g.name or "Group"), gid = tostring(g.id), members = g.members or {}, room = room, read = 0, unread = 0 })
        self:_RefreshChannel()
        self:SaveConvos()
        return self.Channels[#self.Channels]
end

-- every /poll carries the DMs + groups this account belongs to; merge them into the tab list
function Chat:_SyncRooms(dms, groups)
        local dms, groups = type(dms) == "table" and dms or {}, type(groups) == "table" and groups or {}
        local changed = false
        for _, d in ipairs(dms) do
                local uid = tonumber(d.uid)
                if uid and uid ~= LocalPlayer.UserId and not self:_RoomIndex(self:DMRoom(uid)) then
                        self:AddDM(uid, d.name, d.display)
                        changed = true
                end
        end
        local seen = {}
        for _, g in ipairs(groups) do
                seen[tostring(g.id)] = true
                if g.id and not self:_RoomIndex("grp:" .. tostring(g.id)) then
                        self:AddGroup(g)
                        changed = true
                elseif g.id then
                        local have = self:_RoomIndex("grp:" .. tostring(g.id))
                        if have then
                                local ch = self.Channels[have]
                                if g.name and g.name ~= "" and ch.name ~= tostring(g.name) then ch.name = tostring(g.name) changed = true end
                                if g.members then ch.members = g.members end
                        end
                end
        end
        -- a group the relay stopped returning = you left, or it was closed
        for i = #self.Channels, 1, -1 do
                local ch = self.Channels[i]
                if ch.kind == "grp" and not seen[ch.gid] then
                        table.remove(self.Channels, i)
                        changed = true
                        if self.ChIndex >= i then self:SetChannel(1) end
                end
        end
        if changed then self:_RefreshChannel() end
end

-- open (or switch to) a DM with someone
function Chat:OpenDM(uid, name, display)
        uid = tonumber(uid)
        if not uid then return end
        local room = self:DMRoom(uid)
        if not room then return end
        local idx = self:_RoomIndex(room)
        if not idx then
                self:AddDM(uid, name, display)
                idx = self:_RoomIndex(room)
        end
        -- introduce the DM to the relay (it stores both profiles so the other side sees it on their next poll)
        task.spawn(function()
                local q = { after = -1, peer = uid }
                if name and name ~= "" then q.peer_name = tostring(name) end
                if display and display ~= "" then q.peer_display = tostring(display) end
                self:_Do("/poll", q, nil, nil, room)
        end)
        if idx then self:SetChannel(idx) end
end

function Chat:PickUser(cb, title)
        if type(cb) ~= "function" then return end
        self:ShowUsers({ Title = title or "Pick someone", Callback = cb })
end

-- create a group chat: name it, pick up to 9 people (10 with you), done
function Chat:NewGroup(preselect)
        local picked = {}
        if type(preselect) == "table" then
                if preselect.uid then picked[tostring(preselect.uid)] = preselect
                else for _, u in ipairs(preselect) do if u and u.uid then picked[tostring(u.uid)] = u end end end
        end
        local users = {}
        for _, u in ipairs(self.Users or {}) do
                if tostring(u.uid) ~= tostring(LocalPlayer.UserId) and not picked[tostring(u.uid)] then table.insert(users, u) end
        end
        for _, u in pairs(picked) do table.insert(users, u) end
        table.sort(users, function(a, b) return tostring(a.display or a.name):lower() < tostring(b.display or b.name):lower() end)
        local rh, w, h = H(30), 250, H(360)
        local frame = Sink(New("Frame", { Size = UDim2.fromOffset(w, h), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0, ZIndex = 85,
                Theme = { BackgroundColor3 = "Surface" }, Parent = Lib.Overlay }))
        Corner(frame, 8) Stroke(frame, "Stroke", 1, 0) Pad(frame, 12, 12, 12, 12) List(frame, 8)
        New("UIScale", { Scale = math.min(1, Lib.Overlay.AbsoluteSize.X / (w + 20), Lib.Overlay.AbsoluteSize.Y / (h + 20)), Parent = frame })
        New("TextLabel", { Text = "New group chat", Font = Lib.FontBold, TextSize = 13, Size = UDim2.new(1, 0, 0, 18), TextXAlignment = LEFT, ZIndex = 86, Parent = frame })
        local nameBox = New("TextBox", { Text = "", PlaceholderText = "Group name (rename it any time)", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 12,
                Size = UDim2.new(1, 0, 0, H(28)), BackgroundTransparency = 0, TextXAlignment = LEFT, ZIndex = 86, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = frame })
        Corner(nameBox, 5) Pad(nameBox, 8, 0, 8, 0) Stroke(nameBox, "Stroke", 1, 0.3)
        local counter = New("TextLabel", { Text = "", TextSize = 10, Size = UDim2.new(1, 0, 0, 12), TextXAlignment = RIGHT, ZIndex = 86, Theme = { TextColor3 = "Dim" }, Parent = frame })
        local list = New("ScrollingFrame", { Size = UDim2.new(1, 0, 1, -110), AutomaticCanvasSize = Y, ScrollBarThickness = 2, ZIndex = 86, Parent = frame })
        List(list, 2)
        local row = New("Frame", { Size = UDim2.new(1, 0, 0, H(28)), BackgroundTransparency = 1, ZIndex = 86, Parent = frame })
        List(row, 6, Enum.FillDirection.Horizontal)
        local function Count()
                local n = 0
                for _ in pairs(picked) do n = n + 1 end
                counter.Text = "You + " .. n .. " member" .. (n == 1 and "" or "s") .. "  ·  " .. (n + 1) .. "/" .. MAX_GROUP
                return n
        end
        local function Build()
                for _, c in ipairs(list:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
                if #users == 0 then
                        New("TextLabel", { Text = "Nobody else is online here right now.", TextSize = 11, Size = UDim2.new(1, 0, 0, 16), ZIndex = 87, Theme = { TextColor3 = "Dim" }, Parent = list })
                end
                for i, u in ipairs(users) do
                        local id = tostring(u.uid)
                        local b = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, rh), LayoutOrder = i, ZIndex = 87, BackgroundTransparency = 1, BackgroundColor3 = Lib.Theme.FieldHover, Parent = list })
                        Corner(b, 4)
                        local box = New("Frame", { Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 6, 0.5, 0), ZIndex = 88,
                                BackgroundTransparency = 0, Theme = { BackgroundColor3 = picked[id] and "Accent" or "Field" }, Parent = b })
                        Corner(box, 4) Stroke(box, "Stroke", 1, 0.4)
                        if picked[id] then
                                New("TextLabel", { Text = "✓", Font = Lib.FontBold, TextSize = 11, Size = UDim2.fromScale(1, 1), TextColor3 = Lib.KnobOn(), ZIndex = 89, Parent = box })
                        end
                        New("TextLabel", { Text = RichEsc(u.display or u.name) .. " <font color='#" .. ToHex(Lib.Theme.Dim) .. "'>@" .. RichEsc(tostring(u.name)) .. "</font>", RichText = true,
                                TextSize = 12, Size = UDim2.new(1, -32, 1, 0), Position = UDim2.fromOffset(28, 0), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 88, Parent = b })
                        b.MouseEnter:Connect(function() Tween(b, { BackgroundTransparency = 0.35 }, 0.06) end)
                        b.MouseLeave:Connect(function() Tween(b, { BackgroundTransparency = 1 }, 0.08) end)
                        b.Activated:Connect(function()
                                if picked[id] then
                                        picked[id] = nil
                                elseif Count() >= MAX_GROUP - 1 then
                                        Lib:Notify({ Title = "Group chat", Text = "A group holds at most " .. MAX_GROUP .. " people, including you.", Type = "warn", Duration = 4 })
                                        return
                                else
                                        picked[id] = u
                                end
                                Build()
                        end)
                end
                Count()
        end
        Build()
        local cancel = New("TextButton", { Text = "Cancel", TextSize = 12, Size = UDim2.new(0.5, -3, 1, 0), BackgroundTransparency = 0, ZIndex = 87,
                Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = row })
        Corner(cancel, 5)
        local create = New("TextButton", { Text = "Create group", TextSize = 12, Size = UDim2.new(0.5, -3, 1, 0), Position = UDim2.new(0.5, 3, 0, 0), BackgroundTransparency = 0, ZIndex = 87,
                Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = row })
        Corner(create, 5)
        cancel.Activated:Connect(function() Lib:ClosePopup() end)
        create.Activated:Connect(function()
                local name = Trim(nameBox.Text)
                if name == "" then Lib:Notify({ Text = "Give the group a name first.", Type = "warn" }) return end
                local members = {}
                for _, u in pairs(picked) do table.insert(members, tonumber(u.uid) or u.uid) end
                if #members < 1 then Lib:Notify({ Text = "Pick at least one member.", Type = "warn" }) return end
                create.Text = "Creating..."
                task.spawn(function()
                        local d = Decode(self:_Do("/group", nil, "POST", HttpService:JSONEncode({ name = name:sub(1, 32), members = members })))
                        if d and d.ok and d.group then
                                Lib:ClosePopup()
                                self:AddGroup(d.group)
                                local idx = self:_RoomIndex("grp:" .. tostring(d.group.id))
                                if idx then self:SetChannel(idx) end
                                Lib:Notify({ Title = "Group chat", Text = "«" .. name .. "» is live. Up to " .. MAX_GROUP .. " people.", Type = "success", Duration = 4 })
                        else
                                create.Text = "Create group"
                                Lib:Notify({ Title = "Group chat", Text = (d and d.error) or "Couldn't create the group. Is your worker updated?", Type = "error" })
                        end
                end)
        end)
        Lib:OpenPopup(frame, function() if frame.Parent then frame:Destroy() end end)
end

-- gid = nil: pick which group (or make a new one). gid set: pick who to invite into it.
function Chat:InviteToGroup(gid, preselect)
        local groups = {}
        for _, ch in ipairs(self.Channels) do if ch.kind == "grp" then table.insert(groups, ch) end end
        if not gid then
                if #groups == 0 then self:NewGroup(preselect) return end
                local items = {}
                for _, g in ipairs(groups) do
                        table.insert(items, { Text = "«" .. Short(g.name, 15) .. "»", Callback = function() self:InviteToGroup(g.gid, preselect) end })
                end
                table.insert(items, { Text = "New group with them...", Callback = function() self:NewGroup(preselect) end })
                self:Menu(items, self.LastPtr)
                return
        end
        self:PickUser(function(u)
                task.spawn(function()
                        local d = Decode(self:_Do("/group/invite", nil, "POST", HttpService:JSONEncode({ id = gid, uid = tonumber(u.uid) })))
                        if d and d.ok then
                                Lib:Notify({ Title = "Group chat", Text = "Invited " .. tostring(u.display or u.name) .. ".", Type = "success", Duration = 3 })
                        else
                                Lib:Notify({ Title = "Group chat", Text = (d and d.error) or "Couldn't invite them.", Type = "error" })
                        end
                end)
        end, "Invite who?")
end

function Chat:RenameGroup(gid)
        if not gid then return end
        Lib:Prompt({ Title = "Rename group", Text = "New name (only the creator can rename).", Placeholder = "Group name", Confirm = "Rename" }, function(t)
                t = Trim(t)
                if t == "" then return end
                task.spawn(function()
                        local d = Decode(self:_Do("/group/rename", nil, "POST", HttpService:JSONEncode({ id = gid, name = t:sub(1, 32) })))
                        if d and d.ok then
                                for _, ch in ipairs(self.Channels) do
                                        if ch.gid == gid then ch.name = t end
                                end
                                self:_RefreshChannel()
                                self:SaveConvos()
                                Lib:Notify({ Title = "Group chat", Text = "Renamed to «" .. t .. "».", Type = "success", Duration = 3 })
                        else
                                Lib:Notify({ Title = "Group chat", Text = (d and d.error) or "Couldn't rename.", Type = "error" })
                        end
                end)
        end)
end

function Chat:MessageMenu(msg)
        local items = {}
        local name = tostring(msg.display ~= "" and msg.display or msg.name or "?")
        local mine = tostring(msg.uid) == tostring(LocalPlayer.UserId)
        table.insert(items, { Text = "View profile", Callback = function() self:ShowProfile(msg) end })
        if msg.id then table.insert(items, { Text = "Reply", Callback = function() self:SetReply({ id = msg.id, name = name, text = tostring(msg.text ~= "" and msg.text or "[image]"):sub(1, 70) }) end }) end
        if mine and msg.id then table.insert(items, { Text = "Edit message", Callback = function() self:EditMessage(msg) end }) end
        table.insert(items, { Text = "Mention", Callback = function() self:Prefill(self.Input.Text .. "@" .. tostring(msg.name) .. " ") end })
        if type(setclipboard) == "function" and tostring(msg.text or "") ~= "" then table.insert(items, { Text = "Copy text", Callback = function() setclipboard(tostring(msg.text)) end }) end
        local link = tostring(msg.text or ""):match("https?://[^%s<>\"]+")
        if link and type(setclipboard) == "function" then
                link = link:gsub("[%.,;:!%?%)%]]+$", "")
                table.insert(items, { Text = "Copy link", Callback = function() Copy(link, "Link copied") end })
        end
        if not mine and msg.uid then
                local blocked = Lib:IsBlocked(msg.uid)
                table.insert(items, { Text = blocked and "Unblock user" or "Block user", Danger = not blocked, Callback = function()
                        if blocked then Lib:Unblock(msg.uid) else Lib:Block(msg.uid, name) end
                end })
        end
        self:Menu(items, self.LastPtr)
end

function Chat:UserMenu(user, anchor)
        local name = tostring(user.display or user.name)
        local items = { { Text = "View profile", Callback = function() self:ShowProfile(user) end },
                { Text = "Mention", Callback = function() self:Prefill(self.Input.Text .. "@" .. tostring(user.name) .. " ") end } }
        if type(setclipboard) == "function" then table.insert(items, { Text = "Copy user id", Callback = function() setclipboard(tostring(user.uid)) end }) end
        if tostring(user.uid) ~= tostring(LocalPlayer.UserId) then
                local blocked = Lib:IsBlocked(user.uid)
                table.insert(items, { Text = blocked and "Unblock user" or "Block user", Danger = not blocked, Callback = function()
                        if blocked then Lib:Unblock(user.uid) else Lib:Block(user.uid, name) end
                end })
        end
        self:Menu(items, anchor)
end

local ProfileCache = {}

-- Click an avatar: account info, game info and a join button (needs place/job from the chat server, see notes).
function Chat:ShowProfile(u)
        local uid = tonumber(u.uid)
        if not uid then return end
        local info = {}
        for k, v in pairs(u) do info[k] = v end
        for _, x in ipairs(self.Users or {}) do
                if tostring(x.uid) == tostring(uid) then for k, v in pairs(x) do if info[k] == nil then info[k] = v end end end
        end
        local frd = self.Friends.byId[tostring(uid)]
        if frd then for k, v in pairs(frd) do if info[k] == nil then info[k] = v end end end
        local plr = Players:GetPlayerByUserId(uid)
        if plr then info.place, info.job = info.place or game.PlaceId, info.job or game.JobId end
        local name = tostring(info.name or (plr and plr.Name) or uid)
        local display = tostring(info.display ~= nil and info.display ~= "" and info.display or name)
        local dim = New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.5, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 100, Parent = Lib.Overlay })
        local card = Sink(New("Frame", { Size = UDim2.fromOffset(300, 0), AutomaticSize = Y, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 101,
                Theme = { BackgroundColor3 = "Bg" }, Parent = dim }))
        Corner(card, 8) Stroke(card) Pad(card, 14, 14, 14, 14) List(card, 6)
        New("UIScale", { Scale = math.min(1, Lib.Overlay.AbsoluteSize.X / 330, Lib.Overlay.AbsoluteSize.Y / 560), Parent = card })
        local function Close() if dim.Parent then dim:Destroy() end end
        dim.Activated:Connect(Close)
        local order = 0
        local function O() order = order + 1 return order end
        local head = New("Frame", { Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 1, LayoutOrder = O(), ZIndex = 102, Parent = card })
        local pic = New("ImageLabel", { Size = UDim2.fromOffset(56, 56), BackgroundTransparency = 0, ZIndex = 103, Theme = { BackgroundColor3 = "Field" }, Parent = head })
        Corner(pic, 28)
        GetAvatar(uid, function(url) if pic.Parent then pic.Image = url end end, "AvatarBust", "Size180x180")
        New("TextLabel", { Text = RichEsc(display), Font = Lib.FontBold, TextSize = 15, Size = UDim2.new(1, -68, 0, 18), Position = UDim2.fromOffset(68, 8), TextXAlignment = LEFT,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 103, Parent = head })
        New("TextLabel", { Text = "@" .. name, TextSize = 12, Size = UDim2.new(1, -68, 0, 14), Position = UDim2.fromOffset(68, 27), TextXAlignment = LEFT, ZIndex = 103,
                TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = head })
        local bioBox = New("Frame", { Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 0.2, LayoutOrder = O(), ZIndex = 102, Visible = false,
                Theme = { BackgroundColor3 = "Field" }, Parent = card })
        Corner(bioBox, 8) Stroke(bioBox, "Accent", 1, 0.6)
        local bioBar = New("Frame", { Size = UDim2.new(0, 3, 1, -16), Position = UDim2.fromOffset(8, 8), ZIndex = 103, Theme = { BackgroundColor3 = "Accent" }, Parent = bioBox })
        Corner(bioBar, 2)
        New("TextLabel", { Text = "ABOUT ME", Font = Lib.FontBold, TextSize = 10, Size = UDim2.new(1, -32, 0, 12), Position = UDim2.fromOffset(20, 8),
                TextXAlignment = LEFT, ZIndex = 103, Theme = { TextColor3 = "Accent" }, Parent = bioBox })
        local bioLabel = New("TextLabel", { Text = "", TextSize = 14, Size = UDim2.new(1, -32, 0, 16), Position = UDim2.fromOffset(20, 23),
                TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 103, Theme = { TextColor3 = "Text" }, Parent = bioBox })
        Wrap(bioLabel, bioBox, 33, 16)
        local function SetBio(t)
                t = Trim(tostring(t or ""))
                if t == "" and uid == LocalPlayer.UserId then t = "No bio yet. Set one in Settings > Interface > Chat." end
                if bioLabel.Parent then bioLabel.Text, bioBox.Visible = t, t ~= "" end
        end
        SetBio(uid == LocalPlayer.UserId and Lib:LoadBio() or info.bio)
        if uid ~= LocalPlayer.UserId then
                task.spawn(function()
                        local d = Decode(self:_Do("/profile", { target = uid }))
                        if d and d.ok and d.user then SetBio(d.user.bio) end
                end)
        end
        local function Section(t)
                New("TextLabel", { Text = string.upper(t), Font = Lib.FontBold, TextSize = 10, Size = UDim2.new(1, 0, 0, 16), TextXAlignment = LEFT, LayoutOrder = O(), ZIndex = 102,
                        Theme = { TextColor3 = "Dim" }, Parent = card })
        end
        local function Row(label, value)
                local r = New("Frame", { Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, LayoutOrder = O(), ZIndex = 102, Parent = card })
                New("TextLabel", { Text = label, TextSize = 12, Size = UDim2.new(0.4, 0, 1, 0), TextXAlignment = LEFT, ZIndex = 103, Theme = { TextColor3 = "SubText" }, Parent = r })
                return New("TextLabel", { Text = tostring(value), TextSize = 12, Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.fromScale(0.4, 0), TextXAlignment = RIGHT, ZIndex = 103,
                        TextTruncate = Enum.TextTruncate.AtEnd, Parent = r })
        end
        Section("Account")
        Row("User ID", uid)
        local created, age = Row("Created", "..."), Row("Account age", "...")
        local function FillAccount(d)
                if not (created.Parent and d) then return end
                local y, m, dd = tostring(d.created or ""):match("(%d+)-(%d+)-(%d+)")
                if y then
                        created.Text = y .. "-" .. m .. "-" .. dd
                        local ok, t = pcall(os.time, { year = tonumber(y), month = tonumber(m), day = tonumber(dd) })
                        age.Text = ok and (math.max(0, math.floor((os.time() - t) / 86400)) .. " days") or "-"
                else
                        created.Text, age.Text = "-", "-"
                end
        end
        if ProfileCache[uid] then FillAccount(ProfileCache[uid])
        elseif plr then
                created.Text, age.Text = "-", plr.AccountAge .. " days"
        else
                task.spawn(function()
                        local body = Fetch("https://users.roblox.com/v1/users/" .. uid)
                        local ok, d = pcall(function() return HttpService:JSONDecode(body or "") end)
                        if ok and type(d) == "table" then ProfileCache[uid] = d FillAccount(d) elseif created.Parent then created.Text, age.Text = "-", "-" end
                end)
        end
        Section("Game")
        local place, job = tonumber(info.place), info.job and tostring(info.job) or nil
        local priv = info.priv == true or info.priv == 1 or info.priv == "1"
        local sameServer = (plr ~= nil) or (job ~= nil and job == game.JobId)
        local status
        if sameServer then status = "In your server"
        elseif priv then status = "In a private server"
        elseif place and job and job ~= "" then status = "In a public server"
        else status = "Unknown" end
        local statRow = Row("Status", status)
        if priv and not sameServer then statRow.TextColor3 = Lib.Theme.Warn end
        local state = { full = false }
        if place then
                local gn = Row("Game", "...")
                task.spawn(function()
                        local ok, r = pcall(function() return Market:GetProductInfo(place).Name end)
                        if gn.Parent then gn.Text = ok and r or "Unknown" end
                end)
                Row("Place ID", place)
                if job and job ~= "" then Row("Job ID", Short(job, 16)) end
                if not sameServer and not priv and job and job ~= "" then
                        local fill = Row("Players", "checking...")
                        Lib:CheckServer(place, job, function(r, why)
                                if not fill.Parent then return end
                                if r then
                                        state.full = r.max > 0 and r.playing >= r.max
                                        fill.Text = state.full and ("FULL  " .. r.playing .. "/" .. r.max) or (r.playing .. "/" .. r.max)
                                        fill.TextColor3 = state.full and Lib.Theme.Bad or Lib.Theme.Good
                                else
                                        fill.Text = why == "unreachable" and "couldn't check" or "not in public list"
                                        fill.TextColor3 = Lib.Theme.Warn
                                end
                        end)
                end
        else
                local l = New("TextLabel", { Text = "No game info shared for this user yet.", TextSize = 11, Size = UDim2.new(1, 0, 0, 14), TextXAlignment = LEFT, LayoutOrder = O(), ZIndex = 102,
                        Theme = { TextColor3 = "Dim" }, Parent = card })
                Wrap(l, nil, nil, 14)
        end
        if priv and not sameServer then
                local l = New("TextLabel", { Text = "They're in a private server. Roblox doesn't let you join those by server id. Ask them for the invite link.", TextSize = 11, Size = UDim2.new(1, 0, 0, 14),
                        TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = O(), ZIndex = 102, Theme = { TextColor3 = "Warn" }, Parent = card })
                Wrap(l, nil, nil, 14)
        end
        local function BtnRow(list)
                local n = #list
                local bar = New("Frame", { Size = UDim2.new(1, 0, 0, H(28)), BackgroundTransparency = 1, LayoutOrder = O(), ZIndex = 102, Parent = card })
                List(bar, 6, Enum.FillDirection.Horizontal)
                for i, bi in ipairs(list) do
                        local b = New("TextButton", { Text = bi.Text, TextSize = 12, Size = UDim2.new(1 / n, -(6 * (n - 1)) / n, 1, 0), LayoutOrder = i, BackgroundTransparency = 0, ZIndex = 103,
                                Theme = bi.Primary and { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" } or { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = bar })
                        Corner(b, 5)
                        b.Activated:Connect(function() bi.Func(b) end)
                end
        end
        local canJoin = place and job and job ~= "" and not sameServer and not priv
        if canJoin then
                BtnRow({
                        { Text = "Join game", Primary = true, Func = function()
                                if state.full then
                                        Lib:Dialog({ Title = "Server is full", Text = display .. "'s server is at capacity right now. You can still try, a spot may open up.",
                                                Buttons = { { Text = "Cancel" }, { Text = "Try anyway", Primary = true, Callback = function() Close() Lib:JoinServer(place, job, display) end } } })
                                        return
                                end
                                Close()
                                Lib:JoinServer(place, job, display)
                        end },
                        { Text = "Copy join script", Func = function()
                                Copy(string.format("game:GetService('TeleportService'):TeleportToPlaceInstance(%d, '%s', game.Players.LocalPlayer)", place, job), "Join script")
                        end },
                })
        end
        if uid ~= LocalPlayer.UserId then self:_ProfileFriendRow(BtnRow, uid, name, display) end
        if uid ~= LocalPlayer.UserId then
                BtnRow({
                        { Text = "Message", Primary = true, Func = function() Close() self:OpenDM(uid, name, display) end },
                        { Text = "Invite to group", Func = function()
                                Close()
                                self:InviteToGroup(nil, { { uid = uid, name = name, display = display } })
                        end },
                })
        end
        BtnRow({
                { Text = "Copy ID", Func = function() Copy(tostring(uid), "User ID") end },
                { Text = "Mention", Func = function() Close() self:Prefill(self.Input.Text .. "@" .. name .. " ") end },
                { Text = "More", Func = function(b) local p = b.AbsolutePosition + Vector2.new(0, b.AbsoluteSize.Y) Close() self:UserMenu(info, p) end },
        })
        BtnRow({ { Text = "Close", Func = Close } })
end

function Chat:Announce(msg)
        self.Counter = self.Counter + 1
        self.LastUid, self.LastTs = nil, nil
        local kind = msg.kind or "info"
        local key = KindKey[kind] or "Accent"
        local icon = (kind == "error" or kind == "warn") and "triangle-alert" or "megaphone"
        local label = kind == "error" and "ALERT" or (kind == "warn" and "WARNING" or (kind == "success" and "UPDATE" or "ANNOUNCEMENT"))
        local row = New("TextButton", { Name = "Announcement", Text = "", Size = UDim2.new(1, -4, 0, 56), BackgroundTransparency = 0, LayoutOrder = self.Counter, Theme = { BackgroundColor3 = "Card" }, Parent = self.List })
        row:SetAttribute("rest", 0)
        if msg.id then self.ByLid[msg.id] = row self.ByBubble[msg.id] = row end
        row.InputBegan:Connect(function(i) if IsPress(i) then self.LastPtr = Pointer(i) end end)
        Corner(row, 8) Stroke(row, key, 1, 0.65)
        local tile = New("Frame", { Size = UDim2.fromOffset(28, 28), Position = UDim2.fromOffset(10, 10), BackgroundTransparency = 0.75, Theme = { BackgroundColor3 = key }, Parent = row })
        Corner(tile, 7)
        Lib.Icon(icon, 15, key, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Parent = tile }, "!")
        local tm = ""
        if type(msg.ts) == "number" then pcall(function() tm = os.date("%H:%M", math.floor(msg.ts / 1000)) end) end
        New("TextLabel", { RichText = true, TextSize = 11, Size = UDim2.new(1, -56, 0, 14), Position = UDim2.fromOffset(46, 8), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd,
                Text = "<b><font color='#" .. ToHex(Lib.Theme[key]) .. "'>" .. label .. "</font></b>  <font color='#" .. ToHex(Lib.Theme.Dim) .. "'>" .. (msg.by and ("by " .. RichEsc(msg.by)) or "") .. (tm ~= "" and (" · " .. tm) or "") .. "</font>",
                Parent = row })
        local l = New("TextLabel", { Text = tostring(msg.text or ""), TextSize = 13, Size = UDim2.new(1, -56, 0, 14), Position = UDim2.fromOffset(46, 25), TextXAlignment = LEFT,
                TextYAlignment = Enum.TextYAlignment.Top, Parent = row })
        Wrap(l, row, 36, 14)
        table.insert(self.Items, row)
        self:_Trim()
        if self.Loaded then Lib:Notify({ Title = label:sub(1, 1) .. label:sub(2):lower(), Text = tostring(msg.text), Type = kind, Duration = 8 }) end
end

local function Esc(s) return (tostring(s):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")) end
local function Hex(k) return ToHex(Lib.Theme[k]) end

function Chat:_Known(msg)
        self.Known = self.Known or {}
        for _, v in ipairs({ msg.name, msg.display }) do
                if v and v ~= "" then self.Known[tostring(v):lower()] = true end
        end
end

function Chat:_MentionKind(w)
        local l = w:lower()
        if l == "everyone" or l == "here" then return "everyone" end
        if l == LocalPlayer.Name:lower() or l == LocalPlayer.DisplayName:lower() then return "me" end
        if self.Known and self.Known[l] then return "user" end
        for _, u in ipairs(self.Users or {}) do
                if tostring(u.name):lower() == l or tostring(u.display or ""):lower() == l then return "user" end
        end
end

function Chat:_Rich(text)
        local s = Esc(text):gsub("@([%w_]+)", function(w)
                local k = self:_MentionKind(w)
                if k == "me" or k == "everyone" then return "<font color='#" .. Hex("Warn") .. "'><b>@" .. w .. "</b></font>" end
                if k == "user" then return "<font color='#" .. Hex("Accent") .. "'><b>@" .. w .. "</b></font>" end
                return "@" .. w
        end)
        s = s:gsub("(https?://[^%s<>]+)", function(u) return "<font color='#" .. Hex("Accent") .. "'><u>" .. u .. "</u></font>" end)
        return s
end

function Chat:_BodyText(meta)
        local t = self:_Rich(meta.txt)
        if meta.edited then t = t .. " <font color='#" .. Hex("Dim") .. "' size='10'>(edited)</font>" end
        return t
end

function Chat:_Pings(msg)
        local me = tostring(LocalPlayer.UserId)
        if tostring(msg.uid) == me then return false end
        if type(msg.reply) == "table" and msg.reply.uid and tostring(msg.reply.uid) == me then return true end
        for w in tostring(msg.text):lower():gmatch("@([%w_]+)") do
                if w == LocalPlayer.Name:lower() or w == LocalPlayer.DisplayName:lower() then return true end
        end
        return false
end

-- Your messages sit on the right in accent bubbles; everyone else's sit on the left with an avatar.
function Chat:AddMessage(msg)
        if msg.id and self.Seen[msg.id] then return nil end
        if msg.id then self.Seen[msg.id] = true end
        local t = msg.type or "msg"
        if t == "delete" then self:_Remove(msg.target) return nil end
        if t == "edit" then self:_ApplyEdit(msg) return nil end
        if t == "clear" then self:_ClearAll() self:System("Chat was cleared" .. (msg.by and (" by " .. tostring(msg.by)) or "") .. ".") return nil end
        if t == "system" then self:System(msg.text) return nil end
        if t == "announce" then self:Announce(msg) return false end
        if Lib:IsBlocked(msg.uid) then return nil end
        self:_Known(msg)
        local mine = tostring(msg.uid) == tostring(LocalPlayer.UserId)
        local pinged = self:_Pings(msg)
        self.Counter = self.Counter + 1
        local tsOk = type(msg.ts) == "number"
        local groupStart = not (self.LastUid ~= nil and self.LastUid == msg.uid and tsOk and self.LastTs ~= nil and (msg.ts - self.LastTs) < 90000)
        if type(msg.reply) == "table" then groupStart = true end
        self.LastUid, self.LastTs = msg.uid, tsOk and msg.ts or nil
        local nm = tostring(msg.display or msg.name or "Unknown")
        if nm == "" then nm = tostring(msg.name or "Unknown") end

        local maxCol = math.min(560, math.floor((self.Frame.Size.X.Offset - 44) * 0.8))
        local inner = maxCol - 16
        local txt = tostring(msg.text or "")
        local img = type(msg.image) == "table" and msg.image or nil
        local url = txt:match("https?://[^%s<>\"]+")
        if url then url = url:gsub("[%.,;:!%?%)%]]+$", "") end
        local needW = math.min(math.ceil(Measure(txt, 13, Lib.Font, inner).X) + 6, inner)
        if url or img then needW = inner end
        local quoteTxt
        if type(msg.reply) == "table" then
                quoteTxt = tostring(msg.reply.text or "")
                if #quoteTxt > 48 then quoteTxt = quoteTxt:sub(1, 48) .. "..." end
                needW = math.max(needW, math.min(math.ceil(Measure(tostring(msg.reply.name or "?") .. " " .. quoteTxt, 11, Lib.Font, 1000).X) + 24, inner))
        end
        local tm = ""
        if tsOk then pcall(function() tm = os.date("%H:%M", math.floor(msg.ts / 1000)) end) end
        local headPlain = (mine and "" or (nm .. "  ")) .. tm
        local colW = math.min(maxCol, math.max(needW + 16, math.ceil(Measure(headPlain, 12, Lib.FontBold, 1000).X) + 6))
        local bubbleW = math.min(needW + 16, colW)

        local item = New("TextButton", { Name = "Message", Text = "", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Y, BackgroundTransparency = 1, LayoutOrder = self.Counter, Parent = self.List })
        Pad(item, 2, groupStart and 6 or 1, 2, 1)
        List(item, 6, Enum.FillDirection.Horizontal, mine and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Top)
        if msg.id then self.ByLid[msg.id] = item end
        item:SetAttribute("stext", txt:lower())
        item:SetAttribute("sauth", (nm .. " " .. tostring(msg.name or "")):lower())
        item:SetAttribute("uid", tostring(msg.uid))
        item.InputBegan:Connect(function(input) if IsPress(input) then self.LastPtr = Pointer(input) end end)
        do
                local avatar = New("ImageButton", { Name = "Avatar", Size = UDim2.fromOffset(24, 24), BackgroundTransparency = groupStart and 0 or 1, Theme = { BackgroundColor3 = "Field" },
                        LayoutOrder = mine and 3 or 1, Active = groupStart, Parent = item })
                Corner(avatar, 12)
                if groupStart then
                        local uid = tonumber(msg.uid)
                        if uid then GetAvatar(uid, function(u) if avatar.Parent then avatar.Image = u end end) end
                        avatar.MouseEnter:Connect(function() Tween(avatar, { BackgroundTransparency = 0.3 }, 0.08) end)
                        avatar.MouseLeave:Connect(function() Tween(avatar, { BackgroundTransparency = 0 }, 0.1) end)
                        avatar.Activated:Connect(function() self:ShowProfile(msg) end)
                end
        end
        local col = New("Frame", { Name = "Col", Size = UDim2.new(0, colW, 0, 0), AutomaticSize = Y, BackgroundTransparency = 1, LayoutOrder = 2, Parent = item })
        List(col, 2, Enum.FillDirection.Vertical, mine and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left)
        if groupStart then
                local head = mine and ("<font color='#" .. Hex("Dim") .. "'>" .. tm .. "</font>")
                        or ("<b><font color='#" .. Hex("Text") .. "'>" .. RichEsc(nm) .. "</font></b> <font color='#" .. Hex("Dim") .. "'>" .. tm .. "</font>")
                New("TextLabel", { Text = head, RichText = true, TextSize = 12, Size = UDim2.new(1, 0, 0, 14), TextXAlignment = mine and RIGHT or LEFT, TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = 1, Parent = col })
        end
        local rest = pinged and 0.78 or 0
        local bubble = New("Frame", { Name = "Bubble", Size = UDim2.new(0, bubbleW, 0, 0), AutomaticSize = Y, BackgroundTransparency = rest, LayoutOrder = 2,
                Theme = { BackgroundColor3 = pinged and "Warn" or (mine and "FieldHover" or "Field") }, Parent = col })
        bubble:SetAttribute("rest", rest)
        Corner(bubble, 9) Pad(bubble, 8, 5, 8, 5) List(bubble, 3)
        if pinged then Stroke(bubble, "Warn", 1, 0.45) elseif mine then Stroke(bubble, "Accent", 1, 0.75) end
        if msg.id then self.ByBubble[msg.id] = bubble end
        if quoteTxt then
                local quote = New("TextButton", { Name = "Quote", Text = "", Size = UDim2.new(1, 0, 0, H(20)), LayoutOrder = 1, BackgroundTransparency = 0.5, Theme = { BackgroundColor3 = "Bg" }, Parent = bubble })
                Corner(quote, 5)
                New("Frame", { Size = UDim2.new(0, 2, 1, -8), Position = UDim2.fromOffset(4, 4), Theme = { BackgroundColor3 = "Accent" }, Parent = quote })
                New("TextLabel", { RichText = true, Text = "<b><font color='#" .. Hex("Accent") .. "'>" .. RichEsc(msg.reply.name or "?") .. "</font></b> " .. RichEsc(quoteTxt),
                        TextSize = 11, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(12, 0), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = quote })
                quote.Activated:Connect(function() if msg.reply.id then self:_JumpTo(msg.reply.id) end end)
        end
        local body = New("TextLabel", { Name = "Text", RichText = true, Text = "", TextSize = 13, Size = UDim2.new(1, 0, 0, 14), TextXAlignment = LEFT,
                TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = 2, Visible = txt ~= "", Parent = bubble })
        Wrap(body)
        local meta = { body = body, txt = txt, msg = msg, edited = msg.edited ~= nil }
        body.Text = self:_BodyText(meta)
        self.Meta[item] = meta
        if img then
                local iw, ih2 = tonumber(img.w) or 0, tonumber(img.h) or 0
                if iw < 1 or ih2 < 1 or iw > 10000 or ih2 > 10000 then iw, ih2 = 4, 3 end
                local sc = math.min(math.min(inner, 220) / iw, 180 / ih2, 1)
                local dw, dh = math.max(48, math.floor(iw * sc)), math.max(36, math.floor(ih2 * sc))
                local frame = New("TextButton", { Name = "Image", Text = "Loading image...", TextSize = 11, Size = UDim2.fromOffset(dw, dh), LayoutOrder = 3, BackgroundTransparency = 0,
                        Theme = { BackgroundColor3 = "Bg", TextColor3 = "Dim" }, Parent = bubble })
                Corner(frame, 6)
                local pic = New("ImageLabel", { Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Fit, Visible = false, ZIndex = 2, Parent = frame })
                Corner(pic, 6)
                local started = false
                local function Load()
                        if started then return end
                        started = true
                        frame.Text = "Loading image..."
                        self:LoadImage(img, function(asset, err)
                                if not frame.Parent then return end
                                if asset then
                                        pic.Image = asset
                                        pic.Visible = true
                                        frame.Text = ""
                                else
                                        frame.Text = "Image unavailable" .. (err and ("\n(" .. tostring(err):sub(1, 40) .. ")") or "")
                                end
                        end)
                end
                if Lib.ShowImages == false then frame.Text = "Click to load image" else Load() end
                frame.Activated:Connect(function()
                        if not started then Load() elseif pic.Visible then self:ViewImage(pic.Image, iw, ih2) end
                end)
        end
        if url then self:LoadPreview(bubble, url, 4) end
        item.MouseEnter:Connect(function() Tween(bubble, { BackgroundTransparency = math.max(rest - 0.15, 0) }, 0.06) end)
        item.MouseLeave:Connect(function() Tween(bubble, { BackgroundTransparency = rest }, 0.1) end)
        item.Activated:Connect(function() self:MessageMenu(msg) end)
        table.insert(self.Items, item)
        self:_Trim()
        if self.Loaded and not self.Stick and not mine then self.JumpCount = self.JumpCount + 1 self.Jump.Text = "↓ " .. self.JumpCount .. " new" end
        if pinged and self.Loaded then
                self:AddNotif(msg, nm, txt ~= "" and txt or "[image]")
                if not self.PanelObj._shown then
                        Lib:Notify({ Title = (type(msg.reply) == "table" and "Reply from " or "Mentioned by ") .. nm, Text = txt:sub(1, 90), Type = "warn", Duration = 6 })
                        if self.PanelObj.RailButton then self.PanelObj.RailButton:AddBadge() end
                end
        end
        if self.SearchOpen and self.SearchText ~= "" then self:ApplySearch() end
        return mine
end

function Chat:_Do(path, query, method, body, room)
        local cfg = self.Config
        local q = { "room=" .. UrlEncode(room or self.Room), "uid=" .. UrlEncode(LocalPlayer.UserId), "name=" .. UrlEncode(LocalPlayer.Name), "display=" .. UrlEncode(LocalPlayer.DisplayName) }
        if Lib.ShareServer ~= false then
                table.insert(q, "place=" .. UrlEncode(game.PlaceId))
                table.insert(q, "job=" .. UrlEncode(game.JobId))
                table.insert(q, "priv=" .. (game.PrivateServerId ~= "" and "1" or "0"))
        end
        for k, v in pairs(query or {}) do table.insert(q, k .. "=" .. UrlEncode(v)) end
        local req = { Url = cfg.Url .. path .. "?" .. table.concat(q, "&"), Method = method or "GET", Headers = {} }
        if body then req.Headers["Content-Type"] = "application/json" req.Body = body end
        local ok, res = pcall(self.Request, req)
        if not ok then return nil end
        return res
end

function Chat:_ApplyEdit(ev)
        local item = self.ByLid[ev.target]
        local meta = item and self.Meta[item]
        if not meta then return end
        meta.txt, meta.edited = tostring(ev.text or ""), true
        if meta.msg then meta.msg.text = meta.txt end
        item:SetAttribute("stext", meta.txt:lower())
        meta.body.Visible = meta.txt ~= ""
        meta.body.Text = self:_BodyText(meta)
        meta.hl = false
        if self.SearchOpen and self.SearchText ~= "" then self:ApplySearch(true) end
end

function Chat:EditMessage(msg)
        Lib:Prompt({ Title = "Edit message", Text = "", Default = tostring(msg.text or ""), Confirm = "Save" }, function(t)
                t = Trim(t)
                if t == tostring(msg.text or "") then return end
                if t == "" and not msg.image then return end
                task.spawn(function()
                        local d = Decode(self:_Do("/edit", nil, "POST", HttpService:JSONEncode({ id = msg.id, text = t })))
                        if not (d and d.ok) then self:System((d and d.error) or "Couldn't edit that message.") return end
                        self:_PollOnce()
                end)
        end)
end

-- images: downloaded from the relay, cached in Aether/cache, shown with getcustomasset
function Chat:LoadImage(img, cb)
        local cached = Lib.ImgAssets[img.id]
        if cached then cb(cached) return end
        if not (FsOk() and (getcustomasset or getsynasset)) then cb(nil, "your executor can't show images") return end
        task.spawn(function()
                local path = CachePath(img.id, img.mime)
                local have = false
                pcall(function() have = isfile(path) end)
                if not have then
                        local d = Decode(self:_Do("/img", { id = img.id }))
                        if not (d and d.ok and d.data) then cb(nil, (d and d.error) or "download failed") return end
                        local okd, bytes = pcall(B64Decode, d.data)
                        if not okd or not pcall(writefile, path, bytes) then cb(nil, "couldn't save it") return end
                end
                local asset = CustomAsset(path)
                if asset then Lib.ImgAssets[img.id] = asset cb(asset) else cb(nil, "couldn't open it") end
        end)
end

function Chat:ViewImage(asset, w, h)
        local dim = New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.25, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 100, Parent = Lib.Overlay })
        local vp = Lib.Overlay.AbsoluteSize
        local iw, ih = (w and w > 0) and w or 4, (h and h > 0) and h or 3
        local sc = math.min(vp.X * 0.86 / iw, vp.Y * 0.8 / ih, 3)
        local pic = New("ImageLabel", { Image = asset, Size = UDim2.fromOffset(iw * sc, ih * sc), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 101, Parent = dim })
        Corner(pic, 8)
        New("TextLabel", { Text = "click anywhere to close", TextSize = 11, AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -14), Size = UDim2.new(1, 0, 0, 14), ZIndex = 101,
                Theme = { TextColor3 = "SubText" }, Parent = dim })
        dim.Activated:Connect(function() dim:Destroy() end)
end

-- link previews: the relay fetches the page (so your IP never touches the site) and returns title / description
function Chat:LoadPreview(parent, url, order)
        if Lib.LinkPreviews == false then return end
        task.spawn(function()
                local d = Lib.PreviewCache[url]
                if d == nil then
                        d = Decode(self:_Do("/preview", { link = url })) or false
                        Lib.PreviewCache[url] = d
                end
                if not d or not d.ok or not parent.Parent then return end
                local title, desc = tostring(d.title or ""), tostring(d.desc or "")
                if title == "" and desc == "" then return end
                local h = 6 + 13 + 17 + (desc ~= "" and 30 or 0) + 5
                local card = New("TextButton", { Name = "Preview", Text = "", Size = UDim2.new(1, 0, 0, h), LayoutOrder = order, BackgroundTransparency = 0.35, Theme = { BackgroundColor3 = "Bg" }, Parent = parent })
                Corner(card, 6)
                New("Frame", { Size = UDim2.new(0, 2, 1, -10), Position = UDim2.fromOffset(5, 5), Theme = { BackgroundColor3 = "Accent" }, Parent = card })
                New("TextLabel", { Text = tostring(d.site or d.host or ""), TextSize = 10, Size = UDim2.new(1, -22, 0, 13), Position = UDim2.fromOffset(14, 5), TextXAlignment = LEFT,
                        TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Dim" }, Parent = card })
                New("TextLabel", { Text = title ~= "" and title or url, Font = Lib.FontBold, TextSize = 12, Size = UDim2.new(1, -22, 0, 16), Position = UDim2.fromOffset(14, 18), TextXAlignment = LEFT,
                        TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Accent" }, Parent = card })
                if desc ~= "" then
                        New("TextLabel", { Text = desc, TextSize = 11, Size = UDim2.new(1, -22, 0, 28), Position = UDim2.fromOffset(14, 35), TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top,
                                TextWrapped = true, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = card })
                end
                card.Activated:Connect(function() Copy(url, "Link copied") end)
                Lib:AddTooltip(card, "Click to copy the link")
        end)
end

-- image search: the one and only way to attach images - it searches the internet (Openverse + Wikimedia,
-- GIFs included when the worker finds them; Roblox shows GIFs as a still frame).
function Chat:PickSearch()
        Lib:Prompt({ Title = "Search images", Text = "Searches the internet for pictures and GIFs. Tap a result to send it.", Placeholder = "cats, sword gif, blox fruits...", Confirm = "Search" }, function(q)
                q = Trim(q)
                if q ~= "" then self:ShowResults(q) end
        end)
end

function Chat:ShowResults(q)
        Lib:Notify({ Title = "Images", Text = "Searching...", Type = "info", Duration = 2 })
        task.spawn(function()
                local d = Decode(self:_Do("/search", { q = q }))
                if not (d and d.ok) then
                        Lib:Notify({ Title = "Images", Text = (d and d.error) or "Search failed. Is your worker updated?", Type = "error" })
                        return
                end
                local results = d.results or {}
                if #results == 0 then
                        Lib:Notify({ Title = "Images", Text = "No results for \"" .. q .. "\".", Type = "warn" })
                        return
                end
                local canThumb = FsOk() and (getcustomasset or getsynasset) ~= nil
                local dim = New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.5, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 100, Parent = Lib.Overlay })
                local card = Sink(New("Frame", { Size = UDim2.fromOffset(340, 360), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 101,
                        Theme = { BackgroundColor3 = "Bg" }, Parent = dim }))
                Corner(card, 8) Stroke(card)
                New("UIScale", { Scale = math.min(1, Lib.Overlay.AbsoluteSize.X / 370, Lib.Overlay.AbsoluteSize.Y / 400), Parent = card })
                New("TextLabel", { Text = "Results for \"" .. Short(q, 24) .. "\"", Font = Lib.FontBold, TextSize = 14, Size = UDim2.new(1, -80, 0, 30), Position = UDim2.fromOffset(12, 0),
                        TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 102, Parent = card })
                local close = New("TextButton", { Text = "Close", TextSize = 12, Size = UDim2.fromOffset(56, 22), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 4), BackgroundTransparency = 0,
                        ZIndex = 102, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = card })
                Corner(close, 5)
                local function Close() if dim.Parent then dim:Destroy() end end
                close.Activated:Connect(Close)
                dim.Activated:Connect(Close)
                local grid = New("ScrollingFrame", { Size = UDim2.new(1, -16, 1, -62), Position = UDim2.fromOffset(8, 34), AutomaticCanvasSize = Y, ScrollBarThickness = 3, ZIndex = 102, Parent = card })
                New("UIGridLayout", { CellSize = UDim2.fromOffset(100, 100), CellPadding = UDim2.fromOffset(6, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = grid })
                New("TextLabel", { Text = "Tap an image to send it. GIFs arrive as a still frame (Roblox can't play them).", TextSize = 10, Size = UDim2.new(1, -16, 0, 14), AnchorPoint = Vector2.new(0, 1),
                        Position = UDim2.new(0, 8, 1, -6), TextXAlignment = LEFT, ZIndex = 102, Theme = { TextColor3 = "Dim" }, Parent = card })
                for i, r in ipairs(results) do
                        local b = New("TextButton", { Text = canThumb and "" or Short(r.title, 30), TextSize = 10, TextWrapped = true, LayoutOrder = i, BackgroundTransparency = 0, ZIndex = 103,
                                Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = grid })
                        Corner(b, 6)
                        local pic = New("ImageLabel", { Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop, ZIndex = 104, Parent = b })
                        Corner(pic, 6)
                        if r.gif then
                                local tag = New("TextLabel", { Text = "GIF", Font = Lib.FontBold, TextSize = 8, Size = UDim2.fromOffset(24, 12), AnchorPoint = Vector2.new(1, 1),
                                        Position = UDim2.new(1, -3, 0, 3), BackgroundTransparency = 0.2, ZIndex = 105, TextColor3 = WHITE,
                                        BackgroundColor3 = Lib.Theme.Accent, Parent = b })
                                Corner(tag, 3)
                        end
                        b.Activated:Connect(function()
                                Close()
                                self:SendImage({ url = r.thumb or r.url })
                        end)
                        if canThumb then
                                task.spawn(function()
                                        local body = Fetch(r.thumb)
                                        if not body or not b.Parent then return end
                                        local path = CachePath("s" .. tostring(r.id), r.mime)
                                        if pcall(writefile, path, body) then
                                                local asset = CustomAsset(path)
                                                if asset and pic.Parent then pic.Image = asset end
                                        end
                                end)
                                Lib:AddTooltip(b, r.title)
                        end
                end
        end)
end

function Chat:SendImage(payload)
        if self.Blocked then return end
        local caption = Trim(self.Input.Text)
        local replyId = self.ReplyTo and self.ReplyTo.id or nil
        Lib:Notify({ Title = "Image", Text = "Uploading...", Type = "info", Duration = 2 })
        task.spawn(function()
                local d = Decode(self:_Do("/upload", nil, "POST", HttpService:JSONEncode(payload)))
                if not (d and d.ok and d.id) then self:System((d and d.error) or "Upload failed.") return end
                self.Input.Text = ""
                self:SetReply(nil)
                self.Stick = true
                local r = Decode(self:_Do("/send", nil, "POST", HttpService:JSONEncode({ text = caption:sub(1, self.Config.MaxLength), replyTo = replyId, image = d.id })))
                if not (r and r.ok) then self:System((r and r.error) or "Couldn't send the image.") return end
                self:_PollOnce()
        end)
end

-- unread badges for channels you are not viewing (cheap "peek" requests, no presence)
function Chat:_StartPeeking()
        if self._peeking or #self.Channels < 2 or not self.Request or not self.Config.Url then return end
        self._peeking = true
        task.spawn(function()
                while not Lib.Unloaded do
                        task.wait(self.PanelObj.Enabled and 12 or 25)
                        if self.Alive and not self.Blocked then
                                local changed = false
                                for i, ch in ipairs(self.Channels) do
                                        if i ~= self.ChIndex then
                                                local d = Decode(self:_Do("/poll", { peek = 1, after = ch.read or -1 }, nil, nil, ch.room))
                                                if d and d.ok then
                                                        if ch.read == nil then
                                                                ch.read = d.last or 0
                                                        elseif (d.count or 0) ~= (ch.unread or 0) then
                                                                if (d.count or 0) > (ch.unread or 0) and not self.PanelObj._shown and self.PanelObj.RailButton then self.PanelObj.RailButton:AddBadge() end
                                                                ch.unread = d.count or 0
                                                                changed = true
                                                        end
                                                end
                                                task.wait(0.3)
                                        end
                                end
                                if changed then self:_RefreshChannel() end
                        end
                end
        end)
end

function Chat:Send(text)
        text = Trim(text or "")
        if text == "" or self.Blocked then return end
        if os.clock() - self.LastSend < 0.8 then self:System("Slow down a little.") return end
        self.LastSend = os.clock()
        local replyId = self.ReplyTo and self.ReplyTo.id or nil
        self:SetReply(nil)
        self.Stick = true
        task.spawn(function()
                local body = HttpService:JSONEncode({ text = text:sub(1, self.Config.MaxLength), replyTo = replyId })
                local res = self:_Do("/send", nil, "POST", body)
                local d = Decode(res)
                if not res or res.StatusCode ~= 200 then
                        self:System((d and d.error) or "Couldn't send.")
                        return
                end
                self:_PollOnce()
        end)
end

function Chat:_Stop(text, kind)
        self.Alive = false
        self.Blocked = text
        self:SetStatus("Offline", "Disconnected")
        self:System(text)
        Lib:Notify({ Title = "Chat", Text = text, Type = kind or "warn", Duration = 7 })
        self:_UpdateInput()
end

function Chat:Reconnect()
        if self.Alive and not self.Blocked then return end
        self.Alive, self.Blocked, self.Fails = true, nil, 0
        self:SetStatus("Connecting")
        self:_UpdateInput()
        self:_StartPolling()
end

function Chat:_PollOnce()
        local gen = self.Gen
        local res = self:_Do("/poll", { after = self.LastId })
        if gen ~= self.Gen then return true end -- channel changed while this request was in flight
        local data = Decode(res)
        if res and res.StatusCode == 403 and data then
                if data.removed then
                        -- the server says you are no longer in this group
                        local ch = self:_FindRoom(self.Room)
                        if ch and ch.kind == "grp" then
                                Lib:Notify({ Title = "Group", Text = "You're no longer in \"" .. ch.name .. "\".", Type = "warn", Duration = 5 })
                                self:_RemoveChannel(ch)
                        end
                        return true
                end
        end
        if not (res and res.StatusCode == 200 and data and data.ok) then
                self.Fails = self.Fails + 1
                self:SetStatus(self.Fails >= 2 and "Offline" or "Connecting")
                return false
        end
        self.Fails = 0
        self.Users = data.users or {}
        if type(data.group) == "table" then self:_ApplyGroup(data.group) end
        if type(data.pinned) == "table" then self:SetPinned(data.pinned) end
        self.Online = data.online or self.Online
        self:SetStatus("Connected", tostring(self.Online) .. " online")
        local unread = false
        for _, m in ipairs(data.messages or {}) do
                local mine = self:AddMessage(m)
                if self.Loaded and mine == false then unread = true end
                if type(m.id) == "number" and m.id > self.LastId then self.LastId = m.id end
        end
        if not self.Loaded then self:System("Connected.") end
        self.Loaded = true
        if type(data.last) == "number" and data.last > self.LastId then self.LastId = data.last end
        do
                local cur = self.Channels[self.ChIndex]
                cur.read, cur.unread = self.LastId, 0
        end
        if unread and not self.PanelObj.Enabled and self.PanelObj.RailButton then self.PanelObj.RailButton:AddBadge() end
        -- the relay also answers with the DMs + groups this account is part of; keep the tab list in step
        if type(data.dms) == "table" or type(data.groups) == "table" then self:_SyncRooms(data.dms, data.groups) end
        if type(data.fr) == "table" then self:_SyncFriends(data.fr) end
        self:_UpdateInput()
        return true
end

-- the server now owns the group's name, owner and member list, so this just copies what it says
function Chat:_ApplyGroup(g)
        local ch = self:_FindRoom(self.Room)
        if not ch or ch.kind ~= "grp" or type(g.m) ~= "table" then return end
        local members = {}
        for _, v in ipairs(g.m) do
                local n = tonumber(v)
                if n then table.insert(members, n) end
        end
        local name = Trim(tostring(g.n or ch.name)):sub(1, 24)
        local sig = name .. "|" .. tostring(g.o) .. "|" .. table.concat(members, ",")
        if ch._sig == sig then return end
        ch._sig = sig
        ch.name, ch.owner, ch.members = name, tonumber(g.o), members
        self:SaveConvos()
        self:_RefreshChannel()
end

function Chat:_StartPolling()
        task.spawn(function()
                while self.Alive and not Lib.Unloaded do
                        local ok = self:_PollOnce()
                        local wait = self.Config.PollInterval
                        if not self.PanelObj.Enabled then wait = wait * 2.5 end
                        if not ok then wait = math.min(15, 3 + self.Fails * 2) end
                        task.wait(wait)
                end
        end)
end

function Chat:Destroy() self.Alive = false if self.Frame then self.Frame:Destroy() end end

function Chat:_Relayout()
        local sOff = self.SearchOpen and 28 or 0
        local pinOn = self.Pinned[self.PinIdx] ~= nil
        self.Top = self.BaseTop + sOff + (pinOn and 32 or 0)
        local reply = self.ReplyTo and 28 or 0
        local pos, size = UDim2.fromOffset(8, self.Top), UDim2.new(1, -16, 1, -(self.Top + self.ListBottom + reply))
        self.PinBar.Position = UDim2.fromOffset(8, self.BaseTop - 4 + sOff)
        self.List.Position, self.List.Size = pos, size
        self.NotifPanel.Position, self.NotifPanel.Size = pos, size
        self.Jump.Position = UDim2.new(0.5, 0, 1, -(self.ListBottom + reply + 6))
end

function Chat:ToggleSearch(open)
        self.SearchOpen = open and true or false
        self.SearchRow.Visible = self.SearchOpen
        self.SearchApi.Rest = self.SearchOpen and "Accent" or "SubText"
        Tint(self.SearchApi.Icon, Lib.Theme[self.SearchApi.Rest])
        if self.SearchOpen then
                self:ToggleNotifs(false)
                self:_Relayout()
                self.SearchBox:CaptureFocus()
        else
                self.SearchBox.Text, self.SearchText = "", ""
                self:ApplySearch()
                self:_Relayout()
        end
end

local function Highlight(txt, q)
        local low, out, pos = txt:lower(), {}, 1
        while true do
                local a, b = low:find(q, pos, true)
                if not a then break end
                table.insert(out, Esc(txt:sub(pos, a - 1)))
                table.insert(out, "<mark color=\"#FFD54A\" transparency=\"0.55\">" .. Esc(txt:sub(a, b)) .. "</mark>")
                pos = b + 1
        end
        table.insert(out, Esc(txt:sub(pos)))
        return table.concat(out)
end

function Chat:_JumpItem(item)
        if not item or not item.Parent then return end
        self.Stick = false
        task.delay(0.05, function()
                if not item.Parent then return end
                local y = item.AbsolutePosition.Y - self.List.AbsolutePosition.Y + self.List.CanvasPosition.Y - 10
                Tween(self.List, { CanvasPosition = Vector2.new(0, math.max(0, y)) }, 0.25, Enum.EasingStyle.Quint)
                local b = item:FindFirstChild("Bubble", true)
                if b then
                        local rest = b:GetAttribute("rest") or 0
                        b.BackgroundTransparency = math.max(rest - 0.5, 0)
                        Tween(b, { BackgroundTransparency = rest }, 0.9)
                end
        end)
end

-- Searching highlights matches in place and lets you step through them. "from:name" limits it to one author.
function Chat:ApplySearch(keepIdx)
        local raw = self.SearchText or ""
        local author = raw:match("from:(%S+)")
        local q = Trim((raw:gsub("from:%S+", ""))):lower()
        author = author and author:lower() or nil
        local active = q ~= "" or author ~= nil
        local hits = {}
        local function Hidden(it)
                local u = it:GetAttribute("uid")
                return u ~= nil and Lib.BlockList[u] ~= nil
        end
        for _, it in ipairs(self.Items) do
                local meta = self.Meta[it]
                if not meta then
                        it.Visible = (not active) or (not self.SearchFilter)
                else
                        local hidden = Hidden(it)
                        local hit = false
                        if active and not hidden then
                                hit = (author == nil or (it:GetAttribute("sauth") or ""):find(author, 1, true) ~= nil)
                                        and (q == "" or (it:GetAttribute("stext") or ""):find(q, 1, true) ~= nil)
                        end
                        if hit then table.insert(hits, it) end
                        it.Visible = ((not active) or (not self.SearchFilter) or hit) and not hidden
                        local want = hit and q ~= ""
                        if want then
                                meta.body.Text = Highlight(meta.txt, q)
                                meta.hl = true
                        elseif meta.hl then
                                meta.body.Text = self:_BodyText(meta)
                                meta.hl = false
                        end
                end
        end
        self.SearchHits = hits
        if not active then
                self.SearchIdx = 0
                self.SearchCount.Text = ""
        elseif #hits == 0 then
                self.SearchIdx = 0
                self.SearchCount.Text = "none"
        else
                if not keepIdx or self.SearchIdx < 1 or self.SearchIdx > #hits then self.SearchIdx = #hits end
                self.SearchCount.Text = self.SearchIdx .. "/" .. #hits
                if not keepIdx then self:_JumpItem(hits[self.SearchIdx]) end
        end
end

function Chat:SearchStep(d)
        local n = #self.SearchHits
        if n == 0 then return end
        self.SearchIdx = (self.SearchIdx - 1 + d) % n + 1
        self.SearchCount.Text = self.SearchIdx .. "/" .. n
        self:_JumpItem(self.SearchHits[self.SearchIdx])
end

function Chat:SetPinned(list)
        self.Pinned = type(list) == "table" and list or {}
        if self.PinIdx > #self.Pinned then self.PinIdx = 1 end
        self:_RefreshPin()
        self:_Relayout()
end

function Chat:_IsPinned(id)
        for _, p in ipairs(self.Pinned) do if p.id == id then return true end end
        return false
end

function Chat:_RefreshPin()
        local p = self.Pinned[self.PinIdx]
        self.PinBar.Visible = p ~= nil
        if not p then return end
        local nm = p.type == "announce" and "Announcement" or RichEsc((p.display ~= nil and p.display ~= "") and p.display or p.name or "?")
        self.PinText.Text = "<b><font color='#" .. Hex("Accent") .. "'>" .. nm .. "</font></b>  " .. RichEsc(tostring(p.text or ""):sub(1, 140))
        self.PinCount.Text = #self.Pinned > 1 and (self.PinIdx .. "/" .. #self.Pinned) or ""
        self.PinX.Button.Visible = false
end

function Chat:GotoPin()
        local p = self.Pinned[self.PinIdx]
        if not p then return end
        if p.id and self.ByLid[p.id] then
                self.Stick = false
                self:_JumpTo(p.id)
        else
                Lib:Dialog({ Title = "Pinned by " .. tostring(p.by or "someone"), Text = tostring(p.display or p.name or "?") .. ": " .. tostring(p.text or "") })
        end
end

function Chat:_UpdateBell()
        local c = 0
        for _, n in ipairs(self.Notifs) do if not n.read then c = c + 1 end end
        self.BellBadge.Visible = c > 0
        self.BellText.Text = c > 9 and "9+" or tostring(c)
end

function Chat:AddNotif(msg, nm, txt)
        table.insert(self.Notifs, 1, { id = msg.id, uid = msg.uid, name = nm, text = txt, ts = type(msg.ts) == "number" and msg.ts or os.time() * 1000,
                room = self.Room, channel = self.Channels[self.ChIndex].name, kind = type(msg.reply) == "table" and "reply" or "mention", read = false })
        while #self.Notifs > 50 do table.remove(self.Notifs) end
        self:_UpdateBell()
        if self.NotifOpen then self:RebuildNotifs() end
end

function Chat:GotoNotif(n)
        if n.room ~= self.Room then
                for i, ch in ipairs(self.Channels) do if ch.room == n.room then self:SetChannel(i) break end end
                return
        end
        if n.id and self.ByLid[n.id] then self.Stick = false self:_JumpTo(n.id) end
end

function Chat:RebuildNotifs()
        for _, c in ipairs(self.NotifList:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
        if #self.Notifs == 0 then
                New("TextLabel", { Text = "No mentions or replies yet.", TextSize = 12, Size = UDim2.new(1, 0, 0, 44), ZIndex = 17, Theme = { TextColor3 = "Dim" }, Parent = self.NotifList })
                return
        end
        for i, n in ipairs(self.Notifs) do
                local b = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, 42), LayoutOrder = i, BackgroundTransparency = n.read and 1 or 0.6, ZIndex = 17, Theme = { BackgroundColor3 = "Field" }, Parent = self.NotifList })
                Corner(b, 5)
                if not n.read then
                        local d = New("Frame", { Size = UDim2.fromOffset(6, 6), Position = UDim2.fromOffset(6, 9), ZIndex = 18, Theme = { BackgroundColor3 = "Accent" }, Parent = b })
                        Corner(d, 3)
                end
                local tm = ""
                pcall(function() tm = os.date("%H:%M", math.floor(n.ts / 1000)) end)
                New("TextLabel", { RichText = true, Text = "<b>" .. RichEsc(n.name) .. "</b> " .. (n.kind == "reply" and "replied to you" or "mentioned you") .. " <font color='#" .. Hex("Dim") .. "'>#" .. RichEsc(n.channel) .. " " .. tm .. "</font>",
                        TextSize = 11, Size = UDim2.new(1, -24, 0, 14), Position = UDim2.fromOffset(16, 5), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 18, Parent = b })
                New("TextLabel", { Text = n.text, TextSize = 12, Size = UDim2.new(1, -24, 0, 14), Position = UDim2.fromOffset(16, 22), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd,
                        ZIndex = 18, Theme = { TextColor3 = "SubText" }, Parent = b })
                b.Activated:Connect(function()
                        n.read = true
                        self:_UpdateBell()
                        self:ToggleNotifs(false)
                        self:GotoNotif(n)
                end)
        end
end

function Chat:ToggleNotifs(open)
        self.NotifOpen = open and true or false
        self.NotifPanel.Visible = self.NotifOpen
        self.BellApi.Rest = self.NotifOpen and "Accent" or "SubText"
        Tint(self.BellApi.Icon, Lib.Theme[self.BellApi.Rest])
        if self.NotifOpen then self:RebuildNotifs() end
end

-- Online list: searchable, and capped so 100+ players can't turn it into a wall of names.
-- Pass { Title = ..., Callback = fn } to turn it into a picker (new DMs, group invites).
function Chat:ShowUsers(pick)
        local all = {}
        for _, u in ipairs(self.Users or {}) do table.insert(all, u) end
        table.sort(all, function(a, b)
                return tostring(a.display or a.name):lower() < tostring(b.display or b.name):lower()
        end)
        local total = #all
        local rh, w, MAXSHOW, sc = H(26), 230, 40, Lib.Scale
        local searchable = total > 8
        local top = 28 + (searchable and 32 or 0)
        local h = top + math.min(math.max(total, 1), 8) * (rh + 2) + 8
        local frame = Sink(New("Frame", { Size = UDim2.fromOffset(w, h), BackgroundTransparency = 0, ZIndex = 85, Theme = { BackgroundColor3 = "Surface" }, Parent = Lib.Overlay }))
        Corner(frame, 6) Stroke(frame, "Stroke", 1, 0)
        New("UIScale", { Scale = sc, Parent = frame })
        New("TextLabel", { Text = (type(pick) == "table" and pick.Title) or "Online · " .. total, Font = Lib.FontBold, TextSize = 12, Size = UDim2.new(1, -16, 0, 24),
                Position = UDim2.fromOffset(10, 2), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 86, Parent = frame })
        local box
        if searchable then
                local sb = New("Frame", { Size = UDim2.new(1, -16, 0, 24), Position = UDim2.fromOffset(8, 28), BackgroundTransparency = 0, ZIndex = 86, Theme = { BackgroundColor3 = "Field" }, Parent = frame })
                Corner(sb, 4)
                box = New("TextBox", { Text = "", PlaceholderText = "Search players...", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 12, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(8, 0),
                        TextXAlignment = LEFT, ZIndex = 87, Parent = sb })
        end
        local list = New("ScrollingFrame", { Size = UDim2.new(1, -8, 1, -(top + 4)), Position = UDim2.fromOffset(4, top), AutomaticCanvasSize = Y, ScrollBarThickness = 2, ZIndex = 86, Parent = frame })
        List(list, 2)
        local function Build()
                for _, c in ipairs(list:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
                local q = box and box.Text:lower() or ""
                local shown, matched = 0, 0
                for _, u in ipairs(all) do
                        if q == "" or (tostring(u.name) .. " " .. tostring(u.display or "")):lower():find(q, 1, true) then
                                matched = matched + 1
                                if shown < MAXSHOW then
                                        shown = shown + 1
                                        local b = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, rh), LayoutOrder = shown, ZIndex = 87, BackgroundTransparency = 1, BackgroundColor3 = Lib.Theme.FieldHover, Parent = list })
                                        Corner(b, 4)
                                        New("TextLabel", { Text = RichEsc(u.display or u.name) .. " <font color='#" .. ToHex(Lib.Theme.Dim) .. "'>@" .. RichEsc(u.name) .. "</font>", RichText = true, TextSize = 12,
                                                Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(9, 0), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 88, Parent = b })
                                        b.MouseEnter:Connect(function() Tween(b, { BackgroundTransparency = 0.3 }, 0.06) end)
                                        b.MouseLeave:Connect(function() Tween(b, { BackgroundTransparency = 1 }, 0.08) end)
                                        if type(pick) == "table" and type(pick.Callback) == "function" then
                                                Press(b, function() Lib:ClosePopup() Safe(pick.Callback, u) end)
                                        else
                                                Press(b, function() Lib:ClosePopup() self:ShowProfile(u) end)
                                        end
                                end
                        end
                end
                if matched == 0 then
                        New("TextLabel", { Text = "No players match", TextSize = 12, Size = UDim2.new(1, 0, 0, rh), ZIndex = 87, Theme = { TextColor3 = "Dim" }, Parent = list })
                elseif matched > shown then
                        New("TextLabel", { Text = "+" .. (matched - shown) .. " more - search to narrow down", TextSize = 11, Size = UDim2.new(1, 0, 0, rh), LayoutOrder = 1000, ZIndex = 87, Theme = { TextColor3 = "Dim" }, Parent = list })
                end
        end
        if box then box:GetPropertyChangedSignal("Text"):Connect(Build) end
        Build()
        local pos, hh = PlaceBelow(self.Pill, w * sc, h * sc, 6, true)
        frame.Position = UDim2.fromOffset(pos.X, pos.Y)
        frame.Size = UDim2.fromOffset(w, hh / sc)
        Lib:OpenPopup(frame, function() frame:Destroy() end, self.Pill)
end

local function Ago(ms)
        if not ms or ms <= 0 then return "a while ago" end
        local s = math.max(0, os.time() - math.floor(ms / 1000))
        if s < 90 then return "just now" end
        if s < 5400 then return math.floor(s / 60 + 0.5) .. "m ago" end
        if s < 129600 then return math.floor(s / 3600 + 0.5) .. "h ago" end
        return math.floor(s / 86400 + 0.5) .. "d ago"
end

local function ThumbExt(b)
        if b:sub(1, 3) == "\255\216\255" then return ".jpg" end
        if b:sub(1, 4) == "\137PNG" then return ".png" end
        if b:sub(1, 2) == "BM" then return ".bmp" end
        return nil
end

-- ── people browser: search box + scope chips + paged list, fed by the relay's /users endpoint ──────────
-- o: Parent, Position, Size, Z, Scopes = { {"online","Online"}, ... }, Scope, OnClick(u, refresh), Mark(u) -> bool, Extra(u) -> string, Exclude = { [uid] = true }
function Chat:PeopleBrowser(o)
        local z, rh = o.Z or 90, H(30)
        local root = New("Frame", { Size = o.Size, Position = o.Position or UDim2.new(), BackgroundTransparency = 1, ZIndex = z, Parent = o.Parent })
        local sb = New("Frame", { Size = UDim2.new(1, 0, 0, H(26)), BackgroundTransparency = 0, ZIndex = z, Theme = { BackgroundColor3 = "Field" }, Parent = root })
        Corner(sb, 5)
        local box = New("TextBox", { Text = "", PlaceholderText = o.Placeholder or "Search name or @username...", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 12,
                Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(8, 0), TextXAlignment = LEFT, ZIndex = z + 1, Parent = sb })
        local scopes = o.Scopes or { { "online", "Online" }, { "all", "Everyone" } }
        local state = { scope = o.Scope or scopes[1][1], q = "", offset = 0, gen = 0, rows = {}, tick = 0 }
        local chipBar = New("Frame", { Size = UDim2.new(1, 0, 0, H(22)), Position = UDim2.fromOffset(0, H(26) + 4), BackgroundTransparency = 1, ZIndex = z, Parent = root })
        List(chipBar, 4, Enum.FillDirection.Horizontal)
        local top = H(26) + 4 + H(22) + 6
        local info = New("TextLabel", { Text = "", TextSize = 10, Size = UDim2.new(1, 0, 0, 12), Position = UDim2.fromOffset(0, top), TextXAlignment = LEFT, ZIndex = z,
                Theme = { TextColor3 = "Dim" }, Parent = root })
        local list = New("ScrollingFrame", { Size = UDim2.new(1, 0, 1, -(top + 14)), Position = UDim2.fromOffset(0, top + 14), AutomaticCanvasSize = Y, ScrollBarThickness = 2, ZIndex = z, Parent = root })
        List(list, 2)
        local chips, Load = {}, nil
        local function StyleChips()
                for s, b in pairs(chips) do
                        local on = s == state.scope
                        b.BackgroundColor3 = on and Lib.Theme.Accent or Lib.Theme.Field
                        b.TextColor3 = on and Lib.KnobOn() or Lib.Theme.SubText
                end
        end
        for i, sc in ipairs(scopes) do
                local b = New("TextButton", { Text = sc[2], TextSize = 11, AutomaticSize = X, Size = UDim2.fromOffset(0, H(22)), LayoutOrder = i, BackgroundTransparency = 0, ZIndex = z + 1, Parent = chipBar })
                Corner(b, 11) Pad(b, 10, 0, 10, 0)
                chips[sc[1]] = b
                b.Activated:Connect(function() state.scope = sc[1] StyleChips() Load(false) end)
        end
        local function Refresh()
                for _, r in ipairs(state.rows) do
                        r.check.Visible = o.Mark ~= nil and o.Mark(r.u) == true
                        r.extra.Text = o.Extra and tostring(o.Extra(r.u) or "") or ""
                end
        end
        local function AddRow(u, order)
                local b = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, rh), LayoutOrder = order, ZIndex = z + 1, BackgroundTransparency = 1, BackgroundColor3 = Lib.Theme.FieldHover, Parent = list })
                Corner(b, 4)
                local dot = New("Frame", { Size = UDim2.fromOffset(7, 7), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), ZIndex = z + 2,
                        BackgroundColor3 = u.online and Lib.Theme.Good or Lib.Theme.Dim, Parent = b })
                Corner(dot, 4)
                New("TextLabel", { RichText = true, Text = RichEsc(u.display or u.name) .. " <font color='#" .. ToHex(Lib.Theme.Dim) .. "'>@" .. RichEsc(u.name) .. "</font>",
                        TextSize = 12, Size = UDim2.new(1, -92, 1, 0), Position = UDim2.fromOffset(22, 0), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = z + 2, Parent = b })
                local extra = New("TextLabel", { Text = "", TextSize = 10, Size = UDim2.fromOffset(60, rh), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -24, 0, 0),
                        TextXAlignment = RIGHT, ZIndex = z + 2, Theme = { TextColor3 = "Dim" }, Parent = b })
                local check = New("TextLabel", { Text = "✓", Font = Lib.FontBold, TextSize = 13, Size = UDim2.fromOffset(18, rh), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -4, 0, 0),
                        ZIndex = z + 2, Visible = false, Theme = { TextColor3 = "Accent" }, Parent = b })
                b.MouseEnter:Connect(function() Tween(b, { BackgroundTransparency = 0.35 }, 0.06) end)
                b.MouseLeave:Connect(function() Tween(b, { BackgroundTransparency = 1 }, 0.08) end)
                Press(b, function() if o.OnClick then o.OnClick(u, Refresh) end end)
                table.insert(state.rows, { u = u, extra = extra, check = check })
        end
        Load = function(append)
                state.gen = state.gen + 1
                local gen = state.gen
                if not append then
                        state.offset = 0
                        for _, c in ipairs(list:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
                        state.rows = {}
                        info.Text = "Searching..."
                else
                        local mb = list:FindFirstChild("More")
                        if mb then mb:Destroy() end
                end
                task.spawn(function()
                        local d = Decode(self:_Do("/users", { q = state.q, scope = state.scope, offset = state.offset, limit = 30 }))
                        if gen ~= state.gen or not root.Parent then return end
                        if not (d and d.ok) then info.Text = (d and d.error) or "Couldn't load people. Is your worker updated?" return end
                        local users = d.users or {}
                        local n0 = #state.rows
                        for i, u in ipairs(users) do
                                if not (o.Exclude and o.Exclude[tostring(u.uid)]) then AddRow(u, n0 + i) end
                        end
                        state.offset = state.offset + #users
                        local total = tonumber(d.total) or #users
                        local what = state.scope == "online" and " online" or (state.scope == "friends" and " friends" or " people")
                        info.Text = total == 0 and "No one found" or (total .. what .. (state.q ~= "" and " matching" or ""))
                        if state.offset < total then
                                local more = New("TextButton", { Name = "More", Text = "Show more (" .. (total - state.offset) .. ")", TextSize = 11, Size = UDim2.new(1, 0, 0, rh),
                                        LayoutOrder = 100000, ZIndex = z + 1, Theme = { TextColor3 = "Accent" }, Parent = list })
                                more.Activated:Connect(function() Load(true) end)
                        end
                        Refresh()
                end)
        end
        box:GetPropertyChangedSignal("Text"):Connect(function()
                state.tick = state.tick + 1
                local t = state.tick
                task.delay(0.3, function()
                        if t == state.tick and root.Parent then state.q = Trim(box.Text) Load(false) end
                end)
        end)
        StyleChips()
        Load(false)
        return { Root = root, Reload = function() Load(false) end, Refresh = Refresh, Box = box }
end

-- online list / person picker: search box, paging, scopes. No more 400-name wall.
function Chat:ShowUsers(pick)
        local isPick = type(pick) == "table" and type(pick.Callback) == "function"
        local w, h, sc = 280, H(400), Lib.Scale
        local frame = Sink(New("Frame", { Size = UDim2.fromOffset(w, h), BackgroundTransparency = 0, ZIndex = 85, Theme = { BackgroundColor3 = "Surface" }, Parent = Lib.Overlay }))
        Corner(frame, 6) Stroke(frame, "Stroke", 1, 0)
        New("UIScale", { Scale = sc, Parent = frame })
        New("TextLabel", { Text = isPick and (pick.Title or "Pick someone") or ("Online · " .. tostring(self.Online or 0)), Font = Lib.FontBold, TextSize = 12,
                Size = UDim2.new(1, -16, 0, 24), Position = UDim2.fromOffset(10, 4), TextXAlignment = LEFT, ZIndex = 86, Parent = frame })
        self:PeopleBrowser({ Parent = frame, Position = UDim2.fromOffset(8, 30), Size = UDim2.new(1, -16, 1, -38), Z = 86,
                Scopes = { { "online", "Online" }, { "friends", "Friends" }, { "all", "Everyone" } },
                Scope = (isPick and #self.Friends.friends > 0) and "friends" or "online",
                OnClick = function(u)
                        Lib:ClosePopup()
                        if isPick then Safe(pick.Callback, u) else self:ShowProfile(u) end
                end })
        local pos, hh = PlaceBelow(self.Pill, w * sc, h * sc, 6, true)
        frame.Position = UDim2.fromOffset(pos.X, pos.Y)
        frame.Size = UDim2.fromOffset(w, hh / sc)
        Lib:OpenPopup(frame, function() frame:Destroy() end, self.Pill)
end

-- ── user lookup by name / id (works for offline people) ──────────────────────────────────────────────
function Chat:ResolveUser(text, cb)
        text = (Trim(text):gsub("^@", ""))
        if text == "" then cb(nil) return end
        task.spawn(function()
                local uid, name
                if text:match("^%d+$") then
                        uid = tonumber(text)
                        local ok, n = pcall(function() return Players:GetNameFromUserIdAsync(uid) end)
                        name = ok and n or nil
                else
                        local ok, id = pcall(function() return Players:GetUserIdFromNameAsync(text) end)
                        if ok and id then
                                uid = id
                                local ok2, n = pcall(function() return Players:GetNameFromUserIdAsync(id) end)
                                name = ok2 and n or text
                        end
                end
                if uid and name then cb({ uid = uid, name = name, display = name }) else cb(nil) end
        end)
end

function Chat:DMByName()
        Lib:Prompt({ Title = "Message someone", Text = "Roblox username or user ID. They don't have to be online, they'll see it as an unread DM.",
                Placeholder = "username or id", Confirm = "Open DM" }, function(t)
                self:ResolveUser(t, function(u)
                        if not u then Lib:Notify({ Title = "Direct message", Text = "Couldn't find that Roblox user.", Type = "error" }) return end
                        if u.uid == LocalPlayer.UserId then Lib:Notify({ Title = "Direct message", Text = "That's you.", Type = "warn" }) return end
                        self:OpenDM(u.uid, u.name, u.display)
                end)
        end)
end

-- DMs: always open the tab and switch to it, online or not. The relay keeps it for both of you.
function Chat:OpenDM(uid, name, display)
        uid = tonumber(uid)
        if not uid or uid == LocalPlayer.UserId then return end
        local room = self:DMRoom(uid)
        if not room then return end
        self.HiddenDMs[room] = nil
        local idx = self:_RoomIndex(room)
        if not idx then
                self:AddDM(uid, name, display)
                idx = self:_RoomIndex(room)
        end
        if not idx then return end
        task.spawn(function()
                local q = { after = -1, peer = uid }
                if name and name ~= "" then q.peer_name = tostring(name) end
                if display and display ~= "" then q.peer_display = tostring(display) end
                self:_Do("/poll", q, nil, nil, room)
        end)
        self:SetChannel(idx)
end

-- same as the old one, but safe when the current channel was just removed
function Chat:SetChannel(i)
        local ch = self.Channels[i]
        if not ch or i == self.ChIndex then return end
        local old = self.Channels[self.ChIndex]
        if old then old.read, old.unread = self.LastId, 0 end
        ch.unread = 0
        self.ChIndex, self.Room = i, ch.room
        self.Gen = self.Gen + 1
        self.LastId, self.Seen, self.Known, self.Loaded, self.Fails = -1, {}, {}, false, 0
        self.JumpCount, self.Stick = 0, true
        self:SetReply(nil)
        if self.SearchOpen then self:ToggleSearch(false) end
        self:_ClearAll()
        self:SetPinned({})
        self:_RefreshChannel()
        if ch.kind == "dm" then
                self:System("Direct messages with " .. tostring(ch.name) .. " · only you two see these.")
        elseif ch.kind == "grp" then
                self:System("Group chat «" .. tostring(ch.name) .. "» · up to 10 members.")
        else
                self:System("Joined #" .. tostring(ch.name))
        end
        if self.Alive then
                task.spawn(function() self:_PollOnce() end)
        else
                self:Reconnect()
        end
end

-- the relay now sends unread counts + last message for every DM / group, so no more peeking at them
function Chat:_SyncRooms(dms, groups)
        dms = type(dms) == "table" and dms or {}
        groups = type(groups) == "table" and groups or {}
        self.HiddenDMs = self.HiddenDMs or {}
        local changed = false
        local cur = self.Channels[self.ChIndex]
        local function Bump(ch, d, label)
                local n = tonumber(d.unread) or 0
                if ch == cur then n = 0 end
                local l = type(d.last) == "table" and d.last or nil
                if l then ch.lastId = l.id end
                if n > (ch.unread or 0) and l and l.uid ~= LocalPlayer.UserId and ch.notified ~= l.id then
                        ch.notified = l.id
                        Lib:Notify({ Title = label .. " · " .. tostring(l.name or "?"), Text = tostring(l.text or ""), Type = "info", Duration = 5 })
                        if not self.PanelObj._shown and self.PanelObj.RailButton then self.PanelObj.RailButton:AddBadge() end
                end
                if n ~= (ch.unread or 0) then ch.unread = n changed = true end
        end
        for _, d in ipairs(dms) do
                local uid = tonumber(d.uid)
                if uid and uid ~= LocalPlayer.UserId then
                        local room = self:DMRoom(uid)
                        local idx = self:_RoomIndex(room)
                        local hid = self.HiddenDMs[room]
                        local lastId = (type(d.last) == "table" and tonumber(d.last.id)) or 0
                        if hid ~= nil and not idx and lastId <= hid then
                                -- you closed this DM and nothing new arrived
                        else
                                if hid ~= nil then self.HiddenDMs[room] = nil end
                                if not idx then
                                        self:AddDM(uid, d.name, d.display)
                                        idx = self:_RoomIndex(room)
                                        changed = true
                                end
                                local ch = idx and self.Channels[idx]
                                if ch then
                                        local nm = tostring((d.display and d.display ~= "") and d.display or d.name or uid)
                                        if ch.name ~= nm then ch.name = nm changed = true end
                                        Bump(ch, d, "DM")
                                end
                        end
                end
        end
        local seen = {}
        for _, g in ipairs(groups) do
                if g.id then
                        seen[tostring(g.id)] = true
                        local isNew = not self:_RoomIndex("grp:" .. tostring(g.id))
                        local ch = self:AddGroup(g)
                        if ch then
                                ch.creator = g.creator
                                if isNew then
                                        changed = true
                                        if self._roomsSynced and g.creator ~= LocalPlayer.UserId then
                                                Lib:Notify({ Title = "Group chat", Text = "You're in «" .. tostring(g.name) .. "».", Type = "info", Duration = 4 })
                                        end
                                end
                                Bump(ch, g, "Group")
                        end
                end
        end
        local removedAny = false
        for i = #self.Channels, 1, -1 do
                local ch = self.Channels[i]
                if ch.kind == "grp" and not seen[ch.gid] then
                        local wasCur = (self.ChIndex == i)
                        table.remove(self.Channels, i)
                        changed, removedAny = true, true
                        if wasCur then
                                self.ChIndex = -1
                                self:SetChannel(1)
                        elseif self.ChIndex > i then
                                self.ChIndex = self.ChIndex - 1
                        end
                end
        end
        self._roomsSynced = true
        if removedAny then self:SaveConvos() end -- keep the saved conversation list in step with the server's
        if changed then self:_RefreshChannel() end
end

-- unread badges only for public channels now (DMs + groups come with the poll)
function Chat:_StartPeeking()
        if self._peeking or not self.Request or not self.Config.Url then return end
        self._peeking = true
        task.spawn(function()
                while not Lib.Unloaded do
                        task.wait(self.PanelObj.Enabled and 12 or 25)
                        if self.Alive and not self.Blocked then
                                local changed = false
                                for i, ch in ipairs(self.Channels) do
                                        if i ~= self.ChIndex and not ch.kind then
                                                local d = Decode(self:_Do("/poll", { peek = 1, after = ch.read or -1 }, nil, nil, ch.room))
                                                if d and d.ok then
                                                        if ch.read == nil then
                                                                ch.read = d.last or 0
                                                        elseif (d.count or 0) ~= (ch.unread or 0) then
                                                                if (d.count or 0) > (ch.unread or 0) and not self.PanelObj._shown and self.PanelObj.RailButton then self.PanelObj.RailButton:AddBadge() end
                                                                ch.unread = d.count or 0
                                                                changed = true
                                                        end
                                                end
                                                task.wait(0.3)
                                        end
                                end
                                if changed then self:_RefreshChannel() end
                        end
                end
        end)
end

function Chat:ChannelMenu()
        local items = {}
        local function Chan(i, ch, label)
                local here = ch.id and tonumber(ch.id) == game.PlaceId
                local n = (i ~= self.ChIndex) and (ch.unread or 0) or 0
                table.insert(items, { Text = (i == self.ChIndex and "• " or "   ") .. label .. (here and "  (here)" or "") .. (n > 0 and ("  [" .. n .. " new]") or ""),
                        Callback = function() self:SetChannel(i) end })
        end
        local nd, ng = 0, 0
        for i, ch in ipairs(self.Channels) do
                if ch.kind == "dm" then nd = nd + 1
                elseif ch.kind == "grp" then ng = ng + 1
                else Chan(i, ch, "#" .. tostring(ch.name)) end
        end
        local cur = self.Channels[self.ChIndex]
        if nd > 0 then
                table.insert(items, { Header = true, Text = "DIRECT MESSAGES" })
                for i, ch in ipairs(self.Channels) do
                        if ch.kind == "dm" then Chan(i, ch, "@" .. Short(ch.name, 16)) end
                end
        end
        if ng > 0 then
                table.insert(items, { Header = true, Text = "GROUP CHATS · MAX 10" })
                for i, ch in ipairs(self.Channels) do
                        if ch.kind == "grp" then Chan(i, ch, "«" .. Short(ch.name, 13) .. "»" .. (#(ch.members or {}) > 0 and ("  " .. #(ch.members or {}) .. "/10") or "")) end
                end
        end
        table.insert(items, { Header = true, Text = "START" })
        local reqN = #self.Friends.incoming
        table.insert(items, { Text = "Friends" .. (reqN > 0 and ("  [" .. reqN .. " new]") or "") .. "...", Callback = function() self:ShowFriends(reqN > 0 and "requests" or "friends") end })
        table.insert(items, { Text = "New DM (search)...", Callback = function() self:PickUser(function(u) self:OpenDM(u.uid, u.name, u.display) end, "DM who?") end })
        table.insert(items, { Text = "DM by username...", Callback = function() self:DMByName() end })
        table.insert(items, { Text = "New group chat...", Callback = function() self:NewGroup() end })
        if cur and cur.kind == "dm" then
                table.insert(items, { Text = "Close this DM", Danger = true, Callback = function()
                        local idx = self:_RoomIndex(cur.room)
                        if idx then
                                self.HiddenDMs[cur.room] = cur.lastId or 0
                                table.remove(self.Channels, idx)
                                if self.ChIndex == idx then self.ChIndex = -1 self:SetChannel(1)
                                elseif self.ChIndex > idx then self.ChIndex = self.ChIndex - 1 self:_RefreshChannel() else self:_RefreshChannel() end
                        end
                        self:SaveConvos()
                end })
        end
        if cur and cur.kind == "grp" then
                table.insert(items, { Text = "Rename group...", Callback = function() self:RenameGroup(cur.gid) end })
                table.insert(items, { Text = "Invite member...", Callback = function() self:InviteToGroup(cur.gid) end })
                table.insert(items, { Text = "Leave group", Danger = true, Callback = function()
                        Lib:Dialog({ Title = "Leave group", Text = "Leave «" .. cur.name .. "»? Someone has to invite you back in.",
                                Buttons = { { Text = "Cancel" }, { Text = "Leave", Primary = true, Callback = function()
                                        task.spawn(function()
                                                local d = Decode(self:_Do("/group/leave", nil, "POST", HttpService:JSONEncode({ id = cur.gid })))
                                                if d and d.ok then
                                                        Lib:Notify({ Title = "Group chat", Text = "You left «" .. cur.name .. "».", Type = "success", Duration = 3 })
                                                        self:_PollOnce() -- the relay no longer lists it, _SyncRooms removes the tab
                                                else
                                                        Lib:Notify({ Title = "Group chat", Text = (d and d.error) or "Couldn't leave the group.", Type = "error" })
                                                end
                                        end)
                                end } } })
                end })
        end
        self:Menu(items, self.ChBtn)
end

-- group creation with search + friends scope
function Chat:NewGroup(preselect)
        local picked = {}
        if type(preselect) == "table" then
                if preselect.uid then picked[tostring(preselect.uid)] = preselect
                else for _, u in ipairs(preselect) do if u and u.uid then picked[tostring(u.uid)] = u end end end
        end
        local function Count() local n = 0 for _ in pairs(picked) do n = n + 1 end return n end
        local w, h = 290, H(440)
        local frame = Sink(New("Frame", { Size = UDim2.fromOffset(w, h), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0, ZIndex = 85,
                Theme = { BackgroundColor3 = "Surface" }, Parent = Lib.Overlay }))
        Corner(frame, 8) Stroke(frame, "Stroke", 1, 0)
        New("UIScale", { Scale = math.min(1, Lib.Overlay.AbsoluteSize.X / (w + 20), Lib.Overlay.AbsoluteSize.Y / (h + 20)), Parent = frame })
        New("TextLabel", { Text = "New group chat", Font = Lib.FontBold, TextSize = 13, Size = UDim2.new(1, -24, 0, 18), Position = UDim2.fromOffset(12, 10), TextXAlignment = LEFT, ZIndex = 86, Parent = frame })
        local nameBox = New("TextBox", { Text = "", PlaceholderText = "Group name (you can rename it later)", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 12,
                Size = UDim2.new(1, -24, 0, H(28)), Position = UDim2.fromOffset(12, 34), BackgroundTransparency = 0, TextXAlignment = LEFT, ZIndex = 86,
                Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = frame })
        Corner(nameBox, 5) Pad(nameBox, 8, 0, 8, 0) Stroke(nameBox, "Stroke", 1, 0.3)
        local counter = New("TextLabel", { Text = "", TextSize = 10, Size = UDim2.new(1, -24, 0, 12), Position = UDim2.fromOffset(12, 34 + H(28) + 4), TextXAlignment = LEFT,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 86, Theme = { TextColor3 = "Dim" }, Parent = frame })
        local function Update()
                local names = {}
                for _, u in pairs(picked) do table.insert(names, tostring(u.display or u.name)) end
                table.sort(names)
                counter.Text = (Count() + 1) .. "/" .. MAX_GROUP .. " people" .. (#names > 0 and ("  ·  " .. Short(table.concat(names, ", "), 36)) or "")
        end
        local top, foot = 34 + H(28) + 22, H(28) + 14
        self:PeopleBrowser({ Parent = frame, Position = UDim2.fromOffset(12, top), Size = UDim2.new(1, -24, 1, -(top + foot)), Z = 86,
                Scopes = { { "friends", "Friends" }, { "online", "Online" }, { "all", "Everyone" } },
                Scope = #self.Friends.friends > 0 and "friends" or "online",
                Mark = function(u) return picked[tostring(u.uid)] ~= nil end,
                OnClick = function(u, refresh)
                        local id = tostring(u.uid)
                        if picked[id] then
                                picked[id] = nil
                        elseif Count() >= MAX_GROUP - 1 then
                                Lib:Notify({ Title = "Group chat", Text = "A group holds at most " .. MAX_GROUP .. " people, including you.", Type = "warn", Duration = 4 })
                                return
                        else
                                picked[id] = u
                        end
                        Update()
                        refresh()
                end })
        local row = New("Frame", { Size = UDim2.new(1, -24, 0, H(28)), AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 12, 1, -10), BackgroundTransparency = 1, ZIndex = 86, Parent = frame })
        List(row, 6, Enum.FillDirection.Horizontal)
        local cancel = New("TextButton", { Text = "Cancel", TextSize = 12, Size = UDim2.new(0.5, -3, 1, 0), BackgroundTransparency = 0, ZIndex = 87, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = row })
        Corner(cancel, 5)
        local create = New("TextButton", { Text = "Create group", TextSize = 12, Size = UDim2.new(0.5, -3, 1, 0), BackgroundTransparency = 0, ZIndex = 87, Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = row })
        Corner(create, 5)
        cancel.Activated:Connect(function() Lib:ClosePopup() end)
        create.Activated:Connect(function()
                local name = Trim(nameBox.Text)
                if name == "" then Lib:Notify({ Text = "Give the group a name first.", Type = "warn" }) return end
                local members = {}
                for _, u in pairs(picked) do table.insert(members, tonumber(u.uid) or u.uid) end
                if #members < 1 then Lib:Notify({ Text = "Pick at least one member.", Type = "warn" }) return end
                create.Text = "Creating..."
                task.spawn(function()
                        local d = Decode(self:_Do("/group", nil, "POST", HttpService:JSONEncode({ name = name:sub(1, 32), members = members })))
                        if d and d.ok and d.group then
                                Lib:ClosePopup()
                                self:AddGroup(d.group)
                                local idx = self:_RoomIndex("grp:" .. tostring(d.group.id))
                                if idx then self:SetChannel(idx) end
                                Lib:Notify({ Title = "Group chat", Text = "«" .. name .. "» is live. Up to " .. MAX_GROUP .. " people.", Type = "success", Duration = 4 })
                        else
                                create.Text = "Create group"
                                Lib:Notify({ Title = "Group chat", Text = (d and d.error) or "Couldn't create the group. Is your worker updated?", Type = "error" })
                        end
                end)
        end)
        Update()
        Lib:OpenPopup(frame, function() if frame.Parent then frame:Destroy() end end)
end

-- ── friends ──────────────────────────────────────────────────────────────────────────────────────────
function Chat:FriendState(uid)
        local F, id = self.Friends, tostring(uid)
        if F.byId[id] then return "friends" end
        for _, r in ipairs(F.incoming) do if tostring(r.uid) == id then return "incoming" end end
        for _, r in ipairs(F.outgoing) do if tostring(r.uid) == id then return "outgoing" end end
        return nil
end

function Chat:_UpdateFriendBadge()
        local n = #self.Friends.incoming
        if self.FrBadge then
                self.FrBadge.Visible = n > 0
                self.FrBadgeText.Text = n > 9 and "9+" or tostring(n)
        end
end

function Chat:_SetFriends(d)
        local F = self.Friends
        F.friends, F.incoming, F.outgoing, F.ver, F.byId, F.online, F.loaded = d.friends or {}, d.incoming or {}, d.outgoing or {}, d.ver or 0, {}, {}, true
        for _, u in ipairs(F.friends) do
                F.byId[tostring(u.uid)] = u
                if u.online then F.online[tostring(u.uid)] = true end
        end
        self:_UpdateFriendBadge()
        if self.FriendsUI and self.FriendsUI.Alive() then self.FriendsUI.Render() end
end

function Chat:RefreshFriends(cb)
        task.spawn(function()
                local d = Decode(self:_Do("/friends"))
                if d and d.ok then self:_SetFriends(d) end
                if cb then Safe(cb) end
        end)
end

-- every poll carries { ver, incoming, online }: a new `ver` means your friend data changed, so the full list is re-fetched
function Chat:_SyncFriends(fr)
        local F = self.Friends
        local sig = table.concat(fr.online or {}, ",")
        local onlineChanged = sig ~= F.sig
        F.sig = sig
        F.online = {}
        for _, id in ipairs(fr.online or {}) do F.online[tostring(id)] = true end
        if fr.ver ~= F.ver then
                F.ver = fr.ver
                local had = {}
                for _, r in ipairs(F.incoming) do had[tostring(r.uid)] = true end
                local fresh = {}
                for _, r in ipairs(fr.incoming or {}) do if not had[tostring(r.uid)] then table.insert(fresh, r) end end
                F.incoming = fr.incoming or {}
                if #fresh == 1 then
                        Lib:Notify({ Title = "Friend request", Text = tostring(fresh[1].display or fresh[1].name) .. " wants to be your friend. Tap the friends icon.", Type = "info", Duration = 7 })
                elseif #fresh > 1 then
                        Lib:Notify({ Title = "Friend requests", Text = #fresh .. " new friend requests. Tap the friends icon.", Type = "info", Duration = 7 })
                end
                if #fresh > 0 and not self.PanelObj._shown and self.PanelObj.RailButton then self.PanelObj.RailButton:AddBadge() end
                self:RefreshFriends()
        end
        self:_UpdateFriendBadge()
        if onlineChanged and self.FriendsUI and self.FriendsUI.Alive() then self.FriendsUI.Render() end
end

-- action: request | accept | decline | cancel | remove
function Chat:Friend(action, u, cb)
        if not self.Request then return end
        task.spawn(function()
                local d = Decode(self:_Do("/friend/" .. action, nil, "POST", HttpService:JSONEncode({ uid = tonumber(u.uid), name = u.name, display = u.display })))
                if d and d.ok then
                        Lib:Notify({ Title = "Friends", Text = tostring(d.text or "Done."), Type = "success", Duration = 3 })
                        self:RefreshFriends(function() if cb then cb(d) end end)
                else
                        Lib:Notify({ Title = "Friends", Text = (d and d.error) or "Couldn't do that. Is your worker updated?", Type = "error" })
                        if cb then Safe(cb, d) end
                end
        end)
end

-- the Add friend / Remove friend row on a profile card
function Chat:_ProfileFriendRow(BtnRow, uid, name, display)
        local user = { uid = uid, name = name, display = display }
        local function Label()
                local s = self:FriendState(uid)
                return s == "friends" and "Remove friend" or (s == "incoming" and "Accept request" or (s == "outgoing" and "Cancel request" or "Add friend"))
        end
        BtnRow({ { Text = Label(), Primary = self:FriendState(uid) ~= "friends", Func = function(b)
                local s = self:FriendState(uid)
                local function Go()
                        local act = s == "friends" and "remove" or (s == "incoming" and "accept" or (s == "outgoing" and "cancel" or "request"))
                        self:Friend(act, user, function() if b.Parent then b.Text = Label() end end)
                end
                if s == "friends" then
                        Lib:Dialog({ Title = "Remove friend", Text = "Remove " .. tostring(display or name) .. " from your friends?",
                                Buttons = { { Text = "Cancel" }, { Text = "Remove", Primary = true, Callback = Go } } })
                else
                        Go()
                end
        end } })
end

function Chat:ShowFriends(startTab)
        if self.FriendsUI and self.FriendsUI.Alive() then self.FriendsUI.Close() end
        local F, Z = self.Friends, 90
        local W, HH = 330, H(440)
        local dim = New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.5, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = Z, Parent = Lib.Overlay })
        local card = Sink(New("Frame", { Size = UDim2.fromOffset(W, HH), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = Z + 1,
                Theme = { BackgroundColor3 = "Bg" }, Parent = dim }))
        Corner(card, 8) Stroke(card)
        New("UIScale", { Scale = math.min(1, Lib.Overlay.AbsoluteSize.X / (W + 30), Lib.Overlay.AbsoluteSize.Y / (HH + 30)), Parent = card })
        New("TextLabel", { Text = "Friends", Font = Lib.FontBold, TextSize = 14, Size = UDim2.new(1, -80, 0, 30), Position = UDim2.fromOffset(12, 0), TextXAlignment = LEFT, ZIndex = Z + 2, Parent = card })
        local closeB = New("TextButton", { Text = "Close", TextSize = 12, Size = UDim2.fromOffset(52, 22), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 4),
                BackgroundTransparency = 0, ZIndex = Z + 2, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = card })
        Corner(closeB, 5)
        local ui = { tab = startTab or "friends", q = "" }
        function ui.Alive() return dim.Parent ~= nil end
        function ui.Close() if dim.Parent then dim:Destroy() end end
        closeB.Activated:Connect(ui.Close)
        dim.Activated:Connect(ui.Close)
        local tabBar = New("Frame", { Size = UDim2.new(1, -24, 0, H(26)), Position = UDim2.fromOffset(12, 34), BackgroundTransparency = 1, ZIndex = Z + 2, Parent = card })
        List(tabBar, 6, Enum.FillDirection.Horizontal)
        local content = New("Frame", { Size = UDim2.new(1, -24, 1, -(34 + H(26) + 14)), Position = UDim2.fromOffset(12, 34 + H(26) + 8), BackgroundTransparency = 1, ZIndex = Z + 2, Parent = card })
        local tabs = {}
        local function Online(u) return F.online[tostring(u.uid)] == true end
        local function Clear() for _, c in ipairs(content:GetChildren()) do c:Destroy() end end
        local function TabLabels()
                local onl = 0
                for _, u in ipairs(F.friends) do if Online(u) then onl = onl + 1 end end
                tabs.friends.Text = "Friends " .. onl .. "/" .. #F.friends
                tabs.requests.Text = "Requests" .. (#F.incoming > 0 and (" (" .. #F.incoming .. ")") or "")
                tabs.add.Text = "Add"
                for k, b in pairs(tabs) do
                        local on = k == ui.tab
                        b.BackgroundColor3 = on and Lib.Theme.Accent or Lib.Theme.Field
                        b.TextColor3 = on and Lib.KnobOn() or Lib.Theme.SubText
                end
        end
        local function Row(parent, order, u, sub, buttons)
                if u.bio and u.bio ~= "" then sub = sub .. "  ·  " .. u.bio end
                local b = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, H(42)), LayoutOrder = order, BackgroundTransparency = 1, BackgroundColor3 = Lib.Theme.FieldHover, ZIndex = Z + 3, Parent = parent })
                Corner(b, 5)
                local av = New("ImageLabel", { Size = UDim2.fromOffset(30, 30), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 6, 0.5, 0), BackgroundTransparency = 0,
                        ZIndex = Z + 4, Theme = { BackgroundColor3 = "Field" }, Parent = b })
                Corner(av, 15)
                local fid = tonumber(u.uid)
                if fid then GetAvatar(fid, function(url) if av.Parent then av.Image = url end end) end
                local dot = New("Frame", { Size = UDim2.fromOffset(10, 10), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 2, 1, 2), ZIndex = Z + 5,
                        BackgroundColor3 = Online(u) and Lib.Theme.Good or Lib.Theme.Dim, Parent = av })
                Corner(dot, 5)
                Stroke(dot, "Bg", 2, 0)
                local reserve = 50 + #buttons * 58
                New("TextLabel", { Text = tostring(u.display or u.name), Font = Lib.FontBold, TextSize = 12, Size = UDim2.new(1, -reserve, 0, 16), Position = UDim2.fromOffset(44, 6),
                        TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = Z + 4, Parent = b })
                New("TextLabel", { Text = sub, TextSize = 10, Size = UDim2.new(1, -reserve, 0, 12), Position = UDim2.fromOffset(44, 23), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd,
                        ZIndex = Z + 4, Theme = { TextColor3 = "Dim" }, Parent = b })
                for i, bt in ipairs(buttons) do
                        local nb = New("TextButton", { Text = bt.Text, TextSize = 11, Size = UDim2.fromOffset(54, H(24)), AnchorPoint = Vector2.new(1, 0.5),
                                Position = UDim2.new(1, -6 - (#buttons - i) * 58, 0.5, 0), BackgroundTransparency = 0, ZIndex = Z + 5,
                                Theme = bt.Primary and { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" } or { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = b })
                        Corner(nb, 4)
                        nb.Activated:Connect(function() bt.Func(u) end)
                end
                b.MouseEnter:Connect(function() Tween(b, { BackgroundTransparency = 0.4 }, 0.06) end)
                b.MouseLeave:Connect(function() Tween(b, { BackgroundTransparency = 1 }, 0.08) end)
                b.Activated:Connect(function() self:ShowProfile(u) end)
        end
        local function Empty(parent, text, order)
                New("TextLabel", { Text = text, TextSize = 12, TextWrapped = true, Size = UDim2.new(1, 0, 0, 44), LayoutOrder = order or 0, ZIndex = Z + 3, Theme = { TextColor3 = "Dim" }, Parent = parent })
        end
        local function ListFrame(offset)
                local l = New("ScrollingFrame", { Size = UDim2.new(1, 0, 1, -offset), Position = UDim2.fromOffset(0, offset), AutomaticCanvasSize = Y, ScrollBarThickness = 2, ZIndex = Z + 2, Parent = content })
                List(l, 2)
                return l
        end
        local function RenderFriends()
                Clear()
                local sb = New("TextBox", { Text = ui.q, PlaceholderText = "Search friends...", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 12, Size = UDim2.new(1, 0, 0, H(26)),
                        BackgroundTransparency = 0, TextXAlignment = LEFT, ZIndex = Z + 3, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = content })
                Corner(sb, 5) Pad(sb, 8, 0, 8, 0)
                local list = ListFrame(H(26) + 6)
                local function Fill()
                        for _, c in ipairs(list:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
                        local q = ui.q:lower()
                        local arr = {}
                        for _, u in ipairs(F.friends) do
                                if q == "" or (tostring(u.name) .. " " .. tostring(u.display or "")):lower():find(q, 1, true) then table.insert(arr, u) end
                        end
                        table.sort(arr, function(a, b)
                                local oa, ob = Online(a), Online(b)
                                if oa ~= ob then return oa end
                                return tostring(a.display or a.name):lower() < tostring(b.display or b.name):lower()
                        end)
                        if #arr == 0 then
                                Empty(list, #F.friends == 0 and "No friends yet. Click someone in chat and tap Add friend, or use the Add tab." or "No matches.")
                        end
                        for i, u in ipairs(arr) do
                                local sub = Online(u) and (((tonumber(u.place) or 0) > 0) and "Online · in a game" or "Online") or ("Offline · " .. Ago(u.seen))
                                Row(list, i, u, sub, { { Text = "Message", Primary = true, Func = function(x) ui.Close() self:OpenDM(x.uid, x.name, x.display) end } })
                        end
                end
                sb:GetPropertyChangedSignal("Text"):Connect(function() ui.q = sb.Text Fill() end)
                Fill()
        end
        local function RenderRequests()
                Clear()
                local list = ListFrame(0)
                local n = 0
                local function Head(t)
                        n = n + 1
                        New("TextLabel", { Text = string.upper(t), Font = Lib.FontBold, TextSize = 10, Size = UDim2.new(1, 0, 0, 18), LayoutOrder = n, TextXAlignment = LEFT, ZIndex = Z + 3,
                                Theme = { TextColor3 = "Dim" }, Parent = list })
                end
                Head("Incoming · " .. #F.incoming)
                for _, u in ipairs(F.incoming) do
                        n = n + 1
                        Row(list, n, u, "wants to be your friend", {
                                { Text = "Accept", Primary = true, Func = function(x) self:Friend("accept", x) end },
                                { Text = "Decline", Func = function(x) self:Friend("decline", x) end },
                        })
                end
                if #F.incoming == 0 then n = n + 1 Empty(list, "No incoming requests.", n) end
                Head("Sent · " .. #F.outgoing)
                for _, u in ipairs(F.outgoing) do
                        n = n + 1
                        Row(list, n, u, "waiting for them to accept", { { Text = "Cancel", Func = function(x) self:Friend("cancel", x) end } })
                end
                if #F.outgoing == 0 then n = n + 1 Empty(list, "Nothing pending.", n) end
        end
        local function RenderAdd()
                Clear()
                local idBox = New("TextBox", { Text = "", PlaceholderText = "Roblox username or ID", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 12, Size = UDim2.new(1, -64, 0, H(26)),
                        BackgroundTransparency = 0, TextXAlignment = LEFT, ZIndex = Z + 3, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = content })
                Corner(idBox, 5) Pad(idBox, 8, 0, 8, 0)
                local go = New("TextButton", { Text = "Send", TextSize = 12, Size = UDim2.fromOffset(56, H(26)), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
                        BackgroundTransparency = 0, ZIndex = Z + 3, Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = content })
                Corner(go, 5)
                go.Activated:Connect(function()
                        self:ResolveUser(idBox.Text, function(u)
                                if not u then Lib:Notify({ Title = "Friends", Text = "Couldn't find that Roblox user.", Type = "error" }) return end
                                if u.uid == LocalPlayer.UserId then Lib:Notify({ Title = "Friends", Text = "That's you.", Type = "warn" }) return end
                                self:Friend("request", u)
                                idBox.Text = ""
                        end)
                end)
                self:PeopleBrowser({ Parent = content, Position = UDim2.fromOffset(0, H(26) + 8), Size = UDim2.new(1, 0, 1, -(H(26) + 8)), Z = Z + 2,
                        Scopes = { { "online", "Online" }, { "all", "Everyone" } },
                        Extra = function(u)
                                local s = self:FriendState(u.uid)
                                return s == "friends" and "Friends" or (s == "outgoing" and "Sent" or (s == "incoming" and "Accept?" or nil))
                        end,
                        OnClick = function(u, refresh)
                                local s = self:FriendState(u.uid)
                                if s == "friends" then
                                        Lib:Notify({ Title = "Friends", Text = "You're already friends.", Type = "info", Duration = 2 })
                                elseif s == "outgoing" then
                                        Lib:Notify({ Title = "Friends", Text = "Request already sent.", Type = "info", Duration = 2 })
                                else
                                        self:Friend(s == "incoming" and "accept" or "request", u, function() refresh() end)
                                end
                        end })
        end
        local function Show(tab)
                ui.tab = tab
                TabLabels()
                if tab == "friends" then RenderFriends() elseif tab == "requests" then RenderRequests() else RenderAdd() end
        end
        function ui.Render()
                if not dim.Parent then return end
                if ui.tab == "add" then TabLabels() else Show(ui.tab) end
        end
        for i, k in ipairs({ "friends", "requests", "add" }) do
                local b = New("TextButton", { Text = k, TextSize = 12, AutomaticSize = X, Size = UDim2.fromOffset(0, H(26)), LayoutOrder = i, BackgroundTransparency = 0, ZIndex = Z + 3, Parent = tabBar })
                Corner(b, 13) Pad(b, 12, 0, 12, 0)
                tabs[k] = b
                b.Activated:Connect(function() Show(k) end)
        end
        self.FriendsUI = ui
        Show(ui.tab)
        self:RefreshFriends()
end

-- ── images ───────────────────────────────────────────────────────────────────────────────────────────
-- raw download from /imgraw (no base64, so big images are fine). Falls back to the old JSON route.
function Chat:LoadImage(img, cb)
        local cached = Lib.ImgAssets[img.id]
        if cached then cb(cached) return end
        if not (FsOk() and (getcustomasset or getsynasset)) then cb(nil, "your executor can't show images") return end
        task.spawn(function()
                local path = CachePath(img.id, img.mime)
                local have = false
                pcall(function() have = isfile(path) end)
                if not have then
                        local saved = false
                        local res = self:_Do("/imgraw", { id = img.id })
                        if res and res.StatusCode == 200 and type(res.Body) == "string" and #res.Body > 64 and res.Body:sub(1, 1) ~= "{" then
                                saved = pcall(writefile, path, res.Body)
                        end
                        if not saved then
                                local d = Decode(self:_Do("/img", { id = img.id }))
                                if not (d and d.ok and d.data) then cb(nil, (d and d.error) or "download failed") return end
                                local okd, bytes = pcall(B64Decode, d.data)
                                if not okd or not pcall(writefile, path, bytes) then cb(nil, "couldn't save it") return end
                        end
                end
                local asset = CustomAsset(path)
                if asset then Lib.ImgAssets[img.id] = asset cb(asset) else cb(nil, "couldn't open it") end
        end)
end

-- image search window: refine the search without closing, GIF toggle, "more results", thumbnails come through the relay
function Chat:ShowResults(q)
        local canThumb = FsOk() and (getcustomasset or getsynasset) ~= nil
        local dim = New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.5, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 100, Parent = Lib.Overlay })
        local card = Sink(New("Frame", { Size = UDim2.fromOffset(360, 440), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 101,
                Theme = { BackgroundColor3 = "Bg" }, Parent = dim }))
        Corner(card, 8) Stroke(card)
        New("UIScale", { Scale = math.min(1, Lib.Overlay.AbsoluteSize.X / 390, Lib.Overlay.AbsoluteSize.Y / 470), Parent = card })
        New("TextLabel", { Text = "Image search", Font = Lib.FontBold, TextSize = 14, Size = UDim2.new(1, -80, 0, 30), Position = UDim2.fromOffset(12, 0), TextXAlignment = LEFT, ZIndex = 102, Parent = card })
        local close = New("TextButton", { Text = "Close", TextSize = 12, Size = UDim2.fromOffset(56, 22), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 4), BackgroundTransparency = 0,
                ZIndex = 102, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = card })
        Corner(close, 5)
        local function Close() if dim.Parent then dim:Destroy() end end
        close.Activated:Connect(Close)
        dim.Activated:Connect(Close)
        local box = New("TextBox", { Text = q or "", PlaceholderText = "Search the internet...", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 12, Size = UDim2.new(1, -172, 0, 26),
                Position = UDim2.fromOffset(10, 34), BackgroundTransparency = 0, TextXAlignment = LEFT, ZIndex = 102, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = card })
        Corner(box, 5) Pad(box, 8, 0, 8, 0)
        local st = { q = q or "", page = 1, gen = 0, gif = false }
        local gifBtn = New("TextButton", { Text = "GIF", TextSize = 11, Size = UDim2.fromOffset(52, 26), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -74, 0, 34), BackgroundTransparency = 0,
                ZIndex = 102, Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = card })
        Corner(gifBtn, 5)
        local goBtn = New("TextButton", { Text = "Search", TextSize = 12, Size = UDim2.fromOffset(60, 26), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 34), BackgroundTransparency = 0,
                ZIndex = 102, Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = card })
        Corner(goBtn, 5)
        local grid = New("ScrollingFrame", { Size = UDim2.new(1, -16, 1, -92), Position = UDim2.fromOffset(8, 68), AutomaticCanvasSize = Y, ScrollBarThickness = 3, ZIndex = 102, Parent = card })
        New("UIGridLayout", { CellSize = UDim2.fromOffset(104, 104), CellPadding = UDim2.fromOffset(6, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = grid })
        local status = New("TextLabel", { Text = "", TextSize = 10, Size = UDim2.new(1, -20, 0, 14), AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 10, 1, -6), TextXAlignment = LEFT,
                ZIndex = 102, Theme = { TextColor3 = "Dim" }, Parent = card })
        local function Run(page)
                st.gen = st.gen + 1
                local gen = st.gen
                st.page = page
                if page == 1 then
                        for _, c in ipairs(grid:GetChildren()) do if not c:IsA("UIGridLayout") then c:Destroy() end end
                else
                        local m = grid:FindFirstChild("More")
                        if m then m:Destroy() end
                end
                status.Text = "Searching..."
                task.spawn(function()
                        local d = Decode(self:_Do("/search", { q = st.q, page = page, gif = st.gif and "1" or "0" }))
                        if gen ~= st.gen or not card.Parent then return end
                        if not (d and d.ok) then status.Text = (d and d.error) or "Search failed. Is your worker updated?" return end
                        local results = d.results or {}
                        status.Text = (#results == 0 and page == 1) and "No results." or "Tap an image to send it (full size, up to 2 MB). GIFs may show as a still."
                        for i, r in ipairs(results) do
                                local b = New("TextButton", { Text = canThumb and "" or Short(r.title, 30), TextSize = 10, TextWrapped = true, LayoutOrder = (page - 1) * 100 + i, BackgroundTransparency = 0,
                                        ZIndex = 103, Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = grid })
                                Corner(b, 6)
                                local pic = New("ImageLabel", { Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop, ZIndex = 104, Parent = b })
                                Corner(pic, 6)
                                if r.gif then
                                        local tag = New("TextLabel", { Text = "GIF", Font = Lib.FontBold, TextSize = 8, Size = UDim2.fromOffset(24, 12), AnchorPoint = Vector2.new(1, 1),
                                                Position = UDim2.new(1, -3, 1, -3), BackgroundTransparency = 0.2, ZIndex = 105, TextColor3 = WHITE, BackgroundColor3 = Lib.Theme.Accent, Parent = b })
                                        Corner(tag, 3)
                                end
                                b.Activated:Connect(function()
                                        Close()
                                        self:SendImage({ url = r.url, fallback = r.thumb })
                                end)
                                if canThumb then
                                        Lib:AddTooltip(b, r.title)
                                        task.spawn(function()
                                                local base = Lib.ConfigFolder .. "/cache/th_" .. tostring(r.id)
                                                local asset
                                                for _, ext in ipairs({ ".jpg", ".png", ".bmp" }) do
                                                        local ok, ex = pcall(isfile, base .. ext)
                                                        if ok and ex then asset = CustomAsset(base .. ext) break end
                                                end
                                                if not asset then
                                                        local res = self:_Do("/thumb", { u = r.thumb })
                                                        if res and res.StatusCode == 200 and type(res.Body) == "string" and #res.Body > 64 and res.Body:sub(1, 1) ~= "{" then
                                                                local ext = ThumbExt(res.Body)
                                                                if ext then
                                                                        CachePath("x", "image/png") -- makes sure the cache folder exists
                                                                        if pcall(writefile, base .. ext, res.Body) then asset = CustomAsset(base .. ext) end
                                                                end
                                                        end
                                                end
                                                if asset and pic.Parent then pic.Image = asset end
                                        end)
                                end
                        end
                        if d.more then
                                local more = New("TextButton", { Name = "More", Text = "More results", TextSize = 12, LayoutOrder = page * 100, BackgroundTransparency = 0, ZIndex = 103,
                                        Theme = { BackgroundColor3 = "Field", TextColor3 = "Accent" }, Parent = grid })
                                Corner(more, 6)
                                more.Activated:Connect(function() Run(page + 1) end)
                        end
                end)
        end
        local function Go()
                local t = Trim(box.Text)
                if t == "" then return end
                st.q = t
                Run(1)
        end
        goBtn.Activated:Connect(Go)
        box.FocusLost:Connect(function(enter) if enter then Go() end end)
        gifBtn.Activated:Connect(function()
                st.gif = not st.gif
                gifBtn.BackgroundColor3 = st.gif and Lib.Theme.Accent or Lib.Theme.Field
                gifBtn.TextColor3 = st.gif and Lib.KnobOn() or Lib.Theme.SubText
                Go()
        end)
        if st.q ~= "" then Run(1) end
end

Lib.HasFS = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
        and type(listfiles) == "function" and type(makefolder) == "function" and type(isfolder) == "function"

local function Sanitize(n) return (tostring(n):gsub("[^%w%-_ ]", ""):gsub("^%s+", ""):gsub("%s+$", "")) end

local function Ensure()
        if not Lib.HasFS then return false end
        pcall(function()
                if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                if not isfolder(Lib.ConfigFolder .. "/configs") then makefolder(Lib.ConfigFolder .. "/configs") end
        end)
        return true
end

local function CPath(n) return Lib.ConfigFolder .. "/configs/" .. n .. ".json" end

function Lib:SerializeConfig()
        local data = {}
        for idx, obj in pairs(self.Options) do
                if not (obj.Info and obj.Info.IgnoreConfig) and not tostring(idx):find("^__") then
                        local t = obj.Type
                        if t == "Toggle" or t == "Slider" or t == "Input" or t == "Segmented" then
                                data[idx] = { Type = t, Value = obj.Value }
                        elseif t == "Range" then
                                data[idx] = { Type = t, Min = obj.Value.Min, Max = obj.Value.Max }
                        elseif t == "Dropdown" then
                                local v = obj.Value
                                if obj.Info.Multi then
                                        local l = {}
                                        for _, n in ipairs(obj.Values) do if v[n] then table.insert(l, n) end end
                                        v = l
                                end
                                data[idx] = { Type = t, Value = v }
                        elseif t == "ColorPicker" then
                                data[idx] = { Type = t, R = obj.Value.R, G = obj.Value.G, B = obj.Value.B, Transparency = obj.Transparency, Rainbow = obj.RainbowOn }
                        elseif t == "KeyPicker" then
                                data[idx] = { Type = t, Key = KeyName(obj.Key), Mode = obj.Mode }
                        end
                end
        end
        return data
end

function Lib:ApplyConfig(data)
        for idx, saved in pairs(data) do
                local obj = self.Options[idx]
                if obj and obj.Type == saved.Type then
                        pcall(function()
                                local t = obj.Type
                                if t == "Dropdown" then
                                        if saved.Value == nil and not obj.Info.AllowNull then return end
                                        obj:SetValue(saved.Value)
                                elseif t == "Toggle" or t == "Slider" or t == "Input" or t == "Segmented" then obj:SetValue(saved.Value)
                                elseif t == "Range" then obj:SetValue({ Min = saved.Min, Max = saved.Max })
                                elseif t == "ColorPicker" then obj:SetValue(Color3.new(saved.R, saved.G, saved.B), saved.Transparency) obj:SetRainbow(saved.Rainbow)
                                elseif t == "KeyPicker" then obj:SetValue({ Key = saved.Key, Mode = saved.Mode }) end
                        end)
                end
        end
end

function Lib:ResetAll()
        for idx, obj in pairs(self.Options) do
                if obj._def ~= nil and not (obj.Info and obj.Info.IgnoreConfig) and not tostring(idx):find("^__") then
                        pcall(function()
                                if obj.Type == "ColorPicker" then obj:SetRainbow(false) obj:SetValue(obj._def) else obj:SetValue(obj._def) end
                        end)
                end
        end
end

function Lib:SaveConfig(name)
        if not self.HasFS then return false, "Your executor has no file functions." end
        name = Sanitize(name or "")
        if name == "" then return false, "Config name is empty." end
        Ensure()
        local ok, err = pcall(function() writefile(CPath(name), HttpService:JSONEncode(self:SerializeConfig())) end)
        if not ok then return false, tostring(err) end
        return true
end

function Lib:LoadConfig(name)
        if not self.HasFS then return false, "Your executor has no file functions." end
        name = Sanitize(name or "")
        local ok, content = pcall(function() if isfile(CPath(name)) then return readfile(CPath(name)) end end)
        if not ok or not content then return false, "Config not found." end
        local dec, data = pcall(HttpService.JSONDecode, HttpService, content)
        if not dec or type(data) ~= "table" then return false, "Config file is corrupted." end
        self:ApplyConfig(data)
        return true
end

function Lib:DeleteConfig(name)
        if not self.HasFS or type(delfile) ~= "function" then return false end
        name = Sanitize(name or "")
        return pcall(function() if isfile(CPath(name)) then delfile(CPath(name)) end end)
end

function Lib:ListConfigs()
        local out = {}
        if not self.HasFS then return out end
        Ensure()
        local ok, files = pcall(listfiles, self.ConfigFolder .. "/configs")
        if ok and files then
                for _, p in ipairs(files) do
                        local n = tostring(p):match("([^/\\]+)%.json$")
                        if n then table.insert(out, n) end
                end
        end
        table.sort(out)
        return out
end

function Lib:SetAutoload(name)
        if not self.HasFS then return false end
        Ensure()
        return pcall(function() writefile(self.ConfigFolder .. "/autoload.txt", Sanitize(name or "")) end)
end

function Lib:GetAutoload()
        if not self.HasFS then return nil end
        local ok, c = pcall(function() local p = self.ConfigFolder .. "/autoload.txt" if isfile(p) then return readfile(p) end end)
        if ok and c and c ~= "" then return c end
end

function Lib:LoadAutoload()
        local name = self:GetAutoload()
        if not name then return false end
        local ok = self:LoadConfig(name)
        if ok then self:Notify({ Title = "Config", Text = "Autoloaded " .. name, Type = "success" }) end
        return ok
end

Lib.Presets = {
        Blue = Color3.fromRGB(116, 148, 242), Teal = Color3.fromRGB(86, 182, 170), Violet = Color3.fromRGB(139, 92, 246),
        Rose = Color3.fromRGB(232, 110, 140), Amber = Color3.fromRGB(226, 170, 80), Red = Color3.fromRGB(224, 96, 104),
        Green = Color3.fromRGB(92, 184, 128), Mono = Color3.fromRGB(200, 202, 210),
}


function Lib:BuildSettingsTab(window)
        local tab = window:AddTab("Settings", "settings")
        local ui = tab:AddSubTab("Interface")
        local menu = ui:AddLeftGroupbox("Menu", { Icon = "layout-panel-left" })
        menu:AddLabel("Menu keybind"):AddKeyPicker("__MenuKey", { Default = Lib.ToggleKey.Name, Mode = "Always", IgnoreConfig = true,
                ChangedCallback = function(k) Lib.ToggleKey = (typeof(k) == "EnumItem" and k.EnumType == Enum.KeyCode) and k or Enum.KeyCode.Unknown end })
        menu:AddToggle("ShowWatermark", { Text = "Watermark", Default = true, Callback = function(v) if Lib.Watermark then Lib.Watermark:SetVisible(v) end end })
        menu:AddToggle("ShowKeybinds", { Text = "Keybind list", Default = true, Callback = function(v) if Lib.KeybindList then Lib.KeybindList:SetVisible(v) end end })
        menu:AddToggle("ShowESPPreview", { Text = "ESP preview panel", Default = false, Callback = function(v) local p = Lib.Panels.ESPPreview if p then p.UserSet = true p:Set(v) end end })
        menu:AddToggle("ShowChat", { Text = "Chat panel", Default = false, Callback = function(v) local p = Lib.Panels.Chat if p then p.UserSet = true p:Set(v) end end })
        menu:AddToggle("NotifyOn", { Text = "Notifications", Default = true, Callback = function(v) Lib.NotifyEnabled = v end })
        menu:AddToggle("ShareServer", { Text = "Share my game in chat", Default = true, Tooltip = "Lets other chat users see which game/server you're in and join you.", Callback = function(v) Lib.ShareServer = v end })
        menu:AddToggle("HideName", { Text = "Hide my name", Default = false, Callback = function(v) window:SetNameHidden(v) end })
        menu:AddButton({ Text = "Minimize window", Icon = "minus", Func = function() window:SetMinimized(true) end })
        menu:AddButtonRow({
                { Text = "Re-dock panels", Func = function() for _, p in pairs(Lib.Panels) do if p.Dock then p:Dock(true) end end end },
                { Text = "Reset position", Func = function() window:ResetPosition() end },
        })
        menu:AddDivider()
        menu:AddButton({ Text = "Reset all options", DoubleClick = true, Icon = "rotate-ccw", Func = function()
                Lib:ResetAll()
                Lib:Notify({ Title = "Options", Text = "Everything is back to its default.", Type = "success" })
        end })
        menu:AddButton({ Text = "Unload", Icon = "power", Func = function()
                Lib:Dialog({ Title = "Unload " .. Lib.Name, Text = "This removes the UI and stops everything it started.",
                        Buttons = { { Text = "Cancel" }, { Text = "Unload", Primary = true, Callback = function() Lib:Unload() end } } })
        end })
        local look = ui:AddRightGroupbox("Appearance", { Icon = "palette" })
        look:AddDropdown("__Theme", { Text = "Theme", Values = { "Dark", "Midnight", "Graphite", "Mocha", "Forest", "Light" }, Default = 1, IgnoreConfig = true, Callback = function(n) Lib:SetTheme(n) end })
        look:AddDropdown("__Preset", { Text = "Accent preset", Values = { "Blue", "Teal", "Violet", "Rose", "Amber", "Red", "Green", "Mono" }, Default = 3, IgnoreConfig = true,
                Callback = function(n) if Lib.Presets[n] and Lib.Options.AccentColor then Lib.Options.AccentColor:SetValue(Lib.Presets[n]) end end })
        look:AddLabel("Accent color"):AddColorPicker("AccentColor", { Default = Lib.Theme.Accent, Rainbow = false })
        Lib.Options.AccentColor:OnChanged(function(c) Lib:SetAccent(c) end)
        local pendingScale, pendingAt
        look:AddSlider("UiScale", { Text = "UI size (applies on release)", Min = 50, Max = 150, Default = math.floor(Lib.Scale * 100 + 0.5), Suffix = "%", IgnoreConfig = true,
                Tooltip = "Sized automatically for your screen. Drag, then let go to apply.", Callback = function(v) pendingScale, pendingAt = v, os.clock() end })
        Lib:Connect(RunService.Heartbeat, function()
                local sl = Lib.Options.UiScale
                if pendingScale and os.clock() - pendingAt > 0.12 and not (sl and sl._drag) then
                        local v = pendingScale
                        pendingScale = nil
                        Lib:SetScale(v / 100)
                end
        end)
        look:AddButton({ Text = "Auto fit to my screen", Icon = "maximize", Func = function()
                Lib.UserScaled, window.UserSized = false, false
                window:AutoFit(true)
        end })
        look:AddSlider("WinOpacity", { Text = "UI transparency", Min = 0, Max = 60, Default = 0, Suffix = "%", Callback = function(v) window:SetTransparency(v / 100) end })
        look:AddToggle("LockWindow", { Text = "Lock window position", Default = false, Callback = function(v) window:SetLocked(v) end })
        look:AddSlider("PtrOffset", { Text = "Cursor offset (Y)", Min = -80, Max = 80, Default = 0, Suffix = "px", IgnoreConfig = true,
                Tooltip = "Only if clicks land away from your cursor. It auto-calibrates, this is a manual override.",
                Callback = function(v) Lib.PtrShift = Vector2.new(0, v) end })
        local chatUi = ui:AddRightGroupbox("Chat", { Icon = "message-square", Collapsible = true })
        chatUi:AddToggle("LinkPreviews", { Text = "Link previews", Default = true, Callback = function(v) Lib.LinkPreviews = v end })
        chatUi:AddToggle("AutoImages", { Text = "Load images automatically", Default = true, Callback = function(v) Lib.ShowImages = v end })
        chatUi:AddInput("__ChatBio", { Text = "Chat bio", Placeholder = "Shown on your profile card", Default = Lib:LoadBio(), MaxLength = 120, IgnoreConfig = true, Callback = function(v) Lib:SetBio(v) end })
        chatUi:AddDropdown("__BlockedList", { Text = "Blocked users", Values = {}, AllowNull = true, Placeholder = "Nobody blocked", IgnoreConfig = true })
        chatUi:AddButton({ Text = "Unblock selected", Func = function()
                local v = Lib.Options.__BlockedList.Value
                local uid = v and Lib._blockLabels and Lib._blockLabels[v]
                if uid then Lib:Unblock(uid) Lib.Options.__BlockedList:SetValue(nil, true)
                else Lib:Notify({ Text = "Pick someone from the list first.", Type = "warn" }) end
        end })
        chatUi:AddButton({ Text = "Unblock everyone", DoubleClick = true, Func = function()
                Lib.BlockList = {}
                Lib:SaveBlocks()
                Lib:_AfterBlockChange()
                Lib.Options.__BlockedList:SetValue(nil, true)
        end })
        Lib:LoadBlocks()
        Lib:_AfterBlockChange()

        -- ESP / visuals live here now. Flags keep the same names (ESPBox, ESPName, ...) for your own scripts to read.
        local esp = tab:AddSubTab("ESP")
        local function Opt(n) return function(v) if Lib.Preview then Lib.Preview:SetOption(n, v) end end end
        local E = esp:AddLeftGroupbox("ESP", { Icon = "scan" })
        E:AddToggle("ESPBox", { Text = "Box", Default = true, Callback = Opt("Box") }):AddColorPicker("ESPBoxColor", { Default = Color3.new(1, 1, 1), Callback = Opt("BoxColor") })
        E:AddSegmented("ESPBoxStyle", { Text = "", Values = { "Corner", "Full" }, Default = 1, Callback = Opt("BoxStyle") })
        E:AddToggle("ESPBoxFill", { Text = "Box fill", Default = false, Callback = Opt("BoxFill") }):AddColorPicker("ESPFillColor", { Default = Lib.Theme.Accent, Callback = Opt("FillColor") })
        E:AddToggle("ESPName", { Text = "Name", Default = true, Callback = Opt("Name") }):AddColorPicker("ESPNameColor", { Default = Color3.new(1, 1, 1), Callback = Opt("NameColor") })
        E:AddToggle("ESPHealth", { Text = "Health bar", Default = true, Callback = Opt("Health") })
        E:AddToggle("ESPDist", { Text = "Distance", Default = true, Callback = Opt("Distance") })
        E:AddToggle("ESPTool", { Text = "Held tool", Default = true, Callback = Opt("Tool") })
        E:AddToggle("ESPSkeleton", { Text = "Skeleton", Default = true, Callback = Opt("Skeleton") }):AddColorPicker("ESPSkelColor", { Default = Color3.fromRGB(215, 215, 225), Callback = Opt("SkeletonColor") })
        E:AddToggle("ESPFlags", { Text = "Flags", Default = true, Callback = Opt("Flags") })
        E:AddToggle("ESPChams", { Text = "Chams", Default = false, Callback = Opt("Chams") }):AddColorPicker("ESPChamsColor", { Default = Color3.fromRGB(203, 188, 255), Callback = Opt("ChamsColor") })
        E:AddToggle("ESPTracer", { Text = "Tracer", Default = false, Callback = Opt("Tracer") }):AddColorPicker("ESPTracerColor", { Default = Lib.Theme.Accent, Callback = Opt("TracerColor") })
        E:AddToggle("ESPHeadDot", { Text = "Head dot", Default = false, Callback = Opt("HeadDot") }):AddColorPicker("ESPHeadDotColor", { Default = Color3.new(1, 1, 1), Callback = Opt("HeadDotColor") })
        local P = esp:AddRightGroupbox("Preview", { Icon = "scan-face" })
        P:AddInput("__PreviewTarget", { Text = "Target path", Placeholder = "LocalPlayer · workspace.Boss · Players/friend", IgnoreConfig = true,
                Tooltip = "What the 3D preview renders: you, a player, or any object path (dots or slashes)." })
        P:AddButtonRow({
                { Text = "Set target", Func = function()
                        local raw = Trim(Lib.Options.__PreviewTarget.Value or "")
                        if raw == "" then
                                Lib:SetPreviewTarget(nil)
                                Lib:Notify({ Title = "ESP preview", Text = "Previewing your character.", Type = "success" })
                                return
                        end
                        local ok, name = Lib:SetPreviewTarget(raw)
                        if ok then Lib:Notify({ Title = "ESP preview", Text = "Now previewing " .. tostring(name) .. ".", Type = "success" })
                        else Lib:Notify({ Title = "ESP preview", Text = "Couldn't find \"" .. raw .. "\".", Type = "error" }) end
                end },
                { Text = "Back to me", Func = function()
                        if Lib.Options.__PreviewTarget then Lib.Options.__PreviewTarget:SetValue("", true) end
                        Lib:SetPreviewTarget(nil)
                        Lib:Notify({ Title = "ESP preview", Text = "Previewing your character.", Type = "success" })
                end },
        })
        P:AddToggle("PreviewRotate", { Text = "Auto rotate", Default = true, Callback = Opt("Rotate") })
        P:AddSlider("PreviewSpeed", { Text = "Rotate speed", Min = 0.2, Max = 4, Default = 1, Rounding = 1, Callback = Opt("RotateSpeed") })
        P:AddButton({ Text = "Refresh target", Icon = "refresh-cw", Func = function() if Lib.Preview then Lib.Preview:Rebuild() end end })
        Lib:CreateESPPreview()

        local cfgTab = tab:AddSubTab("Configs")
        local share = cfgTab:AddRightGroupbox("Share", { Icon = "clipboard" })
        share:AddInput("__ImportText", { Text = "Paste a config here", Placeholder = "{...}", IgnoreConfig = true, MaxLength = 100000 })
        share:AddButton({ Text = "Import from text", Func = function()
                local ok, data = pcall(HttpService.JSONDecode, HttpService, Lib.Options.__ImportText.Value)
                if ok and type(data) == "table" then Lib:ApplyConfig(data) Lib:Notify({ Title = "Config", Text = "Imported.", Type = "success" })
                else Lib:Notify({ Title = "Config", Text = "That isn't a valid config.", Type = "error" }) end
        end })
        share:AddButton({ Text = "Copy current config", Func = function() Copy(HttpService:JSONEncode(Lib:SerializeConfig()), "Config copied to clipboard") end })
        local cfg = cfgTab:AddLeftGroupbox("Configuration", { Icon = "save" })
        if not Lib.HasFS then
                cfg:AddCallout("Your executor doesn't expose file functions, so saving configs is disabled. Copy/paste still works.", "warn")
                task.defer(function()
                        for _, n in ipairs({ "ESPPreview", "Chat" }) do
                                local p, t = Lib.Panels[n], Lib.Toggles["Show" .. n]
                                if p and t then t:SetValue(p.Enabled, true) end
                        end
                end)
                return tab
        end
        cfg:AddInput("__ConfigName", { Text = "Config name", Placeholder = "my config", IgnoreConfig = true })
        cfg:AddDropdown("__ConfigList", { Text = "Saved configs", Values = Lib:ListConfigs(), AllowNull = true, Placeholder = "Pick a config", IgnoreConfig = true })
        local function Picked()
                local n = Lib.Options.__ConfigList.Value
                if not n then Lib:Notify({ Text = "Pick a config from the list first.", Type = "warn" }) end
                return n
        end
        local function Refresh() Lib.Options.__ConfigList:SetValues(Lib:ListConfigs()) end
        cfg:AddButton({ Text = "Create config", Icon = "plus", Func = function()
                local n = Sanitize(Lib.Options.__ConfigName.Value)
                local ok, err = Lib:SaveConfig(n)
                if ok then Lib:Notify({ Title = "Config", Text = "Saved " .. n, Type = "success" }) Refresh() Lib.Options.__ConfigList:SetValue(n, true)
                else Lib:Notify({ Title = "Config", Text = err or "Could not save.", Type = "error" }) end
        end })
        local act = cfgTab:AddRightGroupbox("Actions", { Icon = "folder-open" })
        act:AddButton({ Text = "Load selected", Func = function()
                local n = Picked() if not n then return end
                local ok, err = Lib:LoadConfig(n)
                Lib:Notify({ Title = "Config", Text = ok and ("Loaded " .. n) or err, Type = ok and "success" or "error" })
        end })
        act:AddButton({ Text = "Overwrite selected", DoubleClick = true, Func = function()
                local n = Picked() if not n then return end
                local ok, err = Lib:SaveConfig(n)
                Lib:Notify({ Title = "Config", Text = ok and ("Overwrote " .. n) or err, Type = ok and "success" or "error" })
        end })
        act:AddButton({ Text = "Delete selected", DoubleClick = true, Func = function()
                local n = Picked() if not n then return end
                Lib:DeleteConfig(n) Refresh() Lib.Options.__ConfigList:SetValue(nil, true)
        end })
        act:AddButton({ Text = "Refresh list", Func = Refresh })
        act:AddDivider()
        local autoLabel = act:AddLabel("Autoload: " .. (Lib:GetAutoload() or "none"))
        act:AddButton({ Text = "Set selected as autoload", Func = function()
                local n = Picked() if not n then return end
                Lib:SetAutoload(n) autoLabel:SetText("Autoload: " .. n)
                Lib:Notify({ Title = "Config", Text = "Autoload set to " .. n, Type = "success" })
        end })
        act:AddButton({ Text = "Clear autoload", Func = function()
                Lib:SetAutoload("") autoLabel:SetText("Autoload: none")
                Lib:Notify({ Title = "Config", Text = "Autoload cleared.", Type = "success" })
        end })
        task.defer(function()
                for _, n in ipairs({ "ESPPreview", "Chat" }) do
                        local p, t = Lib.Panels[n], Lib.Toggles["Show" .. n]
                        if p and t then t:SetValue(p.Enabled, true) end
                end
        end)
        return tab
end

local function ExecutorName()
        local ok, n, v = pcall(function() if identifyexecutor then return identifyexecutor() end end)
        if ok and n then return tostring(n) .. (v and (" " .. tostring(v)) or "") end
        return "Unknown"
end

local function PlatformName()
        if Lib.Touch then return "Mobile" end
        if UIS.GamepadEnabled and not UIS.KeyboardEnabled then return "Console" end
        return "PC"
end


local function HopServer(small)
        Lib:Notify({ Title = "Server", Text = "Looking for a server...", Type = "info", Duration = 2.5 })
        task.spawn(function()
                local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&limit=100", game.PlaceId, small and "Asc" or "Desc")
                local body = Fetch(url)
                local ok, data = pcall(function() return HttpService:JSONDecode(body or "") end)
                if not ok or type(data) ~= "table" or type(data.data) ~= "table" then
                        Lib:Notify({ Title = "Server", Text = "Couldn't read the server list.", Type = "error" })
                        return
                end
                local pool = {}
                for _, s in ipairs(data.data) do
                        if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers - 1 and (not small or s.playing > 0) then table.insert(pool, s) end
                end
                if #pool == 0 then
                        Lib:Notify({ Title = "Server", Text = "No other servers found.", Type = "warn" })
                        return
                end
                local pick = pool[math.random(1, math.min(#pool, 10))]
                Lib:JoinServer(game.PlaceId, pick.id, "a server with " .. pick.playing .. " players")
        end)
end

function Lib:_BuildProfile(window)
        local tab = window:AddTab("Profile", "user", true)
        local acc = tab:AddSubTab("Account")
        local me = acc:AddLeftGroupbox("Account", { Icon = "user" })
        me:AddAvatar3D(160)
        me:AddStat(nil, { Text = "Display name", Default = LocalPlayer.DisplayName })
        me:AddStat(nil, { Text = "Username", Default = "@" .. LocalPlayer.Name })
        me:AddStat(nil, { Text = "User ID", Default = tostring(LocalPlayer.UserId) })
        me:AddStat(nil, { Text = "Account age", Default = LocalPlayer.AccountAge .. " days" })
        me:AddStat(nil, { Text = "Membership", Default = LocalPlayer.MembershipType.Name })
        local teamStat = me:AddStat(nil, { Text = "Team", Default = LocalPlayer.Team and LocalPlayer.Team.Name or "None" })
        me:AddButtonRow({
                { Text = "Copy username", Func = function() Copy(LocalPlayer.Name, "Username") end },
                { Text = "Copy user ID", Func = function() Copy(tostring(LocalPlayer.UserId), "User ID") end },
        })
        local ses = acc:AddRightGroupbox("Session", { Icon = "activity" })
        ses:AddStat(nil, { Text = "Executor", Default = ExecutorName() })
        ses:AddStat(nil, { Text = "Platform", Default = PlatformName() })
        local sTime = ses:AddStat(nil, { Text = "Session", Default = "0m 00s" })
        local sFps = ses:AddStat(nil, { Text = "FPS", Default = "-" })
        local sPing = ses:AddStat(nil, { Text = "Ping", Default = "-" })
        ses:AddDivider()
        ses:AddToggle("BuiltInAntiAFK", { Text = "Anti AFK", Default = false, Tooltip = "Stops Roblox from kicking you for idling." })
        do
                local ok, VU = pcall(function() return Svc("VirtualUser") end)
                if ok and VU then
                        Lib:Connect(LocalPlayer.Idled, function()
                                if Lib.Flags.BuiltInAntiAFK then pcall(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end) end
                        end)
                end
        end
        if type(setfpscap) == "function" then
                ses:AddSlider("FpsCap", { Text = "FPS cap (0 = unlimited)", Min = 0, Max = 240, Default = 0, Callback = function(v) pcall(setfpscap, v) end })
        end
        local srv = tab:AddSubTab("Server")
        local game_ = srv:AddLeftGroupbox("Game", { Icon = "gamepad-2" })
        local gName = game_:AddStat(nil, { Text = "Game", Default = "Loading..." })
        task.spawn(function()
                local ok, r = pcall(function() return Market:GetProductInfo(game.PlaceId).Name end)
                gName:SetValue(ok and Short(r, 26) or "Unknown")
        end)
        game_:AddStat(nil, { Text = "Place ID", Default = tostring(game.PlaceId) })
        game_:AddStat(nil, { Text = "Job ID", Default = Short(game.JobId ~= "" and game.JobId or "Studio", 14) })
        local gPlayers = game_:AddStat(nil, { Text = "Players", Default = "-" })
        local gUp = game_:AddStat(nil, { Text = "Server uptime", Default = "-" })
        game_:AddButtonRow({
                { Text = "Copy PlaceId", Func = function() Copy(tostring(game.PlaceId), "PlaceId") end },
                { Text = "Copy JobId", Func = function() Copy(tostring(game.JobId), "JobId") end },
        })
        game_:AddButton({ Text = "Copy join script", Icon = "terminal", Func = function()
                Copy(string.format("game:GetService('TeleportService'):TeleportToPlaceInstance(%d, '%s', game.Players.LocalPlayer)", game.PlaceId, game.JobId), "Join script")
        end })
        local act = srv:AddRightGroupbox("Server actions", { Icon = "server" })
        act:AddButton({ Text = "Rejoin this server", Icon = "refresh-cw", Func = function()
                Lib:Dialog({ Title = "Rejoin", Text = "Rejoin this server?", Buttons = { { Text = "Cancel" }, { Text = "Rejoin", Primary = true, Callback = function()
                        pcall(function()
                                if #Players:GetPlayers() <= 1 then Teleport:Teleport(game.PlaceId, LocalPlayer)
                                else Teleport:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end
                        end)
                end } } })
        end })
        act:AddButton({ Text = "Join a new server", Icon = "shuffle", Func = function() pcall(function() Teleport:Teleport(game.PlaceId, LocalPlayer) end) end })
        act:AddButton({ Text = "Join smallest server", Icon = "users", Func = function() HopServer(true) end })
        act:AddButton({ Text = "Join busiest server", Icon = "users-round", Func = function() HopServer(false) end })
        act:AddDivider()
        act:AddCallout("Server hopping reads the public server list, so it needs an executor with HTTP access.", "info")
        local clock = 0
        Lib:Connect(RunService.Heartbeat, function(dt)
                clock = clock + dt
                if clock < 0.5 then return end
                clock = 0
                if window.ActiveTab ~= tab then return end
                sTime:SetValue(Clock(os.clock() - Lib.StartTime))
                sFps:SetValue(tostring(Lib.FPS), Lib.FPS >= 50 and Lib.Theme.Good or (Lib.FPS >= 30 and Lib.Theme.Warn or Lib.Theme.Bad))
                local p = Lib:GetPing()
                sPing:SetValue(p .. " ms", p <= 80 and Lib.Theme.Good or (p <= 160 and Lib.Theme.Warn or Lib.Theme.Bad))
                teamStat:SetValue(LocalPlayer.Team and LocalPlayer.Team.Name or "None")
                gPlayers:SetValue(#Players:GetPlayers() .. " / " .. Players.MaxPlayers)
                gUp:SetValue(Clock(workspace.DistributedGameTime))
        end)
        return tab
end

function Lib:Unload()
        if self.Unloaded then return end
        self.Unloaded = true
        self:ClosePopup()
        if self.OnUnload then Safe(self.OnUnload) end
        if self.ChatObj then self.ChatObj.Alive = false end
        if self.Preview then self.Preview.Alive = false end
        for _, c in ipairs(self.Connections) do pcall(function() c:Disconnect() end) end
        self.Connections = {}
        self.Rainbows = {}
        pcall(function() self.Gui:Destroy() end)
        pcall(function() self.Overlay:Destroy() end)
        pcall(function() if self.ProbeGui then self.ProbeGui:Destroy() end end)
        if getgenv and getgenv().__AetherUI == self then getgenv().__AetherUI = nil end
end

-- Aether patch: no duplicate chats, channels API, bio
function Chat:AddChannel(name, id)
        id = tonumber(id) or id
        if id == nil then return end
        local room = "game-" .. tostring(id)
        if self:_RoomIndex(room) then return end
        local ch = { name = tostring(name or id), room = room, id = id, unread = 0 }
        local pos = #self.Channels + 1
        for i, c in ipairs(self.Channels) do
                if c.kind then pos = i break end
        end
        table.insert(self.Channels, pos, ch)
        if self.ChIndex >= pos then self.ChIndex = self.ChIndex + 1 end
        if type(id) == "number" and tostring(ch.name) == tostring(id) then
                task.spawn(function()
                        local ok, r = pcall(function() return Market:GetProductInfo(id).Name end)
                        if ok and r then ch.name = r self:_RefreshChannel() end
                end)
        end
        self:_RefreshChannel()
end

Lib._OrigCreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
        cfg = cfg or {}
        local chat = self.ChatObj
        if chat and chat.Frame and chat.Frame.Parent then
                for _, ch in ipairs(BuildChannels(cfg.Channels or (getgenv and getgenv().AetherChannels), "global")) do
                        if ch.id then chat:AddChannel(ch.name, ch.id) end
                end
                return chat
        end
        return Lib._OrigCreateChat(self, cfg)
end

function Lib:Channels(cfg) return self:CreateChat(cfg) end

function Lib:LoadBio()
        if self._bioLoaded then return self.Bio or "" end
        self._bioLoaded = true
        self.Bio = self.Bio or ""
        if FsOk() then
                pcall(function()
                        local p = self.ConfigFolder .. "/bio.txt"
                        if isfile(p) then self.Bio = Trim(readfile(p)):sub(1, 120) end
                end)
        end
        return self.Bio
end

function Lib:SetBio(t)
        t = Trim(tostring(t or "")):sub(1, 120)
        self.Bio = t
        self._bioTick = (self._bioTick or 0) + 1
        local tick = self._bioTick
        task.delay(1, function()
                if tick ~= self._bioTick or not FsOk() then return end
                pcall(function()
                        if not isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end
                        writefile(self.ConfigFolder .. "/bio.txt", t)
                end)
        end)
end

Lib._OrigDo = Chat._Do
function Chat:_Do(path, query, method, body, room)
        query = query or {}
        query.bio = Lib:LoadBio()
        return Lib._OrigDo(self, path, query, method, body, room)
end

-- ===================== Aether patch 4.1 =====================
do
local P = {}

-- ---------- name style data ----------
P.FontValues, P.FontSet = { "Default" }, {}
for _, n in ipairs({ "Gotham", "GothamBold", "GothamBlack", "Arcade", "Fantasy", "SciFi", "Code", "Cartoon", "Bangers",
        "PermanentMarker", "Kalam", "Oswald", "SpecialElite", "Michroma", "Creepster", "FredokaOne" }) do
        local ok, f = pcall(function() return Enum.Font[n] end)
        if ok and f then table.insert(P.FontValues, n) P.FontSet[n] = true end
end

Lib.NameStyle = Lib.NameStyle or { On = false, C1 = Color3.fromRGB(139, 92, 246), C2 = Color3.fromRGB(236, 72, 153), Grad = false, Font = "Default" }

function Lib:SaveNameStyle()
        if not FsOk() then return end
        local s = self.NameStyle
        pcall(function()
                if not isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end
                writefile(self.ConfigFolder .. "/namestyle.json", HttpService:JSONEncode({ on = s.On, c1 = ToHex(s.C1), c2 = ToHex(s.C2), grad = s.Grad, font = s.Font }))
        end)
end

function Lib:LoadNameStyle()
        if self._nsLoaded then return end
        self._nsLoaded = true
        if not FsOk() then return end
        pcall(function()
                local p = self.ConfigFolder .. "/namestyle.json"
                if not isfile(p) then return end
                local d = HttpService:JSONDecode(readfile(p))
                if type(d) ~= "table" then return end
                local s = self.NameStyle
                s.On = d.on == true
                s.C1 = FromHex(d.c1 or "") or s.C1
                s.C2 = FromHex(d.c2 or "") or s.C2
                s.Grad = d.grad == true
                if d.font == "Default" or P.FontSet[d.font] then s.Font = d.font end
        end)
end

function Lib:EncodeStyle(force)
        local s = self.NameStyle
        if not (s.On or force) then return nil end
        local out = "c=" .. ToHex(s.C1)
        if s.Grad then out = out .. ";g=" .. ToHex(s.C2) end
        if s.Font ~= "Default" and P.FontSet[s.Font] then out = out .. ";f=" .. s.Font end
        return out
end

-- never trust a style string from the server: only hex colors and whitelisted fonts get through
function Lib:ParseStyle(s)
        if type(s) ~= "string" or #s > 60 then return nil end
        local st = {}
        local c, g, f = s:match("c=(%x%x%x%x%x%x)"), s:match("g=(%x%x%x%x%x%x)"), s:match("f=(%a+)")
        if c then st.c1 = FromHex(c) end
        if g then st.c2 = FromHex(g) end
        if f and P.FontSet[f] then st.font = f end
        if not (st.c1 or st.font) then return nil end
        return st
end

function Lib:RenderName(name, st)
        local s = RichEsc(name)
        local out
        local len = utf8.len(s)
        if st.c1 and st.c2 and len and len <= 24 then
                local chars = {}
                for ch in s:gmatch(utf8.charpattern) do chars[#chars + 1] = ch end
                local n, parts = #chars, {}
                for i, ch in ipairs(chars) do
                        local t = n > 1 and (i - 1) / (n - 1) or 0
                        parts[i] = "<font color='#" .. ToHex(st.c1:Lerp(st.c2, t)) .. "'>" .. ch .. "</font>"
                end
                out = table.concat(parts)
        else
                out = "<font color='#" .. ToHex(st.c1 or Lib.Theme.Text) .. "'>" .. s .. "</font>"
        end
        if st.font then return "<font face='" .. st.font .. "'>" .. out .. "</font>" end
        return "<b>" .. out .. "</b>"
end

-- ---------- sends your style with every request (the worker stores it on /send) ----------
P.Do = Chat._Do
function Chat:_Do(path, query, method, body, room)
        query = query or {}
        Lib:LoadNameStyle()
        local s = Lib:EncodeStyle()
        if s then query.style = s end
        return P.Do(self, path, query, method, body, room)
end

-- ---------- bubble refit (fixes "(edited)" splitting into edi / ted) ----------
function Chat:_RefitBubble(item, meta)
        local col = item:FindFirstChild("Col")
        local bubble = col and col:FindFirstChild("Bubble")
        if not bubble then return end
        local maxCol = math.min(560, math.floor((self.Frame.Size.X.Offset - 44) * 0.8))
        local inner = maxCol - 16
        local shown = meta.txt .. (meta.edited and "   (edited)" or "")
        local needW = math.min(math.ceil(Measure(shown, 13, Lib.Font, inner).X) + 8, inner)
        if bubble:FindFirstChild("Image") or bubble:FindFirstChild("Preview") then needW = inner end
        if bubble:FindFirstChild("Quote") then needW = math.max(needW, bubble.Size.X.Offset - 16) end
        local head = col:FindFirstChildOfClass("TextLabel")
        local headW = 0
        if head then
                local m = meta.msg or {}
                local mine = tostring(m.uid) == tostring(LocalPlayer.UserId)
                local nm = tostring(m.display or m.name or "Unknown")
                if nm == "" then nm = tostring(m.name or "Unknown") end
                local tm = ""
                if type(m.ts) == "number" then pcall(function() tm = os.date("%H:%M", math.floor(m.ts / 1000)) end) end
                local plain = (mine and "" or (nm .. "  ")) .. tm
                headW = math.ceil(Measure(plain, 12, Lib.FontBold, 1000).X) + 6
                headW = math.max(headW, tonumber(col:GetAttribute("headW")) or 0)
        end
        local colW = math.min(maxCol, math.max(needW + 16, headW))
        col.Size = UDim2.new(0, colW, 0, 0)
        bubble.Size = UDim2.new(0, math.min(needW + 16, colW), 0, 0)
end

function Chat:_ApplyEdit(ev)
        local item = self.ByLid[ev.target]
        local meta = item and self.Meta[item]
        if not meta then return end
        meta.txt, meta.edited = tostring(ev.text or ""), true
        if meta.msg then meta.msg.text = meta.txt end
        item:SetAttribute("stext", meta.txt:lower())
        meta.body.Visible = meta.txt ~= ""
        meta.body.Text = self:_BodyText(meta)
        meta.hl = false
        self:_RefitBubble(item, meta)
        if self.SearchOpen and self.SearchText ~= "" then self:ApplySearch(true) end
end

-- ---------- styled names in chat ----------
function Chat:_StyleHead(item, msg, st)
        local col = item:FindFirstChild("Col")
        local head = col and col:FindFirstChildOfClass("TextLabel")
        if not head then return end
        local nm = tostring(msg.display or msg.name or "Unknown")
        if nm == "" then nm = tostring(msg.name or "Unknown") end
        local tm = ""
        if type(msg.ts) == "number" then pcall(function() tm = os.date("%H:%M", math.floor(msg.ts / 1000)) end) end
        head.Text = Lib:RenderName(nm, st) .. " <font color='#" .. Hex("Dim") .. "'>" .. tm .. "</font>"
        local w = math.ceil(Measure(nm .. "  " .. tm, 12, Lib.FontBold, 1000).X * (st.font and 1.3 or 1)) + 8
        col:SetAttribute("headW", w)
        local maxCol = math.min(560, math.floor((self.Frame.Size.X.Offset - 44) * 0.8))
        if w > col.Size.X.Offset then col.Size = UDim2.new(0, math.min(maxCol, w), 0, 0) end
end

P.AddMessage = Chat.AddMessage
function Chat:AddMessage(msg)
        local last = self.Items[#self.Items]
        local res = P.AddMessage(self, msg)
        local item = self.Items[#self.Items]
        local meta = item and item ~= last and self.Meta[item]
        if meta and meta.msg == msg then
                pcall(function()
                        local mine = tostring(msg.uid) == tostring(LocalPlayer.UserId)
                        local st = Lib:ParseStyle(msg.style)
                        if not st and mine then st = Lib:ParseStyle(Lib:EncodeStyle()) end
                        if st then self:_StyleHead(item, msg, st) end
                        if meta.edited then
                                task.defer(function() if item.Parent then pcall(self._RefitBubble, self, item, meta) end end)
                        end
                end)
        end
        return res
end

-- ---------- typing indicator ----------
function Chat:_Relayout()
        local sOff = self.SearchOpen and 28 or 0
        local pinOn = self.Pinned[self.PinIdx] ~= nil
        self.Top = self.BaseTop + sOff + (pinOn and 32 or 0)
        local reply = self.ReplyTo and 28 or 0
        local typ = self.TypeOn and 18 or 0
        local pos, size = UDim2.fromOffset(8, self.Top), UDim2.new(1, -16, 1, -(self.Top + self.ListBottom + reply + typ))
        self.PinBar.Position = UDim2.fromOffset(8, self.BaseTop - 4 + sOff)
        self.List.Position, self.List.Size = pos, size
        self.NotifPanel.Position, self.NotifPanel.Size = pos, size
        self.Jump.Position = UDim2.new(0.5, 0, 1, -(self.ListBottom + reply + typ + 6))
        if self.TypeBar then self.TypeBar.Position = UDim2.new(0, 8, 1, -(self.ListBottom - 2 + reply)) end
end

function Chat:_SetTypers(list)
        if not self.TypeBar then return end
        local names = {}
        for _, u in ipairs(type(list) == "table" and list or {}) do
                if type(u) == "table" and tostring(u.uid) ~= tostring(LocalPlayer.UserId) and not Lib:IsBlocked(u.uid) then
                        local n = tostring((u.display ~= nil and u.display ~= "") and u.display or u.name or "?")
                        table.insert(names, "<b><font color='#" .. Hex("Text") .. "'>" .. RichEsc(n:sub(1, 20)) .. "</font></b>")
                end
        end
        local n, text = #names, ""
        if n == 1 then text = names[1] .. " is typing..."
        elseif n == 2 then text = names[1] .. " and " .. names[2] .. " are typing..."
        elseif n == 3 then text = names[1] .. ", " .. names[2] .. ", and " .. names[3] .. " are typing..."
        elseif n > 3 then text = names[1] .. ", " .. names[2] .. ", and " .. names[3] .. " +" .. (n - 3) .. " more are typing..." end
        local was = self.TypeOn
        self.TypeOn = n > 0
        self.TypeBar.Text = text
        self.TypeBar.Visible = self.TypeOn
        if was ~= self.TypeOn then self:_Relayout() end
end

function Chat:_InitExtras()
        if self._extras then return end
        self._extras = true
        local ih = H(32)
        self.TypeOn, self.TypingUntil, self._typeFails = false, 0, 0
        self.TypeBar = New("TextLabel", { Name = "Typing", Text = "", RichText = true, TextSize = 11, Size = UDim2.new(1, -16, 0, 16), AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.new(0, 8, 1, -(ih + 14)), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Visible = false, ZIndex = 6,
                Theme = { TextColor3 = "SubText" }, Parent = self.Frame })
        self.Input:GetPropertyChangedSignal("Text"):Connect(function()
                local t = self.Input.Text
                if t == "" or t:sub(1, 1) == "/" then self.TypingUntil = 0 else self.TypingUntil = os.clock() + 4 end
        end)
        task.spawn(function()
                while not Lib.Unloaded and self.Frame and self.Frame.Parent do
                        local typing = os.clock() < self.TypingUntil
                        if self.Request and self.Config.Url and not self.Blocked and (self.PanelObj._shown or typing) then
                                local room = self.Room
                                local d = Decode(self:_Do("/typing", { t = typing and "1" or "0" }))
                                if room ~= self.Room then
                                        self:_SetTypers(nil)
                                elseif d and d.ok then
                                        self._typeFails = 0
                                        self:_SetTypers(d.users)
                                else
                                        self._typeFails = self._typeFails + 1
                                        if self._typeFails == 1 then self:_SetTypers(nil) end
                                end
                        else
                                self:_SetTypers(nil)
                        end
                        task.wait(self._typeFails >= 3 and 10 or 1.5)
                end
        end)
end

P.SetChannel = Chat.SetChannel
function Chat:SetChannel(i)
        self:_SetTypers(nil)
        return P.SetChannel(self, i)
end

P.CreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
        local chat = P.CreateChat(self, cfg)
        if chat and not chat._extras then pcall(function() chat:_InitExtras() end) end
        return chat
end

-- ---------- join game fix: two teleport methods + the real error ----------
function Lib:JoinServer(place, job, label)
        place, label = tonumber(place), label or "that server"
        if not place or not job or job == "" then
                Lib:Notify({ Title = "Join", Text = "There's no server to join.", Type = "warn" })
                return
        end
        if Lib._join2 and os.clock() - Lib._join2.t0 < 20 then
                Lib:Notify({ Title = "Join", Text = "Already joining, give it a moment.", Type = "info", Duration = 2 })
                return
        end
        local j = { place = place, job = tostring(job), label = label, step = 1, errs = {}, t0 = os.clock(), tok = 0 }
        Lib._join2 = j
        Lib:Notify({ Title = "Join", Text = "Teleporting to " .. label .. "...", Type = "info", Duration = 3 })
        Lib:_JoinStep(j)
end

function Lib:_JoinStep(j)
        if Lib._join2 ~= j then return end
        j.tok = j.tok + 1
        local t = j.tok
        local ok, err
        if j.step == 1 then
                ok, err = pcall(function() Teleport:TeleportToPlaceInstance(j.place, j.job, LocalPlayer) end)
        else
                ok, err = pcall(function()
                        local opts = Instance.new("TeleportOptions")
                        opts.ServerInstanceId = j.job
                        Teleport:TeleportAsync(j.place, { LocalPlayer }, opts)
                end)
        end
        if not ok then Lib:_JoinFail(j, nil, tostring(err)) return end
        task.delay(20, function()
                if Lib.Unloaded or Lib._join2 ~= j or j.tok ~= t then return end
                Lib:_JoinFail(j, nil, "No response from Roblox for 20 seconds.")
        end)
end

function Lib:_JoinFail(j, result, detail)
        if Lib._join2 ~= j then return end
        j.tok = j.tok + 1
        local name = result and result.Name
        table.insert(j.errs, (j.step == 1 and "Method 1: " or "Method 2: ") .. (name or "error") .. ((detail and detail ~= "") and (" - " .. tostring(detail)) or ""))
        local hard = name == "Flooded" or name == "IsTeleporting"
        if j.step == 1 and not hard then
                j.step = 2
                Lib:Notify({ Title = "Join", Text = "Trying another way in...", Type = "info", Duration = 2.5 })
                task.delay(1, function() Lib:_JoinStep(j) end)
                return
        end
        Lib._join2 = nil
        Lib:JoinFailed(j.place, j.job, j.label, result, table.concat(j.errs, "\n"))
end

pcall(function()
        Lib:Connect(Teleport.TeleportInitFailed, function(_, result, msg)
                local j = Lib._join2
                if j then Lib:_JoinFail(j, result, msg) end
        end)
end)

-- ---------- Settings > Interface > "Chat name style" ----------
function Lib:_BuildNameStyleUI(tab)
        local sub = tab and tab.Subs and tab.Subs[1]
        if not sub then return end
        self:LoadNameStyle()
        local s = self.NameStyle
        local gb = sub:AddRightGroupbox("Chat name style", { Icon = "type", Collapsible = true })
        local preview
        local function Refresh()
                Lib:SaveNameStyle()
                if preview then
                        local st = Lib:ParseStyle(Lib:EncodeStyle(true))
                        preview.TextLabel.Text = (st and Lib:RenderName(LocalPlayer.DisplayName, st) or RichEsc(LocalPlayer.DisplayName))
                                .. " <font color='#" .. ToHex(Lib.Theme.Dim) .. "'>12:34</font>"
                end
        end
        gb:AddToggle("__NameOn", { Text = "Use custom name style", Default = s.On, IgnoreConfig = true, Callback = function(v) s.On = v Refresh() end })
        gb:AddLabel("Name color"):AddColorPicker("__NameC1", { Default = s.C1, Rainbow = false, IgnoreConfig = true, Callback = function(c) s.C1 = c Refresh() end })
        gb:AddToggle("__NameGrad", { Text = "Gradient (second color)", Default = s.Grad, IgnoreConfig = true, Callback = function(v) s.Grad = v Refresh() end })
                :AddColorPicker("__NameC2", { Default = s.C2, Rainbow = false, IgnoreConfig = true, Callback = function(c) s.C2 = c Refresh() end })
        gb:AddDropdown("__NameFont", { Text = "Font", Values = P.FontValues, Default = s.Font, IgnoreConfig = true, Callback = function(v) s.Font = v or "Default" Refresh() end })
        preview = gb:AddLabel("")
        preview.TextLabel.RichText = true
        preview.TextLabel.TextSize = 15
        Refresh()
end

P.BuildSettingsTab = Lib.BuildSettingsTab
function Lib:BuildSettingsTab(window)
        local tab = P.BuildSettingsTab(self, window)
        pcall(function() Lib:_BuildNameStyleUI(tab) end)
        return tab
end

end
-- ===================== end patch =====================

-- ===================== Aether patch: built-ins =====================
do
local P = {}

-- ESPPreview = false must win even if something calls CreateESPPreview early
P.CreateESPPreview = Lib.CreateESPPreview
function Lib:CreateESPPreview(cfg)
        if self._noPreview then return nil end
        return P.CreateESPPreview(self, cfg)
end

-- make the manual calls safe to repeat, so old scripts don't build things twice
P.BuildSettingsTab = Lib.BuildSettingsTab
function Lib:BuildSettingsTab(window)
        window = window or self.MainWindow
        if window._settingsTab then return window._settingsTab end
        local tab = P.BuildSettingsTab(self, window)
        window._settingsTab = tab
        return tab
end

P.CreateWatermark = Lib.CreateWatermark
function Lib:CreateWatermark(cfg)
        local w = self.Watermark
        if w and w.Frame and w.Frame.Parent then return w end
        return P.CreateWatermark(self, cfg)
end

P.CreateKeybindList = Lib.CreateKeybindList
function Lib:CreateKeybindList(cfg)
        local k = self.KeybindList
        if k and k.Frame and k.Frame.Parent then return k end
        return P.CreateKeybindList(self, cfg)
end

-- an early LoadAutoload (before Settings exists) would do nothing useful, so it waits for the built-ins
P.LoadAutoload = Lib.LoadAutoload
function Lib:LoadAutoload()
        local w = self.MainWindow
        if w and w._pendingBuiltins then return false end
        return P.LoadAutoload(self)
end

function Window:BuildBuiltins()
        if not self._pendingBuiltins then return end
        self._pendingBuiltins = false
        local c = self.Cfg or {}
        local function Try(name, fn)
                local ok, err = pcall(fn)
                if not ok then warn("[Aether] " .. name .. ": " .. tostring(err)) end
        end
        if c.Settings ~= false then
                Try("Settings", function() Lib:BuildSettingsTab(self) end)
        elseif c.ESPPreview ~= false then
                Try("ESP preview", function() Lib:CreateESPPreview() end)
        end
        if c.Chat ~= false then
                Try("Chat", function() Lib:CreateChat(type(c.Chat) == "table" and c.Chat or {}) end)
        end
        if c.Watermark ~= false then Try("Watermark", function() Lib:CreateWatermark() end) end
        if c.KeybindList ~= false then Try("Keybind list", function() Lib:CreateKeybindList() end) end
        if c.Autoload ~= false then Try("Autoload", function() Lib:LoadAutoload() end) end
end

P.CreateWindow = Lib.CreateWindow
function Lib:CreateWindow(cfg)
        cfg = cfg or {}
        if cfg.ESPPreview == false then self._noPreview = true end
        local win = P.CreateWindow(self, cfg)
        win._pendingBuiltins = true
        -- run after the rest of the script has added its own tabs and options
        task.defer(function()
                task.wait()
                if not Lib.Unloaded then win:BuildBuiltins() end
        end)
        return win
end

end
-- ===================== end patch =====================

-- ===================== Aether patch: fullscreen v2 + extras =====================
do
local P = {}

if getgenv then pcall(function() getgenv().AetherStaffKey = nil end) end

function P.SetIcon(img, name, fallbackText)
        local r = ResolveIcon(name)
        if r then
                img.Image = ToAsset(r.Image)
                if r.Pos then img.ImageRectOffset = r.Pos end
                if r.Size then img.ImageRectSize = r.Size end
        else
                local t = img:FindFirstChildOfClass("TextLabel")
                if t then t.Text = fallbackText or "•" end
        end
end

-- ==================== shared fullscreen scale ====================
-- Fullscreen raises the UI scale so a big screen doesn't just stretch everything; it is put back on exit.
function Lib:_SetFsScale(key, on)
        self._fsUsers = self._fsUsers or {}
        local had = next(self._fsUsers) ~= nil
        if on then
                if not had then self._fsBase = self.Scale end
                self._fsUsers[key] = true
                local vp = GetViewport()
                local want = Clamp(math.min(vp.X / 1000, vp.Y / 560), self._fsBase or self.Scale, 1.5)
                if math.abs(want - self.Scale) > 0.001 then self:_ApplyScale(want) end
        else
                self._fsUsers[key] = nil
                if next(self._fsUsers) == nil and self._fsBase then
                        local b = self._fsBase
                        self._fsBase = nil
                        if math.abs(b - self.Scale) > 0.001 then self:_ApplyScale(b) end
                end
        end
end

-- ==================== WINDOW FULLSCREEN ====================
function Window:_Corners(r)
        for _, f in ipairs({ self.Main, self.Side }) do
                local c = f and f:FindFirstChildOfClass("UICorner")
                if c then c.CornerRadius = UDim.new(0, r) end
        end
        local st = self.Main:FindFirstChildOfClass("UIStroke")
        if st then st.Enabled = r > 0 end
end

function Window:_FitFull()
        if self._fitting then return end
        self._fitting = true
        Lib:_SetFsScale("Window", true)
        local vp, s = GetViewport(), Lib.Scale
        self.W, self.H = vp.X / s, vp.Y / s
        self.Main.Size = UDim2.fromOffset(self.W, self.H)
        self.Main.Position = UDim2.fromOffset(0, 0)
        self._fitting = false
end

function Window:SetFullscreen(state)
        state = state and true or false
        if (self.Fullscreen or false) == state then return end
        Lib:ClosePopup()
        if state then
                if self.Minimized then self:SetMinimized(false, true) end
                self._fs = { bw = self.BaseW, bh = self.BaseH, pos = self.Main.Position, sized = self.UserSized, dragged = self.Dragged, locked = self.Locked }
                self.Fullscreen = true
                self.Locked = true
                self.Grip.Visible = false
                self:_Corners(0)
                self:_FitFull()
        else
                local f = self._fs or {}
                self.Fullscreen = false
                self.Locked = f.locked or false
                self.BaseW, self.BaseH = f.bw or self.BaseW, f.bh or self.BaseH
                self.UserSized, self.Dragged = f.sized, f.dragged
                self.Grip.Visible = true
                self:_Corners(8)
                Lib:_SetFsScale("Window", false)
                self:_Fit()
                if f.pos then self.Main.Position = f.pos end
                self:Clamp(true)
        end
        if self.FsBtn then
                self.FsBtn.Rest = state and "Accent" or "SubText"
                P.SetIcon(self.FsBtn.Icon, state and "minimize" or "maximize", state and "-" or "[]")
                Tint(self.FsBtn.Icon, Lib.Theme[self.FsBtn.Rest], 0.1)
        end
end

function Window:ToggleFullscreen() self:SetFullscreen(not self.Fullscreen) end

P.Fit = Window._Fit
function Window:_Fit()
        if self.Fullscreen then self:_FitFull() return end
        return P.Fit(self)
end

P.AutoFit = Window.AutoFit
function Window:AutoFit(resetPosition)
        if self.Fullscreen then self:_FitFull() return end
        return P.AutoFit(self, resetPosition)
end

P.Clamp = Window.Clamp
function Window:Clamp(strict)
        if self.Fullscreen then self.Main.Position = UDim2.fromOffset(0, 0) return end
        return P.Clamp(self, strict)
end

P.SetMinimized = Window.SetMinimized
function Window:SetMinimized(state, instant)
        if state and self.Fullscreen then self:SetFullscreen(false) end
        return P.SetMinimized(self, state, instant)
end

function Window:_AddFullscreenButton()
        if self.FsBtn then return end
        local header = self.TitleLabel.Parent
        local sz = H(26)
        local api = IconButton(header, "maximize", "[]", sz, function() return self.Fullscreen and "Exit fullscreen" or "Fullscreen" end, "Accent")
        api.Button.AnchorPoint = Vector2.new(1, 0.5)
        api.Button.Position = UDim2.new(1, -(12 + (sz + 6) * 2), 0, 23)
        api.Button.Activated:Connect(function() self:ToggleFullscreen() end)
        self.FsBtn = api
        local sf = self.SearchBox and self.SearchBox.Parent
        if sf then sf.Position = UDim2.new(1, -(12 + (sz + 6) * 3), 0, 23) end
end

P.ApplyScale = Lib._ApplyScale
function Lib:_ApplyScale(s)
        P.ApplyScale(self, s)
        local c = self.ChatObj
        if c and c.Full then c:_FitFull() end
end

-- ==================== CHAT FULLSCREEN ====================
function Chat:_FitFull()
        if self._fitting then return end
        self._fitting = true
        Lib:_SetFsScale("Chat", true)
        local vp, s = GetViewport(), Lib.Scale
        self.Frame.Size = UDim2.fromOffset(vp.X / s, vp.Y / s)
        self.Frame.Position = UDim2.fromOffset(0, 0)
        self._fitting = false
end

function Chat:_ReloadMessages()
        if not self.Alive or self.Blocked then return end
        self.Gen = self.Gen + 1
        self.LastId, self.Seen, self.Known, self.Loaded = -1, {}, {}, false
        self.Stick, self.JumpCount = true, 0
        self:_ClearAll()
        task.spawn(function() self:_PollOnce() end)
end

function Chat:SetFullscreen(state)
        state = state and true or false
        if (self.Full or false) == state then return end
        local panel, frame = self.PanelObj, self.Frame
        Lib:ClosePopup()
        if self.SearchOpen then self:ToggleSearch(false) end
        if self.NotifOpen then self:ToggleNotifs(false) end
        local corner, stroke = frame:FindFirstChildOfClass("UICorner"), frame:FindFirstChildOfClass("UIStroke")
        if state then
                self._fsPrev = { pos = frame.Position, size = frame.Size, moved = panel.Moved }
                self.Full = true
                panel.Moved = true
                if corner then corner.CornerRadius = UDim.new(0, 0) end
                if stroke then stroke.Enabled = false end
                self:_FitFull()
        else
                local p = self._fsPrev or {}
                self.Full = false
                if corner then corner.CornerRadius = UDim.new(0, 8) end
                if stroke then stroke.Enabled = true end
                Lib:_SetFsScale("Chat", false)
                if p.size then frame.Size = p.size end
                if p.pos then frame.Position = p.pos end
                panel.Moved = p.moved
                if not p.moved then Lib:_Place(panel) end
        end
        if self._fsBtn then
                self._fsBtn.Rest = state and "Accent" or "SubText"
                P.SetIcon(self._fsBtn.Icon, state and "minimize" or "maximize", state and "-" or "[]")
                Tint(self._fsBtn.Icon, Lib.Theme[self._fsBtn.Rest], 0.1)
        end
        task.defer(function() self:_ReloadMessages() end)
end

function Chat:_AddFullscreen()
        if self._fsBtn then return end
        local chat, panel, frame = self, self.PanelObj, self.Frame
        local sz = H(26)
        local api = IconButton(panel.Head, "maximize", "[]", sz, function() return chat.Full and "Exit fullscreen" or "Fullscreen" end, "Accent")
        api.Button.AnchorPoint = Vector2.new(1, 0.5)
        api.Button.Position = UDim2.new(1, -(14 + sz * 2), 0.5, 0)
        api.Button.Activated:Connect(function() chat:SetFullscreen(not chat.Full) end)
        self._fsBtn = api
        panel.TitleLabel.Size = UDim2.new(1, -(190 + sz + 4), 1, 0)
        self.Pill.Position = UDim2.new(1, -(sz * 3 + 20), 0.5, 0)
        frame:GetPropertyChangedSignal("Position"):Connect(function()
                if chat.Full and frame.Position ~= UDim2.fromOffset(0, 0) then frame.Position = UDim2.fromOffset(0, 0) end
        end)
        local origDock = panel.Dock
        function panel:Dock(animate)
                if chat.Full then chat:SetFullscreen(false) end
                return origDock(self, animate)
        end
        local oc = panel.OnChanged
        panel.OnChanged = function(on)
                if not on and chat.Full then chat:SetFullscreen(false) end
                if oc then oc(on) end
        end
        Lib:Connect(Lib.Gui:GetPropertyChangedSignal("AbsoluteSize"), function()
                if chat.Full then chat:_FitFull() end
        end)
end

P.CreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
        if getgenv then pcall(function() getgenv().AetherStaffKey = nil end) end
        local chat = P.CreateChat(self, cfg)
        if chat and not chat._fsBtn then pcall(function() chat:_AddFullscreen() end) end
        return chat
end

-- ==================== TOUCH CALIBRATION (color picker / finger offset) ====================
-- Invisible thin bands cover the screen. The band a finger lands on tells us its real Y,
-- so Pointer() can correct the offset exactly instead of guessing the top bar inset.
if UIS.TouchEnabled then
        local gui = MakeGui(994)
        Lib.TouchProbeGui = gui
        local BH, bands, samples, lastH = 6, {}, {}, 0
        local function Build()
                local h = gui.AbsoluteSize.Y
                if h <= 0 or h == lastH then return end
                lastH, samples = h, {}
                for _, b in ipairs(bands) do b:Destroy() end
                bands = {}
                for i = 0, math.ceil(h / BH) do
                        local f = Instance.new("Frame")
                        f.BackgroundTransparency, f.BorderSizePixel, f.Active = 1, 0, false
                        f.Size, f.Position = UDim2.new(1, 0, 0, BH), UDim2.fromOffset(0, i * BH)
                        f.Parent = gui
                        f.InputBegan:Connect(function(input)
                                if input.UserInputType ~= Enum.UserInputType.Touch then return end
                                table.insert(samples, (i * BH + BH / 2) - input.Position.Y)
                                if #samples > 9 then table.remove(samples, 1) end
                                local s = table.clone(samples)
                                table.sort(s)
                                Lib.TouchDY = s[math.ceil(#s / 2)]
                        end)
                        bands[#bands + 1] = f
                end
        end
        Build()
        Lib:Connect(gui:GetPropertyChangedSignal("AbsoluteSize"), function() task.defer(Build) end)
end

P.Unload = Lib.Unload
function Lib:Unload()
        pcall(function() if self.TouchProbeGui then self.TouchProbeGui:Destroy() end end)
        return P.Unload(self)
end

-- ==================== IMAGES ONLY (no GIFs) ====================
local function StripGif(s)
        s = tostring(s or ""):gsub("%f[%w][Gg][Ii][Ff][Ss]?%f[%W]", " ")
        return Trim((s:gsub("%s+", " ")))
end

local function IsGif(r)
        if r.gif then return true end
        return tostring(r.url or ""):lower():find("%.gif%f[%W]") ~= nil
end

function Chat:PickSearch()
        Lib:Prompt({ Title = "Search images", Text = "Search the internet for pictures. Tap a result to send it.", Placeholder = "cats, sword, blox fruits...", Confirm = "Search" }, function(q)
                q = StripGif(q)
                if q ~= "" then self:ShowResults(q) end
        end)
end

function Chat:ShowResults(q)
        local canThumb = FsOk() and (getcustomasset or getsynasset) ~= nil
        local dim = New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.5, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 100, Parent = Lib.Overlay })
        local card = Sink(New("Frame", { Size = UDim2.fromOffset(360, 440), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 101,
                Theme = { BackgroundColor3 = "Bg" }, Parent = dim }))
        Corner(card, 8) Stroke(card)
        New("UIScale", { Scale = math.min(1, Lib.Overlay.AbsoluteSize.X / 390, Lib.Overlay.AbsoluteSize.Y / 470), Parent = card })
        New("TextLabel", { Text = "Image search", Font = Lib.FontBold, TextSize = 14, Size = UDim2.new(1, -80, 0, 30), Position = UDim2.fromOffset(12, 0), TextXAlignment = LEFT, ZIndex = 102, Parent = card })
        local close = New("TextButton", { Text = "Close", TextSize = 12, Size = UDim2.fromOffset(56, 22), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 4), BackgroundTransparency = 0,
                ZIndex = 102, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = card })
        Corner(close, 5)
        local function Close() if dim.Parent then dim:Destroy() end end
        close.Activated:Connect(Close)
        dim.Activated:Connect(Close)
        local box = New("TextBox", { Text = q or "", PlaceholderText = "Search the internet...", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 12, Size = UDim2.new(1, -90, 0, 26),
                Position = UDim2.fromOffset(10, 34), BackgroundTransparency = 0, TextXAlignment = LEFT, ZIndex = 102, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = card })
        Corner(box, 5) Pad(box, 8, 0, 8, 0)
        local st = { q = StripGif(q), page = 1, gen = 0 }
        local goBtn = New("TextButton", { Text = "Search", TextSize = 12, Size = UDim2.fromOffset(60, 26), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 34), BackgroundTransparency = 0,
                ZIndex = 102, Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = card })
        Corner(goBtn, 5)
        local grid = New("ScrollingFrame", { Size = UDim2.new(1, -16, 1, -92), Position = UDim2.fromOffset(8, 68), AutomaticCanvasSize = Y, ScrollBarThickness = 3, ZIndex = 102, Parent = card })
        New("UIGridLayout", { CellSize = UDim2.fromOffset(104, 104), CellPadding = UDim2.fromOffset(6, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = grid })
        local status = New("TextLabel", { Text = "", TextSize = 10, Size = UDim2.new(1, -20, 0, 14), AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 10, 1, -6), TextXAlignment = LEFT,
                ZIndex = 102, Theme = { TextColor3 = "Dim" }, Parent = card })
        local function Run(page)
                st.gen = st.gen + 1
                local gen = st.gen
                st.page = page
                if page == 1 then
                        for _, c in ipairs(grid:GetChildren()) do if not c:IsA("UIGridLayout") then c:Destroy() end end
                else
                        local m = grid:FindFirstChild("More")
                        if m then m:Destroy() end
                end
                status.Text = "Searching..."
                task.spawn(function()
                        local d = Decode(self:_Do("/search", { q = st.q, page = page, gif = "0" }))
                        if gen ~= st.gen or not card.Parent then return end
                        if not (d and d.ok) then status.Text = (d and d.error) or "Search failed. Is your worker updated?" return end
                        local shown = 0
                        for i, r in ipairs(d.results or {}) do
                                if not IsGif(r) then
                                        shown = shown + 1
                                        local b = New("TextButton", { Text = canThumb and "" or Short(r.title, 30), TextSize = 10, TextWrapped = true, LayoutOrder = (page - 1) * 100 + i, BackgroundTransparency = 0,
                                                ZIndex = 103, Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = grid })
                                        Corner(b, 6)
                                        local pic = New("ImageLabel", { Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop, ZIndex = 104, Parent = b })
                                        Corner(pic, 6)
                                        b.Activated:Connect(function()
                                                Close()
                                                self:SendImage({ url = r.url, fallback = r.thumb })
                                        end)
                                        if canThumb then
                                                Lib:AddTooltip(b, r.title)
                                                task.spawn(function()
                                                        local base = Lib.ConfigFolder .. "/cache/th_" .. tostring(r.id)
                                                        local asset
                                                        for _, ext in ipairs({ ".jpg", ".png", ".bmp" }) do
                                                                local ok, ex = pcall(isfile, base .. ext)
                                                                if ok and ex then asset = CustomAsset(base .. ext) break end
                                                        end
                                                        if not asset then
                                                                local res = self:_Do("/thumb", { u = r.thumb })
                                                                if res and res.StatusCode == 200 and type(res.Body) == "string" and #res.Body > 64 and res.Body:sub(1, 1) ~= "{" then
                                                                        local ext = ThumbExt(res.Body)
                                                                        if ext then
                                                                                CachePath("x", "image/png")
                                                                                if pcall(writefile, base .. ext, res.Body) then asset = CustomAsset(base .. ext) end
                                                                        end
                                                                end
                                                        end
                                                        if asset and pic.Parent then pic.Image = asset end
                                                end)
                                        end
                                end
                        end
                        status.Text = (shown == 0 and page == 1) and "No results." or "Tap an image to send it (up to 2 MB)."
                        if d.more then
                                local more = New("TextButton", { Name = "More", Text = "More results", TextSize = 12, LayoutOrder = page * 100, BackgroundTransparency = 0, ZIndex = 103,
                                        Theme = { BackgroundColor3 = "Field", TextColor3 = "Accent" }, Parent = grid })
                                Corner(more, 6)
                                more.Activated:Connect(function() Run(page + 1) end)
                        end
                end)
        end
        local function Go()
                local t = StripGif(box.Text)
                if t == "" then return end
                st.q = t
                Run(1)
        end
        goBtn.Activated:Connect(Go)
        box.FocusLost:Connect(function(enter) if enter then Go() end end)
        if st.q ~= "" then Run(1) end
end

-- ==================== DISABLED ELEMENTS CAN NOTIFY ====================
-- { Disabled = true, DisabledNotify = true, DisabledText = "Paid feature" }
-- Optional: DisabledTitle = "Locked", DisabledType = "info" | "success" | "warn" | "error", DisabledDuration = 3
-- DisabledNotify = false silences it. If you only set DisabledText it notifies automatically.
local function HookDisabled(obj)
        local info, row = obj.Info, obj.Row
        if not (info and row) then return end
        local last = 0
        local function Click()
                if not info.Disabled then return end
                local want = info.DisabledNotify
                if want == nil then want = info.DisabledText ~= nil end
                if not want then return end
                if os.clock() - last < 1.2 then return end
                last = os.clock()
                Lib:Notify({ Title = info.DisabledTitle, Text = tostring(info.DisabledText or "This feature is disabled."),
                        Type = info.DisabledType or "warn", Duration = info.DisabledDuration or 3 })
        end
        for _, d in ipairs(row:GetChildren()) do
                if d:IsA("TextButton") then d.Activated:Connect(Click) end
        end
end

for _, name in ipairs({ "AddToggle", "AddCheckbox", "AddButton" }) do
        local orig = Elements[name]
        Elements[name] = function(self, ...)
                local obj = orig(self, ...)
                pcall(HookDisabled, obj)
                return obj
        end
end

-- ==================== ANIMATED GROUPBOX COLLAPSE ====================
P.AddGroupbox = SubTab.AddGroupbox
function SubTab:AddGroupbox(name, side, opts)
        local box = P.AddGroupbox(self, name, side, opts)
        if not (type(opts) == "table" and opts.Collapsible) then return box end
        local container, head, arrow = box.Container, box.Frame:FindFirstChild("Head"), nil
        if head then
                for _, c in ipairs(head:GetChildren()) do if c:IsA("ImageLabel") then arrow = c end end
        end
        local fullH, gen = nil, 0
        function box:SetCollapsed(state)
                state = state and true or false
                if self.Collapsed == state then return end
                self.Collapsed = state
                gen = gen + 1
                local my = gen
                if arrow then Tween(arrow, { Rotation = state and -90 or 0 }, 0.22, Enum.EasingStyle.Quint) end
                container.ClipsDescendants = true
                local cur = container.AbsoluteSize.Y / math.max(Lib.Scale, 0.01)
                if state then
                        if container.AutomaticSize == Y then fullH = cur end
                        container.AutomaticSize = Enum.AutomaticSize.None
                        container.Size = UDim2.new(1, 0, 0, cur)
                        local t = Tween(container, { Size = UDim2.new(1, 0, 0, 0) }, 0.24, Enum.EasingStyle.Quint)
                        t.Completed:Connect(function() if gen == my then container.Visible = false end end)
                else
                        container.Visible = true
                        container.AutomaticSize = Enum.AutomaticSize.None
                        local t = Tween(container, { Size = UDim2.new(1, 0, 0, fullH or 80) }, 0.26, Enum.EasingStyle.Quint)
                        t.Completed:Connect(function()
                                if gen ~= my then return end
                                container.AutomaticSize = Y
                                container.Size = UDim2.new(1, 0, 0, 0)
                                container.ClipsDescendants = false
                        end)
                end
        end
        return box
end

-- ==================== SCROLLING TAB SIDEBAR ====================
function Window:_BuildTabScroll()
        local old = self.TabList
        if not old or old:IsA("ScrollingFrame") then return end
        local scroll = New("ScrollingFrame", { Name = "TabList", Position = old.Position, Size = old.Size, AutomaticCanvasSize = Y,
                ScrollBarThickness = 2, ScrollBarImageTransparency = 0.25, ElasticBehavior = Enum.ElasticBehavior.Never, Parent = self.Side })
        Lib:Themed(scroll, "ScrollBarImageColor3", "Dim")
        List(scroll, 3)
        Pad(scroll, 0, 0, 4, 0)
        old:Destroy()
        self.TabList = scroll
        -- the list stops above the profile / panel buttons instead of running underneath them
        local function Resize()
                if not (scroll.Parent and self.Bottom.Parent) then return end
                local bh = self.Bottom.AbsoluteSize.Y / math.max(Lib.Scale, 0.01)
                scroll.Size = UDim2.new(1, -16, 1, -(56 + bh + 8))
        end
        self.Bottom:GetPropertyChangedSignal("AbsoluteSize"):Connect(Resize)
        Resize()
        local target = 0
        if not Lib.Touch then
                -- smooth wheel scrolling on PC
                scroll.ScrollingEnabled = false
                Lib:Connect(UIS.InputChanged, function(i)
                        if i.UserInputType ~= Enum.UserInputType.MouseWheel then return end
                        if not (Lib.Visible and scroll.Visible and not self.Minimized and IsOver(scroll)) then return end
                        local max = math.max(0, scroll.AbsoluteCanvasSize.Y - scroll.AbsoluteSize.Y)
                        target = Clamp(target - i.Position.Z * 64 * Lib.Scale, 0, max)
                end)
                Lib:Connect(RunService.RenderStepped, function(dt)
                        local max = math.max(0, scroll.AbsoluteCanvasSize.Y - scroll.AbsoluteSize.Y)
                        target = Clamp(target, 0, max)
                        local cur = scroll.CanvasPosition.Y
                        local diff = target - cur
                        if math.abs(diff) < 0.4 then
                                if diff ~= 0 then scroll.CanvasPosition = Vector2.new(0, target) end
                                return
                        end
                        scroll.CanvasPosition = Vector2.new(0, cur + diff * math.min(1, dt * 14))
                end)
        end
        -- keeps the active tab in view
        function self:_TabScrollTo(btn)
                task.defer(function()
                        if not (btn.Parent and scroll.Parent) then return end
                        local max = math.max(0, scroll.AbsoluteCanvasSize.Y - scroll.AbsoluteSize.Y)
                        if max <= 0 then return end
                        local y = btn.AbsolutePosition.Y - scroll.AbsolutePosition.Y + scroll.CanvasPosition.Y
                        local want = Clamp(y - (scroll.AbsoluteSize.Y - btn.AbsoluteSize.Y) / 2, 0, max)
                        if Lib.Touch then Tween(scroll, { CanvasPosition = Vector2.new(0, want) }, 0.25, Enum.EasingStyle.Quint) else target = want end
                end)
        end
end

P.SelectTab = Window.SelectTab
function Window:SelectTab(tab)
        P.SelectTab(self, tab)
        if self._TabScrollTo and tab and tab.Rail then self:_TabScrollTo(tab.Rail.Button) end
end

-- ==================== CreateWindow hook (fullscreen button + tab scroll) ====================
P.CreateWindow = Lib.CreateWindow
function Lib:CreateWindow(cfg)
        local win = P.CreateWindow(self, cfg)
        pcall(function() win:_AddFullscreenButton() end)
        pcall(function() win:_BuildTabScroll() end)
        return win
end

end
-- ===================== end patch =====================

return Lib