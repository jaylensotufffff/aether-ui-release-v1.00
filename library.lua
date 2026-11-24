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
        Lib:_AttachPinMenu(lhit, obj)
        Lib:_AttachPinMenu(hit, obj)
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
        local function Flip() if Lib._PinHold or info.Disabled then return end obj:SetValue(not obj.Value) end
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
        local pinnable = picker.Index ~= nil -- a pin needs an id to survive restarts
        local MENU_W = 100
        local menuH = (#KeyModes + (pinnable and 1 or 0)) * H(26) + 6
        local menu = Sink(New("Frame", { Visible = false, Size = UDim2.fromOffset(MENU_W, menuH), BackgroundTransparency = 0, ZIndex = 80, Theme = { BackgroundColor3 = "Surface" }, Parent = Lib.Overlay }))
        Corner(menu, 6) Stroke(menu, "Stroke", 1, 0) List(menu, 0) Pad(menu, 3, 3, 3, 3)
        New("UIScale", { Scale = Lib.Scale, Parent = menu })
        local mbtn = {}
        for i, mode in ipairs(KeyModes) do
                local b = New("TextButton", { Text = mode, TextSize = 12, Size = UDim2.new(1, 0, 0, H(26)), LayoutOrder = i, ZIndex = 81, Theme = { TextColor3 = "SubText" }, Parent = menu })
                Press(b, function() picker:SetMode(mode) Lib:ClosePopup() end)
                mbtn[mode] = b
        end
        local pinBtn
        if pinnable then
                pinBtn = New("TextButton", { Text = "", TextSize = 12, Size = UDim2.new(1, 0, 0, H(26)), LayoutOrder = #KeyModes + 1, ZIndex = 81, Theme = { TextColor3 = "SubText" }, Parent = menu })
                Press(pinBtn, function()
                        if Lib:IsPinned(picker.Index) then Lib:Unpin(picker.Index) else Lib:Pin(picker) end
                        Lib:ClosePopup()
                end)
        end
        local function OpenMenu()
                for mode, b in pairs(mbtn) do b.TextColor3 = (picker.Mode == mode) and Lib.Theme.Accent or Lib.Theme.SubText end
                if pinBtn then
                        local pinned = Lib:IsPinned(picker.Index)
                        pinBtn.Text = pinned and "Unpin" or "Pin to screen"
                        pinBtn.TextColor3 = pinned and Lib.Theme.Accent or Lib.Theme.SubText
                end
                local pos = PlaceBelow(button, MENU_W * Lib.Scale, menuH * Lib.Scale, 4, true, WinBounds())
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
                frame.Visible = kl.Enabled and n > 0 and not (Lib.MainWindow and Lib.MainWindow.Fullscreen)
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
        if msg.id then table.insert(items, { Text = "Reply", Callback = function() self:SetReply({ id = msg.id, name = name, text = tostring(msg.text ~= "" and msg.text or (msg.cfg and "[config]" or "[image]")):sub(1, 70) }) end }) end
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
        local cfgc = type(msg.cfg) == "table" and msg.cfg or nil
        local url = txt:match("https?://[^%s<>\"]+")
        if url then url = url:gsub("[%.,;:!%?%)%]]+$", "") end
        local needW = math.min(math.ceil(Measure(txt, 13, Lib.Font, inner).X) + 6, inner)
        if url or img or cfgc then needW = inner end
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
        if cfgc then Lib:_BuildConfigCard(self, bubble, cfgc, 5) end
        item.MouseEnter:Connect(function() Tween(bubble, { BackgroundTransparency = math.max(rest - 0.15, 0) }, 0.06) end)
        item.MouseLeave:Connect(function() Tween(bubble, { BackgroundTransparency = rest }, 0.1) end)
        item.Activated:Connect(function() self:MessageMenu(msg) end)
        table.insert(self.Items, item)
        self:_Trim()
        if self.Loaded and not self.Stick and not mine then self.JumpCount = self.JumpCount + 1 self.Jump.Text = "↓ " .. self.JumpCount .. " new" end
        if pinged and self.Loaded then
                self:AddNotif(msg, nm, txt ~= "" and txt or (cfgc and "[config]" or "[image]"))
                if not self.PanelObj._shown then
                        Lib:Notify({ Title = (type(msg.reply) == "table" and "Reply from " or "Mentioned by ") .. nm, Text = (txt ~= "" and txt or (cfgc and "[config]" or "[image]")):sub(1, 90), Type = "warn", Duration = 6 })
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
                if t == "" and not msg.image and not msg.cfg then return end
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

-- ── pinned on-screen buttons ──────────────────────────────────────────────────
Lib.Pins = {}
do
        local PinCfg = { Show = true, Lock = false, Size = 40, Opacity = 0.45 }
        local PinPos = {} -- id -> { x, y } as 0..1 of the screen. Master list, also holds pins whose element isn't built yet.
        local loaded, saveQueued = false, false

        local function PinFile() return Lib.ConfigFolder .. "/pins.json" end

        -- ConfigFolder is only final after CreateWindow, so read lazily, never at library load.
        local function ReadPins()
                if loaded then return end
                loaded = true
                if not Lib.HasFS then return end
                pcall(function()
                        if not isfile(PinFile()) then return end
                        local d = HttpService:JSONDecode(readfile(PinFile()))
                        if type(d.cfg) == "table" then
                                for k, v in pairs(PinCfg) do
                                        if type(d.cfg[k]) == type(v) then PinCfg[k] = d.cfg[k] end
                                end
                                PinCfg.Size = math.clamp(PinCfg.Size, 28, 72)
                                PinCfg.Opacity = math.clamp(PinCfg.Opacity, 0.1, 1)
                        end
                        if type(d.pins) == "table" then
                                for id, p in pairs(d.pins) do
                                        if type(p) == "table" and tonumber(p.x) and tonumber(p.y) then PinPos[id] = { x = tonumber(p.x), y = tonumber(p.y) } end
                                end
                        end
                end)
        end

        function Lib:_SavePins()
                if not self.HasFS or saveQueued then return end
                saveQueued = true -- debounce: sliders fire a lot
                task.delay(0.4, function()
                        saveQueued = false
                        pcall(function()
                                Ensure()
                                writefile(PinFile(), HttpService:JSONEncode({ v = 1, cfg = PinCfg, pins = PinPos }))
                        end)
                end)
        end

        local function PinLabel(obj)
                return tostring((obj.Type == "KeyPicker" and obj.Title) or (obj.Info and obj.Info.Text) or obj.Index or "?")
        end

        local function PinOn(obj)
                if obj.Type == "KeyPicker" then return obj:GetState() end
                return obj.Value
        end

        -- Hold keybinds follow the press; Toggle keybinds and toggles flip on press; "Always" keybinds do nothing.
        local function PinFire(obj, down)
                if obj.Type == "KeyPicker" then
                        if obj.Mode == "Hold" then obj:SetState(down)
                        elseif obj.Mode == "Toggle" and down then obj:SetState(not obj.State) end
                elseif down then
                        obj:SetValue(not obj.Value)
                end
        end

        function Lib:IsPinned(id) return id ~= nil and PinPos[id] ~= nil end

        function Lib:_BuildPin(id)
                local obj, pos = self.Options[id], PinPos[id]
                if not obj or not pos or self.Pins[id] then return end
                if obj.Type ~= "Toggle" and obj.Type ~= "KeyPicker" then return end
                local btn = New("TextButton", { Name = "Pin_" .. tostring(id), Text = "", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(pos.x, pos.y),
                        Size = UDim2.fromOffset(PinCfg.Size, PinCfg.Size), BackgroundTransparency = 0, BackgroundColor3 = Lib.Theme.Surface, ZIndex = 18, Visible = PinCfg.Show, Parent = self.Gui })
                Corner(btn, 12)
                local st = Stroke(btn, "Accent", 1.5, 0.6)
                local lbl = New("TextLabel", { Text = Short(PinLabel(obj), 14), TextSize = 9, TextWrapped = true, TextTruncate = Enum.TextTruncate.AtEnd,
                        Size = UDim2.new(1, -6, 1, -6), Position = UDim2.fromOffset(3, 3), ZIndex = 19, TextColor3 = Lib.Theme.SubText, Font = Lib.FontBold, Parent = btn })
                local dot = New("Frame", { Size = UDim2.fromOffset(6, 6), Position = UDim2.new(1, -9, 0, 3), ZIndex = 20, BackgroundColor3 = Lib.Theme.Dim, Parent = btn })
                Corner(dot, 3)
                self.Pins[id] = { Obj = obj, Btn = btn, Stroke = st, Label = lbl, Dot = dot }

                -- menu OPEN + unlocked: drag to place, tap flips. Otherwise the press itself drives the feature.
                local function Dragging() return Lib.Visible and not PinCfg.Lock end
                self:MakeDraggable(btn, btn, {
                        Check = Dragging,
                        OnTap = function() Safe(PinFire, obj, true) Safe(PinFire, obj, false) end,
                        OnEnd = function()
                                local g = Lib.Gui
                                local c = btn.AbsolutePosition + btn.AbsoluteSize / 2
                                local x = math.clamp((c.X - g.AbsolutePosition.X) / g.AbsoluteSize.X, 0.02, 0.98)
                                local y = math.clamp((c.Y - g.AbsolutePosition.Y) / g.AbsoluteSize.Y, 0.02, 0.98)
                                btn.Position = UDim2.fromScale(x, y)
                                PinPos[id] = { x = x, y = y }
                                Lib:_SavePins()
                        end,
                })
                btn.InputBegan:Connect(function(input)
                        if Dragging() or not IsPress(input) then return end
                        Safe(PinFire, obj, true)
                        local c
                        c = UIS.InputEnded:Connect(function(i)
                                local fin = (i == input) or (input.UserInputType == Enum.UserInputType.MouseButton1 and i.UserInputType == Enum.UserInputType.MouseButton1)
                                if fin then c:Disconnect() Safe(PinFire, obj, false) end
                        end)
                end)
        end

        function Lib:Pin(obj, silent)
                local id = obj and obj.Index
                if not id or (obj.Type ~= "Toggle" and obj.Type ~= "KeyPicker") then return false end
                ReadPins()
                if PinPos[id] then return true end
                local n = 0
                for _ in pairs(PinPos) do n = n + 1 end
                PinPos[id] = { x = 0.9, y = math.min(0.25 + 0.1 * n, 0.9) } -- stack down the right edge; drag from there
                self:_BuildPin(id)
                self:_SavePins()
                if not silent then self:Notify({ Title = "Pinned", Text = PinLabel(obj) .. ". Drag it while the menu is open.", Type = "success", Duration = 3 }) end
                return true
        end

        function Lib:Unpin(id)
                local p = self.Pins[id]
                if p then p.Btn:Destroy() self.Pins[id] = nil end
                PinPos[id] = nil
                self:_SavePins()
        end

        function Lib:_ApplyPins()
                for _, p in pairs(self.Pins) do
                        p.Btn.Visible = PinCfg.Show
                        p.Btn.Size = UDim2.fromOffset(PinCfg.Size, PinCfg.Size)
                        p.Label.TextSize = math.max(8, math.floor(PinCfg.Size / 4.4))
                end
        end

        -- Build every saved pin. Safe to call again; pins whose element doesn't exist yet are skipped.
        function Lib:LoadPins()
                ReadPins()
                for id in pairs(PinPos) do self:_BuildPin(id) end
                self:_ApplyPins()
        end

        -- state colours (cheap, 10x/sec, same cadence as the keybind list)
        local acc = 0
        Lib:Connect(RunService.RenderStepped, function(dt)
                acc = acc + dt
                if acc < 0.1 then return end
                acc = 0
                local T = Lib.Theme
                for _, p in pairs(Lib.Pins) do
                        local on = PinOn(p.Obj) and true or false
                        local a = on and math.min(1, PinCfg.Opacity + 0.35) or PinCfg.Opacity
                        p.Btn.BackgroundTransparency = 1 - a
                        p.Btn.BackgroundColor3 = on and T.Accent or T.Surface
                        p.Label.TextColor3 = on and T.OnAccent or T.SubText
                        p.Label.TextTransparency = 1 - math.min(1, a + 0.3)
                        p.Stroke.Transparency = on and 0.2 or 0.6
                        p.Dot.BackgroundColor3 = on and T.Good or T.Dim
                end
        end)

        -- Right-click / long-press menu for toggles (keybinds get the entry in their own mode menu, see 1B).
        local pinMenu
        local function PinMenu()
                if pinMenu and pinMenu.Frame.Parent then return pinMenu end
                local f = Sink(New("Frame", { Visible = false, Size = UDim2.fromOffset(120, H(26) + 6), BackgroundTransparency = 0, ZIndex = 80, Theme = { BackgroundColor3 = "Surface" }, Parent = Lib.Overlay }))
                Corner(f, 6) Stroke(f, "Stroke", 1, 0) Pad(f, 3, 3, 3, 3)
                New("UIScale", { Scale = Lib.Scale, Parent = f })
                local b = New("TextButton", { Text = "", TextSize = 12, Size = UDim2.new(1, 0, 0, H(26)), ZIndex = 81, Theme = { TextColor3 = "SubText" }, Parent = f })
                pinMenu = { Frame = f, Btn = b }
                Press(b, function() if pinMenu.Fn then pinMenu.Fn() end Lib:ClosePopup() end)
                return pinMenu
        end

        function Lib:_AttachPinMenu(btn, obj)
                local function Open(input)
                        if not obj.Index then return end
                        local m = PinMenu()
                        local pinned = Lib:IsPinned(obj.Index)
                        m.Btn.Text = pinned and "Unpin from screen" or "Pin to screen"
                        m.Btn.TextColor3 = pinned and Lib.Theme.Accent or Lib.Theme.SubText
                        m.Fn = function() if Lib:IsPinned(obj.Index) then Lib:Unpin(obj.Index) else Lib:Pin(obj) end end
                        local pos = PlaceBelow(btn, 120 * Lib.Scale, (H(26) + 6) * Lib.Scale, 4, true, WinBounds())
                        m.Frame.Position = UDim2.fromOffset(pos.X, pos.Y)
                        m.Frame.UIScale.Scale = Lib.Scale
                        m.Frame.Visible = true
                        Lib:OpenPopup(m.Frame, function() m.Frame.Visible = false end, btn)
                end
                btn.MouseButton2Click:Connect(function() Open() end)
                btn.InputBegan:Connect(function(input)
                        if input.UserInputType ~= Enum.UserInputType.Touch then return end
                        local held, c = true, nil
                        c = UIS.InputEnded:Connect(function(i) if i == input then held = false c:Disconnect() end end)
                        task.delay(0.45, function()
                                if not held then return end
                                held = false
                                Lib._PinHold = input -- swallow the tap that the finger lift would otherwise register
                                UIS.InputEnded:Once(function() task.delay(0.15, function() Lib._PinHold = nil end) end)
                                Open()
                        end)
                end)
        end

        function Lib:BuildPinSettings(g)
                ReadPins()
                task.defer(function() Lib:LoadPins() end) -- after the user's own UI exists
                local function Changed() Lib:_ApplyPins() Lib:_SavePins() end
                g:AddToggle("__PinShow", { Text = "Show pinned buttons", Default = PinCfg.Show, IgnoreConfig = true, Callback = function(v) PinCfg.Show = v Changed() end })
                g:AddToggle("__PinLock", { Text = "Lock positions", Default = PinCfg.Lock, IgnoreConfig = true, Callback = function(v) PinCfg.Lock = v Changed() end })
                g:AddSlider("__PinSize", { Text = "Button size", Min = 28, Max = 72, Default = PinCfg.Size, Rounding = 0, IgnoreConfig = true, Callback = function(v) PinCfg.Size = v Changed() end })
                g:AddSlider("__PinOpacity", { Text = "Idle opacity", Min = 0.1, Max = 1, Default = PinCfg.Opacity, Rounding = 2, IgnoreConfig = true, Callback = function(v) PinCfg.Opacity = v Changed() end })
                g:AddButton({ Text = "Unpin all", DoubleClick = true, Func = function()
                        local ids = {}
                        for id in pairs(PinPos) do table.insert(ids, id) end
                        for _, id in ipairs(ids) do Lib:Unpin(id) end
                end })
                g:AddLabel("Right-click (or long-press on mobile) a toggle or keybind to pin it. Drag pins while this menu is open.")
        end
end

-- ── shared configs ────────────────────────────────────────────────────────────
-- Save a received config into the saved-configs folder (never applies it). Returns the final name, or false + error.
function Lib:ImportConfig(name, data)
        if not self.HasFS then return false, "Your executor has no file functions." end
        if type(data) ~= "table" then return false, "That isn't a valid config." end
        local clean, count = {}, 0
        for k, v in pairs(data) do
                if type(k) == "string" and not k:find("^__") and type(v) == "table" and type(v.Type) == "string" then
                        clean[k] = v
                        count = count + 1
                end
        end
        if count == 0 then return false, "That config is empty." end
        name = Sanitize(name or ""):sub(1, 40)
        if name == "" then name = "Imported" end
        local taken = {}
        for _, n in ipairs(self:ListConfigs()) do taken[n:lower()] = true end
        local final, i = name, 2
        while taken[final:lower()] do final = name .. " " .. i i = i + 1 end -- "name 2", "name 3"
        Ensure()
        local ok, err = pcall(function() writefile(CPath(final), HttpService:JSONEncode(clean)) end)
        if not ok then return false, tostring(err) end
        pcall(function() local dd = Lib.Options.__ConfigList if dd then dd:SetValues(Lib:ListConfigs()) end end)
        return final
end

-- upload, then post a message that references it (same two-step flow as images)
function Chat:ShareConfig(name, data)
        if self.Blocked or not self.Request then return end
        if os.clock() - self.LastSend < 0.8 then self:System("Slow down a little.") return end
        local json = HttpService:JSONEncode(data)
        if #json > 60000 then Lib:Notify({ Title = "Config", Text = "That config is too big to share.", Type = "error" }) return end
        self.LastSend = os.clock()
        local caption = Trim(self.Input.Text)
        local replyId = self.ReplyTo and self.ReplyTo.id or nil
        Lib:Notify({ Title = "Config", Text = "Sharing...", Type = "info", Duration = 2 })
        task.spawn(function()
                local d = Decode(self:_Do("/cfgup", nil, "POST", HttpService:JSONEncode({ name = name, data = json })))
                if not (d and d.ok and d.id) then self:System((d and d.error) or "Couldn't share the config. Is your worker updated?") return end
                self.Input.Text = ""
                self:SetReply(nil)
                self.Stick = true
                local r = Decode(self:_Do("/send", nil, "POST", HttpService:JSONEncode({ text = caption:sub(1, self.Config.MaxLength), replyTo = replyId, cfg = d.id })))
                if not (r and r.ok) then self:System((r and r.error) or "Couldn't post the config.") return end
                self:_PollOnce()
                Lib:Notify({ Title = "Config", Text = "Shared «" .. name .. "» in chat.", Type = "success", Duration = 2.5 })
        end)
end

-- shares the selected saved config, or your current settings if none is selected
function Lib:ShareConfigToChat(saved)
        local chat = self.ChatObj
        if not chat or not chat.Alive then self:Notify({ Title = "Config", Text = "Open the chat first.", Type = "warn" }) return end
        local data, name
        if saved and saved ~= "" then
                name = Sanitize(saved)
                local ok, raw = pcall(function() return readfile(CPath(name)) end)
                local dec, d = false, nil
                if ok then dec, d = pcall(HttpService.JSONDecode, HttpService, raw) end
                if not (dec and type(d) == "table") then self:Notify({ Title = "Config", Text = "Couldn't read that config.", Type = "error" }) return end
                data = d
        else
                data = self:SerializeConfig()
                local o = self.Options.__ConfigName
                name = Sanitize(o and o.Value or "")
                if name == "" then name = "Shared config" end
        end
        chat:ShareConfig(name, data)
end

-- the card inside a chat bubble
function Lib:_BuildConfigCard(chat, parent, cfg, order)
        local id = tostring(cfg.id or "")
        local card = New("Frame", { Name = "ConfigCard", Size = UDim2.new(1, 0, 0, 50), LayoutOrder = order, BackgroundTransparency = 0.35, Theme = { BackgroundColor3 = "Bg" }, Parent = parent })
        Corner(card, 6)
        New("Frame", { Size = UDim2.new(0, 2, 1, -10), Position = UDim2.fromOffset(5, 5), Theme = { BackgroundColor3 = "Accent" }, Parent = card })
        New("TextLabel", { Text = "CONFIG", TextSize = 10, Size = UDim2.new(1, -86, 0, 13), Position = UDim2.fromOffset(14, 5), TextXAlignment = LEFT, Theme = { TextColor3 = "Dim" }, Parent = card })
        New("TextLabel", { Text = Short(cfg.name or "Config", 28), Font = Lib.FontBold, TextSize = 12, Size = UDim2.new(1, -86, 0, 16), Position = UDim2.fromOffset(14, 18),
                TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text" }, Parent = card })
        local sub = New("TextLabel", { Text = tonumber(cfg.n) and (math.floor(cfg.n) .. " settings") or "Shared config", TextSize = 10, Size = UDim2.new(1, -86, 0, 13),
                Position = UDim2.fromOffset(14, 34), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = card })
        local btn = New("TextButton", { Text = "Copy", Font = Lib.FontBold, TextSize = 12, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
                Size = UDim2.fromOffset(58, 28), BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = card })
        Corner(btn, 6)

        local busy, done = false, false
        Press(btn, function()
                if busy or done then return end
                busy = true
                btn.Text = "..."
                task.spawn(function()
                        local d = Decode(chat:_Do("/cfg", { id = id }))
                        local data
                        if d and d.ok and type(d.data) == "string" and #d.data <= 60000 then
                                local dec, t = pcall(HttpService.JSONDecode, HttpService, d.data)
                                if dec and type(t) == "table" then data = t end
                        end
                        if not btn.Parent then return end
                        if not data then
                                busy = false
                                btn.Text = (d and d.error == "expired") and "Expired" or "Retry"
                                Lib:Notify({ Title = "Config", Text = (d and d.error == "expired") and "That config has expired." or ((d and d.error) or "Couldn't fetch that config."), Type = "error" })
                                return
                        end
                        if Lib.HasFS then
                                local saved, err = Lib:ImportConfig(d.name or cfg.name, data)
                                if saved then
                                        done = true
                                        btn.Text = "Saved"
                                        sub.Text = "Saved as " .. saved
                                        Lib:Notify({ Title = "Config", Text = "Added «" .. saved .. "» to your configs.", Type = "success" })
                                else
                                        busy = false
                                        btn.Text = "Retry"
                                        Lib:Notify({ Title = "Config", Text = err or "Couldn't save it.", Type = "error" })
                                end
                        elseif type(setclipboard) == "function" then
                                setclipboard(HttpService:JSONEncode(data))
                                done = true
                                btn.Text = "Copied"
                                Lib:Notify({ Title = "Config", Text = "No file access, so it was copied as text. Paste it under Configs > Import.", Type = "info", Duration = 5 })
                        else
                                busy = false
                                btn.Text = "Retry"
                                Lib:Notify({ Title = "Config", Text = "Your executor can neither save files nor copy text.", Type = "error" })
                        end
                end)
        end)
        Lib:AddTooltip(card, "Copy adds it to your saved configs. It doesn't apply it.")
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
        share:AddButton({ Text = "Share in chat", Icon = "send", Tooltip = "Shares the selected saved config, or your current settings if none is selected.", Func = function()
                local o = Lib.Options.__ConfigList
                Lib:ShareConfigToChat(o and o.Value)
        end })
        Lib:BuildPinSettings(cfgTab:AddRightGroupbox("Pinned buttons", { Icon = "pin" }))
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

-- ===================== Aether patch 4.3: motion + live search =====================
-- Paste this block right above the final `return Lib` (after the "fullscreen v2" patch).
-- It must live in the same file: it hooks file-local helpers (Tween, New, Corner, ...).
do
Lib.Fx = Lib.Fx or { Springs = true, Ripple = true, TabAnim = true }
Lib.SpringPop = Lib.SpringPop or 0.94 -- panels / window pop in from this fraction of their size

-- ==================== A) SPRING PHYSICS ====================
do
local Springs = {}
local Owned = setmetatable({}, { __mode = "k" }) -- instances whose Position/Size ALWAYS spring (slider parts)
Lib._SpringOwned = Owned
local Preset = { Position = { 16, 0.55 }, Size = { 13, 0.72 }, Scale = { 15, 0.5 } } -- { frequency, damping ratio }
local Tol = { n = { 0.002 }, u = { 0.002, 1.2, 0.002, 1.2 }, v = { 1.2, 1.2 } }
local Eps = { n = { 0.0005 }, u = { 0.0008, 0.04, 0.0008, 0.04 }, v = { 0.04, 0.04 } }
local ScaleIdx = { n = { 1 }, u = { 1, 3 }, v = {} }

local function Pack(v)
        local t = typeof(v)
        if t == "number" then return { v }, "n"
        elseif t == "UDim2" then return { v.X.Scale, v.X.Offset, v.Y.Scale, v.Y.Offset }, "u"
        elseif t == "Vector2" then return { v.X, v.Y }, "v" end
end

local function Unpack(a, kind)
        if kind == "n" then return a[1]
        elseif kind == "u" then return UDim2.new(a[1], math.floor(a[2] + 0.5), a[3], math.floor(a[4] + 0.5)) end
        return Vector2.new(a[1], a[2])
end

-- Lib.Spring(inst, prop, target, { Freq, Damping, Clamp01, From, OnDone })
function Lib.Spring(inst, prop, target, o)
        o = o or {}
        local tgt, kind = Pack(target)
        local okc, cur = pcall(function() return inst[prop] end)
        local now = okc and Pack(cur)
        if not (tgt and now) then
                pcall(function() inst[prop] = target end)
                if o.OnDone then Safe(o.OnDone) end
                return { Cancel = function() end }
        end
        if o.From ~= nil then
                local f = Pack(o.From)
                if f then now = f pcall(function() inst[prop] = o.From end) end
        end
        local per = Springs[inst]
        if not per then per = {} Springs[inst] = per end
        local s = per[prop]
        if s then
                -- somebody wrote the property directly since the last frame: start from there, keep listeners
                for i = 1, #now do
                        if math.abs(now[i] - s.pos[i]) > Tol[kind][i] then
                                s.pos, s.vel = now, {}
                                for j = 1, #now do s.vel[j] = 0 end
                                break
                        end
                end
        else
                s = { kind = kind, pos = now, vel = {}, done = {} }
                for i = 1, #now do s.vel[i] = 0 end
                per[prop] = s
        end
        local pr = Preset[prop] or { 14, 0.7 }
        s.f, s.z, s.tgt, s.eps, s.lo, s.hi = o.Freq or pr[1], o.Damping or pr[2], tgt, Eps[kind], {}, {}
        -- long slides (notifications, docking panels) settle without bounce so they never clip
        if kind == "u" and prop == "Position" and not o.Damping
                and math.max(math.abs(tgt[2] - s.pos[2]), math.abs(tgt[4] - s.pos[4])) > 120 then s.z = 1 end
        -- shrinking sizes never undershoot (no negative sizes, header never dips below the minimized height)
        if prop == "Size" then for i = 1, #tgt do if tgt[i] < s.pos[i] then s.lo[i] = tgt[i] end end end
        if inst:IsA("UIScale") then s.lo[1] = 0 end
        if o.Clamp01 then for _, i in ipairs(ScaleIdx[kind]) do s.lo[i], s.hi[i] = 0, 1 end end
        if o.OnDone then table.insert(s.done, o.OnDone) end
        return { Cancel = function() if per[prop] == s then per[prop] = nil end end }
end

function Lib.SpringCancel(inst, prop)
        local per = Springs[inst]
        if per then per[prop] = nil end
end

Lib:Connect(RunService.RenderStepped, function(dt)
        if next(Springs) == nil then return end
        dt = math.min(dt, 0.05)
        local n = math.max(1, math.ceil(dt * 120))
        local h = dt / n
        local fire = {}
        for inst, per in pairs(Springs) do
                if inst.Parent == nil then
                        Springs[inst] = nil
                else
                        for prop, s in pairs(per) do
                                local ok, cur = pcall(function() return inst[prop] end)
                                local now = ok and Pack(cur)
                                local stop = not now
                                if now then
                                        for i = 1, #now do
                                                -- the property was written by someone else: they win, we stop
                                                if math.abs(now[i] - s.pos[i]) > Tol[s.kind][i] * 1.5 then stop = true break end
                                        end
                                end
                                if stop then
                                        per[prop] = nil
                                        for _, fn in ipairs(s.done) do table.insert(fire, fn) end
                                else
                                        local settled = true
                                        for i = 1, #s.pos do
                                                local x, v, t = s.pos[i], s.vel[i], s.tgt[i]
                                                for _ = 1, n do
                                                        v = v + (-s.f * s.f * (x - t) - 2 * s.z * s.f * v) * h
                                                        x = x + v * h
                                                end
                                                local lo, hi = s.lo[i], s.hi[i]
                                                if lo and x < lo then x = lo if v < 0 then v = 0 end end
                                                if hi and x > hi then x = hi if v > 0 then v = 0 end end
                                                s.pos[i], s.vel[i] = x, v
                                                if math.abs(x - t) > s.eps[i] or math.abs(v) > s.eps[i] * 25 then settled = false end
                                        end
                                        if settled then
                                                for i = 1, #s.pos do s.pos[i], s.vel[i] = s.tgt[i], 0 end
                                                per[prop] = nil
                                                for _, fn in ipairs(s.done) do table.insert(fire, fn) end
                                        end
                                        pcall(function() inst[prop] = Unpack(s.pos, s.kind) end)
                                end
                        end
                        if next(per) == nil then Springs[inst] = nil end
                end
        end
        for _, fn in ipairs(fire) do Safe(fn) end
end)

-- Every Quint tween of Position / Size / UIScale.Scale in the library becomes a spring.
-- Anything else (colors, transparency, CanvasPosition, Quad/Sine tweens) is untouched.
local RawTween = Tween
Tween = function(inst, props, d, style, dir)
        if not (Lib.Fx.Springs and typeof(inst) == "Instance") then return RawTween(inst, props, d, style, dir) end
        local owned = Owned[inst]
        if not (owned or style == Enum.EasingStyle.Quint) then return RawTween(inst, props, d, style, dir) end
        local rest, springs, count = {}, {}, 0
        for k, v in pairs(props) do
                if Preset[k] and (k ~= "Scale" or inst:IsA("UIScale")) then springs[k] = v count = count + 1 else rest[k] = v end
        end
        if count == 0 then return RawTween(inst, props, d, style, dir) end
        local real = next(rest) ~= nil and RawTween(inst, rest, d, style, dir) or nil
        local shim, left, handles = { Completed = Signal.new() }, count, {}
        for k, v in pairs(springs) do
                local o = { Clamp01 = owned and true or nil, OnDone = function()
                        left = left - 1
                        if left == 0 then shim.Completed:Fire() end
                end }
                if k == "Scale" and typeof(v) == "number" and inst.Scale < v then o.From = v * Lib.SpringPop end
                table.insert(handles, Lib.Spring(inst, k, v, o))
        end
        function shim:Cancel() for _, h2 in ipairs(handles) do h2.Cancel() end end
        function shim:Play() end
        function shim:Pause() end
        return real or shim
end
Lib.Tween = Tween

-- Sliders: the fill + knob chase the value with a spring, also while dragging.
local origSlider = Elements.AddSlider
Elements.AddSlider = function(self, idx, info)
        local obj = origSlider(self, idx, info)
        pcall(function()
                local track = obj.Row:FindFirstChildWhichIsA("Frame")
                local parts = {}
                for _, c in ipairs(track:GetChildren()) do if c:IsA("Frame") then table.insert(parts, c) end end
                local fill, knob = parts[1], parts[2]
                if not (fill and knob) then return end
                Owned[fill], Owned[knob] = true, true
                local rawSet = obj.SetValue
                local function Cur(inst, prop)
                        local s = Springs[inst] and Springs[inst][prop]
                        return s and Unpack(s.pos, s.kind) or inst[prop]
                end
                obj.SetValue = function(me, v, silent)
                        if not Lib.Fx.Springs then return rawSet(me, v, silent) end
                        local pk, pf = Cur(knob, "Position"), Cur(fill, "Size")
                        rawSet(me, v, silent) -- Render() may have written the final value straight onto the frames while dragging
                        local r = Clamp(Map(me.Value, me.Min, me.Max, 0, 1), 0, 1)
                        knob.Position, fill.Size = pk, pf
                        Lib.Spring(knob, "Position", UDim2.fromScale(r, 0.5), { Clamp01 = true })
                        Lib.Spring(fill, "Size", UDim2.fromScale(r, 1), { Clamp01 = true })
                end
        end)
        return obj
end
end

-- ==================== B) RIPPLE CLICK EFFECT ====================
do
local function Ripple(btn, input, padL, padT, radius)
        local abs, sz = btn.AbsolutePosition, btn.AbsoluteSize
        if sz.X < 2 or sz.Y < 2 then return end
        local sc = math.max(Lib.Scale, 0.01)
        local p = (Pointer(input) - abs) / sc -- exact click point, in the button's own (unscaled) pixels
        local w, h = sz.X / sc, sz.Y / sc
        local ok, cg = pcall(function() return Instance.new("CanvasGroup") end)
        if not ok then return end
        cg.Name, cg.BackgroundTransparency, cg.BorderSizePixel, cg.ZIndex = "Ripple", 1, 0, 5
        cg.Size, cg.Position = UDim2.fromOffset(w, h), UDim2.fromOffset(-padL, -padT) -- undo the button's UIPadding
        cg.Parent = btn
        Corner(cg, radius) -- a CanvasGroup clips to the rounded corners
        local far = math.max(math.sqrt(p.X ^ 2 + p.Y ^ 2), math.sqrt((w - p.X) ^ 2 + p.Y ^ 2),
                math.sqrt(p.X ^ 2 + (h - p.Y) ^ 2), math.sqrt((w - p.X) ^ 2 + (h - p.Y) ^ 2))
        local dot = New("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(p.X, p.Y), Size = UDim2.fromOffset(0, 0),
                BackgroundColor3 = Lib.Theme.Accent, BackgroundTransparency = 0.7, Parent = cg })
        New("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = dot })
        Tween(dot, { Size = UDim2.fromOffset(far * 2 + 4, far * 2 + 4) }, 0.5, Enum.EasingStyle.Quart)
        Tween(dot, { BackgroundTransparency = 1 }, 0.6, Enum.EasingStyle.Sine)
        task.delay(0.65, function() if cg.Parent then cg:Destroy() end end)
end

-- Lib.AddRipple(button, padLeft, padTop, cornerRadius, canFire)
function Lib.AddRipple(btn, padL, padT, radius, can)
        btn.InputBegan:Connect(function(input)
                if not (Lib.Fx.Ripple and IsPress(input)) then return end
                if can and not can() then return end
                pcall(Ripple, btn, input, padL or 0, padT or 0, radius or 5)
        end)
end

local origButton = Elements.AddButton
Elements.AddButton = function(self, a, b)
        local obj = origButton(self, a, b)
        pcall(function()
                local btn = obj.Row:FindFirstChildWhichIsA("TextButton")
                if not btn then return end
                local old = btn:FindFirstChildWhichIsA("Frame") -- the old fixed-position flash, replaced by the ripple
                if old then old.Visible = false end
                Lib.AddRipple(btn, obj.Info.Icon and 30 or 10, 3, 5, function() return not obj.Info.Disabled end)
        end)
        return obj
end

local origRow = Elements.AddButtonRow
Elements.AddButtonRow = function(self, buttons)
        local out = origRow(self, buttons)
        for _, b in ipairs(out or {}) do Lib.AddRipple(b, 8, 2, 5) end
        return out
end
end

-- ==================== C) DIRECTIONAL TAB TRANSITIONS ====================
do
local origSelect = Window.SelectTab
function Window:SelectTab(tab)
        local prev = self.ActiveTab
        origSelect(self, tab)
        if not (Lib.Fx.TabAnim and prev and tab and prev ~= tab) or self.Minimized or Lib.Unloaded then return end
        local a, b = IndexOf(self.Tabs, prev), IndexOf(self.Tabs, tab)
        if not (a and b) then return end
        -- lower in the rail -> the page rises in from below; higher -> it slides down from above
        local dir = b > a and 1 or -1
        local sc = tab.Scroll
        Lib.SpringCancel(sc, "Position")
        sc.Position = UDim2.fromOffset(0, 30 * dir)
        Lib.Spring(sc, "Position", UDim2.new(), { Freq = 15, Damping = 0.62 })
        local fade = self._tabFade
        if not (fade and fade.Parent) then
                fade = New("Frame", { Name = "TabFade", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 50,
                        Theme = { BackgroundColor3 = "Bg" }, Parent = self.Pages })
                self._tabFade = fade
        end
        fade.BackgroundTransparency = 0.45
        Tween(fade, { BackgroundTransparency = 1 }, 0.28)
end
end

-- ==================== D) LIVE SEARCH WITH INLINE ACTIONS ====================
do
local function SFmt(o, v)
        local i = o.Info or {}
        if i.Display then
                local ok, r = pcall(i.Display, v)
                return ok and tostring(r) or tostring(v)
        end
        local rd = i.Rounding or 0
        local s = rd > 0 and string.format("%." .. rd .. "f", v) or tostring(math.floor(v + 0.5))
        return (i.Prefix or "") .. s .. (i.Suffix or "")
end

local Reserve = { Toggle = 52, Button = 64, Segmented = 128, Dropdown = 128, Slider = 90 }

function Window:_BuildSearch(field, clear)
        local win, box = self, self.SearchBox
        local results = Sink(New("Frame", { Visible = false, BackgroundTransparency = 0, ZIndex = 90, Theme = { BackgroundColor3 = "Surface" }, Parent = Lib.Overlay }))
        Corner(results, 6) Stroke(results)
        local rlist = New("ScrollingFrame", { Size = UDim2.new(1, -8, 1, -8), Position = UDim2.fromOffset(4, 4), ZIndex = 91, ScrollBarThickness = 2, AutomaticCanvasSize = Y, Parent = results })
        List(rlist, 2)
        local first, live = nil, {}
        local function Drop() for _, c in ipairs(live) do pcall(function() c:Disconnect() end) end live = {} end
        local function Hide() results.Visible = false rlist.ScrollingEnabled = true Drop() end
        local function Pick(gb, e)
                Hide()
                if Lib.Popup and Lib.Popup.Frame == results then Lib.Popup = nil end
                box.Text = ""
                pcall(function() box:ReleaseFocus() end)
                task.defer(function() pcall(function() win:Goto(gb, e.row) end) end)
        end

        -- builds one result row; returns its height
        local function Build(n, tab, sub, gb, e)
                local o = e.obj
                local kind, info = o.Type, o.Info or {}
                local can = not info.Disabled and (kind == "Toggle" or kind == "Slider" or kind == "Button" or kind == "Segmented"
                        or (kind == "Dropdown" and not info.Multi))
                local hgt = (can and kind == "Slider") and 58 or 38
                local reserve = can and Reserve[kind] or 12
                local b = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, hgt), LayoutOrder = n, ZIndex = 92, Theme = { BackgroundColor3 = "Field" }, Parent = rlist })
                Corner(b, 4)
                New("TextLabel", { Text = e.name, TextSize = 13, Size = UDim2.new(1, -(8 + reserve), 0, 16), Position = UDim2.fromOffset(8, 3), TextXAlignment = LEFT, ZIndex = 93,
                        TextTruncate = Enum.TextTruncate.AtEnd, Parent = b })
                New("TextLabel", { Text = tab.Name .. " › " .. sub.Name .. " › " .. gb.Name, TextSize = 10, Size = UDim2.new(1, -(8 + reserve), 0, 12), Position = UDim2.fromOffset(8, 20),
                        TextXAlignment = LEFT, ZIndex = 93, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Dim" }, Parent = b })
                b.MouseEnter:Connect(function() Tween(b, { BackgroundColor3 = Lib.Theme.FieldHover }, 0.06) end)
                b.MouseLeave:Connect(function() Tween(b, { BackgroundColor3 = Lib.Theme.Field }, 0.08) end)
                local fired = false
                local function Go() if fired then return end fired = true Pick(gb, e) end
                b.InputBegan:Connect(function(i) if IsPress(i) then Go() end end)
                b.Activated:Connect(Go)
                if not can then return hgt end

                if kind == "Toggle" then
                        local tw, th = 30, 16
                        local kn = th - 6
                        local sw = New("TextButton", { Text = "", Size = UDim2.fromOffset(tw + 12, 26), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -4, 0.5, 0), ZIndex = 93, Parent = b })
                        local tr = New("Frame", { Size = UDim2.fromOffset(tw, th), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 94,
                                BackgroundColor3 = Lib.Theme.Stroke, Parent = sw })
                        Corner(tr, th / 2)
                        local kb = New("Frame", { Size = UDim2.fromOffset(kn, kn), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), ZIndex = 95,
                                BackgroundColor3 = Lib.Theme.Dim, Parent = tr })
                        Corner(kb, kn / 2)
                        local function Paint(anim)
                                local on = o.Value == true
                                local tc = on and Lib.Theme.Accent or Lib.Theme.Stroke
                                local kp = UDim2.new(0, on and (tw - kn - 3) or 3, 0.5, 0)
                                local kc = on and Lib.KnobOn() or Lib.Theme.Dim
                                if anim then
                                        Tween(tr, { BackgroundColor3 = tc }, 0.14)
                                        Tween(kb, { Position = kp, BackgroundColor3 = kc }, 0.18, Enum.EasingStyle.Quint)
                                else
                                        tr.BackgroundColor3, kb.Position, kb.BackgroundColor3 = tc, kp, kc
                                end
                        end
                        Paint(false)
                        table.insert(live, o.Changed:Connect(function() Paint(true) end))
                        sw.Activated:Connect(function() o:SetValue(not o.Value) end)

                elseif kind == "Slider" then
                        local vl = New("TextLabel", { Text = "", TextSize = 12, Size = UDim2.fromOffset(78, 16), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 3),
                                TextXAlignment = RIGHT, ZIndex = 93, Parent = b })
                        local tr = New("Frame", { Size = UDim2.new(1, -16, 0, 4), Position = UDim2.new(0, 8, 1, -14), ZIndex = 93, BackgroundColor3 = Lib.Theme.Stroke, Parent = b })
                        Corner(tr, 2)
                        local fl = New("Frame", { Size = UDim2.fromScale(0, 1), ZIndex = 94, Theme = { BackgroundColor3 = "Accent" }, Parent = tr })
                        Corner(fl, 2)
                        local kn = New("Frame", { Size = UDim2.fromOffset(6, 14), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), ZIndex = 95, BackgroundColor3 = WHITE, Parent = tr })
                        Corner(kn, 2)
                        if Lib._SpringOwned then Lib._SpringOwned[fl], Lib._SpringOwned[kn] = true, true end
                        local function Paint(anim)
                                local r = Clamp(Map(o.Value, o.Min, o.Max, 0, 1), 0, 1)
                                vl.Text = SFmt(o, o.Value)
                                if anim then
                                        Tween(fl, { Size = UDim2.fromScale(r, 1) }, 0.1)
                                        Tween(kn, { Position = UDim2.fromScale(r, 0.5) }, 0.1)
                                else
                                        fl.Size, kn.Position = UDim2.fromScale(r, 1), UDim2.fromScale(r, 0.5)
                                end
                        end
                        Paint(false)
                        table.insert(live, o.Changed:Connect(function() Paint(true) end))
                        local hit = New("TextButton", { Text = "", Size = UDim2.new(1, -8, 0, 24), Position = UDim2.fromOffset(4, 32), ZIndex = 96, Parent = b })
                        hit.InputBegan:Connect(function(input)
                                if not IsPress(input) then return end
                                local isTouch = input.UserInputType == Enum.UserInputType.Touch
                                rlist.ScrollingEnabled = false
                                local function From(pos)
                                        o:SetValue(Lerp(o.Min, o.Max, Clamp((pos.X - tr.AbsolutePosition.X) / math.max(tr.AbsoluteSize.X, 1), 0, 1)))
                                end
                                From(Pointer(input))
                                local mc, ec
                                mc = UIS.InputChanged:Connect(function(i)
                                        if isTouch then if i == input then From(Pointer(i)) end
                                        elseif i.UserInputType == Enum.UserInputType.MouseMovement then From(Pointer(i)) end
                                end)
                                ec = UIS.InputEnded:Connect(function(i)
                                        local fin = isTouch and (i == input) or (not isTouch and i.UserInputType == Enum.UserInputType.MouseButton1)
                                        if fin then rlist.ScrollingEnabled = true mc:Disconnect() ec:Disconnect() end
                                end)
                        end)

                elseif kind == "Button" then
                        local armed = false
                        local rb = New("TextButton", { Text = "Run", TextSize = 12, Size = UDim2.fromOffset(52, 22), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0),
                                BackgroundTransparency = 0, ZIndex = 93, Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = b })
                        Corner(rb, 4)
                        Lib.AddRipple(rb, 0, 0, 4)
                        rb.Activated:Connect(function()
                                if info.DoubleClick and not armed then
                                        armed = true
                                        rb.Text = "Sure?"
                                        task.delay(2, function() if armed and rb.Parent then armed = false rb.Text = "Run" end end)
                                        return
                                end
                                armed = false
                                o:Click()
                                rb.Text = "Done"
                                task.delay(0.9, function() if rb.Parent then rb.Text = "Run" end end)
                        end)

                else -- Segmented / single Dropdown: < value >
                        local holder = New("Frame", { Size = UDim2.fromOffset(118, 24), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0), BackgroundTransparency = 1, ZIndex = 93, Parent = b })
                        local val = New("TextLabel", { Text = "", TextSize = 12, Size = UDim2.new(1, -44, 1, 0), Position = UDim2.fromOffset(22, 0), ZIndex = 94,
                                TextTruncate = Enum.TextTruncate.AtEnd, Parent = holder })
                        local function Paint() val.Text = o.Value ~= nil and tostring(o.Value) or "-" end
                        Paint()
                        table.insert(live, o.Changed:Connect(Paint))
                        local function Step(d)
                                local list = o.Values or {}
                                if #list == 0 then return end
                                local i = IndexOf(list, o.Value) or (d > 0 and 0 or 1)
                                o:SetValue(list[(i - 1 + d) % #list + 1])
                        end
                        for _, def in ipairs({ { "<", 0, -1 }, { ">", 1, 1 } }) do
                                local sb = New("TextButton", { Text = def[1], TextSize = 13, Size = UDim2.fromOffset(20, 22), AnchorPoint = Vector2.new(def[2], 0.5), Position = UDim2.new(def[2], 0, 0.5, 0),
                                        BackgroundTransparency = 0, ZIndex = 94, Theme = { BackgroundColor3 = "FieldHover", TextColor3 = "SubText" }, Parent = holder })
                                Corner(sb, 4)
                                Lib.AddRipple(sb, 0, 0, 4)
                                sb.Activated:Connect(function() Step(def[3]) end)
                        end
                end
                return hgt
        end

        local function Rebuild()
                Drop()
                for _, c in ipairs(rlist:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
                first = nil
                local q = box.Text:lower()
                clear.Visible = q ~= ""
                if q == "" then Hide() return end
                local n, total = 0, 8
                for _, tab in ipairs(win.Tabs) do for _, sub in ipairs(tab.Subs) do for _, gb in ipairs(sub.Groupboxes) do
                        for _, e in ipairs(gb.Entries) do
                                if n < 12 and not e.static and (e.text:find(q, 1, true) or gb.Name:lower():find(q, 1, true)) then
                                        n = n + 1
                                        if not first then first = { gb, e } end
                                        local hgt = Build(n, tab, sub, gb, e)
                                        if n <= 7 then total = total + hgt + 2 end
                                end
                        end
                end end end
                if n == 0 then
                        New("TextLabel", { Text = "No matches", TextSize = 12, Size = UDim2.new(1, 0, 0, 30), ZIndex = 92, Theme = { TextColor3 = "Dim" }, Parent = rlist })
                        total = 46
                end
                local w = Clamp(math.max(field.AbsoluteSize.X, 290), 220, Lib.Overlay.AbsoluteSize.X - 8)
                local pos, hh = PlaceBelow(field, w, math.min(total, 340), 4, true)
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
end

-- ==================== E) "Motion" switches in Settings > Interface ====================
do
local origSettings = Lib.BuildSettingsTab
function Lib:BuildSettingsTab(window)
        local tab = origSettings(self, window)
        if tab and not tab._motionUI then
                tab._motionUI = true
                pcall(function()
                        local gb = tab.Subs[1]:AddLeftGroupbox("Motion", { Icon = "wind" })
                        gb:AddToggle("FxSprings", { Text = "Spring animations", Default = Lib.Fx.Springs, Callback = function(v) Lib.Fx.Springs = v end })
                        gb:AddToggle("FxRipple", { Text = "Click ripple", Default = Lib.Fx.Ripple, Callback = function(v) Lib.Fx.Ripple = v end })
                        gb:AddToggle("FxTabAnim", { Text = "Tab transitions", Default = Lib.Fx.TabAnim, Callback = function(v) Lib.Fx.TabAnim = v end })
                end)
        end
        return tab
end
end

end
-- ===================== end patch 4.3 =====================

-- ===================== Aether patch 4.4 =====================
do
local PrevClamp = Window.Clamp

-- ---------- 1) ripples off, quick flash back on buttons ----------
Lib.Fx.Ripple = false
Lib.AddRipple = function() end

local prevButton = Elements.AddButton
Elements.AddButton = function(self, a, b)
        local obj = prevButton(self, a, b)
        pcall(function()
                local btn = obj.Row:FindFirstChildWhichIsA("TextButton")
                local flash = btn and btn:FindFirstChildWhichIsA("Frame")
                if flash then flash.Visible = true end
        end)
        return obj
end

-- ---------- 2) free dragging ----------
function Lib:MakeDraggable(handle, target, opts)
        opts = opts or {}
        handle.InputBegan:Connect(function(input)
                if not IsPress(input) then return end
                if opts.Check and not opts.Check() then return end
                local isTouch = input.UserInputType == Enum.UserInputType.Touch
                local function Raw(i)
                        if isTouch then return Vector2.new(i.Position.X, i.Position.Y) end
                        return UIS:GetMouseLocation()
                end
                local start, startPos, abs0 = Raw(input), target.Position, target.AbsolutePosition
                local hBot = (handle.AbsolutePosition.Y - abs0.Y) + handle.AbsoluteSize.Y
                local threshold = isTouch and 6 or 3
                local moved, mc, ec = false, nil, nil
                mc = UIS.InputChanged:Connect(function(i)
                        if isTouch then
                                if i ~= input then return end
                        elseif i.UserInputType ~= Enum.UserInputType.MouseMovement then
                                return
                        end
                        local d = Raw(i) - start
                        if not moved then
                                if d.Magnitude < threshold then return end
                                moved = true
                                if opts.OnMove then Safe(opts.OnMove) end
                        end
                        local vp, sz = GetViewport(), target.AbsoluteSize
                        local nx = Clamp(abs0.X + d.X, 40 - sz.X, vp.X - 40)
                        local ny = Clamp(abs0.Y + d.Y, 12 - hBot, vp.Y - 24)
                        target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (nx - abs0.X), startPos.Y.Scale, startPos.Y.Offset + (ny - abs0.Y))
                end)
                ec = UIS.InputEnded:Connect(function(i)
                        local fin = isTouch and (i == input) or (not isTouch and i.UserInputType == Enum.UserInputType.MouseButton1)
                        if fin then
                                mc:Disconnect() ec:Disconnect()
                                if moved and opts.OnEnd then Safe(opts.OnEnd) end
                                if not moved and opts.OnTap then Safe(opts.OnTap) end
                        end
                end)
        end)
end

function Window:Clamp(strict)
        if self.Fullscreen then return PrevClamp(self, strict) end
        if strict and self.Dragged then strict = false end -- once you placed it, stop pulling it back
        if strict then return PrevClamp(self, true) end
        local vp, s = GetViewport(), Lib.Scale
        local sz = Vector2.new(self.W * s, self.H * s)
        local pos = self.Main.Position
        local x = Clamp(pos.X.Offset, 44 - sz.X, vp.X - 44)
        local y = Clamp(pos.Y.Offset, 10 - 46 * s, vp.Y - 24)
        if x ~= pos.X.Offset or y ~= pos.Y.Offset then
                self.Main.Position = UDim2.new(pos.X.Scale, x, pos.Y.Scale, y)
        end
end

-- ---------- 3) touch calibration ----------
local calLoaded = false
local function CalPath() return Lib.ConfigFolder .. "/touchcal.json" end
local function LoadCal()
        if calLoaded then return end
        calLoaded = true
        if not FsOk() then return end
        pcall(function()
                local p = CalPath()
                if isfile(p) then
                        local d = HttpService:JSONDecode(readfile(p))
                        if type(d) == "table" and tonumber(d.x) and tonumber(d.y) then Lib.TouchCal = Vector2.new(d.x, d.y) end
                end
        end)
end

Pointer = function(input)
        if input and input.UserInputType == Enum.UserInputType.Touch then
                LoadCal()
                local cal = Lib.TouchCal
                if cal then return Vector2.new(input.Position.X + cal.X, input.Position.Y + cal.Y) end
                return Vector2.new(input.Position.X, input.Position.Y + (Lib.TouchDY or GuiService:GetGuiInset().Y))
        end
        return UIS:GetMouseLocation() + Lib.PtrShift
end
Lib.Pointer = Pointer

function Lib:CalibrateTouch()
        local ov = New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.35, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 200, Parent = self.Overlay })
        local label = New("TextLabel", { Text = "Tap the center of the circle (1/3)", TextSize = 15, Font = Lib.FontBold, Size = UDim2.new(1, 0, 0, 24),
                AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.fromScale(0.5, 0.3), ZIndex = 201, Parent = ov })
        local target = New("Frame", { Size = UDim2.fromOffset(40, 40), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 201,
                Theme = { BackgroundColor3 = "Accent" }, Parent = ov })
        Corner(target, 20)
        local dot = New("Frame", { Size = UDim2.fromOffset(6, 6), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 202, BackgroundColor3 = WHITE, Parent = target })
        Corner(dot, 3)
        local cancel = New("TextButton", { Text = "Cancel", TextSize = 13, Size = UDim2.fromOffset(70, 28), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, 0.75),
                BackgroundTransparency = 0, ZIndex = 203, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = ov })
        Corner(cancel, 5)
        cancel.Activated:Connect(function() ov:Destroy() end)
        local spots, taps = { Vector2.new(0.5, 0.5), Vector2.new(0.3, 0.42), Vector2.new(0.7, 0.58) }, {}
        ov.InputBegan:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.Touch then return end
                local c = target.AbsolutePosition + target.AbsoluteSize / 2
                local off = Vector2.new(c.X - input.Position.X, c.Y - input.Position.Y)
                if math.abs(off.X) > 160 or math.abs(off.Y) > 160 then label.Text = "Tap the circle itself" return end
                table.insert(taps, off)
                if #taps < 3 then
                        local s = spots[#taps + 1]
                        target.Position = UDim2.fromScale(s.X, s.Y)
                        label.Position = UDim2.fromScale(0.5, s.Y - 0.12)
                        label.Text = "Again (" .. (#taps + 1) .. "/3)"
                        return
                end
                local sx, sy = 0, 0
                for _, t in ipairs(taps) do sx, sy = sx + t.X, sy + t.Y end
                Lib.TouchCal = Vector2.new(sx / #taps, sy / #taps)
                pcall(function()
                        Ensure()
                        writefile(CalPath(), HttpService:JSONEncode({ x = Lib.TouchCal.X, y = Lib.TouchCal.Y }))
                end)
                ov:Destroy()
                Lib:Notify({ Title = "Touch", Text = "Calibrated (" .. math.floor(Lib.TouchCal.Y + 0.5) .. "px offset). Saved.", Type = "success" })
        end)
end

function Lib:ResetTouchCal()
        Lib.TouchCal = nil
        calLoaded = true
        pcall(function() if isfile(CalPath()) and type(delfile) == "function" then delfile(CalPath()) end end)
        Lib:Notify({ Title = "Touch", Text = "Calibration reset to automatic.", Type = "info" })
end

-- outside-tap detection for the search popup: slack around it, and the on-screen keyboard never counts as "outside"
IsOver = function(frame, pos)
        if not frame or not frame.Parent then return false end
        local m = pos or Pointer()
        local pad = 0
        local p = Lib.Popup
        if p and p.NoCatch and (frame == p.Frame or frame == p.Ignore) then
                pad = 12
                if UIS.OnScreenKeyboardVisible then
                        local kp = UIS.OnScreenKeyboardPosition
                        if kp.Y > 0 and m.Y >= kp.Y - 60 then return true end
                end
        end
        local ap, as = frame.AbsolutePosition, frame.AbsoluteSize
        return m.X >= ap.X - pad and m.X <= ap.X + as.X + pad and m.Y >= ap.Y - pad and m.Y <= ap.Y + as.Y + pad
end
Lib.IsOver = IsOver

-- ---------- 4) search popup: touch friendly + keyboard aware ----------
do
local function SFmt(o, v)
        local i = o.Info or {}
        if i.Display then
                local ok, r = pcall(i.Display, v)
                return ok and tostring(r) or tostring(v)
        end
        local rd = i.Rounding or 0
        local s = rd > 0 and string.format("%." .. rd .. "f", v) or tostring(math.floor(v + 0.5))
        return (i.Prefix or "") .. s .. (i.Suffix or "")
end
local Reserve = { Toggle = 52, Button = 64, Segmented = 128, Dropdown = 128, Slider = 90 }

function Window:_BuildSearch(field, clear)
        local win, box = self, self.SearchBox
        local results = Sink(New("Frame", { Visible = false, BackgroundTransparency = 0, ZIndex = 90, Theme = { BackgroundColor3 = "Surface" }, Parent = Lib.Overlay }))
        Corner(results, 6) Stroke(results)
        local rlist = New("ScrollingFrame", { Size = UDim2.new(1, -8, 1, -8), Position = UDim2.fromOffset(4, 4), ZIndex = 91, ScrollBarThickness = 2, AutomaticCanvasSize = Y, Parent = results })
        List(rlist, 2)
        local first, live, total, pressAt = nil, {}, 8, 0
        local function Drop() for _, c in ipairs(live) do pcall(function() c:Disconnect() end) end live = {} end
        local function Hide() results.Visible = false rlist.ScrollingEnabled = true Drop() end

        local function Place()
                local w = Clamp(math.max(field.AbsoluteSize.X, 290), 220, Lib.Overlay.AbsoluteSize.X - 8)
                local bounds
                if UIS.OnScreenKeyboardVisible then
                        local kp = UIS.OnScreenKeyboardPosition
                        if kp.Y > 0 then
                                local o, vp = OverlayOrigin(), Lib.Overlay.AbsoluteSize
                                bounds = { 4, 4, vp.X - 4, math.max(140, kp.Y - o.Y - 6) }
                        end
                end
                local pos, hh = PlaceBelow(field, w, math.min(total, 340), 4, true, bounds)
                results.Size = UDim2.fromOffset(w, hh)
                results.Position = UDim2.fromOffset(pos.X, pos.Y)
        end

        local function Pick(gb, e)
                Hide()
                if Lib.Popup and Lib.Popup.Frame == results then Lib.Popup = nil end
                box.Text = ""
                pcall(function() box:ReleaseFocus() end)
                task.defer(function() pcall(function() win:Goto(gb, e.row) end) end)
        end

        local function Build(n, tab, sub, gb, e)
                local o = e.obj
                local kind, info = o.Type, o.Info or {}
                local can = not info.Disabled and (kind == "Toggle" or kind == "Slider" or kind == "Button" or kind == "Segmented"
                        or (kind == "Dropdown" and not info.Multi))
                local hgt = (can and kind == "Slider") and 58 or 38
                local reserve = can and Reserve[kind] or 12
                local b = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, hgt), LayoutOrder = n, ZIndex = 92, Theme = { BackgroundColor3 = "Field" }, Parent = rlist })
                Corner(b, 4)
                New("TextLabel", { Text = e.name, TextSize = 13, Size = UDim2.new(1, -(8 + reserve), 0, 16), Position = UDim2.fromOffset(8, 3), TextXAlignment = LEFT, ZIndex = 93,
                        TextTruncate = Enum.TextTruncate.AtEnd, Parent = b })
                New("TextLabel", { Text = tab.Name .. " › " .. sub.Name .. " › " .. gb.Name, TextSize = 10, Size = UDim2.new(1, -(8 + reserve), 0, 12), Position = UDim2.fromOffset(8, 20),
                        TextXAlignment = LEFT, ZIndex = 93, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Dim" }, Parent = b })
                b.MouseEnter:Connect(function() Tween(b, { BackgroundColor3 = Lib.Theme.FieldHover }, 0.06) end)
                b.MouseLeave:Connect(function() Tween(b, { BackgroundColor3 = Lib.Theme.Field }, 0.08) end)
                -- pick on RELEASE only, so scrolling / aiming with a finger never jumps away
                local fired = false
                b.InputBegan:Connect(function(i) if IsPress(i) then pressAt = os.clock() end end)
                b.Activated:Connect(function() if fired then return end fired = true Pick(gb, e) end)
                if not can then return hgt end

                if kind == "Toggle" then
                        local tw, th = 30, 16
                        local kn = th - 6
                        local sw = New("TextButton", { Text = "", Size = UDim2.fromOffset(tw + 12, 26), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -4, 0.5, 0), ZIndex = 93, Parent = b })
                        local tr = New("Frame", { Size = UDim2.fromOffset(tw, th), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 94, BackgroundColor3 = Lib.Theme.Stroke, Parent = sw })
                        Corner(tr, th / 2)
                        local kb = New("Frame", { Size = UDim2.fromOffset(kn, kn), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), ZIndex = 95, BackgroundColor3 = Lib.Theme.Dim, Parent = tr })
                        Corner(kb, kn / 2)
                        local function Paint(anim)
                                local on = o.Value == true
                                local tc = on and Lib.Theme.Accent or Lib.Theme.Stroke
                                local kp = UDim2.new(0, on and (tw - kn - 3) or 3, 0.5, 0)
                                local kc = on and Lib.KnobOn() or Lib.Theme.Dim
                                if anim then
                                        Tween(tr, { BackgroundColor3 = tc }, 0.14)
                                        Tween(kb, { Position = kp, BackgroundColor3 = kc }, 0.18, Enum.EasingStyle.Quint)
                                else
                                        tr.BackgroundColor3, kb.Position, kb.BackgroundColor3 = tc, kp, kc
                                end
                        end
                        Paint(false)
                        table.insert(live, o.Changed:Connect(function() Paint(true) end))
                        sw.InputBegan:Connect(function(i) if IsPress(i) then pressAt = os.clock() end end)
                        sw.Activated:Connect(function() o:SetValue(not o.Value) end)

                elseif kind == "Slider" then
                        local vl = New("TextLabel", { Text = "", TextSize = 12, Size = UDim2.fromOffset(78, 16), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 3),
                                TextXAlignment = RIGHT, ZIndex = 93, Parent = b })
                        local tr = New("Frame", { Size = UDim2.new(1, -16, 0, 4), Position = UDim2.new(0, 8, 1, -14), ZIndex = 93, BackgroundColor3 = Lib.Theme.Stroke, Parent = b })
                        Corner(tr, 2)
                        local fl = New("Frame", { Size = UDim2.fromScale(0, 1), ZIndex = 94, Theme = { BackgroundColor3 = "Accent" }, Parent = tr })
                        Corner(fl, 2)
                        local kn = New("Frame", { Size = UDim2.fromOffset(6, 14), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), ZIndex = 95, BackgroundColor3 = WHITE, Parent = tr })
                        Corner(kn, 2)
                        if Lib._SpringOwned then Lib._SpringOwned[fl], Lib._SpringOwned[kn] = true, true end
                        local function Paint(anim)
                                local r = Clamp(Map(o.Value, o.Min, o.Max, 0, 1), 0, 1)
                                vl.Text = SFmt(o, o.Value)
                                if anim then
                                        Tween(fl, { Size = UDim2.fromScale(r, 1) }, 0.1)
                                        Tween(kn, { Position = UDim2.fromScale(r, 0.5) }, 0.1)
                                else
                                        fl.Size, kn.Position = UDim2.fromScale(r, 1), UDim2.fromScale(r, 0.5)
                                end
                        end
                        Paint(false)
                        table.insert(live, o.Changed:Connect(function() Paint(true) end))
                        local hit = New("TextButton", { Text = "", Size = UDim2.new(1, -8, 0, 24), Position = UDim2.fromOffset(4, 32), ZIndex = 96, Parent = b })
                        hit.InputBegan:Connect(function(input)
                                if not IsPress(input) then return end
                                pressAt = os.clock()
                                local isTouch = input.UserInputType == Enum.UserInputType.Touch
                                rlist.ScrollingEnabled = false
                                local function From(pos)
                                        o:SetValue(Lerp(o.Min, o.Max, Clamp((pos.X - tr.AbsolutePosition.X) / math.max(tr.AbsoluteSize.X, 1), 0, 1)))
                                end
                                From(Pointer(input))
                                local mc, ec
                                mc = UIS.InputChanged:Connect(function(i)
                                        pressAt = os.clock()
                                        if isTouch then if i == input then From(Pointer(i)) end
                                        elseif i.UserInputType == Enum.UserInputType.MouseMovement then From(Pointer(i)) end
                                end)
                                ec = UIS.InputEnded:Connect(function(i)
                                        local fin = isTouch and (i == input) or (not isTouch and i.UserInputType == Enum.UserInputType.MouseButton1)
                                        if fin then rlist.ScrollingEnabled = true mc:Disconnect() ec:Disconnect() end
                                end)
                        end)

                elseif kind == "Button" then
                        local armed = false
                        local rb = New("TextButton", { Text = "Run", TextSize = 12, Size = UDim2.fromOffset(52, 22), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0),
                                BackgroundTransparency = 0, ZIndex = 93, Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = b })
                        Corner(rb, 4)
                        rb.InputBegan:Connect(function(i) if IsPress(i) then pressAt = os.clock() end end)
                        rb.Activated:Connect(function()
                                if info.DoubleClick and not armed then
                                        armed = true
                                        rb.Text = "Sure?"
                                        task.delay(2, function() if armed and rb.Parent then armed = false rb.Text = "Run" end end)
                                        return
                                end
                                armed = false
                                o:Click()
                                rb.Text = "Done"
                                task.delay(0.9, function() if rb.Parent then rb.Text = "Run" end end)
                        end)

                else -- Segmented / single Dropdown: < value >
                        local holder = New("Frame", { Size = UDim2.fromOffset(118, 24), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0), BackgroundTransparency = 1, ZIndex = 93, Parent = b })
                        local val = New("TextLabel", { Text = "", TextSize = 12, Size = UDim2.new(1, -44, 1, 0), Position = UDim2.fromOffset(22, 0), ZIndex = 94, TextTruncate = Enum.TextTruncate.AtEnd, Parent = holder })
                        local function Paint() val.Text = o.Value ~= nil and tostring(o.Value) or "-" end
                        Paint()
                        table.insert(live, o.Changed:Connect(Paint))
                        local function Step(d)
                                local list = o.Values or {}
                                if #list == 0 then return end
                                local i = IndexOf(list, o.Value) or (d > 0 and 0 or 1)
                                o:SetValue(list[(i - 1 + d) % #list + 1])
                        end
                        for _, def in ipairs({ { "<", 0, -1 }, { ">", 1, 1 } }) do
                                local sb = New("TextButton", { Text = def[1], TextSize = 13, Size = UDim2.fromOffset(20, 22), AnchorPoint = Vector2.new(def[2], 0.5), Position = UDim2.new(def[2], 0, 0.5, 0),
                                        BackgroundTransparency = 0, ZIndex = 94, Theme = { BackgroundColor3 = "FieldHover", TextColor3 = "SubText" }, Parent = holder })
                                Corner(sb, 4)
                                sb.InputBegan:Connect(function(i) if IsPress(i) then pressAt = os.clock() end end)
                                sb.Activated:Connect(function() Step(def[3]) end)
                        end
                end
                return hgt
        end

        local function Rebuild()
                Drop()
                for _, c in ipairs(rlist:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
                first = nil
                local q = box.Text:lower()
                clear.Visible = q ~= ""
                if q == "" then Hide() return end
                local n = 0
                total = 8
                for _, tab in ipairs(win.Tabs) do for _, sub in ipairs(tab.Subs) do for _, gb in ipairs(sub.Groupboxes) do
                        for _, e in ipairs(gb.Entries) do
                                if n < 12 and not e.static and (e.text:find(q, 1, true) or gb.Name:lower():find(q, 1, true)) then
                                        n = n + 1
                                        if not first then first = { gb, e } end
                                        local hgt = Build(n, tab, sub, gb, e)
                                        if n <= 7 then total = total + hgt + 2 end
                                end
                        end
                end end end
                if n == 0 then
                        New("TextLabel", { Text = "No matches", TextSize = 12, Size = UDim2.new(1, 0, 0, 30), ZIndex = 92, Theme = { TextColor3 = "Dim" }, Parent = rlist })
                        total = 46
                end
                Place()
                if not results.Visible then
                        results.Visible = true
                        Lib:OpenPopup(results, Hide, field, true)
                end
        end

        box:GetPropertyChangedSignal("Text"):Connect(Rebuild)
        box.FocusLost:Connect(function(enter) if enter and first then Pick(first[1], first[2]) end end)
        -- keyboard opened / closed: re-fit the popup, but never while a finger is on it (rows would move under the tap)
        local function Refit()
                task.delay(0.3, function()
                        if results.Visible and os.clock() - pressAt > 0.8 then Place() end
                end)
        end
        Lib:Connect(UIS:GetPropertyChangedSignal("OnScreenKeyboardVisible"), Refit)
        Lib:Connect(UIS:GetPropertyChangedSignal("OnScreenKeyboardSize"), Refit)
end
end

-- ---------- 5) chat: delete / hide messages ----------
function Chat:DeleteMessage(msg)
        Lib:Dialog({ Title = "Delete message", Text = "Delete this message for everyone?",
                Buttons = { { Text = "Cancel" }, { Text = "Delete", Primary = true, Callback = function()
                        task.spawn(function()
                                local d = Decode(self:_Do("/delete", nil, "POST", HttpService:JSONEncode({ id = msg.id })))
                                if d and d.ok then
                                        self:_Remove(msg.id)
                                        self:_PollOnce()
                                else
                                        Lib:Notify({ Title = "Chat", Text = (d and d.error) or "The server refused it (does your worker have /delete?). You can still use Hide for me.", Type = "error", Duration = 6 })
                                end
                        end)
                end } } })
end

function Chat:MessageMenu(msg)
        local items = {}
        local name = tostring(msg.display ~= "" and msg.display or msg.name or "?")
        local mine = tostring(msg.uid) == tostring(LocalPlayer.UserId)
        table.insert(items, { Text = "View profile", Callback = function() self:ShowProfile(msg) end })
        if msg.id then table.insert(items, { Text = "Reply", Callback = function() self:SetReply({ id = msg.id, name = name, text = tostring(msg.text ~= "" and msg.text or (msg.cfg and "[config]" or "[image]")):sub(1, 70) }) end }) end
        if mine and msg.id then
                table.insert(items, { Text = "Edit message", Callback = function() self:EditMessage(msg) end })
                table.insert(items, { Text = "Delete message", Danger = true, Callback = function() self:DeleteMessage(msg) end })
        end
        table.insert(items, { Text = "Mention", Callback = function() self:Prefill(self.Input.Text .. "@" .. tostring(msg.name) .. " ") end })
        if type(setclipboard) == "function" and tostring(msg.text or "") ~= "" then table.insert(items, { Text = "Copy text", Callback = function() setclipboard(tostring(msg.text)) end }) end
        local link = tostring(msg.text or ""):match("https?://[^%s<>\"]+")
        if link and type(setclipboard) == "function" then
                link = link:gsub("[%.,;:!%?%)%]]+$", "")
                table.insert(items, { Text = "Copy link", Callback = function() Copy(link, "Link copied") end })
        end
        if msg.id then table.insert(items, { Text = "Hide for me", Callback = function() self:_Remove(msg.id) end }) end
        if not mine and msg.uid then
                local blocked = Lib:IsBlocked(msg.uid)
                table.insert(items, { Text = blocked and "Unblock user" or "Block user", Danger = not blocked, Callback = function()
                        if blocked then Lib:Unblock(msg.uid) else Lib:Block(msg.uid, name) end
                end })
        end
        self:Menu(items, self.LastPtr)
end

-- ---------- 6) share a config to any channel / DM / group ----------
function Chat:ShareConfig(name, data, ch)
        if self.Blocked or not self.Request then return end
        if os.clock() - self.LastSend < 0.8 then self:System("Slow down a little.") return end
        local json = HttpService:JSONEncode(data)
        if #json > 60000 then Lib:Notify({ Title = "Config", Text = "That config is too big to share.", Type = "error" }) return end
        local room = (ch and ch.room) or self.Room
        local here = room == self.Room
        local where = ch and ((ch.kind == "dm" and "@" or (ch.kind == "grp" and "«" or "#")) .. tostring(ch.name)) or "this chat"
        self.LastSend = os.clock()
        local caption = here and Trim(self.Input.Text) or ""
        local replyId = (here and self.ReplyTo) and self.ReplyTo.id or nil
        Lib:Notify({ Title = "Config", Text = "Sharing to " .. where .. "...", Type = "info", Duration = 2 })
        task.spawn(function()
                local d = Decode(self:_Do("/cfgup", nil, "POST", HttpService:JSONEncode({ name = name, data = json }), room))
                if not (d and d.ok and d.id) then Lib:Notify({ Title = "Config", Text = (d and d.error) or "Couldn't share the config.", Type = "error" }) return end
                local r = Decode(self:_Do("/send", nil, "POST", HttpService:JSONEncode({ text = caption:sub(1, self.Config.MaxLength), replyTo = replyId, cfg = d.id }), room))
                if not (r and r.ok) then Lib:Notify({ Title = "Config", Text = (r and r.error) or "Couldn't post the config.", Type = "error" }) return end
                if here then
                        self.Input.Text = ""
                        self:SetReply(nil)
                        self.Stick = true
                        self:_PollOnce()
                end
                Lib:Notify({ Title = "Config", Text = "Shared «" .. name .. "» to " .. where .. ".", Type = "success", Duration = 3 })
        end)
end

function Chat:ChooseShareTarget(cb)
        local items = {}
        local function Add(i, ch, mark, label)
                table.insert(items, { Text = (i == self.ChIndex and "• " or "   ") .. mark .. Short(label, 18), Callback = function() cb(ch) end })
        end
        for i, ch in ipairs(self.Channels) do if not ch.kind then Add(i, ch, "#", tostring(ch.name)) end end
        local hasDM, hasGrp = false, false
        for _, ch in ipairs(self.Channels) do
                if ch.kind == "dm" then hasDM = true elseif ch.kind == "grp" then hasGrp = true end
        end
        if hasDM then
                table.insert(items, { Header = true, Text = "DIRECT MESSAGES" })
                for i, ch in ipairs(self.Channels) do if ch.kind == "dm" then Add(i, ch, "@", tostring(ch.name)) end end
        end
        if hasGrp then
                table.insert(items, { Header = true, Text = "GROUP CHATS" })
                for i, ch in ipairs(self.Channels) do if ch.kind == "grp" then Add(i, ch, "«", tostring(ch.name)) end end
        end
        table.insert(items, { Header = true, Text = "OTHER" })
        table.insert(items, { Text = "DM someone else...", Callback = function()
                self:PickUser(function(u)
                        self:OpenDM(u.uid, u.name, u.display)
                        local idx = self:_RoomIndex(self:DMRoom(u.uid))
                        if idx then cb(self.Channels[idx]) end
                end, "Send config to who?")
        end })
        local anchor
        if self.PanelObj._shown and self.ChBtn and self.ChBtn.Parent then
                anchor = self.ChBtn
        else
                local vp = GetViewport()
                anchor = Vector2.new(vp.X / 2 - 95, vp.Y / 4)
        end
        self:Menu(items, anchor)
end

function Lib:ShareConfigToChat(saved)
        local chat = self.ChatObj
        if not chat or not chat.Alive then self:Notify({ Title = "Config", Text = "Open the chat first.", Type = "warn" }) return end
        local data, name
        if saved and saved ~= "" then
                name = Sanitize(saved)
                local ok, raw = pcall(function() return readfile(CPath(name)) end)
                local dec, d = false, nil
                if ok then dec, d = pcall(HttpService.JSONDecode, HttpService, raw) end
                if not (dec and type(d) == "table") then self:Notify({ Title = "Config", Text = "Couldn't read that config.", Type = "error" }) return end
                data = d
        else
                data = self:SerializeConfig()
                local o = self.Options.__ConfigName
                name = Sanitize(o and o.Value or "")
                if name == "" then name = "Shared config" end
        end
        chat:ChooseShareTarget(function(ch) chat:ShareConfig(name, data, ch) end)
end

-- ---------- 7) settings: hide ripple switch, add Touch group ----------
local PrevSettings = Lib.BuildSettingsTab
function Lib:BuildSettingsTab(window)
        local tab = PrevSettings(self, window)
        if tab and not tab._p44 then
                tab._p44 = true
                pcall(function() local t = Lib.Toggles.FxRipple if t then t:SetVisible(false) end end)
                pcall(function()
                        local gb = tab.Subs[1]:AddLeftGroupbox("Touch", { Icon = "pointer" })
                        gb:AddLabel("If your finger and the color picker, sliders or search results don't line up, calibrate. Tap the circle 3 times.")
                        gb:AddButton({ Text = "Calibrate touch", Func = function() Lib:CalibrateTouch() end })
                        gb:AddButton({ Text = "Reset calibration", Func = function() Lib:ResetTouchCal() end })
                end)
        end
        return tab
end

end
-- ===================== end patch 4.4 =====================

-- ===================== Patch 4.5 =====================
do
local P = {}

-- ---------- 1) branding ----------
Lib.Version = "4.5.0"
Lib.ChannelsKey = Lib.ChannelsKey or "AetherChannels"

P.CreateWindow = Lib.CreateWindow
function Lib:CreateWindow(cfg)
        cfg = cfg or {}
        if cfg.Version then self.Version = tostring(cfg.Version) end
        if cfg.ChatUrl ~= nil then self.DefaultChatUrl = cfg.ChatUrl or nil end
        if cfg.ChannelsKey then self.ChannelsKey = cfg.ChannelsKey end
        if cfg.EnvKey and getgenv then
                pcall(function()
                        local env = getgenv()
                        local old = env[cfg.EnvKey]
                        if type(old) == "table" and old ~= self and old.Unload then pcall(function() old:Unload() end) end
                        env[cfg.EnvKey] = self
                        if env.__AetherUI == self then env.__AetherUI = nil end
                end)
        end
        return P.CreateWindow(self, cfg)
end

P.CreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
        cfg = cfg or {}
        if cfg.Channels == nil and getgenv then
                local env = getgenv()
                local keys = { self.ChannelsKey, (tostring(self.Name):gsub("%W", "")) .. "Channels" }
                for _, k in ipairs(keys) do
                        if k and env[k] ~= nil then cfg.Channels = env[k] break end
                end
        end
        return P.CreateChat(self, cfg)
end

-- ---------- 2) automatic touch offset ----------
-- Thin invisible bands cover the screen. Whichever band a finger lands on tells us the exact
-- offset for that finger. The median of the last taps is kept, saved, and reused next session.
if UIS.TouchEnabled then
        pcall(function() if Lib.TouchProbeGui then Lib.TouchProbeGui:Destroy() Lib.TouchProbeGui = nil end end)
        Lib.TouchCal = nil
        local perInput = setmetatable({}, { __mode = "k" })
        local hist, bands, lastH, saved, loaded = {}, {}, 0, nil, false
        local BH = 4
        local gui = MakeGui(997)
        P.TouchGui = gui
        local function Path() return Lib.ConfigFolder .. "/touchauto.json" end
        local function Learn(off, input)
                if math.abs(off) > 150 then return end
                perInput[input] = off
                table.insert(hist, off)
                if #hist > 9 then table.remove(hist, 1) end
                local s = table.clone(hist)
                table.sort(s)
                local med = s[math.ceil(#s / 2)]
                Lib.TouchDY = med
                if #hist >= 3 and (saved == nil or math.abs(saved - med) > 1) and FsOk() then
                        saved = med
                        pcall(function()
                                if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                                writefile(Path(), HttpService:JSONEncode({ y = med }))
                        end)
                end
        end
        local function Build()
                local h = gui.AbsoluteSize.Y
                if h <= 0 or h == lastH then return end
                lastH = h
                for _, b in ipairs(bands) do b:Destroy() end
                bands = {}
                for i = 0, math.ceil(h / BH) do
                        local f = Instance.new("Frame")
                        f.BackgroundTransparency, f.BorderSizePixel, f.Active = 1, 0, false
                        f.Size, f.Position = UDim2.new(1, 0, 0, BH), UDim2.fromOffset(0, i * BH)
                        f.Parent = gui
                        f.InputBegan:Connect(function(input)
                                if input.UserInputType ~= Enum.UserInputType.Touch then return end
                                Learn((f.AbsolutePosition.Y + BH / 2) - input.Position.Y, input)
                        end)
                        bands[#bands + 1] = f
                end
        end
        Build()
        Lib:Connect(gui:GetPropertyChangedSignal("AbsoluteSize"), function() task.defer(Build) end)

        Pointer = function(input)
                if input and input.UserInputType == Enum.UserInputType.Touch then
                        if not loaded then
                                loaded = true
                                if not Lib.TouchDY and FsOk() then
                                        pcall(function()
                                                if isfile(Path()) then
                                                        local d = HttpService:JSONDecode(readfile(Path()))
                                                        if type(d) == "table" and tonumber(d.y) then Lib.TouchDY, saved = tonumber(d.y), tonumber(d.y) end
                                                end
                                        end)
                                end
                        end
                        local off = perInput[input] or Lib.TouchDY or GuiService:GetGuiInset().Y
                        return Vector2.new(input.Position.X, input.Position.Y + off)
                end
                return UIS:GetMouseLocation() + Lib.PtrShift
        end
        Lib.Pointer = Pointer
end

function Lib:CalibrateTouch() self:Notify({ Title = "Touch", Text = "Touch is calibrated automatically.", Type = "info" }) end
function Lib:ResetTouchCal() self.TouchCal, self.TouchDY = nil, nil end

P.Unload = Lib.Unload
function Lib:Unload()
        pcall(function() if P.TouchGui then P.TouchGui:Destroy() end end)
        return P.Unload(self)
end

-- ---------- 3) color picker: HSV / RGB sliders, copy hex, presets ----------
local Presets = { "FFFFFF", "C8C8C8", "808080", "000000", "EF4444", "F59E0B", "10B981", "3B82F6", "8B5CF6", "EC4899" }

function Lib:_ExtendPicker(picker, popup, swStroke)
        local baseH = 8 + 110 + 8 + 12 + 8 + (picker.Transparency ~= nil and 20 or 0) + 24 + 10
        local y0 = baseH - 4
        local totalH = baseH + 116
        local mode, open, lastKey = "HSV", false, nil
        local function Btn(text, x, w, right)
                local b = New("TextButton", { Text = text, TextSize = 11, Size = UDim2.fromOffset(w, 20), AnchorPoint = Vector2.new(right and 1 or 0, 0),
                        Position = right and UDim2.new(1, -x, 0, y0) or UDim2.fromOffset(x, y0), BackgroundTransparency = 0,
                        Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = popup })
                Corner(b, 4)
                return b
        end
        local hsvB, rgbB, copyB = Btn("HSV", 8, 44), Btn("RGB", 56, 44), Btn("Copy hex", 8, 62, true)
        local rows = {}
        local function Refresh(force)
                local h, s, v = picker.Hue, picker.Sat, picker.Vib
                local key = mode .. math.floor(h * 1000) .. ":" .. math.floor(s * 1000) .. ":" .. math.floor(v * 1000)
                if not force and key == lastKey then return end
                lastKey = key
                local c = picker.Value
                local names, vals, grads, txt
                if mode == "HSV" then
                        names, vals = { "H", "S", "V" }, { h, s, v }
                        grads = { Rainbow, ColorSequence.new(Color3.fromHSV(h, 0, v), Color3.fromHSV(h, 1, v)), ColorSequence.new(Color3.fromHSV(h, s, 0), Color3.fromHSV(h, s, 1)) }
                        txt = { math.floor(h * 360 + 0.5) .. "°", math.floor(s * 100 + 0.5) .. "%", math.floor(v * 100 + 0.5) .. "%" }
                else
                        names, vals = { "R", "G", "B" }, { c.R, c.G, c.B }
                        grads = { ColorSequence.new(Color3.new(0, c.G, c.B), Color3.new(1, c.G, c.B)), ColorSequence.new(Color3.new(c.R, 0, c.B), Color3.new(c.R, 1, c.B)),
                                ColorSequence.new(Color3.new(c.R, c.G, 0), Color3.new(c.R, c.G, 1)) }
                        txt = { math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5) }
                end
                for i, r in ipairs(rows) do
                        r.lab.Text, r.grad.Color, r.knob.Position, r.val.Text = names[i], grads[i], UDim2.fromScale(Clamp(vals[i], 0, 1), 0.5), tostring(txt[i])
                end
                hsvB.BackgroundColor3 = mode == "HSV" and Lib.Theme.Accent or Lib.Theme.Field
                hsvB.TextColor3 = mode == "HSV" and Lib.KnobOn() or Lib.Theme.SubText
                rgbB.BackgroundColor3 = mode == "RGB" and Lib.Theme.Accent or Lib.Theme.Field
                rgbB.TextColor3 = mode == "RGB" and Lib.KnobOn() or Lib.Theme.SubText
        end
        local function Apply(i, x)
                if mode == "HSV" then
                        if i == 1 then
                                picker.Hue = x
                                if picker.RainbowOn then picker:SetRainbow(false) end
                        elseif i == 2 then picker.Sat = x else picker.Vib = x end
                else
                        local c = picker.Value
                        local r, g, b = c.R, c.G, c.B
                        if i == 1 then r = x elseif i == 2 then g = x else b = x end
                        local h, s, v = Color3.new(r, g, b):ToHSV()
                        if s > 0.001 and v > 0.001 then picker.Hue = h end
                        picker.Sat, picker.Vib = s, v
                        if picker.RainbowOn then picker:SetRainbow(false) end
                end
                picker:_Display()
                picker:_Fire(picker.Transparency)
                Refresh(true)
        end
        for i = 1, 3 do
                local y = y0 + 26 + (i - 1) * 20
                local lab = New("TextLabel", { Text = "", TextSize = 11, Size = UDim2.fromOffset(14, 18), Position = UDim2.fromOffset(8, y), Theme = { TextColor3 = "SubText" }, Parent = popup })
                local track = New("Frame", { Size = UDim2.new(1, -(26 + 54), 0, 10), Position = UDim2.fromOffset(26, y + 4), BackgroundColor3 = WHITE, Parent = popup })
                Corner(track, 3)
                local grad = New("UIGradient", { Parent = track })
                local knob = New("Frame", { Size = UDim2.fromOffset(4, 16), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), BackgroundColor3 = WHITE, ZIndex = 3, Parent = track })
                Corner(knob, 2) Stroke(knob, "Bg", 1)
                local val = New("TextLabel", { Text = "", TextSize = 11, Size = UDim2.fromOffset(44, 18), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, y), TextXAlignment = RIGHT, Parent = popup })
                local hit = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, 18), Position = UDim2.fromOffset(0, -4), ZIndex = 5, Parent = track })
                DragArea(hit, function(x) Apply(i, x) end)
                rows[i] = { lab = lab, grad = grad, knob = knob, val = val }
        end
        local strip = New("Frame", { Size = UDim2.new(1, -16, 0, 18), Position = UDim2.fromOffset(8, y0 + 26 + 60 + 6), BackgroundTransparency = 1, Parent = popup })
        List(strip, 4, Enum.FillDirection.Horizontal)
        for i, hex in ipairs(Presets) do
                local col = FromHex(hex)
                local b = New("TextButton", { Text = "", Size = UDim2.new(0.1, -3.6, 1, 0), LayoutOrder = i, BackgroundTransparency = 0, BackgroundColor3 = col, Parent = strip })
                Corner(b, 4) Stroke(b, "Stroke", 1, 0.3)
                b.Activated:Connect(function()
                        if picker.RainbowOn then picker:SetRainbow(false) end
                        picker:SetValue(col)
                        Refresh(true)
                end)
        end
        hsvB.Activated:Connect(function() mode = "HSV" Refresh(true) end)
        rgbB.Activated:Connect(function() mode = "RGB" Refresh(true) end)
        copyB.Activated:Connect(function() Copy("#" .. ToHex(picker.Value), "Hex copied") end)
        Refresh(true)
        Lib:Connect(RunService.RenderStepped, function()
                if open and popup.Parent and popup.Visible then Refresh(false) end
        end)
        -- the swatch always calls picker:Open(), so Open toggles
        function picker:Open()
                if open then return self:Close() end
                open = true
                popup.Visible = true
                Refresh(true)
                Tween(popup, { Size = UDim2.new(1, 0, 0, totalH) }, 0.18, Enum.EasingStyle.Quint)
                if swStroke then swStroke.Color = Lib.Theme.Accent end
        end
        function picker:Close()
                if not open then return end
                open = false
                local t = Tween(popup, { Size = UDim2.new(1, 0, 0, 0) }, 0.14, Enum.EasingStyle.Quint)
                t.Completed:Connect(function() if not open then popup.Visible = false end end)
                if swStroke then swStroke.Color = Lib.Theme.Stroke end
        end
end

P.CreateColorPicker = Lib._CreateColorPicker
function Lib:_CreateColorPicker(owner, idx, info)
        local parentF = owner.Row.Parent
        local before, hBefore = {}, {}
        for _, c in ipairs(parentF:GetChildren()) do before[c] = true end
        if owner.AddonFrame then for _, c in ipairs(owner.AddonFrame:GetChildren()) do hBefore[c] = true end end
        local picker = P.CreateColorPicker(self, owner, idx, info)
        local popup, swStroke
        for _, c in ipairs(parentF:GetChildren()) do
                if not before[c] and c.Name == "Inline" then popup = c end
        end
        if owner.AddonFrame then
                for _, c in ipairs(owner.AddonFrame:GetChildren()) do
                        if not hBefore[c] and c:IsA("TextButton") then swStroke = c:FindFirstChildOfClass("UIStroke") end
                end
        end
        if popup then
                local ok, err = pcall(Lib._ExtendPicker, Lib, picker, popup, swStroke)
                if not ok then warn("[Aether] color picker: " .. tostring(err)) end
        end
        return picker
end

-- ---------- 4) search palette: nothing underneath can react ----------
P.BuildSearch = Window._BuildSearch
function Window:_BuildSearch(field, clear)
        local before = {}
        for _, c in ipairs(Lib.Overlay:GetChildren()) do before[c] = true end
        P.BuildSearch(self, field, clear)
        local results
        for _, c in ipairs(Lib.Overlay:GetChildren()) do
                if not before[c] and c:IsA("Frame") then results = c end
        end
        if not results then return end
        local box = self.SearchBox
        local blocker = New("TextButton", { Name = "SearchBlocker", Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 89,
                Active = true, Visible = false, Parent = Lib.Overlay })
        blocker.InputBegan:Connect(function(i)
                if IsPress(i) and IsOver(field, Pointer(i)) then
                        task.defer(function() pcall(function() box:CaptureFocus() end) end)
                end
        end)
        results:GetPropertyChangedSignal("Visible"):Connect(function() blocker.Visible = results.Visible end)
end

-- ---------- 5) fonts ----------
Lib.FontValues, Lib.FontSet = { "Default" }, {}
do
        local names = {}
        for _, f in ipairs(Enum.Font:GetEnumItems()) do
                if f.Name ~= "Unknown" then table.insert(names, f.Name) Lib.FontSet[f.Name] = true end
        end
        table.sort(names)
        for _, n in ipairs(names) do table.insert(Lib.FontValues, n) end
end

function Lib:EncodeStyle(force)
        local s = self.NameStyle
        if not (s.On or force) then return nil end
        local out = "c=" .. ToHex(s.C1)
        if s.Grad then out = out .. ";g=" .. ToHex(s.C2) end
        if s.Font ~= "Default" and Lib.FontSet[s.Font] then out = out .. ";f=" .. s.Font end
        return out
end

function Lib:ParseStyle(s)
        if type(s) ~= "string" or #s > 60 then return nil end
        local st = {}
        local c, g, f = s:match("c=(%x%x%x%x%x%x)"), s:match("g=(%x%x%x%x%x%x)"), s:match("f=(%w+)")
        if c then st.c1 = FromHex(c) end
        if g then st.c2 = FromHex(g) end
        if f and Lib.FontSet[f] then st.font = f end
        if not (st.c1 or st.font) then return nil end
        return st
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
                if d.font == "Default" or Lib.FontSet[d.font] then s.Font = d.font end
        end)
end

P.BaseFont, P.BaseBold = Lib.Font, Lib.FontBold
function Lib:SetUIFont(name)
        local f, fb
        if name == nil or name == "Default" then
                f, fb = P.BaseFont, P.BaseBold
        else
                local ok, v = pcall(function() return Enum.Font[name] end)
                if not (ok and v) then return false end
                local okb, vb = pcall(function() return Enum.Font[name .. "Bold"] end)
                f, fb = v, (okb and vb) or v
        end
        local old, oldB = self.Font, self.FontBold
        self.Font, self.FontBold = f, fb
        for _, root in ipairs({ self.Gui, self.Overlay }) do
                for _, d in ipairs(root:GetDescendants()) do
                        if TextClasses[d.ClassName] then
                                if d.Font == old then d.Font = f elseif d.Font == oldB then d.Font = fb end
                        end
                end
        end
        return true
end

function Lib:SaveUIFont(name)
        if not FsOk() then return end
        pcall(function()
                if not isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end
                writefile(self.ConfigFolder .. "/uifont.txt", tostring(name or "Default"))
        end)
end

function Lib:LoadUIFont()
        if not FsOk() then return "Default" end
        local ok, c = pcall(function() local p = self.ConfigFolder .. "/uifont.txt" if isfile(p) then return readfile(p) end end)
        c = ok and c and Trim(c) or "Default"
        if c ~= "Default" and not Lib.FontSet[c] then c = "Default" end
        return c
end

-- ---------- 6) settings UI ----------
P.BuildSettingsTab = Lib.BuildSettingsTab
function Lib:BuildSettingsTab(window)
        local tab = P.BuildSettingsTab(self, window)
        if tab and not tab._p45 then
                tab._p45 = true
                pcall(function()
                        for _, gb in ipairs(tab.Subs[1].Groupboxes) do
                                if gb.Name == "Touch" then gb:SetVisible(false) gb.Entries = {} end
                        end
                end)
                pcall(function() local o = Lib.Options.__NameFont if o then o:SetValues(Lib.FontValues) end end)
                pcall(function()
                        local saved = Lib:LoadUIFont()
                        local gb = tab.Subs[1]:AddRightGroupbox("Typography", { Icon = "type", Collapsible = true })
                        gb:AddDropdown("__UIFont", { Text = "UI font", Values = Lib.FontValues, Default = saved, IgnoreConfig = true,
                                Callback = function(v) Lib:SetUIFont(v or "Default") Lib:SaveUIFont(v) end })
                        if saved ~= "Default" then task.defer(function() Lib:SetUIFont(saved) end) end
                end)
        end
        return tab
end

end
-- ===================== end patch 4.5 =====================

-- ===================== Patch 4.6 =====================
do
local P = {}

-- 1) springs, ripple and tab transitions off
Lib.Fx = Lib.Fx or {}
Lib.Fx.Springs, Lib.Fx.Ripple, Lib.Fx.TabAnim = false, false, false

-- 2) tab / sub-tab content appears instantly (no slide-in)
local PrevTween = Tween
Tween = function(inst, props, ...)
        if typeof(inst) == "Instance" and type(props) == "table" and props.Position ~= nil then
                local n = inst.Name
                if n:sub(1, 5) == "Page_" or n:sub(1, 4) == "Sub_" then
                        inst.Position = props.Position
                        return { Completed = Signal.new(), Cancel = function() end, Play = function() end, Pause = function() end }
                end
        end
        return PrevTween(inst, props, ...)
end
Lib.Tween = Tween

-- 3) settings: no target picker for end users, no Motion group
P.BuildSettingsTab = Lib.BuildSettingsTab
function Lib:BuildSettingsTab(window)
        local tab = P.BuildSettingsTab(self, window)
        if tab and not tab._p46 then
                tab._p46 = true
                pcall(function()
                        local target = Lib.Options.__PreviewTarget
                        for _, sub in ipairs(tab.Subs) do
                                for _, gb in ipairs(sub.Groupboxes) do
                                        if gb.Name == "Motion" then
                                                gb:SetVisible(false)
                                                gb.Entries = {}
                                        elseif gb.Name == "Preview" then
                                                if target and target.Row then target.Row.Visible = false end
                                                for _, row in ipairs(gb.Container:GetChildren()) do
                                                        if row:IsA("Frame") then
                                                                for _, b in ipairs(row:GetChildren()) do
                                                                        if b:IsA("TextButton") and (b.Text == "Set target" or b.Text == "Back to me") then
                                                                                row.Visible = false
                                                                                break
                                                                        end
                                                                end
                                                        end
                                                end
                                                for i = #gb.Entries, 1, -1 do
                                                        if gb.Entries[i].obj == target then table.remove(gb.Entries, i) end
                                                end
                                        end
                                end
                        end
                        for _, k in ipairs({ "FxSprings", "FxRipple", "FxTabAnim" }) do
                                Lib.Options[k], Lib.Toggles[k] = nil, nil
                        end
                end)
        end
        return tab
end

-- 4) sidebar tab list: hide the scrollbar
P.CreateWindow = Lib.CreateWindow
function Lib:CreateWindow(cfg)
        local win = P.CreateWindow(self, cfg)
        pcall(function()
                local tl = win.TabList
                if tl and tl:IsA("ScrollingFrame") then
                        tl.ScrollBarThickness = 0
                        tl.ScrollBarImageTransparency = 1
                        local pad = tl:FindFirstChildOfClass("UIPadding")
                        if pad then pad.PaddingRight = UDim.new(0, 0) end
                end
        end)
        return win
end

end
-- ===================== end patch 4.6 =====================

-- ===================== Aether patch 4.7 =====================
-- Paste this whole block right above the final `return Lib` (after patch 4.6).
-- Adds:
--   * emoji reactions (PC: hover bar + right-click menu, mobile: long-press sheet, double-tap to react)
--   * DM read receipts ("Read 12:34"), on by default, DMs only, toggle in Settings > Interface > Chat
--   * Auto correct (LanguageTool through your worker), toggle in Settings > Interface > Chat
--   * multi-select invites for group chats
--   * smarter Lucide lookup (renamed icons, second icon source, letter fallback instead of a dot)
-- Needs the v2.3 worker (/react, /spell, read receipts, /group/invite with uids).
do
local P = {}
Lib.Version = "4.7.0"

-- ==================== 0) CHAT PREFS (saved to <Folder>/chatprefs.json) ====================
Lib.ChatPrefs = { ReadReceipts = true, AutoCorrect = true, DoubleTap = "👍", Recent = {} }
Lib.QuickEmoji = { "👍", "❤️", "😂", "💀", "🔥", "😮" }

do
        local loaded, tick = false, 0
        local function Path() return Lib.ConfigFolder .. "/chatprefs.json" end

        function Lib:LoadChatPrefs()
                if loaded then return self.ChatPrefs end
                loaded = true
                if FsOk() then
                        pcall(function()
                                local p = Path()
                                if not isfile(p) then return end
                                local d = HttpService:JSONDecode(readfile(p))
                                if type(d) ~= "table" then return end
                                local c = self.ChatPrefs
                                if type(d.rr) == "boolean" then c.ReadReceipts = d.rr end
                                if type(d.ac) == "boolean" then c.AutoCorrect = d.ac end
                                if type(d.dbl) == "string" and #d.dbl > 0 and #d.dbl <= 16 then c.DoubleTap = d.dbl end
                                if type(d.recent) == "table" then
                                        for _, e in ipairs(d.recent) do
                                                if type(e) == "string" and #c.Recent < 16 then table.insert(c.Recent, e) end
                                        end
                                end
                        end)
                end
                return self.ChatPrefs
        end

        function Lib:SaveChatPrefs()
                if not FsOk() then return end
                tick = tick + 1
                local t = tick
                task.delay(0.6, function()
                        if t ~= tick then return end
                        pcall(function()
                                if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                                local c = Lib.ChatPrefs
                                writefile(Path(), HttpService:JSONEncode({ rr = c.ReadReceipts, ac = c.AutoCorrect, dbl = c.DoubleTap, recent = c.Recent }))
                        end)
                end)
        end

        function Lib:PushRecentEmoji(e)
                local r = self.ChatPrefs.Recent
                for i = #r, 1, -1 do if r[i] == e then table.remove(r, i) end end
                table.insert(r, 1, e)
                while #r > 16 do table.remove(r) end
                self:SaveChatPrefs()
        end
end

-- ==================== 1) ICONS: fewer dots ====================
-- Lookup order: your CustomIcons / aliases -> the icon pack (name, lowercase, renamed variants) -> a second pack
-- loaded in the background -> a letter/glyph instead of a dot. Icons that were dots get fixed as soon as the pack loads.
do
        local Alias = {
                ["triangle-alert"] = { "alert-triangle" }, ["alert-triangle"] = { "triangle-alert" },
                ["circle-alert"] = { "alert-circle" }, ["alert-circle"] = { "circle-alert" },
                ["octagon-alert"] = { "alert-octagon" }, ["alert-octagon"] = { "octagon-alert" },
                ["circle-check"] = { "check-circle" }, ["check-circle"] = { "circle-check" },
                ["circle-x"] = { "x-circle" }, ["x-circle"] = { "circle-x" },
                ["list-filter"] = { "filter" }, ["filter"] = { "list-filter" },
                ["users-round"] = { "users" }, ["user-round"] = { "user" },
                ["gamepad-2"] = { "gamepad" }, ["gamepad"] = { "gamepad-2" },
                ["move-diagonal-2"] = { "move-diagonal", "maximize-2" },
                ["rotate-3d"] = { "rotate-3-d", "rotate-cw", "refresh-cw" },
                ["layout-panel-left"] = { "panel-left", "sidebar", "layout-sidebar" },
                ["ellipsis"] = { "more-horizontal" }, ["more-horizontal"] = { "ellipsis" },
                ["ellipsis-vertical"] = { "more-vertical" }, ["more-vertical"] = { "ellipsis-vertical" },
                ["trash-2"] = { "trash" }, ["trash"] = { "trash-2" },
                ["pencil"] = { "edit-2", "pen" }, ["edit"] = { "square-pen", "pencil" }, ["square-pen"] = { "edit", "pencil" },
                ["terminal"] = { "square-terminal", "terminal-square" },
                ["smile-plus"] = { "smile", "laugh" },
                ["scan-face"] = { "scan", "user" },
                ["focus"] = { "crosshair", "target" },
                ["reply"] = { "corner-up-left", "undo-2" },
                ["copy"] = { "clipboard-copy", "clipboard" },
                ["eye-off"] = { "eye-closed" },
                ["ban"] = { "slash", "circle-slash" },
                ["at-sign"] = { "at" },
                ["link"] = { "link-2", "external-link" },
                ["send"] = { "send-horizontal" },
                ["refresh-cw"] = { "refresh-ccw", "rotate-cw" },
                ["settings"] = { "settings-2", "cog" },
                ["megaphone"] = { "volume-2" },
        }
        local Glyph = { x = "×", check = "✓", plus = "+", minus = "-", ["chevron-left"] = "<", ["chevron-right"] = ">", ["chevron-down"] = "v", ["chevron-up"] = "^",
                send = ">", search = "?", bell = "!", pin = "*", link = "o", reply = "<", ["at-sign"] = "@", ["smile-plus"] = "+", ellipsis = "...", ["message-square"] = "#" }
        local Hit, Extra, Pending = {}, {}, {}
        local loading, loadedExtra = false, false
        Lib.IconAlias = Lib.IconAlias or {}

        local function Query(mod, nm)
                local ok, r = pcall(function()
                        local fn = mod.Icon or mod.GetIcon or mod.icon
                        return fn(nm)
                end)
                if not (ok and r) then return nil end
                if type(r) == "string" then return { Image = r } end
                if type(r) == "table" then
                        local img = r[1] or r.Image or r.Id or r.id
                        local rect = type(r[2]) == "table" and r[2] or r
                        local pos = rect.ImageRectPosition or rect.ImageRectOffset or rect.Position
                        local sz = rect.ImageRectSize or rect.Size
                        if img then return { Image = img, Pos = pos, Size = sz } end
                end
                return nil
        end

        local function Variants(name)
                local out, seen = {}, {}
                local function Add(n) if n and n ~= "" and not seen[n] then seen[n] = true out[#out + 1] = n end end
                Add(Lib.IconAlias[name])
                Add(name)
                local l = (name:lower():gsub("_", "-"))
                l = (l:gsub("^lucide[%-:]", ""))
                Add(l)
                Add(Lib.IconAlias[l])
                for _, a in ipairs(Alias[l] or {}) do Add(a) end
                Add((l:gsub("%-%d+$", "")))
                return out
        end

        local function Refresh()
                for i = #Pending, 1, -1 do
                        local p = Pending[i]
                        local img = p[1]
                        if not img.Parent then
                                table.remove(Pending, i)
                        else
                                local r = ResolveIcon(p[2])
                                if r then
                                        img.Image = ToAsset(r.Image)
                                        if r.Pos then img.ImageRectOffset = r.Pos end
                                        if r.Size then img.ImageRectSize = r.Size end
                                        local t = img:FindFirstChildOfClass("TextLabel")
                                        if t then t:Destroy() end
                                        table.remove(Pending, i)
                                end
                        end
                end
        end

        local function LoadExtra()
                if loadedExtra or loading or Lib.Unloaded then return end
                loading = true
                task.spawn(function()
                        for _, src in ipairs(Lib.IconSources) do
                                local body = Fetch(src)
                                local fn = body and loadstring(body)
                                if fn then
                                        local ok, mod = pcall(fn)
                                        if ok and type(mod) == "table" then
                                                if mod.SetIconsType then pcall(mod.SetIconsType, "lucide") end
                                                if Probe(mod) then table.insert(Extra, mod) end
                                        end
                                end
                        end
                        loadedExtra, loading = true, false
                        for k, v in pairs(Hit) do if v == false then Hit[k] = nil end end
                        Refresh()
                end)
        end

        ResolveIcon = function(name)
                name = tostring(name)
                local c = Hit[name]
                if c ~= nil then return c or nil end
                local res = false
                if Lib.CustomIcons[name] then
                        res = { Image = Lib.CustomIcons[name] }
                elseif name:find("rbxasset") then
                        res = { Image = name }
                else
                        for _, nm in ipairs(Variants(name)) do
                                if IconMod then res = Query(IconMod, nm) end
                                if not res then
                                        for _, m in ipairs(Extra) do
                                                res = Query(m, nm)
                                                if res then break end
                                        end
                                end
                                if res then break end
                        end
                        res = res or false
                end
                Hit[name] = res
                return res or nil
        end

        local origIcon = Lib.Icon
        function Lib.Icon(name, size, key, props, fallback)
                if fallback == nil then
                        local n = tostring(name)
                        fallback = Glyph[n] or n:sub(1, 1):upper()
                end
                local img = origIcon(name, size, key, props, fallback)
                if img and img:FindFirstChildOfClass("TextLabel") then
                        table.insert(Pending, { img, tostring(name) })
                        task.defer(LoadExtra)
                end
                return img
        end

        function Lib:HasIcon(name) return ResolveIcon(name) ~= nil end

        -- Lib:AddIcon("my-icon", 1234567890)  or  Lib:AddIcon("my-icon", sheetId, Vector2.new(x, y), Vector2.new(w, h))
        function Lib:AddIcon(name, asset, pos, size)
                name = tostring(name)
                if pos then Hit[name] = { Image = asset, Pos = pos, Size = size } else self.CustomIcons[name] = asset Hit[name] = nil end
                Refresh()
        end

        -- Lib:AliasIcon("my-name", "real-lucide-name")
        function Lib:AliasIcon(name, target)
                self.IconAlias[tostring(name)] = tostring(target)
                Hit[tostring(name)] = nil
                Refresh()
        end

        function Lib:AddIconSource(url)
                table.insert(self.IconSources, url)
                loadedExtra = false
                LoadExtra()
        end

        function Lib:ReloadIcons() loadedExtra = false for k in pairs(Hit) do Hit[k] = nil end LoadExtra() end

        -- prints which names can't be found: Lib:IconReport({ "swords", "crown" })
        function Lib:IconReport(names)
                local miss = {}
                for _, n in ipairs(names) do if not ResolveIcon(n) then miss[#miss + 1] = n end end
                if #miss > 0 then warn("[Aether] icons not found: " .. table.concat(miss, ", ")) else print("[Aether] all icons found") end
                return miss
        end

        -- if the first pack never loaded (no HTTP at startup), try again in the background
        task.delay(2.5, function() if not IconMod then LoadExtra() end end)
end

-- ==================== 2) REACTIONS ====================
local Cats = {
        { "😀", "Smileys", "😀 😃 😄 😁 😆 😅 😂 🤣 😊 😇 🙂 🙃 😉 😌 😍 🥰 😘 😗 😋 😛 😜 🤪 😝 🤑 🤗 🤭 🤫 🤔 🤐 🤨 😐 😑 😶 😏 😒 🙄 😬 😴 🤤 😪 😵 🤯 🤠 🥳 😎 🤓 🧐 😕 😟 🙁 😮 😯 😲 😳 🥺 😦 😧 😨 😰 😥 😢 😭 😱 😖 😣 😞 😓 😩 😫 🥱 😤 😡 😠 🤬 😈 👿 💀 ☠️ 💩 🤡 👹 👺 👻 👽 🤖" },
        { "👍", "Gestures", "👍 👎 👌 ✌️ 🤞 🤟 🤘 🤙 👈 👉 👆 👇 ☝️ 👋 🤚 ✋ 🖖 👏 🙌 🤝 🙏 💪 ✍️ 🤳 👀 🧠 👑 🦾" },
        { "❤️", "Hearts & symbols", "❤️ 🧡 💛 💚 💙 💜 🖤 🤍 🤎 💔 ❣️ 💕 💞 💓 💗 💖 💘 💝 💯 💢 💥 💫 💦 💨 🔥 ⭐ 🌟 ✨ ⚡ ✅ ❌ ⭕ ❗ ❓ ‼️ ⁉️ 💤 🎉 🎊" },
        { "🐶", "Animals & food", "🐶 🐱 🐭 🐹 🐰 🦊 🐻 🐼 🐨 🐯 🦁 🐮 🐷 🐸 🐵 🙈 🙉 🙊 🐔 🐧 🐦 🦄 🐝 🦋 🐢 🐍 🐙 🦈 🐬 🍎 🍌 🍉 🍓 🍕 🍔 🍟 🌭 🍿 🍩 🍪 🎂 🍰 🍫 🍺 ☕" },
        { "🎮", "Objects", "🎮 🎯 🎲 ⚽ 🏀 🏈 🎸 🎵 🎧 📱 💻 💡 💰 💎 🔑 🚀 🏆 🔔 📌 🔒 🔓 ⚔️ 🛡️ 💣 🧪 🎁 🌈 ☀️ 🌙 ❄️" },
}

do
        local function MeId() return LocalPlayer.UserId end

        local function Mine(entry)
                for _, u in ipairs(entry.u or {}) do if tonumber(u) == MeId() then return true end end
                return false
        end

        local function Has(list, emoji)
                for _, r in ipairs(list or {}) do if r.e == emoji and Mine(r) then return true end end
                return false
        end

        -- returns a new reaction list with my reaction toggled (or only added)
        local function Toggled(list, emoji, addOnly)
                local out, found = {}, false
                for _, r in ipairs(list or {}) do
                        local u = {}
                        for _, x in ipairs(r.u or {}) do u[#u + 1] = x end
                        if r.e == emoji then
                                found = true
                                local at
                                for i, x in ipairs(u) do if tonumber(x) == MeId() then at = i break end end
                                if at then
                                        if not addOnly then table.remove(u, at) end
                                else
                                        u[#u + 1] = MeId()
                                end
                        end
                        if #u > 0 then out[#out + 1] = { e = r.e, u = u } end
                end
                if not found then out[#out + 1] = { e = emoji, u = { MeId() } } end
                return out
        end

        function Chat:_RenderReactions(item, list)
                local col = item and item:FindFirstChild("Col")
                if not col then return end
                local meta = self.Meta[item]
                if meta then meta.rx = list end
                local row = col:FindFirstChild("Reacts")
                if not list or #list == 0 then
                        if row then row:Destroy() end
                        return
                end
                local mineMsg = meta and meta.msg and tostring(meta.msg.uid) == tostring(LocalPlayer.UserId)
                if not row then
                        row = New("Frame", { Name = "Reacts", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Y, BackgroundTransparency = 1, LayoutOrder = 3, Parent = col })
                        local l = List(row, 4, Enum.FillDirection.Horizontal, mineMsg and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left)
                        l.Wraps = true
                end
                for _, c in ipairs(row:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                local msgId = meta and meta.msg and meta.msg.id
                for i, r in ipairs(list) do
                        local me = Mine(r)
                        local chip = New("TextButton", { Text = tostring(r.e) .. " " .. #(r.u or {}), TextSize = 12, AutomaticSize = X, Size = UDim2.fromOffset(0, H(22)), LayoutOrder = i,
                                BackgroundTransparency = me and 0.7 or 0, Theme = { BackgroundColor3 = me and "Accent" or "Field", TextColor3 = me and "Text" or "SubText" }, Parent = row })
                        Corner(chip, 11) Pad(chip, 8, 0, 8, 0)
                        Stroke(chip, me and "Accent" or "Stroke", 1, me and 0.3 or 0.6)
                        chip.Activated:Connect(function() if msgId then self:React(msgId, r.e) end end)
                end
                -- keep the column wide enough for a couple of chips per line
                local maxCol = math.min(560, math.floor((self.Frame.Size.X.Offset - 44) * 0.8))
                local need = math.min(maxCol, #list * 46 + 6)
                if col.Size.X.Offset < need then col.Size = UDim2.new(0, need, 0, 0) end
        end

        function Chat:_SetReactions(id, list, evId)
                local item = self.ByLid[id]
                if not (item and item.Parent) then return end
                local meta = self.Meta[item]
                if evId and meta then
                        if (meta.rxEv or -1) > evId then return end
                        meta.rxEv = evId
                end
                self:_RenderReactions(item, list)
        end

        function Chat:React(id, emoji, addOnly)
                if not (self.Request and id and emoji) then return end
                local item = self.ByLid[id]
                local meta = item and self.Meta[item]
                local before = (meta and meta.rx) or {}
                if addOnly and Has(before, emoji) then return end
                local room = self.Room
                if item then self:_RenderReactions(item, Toggled(before, emoji, addOnly)) end
                Lib:PushRecentEmoji(emoji)
                task.spawn(function()
                        local d = Decode(self:_Do("/react", nil, "POST", HttpService:JSONEncode({ id = id, emoji = emoji }), room))
                        if room ~= self.Room then return end
                        if d and d.ok then
                                self:_SetReactions(id, d.reactions or {})
                        else
                                self:_SetReactions(id, before)
                                Lib:Notify({ Title = "Reactions", Text = (d and d.error) or "Couldn't react. Is your worker updated?", Type = "error", Duration = 4 })
                        end
                end)
        end

        -- full emoji picker (categories, recents, paste-your-own)
        function Chat:EmojiPicker(cb, title)
                local Z, W, HH = 130, 330, 396
                local dim = New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.45, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = Z, Parent = Lib.Overlay })
                local card = Sink(New("Frame", { Size = UDim2.fromOffset(W, HH), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = Z + 1,
                        Theme = { BackgroundColor3 = "Bg" }, Parent = dim }))
                Corner(card, 10) Stroke(card)
                New("UIScale", { Scale = math.min(1, Lib.Overlay.AbsoluteSize.X / (W + 20), Lib.Overlay.AbsoluteSize.Y / (HH + 20)), Parent = card })
                New("TextLabel", { Text = title or "Pick an emoji", Font = Lib.FontBold, TextSize = 14, Size = UDim2.new(1, -80, 0, 30), Position = UDim2.fromOffset(12, 0),
                        TextXAlignment = LEFT, ZIndex = Z + 2, Parent = card })
                local close = New("TextButton", { Text = "Close", TextSize = 12, Size = UDim2.fromOffset(52, 22), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 4),
                        BackgroundTransparency = 0, ZIndex = Z + 2, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = card })
                Corner(close, 5)
                local function Close() if dim.Parent then dim:Destroy() end end
                close.Activated:Connect(Close)
                dim.Activated:Connect(Close)
                local tabH = H(30)
                local bar = New("Frame", { Size = UDim2.new(1, -20, 0, tabH), Position = UDim2.fromOffset(10, 34), BackgroundTransparency = 1, ZIndex = Z + 2, Parent = card })
                List(bar, 4, Enum.FillDirection.Horizontal)
                local grid = New("ScrollingFrame", { Size = UDim2.new(1, -16, 1, -(tabH + 34 + 6 + 44)), Position = UDim2.fromOffset(8, 34 + tabH + 6), AutomaticCanvasSize = Y,
                        ScrollBarThickness = 3, ZIndex = Z + 2, Parent = card })
                New("UIGridLayout", { CellSize = UDim2.fromOffset(38, 38), CellPadding = UDim2.fromOffset(2, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = grid })
                local tabs = {}
                local function Fill(i)
                        for _, c in ipairs(grid:GetChildren()) do if not c:IsA("UIGridLayout") then c:Destroy() end end
                        local list = {}
                        if i == 0 then
                                for _, e in ipairs(Lib.ChatPrefs.Recent) do list[#list + 1] = e end
                        else
                                for w in Cats[i][3]:gmatch("%S+") do list[#list + 1] = w end
                        end
                        if #list == 0 then
                                New("TextLabel", { Text = "Nothing here yet. React to something first.", TextSize = 12, Size = UDim2.new(1, 0, 0, 30), ZIndex = Z + 3, Theme = { TextColor3 = "Dim" }, Parent = grid })
                        end
                        for n, e in ipairs(list) do
                                local b = New("TextButton", { Text = e, TextSize = 22, LayoutOrder = n, BackgroundTransparency = 1, BackgroundColor3 = Lib.Theme.FieldHover, ZIndex = Z + 3, Parent = grid })
                                Corner(b, 6)
                                b.MouseEnter:Connect(function() Tween(b, { BackgroundTransparency = 0.3 }, 0.06) end)
                                b.MouseLeave:Connect(function() Tween(b, { BackgroundTransparency = 1 }, 0.08) end)
                                b.Activated:Connect(function() Close() Safe(cb, e) end)
                        end
                        for k, t in pairs(tabs) do
                                t.BackgroundColor3 = (k == i) and Lib.Theme.Accent or Lib.Theme.Field
                        end
                end
                local n = #Cats + 1
                for i = 0, #Cats do
                        local b = New("TextButton", { Text = i == 0 and "🕘" or Cats[i][1], TextSize = 16, Size = UDim2.new(1 / n, -4, 1, 0), LayoutOrder = i + 1, BackgroundTransparency = 0, ZIndex = Z + 3,
                                Theme = { BackgroundColor3 = "Field" }, Parent = bar })
                        Corner(b, 6)
                        tabs[i] = b
                        b.Activated:Connect(function() Fill(i) end)
                end
                local box = New("TextBox", { Text = "", PlaceholderText = "Paste any emoji...", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 13, Size = UDim2.new(1, -84, 0, 28),
                        AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 10, 1, -8), BackgroundTransparency = 0, TextXAlignment = LEFT, ZIndex = Z + 2,
                        Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = card })
                Corner(box, 5) Pad(box, 8, 0, 8, 0)
                local use = New("TextButton", { Text = "Use", TextSize = 12, Size = UDim2.fromOffset(56, 28), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -10, 1, -8),
                        BackgroundTransparency = 0, ZIndex = Z + 2, Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = card })
                Corner(use, 5)
                local function Take()
                        local t = Trim(box.Text)
                        if t == "" then return end
                        Close()
                        Safe(cb, t)
                end
                use.Activated:Connect(Take)
                box.FocusLost:Connect(function(enter) if enter then Take() end end)
                Fill(#Lib.ChatPrefs.Recent > 0 and 0 or 1)
        end

        -- the actions shared by the PC right-click menu and the mobile sheet
        function Chat:_MenuItems(msg)
                local name = tostring((msg.display ~= nil and msg.display ~= "") and msg.display or msg.name or "?")
                local mine = tostring(msg.uid) == tostring(LocalPlayer.UserId)
                local A, B, C, D = {}, {}, {}, {}
                local snippet = tostring(msg.text ~= "" and msg.text or (msg.cfg and "[config]" or "[image]")):sub(1, 70)
                if msg.id then
                        table.insert(A, { Text = "Reply", Icon = "reply", Cb = function() self:SetReply({ id = msg.id, name = name, text = snippet }) end })
                end
                table.insert(A, { Text = "Mention", Icon = "at-sign", Cb = function() self:Prefill(self.Input.Text .. "@" .. tostring(msg.name) .. " ") end })
                if type(setclipboard) == "function" and tostring(msg.text or "") ~= "" then
                        table.insert(B, { Text = "Copy Text", Icon = "copy", Cb = function() setclipboard(tostring(msg.text)) end })
                end
                local link = tostring(msg.text or ""):match("https?://[^%s<>\"]+")
                if link and type(setclipboard) == "function" then
                        link = link:gsub("[%.,;:!%?%)%]]+$", "")
                        table.insert(B, { Text = "Copy Link", Icon = "link", Cb = function() Copy(link, "Link copied") end })
                end
                if msg.id and type(setclipboard) == "function" then
                        table.insert(B, { Text = "Copy Message ID", Icon = "hash", Cb = function() Copy(tostring(msg.id), "Message ID") end })
                end
                if msg.id then table.insert(B, { Text = "Hide for me", Icon = "eye-off", Cb = function() self:_Remove(msg.id) end }) end
                if mine and msg.id then
                        table.insert(C, { Text = "Edit Message", Icon = "pencil", Cb = function() self:EditMessage(msg) end })
                        table.insert(C, { Text = "Delete Message", Icon = "trash-2", Danger = true, Cb = function() self:DeleteMessage(msg) end })
                end
                table.insert(D, { Text = "View Profile", Icon = "user", Cb = function() self:ShowProfile(msg) end })
                if not mine and msg.uid then
                        local blocked = Lib:IsBlocked(msg.uid)
                        table.insert(D, { Text = blocked and "Unblock User" or "Block User", Icon = "ban", Danger = not blocked, Cb = function()
                                if blocked then Lib:Unblock(msg.uid) else Lib:Block(msg.uid, name) end
                        end })
                end
                return { A, B, C, D }
        end

        -- PC: right-click menu. Touch: the Discord-style sheet.
        function Chat:OpenMessageMenu(msg, touch)
                if not msg then return end
                if touch or Lib.Touch then self:MessageSheet(msg) return end
                local items = {}
                if msg.id then
                        table.insert(items, { Text = "Add reaction...", Callback = function() self:EmojiPicker(function(e) self:React(msg.id, e) end) end })
                end
                for _, g in ipairs(self:_MenuItems(msg)) do
                        for _, it in ipairs(g) do table.insert(items, { Text = it.Text, Danger = it.Danger, Callback = it.Cb }) end
                end
                self:Menu(items, self.LastPtr)
        end

        -- the old "tap a message" handler: opening the menu now takes a right-click (PC) or a long-press (mobile)
        function Chat:MessageMenu() end

        function Chat:MessageSheet(msg)
                local ov = Lib.Overlay
                local vp = ov.AbsoluteSize
                local s = Clamp(math.min(vp.X / 400, vp.Y / 430), 0.65, 1)
                local W = 380
                local Hh = math.min(560, math.floor((vp.Y - 8) / s))
                local dim = New("TextButton", { Name = "MsgSheetDim", Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 120, Parent = ov })
                Tween(dim, { BackgroundTransparency = 0.45 }, 0.2)
                local card = Sink(New("Frame", { Size = UDim2.fromOffset(W, Hh), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, Hh + 20), ZIndex = 121,
                        Theme = { BackgroundColor3 = "Bg" }, Parent = dim }))
                Corner(card, 16)
                New("UIScale", { Scale = s, Parent = card })
                local grab = New("Frame", { Size = UDim2.fromOffset(40, 4), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 8), Theme = { BackgroundColor3 = "Stroke" }, Parent = card })
                Corner(grab, 2)
                local scroll = New("ScrollingFrame", { Size = UDim2.new(1, 0, 1, -20), Position = UDim2.fromOffset(0, 20), AutomaticCanvasSize = Y, ScrollBarThickness = 2, Parent = card })
                Pad(scroll, 12, 4, 12, 16)
                List(scroll, 10)
                local closed = false
                local function Close()
                        if closed then return end
                        closed = true
                        Tween(card, { Position = UDim2.new(0.5, 0, 1, Hh + 20) }, 0.18, Enum.EasingStyle.Quad)
                        Tween(dim, { BackgroundTransparency = 1 }, 0.18)
                        task.delay(0.22, function() if dim.Parent then dim:Destroy() end end)
                end
                dim.Activated:Connect(Close)
                Tween(card, { Position = UDim2.new(0.5, 0, 1, 0) }, 0.24, Enum.EasingStyle.Quint)

                local nm = tostring((msg.display ~= nil and msg.display ~= "") and msg.display or msg.name or "?")
                local preview = tostring(msg.text ~= "" and msg.text or (msg.cfg and "[config]" or "[image]"))
                New("TextLabel", { Text = "<b>" .. RichEsc(nm) .. "</b>  " .. RichEsc(preview:sub(1, 80)), RichText = true, TextSize = 12, Size = UDim2.new(1, 0, 0, 18), TextXAlignment = LEFT,
                        TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = 0, Theme = { TextColor3 = "SubText" }, Parent = scroll })

                if msg.id then
                        local item = self.ByLid[msg.id]
                        local meta = item and self.Meta[item]
                        local row = New("Frame", { Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, LayoutOrder = 1, Parent = scroll })
                        List(row, 6, Enum.FillDirection.Horizontal)
                        local function Tile(order, text, fn, lit)
                                local b = New("TextButton", { Text = text, TextSize = 24, Size = UDim2.new(1 / 7, -(6 * 6) / 7, 1, 0), LayoutOrder = order, BackgroundTransparency = 0,
                                        Theme = { BackgroundColor3 = "Field" }, Parent = row })
                                Corner(b, 10)
                                if lit then Stroke(b, "Accent", 1.5, 0.2) end
                                b.Activated:Connect(function() Close() fn() end)
                        end
                        for i, e in ipairs(Lib.QuickEmoji) do
                                Tile(i, e, function() self:React(msg.id, e) end, Has(meta and meta.rx, e))
                        end
                        Tile(#Lib.QuickEmoji + 1, "+", function() self:EmojiPicker(function(e) self:React(msg.id, e) end) end, false)

                        local hint = New("Frame", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = 2, Parent = scroll })
                        List(hint, 5, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)
                        New("TextLabel", { Text = "Double tap a message to", TextSize = 12, AutomaticSize = X, Size = UDim2.fromOffset(0, 20), LayoutOrder = 1, Theme = { TextColor3 = "Dim" }, Parent = hint })
                        New("TextLabel", { Text = Lib.ChatPrefs.DoubleTap, TextSize = 15, AutomaticSize = X, Size = UDim2.fromOffset(0, 20), LayoutOrder = 2, Parent = hint })
                        local edit = New("TextButton", { Text = "Edit", TextSize = 12, AutomaticSize = X, Size = UDim2.fromOffset(0, 20), LayoutOrder = 3, Theme = { TextColor3 = "Accent" }, Parent = hint })
                        edit.Activated:Connect(function()
                                Close()
                                self:EmojiPicker(function(e)
                                        Lib.ChatPrefs.DoubleTap = e
                                        Lib:SaveChatPrefs()
                                        Lib:Notify({ Title = "Reactions", Text = "Double tap now reacts with " .. e, Type = "success", Duration = 2.5 })
                                end, "Double tap reaction")
                        end)
                end

                local order = 3
                for _, items in ipairs(self:_MenuItems(msg)) do
                        if #items > 0 then
                                order = order + 1
                                local grp = New("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Y, LayoutOrder = order, BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Field" }, Parent = scroll })
                                Corner(grp, 10) List(grp, 0)
                                for i, it in ipairs(items) do
                                        local b = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, 44), LayoutOrder = i, Parent = grp })
                                        Lib.Icon(it.Icon or "circle", 18, it.Danger and "Bad" or "SubText", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0), Parent = b })
                                        New("TextLabel", { Text = it.Text, TextSize = 14, Size = UDim2.new(1, -56, 1, 0), Position = UDim2.fromOffset(46, 0), TextXAlignment = LEFT,
                                                TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = it.Danger and "Bad" or "Text" }, Parent = b })
                                        if i < #items then
                                                New("Frame", { Size = UDim2.new(1, -46, 0, 1), Position = UDim2.new(0, 46, 1, -1), BackgroundTransparency = 0.5, Theme = { BackgroundColor3 = "Stroke" }, Parent = b })
                                        end
                                        b.Activated:Connect(function() Close() Safe(it.Cb) end)
                                end
                        end
                end
        end

        -- per message: right-click (PC), long-press (touch), double-tap / double-click (react)
        function Chat:_HookItem(item, msg)
                if not (msg and msg.id) then return end
                local lastTap = 0
                item.Activated:Connect(function()
                        if os.clock() - (item:GetAttribute("lp") or 0) < 0.7 then return end
                        local now = os.clock()
                        if now - lastTap < 0.32 then
                                lastTap = 0
                                self:React(msg.id, Lib.ChatPrefs.DoubleTap, true)
                        else
                                lastTap = now
                        end
                end)
                item.MouseButton2Click:Connect(function()
                        self.LastPtr = UIS:GetMouseLocation() + Lib.PtrShift
                        self:OpenMessageMenu(msg, false)
                end)
                item.InputBegan:Connect(function(input)
                        if input.UserInputType ~= Enum.UserInputType.Touch then return end
                        local start = input.Position
                        local alive = true
                        local c
                        c = UIS.InputEnded:Connect(function(i) if i == input then alive = false c:Disconnect() end end)
                        task.delay(0.42, function()
                                if not alive then return end
                                alive = false
                                c:Disconnect()
                                local cur = input.Position
                                if (Vector2.new(cur.X, cur.Y) - Vector2.new(start.X, start.Y)).Magnitude > 14 then return end
                                item:SetAttribute("lp", os.clock())
                                self:OpenMessageMenu(msg, true)
                        end)
                end)
        end

        -- PC only: a little bar (quick reactions, add reaction, reply, more) follows the message under the mouse
        function Chat:_InitReactUI()
                if self._rxUI or Lib.Touch then return end
                self._rxUI = true
                local bar = Sink(New("Frame", { Name = "HoverBar", Size = UDim2.fromOffset(0, 28), AutomaticSize = X, Visible = false, ZIndex = 30,
                        Theme = { BackgroundColor3 = "Surface" }, Parent = self.Frame }))
                Corner(bar, 7) Stroke(bar, "Stroke", 1, 0.1) Pad(bar, 3, 3, 3, 3) List(bar, 2, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
                local function Cur()
                        local it = self._hoverItem
                        local m = it and self.Meta[it]
                        return m and m.msg or nil
                end
                local function EBtn(text, order, fn)
                        local b = New("TextButton", { Text = text, TextSize = 14, Size = UDim2.fromOffset(24, 22), LayoutOrder = order, BackgroundTransparency = 1, ZIndex = 31,
                                Theme = { BackgroundColor3 = "FieldHover" }, Parent = bar })
                        Corner(b, 5)
                        b.MouseEnter:Connect(function() Tween(b, { BackgroundTransparency = 0.3 }, 0.06) end)
                        b.MouseLeave:Connect(function() Tween(b, { BackgroundTransparency = 1 }, 0.08) end)
                        b.Activated:Connect(fn)
                end
                for i = 1, 3 do
                        local e = Lib.QuickEmoji[i]
                        EBtn(e, i, function() local m = Cur() if m and m.id then self:React(m.id, e) end end)
                end
                local function IBtn(icon, fb, tip, order, fn)
                        local api = IconButton(bar, icon, fb, 22, tip, "Accent", 1)
                        api.Button.LayoutOrder = order
                        api.Button.Activated:Connect(fn)
                end
                IBtn("smile-plus", "+", "Add reaction", 4, function()
                        local m = Cur()
                        if m and m.id then self:EmojiPicker(function(e) self:React(m.id, e) end) end
                end)
                IBtn("reply", "<", "Reply", 5, function()
                        local m = Cur()
                        if not (m and m.id) then return end
                        local nm = tostring((m.display ~= nil and m.display ~= "") and m.display or m.name or "?")
                        self:SetReply({ id = m.id, name = nm, text = tostring(m.text ~= "" and m.text or (m.cfg and "[config]" or "[image]")):sub(1, 70) })
                end)
                IBtn("ellipsis", "...", "More", 6, function()
                        local m = Cur()
                        self.LastPtr = UIS:GetMouseLocation() + Lib.PtrShift
                        if m then self:OpenMessageMenu(m, false) end
                end)
                local function Inside(f, m)
                        local p, s = f.AbsolutePosition, f.AbsoluteSize
                        return m.X >= p.X and m.X <= p.X + s.X and m.Y >= p.Y and m.Y <= p.Y + s.Y
                end
                Lib:Connect(RunService.RenderStepped, function()
                        if not self.Frame.Parent then return end
                        local show = false
                        if self.PanelObj._shown and self.Frame.Visible and Lib.Visible and not Lib.Popup and not self.NotifOpen then
                                local m = UIS:GetMouseLocation() + Lib.PtrShift
                                if bar.Visible and self._hoverItem and self._hoverItem.Parent and Inside(bar, m) then
                                        show = true
                                elseif Inside(self.List, m) then
                                        for i = #self.Items, 1, -1 do
                                                local it = self.Items[i]
                                                if it.Parent and it.Visible and self.Meta[it] and Inside(it, m) then
                                                        self._hoverItem = it
                                                        show = true
                                                        break
                                                end
                                        end
                                end
                        end
                        if show and self._hoverItem and self._hoverItem.Parent then
                                local sc = math.max(Lib.Scale, 0.01)
                                local fp, lp, ls = self.Frame.AbsolutePosition, self.List.AbsolutePosition, self.List.AbsoluteSize
                                local ip, bs = self._hoverItem.AbsolutePosition, bar.AbsoluteSize
                                local y = Clamp(ip.Y - 12 * sc, lp.Y, math.max(lp.Y, lp.Y + ls.Y - bs.Y)) - fp.Y
                                local x = lp.X + ls.X - bs.X - 12 * sc - fp.X
                                bar.Position = UDim2.fromOffset(x / sc, y / sc)
                                bar.Visible = true
                        else
                                bar.Visible = false
                        end
                end)
        end

        P.AddMessage = Chat.AddMessage
        function Chat:AddMessage(msg)
                if type(msg) == "table" and msg.type == "react" then
                        if msg.id and self.Seen[msg.id] then return nil end
                        if msg.id then self.Seen[msg.id] = true end
                        self:_SetReactions(msg.target, msg.reactions or {}, msg.id)
                        return nil
                end
                local last = self.Items[#self.Items]
                local res = P.AddMessage(self, msg)
                local item = self.Items[#self.Items]
                local meta = item and item ~= last and self.Meta[item]
                if meta and meta.msg == msg and msg.id then
                        pcall(function()
                                self:_HookItem(item, msg)
                                if type(msg.reactions) == "table" and #msg.reactions > 0 then self:_RenderReactions(item, msg.reactions) end
                                if self.ReadMark then self:_PlaceRead() end
                        end)
                end
                return res
        end
end

-- ==================== 3) READ RECEIPTS (DMs only) ====================
do
        P.Do = Chat._Do
        function Chat:_Do(path, query, method, body, room)
                if path == "/poll" and room == nil and type(self.Room) == "string" and self.Room:sub(1, 3) == "dm:" then
                        query = query or {}
                        if query.peek == nil then
                                local pr = Lib:LoadChatPrefs()
                                local shown = self.PanelObj and self.PanelObj._shown and Lib.Visible and self.Frame and self.Frame.Visible
                                query.rr = pr.ReadReceipts and "1" or "0"
                                query.seen = (pr.ReadReceipts and shown and not self.Blocked) and "1" or "0"
                        end
                        local at = self.Room
                        local res = P.Do(self, path, query, method, body, room)
                        if res and res.StatusCode == 200 and query.peek == nil then
                                local d = Decode(res)
                                if d then pcall(function() self:_ApplyRead(at, d) end) end
                        end
                        return res
                end
                return P.Do(self, path, query, method, body, room)
        end

        function Chat:_ApplyRead(room, d)
                if room ~= self.Room then return end
                if d and d.ok and Lib.ChatPrefs.ReadReceipts and type(d.read) == "table" and tonumber(d.read.id) then
                        self.ReadMark = { id = tonumber(d.read.id), ts = tonumber(d.read.ts) or 0 }
                else
                        self.ReadMark = nil
                end
                self:_PlaceRead()
        end

        -- "Read 12:34" under your newest message, only when they have seen it
        function Chat:_PlaceRead()
                if self._seenLbl then pcall(function() self._seenLbl:Destroy() end) self._seenLbl = nil end
                local rm = self.ReadMark
                if not rm or self.Room:sub(1, 3) ~= "dm:" or not Lib.ChatPrefs.ReadReceipts then return end
                local me = tostring(LocalPlayer.UserId)
                for i = #self.Items, 1, -1 do
                        local it = self.Items[i]
                        local meta = it.Parent and self.Meta[it]
                        if meta and meta.msg and tostring(meta.msg.uid) == me and meta.msg.id then
                                if meta.msg.id <= rm.id then
                                        local col = it:FindFirstChild("Col")
                                        if col then
                                                local tm = ""
                                                pcall(function() tm = os.date("%H:%M", math.floor(rm.ts / 1000)) end)
                                                self._seenLbl = New("TextLabel", { Name = "SeenLbl", Text = "Read " .. tm, TextSize = 10, Size = UDim2.new(1, 0, 0, 12),
                                                        TextXAlignment = RIGHT, LayoutOrder = 4, Theme = { TextColor3 = "Dim" }, Parent = col })
                                        end
                                end
                                return
                        end
                end
        end

        P.SetChannel = Chat.SetChannel
        function Chat:SetChannel(i)
                self.ReadMark, self._acUndo, self._hoverItem = nil, nil, nil
                if self._seenLbl then pcall(function() self._seenLbl:Destroy() end) self._seenLbl = nil end
                return P.SetChannel(self, i)
        end
end

-- ==================== 4) AUTO CORRECT ====================
do
        local AC = { cache = {}, ignore = {}, cool = 0 }
        Lib.AC = AC
        for w in ("lol lmao lmfao omg idk ngl tbh smh imo irl brb btw fyi gg ez rn ty thx pls plz rip wtf wth yea yeah nah bruh bro sus noob lowkey highkey yeet fr tho ur roblox aether bruhh ok okay ayy yup nope hehe haha hahaha uwu owo xd lil gonna wanna gotta kinda sorta dunno gimme lemme cuz cus tryna finna boutta ong frfr nvm nm wyd hbu wbu ikr ily jk atm tmr asap afk gl hf wp ggs"):gmatch("%S+") do AC.ignore[w] = true end
        function Lib:AutoCorrectIgnore(word) AC.ignore[tostring(word):lower()] = true end

        local function MatchCase(orig, fix)
                if #orig > 1 and orig == orig:upper() then return fix:upper() end
                if orig:sub(1, 1) ~= orig:sub(1, 1):lower() then return fix:sub(1, 1):upper() .. fix:sub(2) end
                return fix
        end

        -- returns the lowercase word if it is worth checking
        local function Candidate(word, sentStart)
                local l = word:lower()
                if #l < 3 or #l > 24 or not l:match("^[a-z']+$") or l:find("^'") or AC.ignore[l] then return nil end
                local caps = select(2, word:gsub("%u", ""))
                if caps > 0 and not (caps == 1 and sentStart and word:sub(1, 1):match("%u")) then return nil end
                return l
        end

        -- applies everything already in the cache; also returns the words still to look up
        function Lib:_ACPass(text)
                local urls = {}
                for a, b in text:gmatch("()https?://%S*()") do urls[#urls + 1] = { a, b } end
                local out, last, need, seen = {}, 1, {}, {}
                for s, word, e in text:gmatch("()([%a']+)()") do
                        local c = text:sub(s - 1, s - 1)
                        local skip = c == "@" or c == ":" or text:sub(e, e) == ":"
                        if not skip then
                                local b1, b2 = text:byte(s - 1), text:byte(e)
                                if (b1 and b1 > 127) or (b2 and b2 > 127) then skip = true end
                        end
                        if not skip then
                                for _, u in ipairs(urls) do if s >= u[1] and s < u[2] then skip = true break end end
                        end
                        if not skip then
                                local pre = text:sub(1, s - 1)
                                local sentStart = pre:match("^%s*$") ~= nil or pre:match("[%.!%?]%s+$") ~= nil
                                local l = Candidate(word, sentStart)
                                if l then
                                        local fix = AC.cache[l]
                                        if fix == nil then
                                                if not seen[l] then seen[l] = true need[#need + 1] = l end
                                        elseif fix ~= "" then
                                                out[#out + 1] = text:sub(last, s - 1) .. MatchCase(word, fix)
                                                last = e
                                        end
                                end
                        end
                end
                out[#out + 1] = text:sub(last)
                return table.concat(out), need
        end

        -- blocking: asks the worker (LanguageTool) about words we don't know yet
        function Chat:_ACFetch(words)
                if os.clock() < AC.cool then return false end
                local need = {}
                for _, w in ipairs(words) do if AC.cache[w] == nil then need[#need + 1] = w end end
                for i = 1, #need, 8 do
                        local part = {}
                        for j = i, math.min(i + 7, #need) do part[#part + 1] = need[j] end
                        local d = Decode(self:_Do("/spell", { w = table.concat(part, ",") }))
                        if not (d and d.ok and type(d.r) == "table") then AC.cool = os.clock() + 8 return false end
                        for _, w in ipairs(part) do
                                local v = d.r[w]
                                if type(v) == "string" then AC.cache[w] = v end
                        end
                        if d.busy then AC.cool = os.clock() + 6 return false end
                end
                return true
        end

        -- live: when you type a space / punctuation, the word before it is corrected. Backspace right after to undo.
        function Chat:_InitAutoCorrect()
                if self._acInit then return end
                self._acInit = true
                local input = self.Input
                local prev = ""
                input:GetPropertyChangedSignal("Text"):Connect(function()
                        local t = input.Text
                        if not Lib.ChatPrefs.AutoCorrect then prev = t return end
                        if self._acExpect and t == self._acExpect then self._acExpect = nil prev = t return end
                        local un = self._acUndo
                        if un then
                                self._acUndo = nil
                                if t == un.after:sub(1, -2) then
                                        AC.ignore[un.orig:lower()] = true
                                        local restored = un.before:sub(1, -2)
                                        self._acExpect = restored
                                        input.Text = restored
                                        input.CursorPosition = #restored + 1
                                        prev = restored
                                        return
                                end
                        end
                        local grew = #t == #prev + 1 and t:sub(1, #prev) == prev
                        prev = t
                        if not grew or t:sub(1, 1) == "/" then return end
                        local bc = t:sub(-1)
                        if not bc:match("[%s%.,!%?;]") then return end
                        local body = t:sub(1, -2)
                        local ws, word = body:match("()([%a']+)$")
                        if not word then return end
                        local pre = body:sub(1, ws - 1)
                        local c = pre:sub(-1)
                        if c == "@" or c == ":" then return end
                        local b1 = body:byte(ws - 1)
                        if b1 and b1 > 127 then return end
                        if pre:match("https?://%S*$") then return end
                        local sentStart = pre:match("^%s*$") ~= nil or pre:match("[%.!%?]%s+$") ~= nil
                        local l = Candidate(word, sentStart)
                        if not l then return end
                        local function Apply()
                                local fix = AC.cache[l]
                                if not fix or fix == "" or not input:IsFocused() then return end
                                local cur = input.Text
                                if cur:sub(ws, ws + #word - 1) ~= word or cur:sub(ws + #word, ws + #word) ~= bc then return end
                                local newText = cur:sub(1, ws - 1) .. MatchCase(word, fix) .. cur:sub(ws + #word)
                                self._acUndo = { orig = word, before = cur, after = newText }
                                self._acExpect = newText
                                prev = newText
                                input.Text = newText
                                input.CursorPosition = #newText + 1
                        end
                        if AC.cache[l] ~= nil then Apply() return end
                        task.spawn(function() if self:_ACFetch({ l }) then Apply() end end)
                end)
        end

        -- on send: whatever is left gets corrected too (waits up to 2.5s for the worker)
        P.Send = Chat.Send
        function Chat:Send(text)
                text = Trim(text or "")
                if text == "" or not Lib.ChatPrefs.AutoCorrect or not self.Request or self.Blocked then return P.Send(self, text) end
                local fixed, need = Lib:_ACPass(text)
                if #need == 0 then return P.Send(self, fixed) end
                task.spawn(function()
                        local done = false
                        task.spawn(function() self:_ACFetch(need) done = true end)
                        local t0 = os.clock()
                        while not done and os.clock() - t0 < 2.5 do task.wait(0.05) end
                        local final = Lib:_ACPass(text)
                        P.Send(self, final)
                end)
        end
end

-- ==================== 5) MULTI-SELECT PICKER + GROUP INVITES ====================
do
        -- o = { Title, Confirm, Max, Exclude, Preselect = { users }, OnConfirm = function(list) }
        function Chat:_MultiPick(o)
                local picked = {}
                for _, u in ipairs(o.Preselect or {}) do if u and u.uid then picked[tostring(u.uid)] = u end end
                local function Count() local n = 0 for _ in pairs(picked) do n = n + 1 end return n end
                local w, h = 290, H(420)
                local frame = Sink(New("Frame", { Size = UDim2.fromOffset(w, h), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0, ZIndex = 85,
                        Theme = { BackgroundColor3 = "Surface" }, Parent = Lib.Overlay }))
                Corner(frame, 8) Stroke(frame, "Stroke", 1, 0)
                New("UIScale", { Scale = math.min(1, Lib.Overlay.AbsoluteSize.X / (w + 20), Lib.Overlay.AbsoluteSize.Y / (h + 20)), Parent = frame })
                New("TextLabel", { Text = o.Title or "Pick people", Font = Lib.FontBold, TextSize = 13, Size = UDim2.new(1, -24, 0, 18), Position = UDim2.fromOffset(12, 10),
                        TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 86, Parent = frame })
                local counter = New("TextLabel", { Text = "", TextSize = 10, Size = UDim2.new(1, -24, 0, 12), Position = UDim2.fromOffset(12, 30), TextXAlignment = LEFT,
                        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 86, Theme = { TextColor3 = "Dim" }, Parent = frame })
                local function Update()
                        local names = {}
                        for _, u in pairs(picked) do table.insert(names, tostring(u.display or u.name)) end
                        table.sort(names)
                        counter.Text = Count() .. " selected" .. (o.Max and (" · up to " .. o.Max) or "") .. (#names > 0 and ("  ·  " .. Short(table.concat(names, ", "), 30)) or "")
                end
                local top, foot = 48, H(28) + 14
                self:PeopleBrowser({ Parent = frame, Position = UDim2.fromOffset(12, top), Size = UDim2.new(1, -24, 1, -(top + foot)), Z = 86, Exclude = o.Exclude,
                        Scopes = { { "friends", "Friends" }, { "online", "Online" }, { "all", "Everyone" } },
                        Scope = #self.Friends.friends > 0 and "friends" or "online",
                        Mark = function(u) return picked[tostring(u.uid)] ~= nil end,
                        OnClick = function(u, refresh)
                                local id = tostring(u.uid)
                                if picked[id] then
                                        picked[id] = nil
                                elseif o.Max and Count() >= o.Max then
                                        Lib:Notify({ Title = "Group chat", Text = "Only " .. o.Max .. " more fit in this group.", Type = "warn", Duration = 4 })
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
                local ok = New("TextButton", { Text = o.Confirm or "Done", TextSize = 12, Size = UDim2.new(0.5, -3, 1, 0), BackgroundTransparency = 0, ZIndex = 87, Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = row })
                Corner(ok, 5)
                cancel.Activated:Connect(function() Lib:ClosePopup() end)
                ok.Activated:Connect(function()
                        local list = {}
                        for _, u in pairs(picked) do list[#list + 1] = u end
                        if #list == 0 then Lib:Notify({ Text = "Pick at least one person.", Type = "warn" }) return end
                        Lib:ClosePopup()
                        Safe(o.OnConfirm, list)
                end)
                Update()
                Lib:OpenPopup(frame, function() if frame.Parent then frame:Destroy() end end)
        end

        -- gid = nil: choose the group first. gid set: tick as many people as you want, one tap invites them all.
        function Chat:InviteToGroup(gid, preselect)
                local groups = {}
                for _, ch in ipairs(self.Channels) do if ch.kind == "grp" then groups[#groups + 1] = ch end end
                if not gid then
                        if #groups == 0 then self:NewGroup(preselect) return end
                        local items = {}
                        for _, g in ipairs(groups) do
                                items[#items + 1] = { Text = "«" .. Short(g.name, 15) .. "»", Callback = function() self:InviteToGroup(g.gid, preselect) end }
                        end
                        items[#items + 1] = { Text = "New group with them...", Callback = function() self:NewGroup(preselect) end }
                        self:Menu(items, self.LastPtr)
                        return
                end
                local ch
                for _, g in ipairs(groups) do if g.gid == gid then ch = g end end
                local exclude, have = {}, 0
                for _, m in ipairs((ch and ch.members) or {}) do
                        local id = type(m) == "table" and m.uid or m
                        exclude[tostring(id)] = true
                        have = have + 1
                end
                exclude[tostring(LocalPlayer.UserId)] = true
                local room = MAX_GROUP - math.max(have, 1)
                if room <= 0 then
                        Lib:Notify({ Title = "Group chat", Text = "That group is full (" .. MAX_GROUP .. " max).", Type = "warn" })
                        return
                end
                local pre = {}
                for _, u in ipairs(preselect or {}) do
                        if u and u.uid and not exclude[tostring(u.uid)] and #pre < room then pre[#pre + 1] = u end
                end
                self:_MultiPick({ Title = "Invite to «" .. Short((ch and ch.name) or "group", 16) .. "»", Confirm = "Invite", Max = room, Exclude = exclude, Preselect = pre,
                        OnConfirm = function(list)
                                local uids = {}
                                for _, u in ipairs(list) do uids[#uids + 1] = tonumber(u.uid) or u.uid end
                                task.spawn(function()
                                        local d = Decode(self:_Do("/group/invite", nil, "POST", HttpService:JSONEncode({ id = gid, uids = uids })))
                                        if d and d.ok then
                                                local n = tonumber(d.added) or #uids
                                                local text = "Invited " .. n .. (n == 1 and " person." or " people.")
                                                if (tonumber(d.skipped) or 0) > 0 then text = text .. " " .. d.skipped .. " didn't fit." end
                                                Lib:Notify({ Title = "Group chat", Text = text, Type = "success", Duration = 4 })
                                                self:_PollOnce()
                                        else
                                                Lib:Notify({ Title = "Group chat", Text = (d and d.error) or "Couldn't invite them. Is your worker updated?", Type = "error" })
                                        end
                                end)
                        end })
        end
end

-- ==================== 6) HOOKS + SETTINGS ====================
P.CreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
        local chat = P.CreateChat(self, cfg)
        if chat and not chat._p47 then
                chat._p47 = true
                Lib:LoadChatPrefs()
                pcall(function() chat:_InitReactUI() end)
                pcall(function() chat:_InitAutoCorrect() end)
        end
        return chat
end

P.BuildSettingsTab = Lib.BuildSettingsTab
function Lib:BuildSettingsTab(window)
        local tab = P.BuildSettingsTab(self, window)
        if tab and not tab._p47 then
                tab._p47 = true
                pcall(function()
                        local prefs = Lib:LoadChatPrefs()
                        local sub = tab.Subs[1]
                        local gb
                        for _, g in ipairs(sub.Groupboxes) do if g.Name == "Chat" then gb = g end end
                        gb = gb or sub:AddRightGroupbox("Chat", { Icon = "message-square", Collapsible = true })
                        gb:AddToggle("ReadReceipts", { Text = "Read receipts (DMs only)", Default = prefs.ReadReceipts, IgnoreConfig = true,
                                Tooltip = "Shows \"Read\" under your last DM once they've seen it, and lets them see when you've read theirs. Off hides both ways.",
                                Callback = function(v)
                                        prefs.ReadReceipts = v and true or false
                                        Lib:SaveChatPrefs()
                                        local c = Lib.ChatObj
                                        if c then
                                                if not v then c.ReadMark = nil end
                                                c:_PlaceRead()
                                        end
                                end })
                        gb:AddToggle("AutoCorrect", { Text = "Auto correct", Default = prefs.AutoCorrect, IgnoreConfig = true,
                                Tooltip = "Fixes typos as you type (and when you send). Backspace right after a fix to undo it.",
                                Callback = function(v) prefs.AutoCorrect = v and true or false Lib:SaveChatPrefs() end })
                        gb:AddDropdown("DoubleTapReact", { Text = "Double-tap reaction", Values = { "👍", "❤️", "😂", "💀", "🔥", "😮", "✅", "❌" }, Default = prefs.DoubleTap, IgnoreConfig = true,
                                Callback = function(v) if v then prefs.DoubleTap = v Lib:SaveChatPrefs() end end })
                end)
        end
        return tab
end

end
-- ===================== end patch 4.7 =====================

-- ===================== Aether patch 4.8 =====================
do
local P = {}
Lib.Version = "4.8.0"

do
        local loaded, tick = false, 0
        local function Path() return Lib.ConfigFolder .. "/chatprefs.json" end
        Lib.ChatPrefs.AutoCorrect = false

        function Lib:LoadChatPrefs()
                if loaded then return self.ChatPrefs end
                loaded = true
                local c = self.ChatPrefs
                c.AutoCorrect = false
                if FsOk() then
                        pcall(function()
                                local p = Path()
                                if not isfile(p) then return end
                                local d = HttpService:JSONDecode(readfile(p))
                                if type(d) ~= "table" then return end
                                if type(d.rr) == "boolean" then c.ReadReceipts = d.rr end
                                if d.acv == 2 and type(d.ac) == "boolean" then c.AutoCorrect = d.ac end
                                if type(d.dbl) == "string" and #d.dbl > 0 and #d.dbl <= 16 then c.DoubleTap = d.dbl end
                                if type(d.recent) == "table" then
                                        c.Recent = {}
                                        for _, e in ipairs(d.recent) do
                                                if type(e) == "string" and #c.Recent < 16 then table.insert(c.Recent, e) end
                                        end
                                end
                        end)
                end
                return c
        end

        function Lib:SaveChatPrefs()
                if not FsOk() then return end
                tick = tick + 1
                local t = tick
                task.delay(0.6, function()
                        if t ~= tick then return end
                        pcall(function()
                                if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                                local c = Lib.ChatPrefs
                                writefile(Path(), HttpService:JSONEncode({ rr = c.ReadReceipts, ac = c.AutoCorrect, acv = 2, dbl = c.DoubleTap, recent = c.Recent }))
                        end)
                end)
        end
end

Lib.EmojiMaxVersion = 13
Lib.EmojiSources = {
        "https://cdn.jsdelivr.net/npm/emojibase-data@15/en/data.json",
        "https://cdn.jsdelivr.net/npm/emojibase-data@15/en/compact.json",
        "https://fastly.jsdelivr.net/npm/emojibase-data@15/en/data.json",
        "https://fastly.jsdelivr.net/npm/emojibase-data@15/en/compact.json",
}

local Emoji = { list = nil, idx = nil, idxVer = nil, loading = false, waiters = {} }

local function EmojiCache() return Lib.ConfigFolder .. "/cache/emoji_v2.json" end

local function Slim(raw)
        local out = {}
        for _, e in ipairs(raw) do
                local ch = e.emoji or e.unicode
                local g = tonumber(e.group)
                if type(ch) == "string" and g and g ~= 2 and g ~= 9 then
                        out[#out + 1] = {
                                e = ch, g = g, v = tonumber(e.version) or 0, o = tonumber(e.order) or 0,
                                n = tostring(e.label or e.annotation or ""):lower(),
                                t = type(e.tags) == "table" and table.concat(e.tags, " "):lower() or "",
                        }
                end
        end
        table.sort(out, function(a, b) return a.o < b.o end)
        return out
end

function Lib:LoadEmojis(cb)
        if Emoji.list then
                if cb then Safe(cb, Emoji.list) end
                return
        end
        if cb then table.insert(Emoji.waiters, cb) end
        if Emoji.loading then return end
        Emoji.loading = true
        task.spawn(function()
                local list
                if FsOk() then
                        pcall(function()
                                local p = EmojiCache()
                                if isfile(p) then
                                        local d = HttpService:JSONDecode(readfile(p))
                                        if type(d) == "table" and #d > 200 then list = d end
                                end
                        end)
                end
                if not list then
                        for _, url in ipairs(Lib.EmojiSources) do
                                local body = Fetch(url)
                                local ok, raw = pcall(function() return HttpService:JSONDecode(body or "") end)
                                if ok and type(raw) == "table" then
                                        local s = Slim(raw)
                                        if #s > 200 then
                                                list = s
                                                if FsOk() then
                                                        pcall(function()
                                                                if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                                                                if not isfolder(Lib.ConfigFolder .. "/cache") then makefolder(Lib.ConfigFolder .. "/cache") end
                                                                writefile(EmojiCache(), HttpService:JSONEncode(s))
                                                        end)
                                                end
                                                break
                                        end
                                end
                        end
                end
                Emoji.list, Emoji.loading = list, false
                local w = Emoji.waiters
                Emoji.waiters = {}
                for _, f in ipairs(w) do Safe(f, list) end
        end)
end

function Lib:ReloadEmojis()
        Emoji.list, Emoji.idx = nil, nil
        pcall(function() if FsOk() and isfile(EmojiCache()) and type(delfile) == "function" then delfile(EmojiCache()) end end)
        self:LoadEmojis()
end

local function EmojiIndex()
        local mv = Lib.EmojiMaxVersion
        if Emoji.idx and Emoji.idxVer == mv then return Emoji.idx end
        local by, all = {}, {}
        for _, x in ipairs(Emoji.list or {}) do
                if x.v <= mv then
                        by[x.g] = by[x.g] or {}
                        table.insert(by[x.g], x.e)
                        all[#all + 1] = x
                end
        end
        Emoji.idx, Emoji.idxVer = { by = by, all = all }, mv
        return Emoji.idx
end

local EmojiGroups = {
        { 0, "😀" }, { 1, "👋" }, { 3, "🐶" }, { 4, "🍔" }, { 5, "🚗" }, { 6, "⚽" }, { 7, "💡" }, { 8, "❤️" },
}
local EmojiFallback = {}
for w in ("👍 ❤️ 😂 💀 🔥 😮 😢 😡 🎉 👏 🙏 💯 ✅ ❌ 🤔 😎 🥺 😭 😍 🤣 😅 😊 😉 🙄 😴 🤯 🥳 😤 🤝 👀 💪 🙌 👌 ✌️ 🤞 💔 💖 ⭐ ✨ ⚡ 🌈 🍕 🍔 🎮 🏆 🚀 💎 🐶 🐱 🦊 🐸"):gmatch("%S+") do
        EmojiFallback[#EmojiFallback + 1] = w
end

function Chat:EmojiPicker(cb, title)
        local Z, W, HH = 130, 340, 440
        local dim = New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.45, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = Z, Parent = Lib.Overlay })
        local card = Sink(New("Frame", { Size = UDim2.fromOffset(W, HH), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = Z + 1,
                Theme = { BackgroundColor3 = "Bg" }, Parent = dim }))
        Corner(card, 10) Stroke(card)
        New("UIScale", { Scale = math.min(1, Lib.Overlay.AbsoluteSize.X / (W + 20), Lib.Overlay.AbsoluteSize.Y / (HH + 20)), Parent = card })
        New("TextLabel", { Text = title or "Pick an emoji", Font = Lib.FontBold, TextSize = 14, Size = UDim2.new(1, -80, 0, 30), Position = UDim2.fromOffset(12, 0),
                TextXAlignment = LEFT, ZIndex = Z + 2, Parent = card })
        local close = New("TextButton", { Text = "Close", TextSize = 12, Size = UDim2.fromOffset(52, 22), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 4),
                BackgroundTransparency = 0, ZIndex = Z + 2, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = card })
        Corner(close, 5)
        local function Close() if dim.Parent then dim:Destroy() end end
        close.Activated:Connect(Close)
        dim.Activated:Connect(Close)

        local search = New("TextBox", { Text = "", PlaceholderText = "Search emoji...  (heart, fire, cat)", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 12,
                Size = UDim2.new(1, -20, 0, 28), Position = UDim2.fromOffset(10, 34), BackgroundTransparency = 0, TextXAlignment = LEFT, ZIndex = Z + 2,
                Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = card })
        Corner(search, 5) Pad(search, 8, 0, 8, 0)

        local tabH, barY = H(30), 68
        local bar = New("Frame", { Size = UDim2.new(1, -20, 0, tabH), Position = UDim2.fromOffset(10, barY), BackgroundTransparency = 1, ZIndex = Z + 2, Parent = card })
        List(bar, 4, Enum.FillDirection.Horizontal)
        local gridY = barY + tabH + 6
        local grid = New("ScrollingFrame", { Size = UDim2.new(1, -16, 1, -(gridY + 44)), Position = UDim2.fromOffset(8, gridY), AutomaticCanvasSize = Y,
                ScrollBarThickness = 3, ZIndex = Z + 2, Parent = card })
        New("UIGridLayout", { CellSize = UDim2.fromOffset(38, 38), CellPadding = UDim2.fromOffset(2, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = grid })
        local status = New("TextLabel", { Text = "Loading emoji...", TextSize = 12, TextWrapped = true, Size = UDim2.new(1, -24, 0, 44), Position = UDim2.fromOffset(12, gridY + 8),
                ZIndex = Z + 4, Theme = { TextColor3 = "Dim" }, Parent = card })

        local data, fallback = nil, false
        local gen, curKey = 0, nil
        local tabs = {}

        local function Highlight(key)
                for k, b in pairs(tabs) do b.BackgroundColor3 = (k == key) and Lib.Theme.Accent or Lib.Theme.Field end
        end

        local function Clear()
                for _, c in ipairs(grid:GetChildren()) do if not c:IsA("UIGridLayout") then c:Destroy() end end
        end

        local function Build(list, emptyText)
                gen = gen + 1
                local my = gen
                Clear()
                status.Visible = #list == 0
                if #list == 0 then status.Text = emptyText or "Nothing here." return end
                task.spawn(function()
                        for i, e in ipairs(list) do
                                if my ~= gen or not dim.Parent then return end
                                local b = New("TextButton", { Text = e, TextSize = 22, LayoutOrder = i, BackgroundTransparency = 1, BackgroundColor3 = Lib.Theme.FieldHover, ZIndex = Z + 3, Parent = grid })
                                Corner(b, 6)
                                b.MouseEnter:Connect(function() Tween(b, { BackgroundTransparency = 0.3 }, 0.06) end)
                                b.MouseLeave:Connect(function() Tween(b, { BackgroundTransparency = 1 }, 0.08) end)
                                b.Activated:Connect(function() Close() Safe(cb, e) end)
                                if i % 40 == 0 then task.wait() end
                        end
                end)
        end

        local function ShowKey(key)
                curKey = key
                Highlight(key)
                if key == "r" then
                        local list = {}
                        for _, e in ipairs(Lib.ChatPrefs.Recent) do list[#list + 1] = e end
                        Build(list, "Nothing here yet. React to something first.")
                elseif fallback then
                        Build(EmojiFallback)
                else
                        Build((data and data.by[key]) or {}, "No emoji in this group.")
                end
        end

        local n = #EmojiGroups + 1
        for i = 1, n do
                local key = i == 1 and "r" or EmojiGroups[i - 1][1]
                local b = New("TextButton", { Text = i == 1 and "🕘" or EmojiGroups[i - 1][2], TextSize = 16, Size = UDim2.new(1 / n, -4, 1, 0), LayoutOrder = i,
                        BackgroundTransparency = 0, ZIndex = Z + 3, Theme = { BackgroundColor3 = "Field" }, Parent = bar })
                Corner(b, 6)
                tabs[key] = b
                b.Activated:Connect(function() search.Text = "" ShowKey(key) end)
        end

        local sTick = 0
        search:GetPropertyChangedSignal("Text"):Connect(function()
                sTick = sTick + 1
                local t = sTick
                task.delay(0.2, function()
                        if t ~= sTick or not dim.Parent then return end
                        local q = Trim(search.Text):lower()
                        if q == "" then
                                if curKey ~= nil then ShowKey(curKey) end
                                return
                        end
                        if not data then
                                Build({}, "Search needs the full emoji list, and it couldn't be downloaded.")
                                return
                        end
                        Highlight(nil)
                        local res = {}
                        for _, x in ipairs(data.all) do
                                if x.n:find(q, 1, true) or x.t:find(q, 1, true) then
                                        res[#res + 1] = x.e
                                        if #res >= 200 then break end
                                end
                        end
                        Build(res, "No emoji match \"" .. q .. "\".")
                end)
        end)

        local box = New("TextBox", { Text = "", PlaceholderText = "Paste any emoji...", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 13, Size = UDim2.new(1, -84, 0, 28),
                AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 10, 1, -8), BackgroundTransparency = 0, TextXAlignment = LEFT, ZIndex = Z + 2,
                Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = card })
        Corner(box, 5) Pad(box, 8, 0, 8, 0)
        local use = New("TextButton", { Text = "Use", TextSize = 12, Size = UDim2.fromOffset(56, 28), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -10, 1, -8),
                BackgroundTransparency = 0, ZIndex = Z + 2, Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = card })
        Corner(use, 5)
        local function Take()
                local t = Trim(box.Text)
                if t == "" then return end
                Close()
                Safe(cb, t)
        end
        use.Activated:Connect(Take)
        box.FocusLost:Connect(function(enter) if enter then Take() end end)

        local function Ready(list)
                if not dim.Parent then return end
                if list then
                        data = EmojiIndex()
                else
                        fallback = true
                        status.Text = "Couldn't download the emoji list (needs HTTP access). Showing a small set. You can still paste any emoji below."
                end
                ShowKey(#Lib.ChatPrefs.Recent > 0 and "r" or EmojiGroups[1][1])
                if fallback then
                        status.Visible = true
                        status.Position = UDim2.fromOffset(12, gridY)
                        grid.Position = UDim2.fromOffset(8, gridY + 50)
                        grid.Size = UDim2.new(1, -16, 1, -(gridY + 50 + 44))
                end
        end
        Lib:LoadEmojis(Ready)
end

P.CreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
        local chat = P.CreateChat(self, cfg)
        task.delay(3, function() if not Lib.Unloaded then Lib:LoadEmojis() end end)
        return chat
end

end
-- ===================== end patch 4.8 =====================

-- ===================== Aether patch 4.9.1 =====================
do
local P = {}
Lib.Version = "4.9.1"

Lib.ChatName = ""

do
        local loaded, applyTick = false, 0
        local function Path() return Lib.ConfigFolder .. "/chatname.txt" end

        local function Clean(t)
                t = tostring(t or "")
                t = (t:gsub("%c", " "))
                t = (t:gsub("%s+", " "))
                t = Trim(t)
                local n = utf8.len(t)
                if n and n > 24 then t = t:sub(1, utf8.offset(t, 25) - 1) elseif not n then t = t:sub(1, 24) end
                return t
        end

        function Lib:LoadChatName()
                if loaded then return self.ChatName end
                loaded = true
                if FsOk() then
                        pcall(function()
                                local p = Path()
                                if isfile(p) then self.ChatName = Clean(readfile(p)) end
                        end)
                end
                return self.ChatName
        end

        function Lib:SetChatName(t)
                t = Clean(t)
                self:LoadChatName()
                applyTick = applyTick + 1
                local my = applyTick
                task.delay(1, function()
                        if my ~= applyTick or Lib.Unloaded then return end
                        Lib.ChatName = t
                        if FsOk() then
                                pcall(function()
                                        if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                                        writefile(Path(), t)
                                end)
                        end
                end)
        end
end

function Chat:_InitChatName()
        if self._nameWrap or type(self.Request) ~= "function" then return end
        self._nameWrap = true
        local raw = self.Request
        self.Request = function(req, ...)
                local n = Lib:LoadChatName()
                if n ~= "" and type(req) == "table" and type(req.Url) == "string" then
                        local enc = UrlEncode(n)
                        req.Url = (req.Url:gsub("([%?&])display=[^&]*", function(p) return p .. "display=" .. enc end))
                end
                return raw(req, ...)
        end
end

function Chat:Menu(items, anchor)
        local usable = {}
        for _, it in ipairs(items) do if it.Text and it.Text ~= "" then table.insert(usable, it) end end
        if #usable == 0 then return end
        local w, rh = 190, H(26)
        local h = 6
        for _, it in ipairs(usable) do h = h + (it.Header and H(18) or rh) end
        local sc = Lib.Scale
        local maxH = math.max(120, (Lib.Overlay.AbsoluteSize.Y - 16) / sc)
        local shownH = math.min(h, maxH)
        local menu = Sink(New("Frame", { Size = UDim2.fromOffset(w, shownH), BackgroundTransparency = 0, ZIndex = 85, Theme = { BackgroundColor3 = "Surface" }, Parent = Lib.Overlay }))
        Corner(menu, 6) Stroke(menu, "Stroke", 1, 0)
        New("UIScale", { Scale = sc, Parent = menu })
        local scroll = New("ScrollingFrame", { Size = UDim2.new(1, -6, 1, -6), Position = UDim2.fromOffset(3, 3), AutomaticCanvasSize = Y, ScrollBarThickness = 2, ZIndex = 86, Parent = menu })
        List(scroll, 0)
        for i, it in ipairs(usable) do
                if it.Header then
                        New("TextLabel", { Text = it.Text, Font = Lib.FontBold, TextSize = 9, Size = UDim2.new(1, 0, 0, H(18)), LayoutOrder = i, TextXAlignment = LEFT, ZIndex = 87,
                                Theme = { TextColor3 = "Dim" }, Parent = scroll })
                else
                        local b = New("TextButton", { Text = it.Text, TextSize = 12, Size = UDim2.new(1, 0, 0, rh), LayoutOrder = i, TextXAlignment = LEFT, ZIndex = 87,
                                BackgroundTransparency = 1, BackgroundColor3 = Lib.Theme.FieldHover, TextColor3 = it.Danger and Lib.Theme.Bad or Lib.Theme.Text, TextTruncate = Enum.TextTruncate.AtEnd, Parent = scroll })
                        Corner(b, 4) Pad(b, 9, 0, 8, 0)
                        b.MouseEnter:Connect(function() Tween(b, { BackgroundTransparency = 0.3 }, 0.06) end)
                        b.MouseLeave:Connect(function() Tween(b, { BackgroundTransparency = 1 }, 0.08) end)
                        Press(b, function() Lib:ClosePopup() Safe(it.Callback) end)
                end
        end
        local pos
        if typeof(anchor) == "Instance" then
                local hh
                pos, hh = PlaceBelow(anchor, w * sc, shownH * sc, 4, false)
                menu.Size = UDim2.fromOffset(w, math.min(shownH, math.max(hh / sc, 60)))
        else
                pos = PlaceAt(anchor, w * sc, shownH * sc)
        end
        menu.Position = UDim2.fromOffset(pos.X, pos.Y)
        Lib:OpenPopup(menu, function() menu:Destroy() end, typeof(anchor) == "Instance" and anchor or nil)
end

function Chat:LeaveGroup(ch)
        ch = ch or self.Channels[self.ChIndex]
        if not ch or ch.kind ~= "grp" then return end
        local owner = tonumber(ch.creator or ch.owner) == LocalPlayer.UserId
        local alone = #(ch.members or {}) <= 1
        local text = "Leave «" .. tostring(ch.name) .. "»? Someone has to invite you back in."
        if owner and alone then
                text = "You're the only one in «" .. tostring(ch.name) .. "». Leaving closes the group."
        elseif owner then
                text = "You're the owner of «" .. tostring(ch.name) .. "». If you leave, the member who's been here longest becomes the owner. You can pick someone yourself first with \"Make owner...\"."
        end
        Lib:Dialog({ Title = "Leave group", Text = text,
                Buttons = { { Text = "Cancel" }, { Text = "Leave", Primary = true, Callback = function()
                        task.spawn(function()
                                local d = Decode(self:_Do("/group/leave", nil, "POST", HttpService:JSONEncode({ id = ch.gid })))
                                if d and d.ok then
                                        self:_RemoveChannel(ch)
                                        Lib:Notify({ Title = "Group chat", Text = (d.closed and "Closed «" or "You left «") .. tostring(ch.name) .. "».", Type = "success", Duration = 3 })
                                else
                                        Lib:Notify({ Title = "Group chat", Text = (d and d.error) or "Couldn't leave the group.", Type = "error" })
                                end
                        end)
                end } } })
end

function Chat:TransferOwner(ch)
        ch = ch or self.Channels[self.ChIndex]
        if not ch or ch.kind ~= "grp" then return end
        if tonumber(ch.creator or ch.owner) ~= LocalPlayer.UserId then
                Lib:Notify({ Title = "Group chat", Text = "Only the owner can do that.", Type = "warn" })
                return
        end
        local items = { { Header = true, Text = "MAKE OWNER" } }
        for _, m in ipairs(ch.members or {}) do
                local uid = tonumber(type(m) == "table" and m.uid or m)
                if uid and uid ~= LocalPlayer.UserId then
                        local nm = type(m) == "table" and tostring((m.display ~= nil and m.display ~= "") and m.display or m.name or uid) or ("user " .. uid)
                        table.insert(items, { Text = Short(nm, 22), Callback = function()
                                Lib:Dialog({ Title = "Make owner", Text = "Make " .. nm .. " the owner of «" .. tostring(ch.name) .. "»? Only owners can rename the group and hand it over.",
                                        Buttons = { { Text = "Cancel" }, { Text = "Make owner", Primary = true, Callback = function()
                                                task.spawn(function()
                                                        local d = Decode(self:_Do("/group/owner", nil, "POST", HttpService:JSONEncode({ id = ch.gid, uid = uid })))
                                                        if d and d.ok then
                                                                ch.creator, ch.owner = uid, uid
                                                                Lib:Notify({ Title = "Group chat", Text = nm .. " is now the owner.", Type = "success", Duration = 3 })
                                                                self:_RefreshChannel()
                                                                self:_PollOnce()
                                                        else
                                                                Lib:Notify({ Title = "Group chat", Text = (d and d.error) or "Couldn't hand it over. Is your worker updated?", Type = "error" })
                                                        end
                                                end)
                                        end } } })
                        end })
                end
        end
        if #items == 1 then
                Lib:Notify({ Title = "Group chat", Text = "Nobody else is in this group yet.", Type = "warn" })
                return
        end
        self:Menu(items, self.ChBtn)
end

function Chat:_InitLeave()
        if self.LeaveBtn or not self.ChBtn then return end
        local api = IconButton(self.ChBtn, "log-out", ">", 20, "Leave group", "Bad", 1)
        api.Button.AnchorPoint, api.Button.Position, api.Button.Visible = Vector2.new(1, 0.5), UDim2.new(1, -28, 0.5, 0), false
        api.Button.ZIndex = 5
        api.Button.Activated:Connect(function() self:LeaveGroup() end)
        self.LeaveBtn = api
        self:_RefreshChannel()
end

P.RefreshChannel = Chat._RefreshChannel
function Chat:_RefreshChannel()
        P.RefreshChannel(self)
        pcall(function()
                if not self.LeaveBtn then return end
                local ch = self.Channels[self.ChIndex]
                local g = ch ~= nil and ch.kind == "grp"
                self.LeaveBtn.Button.Visible = g
                self.ChLabel.Size = UDim2.new(1, g and -56 or -30, 1, 0)
        end)
end

local function CanPin(chat)
        local r = chat.Room
        return type(r) == "string" and (r:sub(1, 3) == "dm:" or r:sub(1, 4) == "grp:")
end

local function PinWho(p)
        if p.type == "announce" then return "Announcement" end
        local n = (p.display ~= nil and p.display ~= "") and p.display or p.name
        return tostring(n or "?")
end

local function PinText(p)
        local t = tostring(p.text or "")
        if t == "" then return "[attachment]" end
        return t
end

function Chat:PinMessage(msg, on)
        if not (msg and msg.id and self.Request) then return end
        local room = self.Room
        task.spawn(function()
                local d = Decode(self:_Do(on and "/pin" or "/unpin", nil, "POST", HttpService:JSONEncode({ id = msg.id }), room))
                if d and d.ok then
                        if room == self.Room then
                                if type(d.pinned) == "table" then self:SetPinned(d.pinned) end
                                self:_PollOnce()
                        end
                        Lib:Notify({ Title = "Pins", Text = on and "Message pinned." or "Message unpinned.", Type = "success", Duration = 2.5 })
                else
                        Lib:Notify({ Title = "Pins", Text = (d and d.error) or ("Couldn't " .. (on and "pin" or "unpin") .. " that. Your worker needs /pin and /unpin for groups and DMs."),
                                Type = "error", Duration = 6 })
                end
        end)
end

function Chat:_GotoPinned(p)
        if p.id and self.ByLid[p.id] then
                self.Stick = false
                self:_JumpTo(p.id)
        else
                Lib:Dialog({ Title = "Pinned by " .. tostring(p.by or "someone"), Text = PinWho(p) .. ": " .. PinText(p) })
        end
end

function Chat:ShowPins()
        local list = self.Pinned or {}
        local canUn = CanPin(self)
        local Z, W, HH = 140, 340, 400
        local dim = New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.45, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = Z, Parent = Lib.Overlay })
        local card = Sink(New("Frame", { Size = UDim2.fromOffset(W, HH), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = Z + 1,
                Theme = { BackgroundColor3 = "Bg" }, Parent = dim }))
        Corner(card, 10) Stroke(card)
        New("UIScale", { Scale = math.min(1, Lib.Overlay.AbsoluteSize.X / (W + 20), Lib.Overlay.AbsoluteSize.Y / (HH + 20)), Parent = card })
        New("TextLabel", { Text = "Pinned messages · " .. #list, Font = Lib.FontBold, TextSize = 14, Size = UDim2.new(1, -80, 0, 30), Position = UDim2.fromOffset(12, 0),
                TextXAlignment = LEFT, ZIndex = Z + 2, Parent = card })
        local close = New("TextButton", { Text = "Close", TextSize = 12, Size = UDim2.fromOffset(52, 22), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 4),
                BackgroundTransparency = 0, ZIndex = Z + 2, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = card })
        Corner(close, 5)
        local function Close() if dim.Parent then dim:Destroy() end end
        close.Activated:Connect(Close)
        dim.Activated:Connect(Close)
        local scroll = New("ScrollingFrame", { Size = UDim2.new(1, -16, 1, -42), Position = UDim2.fromOffset(8, 34), AutomaticCanvasSize = Y, ScrollBarThickness = 2, ZIndex = Z + 2, Parent = card })
        List(scroll, 4)
        if #list == 0 then
                New("TextLabel", { Text = canUn and "Nothing pinned yet. Right-click (or long-press) a message and choose Pin Message." or "Nothing pinned here yet.",
                        TextSize = 12, TextWrapped = true, Size = UDim2.new(1, 0, 0, 44), ZIndex = Z + 3, Theme = { TextColor3 = "Dim" }, Parent = scroll })
        end
        for i, p in ipairs(list) do
                local row = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, H(50)), LayoutOrder = i, BackgroundTransparency = 0, ZIndex = Z + 3,
                        Theme = { BackgroundColor3 = "Field" }, Parent = scroll })
                Corner(row, 6)
                local reserve = canUn and 76 or 16
                New("TextLabel", { Text = PinWho(p), Font = Lib.FontBold, TextSize = 12, Size = UDim2.new(1, -reserve, 0, 16), Position = UDim2.fromOffset(10, 6),
                        TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = Z + 4, Parent = row })
                New("TextLabel", { Text = PinText(p), TextSize = 12, Size = UDim2.new(1, -reserve, 0, 16), Position = UDim2.fromOffset(10, 24),
                        TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = Z + 4, Theme = { TextColor3 = "SubText" }, Parent = row })
                if canUn then
                        local ub = New("TextButton", { Text = "Unpin", TextSize = 11, Size = UDim2.fromOffset(54, 24), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
                                BackgroundTransparency = 0, ZIndex = Z + 5, Theme = { BackgroundColor3 = "FieldHover", TextColor3 = "Bad" }, Parent = row })
                        Corner(ub, 4)
                        ub.Activated:Connect(function() Close() self:PinMessage(p, false) end)
                end
                row.MouseEnter:Connect(function() Tween(row, { BackgroundColor3 = Lib.Theme.FieldHover }, 0.06) end)
                row.MouseLeave:Connect(function() Tween(row, { BackgroundColor3 = Lib.Theme.Field }, 0.08) end)
                row.Activated:Connect(function() Close() self:_GotoPinned(p) end)
        end
end

function Chat:_InitPins()
        if self._pinUI or not self.PinBar then return end
        self._pinUI = true
        self.PinText.Size = UDim2.new(1, -136, 1, 0)
        self.PinCount.Visible = false
        self.PinListBtn = New("TextButton", { Name = "PinList", Text = "", TextSize = 11, Size = UDim2.fromOffset(74, 28), AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -28, 0, 0), Theme = { TextColor3 = "Accent" }, Parent = self.PinBar })
        self.PinListBtn.Activated:Connect(function() self:ShowPins() end)
        self.PinX.Button.Activated:Connect(function()
                local p = self.Pinned[self.PinIdx]
                if p and CanPin(self) then self:PinMessage(p, false) end
        end)
        self:_RefreshPin()
end

P.RefreshPin = Chat._RefreshPin
function Chat:_RefreshPin()
        P.RefreshPin(self)
        pcall(function()
                if not self._pinUI then return end
                self.PinCount.Visible = false
                local n = #self.Pinned
                self.PinListBtn.Text = n .. (n == 1 and " pin" or " pins") .. " ▾"
                self.PinX.Button.Visible = n > 0 and CanPin(self)
        end)
end

P.MenuItems = Chat._MenuItems
function Chat:_MenuItems(msg)
        local groups = P.MenuItems(self, msg)
        if msg and msg.id and CanPin(self) and type(groups[1]) == "table" then
                local pinned = self:_IsPinned(msg.id)
                table.insert(groups[1], { Text = pinned and "Unpin Message" or "Pin Message", Icon = "pin", Cb = function() self:PinMessage(msg, not pinned) end })
        end
        return groups
end

P.Menu = Chat.Menu
function Chat:Menu(items, anchor)
        local picker = items[1] and items[1].Header and items[1].Text == "MAKE OWNER"
        if anchor ~= nil and anchor == self.ChBtn and not picker then
                local cur = self.Channels[self.ChIndex]
                local mine, keep = {}, {}
                for _, it in ipairs(items) do
                        local t = it.Text
                        if t == "Rename group..." or t == "Invite member..." or t == "Leave group" or t == "Close this DM" then
                                if t == "Leave group" and cur and cur.kind == "grp" then it.Callback = function() self:LeaveGroup(cur) end end
                                table.insert(mine, it)
                        else
                                table.insert(keep, it)
                        end
                end
                if cur and cur.kind == "grp" and tonumber(cur.creator or cur.owner) == LocalPlayer.UserId then
                        local at = 1
                        for i, it in ipairs(mine) do if it.Text == "Invite member..." then at = i + 1 end end
                        table.insert(mine, at, { Text = "Make owner...", Callback = function() self:TransferOwner(cur) end })
                end
                local out = {}
                if #mine > 0 then
                        table.insert(out, { Header = true, Text = (cur and cur.kind == "grp") and "THIS GROUP" or "THIS DM" })
                        for _, it in ipairs(mine) do table.insert(out, it) end
                end
                for _, it in ipairs(keep) do table.insert(out, it) end
                items = out
                local at
                for i, it in ipairs(items) do
                        if it.Header and it.Text == "START" then at = i break end
                end
                table.insert(items, at and (at + 1) or (#items + 1), { Text = "Pinned messages (" .. #self.Pinned .. ")...", Callback = function() self:ShowPins() end })
        end
        return P.Menu(self, items, anchor)
end

P.CreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
        local chat = P.CreateChat(self, cfg)
        if chat then
                pcall(function() chat:_InitChatName() end)
                pcall(function() chat:_InitPins() end)
                pcall(function() chat:_InitLeave() end)
        end
        return chat
end

P.BuildSettingsTab = Lib.BuildSettingsTab
function Lib:BuildSettingsTab(window)
        local tab = P.BuildSettingsTab(self, window)
        if tab and not tab._p49 then
                tab._p49 = true
                pcall(function()
                        local sub = tab.Subs[1]
                        local gb
                        for _, g in ipairs(sub.Groupboxes) do if g.Name == "Chat" then gb = g end end
                        gb = gb or sub:AddRightGroupbox("Chat", { Icon = "message-square", Collapsible = true })
                        gb:AddInput("__ChatName", { Text = "Chat display name", Placeholder = "What people should call you", Default = Lib:LoadChatName(), MaxLength = 24, IgnoreConfig = true,
                                Tooltip = "The name shown on your chat messages. Empty = your Roblox display name.",
                                Callback = function(v) Lib:SetChatName(v) end })
                        gb:AddButton({ Text = "Use my Roblox name", Func = function()
                                Lib:SetChatName("")
                                local o = Lib.Options.__ChatName
                                if o then o:SetValue("", true) end
                                Lib:Notify({ Title = "Chat", Text = "Using your Roblox display name again.", Type = "success", Duration = 2.5 })
                        end })
                        gb:AddLabel("New messages use this name. Messages you already sent keep the name they had.")
                end)
        end
        return tab
end

end
-- ===================== end patch 4.9.1 =====================

-- ===================== Aether patch 5.0 =====================
do
local P = {}
Lib.Version = "5.0.0"

Lib.ChatState = { drafts = {}, favs = {}, reads = {}, layout = "Discord" }
do
    local loaded, tick = false, 0
    local function Path() return Lib.ConfigFolder .. "/chatstate.json" end

    function Lib:LoadChatState()
        if loaded then return self.ChatState end
        loaded = true
        if FsOk() then
            pcall(function()
                local p = Path()
                if not isfile(p) then return end
                local d = HttpService:JSONDecode(readfile(p))
                if type(d) ~= "table" then return end
                local S = self.ChatState
                if type(d.drafts) == "table" then
                    for k, v in pairs(d.drafts) do if type(k) == "string" and type(v) == "string" then S.drafts[k] = v:sub(1, 500) end end
                end
                if type(d.favs) == "table" then
                    for k, v in pairs(d.favs) do if type(k) == "string" and v == true then S.favs[k] = true end end
                end
                if type(d.reads) == "table" then
                    for k, v in pairs(d.reads) do if type(k) == "string" and type(v) == "number" then S.reads[k] = v end end
                end
                if d.layout == "Compact" or d.layout == "Discord" then S.layout = d.layout end
            end)
        end
        return self.ChatState
    end

    function Lib:SaveChatState()
        if not FsOk() then return end
        tick = tick + 1
        local t = tick
        task.delay(0.8, function()
            if t ~= tick then return end
            pcall(function()
                if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                writefile(Path(), HttpService:JSONEncode(Lib.ChatState))
            end)
        end)
    end
end

function Lib:SetFav(room, on)
    local S = self:LoadChatState()
    S.favs[room] = on and true or nil
    self:SaveChatState()
    local c = self.ChatObj
    if c then c:_QueueSidebar() end
end

function Lib:_HookTeleportFail()
    if self._tpHooked then return end
    self._tpHooked = true
    pcall(function()
        Lib:Connect(Teleport.TeleportInitFailed, function(_, result, msg)
            local j = Lib._join
            if not j then return end
            Lib._join = nil
            local name = result and result.Name
            if j.refresh and (name == "GameEnded" or name == "GameNotFound" or name == "Failure") then
                j.refresh(function(p, jb)
                    if p and jb and jb ~= "" and jb ~= j.job then
                        Lib:Notify({ Title = "Join", Text = "They moved servers, following...", Type = "info", Duration = 2.5 })
                        Lib:JoinServer(p, jb, j.label)
                    else
                        Lib:JoinFailed(j.place, j.job, j.label, result, msg)
                    end
                end)
                return
            end
            Lib:JoinFailed(j.place, j.job, j.label, result, msg)
        end)
    end)
end

function Lib:JoinServer(place, job, label, refresh)
    place, label = tonumber(place), label or "that server"
    job = job and tostring(job) or nil
    if not place or not job or job == "" then
        Lib:Notify({ Title = "Join", Text = "There's no server to join.", Type = "warn" })
        return
    end
    local busy = self._join
    if busy and os.clock() - busy.t0 < 15 then
        Lib:Notify({ Title = "Join", Text = "Already joining, give it a moment.", Type = "info", Duration = 2 })
        return
    end
    self:_HookTeleportFail()
    local j = { place = place, job = job, label = label, refresh = refresh, t0 = os.clock() }
    self._join = j
    Lib:Notify({ Title = "Join", Text = "Teleporting to " .. label .. "...", Type = "info", Duration = 3 })
    local ok, err = pcall(function() Teleport:TeleportToPlaceInstance(place, job, LocalPlayer) end)
    if not ok then
        self._join = nil
        self:JoinFailed(place, job, label, nil, tostring(err))
        return
    end
    task.delay(25, function()
        if self._join == j then
            self._join = nil
            Lib:Notify({ Title = "Join", Text = "Roblox didn't respond. Try again.", Type = "warn" })
        end
    end)
end

function Chat:JoinFriend(u)
    local uid = tostring(u.uid)
    local name = tostring(u.display or u.name or "friend")
    Lib:Notify({ Title = "Join", Text = "Finding " .. name .. "'s server...", Type = "info", Duration = 2 })
    local function Fresh(cb)
        self:RefreshFriends(function()
            local f = self.Friends.byId[uid]
            cb(f and tonumber(f.place), f and f.job and tostring(f.job))
        end)
    end
    self:RefreshFriends(function()
        local f = self.Friends.byId[uid] or u
        if f.priv == true or f.priv == 1 or f.priv == "1" then
            Lib:Notify({ Title = "Join", Text = name .. " is in a private server. Ask them for the invite link.", Type = "warn", Duration = 5 })
            return
        end
        local place, job = tonumber(f.place), f.job and tostring(f.job)
        if not place or not job or job == "" then
            Lib:Notify({ Title = "Join", Text = name .. " isn't sharing a server right now.", Type = "warn" })
            return
        end
        if job == game.JobId then
            Lib:Notify({ Title = "Join", Text = "You're already in their server.", Type = "info" })
            return
        end
        Lib:JoinServer(place, job, name, Fresh)
    end)
end

function Chat:_FriendByLabel(text)
    local best
    for _, u in ipairs(self.Friends.friends) do
        if tostring(u.display or u.name) == text or tostring(u.name) == text then
            if not best or (tonumber(u.place) or 0) > (tonumber(best.place) or 0) then best = u end
        end
    end
    return best
end

local function AddJoin(self, d)
    if not (d.Parent and d:IsA("TextButton") and d.Text == "Message") then return end
    local row = d.Parent
    if not row:IsA("TextButton") or row:FindFirstChild("JoinBtn") then return end
    local lab = row:FindFirstChildWhichIsA("TextLabel")
    local u = lab and self:_FriendByLabel(lab.Text)
    if not u or not self.Friends.online[tostring(u.uid)] then return end
    local place, job = tonumber(u.place), u.job and tostring(u.job)
    local priv = u.priv == true or u.priv == 1 or u.priv == "1"
    if not place or not job or job == "" or job == game.JobId or priv then return end
    for _, c in ipairs(row:GetChildren()) do
        if c:IsA("TextLabel") then c.Size = UDim2.new(c.Size.X.Scale, c.Size.X.Offset - 58, 0, c.Size.Y.Offset) end
    end
    local jb = New("TextButton", { Name = "JoinBtn", Text = "Join", TextSize = 11, Size = UDim2.fromOffset(54, H(24)), AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -64, 0.5, 0), BackgroundTransparency = 0, ZIndex = d.ZIndex, TextColor3 = Color3.fromRGB(12, 16, 12),
        Theme = { BackgroundColor3 = "Good" }, Parent = row })
    Corner(jb, 4)
    jb.Activated:Connect(function() self:JoinFriend(u) end)
end

P.ShowFriends = Chat.ShowFriends
function Chat:ShowFriends(startTab)
    local before = {}
    for _, c in ipairs(Lib.Overlay:GetChildren()) do before[c] = true end
    P.ShowFriends(self, startTab)
    local dim
    for _, c in ipairs(Lib.Overlay:GetChildren()) do
        if not before[c] and c:IsA("TextButton") then dim = c end
    end
    if not dim then return end
    for _, d in ipairs(dim:GetDescendants()) do pcall(AddJoin, self, d) end
    dim.DescendantAdded:Connect(function(d) task.defer(function() pcall(AddJoin, self, d) end) end)
end

Lib._CfgPrev = {}

function Lib:_FeatureText(data)
    local on, off, sl, dd, kb = {}, 0, 0, 0, 0
    for idx, v in pairs(data) do
        if type(v) == "table" and type(v.Type) == "string" and not tostring(idx):find("^__") then
            local o = self.Options[idx]
            if not (o and o.Info and o.Info.IgnoreConfig) then
                local t = v.Type
                if t == "Toggle" then
                    if v.Value == true then
                        local n = o and o.Info and o.Info.Text
                        if type(n) ~= "string" or n == "" then n = (tostring(idx):gsub("(%l)(%u)", "%1 %2")) end
                        local s = RichEsc(n)
                        if o and o.Info and o.Info.Risky then s = "<font color='#" .. Hex("Bad") .. "'>" .. s .. "</font>" end
                        if not o then s = s .. " <font color='#" .. Hex("Dim") .. "'>(not in this hub)</font>" end
                        on[#on + 1] = { key = n:lower(), s = s }
                    else
                        off = off + 1
                    end
                elseif t == "Slider" or t == "Range" then sl = sl + 1
                elseif t == "Dropdown" or t == "Segmented" or t == "Input" then dd = dd + 1
                elseif t == "KeyPicker" then kb = kb + 1 end
            end
        end
    end
    table.sort(on, function(a, b) return a.key < b.key end)
    local lines = { "<b>" .. #on .. " feature" .. (#on == 1 and "" or "s") .. " turned on</b>" }
    lines[2] = "<font color='#" .. Hex("Dim") .. "'>" .. off .. " off · " .. sl .. " sliders · " .. dd .. " dropdowns/inputs · " .. kb .. " keybinds</font>"
    if #on == 0 then lines[#lines + 1] = "Nothing is switched on in this config." end
    for i = 1, math.min(#on, 20) do lines[#lines + 1] = "• " .. on[i].s end
    if #on > 20 then lines[#lines + 1] = "<font color='#" .. Hex("Dim") .. "'>+" .. (#on - 20) .. " more</font>" end
    return table.concat(lines, "\n")
end

P.BuildConfigCard = Lib._BuildConfigCard
function Lib:_BuildConfigCard(chat, parent, cfg, order)
    P.BuildConfigCard(self, chat, parent, cfg, order)
    local ok, err = pcall(function()
        local card = parent:FindFirstChild("ConfigCard")
        if not card then return end
        local id = tostring(cfg.id or "")
        local copyBtn
        for _, c in ipairs(card:GetChildren()) do
            if c:IsA("TextLabel") then c.Size = UDim2.new(c.Size.X.Scale, c.Size.X.Offset - 64, 0, c.Size.Y.Offset)
            elseif c:IsA("TextButton") then copyBtn = c end
        end
        if not copyBtn then return end
        copyBtn.AnchorPoint, copyBtn.Position = Vector2.new(1, 0), UDim2.new(1, -8, 0, 11)
        local pv = New("TextButton", { Text = "Preview", TextSize = 11, Size = UDim2.fromOffset(56, 28), AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -72, 0, 11), BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = card })
        Corner(pv, 6)
        local open, lbl = false, nil
        local function Close()
            open = false
            pv.Text = "Preview"
            if lbl then lbl:Destroy() lbl = nil end
            card.Size = UDim2.new(1, 0, 0, 50)
        end
        pv.Activated:Connect(function()
            if open then Close() return end
            open = true
            pv.Text = "Hide"
            lbl = New("TextLabel", { Name = "CfgFeatures", RichText = true, Text = "Loading...", TextSize = 12, Size = UDim2.new(1, -28, 0, 14), Position = UDim2.fromOffset(14, 54),
                TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top, Theme = { TextColor3 = "SubText" }, Parent = card })
            Wrap(lbl, card, 66, 14)
            local my = lbl
            local function Fill(data) if lbl == my and my.Parent then my.Text = Lib:_FeatureText(data) end end
            if Lib._CfgPrev[id] then Fill(Lib._CfgPrev[id]) return end
            task.spawn(function()
                local d = Decode(chat:_Do("/cfg", { id = id }))
                local data
                if d and d.ok and type(d.data) == "string" and #d.data <= 60000 then
                    local dec, t = pcall(HttpService.JSONDecode, HttpService, d.data)
                    if dec and type(t) == "table" then data = t end
                end
                if not data then
                    if lbl == my and my.Parent then my.Text = (d and d.error == "expired") and "That config has expired." or "Couldn't load the preview." end
                    return
                end
                Lib._CfgPrev[id] = data
                Fill(data)
            end)
        end)
    end)
    if not ok then warn("[Aether] config preview: " .. tostring(err)) end
end

function Chat:_ClampItem(item)
    local col = item and item:FindFirstChild("Col")
    if not col then return end
    local cap = math.max(self.Frame.Size.X.Offset - (self.Wide and self.SBW or 0) - 66, 160)
    if col.Size.X.Offset > cap then col.Size = UDim2.new(0, cap, 0, 0) end
    local bubble = col:FindFirstChild("Bubble")
    if bubble and bubble.Size.X.Offset > cap then bubble.Size = UDim2.new(0, cap, 0, 0) end
end

for _, nm in ipairs({ "_RefitBubble", "_StyleHead", "_RenderReactions" }) do
    local orig = Chat[nm]
    if orig then
        Chat[nm] = function(self, item, ...)
            local r = orig(self, item, ...)
            pcall(self._ClampItem, self, item)
            return r
        end
    end
end

function Chat:_PlaceDivider(item)
    self.Counter = self.Counter + 1
    local div = New("Frame", { Name = "NewDivider", Size = UDim2.new(1, 0, 0, H(22)), BackgroundTransparency = 1, LayoutOrder = item.LayoutOrder, Parent = self.List })
    item.LayoutOrder = self.Counter
    New("Frame", { Size = UDim2.new(1, -8, 0, 1), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 4, 0.5, 0), BackgroundTransparency = 0.35,
        Theme = { BackgroundColor3 = "Bad" }, Parent = div })
    local pill = New("TextLabel", { Text = "NEW", Font = Lib.FontBold, TextSize = 10, AutomaticSize = X, Size = UDim2.fromOffset(0, 14), AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -6, 0.5, 0), BackgroundTransparency = 0, TextColor3 = WHITE, Theme = { BackgroundColor3 = "Bad" }, Parent = div })
    Corner(pill, 7) Pad(pill, 6, 0, 6, 0)
    table.insert(self.Items, #self.Items, div)
    self._div, self._divCount = div, 0
end

function Chat:_UpdateNewBar()
    local bar, div = self.NewBar, self._div
    if not bar then return end
    if not (div and div.Parent) then bar.Visible = false return end
    local n = self._divCount or 1
    bar.Text = "↑ " .. n .. " new message" .. (n == 1 and "" or "s") .. " · Jump"
    bar.Visible = (div.AbsolutePosition.Y + div.AbsoluteSize.Y) < (self.List.AbsolutePosition.Y + 6)
end

P.ClearAll = Chat._ClearAll
function Chat:_ClearAll()
    P.ClearAll(self)
    self._div, self._divCount = nil, 0
    if self.NewBar then self.NewBar.Visible = false end
end

P.Relayout = Chat._Relayout
function Chat:_Relayout()
    P.Relayout(self)
    if self.NewBar then self.NewBar.Position = UDim2.new(0.5, 0, 0, self.Top + 4) end
end

P.AddMessage = Chat.AddMessage
function Chat:AddMessage(msg)
    local last = self.Items[#self.Items]
    local res = P.AddMessage(self, msg)
    local item = self.Items[#self.Items]
    if item and item ~= last and type(msg) == "table" and (msg.type == nil or msg.type == "msg") and self.Meta[item] then
        pcall(function()
            self:_ClampItem(item)
            local mine = tostring(msg.uid) == tostring(LocalPlayer.UserId)
            local isNew = self._divAt and type(msg.id) == "number" and msg.id > self._divAt and not mine
            if isNew and not self._div and not self.Loaded then
                local hasPrior = false
                for _, it in ipairs(self.Items) do
                    if it == item then break end
                    if self.Meta[it] then hasPrior = true break end
                end
                if hasPrior then self:_PlaceDivider(item) end
            end
            if isNew and self._div then
                self._divCount = (self._divCount or 0) + 1
                task.defer(function() self:_UpdateNewBar() end)
            end
        end)
    end
    return res
end

P.SetChannel = Chat.SetChannel
function Chat:SetChannel(i)
    local ch = self.Channels[i]
    if not ch or i == self.ChIndex then return P.SetChannel(self, i) end
    local S = Lib:LoadChatState()
    local old = self.Channels[self.ChIndex]
    if old then
        local t = self.Input.Text
        S.drafts[old.room] = (Trim(t) ~= "") and t:sub(1, 500) or nil
        if self.PanelObj._shown and self.LastId and self.LastId > 0 then S.reads[old.room] = self.LastId end
    end
    local r = math.max(tonumber(ch.read) or 0, S.reads[ch.room] or 0)
    self._divAt = r > 0 and r or nil
    P.SetChannel(self, i)
    local d = S.drafts[ch.room]
    self.Input.Text = d or ""
    task.defer(function() self.TypingUntil = 0 end)
    Lib:SaveChatState()
    self:_QueueSidebar()
end

function Chat:_StashState()
    local S = Lib.ChatState
    local ch = self.Channels[self.ChIndex]
    if not ch then return end
    if self.PanelObj._shown and self.LastId and self.LastId > 0 then S.reads[ch.room] = self.LastId end
    local t = self.Input.Text
    S.drafts[ch.room] = (Trim(t) ~= "") and t:sub(1, 500) or nil
    Lib:SaveChatState()
end

function Chat:_QueueSidebar()
    if not self._sb or self._sbQ then return end
    self._sbQ = true
    task.defer(function()
        self._sbQ = false
        pcall(function() self:_RenderSidebar() end)
    end)
end

function Chat:_RenderSidebar()
    local sb = self._sb
    if not (sb and sb.list.Parent and sb.card.Visible) then return end
    local S, list, rh = Lib.ChatState, sb.list, H(26)
    for _, c in ipairs(list:GetChildren()) do
        if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
    end
    local order = 0
    local function Head(t, plus, fn)
        order = order + 1
        local h = New("Frame", { Size = UDim2.new(1, 0, 0, 18), LayoutOrder = order, BackgroundTransparency = 1, Parent = list })
        New("TextLabel", { Text = t, Font = Lib.FontBold, TextSize = 10, Size = UDim2.new(1, -24, 1, 0), Position = UDim2.fromOffset(6, 0), TextXAlignment = LEFT,
            Theme = { TextColor3 = "Dim" }, Parent = h })
        if plus then
            local pb = New("TextButton", { Text = "+", Font = Lib.FontBold, TextSize = 15, Size = UDim2.fromOffset(20, 18), AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, 0, 0, 0), Theme = { TextColor3 = "SubText" }, Parent = h })
            pb.Activated:Connect(fn)
            Lib:AddTooltip(pb, plus)
        end
    end
    local function Row(i, ch)
        order = order + 1
        local cur = i == self.ChIndex
        local unread = (not cur) and (ch.unread or 0) or 0
        local fav = S.favs[ch.room] == true
        local b = New("TextButton", { Name = "Ch", Text = "", Size = UDim2.new(1, 0, 0, rh), LayoutOrder = order, BackgroundTransparency = cur and 0.35 or 1,
            Theme = { BackgroundColor3 = cur and "FieldHover" or "Field" }, Parent = list })
        Corner(b, 5)
        if ch.kind == "dm" then
            local on = ch.uid and self.Friends.online[tostring(ch.uid)]
            local dot = New("Frame", { Size = UDim2.fromOffset(8, 8), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 7, 0.5, 0),
                BackgroundColor3 = on and Lib.Theme.Good or Lib.Theme.Dim, Parent = b })
            Corner(dot, 4)
        else
            New("TextLabel", { Text = ch.kind == "grp" and "«" or "#", Font = Lib.FontBold, TextSize = 13, Size = UDim2.fromOffset(16, rh), Position = UDim2.fromOffset(4, 0),
                Theme = { TextColor3 = cur and "Accent" or "Dim" }, Parent = b })
        end
        New("TextLabel", { Text = tostring(ch.name or "?"), Font = (cur or unread > 0) and Lib.FontBold or Lib.Font, TextSize = 12, Size = UDim2.new(1, -(24 + 38), 1, 0),
            Position = UDim2.fromOffset(22, 0), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd,
            Theme = { TextColor3 = (cur or unread > 0) and "Text" or "SubText" }, Parent = b })
        if unread > 0 then
            local bd = New("Frame", { Size = UDim2.fromOffset(unread > 9 and 22 or 16, 14), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -20, 0.5, 0),
                Theme = { BackgroundColor3 = "Bad" }, BackgroundTransparency = 0, Parent = b })
            Corner(bd, 7)
            New("TextLabel", { Text = unread > 9 and "9+" or tostring(unread), Font = Lib.FontBold, TextSize = 9, Size = UDim2.fromScale(1, 1), TextColor3 = WHITE, Parent = bd })
        elseif (S.drafts[ch.room] or "") ~= "" and not cur then
            New("TextLabel", { Text = "✎", TextSize = 11, Size = UDim2.fromOffset(16, rh), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -20, 0, 0),
                Theme = { TextColor3 = "Dim" }, Parent = b })
        end
        local star = New("TextButton", { Text = "", Size = UDim2.fromOffset(18, rh), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -2, 0, 0),
            Visible = fav or (Lib.Touch and cur), ZIndex = 3, Parent = b })
        Lib.Icon("star", 12, fav and "Warn" or "Dim", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 4, Parent = star }, "*")
        star.Activated:Connect(function() Lib:SetFav(ch.room, not fav) end)
        b.MouseEnter:Connect(function()
            star.Visible = true
            if not cur then Tween(b, { BackgroundTransparency = 0.6 }, 0.06) end
        end)
        b.MouseLeave:Connect(function()
            star.Visible = fav or (Lib.Touch and cur)
            if not cur then Tween(b, { BackgroundTransparency = 1 }, 0.08) end
        end)
        b.Activated:Connect(function() self:SetChannel(i) end)
    end

    local favs, pubs, dms, grps = {}, {}, {}, {}
    for i, ch in ipairs(self.Channels) do
        local e = { i, ch }
        if S.favs[ch.room] then favs[#favs + 1] = e
        elseif ch.kind == "dm" then dms[#dms + 1] = e
        elseif ch.kind == "grp" then grps[#grps + 1] = e
        else pubs[#pubs + 1] = e end
    end
    if #favs > 0 then
        Head("FAVORITES")
        for _, e in ipairs(favs) do Row(e[1], e[2]) end
    end
    Head("CHANNELS")
    for _, e in ipairs(pubs) do Row(e[1], e[2]) end
    Head("DIRECT MESSAGES", "New DM", function() self:PickUser(function(u) self:OpenDM(u.uid, u.name, u.display) end, "DM who?") end)
    for _, e in ipairs(dms) do Row(e[1], e[2]) end
    Head("GROUPS", "New group", function() self:NewGroup() end)
    for _, e in ipairs(grps) do Row(e[1], e[2]) end
    local n = #self.Friends.incoming
    if self._frBtn then self._frBtn.Text = n > 0 and ("Friends · " .. n) or "Friends" end
end

function Chat:_SidebarLayout()
    local sb = self._sb
    if not sb then return end
    local w = self.Frame.Size.X.Offset
    local wide = w >= 440 and (self.Full or Lib.ChatState.layout ~= "Compact")
    local was = self.Wide
    self.Wide = wide
    sb.card.Visible = wide
    local SW = wide and self.SBW or 0
    sb.main.Position = UDim2.fromOffset(SW, 0)
    sb.main.Size = UDim2.new(1, -SW, 1, 0)
    local btn = self.ChBtn
    local ar = H(26) + 4
    for _, c in ipairs(btn.Parent:GetChildren()) do
        if c:IsA("TextButton") and c ~= btn then c.Visible = not wide end
    end
    btn.Position = wide and UDim2.fromOffset(0, 0) or UDim2.fromOffset(ar, 0)
    btn.Size = wide and UDim2.fromScale(1, 1) or UDim2.new(1, -(ar * 2), 1, 0)
    if wide then self:_QueueSidebar() end
    if was ~= wide then
        for _, it in ipairs(self.Items) do pcall(self._ClampItem, self, it) end
    end
end

function Chat:_ApplyLayout()
    local S = Lib.ChatState
    local panel, frame = self.PanelObj, self.Frame
    if self.Full then self:_SidebarLayout() return end
    panel.W = (S.layout == "Compact") and 310 or 540
    if panel.Moved then
        local vp, s = GetViewport(), Lib.Scale
        frame.Size = UDim2.fromOffset(math.min(panel.W, (vp.X - 8) / s), frame.Size.Y.Offset)
    else
        Lib:_Place(panel)
    end
    self:_SidebarLayout()
end

function Chat:_InitSidebar()
    if self._sb then return end
    local frame, panel = self.Frame, self.PanelObj
    self.SBW = 150
    local main = New("Frame", { Name = "Main", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = frame })
    for _, c in ipairs(frame:GetChildren()) do
        if c ~= main and c ~= panel.Head and c:IsA("GuiObject") and c.Name ~= "HoverBar"
            and not (c:IsA("Frame") and c.Size == UDim2.new(1, -24, 0, 1)) then
            c.Parent = main
        end
    end
    local card = New("Frame", { Name = "Sidebar", Position = UDim2.fromOffset(8, 44), Size = UDim2.new(0, self.SBW - 8, 1, -52), BackgroundTransparency = 0,
        Theme = { BackgroundColor3 = "Surface" }, Parent = frame })
    Corner(card, 6)
    local list = New("ScrollingFrame", { Size = UDim2.new(1, -4, 1, -(H(26) + 12)), Position = UDim2.fromOffset(2, 4), AutomaticCanvasSize = Y, ScrollBarThickness = 0, Parent = card })
    List(list, 1)
    Pad(list, 4, 0, 4, 0)
    local foot = New("Frame", { Size = UDim2.new(1, -8, 0, H(26)), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -4), BackgroundTransparency = 1, Parent = card })
    List(foot, 4, Enum.FillDirection.Horizontal)
    local function FBtn(text, ord, fn)
        local b = New("TextButton", { Text = text, TextSize = 11, Size = UDim2.new(0.5, -2, 1, 0), LayoutOrder = ord, BackgroundTransparency = 0,
            TextTruncate = Enum.TextTruncate.AtEnd, Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = foot })
        Corner(b, 5)
        b.MouseEnter:Connect(function() Tween(b, { BackgroundColor3 = Lib.Theme.FieldHover, TextColor3 = Lib.Theme.Text }, 0.08) end)
        b.MouseLeave:Connect(function() Tween(b, { BackgroundColor3 = Lib.Theme.Field, TextColor3 = Lib.Theme.SubText }, 0.1) end)
        b.Activated:Connect(fn)
        return b
    end
    self._frBtn = FBtn("Friends", 1, function() self:ShowFriends() end)
    FBtn("Pins", 2, function() self:ShowPins() end)
    self._sb = { main = main, card = card, list = list }

    self.NewBar = New("TextButton", { Name = "NewBar", Text = "", TextSize = 11, Size = UDim2.fromOffset(0, 22), AutomaticSize = X, AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, self.Top + 4), Visible = false, ZIndex = 12, BackgroundTransparency = 0,
        Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = main })
    Corner(self.NewBar, 11) Pad(self.NewBar, 12, 0, 12, 0)
    self.NewBar.Activated:Connect(function()
        if self._div and self._div.Parent then self:_JumpItem(self._div) end
        task.delay(0.4, function() self:_UpdateNewBar() end)
    end)
    self.List:GetPropertyChangedSignal("CanvasPosition"):Connect(function() self:_UpdateNewBar() end)
    self.List:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() self:_UpdateNewBar() end)
    frame:GetPropertyChangedSignal("Size"):Connect(function() self:_SidebarLayout() end)

    local S = Lib:LoadChatState()
    local r = S.reads[self.Room]
    self._divAt = (r and r > 0) and r or nil
    local d = S.drafts[self.Room]
    if d and d ~= "" then
        self.Input.Text = d
        task.defer(function() self.TypingUntil = 0 end)
    end
    task.spawn(function()
        while not Lib.Unloaded and self.Frame and self.Frame.Parent do
            task.wait(10)
            pcall(function() self:_StashState() end)
        end
    end)
    self:_ApplyLayout()
    self:_RenderSidebar()
end

P.RefreshChannel = Chat._RefreshChannel
function Chat:_RefreshChannel()
    P.RefreshChannel(self)
    self:_QueueSidebar()
end

P.SyncFriends = Chat._SyncFriends
function Chat:_SyncFriends(fr)
    P.SyncFriends(self, fr)
    self:_QueueSidebar()
end

P.Menu = Chat.Menu
function Chat:Menu(items, anchor)
    if anchor ~= nil and anchor == self.ChBtn then
        local favs = {}
        for i, ch in ipairs(self.Channels) do
            if Lib.ChatState.favs[ch.room] then
                favs[#favs + 1] = { Text = (i == self.ChIndex and "• " or "   ") .. "* " .. Short(ch.name, 18), Callback = function() self:SetChannel(i) end }
            end
        end
        if #favs > 0 then
            table.insert(items, 1, { Header = true, Text = "FAVORITES" })
            for k, f in ipairs(favs) do table.insert(items, 1 + k, f) end
        end
    end
    return P.Menu(self, items, anchor)
end

P.HookItem = Chat._HookItem
function Chat:_HookItem(item, msg)
    P.HookItem(self, item, msg)
    if not (Lib.Touch and msg and msg.id) then return end
    local last = 0
    item.Activated:Connect(function()
        local now = os.clock()
        if now - last < 0.32 then last = 0 return end
        last = now
        task.delay(0.34, function()
            if last ~= now or not item.Parent then return end
            last = 0
            if os.clock() - (item:GetAttribute("lp") or 0) < 0.7 then return end
            self:OpenMessageMenu(msg, true)
        end)
    end)
end

P.CreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
    local chat = P.CreateChat(self, cfg)
    if chat and not chat._p50 then
        chat._p50 = true
        local ok, err = pcall(function() chat:_InitSidebar() end)
        if not ok then warn("[Aether] sidebar: " .. tostring(err)) end
    end
    return chat
end

P.BuildSettingsTab = Lib.BuildSettingsTab
function Lib:BuildSettingsTab(window)
    local tab = P.BuildSettingsTab(self, window)
    if tab and not tab._p50 then
        tab._p50 = true
        pcall(function()
            local S = Lib:LoadChatState()
            local sub = tab.Subs[1]
            local gb
            for _, g in ipairs(sub.Groupboxes) do if g.Name == "Chat" then gb = g end end
            gb = gb or sub:AddRightGroupbox("Chat", { Icon = "message-square", Collapsible = true })
            gb:AddDropdown("ChatLayout", { Text = "Chat layout", Values = { "Discord", "Compact" }, Default = S.layout, IgnoreConfig = true,
                Tooltip = "Discord: channel sidebar on the left. Compact: the small single-column chat.",
                Callback = function(v)
                    S.layout = v == "Compact" and "Compact" or "Discord"
                    Lib:SaveChatState()
                    local c = Lib.ChatObj
                    if c and c._sb then c:_ApplyLayout() end
                end })
        end)
    end
    return tab
end

end
-- ===================== end patch 5.0 =====================

-- ===================== Aether patch 5.1 (group icons) =====================
do
local P = {}
Lib.Version = "5.1.0"

Lib.GroupIcons = {}
do
    local loaded, tick = false, 0
    local function Path() return Lib.ConfigFolder .. "/groupicons.json" end

    function Lib:LoadGroupIcons()
        if loaded then return self.GroupIcons end
        loaded = true
        if FsOk() then
            pcall(function()
                local p = Path()
                if not isfile(p) then return end
                local d = HttpService:JSONDecode(readfile(p))
                if type(d) ~= "table" then return end
                for gid, e in pairs(d) do
                    if type(gid) == "string" and type(e) == "table" and e.id ~= nil and #tostring(e.id) < 80 then
                        self.GroupIcons[gid] = { id = tostring(e.id), mime = type(e.mime) == "string" and e.mime or "image/png", shared = e.shared == true }
                    end
                end
            end)
        end
        return self.GroupIcons
    end

    function Lib:SaveGroupIcons()
        if not FsOk() then return end
        tick = tick + 1
        local t = tick
        task.delay(0.8, function()
            if t ~= tick then return end
            pcall(function()
                if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                writefile(Path(), HttpService:JSONEncode(Lib.GroupIcons))
            end)
        end)
    end
end

function Chat:_IconAsset(entry, room, cb)
    local id = tostring(entry.id)
    local cached = Lib.ImgAssets[id]
    if cached then cb(cached) return end
    if not (FsOk() and (getcustomasset or getsynasset)) then return end
    task.spawn(function()
        local base = Lib.ConfigFolder .. "/cache/gi_" .. id:gsub("[^%w_%-]", "")
        local asset
        for _, ext in ipairs({ ".png", ".jpg", ".bmp" }) do
            local ok, ex = pcall(isfile, base .. ext)
            if ok and ex then asset = CustomAsset(base .. ext) break end
        end
        if not asset then
            local res = self:_Do("/imgraw", { id = id }, nil, nil, room)
            if res and res.StatusCode == 200 and type(res.Body) == "string" and #res.Body > 64 and res.Body:sub(1, 1) ~= "{" then
                CachePath("x", "image/png")
                local ext = ThumbExt(res.Body) or ".png"
                if pcall(writefile, base .. ext, res.Body) then asset = CustomAsset(base .. ext) end
            end
        end
        if asset then
            Lib.ImgAssets[id] = asset
            cb(asset)
        end
    end)
end

function Chat:ChooseGroupIcon(ch)
    if not (ch and ch.kind == "grp" and ch.gid) then return end
    self._iconPick = { gid = tostring(ch.gid), room = ch.room, name = tostring(ch.name or "group"), shown = false }
    Lib:Notify({ Title = "Group icon", Text = "Search for a picture, then tap it to use it for «" .. tostring(ch.name) .. "».", Type = "info", Duration = 4 })
    self:PickSearch()
end

P.ShowResults = Chat.ShowResults
function Chat:ShowResults(q)
    local pk = self._iconPick
    local before = {}
    for _, c in ipairs(Lib.Overlay:GetChildren()) do before[c] = true end
    P.ShowResults(self, q)
    if not pk then return end
    pk.shown = true
    local dim
    for _, c in ipairs(Lib.Overlay:GetChildren()) do
        if not before[c] and c:IsA("TextButton") then dim = c end
    end
    if dim then
        dim.Destroying:Connect(function()
            task.delay(0.5, function() if self._iconPick == pk then self._iconPick = nil end end)
        end)
    end
end

P.SendImage = Chat.SendImage
function Chat:SendImage(payload)
    local pk = self._iconPick
    if pk then
        self._iconPick = nil
        if pk.shown and pk.room == self.Room then
            self:_SetGroupIcon(pk, payload)
            return
        end
    end
    return P.SendImage(self, payload)
end

function Chat:_SetGroupIcon(pk, payload)
    Lib:Notify({ Title = "Group icon", Text = "Uploading...", Type = "info", Duration = 2 })
    task.spawn(function()
        local d = Decode(self:_Do("/upload", nil, "POST", HttpService:JSONEncode(payload), pk.room))
        if not (d and d.ok and d.id ~= nil) then
            Lib:Notify({ Title = "Group icon", Text = (d and d.error) or "Upload failed.", Type = "error" })
            return
        end
        local entry = { id = tostring(d.id), mime = type(d.mime) == "string" and d.mime or "image/png", shared = false }
        local res = self:_Do("/group/icon", nil, "POST", HttpService:JSONEncode({ id = pk.gid, image = d.id }), pk.room)
        local r = Decode(res)
        local text
        if r and r.ok then
            entry.shared = true
            text = "Icon updated for «" .. pk.name .. "»."
        elseif r and r.error and res and res.StatusCode ~= 404 then
            Lib:Notify({ Title = "Group icon", Text = tostring(r.error), Type = "error" })
            return
        else
            text = "Icon set for you. Others will see it once your worker supports /group/icon."
        end
        Lib:LoadGroupIcons()[pk.gid] = entry
        Lib:SaveGroupIcons()
        self:_QueueSidebar()
        Lib:Notify({ Title = "Group icon", Text = text, Type = "success", Duration = 4 })
    end)
end

function Chat:ClearGroupIcon(ch)
    if not (ch and ch.gid) then return end
    local gid = tostring(ch.gid)
    local I = Lib:LoadGroupIcons()
    if not I[gid] then return end
    local was = I[gid]
    I[gid] = nil
    Lib:SaveGroupIcons()
    self:_QueueSidebar()
    if was.shared then
        task.spawn(function()
            local r = Decode(self:_Do("/group/icon", nil, "POST", HttpService:JSONEncode({ id = gid, clear = true }), ch.room))
            if not (r and r.ok) then
                Lib:Notify({ Title = "Group icon", Text = (r and r.error) or "Removed for you, but the server didn't clear it.", Type = "warn", Duration = 4 })
            end
        end)
    end
end

function Chat:GroupIconMenu(ch, anchor)
    local items = { { Text = "Change group icon...", Callback = function() self:ChooseGroupIcon(ch) end } }
    if Lib:LoadGroupIcons()[tostring(ch.gid)] then
        table.insert(items, { Text = "Remove group icon", Danger = true, Callback = function() self:ClearGroupIcon(ch) end })
    end
    self:Menu(items, anchor)
end

P.Menu = Chat.Menu
function Chat:Menu(items, anchor)
    local cur = self.Channels[self.ChIndex]
    if anchor ~= nil and anchor == self.ChBtn and cur and cur.kind == "grp" then
        local at
        for i, it in ipairs(items) do
            if it.Text == "Rename group..." then at = i break end
        end
        local pos = at and (at + 1) or (#items + 1)
        table.insert(items, pos, { Text = "Change group icon...", Callback = function() self:ChooseGroupIcon(cur) end })
        if Lib:LoadGroupIcons()[tostring(cur.gid)] then
            table.insert(items, pos + 1, { Text = "Remove group icon", Danger = true, Callback = function() self:ClearGroupIcon(cur) end })
        end
    end
    return P.Menu(self, items, anchor)
end

P.SyncRooms = Chat._SyncRooms
function Chat:_SyncRooms(dms, groups)
    P.SyncRooms(self, dms, groups)
    pcall(function()
        local I, changed = Lib:LoadGroupIcons(), false
        for _, g in ipairs(type(groups) == "table" and groups or {}) do
            local gid = g.id ~= nil and tostring(g.id) or nil
            local ic = g.icon
            if ic == nil then ic = g.ic end
            if gid and ic ~= nil then
                local cur = I[gid]
                local id, mime
                if type(ic) == "table" and ic.id ~= nil then
                    id, mime = tostring(ic.id), type(ic.mime) == "string" and ic.mime or "image/png"
                elseif type(ic) == "string" and ic ~= "" then
                    id, mime = ic, "image/png"
                end
                if id then
                    if not cur or cur.id ~= id or not cur.shared then
                        I[gid] = { id = id, mime = mime, shared = true }
                        changed = true
                    end
                elseif (ic == "" or ic == false) and cur and cur.shared then
                    I[gid] = nil
                    changed = true
                end
            end
        end
        if changed then
            Lib:SaveGroupIcons()
            self:_QueueSidebar()
        end
    end)
end

P.RenderSidebar = Chat._RenderSidebar
function Chat:_RenderSidebar()
    P.RenderSidebar(self)
    local sb = self._sb
    if not (sb and sb.list.Parent and sb.card.Visible) then return end
    local ok, err = pcall(function()
        local I = Lib:LoadGroupIcons()
        local cur = self.Channels[self.ChIndex]
        local used = {}
        for _, row in ipairs(sb.list:GetChildren()) do
            if row.Name == "Ch" and row:IsA("TextButton") then
                local mark, nameLbl
                for _, c in ipairs(row:GetChildren()) do
                    if c:IsA("TextLabel") then
                        if c.Text == "«" then mark = c
                        elseif c.Position.X.Offset == 22 then nameLbl = c end
                    end
                end
                if mark and nameLbl then
                    local ch
                    for _, c2 in ipairs(self.Channels) do
                        if c2.kind == "grp" and not used[c2] and tostring(c2.name) == nameLbl.Text then ch = c2 break end
                    end
                    if ch then
                        used[ch] = true
                        local entry = I[tostring(ch.gid)]
                        if entry then
                            local img = New("ImageLabel", { Size = UDim2.fromOffset(18, 18), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0),
                                BackgroundTransparency = 0, ScaleType = Enum.ScaleType.Crop, Theme = { BackgroundColor3 = "Field" }, Parent = row })
                            Corner(img, 9)
                            self:_IconAsset(entry, ch.room, function(a)
                                if img.Parent then
                                    img.Image = a
                                    mark.Text = ""
                                end
                            end)
                        end
                        if ch == cur then
                            local cam = New("TextButton", { Text = "", Size = UDim2.new(0, 18, 1, 0), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -20, 0, 0),
                                ZIndex = 3, Parent = row })
                            Lib.Icon("image", 13, "SubText", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 4, Parent = cam }, "▣")
                            cam.Activated:Connect(function() self:GroupIconMenu(ch, cam) end)
                            Lib:AddTooltip(cam, "Group icon")
                        end
                    end
                end
            end
        end
    end)
    if not ok then warn("[Aether] group icons: " .. tostring(err)) end
end

end
-- ===================== end patch 5.1 =====================

-- ===================== Aether patch 5.2 (discord menu + DM avatars) =====================
do
local P = {}
Lib.Version = "5.2.0"

-- ---------- discord-style popover ----------
-- spec = { Name, Sub, Glyph, Uid, Group, Sections = { { {Text, Icon, Cb, Danger, Hint}, ... }, ... } }
function Chat:_PopMenu(spec, anchor)
    local W, rh, sc = 224, H(32), Lib.Scale
    local secs = {}
    for _, s in ipairs(spec.Sections) do if #s > 0 then secs[#secs + 1] = s end end
    local h = 10
    if spec.Name then h = h + 54 end
    for i, s in ipairs(secs) do
        if i > 1 or spec.Name then h = h + 11 end
        h = h + #s * (rh + 2)
    end
    local maxH = math.max(140, (Lib.Overlay.AbsoluteSize.Y - 16) / sc)
    local shown = math.min(h, maxH)
    local menu = Sink(New("Frame", { Name = "ConvoMenu", Size = UDim2.fromOffset(W, shown), BackgroundTransparency = 0, ZIndex = 85,
        Theme = { BackgroundColor3 = "Surface" }, Parent = Lib.Overlay }))
    Corner(menu, 8) Stroke(menu, "Stroke", 1, 0)
    New("UIScale", { Scale = sc, Parent = menu })
    local scroll = New("ScrollingFrame", { Size = UDim2.new(1, -8, 1, -8), Position = UDim2.fromOffset(4, 4), AutomaticCanvasSize = Y,
        ScrollBarThickness = 2, ZIndex = 86, Parent = menu })
    List(scroll, 2)
    local order = 0

    if spec.Name then
        order = order + 1
        local head = New("Frame", { Size = UDim2.new(1, 0, 0, 52), LayoutOrder = order, BackgroundTransparency = 1, ZIndex = 87, Parent = scroll })
        local av = New("ImageLabel", { Size = UDim2.fromOffset(36, 36), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0),
            BackgroundTransparency = 0, ScaleType = Enum.ScaleType.Crop, ZIndex = 88, Theme = { BackgroundColor3 = "Field" }, Parent = head })
        Corner(av, 18)
        local glyph = New("TextLabel", { Text = spec.Glyph or "", Font = Lib.FontBold, TextSize = 16, Size = UDim2.fromScale(1, 1), ZIndex = 89,
            Theme = { TextColor3 = "Accent" }, Parent = av })
        if spec.Uid then
            GetAvatar(spec.Uid, function(u) if av.Parent then av.Image = u glyph.Text = "" end end)
        elseif spec.Group then
            local entry = Lib:LoadGroupIcons()[tostring(spec.Group.gid)]
            if entry then
                self:_IconAsset(entry, spec.Group.room, function(a) if av.Parent then av.Image = a glyph.Text = "" end end)
            end
        end
        New("TextLabel", { Text = Short(tostring(spec.Name), 24), Font = Lib.FontBold, TextSize = 14, Size = UDim2.new(1, -62, 0, 18), Position = UDim2.fromOffset(54, 8),
            TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 88, Parent = head })
        New("TextLabel", { Text = spec.Sub or "", TextSize = 11, Size = UDim2.new(1, -62, 0, 14), Position = UDim2.fromOffset(54, 28),
            TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 88, Theme = { TextColor3 = "Dim" }, Parent = head })
    end

    for i, sec in ipairs(secs) do
        if i > 1 or spec.Name then
            order = order + 1
            local d = New("Frame", { Size = UDim2.new(1, 0, 0, 9), LayoutOrder = order, BackgroundTransparency = 1, ZIndex = 87, Parent = scroll })
            New("Frame", { Size = UDim2.new(1, -12, 0, 1), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0.35,
                ZIndex = 88, Theme = { BackgroundColor3 = "Stroke" }, Parent = d })
        end
        for _, it in ipairs(sec) do
            order = order + 1
            local danger = it.Danger
            local b = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, rh), LayoutOrder = order, BackgroundTransparency = 1, ZIndex = 87,
                Theme = { BackgroundColor3 = danger and "Bad" or "FieldHover" }, Parent = scroll })
            Corner(b, 5)
            local ico = Lib.Icon(it.Icon or "circle", 16, danger and "Bad" or "SubText",
                { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0), ZIndex = 88, Parent = b })
            New("TextLabel", { Text = it.Text, TextSize = 13, Size = UDim2.new(1, -(40 + (it.Hint and 44 or 8)), 1, 0), Position = UDim2.fromOffset(36, 0),
                TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 88, Theme = { TextColor3 = danger and "Bad" or "Text" }, Parent = b })
            if it.Hint then
                New("TextLabel", { Text = tostring(it.Hint), TextSize = 11, Size = UDim2.fromOffset(36, rh), AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -10, 0, 0), TextXAlignment = RIGHT, ZIndex = 88, Theme = { TextColor3 = "Dim" }, Parent = b })
            end
            b.MouseEnter:Connect(function()
                Tween(b, { BackgroundTransparency = danger and 0.8 or 0.3 }, 0.06)
                if not danger then Tint(ico, Lib.Theme.Text, 0.08) end
            end)
            b.MouseLeave:Connect(function()
                Tween(b, { BackgroundTransparency = 1 }, 0.08)
                if not danger then Tint(ico, Lib.Theme.SubText, 0.1) end
            end)
            Press(b, function() Lib:ClosePopup() Safe(it.Cb) end)
        end
    end

    local pos, hh = PlaceBelow(anchor, W * sc, shown * sc, 4, true)
    menu.Size = UDim2.fromOffset(W, math.min(shown, math.max(hh / sc, 60)))
    menu.Position = UDim2.fromOffset(pos.X, pos.Y)
    Lib:OpenPopup(menu, function() menu:Destroy() end, anchor)
end

-- ---------- the chevron menu ----------
P.ChannelMenu = Chat.ChannelMenu
function Chat:ChannelMenu()
    local cur = self.Channels[self.ChIndex]
    if not cur then return end
    local me = LocalPlayer.UserId
    local S = Lib:LoadChatState()
    local fav = S.favs[cur.room] == true
    local pins = #(self.Pinned or {})
    local A, B, E, C = {}, {}, {}, {}
    local function Add(sec, text, icon, cb, o)
        table.insert(sec, { Text = text, Icon = icon, Cb = cb, Danger = o and o.Danger, Hint = o and o.Hint })
    end
    local spec = { Sections = { A, B, E, C } }

    if cur.kind == "grp" then
        local owner = tonumber(cur.creator or cur.owner)
        local isOwner = owner == nil or owner == me
        local n = #(cur.members or {})
        spec.Name, spec.Glyph, spec.Group = cur.name, "«", cur
        spec.Sub = "Group chat" .. (n > 0 and (" · " .. n .. "/" .. MAX_GROUP .. " members") or "")
        Add(A, "Invite Members", "user-plus", function() self:InviteToGroup(cur.gid) end)
        if isOwner then Add(A, "Rename Group", "pencil", function() self:RenameGroup(cur.gid) end) end
        Add(A, "Change Group Icon", "image", function() self:ChooseGroupIcon(cur) end)
        if Lib:LoadGroupIcons()[tostring(cur.gid)] then
            Add(A, "Remove Group Icon", "x", function() self:ClearGroupIcon(cur) end)
        end
        if isOwner then Add(A, "Make Owner", "crown", function() self:TransferOwner(cur) end) end
        Add(C, "Leave Group", "log-out", function() self:LeaveGroup(cur) end, { Danger = true })
    elseif cur.kind == "dm" then
        local u = { uid = cur.uid, name = cur.name, display = cur.name }
        local online = cur.uid and self.Friends.online[tostring(cur.uid)]
        spec.Name, spec.Uid = cur.name, cur.uid
        spec.Sub = "Direct message" .. (online and " · online" or "")
        Add(A, "View Profile", "user", function() self:ShowProfile(u) end)
        Add(A, "Invite to Group", "users", function() self:InviteToGroup(nil, { u }) end)
        local st = cur.uid and self:FriendState(cur.uid) or nil
        if st == nil and cur.uid then Add(A, "Add Friend", "user-plus", function() self:Friend("request", u) end)
        elseif st == "incoming" then Add(A, "Accept Friend Request", "user-check", function() self:Friend("accept", u) end)
        elseif st == "outgoing" then Add(A, "Cancel Friend Request", "user-x", function() self:Friend("cancel", u) end) end
        if cur.uid then
            local blocked = Lib:IsBlocked(cur.uid)
            Add(C, blocked and "Unblock User" or "Block User", "ban", function()
                if blocked then Lib:Unblock(cur.uid) else Lib:Block(cur.uid, cur.name) end
            end, { Danger = not blocked })
        end
        Add(C, "Close DM", "x", function()
            local idx = self:_RoomIndex(cur.room)
            if idx then
                self.HiddenDMs[cur.room] = cur.lastId or 0
                table.remove(self.Channels, idx)
                if self.ChIndex == idx then self.ChIndex = -1 self:SetChannel(1)
                elseif self.ChIndex > idx then self.ChIndex = self.ChIndex - 1 self:_RefreshChannel()
                else self:_RefreshChannel() end
            end
            self:SaveConvos()
        end, { Danger = true })
    else
        local here = cur.id and tonumber(cur.id) == game.PlaceId
        spec.Name, spec.Glyph = "#" .. tostring(cur.name), "#"
        spec.Sub = "Channel" .. (here and " · current game" or "")
    end

    Add(B, "Pinned Messages", "pin", function() self:ShowPins() end, { Hint = pins > 0 and pins or nil })
    Add(B, "Search Messages", "search", function() self:ToggleSearch(true) end)
    Add(B, fav and "Remove Favorite" or "Mark as Favorite", "star", function() Lib:SetFav(cur.room, not fav) end)

    -- no sidebar in Compact layout, so the menu is the only way to switch / start conversations
    if not self.Wide then
        Add(E, "Switch Conversation...", "list", function() P.ChannelMenu(self) end)
        Add(E, "New DM...", "message-square", function()
            self:PickUser(function(u) self:OpenDM(u.uid, u.name, u.display) end, "DM who?")
        end)
        Add(E, "New Group Chat...", "users", function() self:NewGroup() end)
        local reqN = #self.Friends.incoming
        Add(E, "Friends", "user", function() self:ShowFriends(reqN > 0 and "requests" or "friends") end, { Hint = reqN > 0 and reqN or nil })
    end

    self:_PopMenu(spec, self.ChBtn)
end

-- ---------- avatars in the header bar ----------
function Chat:_UpdateHeaderAvatar()
    local btn, label = self.ChBtn, self.ChLabel
    if not (btn and label and btn.Parent) then return end
    local ch = self.Channels[self.ChIndex]
    local av = self._hdrAv
    if not av then
        av = New("ImageLabel", { Name = "HdrAvatar", Size = UDim2.fromOffset(20, 20), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 7, 0.5, 0),
            BackgroundTransparency = 0, ScaleType = Enum.ScaleType.Crop, Visible = false, ZIndex = 3, Theme = { BackgroundColor3 = "Field" }, Parent = btn })
        Corner(av, 10)
        self._hdrAv = av
    end
    local g = ch ~= nil and ch.kind == "grp"
    local entry = g and Lib:LoadGroupIcons()[tostring(ch.gid)] or nil
    local want = ch ~= nil and ((ch.kind == "dm" and ch.uid) or entry) and true or false
    av.Visible = want
    local off = want and 26 or 0
    label.Position = UDim2.fromOffset(10 + off, 0)
    label.Size = UDim2.new(1, -((g and 56 or 30) + off), 1, 0)
    if not want then return end
    av.Image = ""
    local key = ch.room .. ":" .. tostring(entry and entry.id or ch.uid)
    self._hdrKey = key
    local function Set(a) if av.Parent and self._hdrKey == key then av.Image = a end end
    if ch.kind == "dm" then GetAvatar(ch.uid, Set) else self:_IconAsset(entry, ch.room, Set) end
end

P.RefreshChannel = Chat._RefreshChannel
function Chat:_RefreshChannel()
    P.RefreshChannel(self)
    pcall(function() self:_UpdateHeaderAvatar() end)
end

-- ---------- avatars in the sidebar DM rows ----------
P.RenderSidebar = Chat._RenderSidebar
function Chat:_RenderSidebar()
    P.RenderSidebar(self)
    local sb = self._sb
    if not (sb and sb.list.Parent and sb.card.Visible) then return end
    local ok, err = pcall(function()
        local used = {}
        for _, row in ipairs(sb.list:GetChildren()) do
            if row.Name == "Ch" and row:IsA("TextButton") then
                local dot, nameLbl
                for _, c in ipairs(row:GetChildren()) do
                    if c:IsA("Frame") and c.Size == UDim2.fromOffset(8, 8) then dot = c
                    elseif c:IsA("TextLabel") and c.Position == UDim2.fromOffset(22, 0) then nameLbl = c end
                end
                if dot and nameLbl then
                    local ch
                    for _, c2 in ipairs(self.Channels) do
                        if c2.kind == "dm" and c2.uid and not used[c2] and tostring(c2.name) == nameLbl.Text then ch = c2 break end
                    end
                    if ch then
                        used[ch] = true
                        local av = New("ImageLabel", { Name = "DmAvatar", Size = UDim2.fromOffset(20, 20), AnchorPoint = Vector2.new(0, 0.5),
                            Position = UDim2.new(0, 4, 0.5, 0), BackgroundTransparency = 0, ScaleType = Enum.ScaleType.Crop, ZIndex = 2,
                            Theme = { BackgroundColor3 = "Field" }, Parent = row })
                        Corner(av, 10)
                        GetAvatar(ch.uid, function(u) if av.Parent then av.Image = u end end)
                        -- the old status dot becomes the little badge on the avatar's corner
                        dot.Parent = av
                        dot.AnchorPoint, dot.Position, dot.Size, dot.ZIndex = Vector2.new(1, 1), UDim2.new(1, 3, 1, 3), UDim2.fromOffset(9, 9), 4
                        Stroke(dot, "Surface", 2, 0)
                        nameLbl.Position = UDim2.fromOffset(30, 0)
                        nameLbl.Size = UDim2.new(nameLbl.Size.X.Scale, nameLbl.Size.X.Offset - 8, nameLbl.Size.Y.Scale, nameLbl.Size.Y.Offset)
                    end
                end
            end
        end
    end)
    if not ok then warn("[Aether] dm avatars: " .. tostring(err)) end
end

end
-- ===================== end patch 5.2 =====================

-- ===================== Aether patch 5.3 (code blocks, formatting, emoji, notif settings, join cards) =====================
do
local P = {}
Lib.Version = "5.3.0"
Lib._quiet = false

-- ==================== A) notification settings storage ====================
Lib.ChatNotif = {}
do
    local loaded, tick = false, 0
    local function Path() return Lib.ConfigFolder .. "/chatnotif.json" end
    local function Load()
        if loaded then return end
        loaded = true
        if not FsOk() then return end
        pcall(function()
            local p = Path()
            if not isfile(p) then return end
            local d = HttpService:JSONDecode(readfile(p))
            if type(d) ~= "table" then return end
            for k, v in pairs(d) do
                if type(k) == "string" and (v == "mentions" or v == "none") then Lib.ChatNotif[k] = v end
            end
        end)
    end
    function Lib:GetNotif(room)
        Load()
        return self.ChatNotif[room] or "all"
    end
    function Lib:SetNotif(room, mode)
        Load()
        self.ChatNotif[room] = (mode == "mentions" or mode == "none") and mode or nil
        if not FsOk() then return end
        tick = tick + 1
        local t = tick
        task.delay(0.6, function()
            if t ~= tick then return end
            pcall(function()
                if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                writefile(Path(), HttpService:JSONEncode(Lib.ChatNotif))
            end)
        end)
    end
end

-- toasts can be silenced for the duration of one call
P.Notify = Lib.Notify
function Lib:Notify(a, b, c)
    if Lib._quiet then return end
    return P.Notify(self, a, b, c)
end

-- ==================== B) text formatting ====================
-- Control characters are used as temporary tokens so the original _Rich (mentions, links) can be reused.
P.Rich = Chat._Rich
function Chat:_Rich(text, meta)
    text = tostring(text or "")
    text = (text:gsub("[\1-\8\11\12\14-\31]", ""))
    local st = {}
    local function Stash(k, v) st[#st + 1] = { k = k, v = v } return "\2s" .. #st .. "\3" end
    text = text:gsub("`([^`\n]+)`", function(c) return Stash("code", c) end)
    text = text:gsub("||(.-)||", function(c)
        if c == "" then return nil end
        if meta then meta.hasSp = true end
        return Stash("sp", c)
    end)
    local function Wrapper(pat, tag)
        text = text:gsub(pat, function(c)
            if c:match("^%s") or c:match("%s$") then return nil end
            return "\2" .. tag .. "\3" .. c .. "\2/" .. tag .. "\3"
        end)
    end
    Wrapper("%*%*%*(.-)%*%*%*", "BI")
    Wrapper("%*%*(.-)%*%*", "B")
    Wrapper("~~(.-)~~", "S")
    Wrapper("%*([^%*]+)%*", "I")
    local stack, okb = {}, true
    for slash, tag in text:gmatch("\2(/?)(%a+)\3") do
        if slash == "" then stack[#stack + 1] = tag
        else
            if stack[#stack] ~= tag then okb = false break end
            stack[#stack] = nil
        end
    end
    if not okb or #stack > 0 then text = text:gsub("\2/?[BIS]+\3", "") end

    local s = P.Rich(self, text)
    local TAG = { B = "<b>", ["/B"] = "</b>", I = "<i>", ["/I"] = "</i>", S = "<s>", ["/S"] = "</s>", BI = "<b><i>", ["/BI"] = "</i></b>" }
    for _ = 1, 4 do
        local n
        s, n = s:gsub("\2([^\3]+)\3", function(tok)
            if TAG[tok] then return TAG[tok] end
            local i = tonumber(tok:match("^s(%d+)$"))
            local e = i and st[i]
            if not e then return "" end
            if e.k == "code" then
                return "<font face='Code'><mark color='#" .. Hex("Bg") .. "' transparency='0.15'>" .. Esc(e.v) .. "</mark></font>"
            end
            if meta and meta.spoil then
                return "<mark color='#" .. Hex("Dim") .. "' transparency='0.65'>" .. Esc(e.v) .. "</mark>"
            end
            return "<font color='#" .. Hex("Dim") .. "'>" .. string.rep("█", Clamp(utf8.len(e.v) or #e.v, 3, 20)) .. "</font>"
        end)
        if n == 0 then break end
    end
    return s
end

-- renders the first text segment of a message (the whole text for normal messages)
function Chat:_BodyText(meta)
    local t = self:_Rich(meta.s1 ~= nil and meta.s1 or meta.txt, meta)
    if meta.edited and meta.editBody ~= false then
        t = t .. " <font color='#" .. Hex("Dim") .. "' size='10'>(edited)</font>"
    end
    return t
end

-- ==================== C) code blocks ====================
local function ParseBlocks(txt)
    local segs, pos = {}, 1
    local function AddText(s)
        s = s:gsub("^%s+", ""):gsub("%s+$", "")
        if s ~= "" then segs[#segs + 1] = { k = "t", s = s } end
    end
    while true do
        local a, b = txt:find("```", pos, true)
        if not a then break end
        local c, d = txt:find("```", b + 1, true)
        if not c then break end
        AddText(txt:sub(pos, a - 1))
        local body = txt:sub(b + 1, c - 1)
        local lang, code = body:match("^([%w_%+%-%.#]*)\n(.*)$")
        if not lang then lang, code = "", body end
        code = code:gsub("^\n+", ""):gsub("[\n%s]+$", "")
        if code ~= "" then segs[#segs + 1] = { k = "c", lang = lang, s = code } end
        pos = d + 1
    end
    AddText(txt:sub(pos))
    return segs
end

function Chat:_WidenItem(item)
    local col = item:FindFirstChild("Col")
    local bubble = col and col:FindFirstChild("Bubble")
    if not bubble then return end
    local maxCol = math.min(560, math.floor((self.Frame.Size.X.Offset - 44) * 0.8))
    col.Size = UDim2.new(0, maxCol, 0, 0)
    bubble.Size = UDim2.new(0, maxCol, 0, 0)
    pcall(self._ClampItem, self, item)
end

function Chat:_ColWidth()
    local maxCol = math.min(560, math.floor((self.Frame.Size.X.Offset - 44) * 0.8))
    local cap = math.max(self.Frame.Size.X.Offset - (self.Wide and self.SBW or 0) - 66, 160)
    return math.min(maxCol, cap)
end

function Chat:_CodeBlock(parent, seg, order)
    local code = seg.s
    local lang = seg.lang ~= "" and seg.lang:lower() or "code"
    local w = math.max(self:_ColWidth() - 28, 100)
    local th = math.ceil(Measure(code, 12, Enum.Font.Code, w).Y)
    local viewH = math.min(th + 6, 190)
    local box = New("Frame", { Name = "CodeBlock", Size = UDim2.new(1, 0, 0, viewH + 24), LayoutOrder = order, BackgroundTransparency = 0,
        Theme = { BackgroundColor3 = "Bg" }, Parent = parent })
    Corner(box, 6) Stroke(box, "Stroke", 1, 0.4)
    New("TextLabel", { Text = Short(lang, 16), TextSize = 10, Size = UDim2.new(1, -70, 0, 20), Position = UDim2.fromOffset(8, 0), TextXAlignment = LEFT,
        Theme = { TextColor3 = "Dim" }, Parent = box })
    local copy = New("TextButton", { Text = "Copy", TextSize = 11, Size = UDim2.fromOffset(46, 18), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -4, 0, 2),
        BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = box })
    Corner(copy, 4)
    Lib:AddTooltip(copy, "Only run code you trust")
    local sf = New("ScrollingFrame", { Size = UDim2.new(1, -8, 0, viewH), Position = UDim2.fromOffset(4, 22), AutomaticCanvasSize = Y,
        ScrollBarThickness = 2, ScrollingEnabled = th + 6 > 190, Parent = box })
    New("TextLabel", { Text = code, Font = Enum.Font.Code, TextSize = 12, Size = UDim2.new(1, -4, 0, th), AutomaticSize = Y, TextXAlignment = LEFT,
        TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, RichText = false, Theme = { TextColor3 = "Text" }, Parent = sf })
    copy.Activated:Connect(function()
        if type(setclipboard) == "function" then
            setclipboard(code)
            copy.Text = "Copied"
            task.delay(1.2, function() if copy.Parent then copy.Text = "Copy" end end)
        else
            Lib:Notify({ Text = "Your executor has no clipboard function.", Type = "warn" })
        end
    end)
    return box
end

function Chat:_RenderSegments(item, meta)
    local col = item:FindFirstChild("Col")
    local bubble = col and col:FindFirstChild("Bubble")
    if not bubble then return end
    for _, o in ipairs(meta.extras or {}) do pcall(function() o:Destroy() end) end
    meta.extras, meta.hasSp = {}, false
    local function Spoiler()
        if not meta.hasSp then return end
        local b = New("TextButton", { Name = "SpoilerBtn", Text = meta.spoil and "Hide spoiler" or "Reveal spoiler", TextSize = 11, AutomaticSize = X,
            Size = UDim2.fromOffset(0, H(20)), LayoutOrder = 9, BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Bg", TextColor3 = "Accent" }, Parent = bubble })
        Corner(b, 5) Pad(b, 8, 0, 8, 0)
        table.insert(meta.extras, b)
        b.Activated:Connect(function() meta.spoil = not meta.spoil self:_RenderSegments(item, meta) end)
    end
    local txt = meta.txt
    if not txt:find("```", 1, true) then
        meta.s1, meta.editBody = nil, nil
        meta.body.Visible = txt ~= ""
        meta.body.Text = self:_BodyText(meta)
        Spoiler()
        return
    end
    local segs = ParseBlocks(txt)
    local lastText
    for i, s in ipairs(segs) do if s.k == "t" then lastText = i end end
    meta.s1 = (segs[1] and segs[1].k == "t") and segs[1].s or ""
    meta.editBody = (lastText == 1)
    meta.body.Visible = meta.s1 ~= ""
    meta.body.Text = meta.s1 ~= "" and self:_BodyText(meta) or ""
    local order = 10
    for i = 2, #segs do
        local s = segs[i]
        order = order + 1
        if s.k == "t" then
            local l = New("TextLabel", { Name = "Seg", RichText = true, Text = "", TextSize = 13, Size = UDim2.new(1, 0, 0, 14), TextXAlignment = LEFT,
                TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = order, Parent = bubble })
            Wrap(l)
            local rich = self:_Rich(s.s, meta)
            if meta.edited and i == lastText then rich = rich .. " <font color='#" .. Hex("Dim") .. "' size='10'>(edited)</font>" end
            l.Text = rich
            table.insert(meta.extras, l)
        else
            table.insert(meta.extras, self:_CodeBlock(bubble, s, order))
        end
    end
    if meta.edited and not lastText then
        order = order + 1
        local l = New("TextLabel", { Text = "(edited)", TextSize = 10, Size = UDim2.new(1, 0, 0, 12), TextXAlignment = LEFT, LayoutOrder = order,
            Theme = { TextColor3 = "Dim" }, Parent = bubble })
        table.insert(meta.extras, l)
    end
    Spoiler()
    self:_WidenItem(item)
end

-- ==================== D) Join me cards ====================
local function ParseJoin(txt)
    local t = Trim(tostring(txt or ""))
    local place, job, pl, mx, name = t:match("^%[join|(%d+)|([%x%-]+)|(%d+)|(%d+)|([^|%]]*)%]$")
    if not place or not job:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then return nil end
    return { place = tonumber(place), job = job, players = tonumber(pl) or 0, max = tonumber(mx) or 0, name = Trim(name):sub(1, 40) }
end

function Chat:_BuildJoinCard(item, meta, msg, c)
    meta.isCard = true
    meta.body.Visible = false
    local col = item:FindFirstChild("Col")
    local bubble = col and col:FindFirstChild("Bubble")
    if not bubble then return end
    local mine = tostring(msg.uid) == tostring(LocalPlayer.UserId)
    local who = tostring((msg.display ~= nil and msg.display ~= "") and msg.display or msg.name or "them")
    local same = c.job == game.JobId
    local card = New("Frame", { Name = "JoinCard", Size = UDim2.new(1, 0, 0, H(82)), LayoutOrder = 3, BackgroundTransparency = 0.35,
        Theme = { BackgroundColor3 = "Bg" }, Parent = bubble })
    Corner(card, 6)
    New("Frame", { Size = UDim2.new(0, 2, 1, -10), Position = UDim2.fromOffset(5, 5), Theme = { BackgroundColor3 = "Good" }, Parent = card })
    New("TextLabel", { Text = "JOIN ME", TextSize = 10, Size = UDim2.new(1, -20, 0, 13), Position = UDim2.fromOffset(14, 5), TextXAlignment = LEFT,
        Theme = { TextColor3 = "Dim" }, Parent = card })
    New("TextLabel", { Text = c.name ~= "" and c.name or "Roblox game", Font = Lib.FontBold, TextSize = 13, Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.fromOffset(14, 18), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Parent = card })
    New("TextLabel", { Text = c.players .. "/" .. c.max .. " players when posted", TextSize = 11, Size = UDim2.new(1, -20, 0, 13),
        Position = UDim2.fromOffset(14, 35), TextXAlignment = LEFT, Theme = { TextColor3 = "SubText" }, Parent = card })
    local row = New("Frame", { Size = UDim2.new(1, -24, 0, H(24)), Position = UDim2.fromOffset(14, 52 + (H(24) - 24)), BackgroundTransparency = 1, Parent = card })
    List(row, 6, Enum.FillDirection.Horizontal)
    local join = New("TextButton", { Text = same and (mine and "Your server" or "In your server") or "Join", TextSize = 12, Size = UDim2.new(0.5, -3, 1, 0), LayoutOrder = 1,
        BackgroundTransparency = same and 0.5 or 0, TextColor3 = Color3.fromRGB(12, 16, 12), Theme = { BackgroundColor3 = "Good" }, Parent = row })
    Corner(join, 5)
    local cp = New("TextButton", { Text = "Copy script", TextSize = 12, Size = UDim2.new(0.5, -3, 1, 0), LayoutOrder = 2, BackgroundTransparency = 0,
        Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = row })
    Corner(cp, 5)
    cp.Activated:Connect(function()
        Copy(string.format("game:GetService('TeleportService'):TeleportToPlaceInstance(%d, '%s', game.Players.LocalPlayer)", c.place, c.job), "Join script")
    end)
    local busy = false
    join.Activated:Connect(function()
        if same then Lib:Notify({ Text = "You're already in this server.", Type = "info" }) return end
        if busy then return end
        busy = true
        join.Text = "Checking..."
        local function Go() Lib:JoinServer(c.place, c.job, who) end
        Lib:CheckServer(c.place, c.job, function(r, why)
            busy = false
            if join.Parent then join.Text = "Join" end
            if r and r.max > 0 and r.playing >= r.max then
                Lib:Dialog({ Title = "Server is full", Text = who .. "'s server is at capacity right now. A spot may open up.",
                    Buttons = { { Text = "Cancel" }, { Text = "Try anyway", Primary = true, Callback = Go } } })
            elseif not r and why == "notfound" then
                Lib:Dialog({ Title = "Server not in the public list", Text = "It may have closed, or it just isn't in the first 400 servers Roblox lists. Try anyway?",
                    Buttons = { { Text = "Cancel" }, { Text = "Try anyway", Primary = true, Callback = Go } } })
            else
                Go()
            end
        end)
    end)
    self:_WidenItem(item)
end

function Chat:ShareServer()
    if game.PrivateServerId ~= "" then
        Lib:Notify({ Title = "Join me", Text = "You're in a private server. Roblox only lets people in with an invite link, not a server id, so a card can't work here.", Type = "warn", Duration = 6 })
        return
    end
    if game.JobId == "" then
        Lib:Notify({ Title = "Join me", Text = "There's no live server to share (Studio?).", Type = "warn" })
        return
    end
    Lib:Dialog({ Title = "Share your server", Text = "Post your current game and server in this chat? Anyone who sees it can join you.",
        Buttons = { { Text = "Cancel" }, { Text = "Post", Primary = true, Callback = function()
            task.spawn(function()
                local ok, nm = pcall(function() return Market:GetProductInfo(game.PlaceId).Name end)
                local name = ok and tostring(nm) or "Roblox game"
                name = name:gsub("[|%[%]%c]", " ")
                name = Trim(name):sub(1, 40)
                self:Send(string.format("[join|%d|%s|%d|%d|%s]", game.PlaceId, game.JobId, #Players:GetPlayers(), Players.MaxPlayers, name))
            end)
        end } } })
end

-- ==================== E) message hooks ====================
P.AddMessage = Chat.AddMessage
function Chat:AddMessage(msg)
    local quiet = type(msg) == "table" and (msg.type == nil or msg.type == "msg") and Lib:GetNotif(self.Room) == "none"
    local last = self.Items[#self.Items]
    if quiet then Lib._quiet = true end
    local ok, res = pcall(P.AddMessage, self, msg)
    Lib._quiet = false
    if not ok then error(res, 0) end
    local item = self.Items[#self.Items]
    local meta = item and item ~= last and self.Meta[item]
    if meta and meta.msg == msg then
        local ok2, err = pcall(function()
            local card = ParseJoin(meta.txt)
            if card then self:_BuildJoinCard(item, meta, msg, card) else self:_RenderSegments(item, meta) end
        end)
        if not ok2 then warn("[Aether] message render: " .. tostring(err)) end
    end
    return res
end

P.ApplyEdit = Chat._ApplyEdit
function Chat:_ApplyEdit(ev)
    P.ApplyEdit(self, ev)
    local item = self.ByLid[ev.target]
    local meta = item and self.Meta[item]
    if meta and not meta.isCard then pcall(self._RenderSegments, self, item, meta) end
end

-- while searching, highlight only the first text segment (the code blocks are separate objects)
P.ApplySearch = Chat.ApplySearch
function Chat:ApplySearch(keep)
    local swapped = {}
    for _, it in ipairs(self.Items) do
        local m = self.Meta[it]
        if m and m.s1 ~= nil then swapped[m] = m.txt m.txt = m.s1 end
    end
    local ok, err = pcall(P.ApplySearch, self, keep)
    for m, t in pairs(swapped) do m.txt = t end
    if not ok then warn("[Aether] search: " .. tostring(err)) end
end

-- ==================== F) sending: lengths, no auto-correct on code / cards ====================
P.Send = Chat.Send
function Chat:Send(text)
    text = Trim(text or "")
    if text == "" then return P.Send(self, text) end
    local code = text:find("```", 1, true) ~= nil
    local card = text:sub(1, 6) == "[join|"
    local cap = code and 1500 or (card and 240 or (self._baseMax or 200))
    local cut = #text > cap
    text = text:sub(1, cap)
    if code and cut and (select(2, text:gsub("```", "")) % 2 == 1) then text = text .. "\n```" end
    local ac = Lib.ChatPrefs and Lib.ChatPrefs.AutoCorrect
    if (code or card) and Lib.ChatPrefs then Lib.ChatPrefs.AutoCorrect = false end
    local ok, err = pcall(P.Send, self, text)
    if Lib.ChatPrefs then Lib.ChatPrefs.AutoCorrect = ac end
    if not ok then error(err, 0) end
end

-- ==================== G) the + button in the input bar ====================
function Chat:_InitBar()
    local input = self.Input
    local bar = input.Parent
    local ih = H(32)
    input.Size = UDim2.new(1, -(ih * 3 + 14), 1, 0)
    local plus = IconButton(bar, "plus", "+", ih - 8, "More", "Accent", 1)
    plus.Button.AnchorPoint, plus.Button.Position = Vector2.new(1, 0.5), UDim2.new(1, -ih * 2, 0.5, 0)
    plus.Button.Activated:Connect(function() self:_PlusMenu(plus.Button) end)
end

-- ==================== H) emoji shortcuts ====================
local Alias = {
    { "joy", "😂" }, { "sob", "😭" }, { "heart", "❤️" }, { "thumbsup", "👍" }, { "+1", "👍" }, { "thumbsdown", "👎" }, { "-1", "👎" },
    { "fire", "🔥" }, { "skull", "💀" }, { "100", "💯" }, { "pray", "🙏" }, { "clap", "👏" }, { "eyes", "👀" }, { "cry", "😢" },
    { "smile", "😄" }, { "grin", "😁" }, { "laughing", "😆" }, { "rofl", "🤣" }, { "sunglasses", "😎" }, { "thinking", "🤔" },
    { "wave", "👋" }, { "tada", "🎉" }, { "rocket", "🚀" }, { "sweat_smile", "😅" }, { "ok_hand", "👌" }, { "muscle", "💪" },
    { "angry", "😠" }, { "rage", "😡" }, { "scream", "😱" }, { "poop", "💩" }, { "ghost", "👻" }, { "crown", "👑" }, { "star", "⭐" },
    { "sparkles", "✨" }, { "zap", "⚡" }, { "check", "✅" }, { "x", "❌" }, { "clown", "🤡" }, { "nerd", "🤓" }, { "trophy", "🏆" },
}
local Emo = { map = {}, list = {} }
local function BuildEmoji(l)
    local map, list = {}, {}
    local function Add(code, e)
        if code ~= "" and not map[code] then map[code] = e list[#list + 1] = { code, e } end
    end
    for _, a in ipairs(Alias) do Add(a[1], a[2]) end
    if l then
        for _, x in ipairs(l) do
            if (x.v or 0) <= Lib.EmojiMaxVersion then
                local c = tostring(x.n or ""):gsub("[^%w%s]", "")
                c = c:gsub("%s+", "_")
                Add(c, x.e)
            end
        end
    end
    Emo.map, Emo.list = map, list
end
BuildEmoji(nil)

local function EmojiLookup(part)
    part = part:lower()
    local out, seen = {}, {}
    for _, it in ipairs(Emo.list) do
        if it[1]:sub(1, #part) == part then out[#out + 1] = it seen[it[1]] = true if #out >= 6 then return out end end
    end
    for _, it in ipairs(Emo.list) do
        if not seen[it[1]] and it[1]:find(part, 1, true) then out[#out + 1] = it if #out >= 6 then return out end end
    end
    return out
end

function Chat:_InitEmoji()
    local input = self.Input
    local par = (self._sb and self._sb.main) or self.Frame
    local sug = Sink(New("Frame", { Name = "EmojiSuggest", Visible = false, Size = UDim2.new(1, -16, 0, 0), AutomaticSize = Y, AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 8, 1, -(H(32) + 14)), BackgroundTransparency = 0, ZIndex = 22, Theme = { BackgroundColor3 = "Surface" }, Parent = par }))
    Corner(sug, 6) Stroke(sug) Pad(sug, 3, 3, 3, 3) List(sug, 0)
    Lib:LoadEmojis(function(l) if l then BuildEmoji(l) end end)
    local guard = false
    local function SetText(t)
        guard = true
        input.Text = t
        input.CursorPosition = #t + 1
        guard = false
    end
    local function Boundary(t, s) return s == 1 or t:sub(s - 1, s - 1):match("%s") ~= nil end
    local function Hide() sug.Visible = false end
    input:GetPropertyChangedSignal("Text"):Connect(function()
        if guard then return end
        local t = input.Text
        for _, c in ipairs(sug:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        local s, code = t:match("()%:([%w_%+%-]+)%:$")
        if s and Boundary(t, s) then
            local e = Emo.map[code:lower()]
            if e then SetText(t:sub(1, s - 1) .. e) Hide() return end
        end
        local s2, part = t:match("()%:([%w_%+%-]+)$")
        if not (s2 and #part >= 2 and Boundary(t, s2)) then Hide() return end
        local found = EmojiLookup(part)
        if #found == 0 then Hide() return end
        sug.Position = UDim2.new(0, 8, 1, -(self.ListBottom - 2 + (self.ReplyTo and 28 or 0) + (self.TypeOn and 18 or 0)))
        for i, it in ipairs(found) do
            local b = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, H(28)), LayoutOrder = i, ZIndex = 23, BackgroundTransparency = 1,
                BackgroundColor3 = Lib.Theme.FieldHover, Parent = sug })
            Corner(b, 4)
            New("TextLabel", { Text = it[2] .. "  :" .. it[1] .. ":", TextSize = 13, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(9, 0),
                TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 24, Parent = b })
            b.MouseEnter:Connect(function() Tween(b, { BackgroundTransparency = 0.3 }, 0.06) end)
            b.MouseLeave:Connect(function() Tween(b, { BackgroundTransparency = 1 }, 0.08) end)
            local picked = false
            local function Pick()
                if picked then return end
                picked = true
                local cur = input.Text
                local ns = cur:match("()%:([%w_%+%-]+)$")
                if ns then SetText(cur:sub(1, ns - 1) .. it[2] .. " ") end
                Hide()
                task.defer(function() input:CaptureFocus() end)
            end
            b.InputBegan:Connect(function(i) if IsPress(i) then Pick() end end)
            b.Activated:Connect(Pick)
        end
        sug.Visible = true
    end)
    input.FocusLost:Connect(function()
        task.delay(0.3, function() if sug.Parent and not input:IsFocused() then sug.Visible = false end end)
    end)
end

-- ==================== I) notification settings ====================
function Chat:NotifMenu(ch)
    local mode = Lib:GetNotif(ch.room)
    local function Opt(text, icon, m, msg)
        return { Text = text, Icon = icon, Hint = mode == m and "✓" or nil, Cb = function()
            Lib:SetNotif(ch.room, m)
            if m ~= "all" then ch.unread = 0 end
            self:_RefreshChannel()
            Lib:Notify({ Title = "Notifications", Text = msg, Type = "success", Duration = 3 })
        end }
    end
    local label = ch.kind == "dm" and ("@" .. tostring(ch.name)) or (ch.kind == "grp" and ("«" .. tostring(ch.name) .. "»") or ("#" .. tostring(ch.name)))
    self:_PopMenu({ Name = "Notifications", Sub = label, Glyph = "🔔", Sections = { {
        Opt("All Messages", "bell", "all", "You'll be notified for every message in " .. label .. "."),
        Opt("Only @mentions", "at-sign", "mentions", "Only mentions and replies in " .. label .. " will get your attention."),
        Opt("Nothing", "bell-off", "none", label .. " is muted. No badges or popups."),
    } } }, self.ChBtn)
end

P.PopMenu = Chat._PopMenu
function Chat:_PopMenu(spec, anchor)
    if anchor ~= nil and anchor == self.ChBtn and spec.Name ~= "Notifications" and spec.Sections and spec.Sections[2] then
        local cur = self.Channels[self.ChIndex]
        if cur then
            local m = Lib:GetNotif(cur.room)
            table.insert(spec.Sections[2], 1, { Text = "Notification Settings", Icon = m == "none" and "bell-off" or "bell",
                Hint = m == "all" and "All" or (m == "mentions" and "@" or "Off"), Cb = function() self:NotifMenu(cur) end })
        end
    end
    return P.PopMenu(self, spec, anchor)
end

-- DM / group unread counts arrive with every poll; zero them for muted rooms before the chat sees them
P.SyncRooms = Chat._SyncRooms
function Chat:_SyncRooms(dms, groups)
    local function Filter(d, room)
        local m = room and Lib:GetNotif(room) or "all"
        if m == "all" then return end
        if m == "none" then d.unread = 0 return end
        local l = type(d.last) == "table" and d.last or nil
        if not (l and self:_Pings(l)) then d.unread = 0 end
    end
    pcall(function()
        for _, d in ipairs(type(dms) == "table" and dms or {}) do
            local uid = tonumber(d.uid)
            if uid then Filter(d, self:DMRoom(uid)) end
        end
        for _, g in ipairs(type(groups) == "table" and groups or {}) do
            if g.id ~= nil then Filter(g, "grp:" .. tostring(g.id)) end
        end
    end)
    return P.SyncRooms(self, dms, groups)
end

-- public channel "peek" requests only return a count, so a muted channel always reports 0
P.Do = Chat._Do
function Chat:_Do(path, query, method, body, room)
    local res = P.Do(self, path, query, method, body, room)
    if path == "/poll" and type(query) == "table" and query.peek and room and Lib:GetNotif(room) ~= "all" and res and res.StatusCode == 200 then
        local d = Decode(res)
        if d and d.ok then
            d.count = 0
            return { StatusCode = 200, Body = HttpService:JSONEncode(d) }
        end
    end
    return res
end

-- bell-off icon + dimmed name on muted rows
P.RenderSidebar = Chat._RenderSidebar
function Chat:_RenderSidebar()
    P.RenderSidebar(self)
    local sb = self._sb
    if not (sb and sb.list.Parent and sb.card.Visible) then return end
    local ok, err = pcall(function()
        local used = {}
        for _, row in ipairs(sb.list:GetChildren()) do
            if row.Name == "Ch" and row:IsA("TextButton") then
                local nameLbl
                for _, c in ipairs(row:GetChildren()) do
                    if c:IsA("TextLabel") and c.Position.X.Scale == 0 and c.Position.Y.Offset == 0
                        and (c.Position.X.Offset == 22 or c.Position.X.Offset == 30) then nameLbl = c end
                end
                if nameLbl then
                    for _, ch in ipairs(self.Channels) do
                        if not used[ch] and tostring(ch.name) == nameLbl.Text then
                            used[ch] = true
                            if Lib:GetNotif(ch.room) ~= "all" then
                                nameLbl.TextTransparency = 0.45
                                Lib.Icon(Lib:GetNotif(ch.room) == "none" and "bell-off" or "at-sign", 11, "Dim",
                                    { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -40, 0.5, 0), ZIndex = 3, Parent = row })
                            end
                            break
                        end
                    end
                end
            end
        end
    end)
    if not ok then warn("[Aether] muted rows: " .. tostring(err)) end
end

-- ==================== J) init ====================
function Chat:_InitP53()
    self._baseMax = self.Config.MaxLength or 200
    self.Config.MaxLength = 1500
    local function Try(name, fn)
        local ok, err = pcall(fn)
        if not ok then warn("[Aether] " .. name .. ": " .. tostring(err)) end
    end
    Try("input bar", function() self:_InitBar() end)
    Try("emoji shortcuts", function() self:_InitEmoji() end)
    Try("rail badge", function()
        local rb = self.PanelObj.RailButton
        if rb and not rb._p53 then
            rb._p53 = true
            local orig = rb.AddBadge
            rb.AddBadge = function(b2, ...)
                if Lib._quiet then return end
                return orig(b2, ...)
            end
        end
    end)
end

P.CreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
    local chat = P.CreateChat(self, cfg)
    if chat and not chat._p53 then
        chat._p53 = true
        chat:_InitP53()
    end
    return chat
end

end
-- ===================== end patch 5.3 =====================

-- ===================== Aether patch 5.4 =====================
do
local P = {}
Lib.Version = "5.4.0"
local CODE_MAX = 10000

-- ---------- 1) sizing ----------
function Lib:_Metrics()
        local vp = GetViewport()
        local scale, w, h
        if self.Touch then
                scale = Clamp(math.min(vp.X / 820, vp.Y / 470), 0.65, 1)
                w = Clamp(vp.X * 0.82 / scale, 440, 780)
                h = Clamp(vp.Y * 0.86 / scale, 270, 500)
        else
                -- 1920x1080 = 1.0x. Smaller screens shrink down to 0.8x, big ones grow up to 1.4x.
                scale = Clamp(math.min(vp.X / 1920, vp.Y / 1080), 0.8, 1.4)
                w = Clamp(vp.X * 0.42 / scale, 560, 800)
                h = Clamp(vp.Y * 0.60 / scale, 380, 540)
        end
        return scale, w, h
end

-- fullscreen used to raise the scale up to 1.5x, which felt huge on a normal monitor
function Lib:_SetFsScale(key, on)
        self._fsUsers = self._fsUsers or {}
        local had = next(self._fsUsers) ~= nil
        if on then
                if not had then self._fsBase = self.Scale end
                self._fsUsers[key] = true
                local vp = GetViewport()
                local want = Clamp(math.min(vp.X / 1280, vp.Y / 720), self._fsBase or self.Scale, 1.25)
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

-- ---------- 2) code blocks up to 10k characters ----------
P.Send = Chat.Send
function Chat:Send(text)
        text = Trim(text or "")
        if #text > 1500 and text:find("```", 1, true) then
                if self.Blocked then return end
                if os.clock() - self.LastSend < 0.8 then self:System("Slow down a little.") return end
                if #text > CODE_MAX then
                        text = text:sub(1, CODE_MAX - 4)
                        if select(2, text:gsub("```", "")) % 2 == 1 then text = text .. "\n```" end
                end
                self.LastSend = os.clock()
                local replyId = self.ReplyTo and self.ReplyTo.id or nil
                self:SetReply(nil)
                self.Stick = true
                task.spawn(function()
                        local res = self:_Do("/send", nil, "POST", HttpService:JSONEncode({ text = text, replyTo = replyId }))
                        local d = Decode(res)
                        if not res or res.StatusCode ~= 200 then self:System((d and d.error) or "Couldn't send.") return end
                        self:_PollOnce()
                end)
                return
        end
        return P.Send(self, text)
end

function Chat:CodeComposer()
        local langBox
        Lib:Dialog({ Title = "Share code", Text = "Paste or type your code (up to " .. CODE_MAX .. " characters). People can copy it, nothing runs automatically.",
                Extra = function(card)
                        local lf = New("Frame", { Size = UDim2.new(1, 0, 0, H(26)), LayoutOrder = 3, ZIndex = 102, Theme = { BackgroundColor3 = "Field" }, Parent = card })
                        Corner(lf, 5) Stroke(lf, "Stroke", 1, 0.3)
                        langBox = New("TextBox", { Text = "lua", PlaceholderText = "language (optional)", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 12,
                                Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(8, 0), TextXAlignment = LEFT, ZIndex = 103, Parent = lf })
                        local f = New("Frame", { Size = UDim2.new(1, 0, 0, 180), LayoutOrder = 3, ZIndex = 102, ClipsDescendants = true, Theme = { BackgroundColor3 = "Field" }, Parent = card })
                        Corner(f, 5) Stroke(f, "Stroke", 1, 0.3)
                        return New("TextBox", { Text = "", PlaceholderText = "Your code...", PlaceholderColor3 = Lib.Theme.Dim, MultiLine = true, TextWrapped = false,
                                Font = Enum.Font.Code, TextSize = 12, Size = UDim2.new(1, -16, 1, -12), Position = UDim2.fromOffset(8, 6), TextXAlignment = LEFT,
                                TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 103, Parent = f })
                end,
                Buttons = { { Text = "Cancel" }, { Text = "Send", Primary = true, Callback = function(body)
                        body = tostring(body or ""):gsub("\r\n", "\n"):gsub("\r", "\n")
                        body = Trim(body)
                        if body == "" then return end
                        local lang = Trim(langBox and langBox.Text or ""):gsub("[^%w_%+%-%.#]", "")
                        local msg = "```" .. lang .. "\n" .. body .. "\n```"
                        if #msg > CODE_MAX then
                                Lib:Notify({ Title = "Share code", Text = "That's too long to send (max " .. CODE_MAX .. " characters).", Type = "error" })
                                return
                        end
                        self:Send(msg)
                end } } })
end

-- ---------- 3) "+" menu: Share Config instead of Search Images ----------
function Chat:ConfigShareMenu(anchor)
        local function Go(name, data) self:ShareConfig(name, data) end
        local items = { { Text = "Current Settings", Icon = "sliders-horizontal", Cb = function()
                local o = Lib.Options.__ConfigName
                local nm = Sanitize(o and o.Value or "")
                if nm == "" then nm = "Shared config" end
                Go(nm, Lib:SerializeConfig())
        end } }
        local saved = {}
        for i, n in ipairs(Lib:ListConfigs()) do
                if i > 20 then break end
                table.insert(saved, { Text = Short(n, 22), Icon = "file", Cb = function()
                        local ok, raw = pcall(function() return readfile(CPath(n)) end)
                        local dec, d = false, nil
                        if ok then dec, d = pcall(HttpService.JSONDecode, HttpService, raw) end
                        if dec and type(d) == "table" then Go(n, d)
                        else Lib:Notify({ Title = "Config", Text = "Couldn't read that config.", Type = "error" }) end
                end })
        end
        self:_PopMenu({ Name = "Share a config", Sub = "to this chat", Glyph = "C", Sections = { items, saved } }, anchor)
end

function Chat:_PlusMenu(anchor)
        self:_PopMenu({ Sections = { {
                { Text = "Share Code...", Icon = "code", Cb = function() self:CodeComposer() end },
                { Text = "Share My Server", Icon = "gamepad-2", Cb = function() self:ShareServer() end },
                { Text = "Share Config...", Icon = "share-2", Cb = function() self:ConfigShareMenu(anchor) end },
        } } }, anchor)
end

-- ---------- 4) mobile: hold a message to open its menu (tap does nothing) ----------
P.OpenMessageMenu = Chat.OpenMessageMenu
function Chat:OpenMessageMenu(msg, touch)
        if touch == true and msg and msg.id then
                -- the long-press handler stamps the item right before it calls us; a plain tap never does
                local item = self.ByLid[msg.id]
                if not (item and os.clock() - (item:GetAttribute("lp") or -10) < 0.6) then return end
        end
        return P.OpenMessageMenu(self, msg, touch)
end

-- ---------- 5) new-messages bar + unread badges ----------
P.UpdateNewBar = Chat._UpdateNewBar
function Chat:_UpdateNewBar()
        local bar, div = self.NewBar, self._div
        if not bar then return end
        if self._barDone or not (div and div.Parent) then bar.Visible = false return end
        local lp, ls = self.List.AbsolutePosition, self.List.AbsoluteSize
        local dy = div.AbsolutePosition.Y
        if self.Loaded and dy + div.AbsoluteSize.Y >= lp.Y + 6 and dy <= lp.Y + ls.Y then
                -- the divider has been on screen: you've seen where the new messages start
                self._barDone = true
                bar.Visible = false
                return
        end
        return P.UpdateNewBar(self)
end

P.PlaceDivider = Chat._PlaceDivider
function Chat:_PlaceDivider(item)
        P.PlaceDivider(self, item)
        self._barDone = false
end

-- DMs / groups: ignore the server's unread count when the last message is one you've already seen
P.SyncRooms = Chat._SyncRooms
function Chat:_SyncRooms(dms, groups)
        pcall(function()
                local S = Lib:LoadChatState()
                local function Seen(room, d)
                        local l = type(d.last) == "table" and tonumber(d.last.id) or nil
                        if not l then return end
                        local ch = self:_FindRoom(room)
                        local read = math.max(ch and tonumber(ch.read) or 0, S.reads[room] or 0)
                        if l <= read then d.unread = 0 end
                end
                for _, d in ipairs(type(dms) == "table" and dms or {}) do
                        local uid = tonumber(d.uid)
                        if uid then Seen(self:DMRoom(uid), d) end
                end
                for _, g in ipairs(type(groups) == "table" and groups or {}) do
                        if g.id ~= nil then Seen("grp:" .. tostring(g.id), g) end
                end
        end)
        return P.SyncRooms(self, dms, groups)
end

-- ---------- 6) avatars in every people list ----------
function Chat:PeopleBrowser(o)
        local z, rh = o.Z or 90, H(34)
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
                local av = New("ImageLabel", { Size = UDim2.fromOffset(24, 24), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 6, 0.5, 0),
                        BackgroundTransparency = 0, ScaleType = Enum.ScaleType.Crop, ZIndex = z + 2, Theme = { BackgroundColor3 = "Field" }, Parent = b })
                Corner(av, 12)
                local uid = tonumber(u.uid)
                if uid then GetAvatar(uid, function(url) if av.Parent then av.Image = url end end) end
                local dot = New("Frame", { Size = UDim2.fromOffset(9, 9), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 3, 1, 3), ZIndex = z + 3,
                        BackgroundColor3 = u.online and Lib.Theme.Good or Lib.Theme.Dim, Parent = av })
                Corner(dot, 5) Stroke(dot, "Surface", 2, 0)
                New("TextLabel", { RichText = true, Text = RichEsc(u.display or u.name) .. " <font color='#" .. ToHex(Lib.Theme.Dim) .. "'>@" .. RichEsc(u.name) .. "</font>",
                        TextSize = 12, Size = UDim2.new(1, -112, 1, 0), Position = UDim2.fromOffset(38, 0), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = z + 2, Parent = b })
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

-- ---------- hooks ----------
P.CreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
        local chat = P.CreateChat(self, cfg)
        if chat and not chat._p54 then
                chat._p54 = true
                chat.Config.MaxLength = CODE_MAX
                if chat.NewBar then
                        chat.NewBar.Activated:Connect(function()
                                chat._barDone = true
                                chat.NewBar.Visible = false
                        end)
                end
        end
        return chat
end

end
-- ===================== end patch 5.4 =====================

-- ===================== Aether patch 5.5 =====================
-- Paste right above the final `return Lib` (after patch 5.4).
--
--  1) Per-game chat channels are gone. The chat has Global + DMs + groups.
--     Lib:CreateChat({ Channels = ... }), ChannelsKey and getgenv().<Name>Channels are ignored.
--  2) The chat server address is built in. ChatUrl / Url from a script are ignored.
--  3) Profile cards show which hub the person is using (the Title the script owner gave CreateWindow),
--     e.g. "Using  Aether v1.0.0". Two different hubs that are both called "Aether" are told apart
--     with a short id: the card shows "Aether v1.0.0 (another hub #3fa9)".
--
-- Needs worker.js v2.5.1 (stores hub / hid / hv and returns them from /profile).
do
local P = {}
Lib.Version = "5.5.0"

-- the chat server. Not configurable from a script any more.
local CHAT_URL = "https://aether-chat.j6n7.workers.dev"
Lib.DefaultChatUrl = CHAT_URL

-- ---------- hub identity ----------
local function HubHash(s)
        local h = 5381
        for i = 1, #s do h = (h * 33 + s:byte(i)) % 4294967296 end
        return string.format("%08x", h):sub(1, 6)
end

local function CleanName(s)
        s = tostring(s or ""):gsub("%c", " ")
        s = s:gsub("%s+", " ")
        return Trim(s):sub(1, 24)
end

Lib.Hub = { Name = "Aether", Id = HubHash("Aether"), Version = "" }

P.CreateWindow = Lib.CreateWindow
function Lib:CreateWindow(cfg)
        cfg = cfg or {}
        cfg.ChatUrl, cfg.ChannelsKey = nil, nil -- removed options
        local win = P.CreateWindow(self, cfg)
        self.DefaultChatUrl = CHAT_URL
        local name = CleanName(cfg.Title)
        if name == "" then name = "Aether" end
        -- the id is what tells two hubs with the same name apart. Set HubId yourself to pin it down,
        -- otherwise it is made from Title + EnvKey + Folder.
        local id = (tostring(cfg.HubId or ""):gsub("[^%w]", "")):sub(1, 12)
        if id == "" then id = HubHash(name .. "|" .. tostring(cfg.EnvKey or "") .. "|" .. tostring(cfg.Folder or name)) end
        self.Hub = { Name = name, Id = id, Version = (tostring(cfg.Version or ""):gsub("[^%w%.%-_]", "")):sub(1, 12) }
        return win
end

-- ---------- chat: no channel config, fixed server, hub info on every request ----------
P.CreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
        cfg = cfg or {}
        cfg.Url = CHAT_URL
        cfg.Channels = {} -- an empty list means only "Global"
        return P.CreateChat(self, cfg)
end

function Chat:AddChannel() end
function Lib:Channels() return self.ChatObj end

P.Do = Chat._Do
function Chat:_Do(path, query, method, body, room)
        self.Config.Url = CHAT_URL
        query = query or {}
        local h = Lib.Hub
        query.hub, query.hid, query.hv = h.Name, h.Id, h.Version
        return P.Do(self, path, query, method, body, room)
end

-- ---------- profile card: "Using <hub>" ----------
local function HubText(hub, hid, hv)
        hub = tostring(hub or "")
        if hub == "" then return "Unknown" end
        local t = hub
        hv = tostring(hv or "")
        if hv ~= "" then t = t .. " v" .. (hv:gsub("^[vV]", "")) end
        local mine = Lib.Hub
        hid = tostring(hid or "")
        if hid ~= "" and hub:lower() == mine.Name:lower() and hid ~= mine.Id then
                t = t .. " (another hub #" .. hid:sub(1, 4) .. ")"
        end
        return t
end

P.ShowProfile = Chat.ShowProfile
function Chat:ShowProfile(u)
        local before = {}
        for _, c in ipairs(Lib.Overlay:GetChildren()) do before[c] = true end
        P.ShowProfile(self, u)
        local ok, err = pcall(function()
                local uid = tonumber(u.uid)
                if not uid then return end
                local dim
                for _, c in ipairs(Lib.Overlay:GetChildren()) do
                        if not before[c] and c:IsA("TextButton") then dim = c end
                end
                local card = dim and dim:FindFirstChildWhichIsA("Frame")
                if not card then return end
                -- slot a row in right under the header: shift everything below it down by one
                for _, c in ipairs(card:GetChildren()) do
                        if c:IsA("GuiObject") and c.LayoutOrder >= 2 then c.LayoutOrder = c.LayoutOrder + 1 end
                end
                local row = New("Frame", { Name = "HubRow", Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, LayoutOrder = 2, ZIndex = 102, Parent = card })
                New("TextLabel", { Text = "Using", TextSize = 12, Size = UDim2.new(0.3, 0, 1, 0), TextXAlignment = LEFT, ZIndex = 103,
                        Theme = { TextColor3 = "SubText" }, Parent = row })
                local val = New("TextLabel", { Text = "...", Font = Lib.FontBold, TextSize = 12, Size = UDim2.new(0.7, 0, 1, 0), Position = UDim2.fromScale(0.3, 0),
                        TextXAlignment = RIGHT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 103, Theme = { TextColor3 = "Accent" }, Parent = row })
                if uid == LocalPlayer.UserId then
                        local h = Lib.Hub
                        val.Text = HubText(h.Name, h.Id, h.Version)
                        return
                end
                task.spawn(function()
                        local d = Decode(self:_Do("/profile", { target = uid }))
                        if not val.Parent then return end
                        if d and d.ok and d.user then val.Text = HubText(d.user.hub, d.user.hid, d.user.hv)
                        else val.Text = "Unknown" end
                end)
        end)
        if not ok then warn("[Aether] hub row: " .. tostring(err)) end
end

end
-- ===================== end patch 5.5 =====================

-- ===================== Aether patch 5.6 (ratings, presence, slash commands, polls) =====================
do
local P = {}
Lib.Version = "5.6.0"

-- ==================== 0) small prefs ====================
Lib.Extras = { presence = true }
do
    local loaded, tick = false, 0
    local function Path() return Lib.ConfigFolder .. "/chatextras.json" end
    function Lib:LoadExtras()
        if loaded then return self.Extras end
        loaded = true
        if FsOk() then
            pcall(function()
                local p = Path()
                if not isfile(p) then return end
                local d = HttpService:JSONDecode(readfile(p))
                if type(d) == "table" and type(d.presence) == "boolean" then self.Extras.presence = d.presence end
            end)
        end
        return self.Extras
    end
    function Lib:SaveExtras()
        if not FsOk() then return end
        tick = tick + 1
        local t = tick
        task.delay(0.6, function()
            if t ~= tick then return end
            pcall(function()
                if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                writefile(Path(), HttpService:JSONEncode({ presence = Lib.Extras.presence }))
            end)
        end)
    end
end

-- poll / rating votes are reactions, keep them out of the "recent emoji" list
P.PushRecent = Lib.PushRecentEmoji
function Lib:PushRecentEmoji(e)
    if Lib._noRecent then return end
    return P.PushRecent(self, e)
end
local function Silent(fn)
    Lib._noRecent = true
    pcall(fn)
    Lib._noRecent = false
end

local function Private(chat)
    local r = chat.Room
    return type(r) == "string" and (r:sub(1, 3) == "dm:" or r:sub(1, 4) == "grp:")
end

local function Mine(entry)
    for _, u in ipairs(entry.u or {}) do if tonumber(u) == LocalPlayer.UserId then return true end end
    return false
end

local function Tally(rx, emoji)
    for _, r in ipairs(rx or {}) do
        if r.e == emoji then return #(r.u or {}), Mine(r) end
    end
    return 0, false
end

local function CleanPart(s, n)
    s = tostring(s or "")
    s = s:gsub("[|%[%]%c]", " ")
    s = Trim(s)
    s = s:gsub("%s+", " ")
    local len = utf8.len(s)
    if len and len > n then s = s:sub(1, utf8.offset(s, n + 1) - 1) elseif not len then s = s:sub(1, n) end
    return s
end

-- ==================== 1) RATINGS (👍 / 👎 on config cards and code messages) ====================
local UP, DOWN = "👍", "👎"

function Chat:_AddRating(item, meta)
    local col = item:FindFirstChild("Col")
    local bubble = col and col:FindFirstChild("Bubble")
    if not bubble or meta.rateRow then return end
    meta.isRated = true
    local msg = meta.msg
    local what = msg.cfg and "config" or "script"
    local row = New("Frame", { Name = "RateRow", Size = UDim2.new(1, 0, 0, H(24)), LayoutOrder = 500, BackgroundTransparency = 1, Parent = bubble })
    List(row, 5, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
    local function Btn(emoji, order, tip)
        local b = New("TextButton", { Text = "", TextSize = 12, AutomaticSize = X, Size = UDim2.fromOffset(0, H(22)), LayoutOrder = order, BackgroundTransparency = 0,
            Theme = { BackgroundColor3 = "Bg", TextColor3 = "SubText" }, Parent = row })
        Corner(b, 11) Pad(b, 9, 0, 9, 0)
        local st = Stroke(b, "Stroke", 1, 0.5)
        b.Activated:Connect(function() self:RateMessage(msg, emoji) end)
        Lib:AddTooltip(b, tip)
        return b, st
    end
    local up, upS = Btn(UP, 1, "Works / good " .. what)
    local dn, dnS = Btn(DOWN, 2, "Broken / bad " .. what)
    local sum = New("TextLabel", { Text = "", TextSize = 11, AutomaticSize = X, Size = UDim2.fromOffset(0, H(22)), LayoutOrder = 3, TextXAlignment = LEFT,
        Theme = { TextColor3 = "Dim" }, Parent = row })
    Pad(sum, 4, 0, 0, 0)
    meta.rateRow = { row = row, up = up, upS = upS, dn = dn, dnS = dnS, sum = sum, what = what }
    self:_UpdateRating(item, meta)
end

function Chat:_UpdateRating(item, meta)
    local r = meta.rateRow
    if not (r and r.row.Parent) then return end
    local u, um = Tally(meta.rx, UP)
    local d, dm = Tally(meta.rx, DOWN)
    r.up.Text, r.dn.Text = UP .. " " .. u, DOWN .. " " .. d
    r.up.TextColor3 = um and Lib.Theme.Text or Lib.Theme.SubText
    r.dn.TextColor3 = dm and Lib.Theme.Text or Lib.Theme.SubText
    r.upS.Color, r.upS.Transparency = um and Lib.Theme.Good or Lib.Theme.Stroke, um and 0.05 or 0.5
    r.dnS.Color, r.dnS.Transparency = dm and Lib.Theme.Bad or Lib.Theme.Stroke, dm and 0.05 or 0.5
    local total = u + d
    if total == 0 then
        r.sum.Text = "Rate this " .. r.what
    else
        r.sum.Text = math.floor(u / total * 100 + 0.5) .. "% liked · " .. total .. (total == 1 and " rating" or " ratings")
    end
end

function Chat:RateMessage(msg, emoji)
    if not (msg and msg.id) then return end
    if tostring(msg.uid) == tostring(LocalPlayer.UserId) then
        Lib:Notify({ Title = "Rating", Text = "You can't rate your own post.", Type = "warn", Duration = 3 })
        return
    end
    local item = self.ByLid[msg.id]
    local meta = item and self.Meta[item]
    local rx = meta and meta.rx or {}
    local _, upMine = Tally(rx, UP)
    local _, dnMine = Tally(rx, DOWN)
    local other = emoji == UP and DOWN or UP
    local otherMine = emoji == UP and dnMine or upMine
    if otherMine then
        Silent(function() self:React(msg.id, other) end)
        task.delay(0.4, function() Silent(function() self:React(msg.id, emoji) end) end)
    else
        Silent(function() self:React(msg.id, emoji) end)
    end
end

-- ==================== 2) POLLS (DMs and group chats only) ====================
local function PollEmoji(i)
    if i == 10 then return "🔟" end
    return tostring(i) .. utf8.char(0xFE0F, 0x20E3)
end

local function ParsePoll(txt)
    txt = Trim(tostring(txt or ""))
    local body = txt:match("^%[poll|(.*)%]$")
    if not body then return nil end
    local parts = {}
    for piece in (body .. "|"):gmatch("([^|]*)|") do parts[#parts + 1] = Trim(piece) end
    local q = table.remove(parts, 1)
    if not q or q == "" or #parts < 2 or #parts > 10 then return nil end
    for i, o in ipairs(parts) do
        if o == "" then return nil end
        parts[i] = o:sub(1, 60)
    end
    return { q = q:sub(1, 140), opts = parts }
end

function Chat:_BuildPoll(item, meta, msg, poll)
    meta.isPoll, meta.isCard, meta.poll = true, true, poll
    meta.body.Visible = false
    local col = item:FindFirstChild("Col")
    local bubble = col and col:FindFirstChild("Bubble")
    if not bubble then return end
    local card = New("Frame", { Name = "PollCard", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Y, LayoutOrder = 3, BackgroundTransparency = 0.35,
        Theme = { BackgroundColor3 = "Bg" }, Parent = bubble })
    Corner(card, 6) Pad(card, 10, 8, 10, 8) List(card, 5)
    New("TextLabel", { Text = "POLL", Font = Lib.FontBold, TextSize = 10, Size = UDim2.new(1, 0, 0, 12), TextXAlignment = LEFT, LayoutOrder = 1,
        Theme = { TextColor3 = "Accent" }, Parent = card })
    local q = New("TextLabel", { Text = poll.q, Font = Lib.FontBold, TextSize = 13, Size = UDim2.new(1, 0, 0, 16), TextXAlignment = LEFT,
        TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = 2, Parent = card })
    Wrap(q, nil, nil, 16)
    meta.pollRows = {}
    for i, o in ipairs(poll.opts) do
        local b = New("TextButton", { Name = "Opt", Text = "", Size = UDim2.new(1, 0, 0, H(28)), LayoutOrder = 2 + i, BackgroundTransparency = 0,
            ClipsDescendants = true, Theme = { BackgroundColor3 = "Field" }, Parent = card })
        Corner(b, 5)
        local fill = New("Frame", { Size = UDim2.fromScale(0, 1), BackgroundTransparency = 0.72, Theme = { BackgroundColor3 = "Accent" }, Parent = b })
        Corner(fill, 5)
        New("TextLabel", { Text = o, TextSize = 12, Size = UDim2.new(1, -84, 1, 0), Position = UDim2.fromOffset(10, 0), TextXAlignment = LEFT,
            TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 2, Parent = b })
        local cnt = New("TextLabel", { Text = "0", TextSize = 11, Size = UDim2.fromOffset(72, H(28)), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 0),
            TextXAlignment = RIGHT, ZIndex = 2, Theme = { TextColor3 = "SubText" }, Parent = b })
        local st = Stroke(b, "Accent", 1, 1)
        b.Activated:Connect(function() self:VotePoll(msg, poll, i) end)
        meta.pollRows[i] = { fill = fill, cnt = cnt, st = st }
    end
    meta.pollFoot = New("TextLabel", { Text = "", TextSize = 10, Size = UDim2.new(1, 0, 0, 12), LayoutOrder = 100, TextXAlignment = LEFT,
        Theme = { TextColor3 = "Dim" }, Parent = card })
    self:_WidenItem(item)
    self:_UpdatePoll(item, meta)
end

function Chat:_UpdatePoll(item, meta)
    if not (meta.isPoll and meta.pollRows) then return end
    local counts, total, mineIdx = {}, 0, nil
    for i = 1, #meta.poll.opts do
        local n, m = Tally(meta.rx, PollEmoji(i))
        counts[i] = n
        total = total + n
        if m then mineIdx = i end
    end
    for i, r in ipairs(meta.pollRows) do
        local pct = total > 0 and counts[i] / total or 0
        Tween(r.fill, { Size = UDim2.fromScale(pct, 1) }, 0.2)
        r.cnt.Text = counts[i] .. (total > 0 and (" · " .. math.floor(pct * 100 + 0.5) .. "%") or "")
        r.st.Transparency = (mineIdx == i) and 0.15 or 1
    end
    meta.pollFoot.Text = total .. (total == 1 and " vote" or " votes") .. (mineIdx and " · tap your pick again to undo" or " · tap an option to vote")
end

function Chat:VotePoll(msg, poll, idx)
    if not (msg and msg.id) then return end
    local item = self.ByLid[msg.id]
    local meta = item and self.Meta[item]
    local rx = meta and meta.rx or {}
    local e = PollEmoji(idx)
    local _, already = Tally(rx, e)
    local others = {}
    for i = 1, #poll.opts do
        if i ~= idx then
            local _, m = Tally(rx, PollEmoji(i))
            if m then others[#others + 1] = PollEmoji(i) end
        end
    end
    for _, o in ipairs(others) do Silent(function() self:React(msg.id, o) end) end
    if already then
        if #others == 0 then Silent(function() self:React(msg.id, e) end) end
    elseif #others > 0 then
        task.delay(0.4, function() Silent(function() self:React(msg.id, e) end) end)
    else
        Silent(function() self:React(msg.id, e) end)
    end
end

function Chat:_SendRaw(text)
    if self.Blocked or not self.Request then return end
    if os.clock() - self.LastSend < 0.8 then self:System("Slow down a little.") return end
    self.LastSend = os.clock()
    local replyId = self.ReplyTo and self.ReplyTo.id or nil
    self:SetReply(nil)
    self.Stick = true
    task.spawn(function()
        local res = self:_Do("/send", nil, "POST", HttpService:JSONEncode({ text = text, replyTo = replyId }))
        local d = Decode(res)
        if not res or res.StatusCode ~= 200 then self:System((d and d.error) or "Couldn't send.") return end
        self:_PollOnce()
    end)
end

function Chat:CreatePoll(q, opts)
    if not Private(self) then self:System("Polls only work in DMs and group chats.") return end
    q = CleanPart(q, 140)
    local list = {}
    for _, o in ipairs(opts) do
        o = CleanPart(o, 60)
        if o ~= "" then list[#list + 1] = o end
    end
    if q == "" then self:System("A poll needs a question.") return end
    if #list < 2 then self:System("A poll needs at least 2 options.") return end
    if #list > 10 then self:System("A poll can have at most 10 options.") return end
    self:_SendRaw("[poll|" .. q .. "|" .. table.concat(list, "|") .. "]")
end

function Chat:PollComposer()
    if not Private(self) then self:System("Polls only work in DMs and group chats.") return end
    local qBox
    Lib:Dialog({ Title = "Create a poll", Text = "One option per line, 2 to 10 options. Everyone here can vote, one vote each.",
        Extra = function(card)
            local qf = New("Frame", { Size = UDim2.new(1, 0, 0, H(26)), LayoutOrder = 3, ZIndex = 102, Theme = { BackgroundColor3 = "Field" }, Parent = card })
            Corner(qf, 5) Stroke(qf, "Stroke", 1, 0.3)
            qBox = New("TextBox", { Text = "", PlaceholderText = "Question", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 12, Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.fromOffset(8, 0), TextXAlignment = LEFT, ZIndex = 103, Parent = qf })
            local f = New("Frame", { Size = UDim2.new(1, 0, 0, 120), LayoutOrder = 3, ZIndex = 102, ClipsDescendants = true, Theme = { BackgroundColor3 = "Field" }, Parent = card })
            Corner(f, 5) Stroke(f, "Stroke", 1, 0.3)
            return New("TextBox", { Text = "", PlaceholderText = "Option 1\nOption 2\nOption 3", PlaceholderColor3 = Lib.Theme.Dim, MultiLine = true, TextWrapped = true,
                TextSize = 12, Size = UDim2.new(1, -16, 1, -12), Position = UDim2.fromOffset(8, 6), TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top,
                ZIndex = 103, Parent = f })
        end,
        Buttons = { { Text = "Cancel" }, { Text = "Post poll", Primary = true, Callback = function(body)
            local opts = {}
            for line in (tostring(body or "") .. "\n"):gmatch("([^\n]*)\n") do
                line = Trim(line)
                if line ~= "" then opts[#opts + 1] = line end
            end
            self:CreatePoll(qBox and qBox.Text or "", opts)
        end } } })
end

-- ==================== 3) reactions hook: hide poll / rating chips, refresh the cards ====================
P.RenderReactions = Chat._RenderReactions
function Chat:_RenderReactions(item, list)
    P.RenderReactions(self, item, list)
    pcall(function()
        local meta = self.Meta[item]
        if not meta then return end
        local col = item:FindFirstChild("Col")
        local row = col and col:FindFirstChild("Reacts")
        if meta.isPoll then
            if row then row.Visible = false end
            self:_UpdatePoll(item, meta)
        end
        if meta.isRated then
            if row then
                local left = 0
                for _, c in ipairs(row:GetChildren()) do
                    if c:IsA("TextButton") then
                        local t = c.Text
                        if t:sub(1, #UP) == UP or t:sub(1, #DOWN) == DOWN then c:Destroy() else left = left + 1 end
                    end
                end
                row.Visible = left > 0
            end
            self:_UpdateRating(item, meta)
        end
    end)
end

P.AddMessage = Chat.AddMessage
function Chat:AddMessage(msg)
    local last = self.Items[#self.Items]
    local res = P.AddMessage(self, msg)
    local item = self.Items[#self.Items]
    local meta = item and item ~= last and self.Meta[item]
    if meta and meta.msg == msg and msg.id then
        local ok, err = pcall(function()
            local poll = ParsePoll(meta.txt)
            if poll then
                if Private(self) then
                    self:_BuildPoll(item, meta, msg, poll)
                else
                    meta.isCard = true
                    meta.body.Visible = true
                    meta.body.Text = "📊 Polls only work in DMs and group chats."
                end
            elseif msg.cfg or meta.txt:find("```", 1, true) then
                self:_AddRating(item, meta)
            end
            if meta.isPoll or meta.isRated then self:_RenderReactions(item, meta.rx or msg.reactions or {}) end
        end)
        if not ok then warn("[Aether] ratings/polls: " .. tostring(err)) end
    end
    return res
end

-- polls can't be edited into something else
P.MenuItems = Chat._MenuItems
function Chat:_MenuItems(msg)
    local groups = P.MenuItems(self, msg)
    local item = msg and msg.id and self.ByLid[msg.id]
    local meta = item and self.Meta[item]
    if meta and (meta.isPoll or ParsePoll(meta.txt)) then
        for _, g in ipairs(groups) do
            for i = #g, 1, -1 do if g[i].Text == "Edit Message" then table.remove(g, i) end end
        end
    end
    return groups
end

-- ==================== 4) SLASH COMMANDS (DMs and group chats only) ====================
local Cmds, CmdOrder = {}, {}
local function Def(name, usage, desc, fn, groupOnly)
    Cmds[name] = { usage = usage, desc = desc, run = fn, group = groupOnly }
    CmdOrder[#CmdOrder + 1] = name
end
local function CurGroup(chat)
    local ch = chat.Channels[chat.ChIndex]
    if ch and ch.kind == "grp" then return ch end
    chat:System("That command only works in group chats.")
    return nil
end
local function Plain(chat, text) return P.Send(chat, text) end

Def("me", "/me <action>", "Send an action, like \"*waves*\".", function(c, a)
    if a == "" then c:System("Usage: /me <action>") return end
    Plain(c, "*" .. a .. "*")
end)
Def("shrug", "/shrug [text]", "Appends ¯\\_(ツ)_/¯ to your message.", function(c, a)
    Plain(c, (a ~= "" and (a .. " ") or "") .. "¯\\_(ツ)_/¯")
end)
Def("tableflip", "/tableflip [text]", "Appends (╯°□°)╯︵ ┻━┻", function(c, a)
    Plain(c, (a ~= "" and (a .. " ") or "") .. "(╯°□°)╯︵ ┻━┻")
end)
Def("unflip", "/unflip [text]", "Appends ┬─┬ ノ( ゜-゜ノ)", function(c, a)
    Plain(c, (a ~= "" and (a .. " ") or "") .. "┬─┬ ノ( ゜-゜ノ)")
end)
Def("lenny", "/lenny [text]", "Appends ( ͡° ͜ʖ ͡°)", function(c, a)
    Plain(c, (a ~= "" and (a .. " ") or "") .. "( ͡° ͜ʖ ͡°)")
end)
Def("spoiler", "/spoiler <text>", "Hides your message behind a spoiler.", function(c, a)
    if a == "" then c:System("Usage: /spoiler <text>") return end
    Plain(c, "||" .. a .. "||")
end)
Def("roll", "/roll [NdM]", "Roll dice, e.g. /roll 2d20. Default 1d6.", function(c, a)
    local n, s = "1", "6"
    if a ~= "" then
        n, s = a:match("^(%d*)[dD](%d+)$")
        if not s then c:System("Usage: /roll 2d20  (up to 20 dice, 1000 sides)") return end
    end
    n = Clamp(tonumber(n) or 1, 1, 20)
    s = Clamp(tonumber(s) or 6, 2, 1000)
    local rolls, sum = {}, 0
    for i = 1, n do
        rolls[i] = math.random(1, s)
        sum = sum + rolls[i]
    end
    Plain(c, "🎲 rolled " .. n .. "d" .. s .. ": " .. (n > 1 and (table.concat(rolls, " + ") .. " = ") or "") .. "**" .. sum .. "**")
end)
Def("flip", "/flip", "Flip a coin.", function(c)
    Plain(c, "🪙 flipped a coin: **" .. (math.random(2) == 1 and "Heads" or "Tails") .. "**")
end)
local Ball = { "It is certain.", "Without a doubt.", "Yes, definitely.", "Most likely.", "Signs point to yes.", "Ask again later.",
    "Cannot predict now.", "Don't count on it.", "My reply is no.", "Very doubtful." }
Def("8ball", "/8ball <question>", "Ask the magic 8-ball.", function(c, a)
    if a == "" then c:System("Usage: /8ball <question>") return end
    Plain(c, "🎱 " .. a .. " → **" .. Ball[math.random(#Ball)] .. "**")
end)
Def("nick", "/nick [name]", "Change your chat display name. Empty = your Roblox name.", function(c, a)
    Lib:SetChatName(a)
    pcall(function() local o = Lib.Options.__ChatName if o then o:SetValue(a, true) end end)
    c:System(a == "" and "Using your Roblox display name again." or ("Your chat name is now \"" .. CleanPart(a, 24) .. "\" (applies to new messages)."))
end)
Def("poll", "/poll Question | A | B | C", "Start a poll (2 to 10 options). Just /poll opens a form.", function(c, a)
    if a == "" then c:PollComposer() return end
    local parts = {}
    for piece in (a .. "|"):gmatch("([^|]*)|") do parts[#parts + 1] = piece end
    local q = table.remove(parts, 1)
    c:CreatePoll(q, parts)
end)
Def("code", "/code", "Open the share code composer.", function(c) c:CodeComposer() end)
Def("join", "/join", "Share your current server as a Join card.", function(c) c:ShareServer() end)
Def("mute", "/mute", "Mute this chat (no badges or popups).", function(c)
    local ch = c.Channels[c.ChIndex]
    Lib:SetNotif(ch.room, "none") ch.unread = 0 c:_RefreshChannel()
    c:System("Muted. Use /unmute to turn notifications back on.")
end)
Def("mentions", "/mentions", "Only notify me about @mentions and replies here.", function(c)
    local ch = c.Channels[c.ChIndex]
    Lib:SetNotif(ch.room, "mentions") ch.unread = 0 c:_RefreshChannel()
    c:System("Only mentions and replies will notify you here.")
end)
Def("unmute", "/unmute", "Notify me about every message here again.", function(c)
    local ch = c.Channels[c.ChIndex]
    Lib:SetNotif(ch.room, "all") c:_RefreshChannel()
    c:System("Notifications are back on for this chat.")
end)
Def("clear", "/clear", "Clear your view of this chat (nothing is deleted).", function(c)
    c:_ClearAll()
    c:System("Cleared your view. Messages come back when you reopen this chat.")
end)
Def("search", "/search [text]", "Search messages in this chat.", function(c, a)
    c:ToggleSearch(true)
    if a ~= "" then c.SearchBox.Text = a end
end)
Def("pins", "/pins", "Show pinned messages.", function(c) c:ShowPins() end)
Def("dm", "/dm <@user|id>", "Open a DM with someone.", function(c, a)
    if a == "" then c:System("Usage: /dm @username") return end
    c:ResolveUser(a, function(u)
        if not u then Lib:Notify({ Title = "Direct message", Text = "Couldn't find that Roblox user.", Type = "error" }) return end
        if u.uid == LocalPlayer.UserId then Lib:Notify({ Title = "Direct message", Text = "That's you.", Type = "warn" }) return end
        c:OpenDM(u.uid, u.name, u.display)
    end)
end)
Def("friend", "/friend <@user|id>", "Send a friend request.", function(c, a)
    if a == "" then c:System("Usage: /friend @username") return end
    c:ResolveUser(a, function(u)
        if not u then Lib:Notify({ Title = "Friends", Text = "Couldn't find that Roblox user.", Type = "error" }) return end
        if u.uid == LocalPlayer.UserId then Lib:Notify({ Title = "Friends", Text = "That's you.", Type = "warn" }) return end
        c:Friend("request", u)
    end)
end)
Def("block", "/block <@user|id>", "Hide someone's messages.", function(c, a)
    if a == "" then c:System("Usage: /block @username") return end
    c:ResolveUser(a, function(u)
        if not u then Lib:Notify({ Title = "Block", Text = "Couldn't find that Roblox user.", Type = "error" }) return end
        Lib:Block(u.uid, u.name)
    end)
end)
Def("unblock", "/unblock <@user|id>", "Unblock someone.", function(c, a)
    if a == "" then c:System("Usage: /unblock @username") return end
    c:ResolveUser(a, function(u)
        if not u then Lib:Notify({ Title = "Block", Text = "Couldn't find that Roblox user.", Type = "error" }) return end
        Lib:Unblock(u.uid)
        Lib:Notify({ Title = "Block", Text = "Unblocked " .. tostring(u.name) .. ".", Type = "success", Duration = 2.5 })
    end)
end)
Def("invite", "/invite <@user|id>", "Invite someone to this group.", function(c, a)
    local g = CurGroup(c)
    if not g then return end
    if a == "" then c:InviteToGroup(g.gid) return end
    c:ResolveUser(a, function(u)
        if not u then Lib:Notify({ Title = "Group chat", Text = "Couldn't find that Roblox user.", Type = "error" }) return end
        task.spawn(function()
            local d = Decode(c:_Do("/group/invite", nil, "POST", HttpService:JSONEncode({ id = g.gid, uids = { tonumber(u.uid) } })))
            if d and d.ok then
                Lib:Notify({ Title = "Group chat", Text = "Invited " .. tostring(u.display or u.name) .. ".", Type = "success", Duration = 3 })
                c:_PollOnce()
            else
                Lib:Notify({ Title = "Group chat", Text = (d and d.error) or "Couldn't invite them.", Type = "error" })
            end
        end)
    end)
end, true)
Def("rename", "/rename <name>", "Rename this group (owner only).", function(c, a)
    local g = CurGroup(c)
    if not g then return end
    if a == "" then c:RenameGroup(g.gid) return end
    local name = CleanPart(a, 32)
    task.spawn(function()
        local d = Decode(c:_Do("/group/rename", nil, "POST", HttpService:JSONEncode({ id = g.gid, name = name })))
        if d and d.ok then
            g.name = name
            c:_RefreshChannel()
            c:SaveConvos()
            Lib:Notify({ Title = "Group chat", Text = "Renamed to «" .. name .. "».", Type = "success", Duration = 3 })
        else
            Lib:Notify({ Title = "Group chat", Text = (d and d.error) or "Couldn't rename.", Type = "error" })
        end
    end)
end, true)
Def("leave", "/leave", "Leave this group.", function(c)
    local g = CurGroup(c)
    if g then c:LeaveGroup(g) end
end, true)
Def("help", "/help", "Show this list.", function(c) c:ShowHelp() end)

function Chat:ShowHelp()
    local Z, W, HH = 140, 350, 430
    local dim = New("TextButton", { Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.45, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = Z, Parent = Lib.Overlay })
    local card = Sink(New("Frame", { Size = UDim2.fromOffset(W, HH), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = Z + 1,
        Theme = { BackgroundColor3 = "Bg" }, Parent = dim }))
    Corner(card, 10) Stroke(card)
    New("UIScale", { Scale = math.min(1, Lib.Overlay.AbsoluteSize.X / (W + 20), Lib.Overlay.AbsoluteSize.Y / (HH + 20)), Parent = card })
    New("TextLabel", { Text = "Slash commands", Font = Lib.FontBold, TextSize = 14, Size = UDim2.new(1, -80, 0, 30), Position = UDim2.fromOffset(12, 0),
        TextXAlignment = LEFT, ZIndex = Z + 2, Parent = card })
    local close = New("TextButton", { Text = "Close", TextSize = 12, Size = UDim2.fromOffset(52, 22), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 4),
        BackgroundTransparency = 0, ZIndex = Z + 2, Theme = { BackgroundColor3 = "Field", TextColor3 = "Text" }, Parent = card })
    Corner(close, 5)
    local function Close() if dim.Parent then dim:Destroy() end end
    close.Activated:Connect(Close)
    dim.Activated:Connect(Close)
    New("TextLabel", { Text = "Only in DMs and group chats. Start a message with // to send a literal slash.", TextSize = 11, Size = UDim2.new(1, -24, 0, 14),
        Position = UDim2.fromOffset(12, 30), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = Z + 2, Theme = { TextColor3 = "Dim" }, Parent = card })
    local scroll = New("ScrollingFrame", { Size = UDim2.new(1, -16, 1, -54), Position = UDim2.fromOffset(8, 48), AutomaticCanvasSize = Y, ScrollBarThickness = 2, ZIndex = Z + 2, Parent = card })
    List(scroll, 6)
    for i, n in ipairs(CmdOrder) do
        local c = Cmds[n]
        local l = New("TextLabel", { RichText = true, TextSize = 12, Size = UDim2.new(1, -6, 0, 30), LayoutOrder = i, TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = Z + 3, Theme = { TextColor3 = "SubText" }, Parent = scroll,
            Text = "<b><font color='#" .. Hex("Accent") .. "'>" .. Esc(c.usage) .. "</font></b>" .. (c.group and ("  <font color='#" .. Hex("Dim") .. "'>groups only</font>") or "")
                .. "\n" .. Esc(c.desc) })
        Wrap(l, nil, nil, 30)
    end
end

-- /command suggestions while you type (DMs and groups only)
function Chat:_InitSlash()
    if self._slash then return end
    self._slash = true
    local input = self.Input
    local par = (self._sb and self._sb.main) or self.Frame
    local sug = Sink(New("Frame", { Name = "SlashSuggest", Visible = false, Size = UDim2.new(1, -16, 0, 0), AutomaticSize = Y, AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 8, 1, -(H(32) + 14)), BackgroundTransparency = 0, ZIndex = 22, Theme = { BackgroundColor3 = "Surface" }, Parent = par }))
    Corner(sug, 6) Stroke(sug) Pad(sug, 3, 3, 3, 3) List(sug, 0)
    input:GetPropertyChangedSignal("Text"):Connect(function()
        for _, c in ipairs(sug:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        local part = Private(self) and input.Text:match("^/(%w*)$")
        if not part then sug.Visible = false return end
        part = part:lower()
        local cur = self.Channels[self.ChIndex]
        local found = {}
        for _, n in ipairs(CmdOrder) do
            local c = Cmds[n]
            if n:sub(1, #part) == part and not (c.group and not (cur and cur.kind == "grp")) then
                found[#found + 1] = n
                if #found >= 6 then break end
            end
        end
        if #found == 0 then sug.Visible = false return end
        sug.Position = UDim2.new(0, 8, 1, -(self.ListBottom - 2 + (self.ReplyTo and 28 or 0) + (self.TypeOn and 18 or 0)))
        for i, n in ipairs(found) do
            local c = Cmds[n]
            local b = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, H(28)), LayoutOrder = i, ZIndex = 23, BackgroundTransparency = 1,
                BackgroundColor3 = Lib.Theme.FieldHover, Parent = sug })
            Corner(b, 4)
            New("TextLabel", { RichText = true, TextSize = 12, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(9, 0), TextXAlignment = LEFT,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 24, Text = "<b>/" .. n .. "</b>  <font color='#" .. Hex("Dim") .. "'>" .. Esc(c.desc) .. "</font>", Parent = b })
            b.MouseEnter:Connect(function() Tween(b, { BackgroundTransparency = 0.3 }, 0.06) end)
            b.MouseLeave:Connect(function() Tween(b, { BackgroundTransparency = 1 }, 0.08) end)
            local picked = false
            local function Pick()
                if picked then return end
                picked = true
                input.Text = "/" .. n .. " "
                sug.Visible = false
                task.defer(function() input:CaptureFocus() end)
            end
            b.InputBegan:Connect(function(i2) if IsPress(i2) then Pick() end end)
            b.Activated:Connect(Pick)
        end
        sug.Visible = true
    end)
    input.FocusLost:Connect(function()
        task.delay(0.3, function() if sug.Parent and not input:IsFocused() then sug.Visible = false end end)
    end)
end

P.Send = Chat.Send
function Chat:Send(text)
    local t = Trim(text or "")
    if t:sub(1, 6) == "[poll|" and not Private(self) then
        self:System("Polls only work in DMs and group chats.")
        return
    end
    if t:sub(1, 1) == "/" then
        if t:sub(1, 2) == "//" then return P.Send(self, t:sub(2)) end
        local name, args = t:match("^/(%w+)%s*(.-)%s*$")
        if name then
            name = name:lower()
            local cmd = Cmds[name]
            if not Private(self) then
                if cmd then
                    self:System("Slash commands only work in DMs and group chats. Open or start one to use /" .. name .. ".")
                    return
                end
            elseif cmd then
                if self.Blocked then return end
                local ok, err = pcall(cmd.run, self, args)
                if not ok then
                    warn("[Aether] /" .. name .. ": " .. tostring(err))
                    self:System("That command failed.")
                end
                return
            else
                self:System("Unknown command /" .. name .. ". Type /help for the list. (Start with // to send a literal slash.)")
                return
            end
        end
    end
    return P.Send(self, text)
end

-- ==================== 5) PRESENCE CARDS (on by default) ====================
local GameNames = {}
function Lib:GameName(place, cb)
    place = tonumber(place)
    if not place then Safe(cb, "Unknown game") return end
    local c = GameNames[place]
    if c then Safe(cb, c) return end
    task.spawn(function()
        local ok, r = pcall(function() return Market:GetProductInfo(place).Name end)
        local name = ok and tostring(r) or "a Roblox game"
        GameNames[place] = name
        Safe(cb, name)
    end)
end

local sizeCache, sizeWait, sizeQ, sizeBusy = {}, {}, {}, false
local function PumpSizes()
    if sizeBusy then return end
    sizeBusy = true
    task.spawn(function()
        while #sizeQ > 0 and not Lib.Unloaded do
            local it = table.remove(sizeQ, 1)
            local finished = false
            local function Done(info, why)
                if finished then return end
                finished = true
                sizeCache[it.job] = { t = os.clock(), info = info, why = why }
                local w = sizeWait[it.job]
                sizeWait[it.job] = nil
                for _, f in ipairs(w or {}) do Safe(f, info, why) end
            end
            Lib:CheckServer(it.place, it.job, Done)
            local t0 = os.clock()
            while not finished and os.clock() - t0 < 25 do task.wait(0.1) end
            Done(nil, "unreachable")
            task.wait(0.4)
        end
        sizeBusy = false
    end)
end

-- Lib:ServerSize(place, job, function(info, why) ... end)  info = { playing, max } or nil. Queued + cached for 45s.
function Lib:ServerSize(place, job, cb)
    local c = sizeCache[job]
    if c and os.clock() - c.t < 45 then Safe(cb, c.info, c.why) return end
    local w = sizeWait[job]
    if w then table.insert(w, cb) return end
    sizeWait[job] = { cb }
    sizeQ[#sizeQ + 1] = { place = place, job = job }
    PumpSizes()
end

function Chat:_PeerPresence()
    if not Lib:LoadExtras().presence then return nil end
    local ch = self.Channels[self.ChIndex]
    if not (ch and ch.kind == "dm" and ch.uid) then return nil end
    local id = tostring(ch.uid)
    local f = self.Friends.byId[id]
    local live
    for _, x in ipairs(self.Users or {}) do
        if tostring(x.uid) == id then live = x break end
    end
    if not (self.Friends.online[id] == true or live ~= nil) then return nil end
    local src = {}
    if f then for k, v in pairs(f) do src[k] = v end end
    if live then for k, v in pairs(live) do if v ~= nil then src[k] = v end end end
    local place, job = tonumber(src.place), src.job and tostring(src.job) or nil
    if not place or place == 0 or not job or job == "" then return nil end
    local priv = src.priv == true or src.priv == 1 or src.priv == "1"
    local same = job == game.JobId or Players:GetPlayerByUserId(tonumber(ch.uid) or 0) ~= nil
    return { uid = ch.uid, name = tostring(ch.name), place = place, job = job, priv = priv, same = same, friend = f }
end

function Chat:_InitPresence()
    if self._presBar then return end
    local parent = (self.PinBar and self.PinBar.Parent) or self.Frame
    local ph = H(46)
    self._presH = ph
    local bar = New("Frame", { Name = "Presence", Size = UDim2.new(1, -16, 0, ph), Position = UDim2.fromOffset(8, self.BaseTop - 4), BackgroundTransparency = 0,
        Visible = false, Theme = { BackgroundColor3 = "Field" }, Parent = parent })
    Corner(bar, 6) Stroke(bar, "Good", 1, 0.6)
    local stripe = New("Frame", { Size = UDim2.new(0, 3, 1, -14), Position = UDim2.fromOffset(6, 7), Theme = { BackgroundColor3 = "Good" }, Parent = bar })
    Corner(stripe, 2)
    New("TextLabel", { Text = "PLAYING", Font = Lib.FontBold, TextSize = 9, Size = UDim2.new(1, -96, 0, 11), Position = UDim2.fromOffset(16, 4), TextXAlignment = LEFT,
        Theme = { TextColor3 = "Good" }, Parent = bar })
    self._presGame = New("TextLabel", { Text = "", Font = Lib.FontBold, TextSize = 12, Size = UDim2.new(1, -96, 0, 15), Position = UDim2.fromOffset(16, 15), TextXAlignment = LEFT,
        TextTruncate = Enum.TextTruncate.AtEnd, Parent = bar })
    self._presSub = New("TextLabel", { Text = "", TextSize = 11, Size = UDim2.new(1, -96, 0, 13), Position = UDim2.fromOffset(16, 30), TextXAlignment = LEFT,
        TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = bar })
    local join = New("TextButton", { Text = "Join", TextSize = 12, Size = UDim2.fromOffset(60, H(26)), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
        BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(12, 16, 12), Theme = { BackgroundColor3 = "Good" }, Parent = bar })
    Corner(join, 5)
    self._presBar, self._presJoin = bar, join
    join.Activated:Connect(function()
        local p, pi = self._pres, self._pi or {}
        if not p then return end
        local function Go()
            if p.friend then self:JoinFriend(p.friend) else Lib:JoinServer(p.place, p.job, p.name) end
        end
        if pi.size and pi.size.max > 0 and pi.size.playing >= pi.size.max then
            Lib:Dialog({ Title = "Server is full", Text = p.name .. "'s server is at capacity right now. A spot may open up.",
                Buttons = { { Text = "Cancel" }, { Text = "Try anyway", Primary = true, Callback = Go } } })
        else
            Go()
        end
    end)
    self:_Relayout()
    task.spawn(function()
        while not Lib.Unloaded and bar.Parent do
            pcall(function() self:_UpdatePresence() end)
            task.wait(3)
        end
    end)
end

function Chat:_PaintPresence()
    local p, pi = self._pres, self._pi or {}
    if not (p and self._presBar) then return end
    self._presGame.Text = pi.game or "Loading..."
    local sub
    if p.same then
        sub = "In your server"
    elseif p.priv then
        sub = "Private server · ask them for an invite link"
    elseif pi.size then
        local full = pi.size.max > 0 and pi.size.playing >= pi.size.max
        sub = pi.size.playing .. "/" .. pi.size.max .. " players · Public server" .. (full and " · FULL" or "")
    else
        sub = "Public server"
    end
    self._presSub.Text = sub
    local canJoin = not p.same and not p.priv
    self._presJoin.Visible = canJoin
    local w = canJoin and -96 or -32
    self._presGame.Size = UDim2.new(1, w, 0, 15)
    self._presSub.Size = UDim2.new(1, w, 0, 13)
end

function Chat:_UpdatePresence(force)
    local bar = self._presBar
    if not bar then return end
    local p = self:_PeerPresence()
    local was = bar.Visible
    if not p then
        self._pres, self._presKey = nil, nil
        if was then bar.Visible = false self:_Relayout() end
        return
    end
    local key = p.uid .. ":" .. p.place .. ":" .. p.job .. ":" .. tostring(p.priv)
    local changed = force or key ~= self._presKey
    self._pres, self._presKey = p, key
    if changed then
        self._pi = {}
        Lib:GameName(p.place, function(n)
            if self._presKey == key and bar.Parent then
                self._pi.game = n
                self:_PaintPresence()
            end
        end)
    end
    if not p.priv and not p.same then
        Lib:ServerSize(p.place, p.job, function(info)
            if self._presKey == key and bar.Parent then
                self._pi.size = info
                self:_PaintPresence()
            end
        end)
    end
    self:_PaintPresence()
    if not was then
        bar.Visible = true
        self:_Relayout()
    end
end

-- the presence bar pushes pins + the message list down by its own height
P.Relayout = Chat._Relayout
function Chat:_Relayout()
    P.Relayout(self)
    local pb = self._presBar
    if not pb then return end
    local sOff = self.SearchOpen and 28 or 0
    pb.Position = UDim2.fromOffset(8, self.BaseTop - 4 + sOff)
    if not pb.Visible then return end
    local extra = (self._presH or H(46)) + 4
    local function Shift(f)
        local pos, sz = f.Position, f.Size
        f.Position = UDim2.new(pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset + extra)
        f.Size = UDim2.new(sz.X.Scale, sz.X.Offset, sz.Y.Scale, sz.Y.Offset - extra)
    end
    local pp = self.PinBar.Position
    self.PinBar.Position = UDim2.new(pp.X.Scale, pp.X.Offset, pp.Y.Scale, pp.Y.Offset + extra)
    Shift(self.List)
    Shift(self.NotifPanel)
    self.Top = self.Top + extra
    if self.NewBar then self.NewBar.Position = UDim2.new(0.5, 0, 0, self.Top + 4) end
end

P.SetChannel = Chat.SetChannel
function Chat:SetChannel(i)
    P.SetChannel(self, i)
    pcall(function() self:_UpdatePresence(true) end)
end

-- "PLAYING NOW" cards for online friends, under the channel list
P.RenderSidebar = Chat._RenderSidebar
function Chat:_RenderSidebar()
    P.RenderSidebar(self)
    local sb = self._sb
    if not (sb and sb.list.Parent and sb.card.Visible) then return end
    if not Lib:LoadExtras().presence then return end
    local ok, err = pcall(function()
        local friends = {}
        for _, u in ipairs(self.Friends.friends) do
            if self.Friends.online[tostring(u.uid)] then
                local place, job = tonumber(u.place), u.job and tostring(u.job)
                if place and place ~= 0 and job and job ~= "" then friends[#friends + 1] = u end
            end
        end
        if #friends == 0 then return end
        table.sort(friends, function(a, b) return tostring(a.display or a.name):lower() < tostring(b.display or b.name):lower() end)
        local L = sb.list
        local head = New("TextLabel", { Text = "PLAYING NOW", Font = Lib.FontBold, TextSize = 10, Size = UDim2.new(1, 0, 0, 18), LayoutOrder = 5000, TextXAlignment = LEFT,
            Theme = { TextColor3 = "Dim" }, Parent = L })
        Pad(head, 6, 0, 0, 0)
        for i = 1, math.min(#friends, 4) do
            local u = friends[i]
            local place, job = tonumber(u.place), tostring(u.job)
            local priv = u.priv == true or u.priv == 1 or u.priv == "1"
            local same = job == game.JobId
            local canJoin = not priv and not same
            local card = New("Frame", { Name = "PresenceCard", Size = UDim2.new(1, 0, 0, H(40)), LayoutOrder = 5000 + i, BackgroundTransparency = 0,
                Theme = { BackgroundColor3 = "Field" }, Parent = L })
            Corner(card, 5)
            New("TextLabel", { Text = tostring(u.display or u.name), Font = Lib.FontBold, TextSize = 11, Size = UDim2.new(1, canJoin and -58 or -14, 0, 14),
                Position = UDim2.fromOffset(8, 4), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Parent = card })
            local sub = New("TextLabel", { Text = "", TextSize = 10, Size = UDim2.new(1, canJoin and -58 or -14, 0, 13), Position = UDim2.fromOffset(8, 20),
                TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Dim" }, Parent = card })
            local gname, size
            local function Paint()
                if not sub.Parent then return end
                local t = gname or "..."
                if same then t = t .. " · your server"
                elseif priv then t = t .. " · private"
                elseif size then t = t .. " · " .. size.playing .. "/" .. size.max end
                sub.Text = t
            end
            Paint()
            Lib:GameName(place, function(n) gname = n Paint() end)
            if canJoin then
                Lib:ServerSize(place, job, function(info) size = info Paint() end)
                local jb = New("TextButton", { Text = "Join", TextSize = 11, Size = UDim2.fromOffset(44, H(22)), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0),
                    BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(12, 16, 12), Theme = { BackgroundColor3 = "Good" }, Parent = card })
                Corner(jb, 4)
                jb.Activated:Connect(function() self:JoinFriend(u) end)
            end
        end
    end)
    if not ok then warn("[Aether] presence cards: " .. tostring(err)) end
end

-- ==================== 6) hooks + settings ====================
P.CreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
    local chat = P.CreateChat(self, cfg)
    if chat and not chat._p55 then
        chat._p55 = true
        Lib:LoadExtras()
        local function Try(n, fn)
            local ok, e = pcall(fn)
            if not ok then warn("[Aether] " .. n .. ": " .. tostring(e)) end
        end
        Try("slash commands", function() chat:_InitSlash() end)
        Try("presence", function() chat:_InitPresence() end)
    end
    return chat
end

P.BuildSettingsTab = Lib.BuildSettingsTab
function Lib:BuildSettingsTab(window)
    local tab = P.BuildSettingsTab(self, window)
    if tab and not tab._p55 then
        tab._p55 = true
        pcall(function()
            local ex = Lib:LoadExtras()
            local sub = tab.Subs[1]
            local gb
            for _, g in ipairs(sub.Groupboxes) do if g.Name == "Chat" then gb = g end end
            gb = gb or sub:AddRightGroupbox("Chat", { Icon = "message-square", Collapsible = true })
            gb:AddToggle("PresenceCards", { Text = "Presence cards", Default = ex.presence, IgnoreConfig = true,
                Tooltip = "Shows what game a friend is in, the server size and a Join button (DM header + sidebar). Your own game is shared with \"Share my game in chat\".",
                Callback = function(v)
                    ex.presence = v and true or false
                    Lib:SaveExtras()
                    local c = Lib.ChatObj
                    if c then
                        pcall(function() c:_UpdatePresence(true) end)
                        c:_QueueSidebar()
                    end
                end })
        end)
    end
    return tab
end

end
-- ===================== end patch 5.6 =====================

-- ===================== Aether patch 5.7 =====================
do
local P = {}
Lib.Version = "5.7.0"
local LEFTA = Enum.HorizontalAlignment.Left

Lib.Skin = { MsgStyle = "Discord", Independent = true, UiBg = "", UiBgT = 0.5, ChatBg = "", ChatBgT = 0.5 }

-- ---------- saved skin ----------
do
        local loaded, tick = false, 0
        local function Path() return Lib.ConfigFolder .. "/skin.json" end
        function Lib:LoadSkin()
                if loaded then return self.Skin end
                loaded = true
                if FsOk() then
                        pcall(function()
                                local p = Path()
                                if not isfile(p) then return end
                                local d = HttpService:JSONDecode(readfile(p))
                                if type(d) ~= "table" then return end
                                local s = self.Skin
                                if d.msg == "Bubbles" or d.msg == "Discord" then s.MsgStyle = d.msg end
                                if type(d.ind) == "boolean" then s.Independent = d.ind end
                                if type(d.ui) == "string" then s.UiBg = d.ui:sub(1, 120) end
                                if type(d.chat) == "string" then s.ChatBg = d.chat:sub(1, 120) end
                                if tonumber(d.uit) then s.UiBgT = Clamp(tonumber(d.uit), 0.05, 1) end
                                if tonumber(d.cht) then s.ChatBgT = Clamp(tonumber(d.cht), 0.05, 1) end
                        end)
                end
                return self.Skin
        end
        function Lib:SaveSkin()
                if not FsOk() then return end
                tick = tick + 1
                local t = tick
                task.delay(0.6, function()
                        if t ~= tick then return end
                        pcall(function()
                                if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                                local s = Lib.Skin
                                writefile(Path(), HttpService:JSONEncode({ msg = s.MsgStyle, ind = s.Independent, ui = s.UiBg, chat = s.ChatBg, uit = s.UiBgT, cht = s.ChatBgT }))
                        end)
                end)
        end
end

local function IsFlat() return Lib.Skin.MsgStyle ~= "Bubbles" end

-- ---------- custom backgrounds ----------
local function BgAsset(s)
        s = Trim(s or "")
        if s == "" then return nil end
        local n = s:match("^(%d+)$") or s:match("rbxassetid://(%d+)") or s:match("[?&]id=(%d+)") or s:match("/(%d+)")
        if n then return "rbxassetid://" .. n end
        if s:find("^rbxasset") then return s end
        return nil
end

local function MakeBg(parent, radius)
        local img = New("ImageLabel", { Name = "CustomBG", Size = UDim2.fromScale(1, 1), ZIndex = 0, ScaleType = Enum.ScaleType.Crop, Visible = false, Parent = parent })
        Corner(img, radius)
        return img
end

function Lib:ApplyUiBg()
        local w = self.MainWindow
        if not (w and w.Main and w.Main.Parent) then return end
        local sk = self.Skin
        local a = BgAsset(sk.UiBg)
        if not (w._bg and w._bg.Parent) then w._bg = MakeBg(w.Main, w.Fullscreen and 0 or 8) end
        w._bg.Visible = a ~= nil
        if a then
                w._bg.Image = a
                w._bg.ImageTransparency = 1 - Clamp(sk.UiBgT, 0.05, 1)
        end
end

function Lib:ApplyChatBg()
        local c = self.ChatObj
        if not (c and c.Frame and c.Frame.Parent) then return end
        local sk = self.Skin
        local a = BgAsset(sk.ChatBg)
        if not (c._bg and c._bg.Parent) then c._bg = MakeBg(c.Frame, c.Full and 0 or 8) end
        c._bg.Visible = a ~= nil
        if a then
                c._bg.Image = a
                c._bg.ImageTransparency = 1 - Clamp(sk.ChatBgT, 0.05, 1)
        end
        c.List.BackgroundTransparency = a and 0.45 or 0
        if c._sb then c._sb.card.BackgroundTransparency = a and 0.45 or 0 end
end

function Lib:_BgGlass()
        if self.GlassT < 0.3 then
                local o = self.Options.WinOpacity
                if o then o:SetValue(40) else self:SetGlass(0.4) end
        end
end

P.Corners = Window._Corners
function Window:_Corners(r)
        P.Corners(self, r)
        local c = self._bg and self._bg:FindFirstChildOfClass("UICorner")
        if c then c.CornerRadius = UDim.new(0, r) end
end

P.ChatFs = Chat.SetFullscreen
function Chat:SetFullscreen(s)
        P.ChatFs(self, s)
        local c = self._bg and self._bg:FindFirstChildOfClass("UICorner")
        if c then c.CornerRadius = UDim.new(0, self.Full and 0 or 8) end
end

P.BuildBuiltins = Window.BuildBuiltins
function Window:BuildBuiltins()
        P.BuildBuiltins(self)
        Lib:LoadSkin()
        pcall(function() Lib:ApplyUiBg() end)
        pcall(function() Lib:ApplyChatBg() end)
end

-- ---------- panels stay open when the menu closes ----------
P.NewPanel = Lib._NewPanel
function Lib:_NewPanel(name, frame, startShown)
        local p = P.NewPanel(self, name, frame, startShown)
        function p:Refresh(instant)
                local win = Lib.MainWindow
                local hiddenByMin = self.Side and not self.Moved and win and win.Minimized
                local gate = Lib.Visible
                if name ~= "Window" and Lib.Skin.Independent then gate = true end
                local want = (gate and self.Enabled and not hiddenByMin) and true or false
                if want == self._shown then return end
                self._shown = want
                self._gen = self._gen + 1
                local gen, base, fr, scale = self._gen, Lib.Scale, self.Frame, self.Scale
                if instant then fr.Visible = want scale.Scale = base return end
                if want then
                        fr.Visible = true
                        scale.Scale = base * 0.96
                        Tween(scale, { Scale = base }, 0.2, Enum.EasingStyle.Quint)
                else
                        Tween(scale, { Scale = base * 0.97 }, 0.12)
                        task.delay(0.13, function() if self._gen == gen then fr.Visible = false scale.Scale = Lib.Scale end end)
                end
        end
        return p
end

-- ---------- mobile button hidden in fullscreen ----------
Lib:Connect(RunService.Heartbeat, function()
        local b = Lib.MobileButton
        if not b then return end
        local w, c = Lib.MainWindow, Lib.ChatObj
        local full = (w and w.Fullscreen) or (c and c.Full and c.PanelObj and c.PanelObj._shown)
        local want = not full
        if b.Visible ~= want then b.Visible = want end
end)

-- ---------- Discord-style messages ----------
local function EmojiOnly(t)
        t = Trim(t)
        if t == "" or #t > 96 then return false end
        local ok, n = pcall(function()
                local c = 0
                for _, cp in utf8.codes(t) do
                        if cp == 32 or cp == 0x200D or cp == 0xFE0F or cp == 0x20E3 then
                        elseif (cp >= 0x1F000 and cp <= 0x1FAFF) or (cp >= 0x2190 and cp <= 0x2BFF) or cp == 0x203C or cp == 0x2049 then c = c + 1
                        else return -1 end
                end
                return c
        end)
        return ok and n >= 1 and n <= 12
end

function Chat:_FlatFix(item)
        if not (item and item.Parent) then return end
        local meta = self.Meta[item]
        if not (meta and meta.flat) then return end
        local col = item:FindFirstChild("Col")
        if not col then return end
        col.Size = UDim2.new(1, -36, 0, 0)
        local bubble = col:FindFirstChild("Bubble")
        if bubble then bubble.Size = UDim2.new(1, 0, 0, 0) end
end

function Chat:_FlatStyle(item, msg)
        local meta = self.Meta[item]
        if not meta or meta.flat then return end
        meta.flat = true
        local lay = item:FindFirstChildOfClass("UIListLayout")
        if lay then lay.HorizontalAlignment = LEFTA end
        local av = item:FindFirstChild("Avatar")
        if av then av.LayoutOrder = 1 end
        local col = item:FindFirstChild("Col")
        if not col then return end
        local cl = col:FindFirstChildOfClass("UIListLayout")
        if cl then cl.HorizontalAlignment = LEFTA end
        local reacts = col:FindFirstChild("Reacts")
        local rl = reacts and reacts:FindFirstChildOfClass("UIListLayout")
        if rl then rl.HorizontalAlignment = LEFTA end
        local head = col:FindFirstChildOfClass("TextLabel")
        if head then
                head.TextXAlignment = LEFT
                local mine = tostring(msg.uid) == tostring(LocalPlayer.UserId)
                local t = head.Text
                if mine and not t:find("<b>", 1, true) and not t:find("face=", 1, true) then
                        local nm = tostring((msg.display ~= nil and msg.display ~= "") and msg.display or msg.name or "Unknown")
                        local tm = ""
                        if type(msg.ts) == "number" then pcall(function() tm = os.date("%H:%M", math.floor(msg.ts / 1000)) end) end
                        head.Text = "<b><font color='#" .. Hex("Text") .. "'>" .. RichEsc(nm) .. "</font></b> <font color='#" .. Hex("Dim") .. "'>" .. tm .. "</font>"
                end
        end
        local bubble = col:FindFirstChild("Bubble")
        if bubble then
                local pad = bubble:FindFirstChildOfClass("UIPadding")
                if pad then
                        pad.PaddingLeft, pad.PaddingRight = UDim.new(0, 4), UDim.new(0, 4)
                        pad.PaddingTop, pad.PaddingBottom = UDim.new(0, 2), UDim.new(0, 2)
                end
                if (bubble:GetAttribute("rest") or 0) == 0 then
                        -- invisible until hovered (a gradient so the library's own hover tween can't undo it)
                        local g = Instance.new("UIGradient")
                        g.Transparency = NumberSequence.new(1)
                        g.Parent = bubble
                        local st = bubble:FindFirstChildOfClass("UIStroke")
                        if st then st:Destroy() end
                        item.MouseEnter:Connect(function() g.Transparency = NumberSequence.new(0.82) end)
                        item.MouseLeave:Connect(function() g.Transparency = NumberSequence.new(1) end)
                end
        end
        self:_FlatFix(item)
end

function Chat:_DayDivider(item, msg)
        if type(msg.ts) ~= "number" then return end
        local sec = math.floor(msg.ts / 1000)
        local day = os.date("%Y-%m-%d", sec)
        if self._day == day then return end
        self._day = day
        local label
        if day == os.date("%Y-%m-%d") then label = "Today"
        elseif day == os.date("%Y-%m-%d", os.time() - 86400) then label = "Yesterday"
        else label = os.date("%B %d, %Y", sec) end
        self.Counter = self.Counter + 1
        local div = New("Frame", { Name = "DayDivider", Size = UDim2.new(1, 0, 0, H(24)), BackgroundTransparency = 1, LayoutOrder = item.LayoutOrder, Parent = self.List })
        item.LayoutOrder = self.Counter
        New("Frame", { Size = UDim2.new(1, -8, 0, 1), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 4, 0.5, 0), BackgroundTransparency = 0.5,
                Theme = { BackgroundColor3 = "Stroke" }, Parent = div })
        local pill = New("TextLabel", { Text = label, Font = Lib.FontBold, TextSize = 10, AutomaticSize = X, Size = UDim2.fromOffset(0, 16), AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0, Theme = { TextColor3 = "SubText", BackgroundColor3 = "Surface" }, Parent = div })
        Corner(pill, 8) Pad(pill, 8, 0, 8, 0)
        table.insert(self.Items, #self.Items, div)
end

for _, nm in ipairs({ "_RefitBubble", "_StyleHead", "_RenderReactions", "_ClampItem", "_WidenItem" }) do
        local orig = Chat[nm]
        if orig then
                Chat[nm] = function(self, item, ...)
                        local r = orig(self, item, ...)
                        pcall(self._FlatFix, self, item)
                        return r
                end
        end
end

P.PlaceRead = Chat._PlaceRead
function Chat:_PlaceRead()
        P.PlaceRead(self)
        if self._seenLbl and IsFlat() then self._seenLbl.TextXAlignment = LEFT end
end

P.ClearAll = Chat._ClearAll
function Chat:_ClearAll()
        self._day = nil
        return P.ClearAll(self)
end

P.AddMessage = Chat.AddMessage
function Chat:AddMessage(msg)
        local last = self.Items[#self.Items]
        local res = P.AddMessage(self, msg)
        local item = self.Items[#self.Items]
        local meta = item and item ~= last and self.Meta[item]
        if meta and meta.msg == msg and IsFlat() then
                local ok, err = pcall(function()
                        self:_FlatStyle(item, msg)
                        self:_DayDivider(item, msg)
                        if not meta.isCard and not meta.txt:find("```", 1, true) and EmojiOnly(meta.txt) then meta.body.TextSize = 30 end
                end)
                if not ok then warn("[Aether] discord style: " .. tostring(err)) end
        end
        return res
end

-- Up in an empty box edits your last message, Esc cancels a reply
function Chat:_InitDiscordKeys()
        local input = self.Input
        Lib:Connect(UIS.InputBegan, function(i)
                if not input:IsFocused() then return end
                if i.KeyCode == Enum.KeyCode.Up and input.Text == "" then
                        for k = #self.Items, 1, -1 do
                                local m = self.Meta[self.Items[k]]
                                if m and m.msg and m.msg.id and not m.isCard and tostring(m.msg.uid) == tostring(LocalPlayer.UserId) then
                                        self:EditMessage(m.msg)
                                        return
                                end
                        end
                elseif i.KeyCode == Enum.KeyCode.Escape and self.ReplyTo then
                        self:SetReply(nil)
                end
        end)
end

P.CreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
        local chat = P.CreateChat(self, cfg)
        if chat and not chat._p57 then
                chat._p57 = true
                Lib:LoadSkin()
                pcall(function() chat:_InitDiscordKeys() end)
                pcall(function() Lib:ApplyChatBg() end)
        end
        return chat
end

-- ---------- settings ----------
P.BuildSettingsTab = Lib.BuildSettingsTab
function Lib:BuildSettingsTab(window)
        local tab = P.BuildSettingsTab(self, window)
        if tab and not tab._p57 then
                tab._p57 = true
                pcall(function()
                        local sk = Lib:LoadSkin()
                        local sub = tab.Subs[1]
                        local function Box(name, side, icon)
                                for _, g in ipairs(sub.Groupboxes) do if g.Name == name then return g end end
                                return sub:AddGroupbox(name, side, { Icon = icon, Collapsible = true })
                        end
                        local function BgControls(gb, key, tkey, title, id, apply, glass)
                                gb:AddInput("__" .. id .. "BgId", { Text = title .. " background (asset id)", Placeholder = "123456789 or rbxassetid://123456789",
                                        Default = sk[key], IgnoreConfig = true, MaxLength = 120 })
                                gb:AddSlider("__" .. id .. "BgT", { Text = title .. " background visibility", Min = 5, Max = 100, Default = math.floor(sk[tkey] * 100 + 0.5),
                                        Suffix = "%", IgnoreConfig = true, Callback = function(v) sk[tkey] = v / 100 Lib:SaveSkin() apply() end })
                                gb:AddButtonRow({
                                        { Text = "Apply", Func = function()
                                                local raw = Trim(Lib.Options["__" .. id .. "BgId"].Value or "")
                                                if not BgAsset(raw) then
                                                        Lib:Notify({ Title = "Background", Text = "That doesn't look like an asset id.", Type = "error" })
                                                        return
                                                end
                                                sk[key] = raw
                                                Lib:SaveSkin()
                                                apply()
                                                if glass then Lib:_BgGlass() end
                                                Lib:Notify({ Title = "Background", Text = title .. " background applied.", Type = "success", Duration = 2.5 })
                                        end },
                                        { Text = "Default", Func = function()
                                                sk[key] = ""
                                                Lib:SaveSkin()
                                                apply()
                                                Lib.Options["__" .. id .. "BgId"]:SetValue("", true)
                                                Lib:Notify({ Title = "Background", Text = title .. " background reset to default.", Type = "success", Duration = 2.5 })
                                        end },
                                })
                        end
                        local bg = Box("Backgrounds", "Left", "image")
                        bg:AddLabel("Use an Image asset id. The menu's UI transparency is raised to 40% on Apply so the image can show.")
                        BgControls(bg, "UiBg", "UiBgT", "Menu", "Ui", function() Lib:ApplyUiBg() end, true)

                        local cg = Box("Chat", "Right", "message-square")
                        cg:AddDropdown("ChatMsgStyle", { Text = "Message style", Values = { "Discord", "Bubbles" }, Default = sk.MsgStyle, IgnoreConfig = true,
                                Callback = function(v)
                                        sk.MsgStyle = v == "Bubbles" and "Bubbles" or "Discord"
                                        Lib:SaveSkin()
                                        local c = Lib.ChatObj
                                        if c then c:_ReloadMessages() end
                                end })
                        cg:AddToggle("ChatIndependent", { Text = "Keep chat & ESP open when menu closes", Default = sk.Independent, IgnoreConfig = true,
                                Callback = function(v)
                                        sk.Independent = v and true or false
                                        Lib:SaveSkin()
                                        Lib:SetVisible(Lib.Visible)
                                end })
                        BgControls(cg, "ChatBg", "ChatBgT", "Chat", "Chat", function() Lib:ApplyChatBg() end, false)
                end)
        end
        return tab
end

end
-- ===================== end patch 5.7 =====================

-- ===================== Aether patch 5.8 =====================
do
local P = {}
Lib.Version = "5.8.0"

-- ---------- 1) code block at the start of a message ----------
P.RenderSegments = Chat._RenderSegments
function Chat:_RenderSegments(item, meta)
        P.RenderSegments(self, item, meta)
        if meta.isCard then return end
        local ok, err = pcall(function()
                local txt = tostring(meta.txt or "")
                local a, b = txt:find("^%s*```")
                if not a then return end
                local c = txt:find("```", b + 1, true)
                if not c then return end
                local col = item:FindFirstChild("Col")
                local bubble = col and col:FindFirstChild("Bubble")
                if not bubble then return end
                local body = txt:sub(b + 1, c - 1)
                local lang, code = body:match("^([%w_%+%-%.#]*)\n(.*)$")
                if not lang then lang, code = "", body end
                code = code:gsub("^\n+", ""):gsub("[\n%s]+$", "")
                if code == "" then return end
                meta.extras = meta.extras or {}
                -- order 10 = before every later segment (those start at 11)
                table.insert(meta.extras, self:_CodeBlock(bubble, { lang = lang, s = code }, 10))
                self:_WidenItem(item)
        end)
        if not ok then warn("[Aether] leading code block: " .. tostring(err)) end
end

-- ---------- 2) watermark hidden in the main UI's fullscreen ----------
Lib:Connect(RunService.Heartbeat, function()
        local w = Lib.MainWindow
        local fs = w and w.Fullscreen
        local wm = Lib.Watermark
        if wm and wm.Frame and wm.Frame.Parent then
                local want = (wm.Enabled ~= false) and not fs
                if wm.Frame.Visible ~= want then wm.Frame.Visible = want end
        end
end)

end
-- ===================== end patch 5.8 =====================

-- ===================== Aether patch 5.9 =====================
-- Paste this block right above the final `return Lib` (after patch 5.8).
--
--  1) Groups without a custom icon now show a small collage of their members' avatars
--     (header bar, channel sidebar and the chevron menu) instead of the "«" glyph.
--  2) The keybind list is force-hidden while the main UI is fullscreen (and while chat is fullscreen),
--     enforced after every other script has touched it, so it can no longer flicker through.
do
local P = {}
Lib.Version = "5.9.0"

-- ---------- member ids of a group (numbers or {uid=...} tables), you last ----------
local function MemberIds(ch)
    local out, seen = {}, {}
    local me = LocalPlayer.UserId
    for _, m in ipairs((ch and ch.members) or {}) do
        local id = tonumber(type(m) == "table" and (m.uid or m.id) or m)
        if id and not seen[id] then
            seen[id] = true
            out[#out + 1] = id
        end
    end
    table.sort(out, function(a, b)
        if (a == me) ~= (b == me) then return b == me end
        return a < b
    end)
    return out
end

-- tile layouts on a 20x20 canvas: { x, y, size }
local Layout = {
    [1] = { { 0, 0, 20 } },
    [2] = { { 0, 0, 13 }, { 7, 7, 13 } },
    [3] = { { 0, 0, 11 }, { 9, 0, 11 }, { 4.5, 9, 11 } },
    [4] = { { 0, 0, 11 }, { 9, 0, 11 }, { 0, 9, 11 }, { 9, 9, 11 } },
}

-- builds a round-avatar cluster of up to 4 members inside `parent`
function Chat:_Collage(parent, ids, px, z)
    local n = math.min(#ids, 4)
    local f = New("Frame", { Name = "Collage", Size = UDim2.fromOffset(px, px), BackgroundTransparency = 1, ZIndex = z, Parent = parent })
    if n == 0 then return f end
    local k = px / 20
    for i = 1, n do
        local t = Layout[n][i]
        local s = t[3] * k
        local img = New("ImageLabel", { Size = UDim2.fromOffset(s, s), Position = UDim2.fromOffset(t[1] * k, t[2] * k), BackgroundTransparency = 0,
            ScaleType = Enum.ScaleType.Crop, ZIndex = z + i, Theme = { BackgroundColor3 = "Field" }, Parent = f })
        Corner(img, s / 2)
        Stroke(img, "Surface", 1, 0)
        GetAvatar(ids[i], function(u) if img.Parent then img.Image = u end end)
    end
    return f
end

local function Key(ids)
    local t = {}
    for i = 1, math.min(#ids, 4) do t[i] = ids[i] end
    return table.concat(t, ",")
end

-- ---------- header bar ----------
function Chat:_GroupHeader()
    local btn, label = self.ChBtn, self.ChLabel
    if not (btn and label and btn.Parent) then return end
    local ch = self.Channels[self.ChIndex]
    local ids
    if ch and ch.kind == "grp" and not Lib:LoadGroupIcons()[tostring(ch.gid)] then
        ids = MemberIds(ch)
        if #ids == 0 then ids = nil end
    end
    if not ids then
        if self._gcol then pcall(function() self._gcol:Destroy() end) end
        self._gcol, self._gcKey = nil, nil
        return
    end
    local key = ch.room .. ":" .. Key(ids)
    if self._gcKey ~= key or not (self._gcol and self._gcol.Parent) then
        if self._gcol then pcall(function() self._gcol:Destroy() end) end
        local col = self:_Collage(btn, ids, 22, 3)
        col.AnchorPoint, col.Position = Vector2.new(0, 0.5), UDim2.new(0, 7, 0.5, 0)
        self._gcol, self._gcKey = col, key
    end
    -- drop the « ... » marks, the collage takes their place
    label.Text = (label.Text:gsub("^<font color='#%x+'><b>«</b></font> ", ""))
    label.Text = (label.Text:gsub("»", "", 1))
    label.Position = UDim2.fromOffset(36, 0)
    label.Size = UDim2.new(1, -(56 + 26), 1, 0)
end

P.RefreshChannel = Chat._RefreshChannel
function Chat:_RefreshChannel()
    P.RefreshChannel(self)
    pcall(function() self:_GroupHeader() end)
end

-- ---------- channel sidebar ----------
P.RenderSidebar = Chat._RenderSidebar
function Chat:_RenderSidebar()
    P.RenderSidebar(self)
    local sb = self._sb
    if not (sb and sb.list.Parent and sb.card.Visible) then return end
    local ok, err = pcall(function()
        local I = Lib:LoadGroupIcons()
        local used = {}
        for _, row in ipairs(sb.list:GetChildren()) do
            if row.Name == "Ch" and row:IsA("TextButton") then
                local mark, nameLbl
                for _, c in ipairs(row:GetChildren()) do
                    if c:IsA("TextLabel") then
                        if c.Text == "«" then mark = c
                        elseif c.Position.X.Offset == 22 and c.Position.Y.Offset == 0 then nameLbl = c end
                    end
                end
                if mark and nameLbl then
                    local ch
                    for _, c2 in ipairs(self.Channels) do
                        if c2.kind == "grp" and not used[c2] and tostring(c2.name) == nameLbl.Text then ch = c2 break end
                    end
                    if ch then
                        used[ch] = true
                        local ids = (not I[tostring(ch.gid)]) and MemberIds(ch) or nil
                        if ids and #ids > 0 then
                            local col = self:_Collage(row, ids, 20, 2)
                            col.AnchorPoint, col.Position = Vector2.new(0, 0.5), UDim2.new(0, 3, 0.5, 0)
                            mark.Text = ""
                            nameLbl.Position = UDim2.fromOffset(28, 0)
                            nameLbl.Size = UDim2.new(nameLbl.Size.X.Scale, nameLbl.Size.X.Offset - 6, nameLbl.Size.Y.Scale, nameLbl.Size.Y.Offset)
                        end
                    end
                end
            end
        end
    end)
    if not ok then warn("[Aether] group collage (sidebar): " .. tostring(err)) end
end

-- ---------- chevron menu header ----------
P.PopMenu = Chat._PopMenu
function Chat:_PopMenu(spec, anchor)
    local before = {}
    for _, c in ipairs(Lib.Overlay:GetChildren()) do before[c] = true end
    P.PopMenu(self, spec, anchor)
    if not (spec and spec.Group) then return end
    pcall(function()
        if Lib:LoadGroupIcons()[tostring(spec.Group.gid)] then return end
        local ids = MemberIds(spec.Group)
        if #ids == 0 then return end
        local menu
        for _, c in ipairs(Lib.Overlay:GetChildren()) do
            if not before[c] and c.Name == "ConvoMenu" then menu = c end
        end
        if not menu then return end
        local av
        for _, d in ipairs(menu:GetDescendants()) do
            if d:IsA("ImageLabel") and d.Size == UDim2.fromOffset(36, 36) then av = d break end
        end
        if not av then return end
        local g = av:FindFirstChildWhichIsA("TextLabel")
        if g then g.Text = "" end
        local col = self:_Collage(av, ids, 32, av.ZIndex + 1)
        col.Position = UDim2.fromOffset(2, 2)
    end)
end

-- ---------- keybind list: never visible while a fullscreen view is open ----------
local BIND = "AetherHideKeybinds"

local function FullscreenOpen()
    local w, c = Lib.MainWindow, Lib.ChatObj
    if w and w.Fullscreen then return true end
    if c and c.Full and c.PanelObj and c.PanelObj._shown then return true end
    return false
end

pcall(function() RunService:UnbindFromRenderStep(BIND) end)
RunService:BindToRenderStep(BIND, Enum.RenderPriority.Last.Value, function()
    if Lib.Unloaded then return end
    local kl = Lib.KeybindList
    local f = kl and kl.Frame
    if not (f and f.Parent) then return end
    -- also catch any other script flipping Visible back on, the moment it happens
    if not f:GetAttribute("p59") then
        f:SetAttribute("p59", true)
        Lib:Connect(f:GetPropertyChangedSignal("Visible"), function()
            if f.Visible and FullscreenOpen() then f.Visible = false end
        end)
    end
    if f.Visible and FullscreenOpen() then f.Visible = false end
end)

local prevUnload = Lib.OnUnload
Lib.OnUnload = function()
    pcall(function() RunService:UnbindFromRenderStep(BIND) end)
    if prevUnload then Safe(prevUnload) end
end

end
-- ===================== end patch 5.9 =====================

-- ===================== Aether patch 6.0: forward messages =====================
-- Paste this block right above the final `return Lib` (after patch 5.9).
--
--  Right-click (PC) or long-press (mobile) a message -> Forward. A Discord-style picker lets you tick up to 5 chats
--  (channels, DMs, group chats, friends, or anyone by username), add an optional message, and send.
--  Works for text and images. Uses only relay endpoints the script already calls, so the relay needs no changes.
do
local P = {}
Lib.Version = "6.0.0"
P.FWD = "↪ Forwarded from "
P.MAX = 5

-- ---------- forwarded text: first line "↪ Forwarded from Name · #channel", then the original text ----------
function P.Parse(txt)
    local line, rest = tostring(txt or ""):match("^↪ Forwarded from ([^\n]*)\n?(.*)$")
    if not line then return nil end
    local who, where = line:match("^(.-) · (.+)$")
    if not who then who, where = line, "" end
    return who, where, rest
end

-- one line, no control characters, at most n characters
function P.Clean(s, n)
    s = tostring(s or ""):gsub("%c", " ")
    s = Trim(s):gsub("%s+", " ")
    local len = utf8.len(s)
    if len and len > n then
        s = s:sub(1, utf8.offset(s, n + 1) - 1)
    elseif not len then
        s = s:sub(1, n)
    end
    return s
end

function P.Build(who, where, body, cap)
    local head = P.FWD .. P.Clean(who, 32) .. (where ~= "" and (" · " .. P.Clean(where, 32)) or "")
    body = tostring(body or "")
    local room = cap - #head - 1
    if #body > room then
        body = body:sub(1, math.max(room - 3, 0))
        while #body > 0 and not utf8.len(body) do body = body:sub(1, -2) end
        body = body .. "…"
        if select(2, body:gsub("```", "")) % 2 == 1 then body = body .. "\n```" end
    end
    return head .. "\n" .. body
end

function P.Author(msg)
    return tostring((msg.display ~= nil and msg.display ~= "") and msg.display or msg.name or "?")
end

-- polls, config cards and join cards are special messages, they can't be forwarded
function P.Can(msg)
    if type(msg) ~= "table" or not msg.id or msg.cfg ~= nil then return false end
    local t = tostring(msg.text or "")
    if t:match("^%s*%[poll|") or t:match("^%s*%[join|") then return false end
    return t ~= "" or type(msg.image) == "table"
end

function P.Label(t)
    if t.kind == "dm" then return "@" .. t.name end
    if t.kind == "grp" then return "«" .. t.name .. "»" end
    return "#" .. t.name
end

-- ---------- everywhere a message can be forwarded to ----------
function Chat:_FwdTargets()
    local out, seen = {}, {}
    local me = LocalPlayer.UserId
    local function Add(t)
        if t.room and not seen[t.room] then
            seen[t.room] = true
            out[#out + 1] = t
        end
    end
    for _, ch in ipairs(self.Channels) do
        if not ch.kind then
            Add({ room = ch.room, kind = "pub", name = tostring(ch.name or "Global"), sub = "Channel" })
        end
    end
    for _, ch in ipairs(self.Channels) do
        if ch.kind == "dm" and ch.uid then
            Add({ room = ch.room, kind = "dm", uid = tonumber(ch.uid), name = tostring(ch.name or ch.uid), sub = "Direct message" })
        end
    end
    for _, ch in ipairs(self.Channels) do
        if ch.kind == "grp" then
            local ids = {}
            for _, m in ipairs(ch.members or {}) do
                local id = tonumber(type(m) == "table" and (m.uid or m.id) or m)
                if id and id ~= me then ids[#ids + 1] = id end
            end
            local n = #(ch.members or {})
            Add({ room = ch.room, kind = "grp", name = tostring(ch.name or "Group"), ids = ids, ch = ch,
                sub = "Group chat" .. (n > 0 and (" · " .. n .. " members") or "") })
        end
    end
    -- friends you haven't opened a DM with yet
    for _, u in ipairs((self.Friends and self.Friends.friends) or {}) do
        local uid = tonumber(u.uid)
        local room = uid and uid ~= me and self:DMRoom(uid)
        if room then
            Add({ room = room, kind = "dm", uid = uid, new = true, user = u,
                name = tostring((u.display and u.display ~= "") and u.display or u.name or uid), sub = "Friend · @" .. tostring(u.name or uid) })
        end
    end
    return out
end

-- ---------- the picker ----------
function Chat:ForwardMessage(msg)
    if not P.Can(msg) then return end
    if self.Blocked then
        Lib:Notify({ Title = "Forward", Text = "You can't send messages right now.", Type = "warn" })
        return
    end
    local src = { room = self.Room, ch = self.Channels[self.ChIndex], msg = msg }
    local targets = self:_FwdTargets()
    local me = LocalPlayer.UserId
    local Z, W, HH = 98, 420, 560 -- below Lib:Prompt (100), so "someone else" can open on top
    local sel, count, rows, groups = {}, 0, {}, {}
    local sending = false

    local dim = New("TextButton", { Name = "ForwardDim", Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.45,
        BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = Z, Parent = Lib.Overlay })
    local card = Sink(New("Frame", { Name = "ForwardCard", Size = UDim2.fromOffset(W, HH), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), ZIndex = Z + 1, Theme = { BackgroundColor3 = "Bg" }, Parent = dim }))
    Corner(card, 10) Stroke(card)
    local vp = Lib.Overlay.AbsoluteSize
    New("UIScale", { Scale = (vp.X > 0 and vp.Y > 0) and math.min(1, vp.X / (W + 20), vp.Y / (HH + 20)) or 1, Parent = card })
    local function Close() if dim.Parent then dim:Destroy() end end
    dim.Activated:Connect(Close)

    -- header
    New("TextLabel", { Text = "Forward To", Font = Lib.FontBold, TextSize = 20, Size = UDim2.new(1, -70, 0, 26), Position = UDim2.fromOffset(20, 14),
        TextXAlignment = LEFT, ZIndex = Z + 2, Parent = card })
    New("TextLabel", { Text = "Select where you want to share this message.", TextSize = 12, Size = UDim2.new(1, -40, 0, 16), Position = UDim2.fromOffset(20, 42),
        TextXAlignment = LEFT, ZIndex = Z + 2, Theme = { TextColor3 = "Dim" }, Parent = card })
    local x = New("TextButton", { Text = "×", TextSize = 24, Size = UDim2.fromOffset(32, 32), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 10),
        ZIndex = Z + 2, Theme = { TextColor3 = "Dim" }, Parent = card })
    x.Activated:Connect(Close)

    -- search
    local sf = New("Frame", { Size = UDim2.new(1, -40, 0, 36), Position = UDim2.fromOffset(20, 68), BackgroundTransparency = 0, ZIndex = Z + 2,
        Theme = { BackgroundColor3 = "Field" }, Parent = card })
    Corner(sf, 8) Stroke(sf, "Accent", 1.5, 0.15)
    Lib.Icon("search", 16, "Dim", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0), ZIndex = Z + 3, Parent = sf }, "?")
    local sbox = New("TextBox", { Text = "", PlaceholderText = "Search", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 14, Size = UDim2.new(1, -44, 1, 0),
        Position = UDim2.fromOffset(36, 0), TextXAlignment = LEFT, ZIndex = Z + 3, Parent = sf })

    -- list
    local list = New("ScrollingFrame", { Size = UDim2.new(1, -16, 0, HH - 116 - 132), Position = UDim2.fromOffset(8, 116), AutomaticCanvasSize = Y,
        ScrollBarThickness = 3, ZIndex = Z + 2, Parent = card })
    List(list, 2) Pad(list, 4, 0, 4, 0)
    local empty = New("TextLabel", { Text = "No chats match your search.", TextSize = 12, Size = UDim2.new(1, 0, 0, 40), LayoutOrder = 99999, Visible = false,
        ZIndex = Z + 3, Theme = { TextColor3 = "Dim" }, Parent = list })

    -- footer: what you're forwarding, an optional message, Send
    New("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromOffset(0, HH - 124), BackgroundTransparency = 0.5, ZIndex = Z + 2,
        Theme = { BackgroundColor3 = "Stroke" }, Parent = card })
    local pv = New("Frame", { Size = UDim2.new(1, -40, 0, 40), Position = UDim2.fromOffset(20, HH - 114), BackgroundTransparency = 1, ZIndex = Z + 2, Parent = card })
    Corner(New("Frame", { Size = UDim2.new(0, 3, 1, 0), BackgroundTransparency = 0, ZIndex = Z + 3, Theme = { BackgroundColor3 = "Stroke" }, Parent = pv }), 2)
    local who, _, rest = P.Parse(msg.text)
    local snip = P.Clean(who and rest or msg.text, 160)
    if type(msg.image) == "table" then snip = (snip ~= "" and (snip .. " ") or "") .. "[image]" end
    New("TextLabel", { RichText = true, Text = "<b>" .. RichEsc(P.Clean(who or P.Author(msg), 32)) .. "</b>  " .. RichEsc(snip), TextSize = 12,
        Size = UDim2.new(1, -14, 1, 0), Position = UDim2.fromOffset(12, 0), TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = Z + 3, Theme = { TextColor3 = "SubText" }, Parent = pv })

    local inF = New("Frame", { Size = UDim2.new(1, -40 - 96, 0, 40), Position = UDim2.fromOffset(20, HH - 64), BackgroundTransparency = 0, ZIndex = Z + 2,
        Theme = { BackgroundColor3 = "Field" }, Parent = card })
    Corner(inF, 8)
    local cbox = New("TextBox", { Text = "", PlaceholderText = "Add an optional message...", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 13,
        Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(10, 0), TextXAlignment = LEFT, ZIndex = Z + 3, Parent = inF })
    local sendBtn = New("TextButton", { Text = "Send", Font = Lib.FontBold, TextSize = 14, Size = UDim2.fromOffset(84, 40), AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -20, 0, HH - 64), BackgroundTransparency = 0.6, ZIndex = Z + 2,
        Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = card })
    Corner(sendBtn, 8)

    -- behaviour
    local function Refresh()
        sendBtn.Text = count > 0 and ("Send (" .. count .. ")") or "Send"
        sendBtn.BackgroundTransparency = count > 0 and 0 or 0.6
    end

    local function SetSel(rec, on)
        local room = rec.t.room
        if on then
            if sel[room] then return end
            if count >= P.MAX then
                Lib:Notify({ Title = "Forward", Text = "You can forward to up to " .. P.MAX .. " chats at once.", Type = "warn", Duration = 2.5 })
                return
            end
            sel[room] = rec
            count = count + 1
        else
            if not sel[room] then return end
            sel[room] = nil
            count = count - 1
        end
        rec.fill.Visible = on
        rec.row.BackgroundTransparency = on and 0.7 or 1
        Refresh()
    end

    local GROUPS = { pub = { 1, "CHANNELS" }, dm = { 2, "DIRECT MESSAGES" }, grp = { 3, "GROUP CHATS" }, friend = { 4, "FRIENDS" } }
    local function Group(kind)
        local g = groups[kind]
        if g then return g end
        local def = GROUPS[kind]
        g = { order = def[1] * 10000, n = 0, rows = {} }
        g.head = New("TextLabel", { Text = def[2], Font = Lib.FontBold, TextSize = 10, Size = UDim2.new(1, 0, 0, 24), LayoutOrder = g.order,
            TextXAlignment = LEFT, ZIndex = Z + 3, Theme = { TextColor3 = "Dim" }, Parent = list })
        Pad(g.head, 8, 8, 0, 0)
        groups[kind] = g
        return g
    end

    local function BaseRow(order, name, sub)
        local row = New("TextButton", { Name = "Row", Text = "", Size = UDim2.new(1, 0, 0, 50), LayoutOrder = order, BackgroundTransparency = 1, ZIndex = Z + 3,
            Theme = { BackgroundColor3 = "FieldHover" }, Parent = list })
        Corner(row, 8)
        local av = New("Frame", { Size = UDim2.fromOffset(36, 36), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0), BackgroundTransparency = 0,
            ZIndex = Z + 4, Theme = { BackgroundColor3 = "Field" }, Parent = row })
        Corner(av, 18)
        New("TextLabel", { Text = name, Font = Lib.FontBold, TextSize = 14, Size = UDim2.new(1, -110, 0, 18), Position = UDim2.fromOffset(56, sub and 8 or 16),
            TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = Z + 4, Parent = row })
        if sub then
            New("TextLabel", { Text = sub, TextSize = 11, Size = UDim2.new(1, -110, 0, 14), Position = UDim2.fromOffset(56, 27), TextXAlignment = LEFT,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = Z + 4, Theme = { TextColor3 = "Dim" }, Parent = row })
        end
        return row, av
    end

    local function AddRow(t)
        local g = Group((t.kind == "dm" and t.new) and "friend" or t.kind)
        g.n = g.n + 1
        local row, av = BaseRow(g.order + g.n, t.name, t.sub)
        if t.kind == "dm" then
            local img = New("ImageLabel", { Size = UDim2.fromScale(1, 1), ZIndex = Z + 5, Parent = av })
            Corner(img, 18)
            GetAvatar(t.uid, function(u) if img.Parent then img.Image = u end end)
        elseif t.kind == "grp" then
            local glyph = New("TextLabel", { Text = "«", Font = Lib.FontBold, TextSize = 18, Size = UDim2.fromScale(1, 1), ZIndex = Z + 5, Parent = av })
            pcall(function()
                local entry = Lib:LoadGroupIcons()[tostring(t.ch.gid)]
                if entry then
                    local img = New("ImageLabel", { Size = UDim2.fromScale(1, 1), ZIndex = Z + 5, Parent = av })
                    Corner(img, 18)
                    self:_IconAsset(entry, t.room, function(asset) if img.Parent then img.Image = asset glyph.Text = "" end end)
                elseif #t.ids > 0 then
                    av.BackgroundTransparency = 1
                    glyph.Text = ""
                    self:_Collage(av, t.ids, 36, Z + 5)
                end
            end)
        else
            New("TextLabel", { Text = "#", Font = Lib.FontBold, TextSize = 20, Size = UDim2.fromScale(1, 1), ZIndex = Z + 5, Theme = { TextColor3 = "SubText" }, Parent = av })
        end
        local box = New("Frame", { Size = UDim2.fromOffset(22, 22), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), BackgroundTransparency = 0,
            ZIndex = Z + 4, Theme = { BackgroundColor3 = "Field" }, Parent = row })
        Corner(box, 5) Stroke(box, "Stroke", 1.5, 0.1)
        local fill = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0, Visible = false, ZIndex = Z + 5, Theme = { BackgroundColor3 = "Accent" }, Parent = box })
        Corner(fill, 5)
        Lib.Icon("check", 14, "OnAccent", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = Z + 6, Parent = fill }, "✓")
        local rec = { row = row, t = t, fill = fill, hay = (t.name .. " " .. t.sub):lower() }
        rows[#rows + 1] = rec
        g.rows[#g.rows + 1] = rec
        row.MouseEnter:Connect(function() if not sel[t.room] then Tween(row, { BackgroundTransparency = 0.55 }, 0.06) end end)
        row.MouseLeave:Connect(function() if not sel[t.room] then Tween(row, { BackgroundTransparency = 1 }, 0.08) end end)
        row.Activated:Connect(function() SetSel(rec, not sel[t.room]) end)
        return rec
    end

    local other = BaseRow(90000, "Message someone else...", nil)
    do
        local av = other:FindFirstChildWhichIsA("Frame")
        if av then New("TextLabel", { Text = "+", Font = Lib.FontBold, TextSize = 22, Size = UDim2.fromScale(1, 1), ZIndex = Z + 5, Theme = { TextColor3 = "SubText" }, Parent = av }) end
    end

    local function Filter()
        local q = Trim(sbox.Text):lower()
        local shown = 0
        for _, g in pairs(groups) do
            local any = false
            for _, r in ipairs(g.rows) do
                local show = q == "" or r.hay:find(q, 1, true) ~= nil
                r.row.Visible = show
                if show then any = true shown = shown + 1 end
            end
            g.head.Visible = any
        end
        other.Visible = q == ""
        empty.Visible = q ~= "" and shown == 0
    end
    sbox:GetPropertyChangedSignal("Text"):Connect(Filter)

    other.Activated:Connect(function()
        Lib:Prompt({ Title = "Forward to someone", Text = "Roblox username or user ID. They don't have to be online.", Placeholder = "@username", Confirm = "Add" }, function(text)
            if not dim.Parent then return end
            self:ResolveUser(text, function(u)
                if not dim.Parent then return end
                if not u then Lib:Notify({ Title = "Forward", Text = "Couldn't find that Roblox user.", Type = "error" }) return end
                if tonumber(u.uid) == me then Lib:Notify({ Title = "Forward", Text = "That's you.", Type = "warn" }) return end
                local room = self:DMRoom(u.uid)
                local have
                for _, r in ipairs(rows) do if r.t.room == room then have = r break end end
                if not have then
                    have = AddRow({ room = room, kind = "dm", uid = tonumber(u.uid), user = u, new = self:_RoomIndex(room) == nil,
                        name = tostring((u.display and u.display ~= "") and u.display or u.name), sub = "@" .. tostring(u.name) })
                end
                if sbox.Text ~= "" then sbox.Text = "" end
                Filter()
                SetSel(have, true)
            end)
        end)
    end)

    local function DoSend()
        if sending or count == 0 then return end
        sending = true
        local chosen = {}
        for _, r in ipairs(rows) do if sel[r.t.room] then chosen[#chosen + 1] = r.t end end
        local comment = Trim(cbox.Text)
        Close()
        self:_ForwardRun(src, chosen, comment)
    end
    sendBtn.Activated:Connect(DoSend)
    cbox.FocusLost:Connect(function(enter) if enter then DoSend() end end)

    for _, t in ipairs(targets) do AddRow(t) end
    Refresh()
    Filter()
    if not Lib.Touch then task.defer(function() if sbox.Parent then sbox:CaptureFocus() end end) end
end

-- ---------- sending ----------
function P.SendTo(self, t, text, data, comment)
    local room = t.room
    if t.new and not self:_RoomIndex(room) then
        self:AddDM(t.uid, t.user and t.user.name or t.name, t.name)
        local q = { after = -1, peer = t.uid }
        if t.user and t.user.name then q.peer_name = tostring(t.user.name) end
        if t.name and t.name ~= "" then q.peer_display = tostring(t.name) end
        self:_Do("/poll", q, nil, nil, room)
    end
    local imageId
    if data then
        local d = Decode(self:_Do("/upload", nil, "POST", HttpService:JSONEncode({ data = data }), room))
        if not (d and d.ok and d.id) then return false, (d and d.error) or "Upload failed." end
        imageId = d.id
    end
    local r = Decode(self:_Do("/send", nil, "POST", HttpService:JSONEncode({ text = text, image = imageId }), room))
    if not (r and r.ok) then return false, (r and r.error) or "Couldn't send." end
    if comment ~= "" then
        task.wait(0.85) -- the relay rejects two messages from you in the same chat less than ~0.7 s apart
        self:_Do("/send", nil, "POST", HttpService:JSONEncode({ text = comment }), room)
    end
    return true
end

function Chat:_ForwardRun(src, chosen, comment)
    local msg = src.msg
    local who, where, body = P.Parse(msg.text)
    if not who then
        -- the source channel is only named for public channels, never for DMs or group chats
        who = P.Author(msg)
        where = (src.ch and not src.ch.kind) and ("#" .. tostring(src.ch.name or "")) or ""
        body = tostring(msg.text or "")
    end
    local cap = math.max(tonumber(self.Config.MaxLength) or 200, 200)
    local text = P.Build(who, where, body, cap)
    comment = comment:sub(1, cap)
    local img = type(msg.image) == "table" and msg.image or nil
    Lib:Notify({ Title = "Forward", Text = "Forwarding to " .. #chosen .. (#chosen == 1 and " chat..." or " chats..."), Type = "info", Duration = 2 })
    task.spawn(function()
        local data
        if img then
            local d = Decode(self:_Do("/img", { id = img.id }, nil, nil, src.room))
            data = d and d.ok and d.data or nil
            if not data then
                Lib:Notify({ Title = "Forward", Text = (d and d.error) or "Couldn't read that image. It may have expired.", Type = "error" })
                return
            end
        end
        local good, bad, firstErr = {}, {}, nil
        for i, t in ipairs(chosen) do
            local ok, err = P.SendTo(self, t, text, data, comment)
            if ok then
                good[#good + 1] = P.Label(t)
                if t.room == self.Room then
                    self.Stick = true
                    self:_PollOnce()
                end
            else
                bad[#bad + 1] = P.Label(t)
                firstErr = firstErr or err
            end
            if i < #chosen then task.wait(0.8) end
        end
        self.LastSend = os.clock()
        if #good > 0 then
            Lib:Notify({ Title = "Forwarded", Text = "Sent to " .. table.concat(good, ", ") .. ".", Type = "success", Duration = 3 })
        end
        if #bad > 0 then
            Lib:Notify({ Title = "Forward", Text = "Couldn't send to " .. table.concat(bad, ", ") .. ": " .. tostring(firstErr), Type = "error", Duration = 5 })
        end
    end)
end

-- ---------- "↪ Forwarded from ..." label above the forwarded text ----------
P.Rich = Chat._Rich
function Chat:_Rich(text, meta)
    local who, where, rest = P.Parse(text)
    if not who then return P.Rich(self, text, meta) end
    local head = "<font color='#" .. Hex("Dim") .. "' size='11'><i>↪ Forwarded from <b>" .. RichEsc(who) .. "</b>"
        .. (where ~= "" and (" · " .. RichEsc(where)) or "") .. "</i></font>"
    if rest == "" then return head end
    return head .. "\n" .. P.Rich(self, rest, meta)
end

-- ---------- menu: Forward (under Reply); forwarded messages can't be edited and copy/reply use the original text ----------
P.MenuItems = Chat._MenuItems
function Chat:_MenuItems(msg)
    local groups = P.MenuItems(self, msg)
    if type(groups) ~= "table" or type(msg) ~= "table" then return groups end
    if P.Can(msg) and type(groups[1]) == "table" then
        local pos = #groups[1] + 1
        for i, it in ipairs(groups[1]) do
            if it.Text == "Reply" then pos = i + 1 break end
        end
        table.insert(groups[1], pos, { Text = "Forward", Icon = "forward", Cb = function() self:ForwardMessage(msg) end })
    end
    local who, _, rest = P.Parse(msg.text)
    if who then
        for _, g in ipairs(groups) do
            for i = #g, 1, -1 do
                local it = g[i]
                if it.Text == "Edit Message" or (it.Text == "Copy Text" and rest == "") then
                    table.remove(g, i)
                elseif it.Text == "Copy Text" then
                    it.Cb = function() if type(setclipboard) == "function" then setclipboard(rest) end end
                elseif it.Text == "Reply" then
                    it.Cb = function()
                        self:SetReply({ id = msg.id, name = P.Author(msg), text = P.Clean(rest ~= "" and rest or ("Forwarded from " .. who), 70) })
                    end
                end
            end
        end
    end
    return groups
end

end
-- ===================== end patch 6.0 =====================

-- ===================== Aether patch 6.1: discord-style forwarded messages =====================
do
local P = {}
Lib.Version = "6.1.0"

-- wire format only (never drawn): "<arrow> Forwarded from Name · #channel\nbody"
local ARROW = utf8.char(0x21AA)

local function Parse(txt)
    local line, rest = tostring(txt or ""):match("^" .. ARROW .. " Forwarded from ([^\n]*)\n?(.*)$")
    if not line then return nil end
    local who, where = line:match("^(.-) · (.+)$")
    if not who then who, where = line, "" end
    return who, where, rest
end

-- the text body never contains the header line any more
P.Rich = Chat._Rich
function Chat:_Rich(text, meta)
    local who, _, rest = Parse(text)
    return P.Rich(self, who and rest or text, meta)
end

function Chat:_FwdStyle(item, meta, who, where, rest)
    local col = item:FindFirstChild("Col")
    local bubble = col and col:FindFirstChild("Bubble")
    if not bubble or meta.fwdBuilt then return end
    meta.fwdBuilt = true

    -- header: [icon] Forwarded
    local head = New("Frame", { Name = "FwdHead", Size = UDim2.new(1, 0, 0, H(16)), LayoutOrder = 1, BackgroundTransparency = 1, Parent = bubble })
    Lib.Icon("forward", 13, "Dim", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Parent = head }, ">")
    New("TextLabel", { RichText = true, Text = "<i>Forwarded</i>", TextSize = 12, Size = UDim2.new(1, -18, 1, 0), Position = UDim2.fromOffset(18, 0),
        TextXAlignment = LEFT, Theme = { TextColor3 = "Dim" }, Parent = head })

    -- quote block with the grey bar
    local block = New("Frame", { Name = "FwdBlock", Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, LayoutOrder = 2, Parent = bubble })
    local bar = New("Frame", { Name = "Bar", Size = UDim2.new(0, 3, 0, 0), Theme = { BackgroundColor3 = "Dim" }, Parent = block })
    Corner(bar, 2)
    local inner = New("Frame", { Name = "Inner", Size = UDim2.new(1, -12, 0, 0), Position = UDim2.fromOffset(12, 0), AutomaticSize = Y,
        BackgroundTransparency = 1, Parent = block })
    List(inner, 3)

    -- the original text / image live inside the block
    meta.body.Parent = inner
    meta.body.Visible = rest ~= ""
    local img = bubble:FindFirstChild("Image")
    if img then img.Parent = inner end

    -- footer: [icon] from Name · #channel
    local foot = New("Frame", { Name = "FwdFoot", Size = UDim2.new(1, 0, 0, H(16)), LayoutOrder = 400, BackgroundTransparency = 1, Parent = inner })
    Lib.Icon(where:sub(1, 1) == "#" and "hash" or "user", 12, "Dim", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Parent = foot }, "#")
    New("TextLabel", { RichText = true, TextSize = 11, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(16, 0), TextXAlignment = LEFT,
        TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Dim" }, Parent = foot,
        Text = "from <b>" .. RichEsc(who) .. "</b>" .. (where ~= "" and (" · " .. RichEsc(where)) or "") })

    -- bar + block follow the real content height
    local function Fit()
        if not (inner.Parent and block.Parent) then return end
        local h = math.ceil(inner.AbsoluteSize.Y / math.max(Lib.Scale, 0.01))
        block.Size = UDim2.new(1, 0, 0, h)
        bar.Size = UDim2.new(0, 3, 0, h)
    end
    inner:GetPropertyChangedSignal("AbsoluteSize"):Connect(Fit)
    task.defer(Fit)
end

P.AddMessage = Chat.AddMessage
function Chat:AddMessage(msg)
    local last = self.Items[#self.Items]
    local res = P.AddMessage(self, msg)
    local item = self.Items[#self.Items]
    local meta = item and item ~= last and self.Meta[item]
    if meta and meta.msg == msg and not meta.isCard then
        local who, where, rest = Parse(meta.txt)
        if who then
            local ok, err = pcall(function()
                self:_FwdStyle(item, meta, who, where, rest)
                self:_WidenItem(item)
            end)
            if not ok then warn("[Aether] forwarded style: " .. tostring(err)) end
        end
    end
    return res
end

-- searching highlights only the real text, not the header line
P.ApplySearch = Chat.ApplySearch
function Chat:ApplySearch(keep)
    local tmp = {}
    for _, it in ipairs(self.Items) do
        local m = self.Meta[it]
        if m and m.fwdBuilt and m.s1 == nil then
            local _, _, rest = Parse(m.txt)
            if rest then m.s1 = rest tmp[#tmp + 1] = m end
        end
    end
    local ok, err = pcall(P.ApplySearch, self, keep)
    for _, m in ipairs(tmp) do m.s1 = nil end
    if not ok then warn("[Aether] search: " .. tostring(err)) end
end

end
-- ===================== end patch 6.1 =====================

-- ===================== Aether patch 6.2: discord sidebar, quick switcher, user panel, profile banner =====================
do
local P = {}
Lib.Version = "6.2.0"

local function TitleCase(s)
    return (tostring(s):lower():gsub("(%a)(%a*)", function(a, b) return a:upper() .. b end))
end

local function IsCaps(t)
    return type(t) == "string" and t:match("^[A-Z][A-Z ]+$") ~= nil
end

-- ==================== 1) quick switcher (Find or start a chat) ====================
function Chat:QuickSwitcher()
    local me = LocalPlayer.UserId
    if self._qs and self._qs.Parent then self._qs:Destroy() end
    local Z, W, HH = 150, 440, 400

    local dim = New("TextButton", { Name = "QuickSwitch", Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.5,
        BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = Z, Parent = Lib.Overlay })
    self._qs = dim
    local card = Sink(New("Frame", { Size = UDim2.fromOffset(W, HH), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0.14, 0),
        ZIndex = Z + 1, Theme = { BackgroundColor3 = "Bg" }, Parent = dim }))
    Corner(card, 10) Stroke(card)
    local vp = Lib.Overlay.AbsoluteSize
    local ui = New("UIScale", { Scale = (vp.X > 0 and vp.Y > 0) and math.min(1, vp.X / (W + 20), vp.Y / (HH + 140)) or 1, Parent = card })

    local conn
    local function Close()
        if conn then conn:Disconnect() conn = nil end
        if dim.Parent then dim:Destroy() end
    end
    dim.Activated:Connect(Close)
    dim.Destroying:Connect(function() if conn then conn:Disconnect() conn = nil end end)

    local bf = New("Frame", { Size = UDim2.new(1, -24, 0, H(44)), Position = UDim2.fromOffset(12, 12), BackgroundTransparency = 0, ZIndex = Z + 2,
        Theme = { BackgroundColor3 = "Field" }, Parent = card })
    Corner(bf, 8) Stroke(bf, "Accent", 1.5, 0.15)
    Lib.Icon("search", 17, "Dim", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0), ZIndex = Z + 3, Parent = bf }, "?")
    local box = New("TextBox", { Text = "", PlaceholderText = "Where would you like to go?", PlaceholderColor3 = Lib.Theme.Dim, TextSize = 16,
        Size = UDim2.new(1, -48, 1, 0), Position = UDim2.fromOffset(40, 0), TextXAlignment = LEFT, ZIndex = Z + 3, Parent = bf })
    local listTop = 12 + H(44) + 8
    local list = New("ScrollingFrame", { Size = UDim2.new(1, -16, 1, -(listTop + 30)), Position = UDim2.fromOffset(8, listTop), AutomaticCanvasSize = Y,
        ScrollBarThickness = 3, ZIndex = Z + 2, Parent = card })
    List(list, 2)
    New("TextLabel", { Text = "Up / Down to move  ·  Enter to open  ·  Esc to close", TextSize = 10, Size = UDim2.new(1, -24, 0, 16),
        AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 12, 1, -8), TextXAlignment = LEFT, ZIndex = Z + 2, Theme = { TextColor3 = "Dim" }, Parent = card })

    -- everything you can jump to
    local entries = {}
    local favs = Lib:LoadChatState().favs
    for _, ch in ipairs(self.Channels) do
        local kind = ch.kind or "pub"
        local n = #(ch.members or {})
        local sub = kind == "dm" and "Direct message" or (kind == "grp" and ("Group chat" .. (n > 0 and (" · " .. n .. " members") or "")) or "Channel")
        entries[#entries + 1] = { room = ch.room, kind = kind, name = tostring(ch.name or "?"), sub = sub, ch = ch, uid = tonumber(ch.uid), unread = ch.unread or 0 }
    end
    for _, u in ipairs((self.Friends and self.Friends.friends) or {}) do
        local uid = tonumber(u.uid)
        local room = uid and uid ~= me and self:DMRoom(uid)
        if room and not self:_RoomIndex(room) then
            entries[#entries + 1] = { room = room, kind = "friend", uid = uid, u = u, unread = 0, sub = "Friend",
                name = tostring((u.display and u.display ~= "") and u.display or u.name or uid) }
        end
    end
    for i, e in ipairs(entries) do
        e.o = i
        e.score = (e.unread > 0 and 2 or 0) + (favs[e.room] and 1 or 0)
    end
    table.sort(entries, function(a, b)
        if a.score ~= b.score then return a.score > b.score end
        return a.o < b.o
    end)

    local function BaseRow(order, name, sub)
        local row = New("TextButton", { Name = "Row", Text = "", Size = UDim2.new(1, 0, 0, H(44)), LayoutOrder = order, BackgroundTransparency = 1, ZIndex = Z + 3,
            Theme = { BackgroundColor3 = "FieldHover" }, Parent = list })
        Corner(row, 8)
        local av = New("Frame", { Size = UDim2.fromOffset(32, 32), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0), BackgroundTransparency = 0,
            ZIndex = Z + 4, Theme = { BackgroundColor3 = "Field" }, Parent = row })
        Corner(av, 16)
        New("TextLabel", { Text = name, Font = Lib.FontBold, TextSize = 13, Size = UDim2.new(1, -110, 0, 16), Position = UDim2.fromOffset(52, 6), TextXAlignment = LEFT,
            TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = Z + 4, Parent = row })
        New("TextLabel", { Text = sub, TextSize = 11, Size = UDim2.new(1, -110, 0, 14), Position = UDim2.fromOffset(52, 23), TextXAlignment = LEFT,
            TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = Z + 4, Theme = { TextColor3 = "Dim" }, Parent = row })
        return row, av
    end

    local function Pick(e)
        Close()
        if e.kind == "friend" then
            self:OpenDM(e.uid, e.u.name, e.name)
        else
            local idx = self:_RoomIndex(e.room)
            if idx then self:SetChannel(idx) end
        end
    end

    local rows = {}
    for i, e in ipairs(entries) do
        local row, av = BaseRow(i, e.name, e.sub)
        if e.kind == "dm" or e.kind == "friend" then
            local img = New("ImageLabel", { Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop, ZIndex = Z + 5, Parent = av })
            Corner(img, 16)
            if e.uid then GetAvatar(e.uid, function(u) if img.Parent then img.Image = u end end) end
        elseif e.kind == "grp" then
            local glyph = New("TextLabel", { Text = "«", Font = Lib.FontBold, TextSize = 16, Size = UDim2.fromScale(1, 1), ZIndex = Z + 5, Theme = { TextColor3 = "SubText" }, Parent = av })
            pcall(function()
                local entry = Lib:LoadGroupIcons()[tostring(e.ch.gid)]
                if entry then
                    local img = New("ImageLabel", { Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop, ZIndex = Z + 5, Parent = av })
                    Corner(img, 16)
                    self:_IconAsset(entry, e.room, function(a) if img.Parent then img.Image = a glyph.Text = "" end end)
                else
                    local ids = {}
                    for _, m in ipairs(e.ch.members or {}) do
                        local id = tonumber(type(m) == "table" and (m.uid or m.id) or m)
                        if id and id ~= me and #ids < 4 then ids[#ids + 1] = id end
                    end
                    if #ids > 0 then
                        av.BackgroundTransparency = 1
                        glyph.Text = ""
                        self:_Collage(av, ids, 32, Z + 5)
                    end
                end
            end)
        else
            New("TextLabel", { Text = "#", Font = Lib.FontBold, TextSize = 18, Size = UDim2.fromScale(1, 1), ZIndex = Z + 5, Theme = { TextColor3 = "SubText" }, Parent = av })
        end
        if e.unread > 0 then
            local bd = New("Frame", { Size = UDim2.fromOffset(e.unread > 9 and 24 or 18, 16), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0),
                BackgroundTransparency = 0, ZIndex = Z + 4, Theme = { BackgroundColor3 = "Bad" }, Parent = row })
            Corner(bd, 8)
            New("TextLabel", { Text = e.unread > 9 and "9+" or tostring(e.unread), Font = Lib.FontBold, TextSize = 10, Size = UDim2.fromScale(1, 1), TextColor3 = WHITE,
                ZIndex = Z + 5, Parent = bd })
        end
        row.Activated:Connect(function() Pick(e) end)
        rows[#rows + 1] = { row = row, hay = (e.name .. " " .. e.sub):lower(), act = function() Pick(e) end }
    end

    local vis, sel, extra = {}, 1, nil
    local function Highlight()
        for i, v in ipairs(vis) do v.row.BackgroundTransparency = (i == sel) and 0.55 or 1 end
        local v = vis[sel]
        if v and v.row.Parent then
            local sc = math.max(ui.Scale, 0.01)
            local top = v.row.AbsolutePosition.Y - list.AbsolutePosition.Y
            local bot = top + v.row.AbsoluteSize.Y
            if top < 0 then
                list.CanvasPosition = Vector2.new(0, math.max(0, list.CanvasPosition.Y + top / sc))
            elseif bot > list.AbsoluteSize.Y then
                list.CanvasPosition = Vector2.new(0, list.CanvasPosition.Y + (bot - list.AbsoluteSize.Y) / sc)
            end
        end
    end

    local function Filter()
        local q = (Trim(box.Text):lower():gsub("^@", ""))
        vis = {}
        for _, r in ipairs(rows) do
            local show = q == "" or r.hay:find(q, 1, true) ~= nil
            r.row.Visible = show
            if show then vis[#vis + 1] = r end
        end
        if extra then extra:Destroy() extra = nil end
        if #q >= 3 and q:match("^[%w_]+$") then
            local row, av = BaseRow(100000, "Message @" .. q, "Look this Roblox user up and open a DM")
            Lib.Icon("search", 16, "SubText", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = Z + 5, Parent = av }, "?")
            extra = row
            local function Go()
                Close()
                self:ResolveUser(q, function(u)
                    if not u then Lib:Notify({ Title = "Direct message", Text = "Couldn't find that Roblox user.", Type = "error" }) return end
                    if tonumber(u.uid) == me then Lib:Notify({ Title = "Direct message", Text = "That's you.", Type = "warn" }) return end
                    self:OpenDM(u.uid, u.name, u.display)
                end)
            end
            row.Activated:Connect(Go)
            vis[#vis + 1] = { row = row, act = Go }
        end
        sel = 1
        Highlight()
    end
    box:GetPropertyChangedSignal("Text"):Connect(Filter)
    box.FocusLost:Connect(function(enter)
        if enter and vis[sel] then vis[sel].act() end
    end)
    conn = UIS.InputBegan:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.Down then
            sel = math.min(#vis, sel + 1)
            Highlight()
        elseif i.KeyCode == Enum.KeyCode.Up then
            sel = math.max(1, sel - 1)
            Highlight()
        elseif i.KeyCode == Enum.KeyCode.Escape then
            Close()
        end
    end)
    Filter()
    if not Lib.Touch then task.defer(function() if box.Parent then box:CaptureFocus() end end) end
end

-- ==================== 2) sidebar: find button, nav rows, user panel ====================
function Chat:_UpdateDiscordNav()
    local n = self._nav
    if not n then return end
    local c = #self.Friends.incoming
    n.frBadge.Visible = c > 0
    n.frBadgeText.Text = c > 9 and "9+" or tostring(c)
    local p = #(self.Pinned or {})
    n.pinCount.Text = p > 0 and tostring(p) or ""
end

function Chat:_UpdateUserPanel()
    local u = self._up
    if not (u and u.name.Parent) then return end
    local nm = Lib:LoadChatName()
    if nm == "" then nm = LocalPlayer.DisplayName end
    u.name.Text = nm
    local st = self.State or "Connecting"
    if st == "Connected" then
        u.sub.Text = "Online · " .. tostring(self.Online or 0) .. " in chat"
        u.dot.BackgroundColor3 = Lib.Theme.Good
    elseif st == "Connecting" then
        u.sub.Text = "Connecting..."
        u.dot.BackgroundColor3 = Lib.Theme.Warn
    else
        u.sub.Text = st == "No server" and "No server" or "Offline"
        u.dot.BackgroundColor3 = Lib.Theme.Bad
    end
end

P.SetStatus = Chat.SetStatus
function Chat:SetStatus(state, text)
    P.SetStatus(self, state, text)
    pcall(function() self:_UpdateUserPanel() end)
end

function Chat:_InitDiscordSidebar()
    local sb = self._sb
    if not sb or self._nav then return end
    local card, list = sb.card, sb.list
    card.ClipsDescendants = true
    for _, c in ipairs(card:GetChildren()) do
        if c:IsA("Frame") and c ~= list and c.AnchorPoint == Vector2.new(0.5, 1) then c.Visible = false end -- old Friends / Pins footer
    end

    local fh, nh, uh = H(28), H(28), H(44)
    local y = 6

    -- Find or start a chat
    local find = New("TextButton", { Name = "FindBtn", Text = "", Size = UDim2.new(1, -12, 0, fh), Position = UDim2.fromOffset(6, y), BackgroundTransparency = 0,
        Theme = { BackgroundColor3 = "Field" }, Parent = card })
    Corner(find, 5) Stroke(find, "Stroke", 1, 0.5)
    Lib.Icon("search", 13, "Dim", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), Parent = find }, "?")
    New("TextLabel", { Text = "Find or start a chat", TextSize = 11, Size = UDim2.new(1, -30, 1, 0), Position = UDim2.fromOffset(26, 0), TextXAlignment = LEFT,
        TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Dim" }, Parent = find })
    find.MouseEnter:Connect(function() Tween(find, { BackgroundColor3 = Lib.Theme.FieldHover }, 0.08) end)
    find.MouseLeave:Connect(function() Tween(find, { BackgroundColor3 = Lib.Theme.Field }, 0.1) end)
    find.Activated:Connect(function() self:QuickSwitcher() end)
    Lib:AddTooltip(find, "Ctrl + K")
    y = y + fh + 6

    local nav = {}
    local function NavRow(icon, text, fn)
        local b = New("TextButton", { Name = "Nav", Text = "", Size = UDim2.new(1, -8, 0, nh), Position = UDim2.fromOffset(4, y), BackgroundTransparency = 1,
            Theme = { BackgroundColor3 = "FieldHover" }, Parent = card })
        Corner(b, 5)
        local ico = Lib.Icon(icon, 16, "SubText", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0), Parent = b })
        local lbl = New("TextLabel", { Text = text, TextSize = 13, Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(34, 0), TextXAlignment = LEFT,
            Theme = { TextColor3 = "SubText" }, Parent = b })
        b.MouseEnter:Connect(function()
            Tween(b, { BackgroundTransparency = 0.45 }, 0.06)
            Tint(ico, Lib.Theme.Text, 0.08)
            Tween(lbl, { TextColor3 = Lib.Theme.Text }, 0.08)
        end)
        b.MouseLeave:Connect(function()
            Tween(b, { BackgroundTransparency = 1 }, 0.08)
            Tint(ico, Lib.Theme.SubText, 0.1)
            Tween(lbl, { TextColor3 = Lib.Theme.SubText }, 0.1)
        end)
        b.Activated:Connect(fn)
        y = y + nh + 2
        return b
    end

    local fr = NavRow("users", "Friends", function() self:ShowFriends(#self.Friends.incoming > 0 and "requests" or "friends") end)
    local badge = New("Frame", { Size = UDim2.fromOffset(18, 16), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Visible = false,
        BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Bad" }, Parent = fr })
    Corner(badge, 8)
    local badgeText = New("TextLabel", { Text = "0", Font = Lib.FontBold, TextSize = 10, Size = UDim2.fromScale(1, 1), TextColor3 = WHITE, Parent = badge })

    local pins = NavRow("pin", "Pins", function() self:ShowPins() end)
    local pinCount = New("TextLabel", { Text = "", TextSize = 11, Size = UDim2.fromOffset(30, nh), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 0),
        TextXAlignment = RIGHT, Theme = { TextColor3 = "Dim" }, Parent = pins })

    New("Frame", { Size = UDim2.new(1, -16, 0, 1), Position = UDim2.fromOffset(8, y + 2), BackgroundTransparency = 0.5, Theme = { BackgroundColor3 = "Stroke" }, Parent = card })
    local top = y + 8
    list.Position = UDim2.fromOffset(2, top)
    list.Size = UDim2.new(1, -4, 1, -(top + uh + 10))
    self._nav = { frBadge = badge, frBadgeText = badgeText, pinCount = pinCount }

    -- user panel at the bottom
    local up = New("Frame", { Name = "UserPanel", Size = UDim2.new(1, -8, 0, uh), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -4),
        BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Bg" }, Parent = card })
    Corner(up, 6) Stroke(up, "Stroke", 1, 0.5)
    local hit = New("TextButton", { Text = "", Size = UDim2.new(1, -30, 1, 0), ZIndex = 2, Parent = up })
    local av = New("ImageLabel", { Size = UDim2.fromOffset(28, 28), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 6, 0.5, 0), BackgroundTransparency = 0,
        ScaleType = Enum.ScaleType.Crop, ZIndex = 3, Theme = { BackgroundColor3 = "Field" }, Parent = up })
    Corner(av, 14)
    GetAvatar(LocalPlayer.UserId, function(u) if av.Parent then av.Image = u end end)
    local dot = New("Frame", { Size = UDim2.fromOffset(10, 10), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 3, 1, 3), ZIndex = 4,
        BackgroundColor3 = Lib.Theme.Warn, Parent = av })
    Corner(dot, 5) Stroke(dot, "Bg", 2, 0)
    local nameL = New("TextLabel", { Text = "", Font = Lib.FontBold, TextSize = 12, Size = UDim2.new(1, -72, 0, 16), Position = UDim2.fromOffset(40, 6), TextXAlignment = LEFT,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3, Parent = up })
    local subL = New("TextLabel", { Text = "", TextSize = 10, Size = UDim2.new(1, -72, 0, 14), Position = UDim2.fromOffset(40, 22), TextXAlignment = LEFT,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3, Theme = { TextColor3 = "Dim" }, Parent = up })
    local gear = IconButton(up, "settings", "*", H(24), "Settings", "Accent", 1)
    gear.Button.AnchorPoint, gear.Button.Position, gear.Button.ZIndex = Vector2.new(1, 0.5), UDim2.new(1, -4, 0.5, 0), 3
    gear.Button.Activated:Connect(function()
        local w = Lib.MainWindow
        if w and w._settingsTab then
            Lib:SetVisible(true)
            if w.Minimized then w:SetMinimized(false) end
            w:SelectTab(w._settingsTab)
        else
            Lib:Notify({ Text = "Settings aren't available.", Type = "warn" })
        end
    end)
    hit.Activated:Connect(function()
        self:ShowProfile({ uid = LocalPlayer.UserId, name = LocalPlayer.Name, display = LocalPlayer.DisplayName })
    end)
    self._up = { name = nameL, sub = subL, dot = dot }
    self:_UpdateUserPanel()
    self:_UpdateDiscordNav()
    self:_QueueSidebar()
end

-- ==================== 3) sidebar rows: member counts, title-case headers ====================
function Chat:_DiscordRows()
    local sb = self._sb
    local list = sb and sb.list
    if not (list and list.Parent) then return end
    local used = {}
    for _, c in ipairs(list:GetChildren()) do
        if c:IsA("TextLabel") and IsCaps(c.Text) then
            c.Text = TitleCase(c.Text)
            c.TextSize = 11
        elseif c:IsA("Frame") and c.Name ~= "PresenceCard" then
            local l = c:FindFirstChildWhichIsA("TextLabel")
            if l and IsCaps(l.Text) then
                l.Text = TitleCase(l.Text)
                l.TextSize = 11
            end
        elseif c.Name == "Ch" and c:IsA("TextButton") then
            local nameLbl
            for _, x in ipairs(c:GetChildren()) do
                if x:IsA("TextLabel") and x.Position.X.Scale == 0 and x.Position.X.Offset >= 22 and x.Position.Y.Scale == 0 and x.Position.Y.Offset == 0 then nameLbl = x end
            end
            if nameLbl then
                for _, ch in ipairs(self.Channels) do
                    if ch.kind == "grp" and not used[ch] and tostring(ch.name) == nameLbl.Text then
                        used[ch] = true
                        local n = #(ch.members or {})
                        if n > 0 then
                            c.Size = UDim2.new(1, 0, 0, H(38))
                            local px, sx = nameLbl.Position.X.Offset, nameLbl.Size.X
                            nameLbl.Position = UDim2.fromOffset(px, 3)
                            nameLbl.Size = UDim2.new(sx.Scale, sx.Offset, 0, 18)
                            New("TextLabel", { Text = n .. (n == 1 and " Member" or " Members"), TextSize = 10, Size = UDim2.new(sx.Scale, sx.Offset, 0, 13),
                                Position = UDim2.fromOffset(px, 20), TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Dim" }, Parent = c })
                        end
                        break
                    end
                end
            end
        end
    end
end

P.RenderSidebar = Chat._RenderSidebar
function Chat:_RenderSidebar()
    P.RenderSidebar(self)
    local sb = self._sb
    if not (sb and sb.list.Parent and sb.card.Visible) then return end
    local ok, err = pcall(function() self:_DiscordRows() end)
    if not ok then warn("[Aether] sidebar rows: " .. tostring(err)) end
    pcall(function() self:_UpdateDiscordNav() end)
    pcall(function() self:_UpdateUserPanel() end)
end

-- Compact layout has no sidebar, so the chevron menu gets the entry
P.PopMenu = Chat._PopMenu
function Chat:_PopMenu(spec, anchor)
    if anchor ~= nil and anchor == self.ChBtn and spec.Name ~= "Notifications" and not self.Wide and spec.Sections and spec.Sections[2] then
        table.insert(spec.Sections[2], 1, { Text = "Find or Start a Chat", Icon = "search", Hint = "Ctrl K", Cb = function() self:QuickSwitcher() end })
    end
    return P.PopMenu(self, spec, anchor)
end

-- ==================== 4) profile card: banner, big avatar, status dot ====================
P.ShowProfile = Chat.ShowProfile
function Chat:ShowProfile(u)
    local before = {}
    for _, c in ipairs(Lib.Overlay:GetChildren()) do before[c] = true end
    P.ShowProfile(self, u)
    local ok, err = pcall(function()
        local uid = tonumber(u.uid)
        if not uid then return end
        local dim
        for _, c in ipairs(Lib.Overlay:GetChildren()) do
            if not before[c] and c:IsA("TextButton") then dim = c end
        end
        local card = dim and dim:FindFirstChildWhichIsA("Frame")
        if not card then return end

        local head
        for _, c in ipairs(card:GetChildren()) do
            if c:IsA("Frame") and c.LayoutOrder == 1 then head = c break end
        end
        local pic = head and head:FindFirstChildWhichIsA("ImageLabel")
        if not pic then return end

        -- banner (bleeds into the card's padding, flat at the bottom)
        local base = Lib.Theme.Accent:Lerp(Color3.new(0, 0, 0), 0.3)
        local holder = New("Frame", { Name = "Banner", Size = UDim2.new(1, 0, 0, 50), LayoutOrder = 0, BackgroundTransparency = 1, ZIndex = 102, Parent = card })
        local fill = New("Frame", { Position = UDim2.fromOffset(-14, -14), Size = UDim2.new(1, 28, 1, 14), BackgroundColor3 = base, ZIndex = 102, Parent = holder })
        Corner(fill, 8)
        New("Frame", { Size = UDim2.new(1, 0, 0, 10), AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = base, ZIndex = 102, Parent = fill })

        -- avatar overlaps the banner
        head.Size = UDim2.new(1, 0, 0, 40)
        pic.Size = UDim2.fromOffset(64, 64)
        pic.Position = UDim2.fromOffset(0, -30)
        pic.ZIndex = 104
        local cr = pic:FindFirstChildOfClass("UICorner")
        if cr then cr.CornerRadius = UDim.new(0, 32) end
        Stroke(pic, "Bg", 4, 0)

        local labels = {}
        for _, c in ipairs(head:GetChildren()) do
            if c:IsA("TextLabel") then labels[#labels + 1] = c end
        end
        table.sort(labels, function(a, b) return a.Position.Y.Offset < b.Position.Y.Offset end)
        if labels[1] then
            labels[1].Position = UDim2.fromOffset(76, 4)
            labels[1].Size = UDim2.new(1, -84, 0, 18)
        end
        if labels[2] then
            labels[2].Position = UDim2.fromOffset(76, 23)
            labels[2].Size = UDim2.new(1, -84, 0, 14)
        end

        -- status dot
        local online = uid == LocalPlayer.UserId or Players:GetPlayerByUserId(uid) ~= nil or (self.Friends.online[tostring(uid)] == true)
        if not online then
            for _, x in ipairs(self.Users or {}) do
                if tonumber(x.uid) == uid then online = true break end
            end
        end
        local dot = New("Frame", { Size = UDim2.fromOffset(16, 16), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -2, 1, -2), ZIndex = 106,
            BackgroundColor3 = online and Lib.Theme.Good or Lib.Theme.Dim, Parent = pic })
        Corner(dot, 8) Stroke(dot, "Bg", 3, 0)

        -- wording
        for _, d in ipairs(card:GetDescendants()) do
            if d:IsA("TextLabel") then
                if d.Text == "Created" then d.Text = "Member since"
                elseif d.Parent == card and IsCaps(d.Text) then
                    d.Text = TitleCase(d.Text)
                    d.TextSize = 11
                end
            end
        end
    end)
    if not ok then warn("[Aether] profile banner: " .. tostring(err)) end
end

-- ==================== 5) hooks ====================
P.CreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
    local chat = P.CreateChat(self, cfg)
    if chat and not chat._p62 then
        chat._p62 = true
        local ok, err = pcall(function() chat:_InitDiscordSidebar() end)
        if not ok then warn("[Aether] discord sidebar: " .. tostring(err)) end
    end
    return chat
end

Lib:Connect(UIS.InputBegan, function(i)
    if i.KeyCode ~= Enum.KeyCode.K then return end
    if not (UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl)) then return end
    local c = Lib.ChatObj
    if c and c.PanelObj and c.PanelObj._shown then c:QuickSwitcher() end
end)

end
-- ===================== end patch 6.2 =====================

-- ===================== Aether patch 6.3: user settings, profile art =====================
do
local P = {}
Lib.Version = "6.3.0"

-- ==================== 1) saved profile art ====================
Lib.Art = {}
do
    local loaded, tick = false, 0
    local function Path() return Lib.ConfigFolder .. "/profileart.json" end
    local function Clean(e)
        if type(e) ~= "table" then return nil end
        if type(e.asset) == "string" and e.asset:find("^rbxassetid://%d+$") then return { asset = e.asset } end
        if e.id ~= nil and #tostring(e.id) < 80 then
            return { id = tostring(e.id), mime = type(e.mime) == "string" and e.mime or "image/png" }
        end
        return nil
    end
    function Lib:LoadArt()
        if loaded then return self.Art end
        loaded = true
        if FsOk() then
            pcall(function()
                local p = Path()
                if not isfile(p) then return end
                local d = HttpService:JSONDecode(readfile(p))
                if type(d) ~= "table" then return end
                self.Art.pfp = Clean(d.pfp)
                self.Art.banner = Clean(d.banner)
            end)
        end
        return self.Art
    end
    function Lib:SaveArt()
        if not FsOk() then return end
        tick = tick + 1
        local t = tick
        task.delay(0.6, function()
            if t ~= tick then return end
            pcall(function()
                if not isfolder(Lib.ConfigFolder) then makefolder(Lib.ConfigFolder) end
                writefile(Path(), HttpService:JSONEncode({ pfp = Lib.Art.pfp, banner = Lib.Art.banner }))
            end)
        end)
    end
end

function Lib:SetArt(kind, entry)
    local a = self:LoadArt()
    a[kind] = entry
    self:SaveArt()
    local c = self.ChatObj
    if not c then return end
    pcall(function() c:_UpdateUserPanel() end)
    -- best effort: tell the relay (older relays just ignore this)
    task.spawn(function()
        pcall(function()
            local body = { kind = kind, clear = true }
            if entry and entry.id then body = { kind = kind, image = entry.id }
            elseif entry and entry.asset then body = { kind = kind, asset = entry.asset } end
            c:_Do("/profile/art", nil, "POST", HttpService:JSONEncode(body))
        end)
    end)
end

-- resolves { asset = ... } or { id = ... } to something an ImageLabel can show
function Chat:_ArtImage(entry, cb)
    if not entry then return end
    if entry.asset then cb(entry.asset) return end
    self:_IconAsset(entry, self.Room, cb)
end

-- ==================== 2) picking art (image search / asset id / reset) ====================
function Chat:ChooseArt(kind, anchor, after)
    local label = kind == "pfp" and "profile picture" or "banner"
    local items = {
        { Text = "Search images...", Callback = function()
            self._artPick = { kind = kind, after = after, shown = false }
            Lib:Notify({ Title = "Profile", Text = "Search for a picture, then tap it to use it as your " .. label .. ".", Type = "info", Duration = 4 })
            self:PickSearch()
        end },
        { Text = "Use an asset id...", Callback = function()
            Lib:Prompt({ Title = "Asset id", Text = "Paste an Image asset id (a number or rbxassetid://...).", Placeholder = "123456789", Confirm = "Use" }, function(t)
                t = Trim(t)
                local n = t:match("^(%d+)$") or t:match("rbxassetid://(%d+)") or t:match("[?&]id=(%d+)")
                if not n then Lib:Notify({ Title = "Profile", Text = "That doesn't look like an asset id.", Type = "error" }) return end
                Lib:SetArt(kind, { asset = "rbxassetid://" .. n })
                if after then Safe(after) end
            end)
        end },
    }
    if Lib:LoadArt()[kind] then
        table.insert(items, { Text = "Reset to default", Danger = true, Callback = function()
            Lib:SetArt(kind, nil)
            if after then Safe(after) end
        end })
    end
    self:Menu(items, anchor)
end

P.PickSearch = Chat.PickSearch
function Chat:PickSearch()
    local pk = self._artPick
    if pk and pk.started then self._artPick = nil end -- a stale pick from a cancelled search
    if self._artPick then self._artPick.started = true end
    return P.PickSearch(self)
end

P.ShowResults = Chat.ShowResults
function Chat:ShowResults(q)
    local pk = self._artPick
    local before = {}
    for _, c in ipairs(Lib.Overlay:GetChildren()) do before[c] = true end
    P.ShowResults(self, q)
    if not pk then return end
    pk.shown = true
    for _, c in ipairs(Lib.Overlay:GetChildren()) do
        if not before[c] and c:IsA("TextButton") then
            c.Destroying:Connect(function()
                task.delay(0.5, function() if self._artPick == pk then self._artPick = nil end end)
            end)
        end
    end
end

P.SendImage = Chat.SendImage
function Chat:SendImage(payload)
    local pk = self._artPick
    if pk then
        self._artPick = nil
        if pk.shown then
            self:_SetArt(pk, payload)
            return
        end
    end
    return P.SendImage(self, payload)
end

function Chat:_SetArt(pk, payload)
    Lib:Notify({ Title = "Profile", Text = "Uploading...", Type = "info", Duration = 2 })
    task.spawn(function()
        local d = Decode(self:_Do("/upload", nil, "POST", HttpService:JSONEncode(payload)))
        if not (d and d.ok and d.id ~= nil) then
            Lib:Notify({ Title = "Profile", Text = (d and d.error) or "Upload failed.", Type = "error" })
            return
        end
        Lib:SetArt(pk.kind, { id = tostring(d.id), mime = type(d.mime) == "string" and d.mime or "image/png" })
        Lib:Notify({ Title = "Profile", Text = (pk.kind == "pfp" and "Profile picture" or "Banner") .. " updated.", Type = "success", Duration = 3 })
        if pk.after then Safe(pk.after) end
    end)
end

-- ==================== 3) sidebar user panel shows your picture ====================
P.UpdateUserPanel = Chat._UpdateUserPanel
function Chat:_UpdateUserPanel()
    P.UpdateUserPanel(self)
    pcall(function()
        local u = self._up
        if not (u and u.name.Parent) then return end
        local av = u.name.Parent:FindFirstChildWhichIsA("ImageLabel")
        if not av then return end
        local e = Lib:LoadArt().pfp
        local key = e and (e.asset or e.id) or "default"
        if u.artKey == key then return end
        u.artKey = key
        av.ScaleType = Enum.ScaleType.Crop
        if e then
            self:_ArtImage(e, function(a) if av.Parent and u.artKey == key then av.Image = a end end)
        else
            GetAvatar(LocalPlayer.UserId, function(url) if av.Parent and u.artKey == key then av.Image = url end end)
        end
    end)
end

-- ==================== 4) profile card: headshot fix, custom art, Edit Profile ====================
P.ShowProfile = Chat.ShowProfile
function Chat:ShowProfile(u)
    local before = {}
    for _, c in ipairs(Lib.Overlay:GetChildren()) do before[c] = true end
    P.ShowProfile(self, u)
    local ok, err = pcall(function()
        local uid = tonumber(u.uid)
        if not uid then return end
        local dim
        for _, c in ipairs(Lib.Overlay:GetChildren()) do
            if not before[c] and c:IsA("TextButton") then dim = c end
        end
        local card = dim and dim:FindFirstChildWhichIsA("Frame")
        if not card then return end
        local head, holder
        for _, c in ipairs(card:GetChildren()) do
            if c:IsA("Frame") then
                if c.Name == "Banner" then holder = c elseif c.LayoutOrder == 1 then head = c end
            end
        end
        local pic = head and head:FindFirstChildWhichIsA("ImageLabel")
        if not pic then return end
        local fill = holder and holder:FindFirstChildWhichIsA("Frame")
        local mine = uid == LocalPlayer.UserId

        -- the avatar: a cropped headshot (the old bust thumbnail looked cut off in the circle)
        pic.ScaleType = Enum.ScaleType.Crop
        pic.BackgroundTransparency = 0
        local want
        pic:GetPropertyChangedSignal("Image"):Connect(function()
            if want and pic.Image ~= want then pic.Image = want end
        end)
        local function Pfp(e)
            if e then self:_ArtImage(e, function(a) want = a pic.Image = a end)
            else GetAvatar(uid, function(a) want = a pic.Image = a end, "HeadShot", "Size150x150") end
        end
        local banner
        local function Banner(e)
            if not (e and fill and fill.Parent) then return end
            fill.ClipsDescendants = true
            if not banner then
                banner = New("ImageLabel", { Size = UDim2.new(1, 0, 1, 14), ScaleType = Enum.ScaleType.Crop, ZIndex = 103, Parent = fill })
                Corner(banner, 8)
            end
            self:_ArtImage(e, function(a) if banner and banner.Parent then banner.Image = a end end)
        end

        local art = mine and Lib:LoadArt() or {}
        Pfp(art.pfp)
        Banner(art.banner)

        if mine then
            local rows = {}
            for _, c in ipairs(card:GetChildren()) do if c:IsA("GuiObject") and c.LayoutOrder > 0 then rows[#rows + 1] = c end end
            table.sort(rows, function(a, b) return a.LayoutOrder < b.LayoutOrder end)
            local last = rows[#rows]
            local b = New("TextButton", { Text = "Edit Profile", TextSize = 12, Size = UDim2.new(1, 0, 0, H(28)), LayoutOrder = last and last.LayoutOrder or 99,
                BackgroundTransparency = 0, ZIndex = 103, Theme = { BackgroundColor3 = "Accent", TextColor3 = "OnAccent" }, Parent = card })
            Corner(b, 5)
            if last then last.LayoutOrder = last.LayoutOrder + 1 end
            b.Activated:Connect(function()
                if dim.Parent then dim:Destroy() end
                self:OpenSettings("profiles")
            end)
        else
            -- other people: only if the relay hands out their art
            task.spawn(function()
                local d = Decode(self:_Do("/profile", { target = uid }))
                local us = d and d.ok and d.user
                if not (us and dim.Parent) then return end
                local function E(v)
                    if type(v) == "table" and v.id ~= nil then return { id = tostring(v.id), mime = type(v.mime) == "string" and v.mime or "image/png" } end
                    if type(v) == "string" and v ~= "" and #v < 80 then return { id = v, mime = "image/png" } end
                end
                local p, bn = E(us.pfp), E(us.banner)
                if p then Pfp(p) end
                if bn then Banner(bn) end
            end)
        end

        -- "Member since" showed "-" for people in your server
        local plr = Players:GetPlayerByUserId(uid)
        if plr then
            for _, d in ipairs(card:GetDescendants()) do
                if d:IsA("TextLabel") and d.Text == "Member since" then
                    for _, v in ipairs(d.Parent:GetChildren()) do
                        if v:IsA("TextLabel") and v ~= d and v.Text == "-" then
                            v.Text = os.date("%Y-%m-%d", os.time() - plr.AccountAge * 86400)
                        end
                    end
                end
            end
        end
    end)
    if not ok then warn("[Aether] profile art: " .. tostring(err)) end
end

-- ==================== 5) the User Settings screen ====================
function Chat:_ProfilePreview(parent, order)
    local art = Lib:LoadArt()
    local card = New("Frame", { Name = "Preview", Size = UDim2.new(1, 0, 0, 150), LayoutOrder = order, BackgroundTransparency = 0,
        Theme = { BackgroundColor3 = "Card" }, Parent = parent })
    Corner(card, 10) Stroke(card, "Stroke", 1, 0.4)
    local ban = New("Frame", { Position = UDim2.fromOffset(8, 8), Size = UDim2.new(1, -16, 0, 84), BackgroundColor3 = Lib.Theme.Accent:Lerp(Color3.new(0, 0, 0), 0.3), Parent = card })
    Corner(ban, 8)
    if art.banner then
        local bi = New("ImageLabel", { Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop, Parent = ban })
        Corner(bi, 8)
        self:_ArtImage(art.banner, function(a) if bi.Parent then bi.Image = a end end)
    end
    local av = New("ImageLabel", { Size = UDim2.fromOffset(76, 76), Position = UDim2.fromOffset(24, 62), BackgroundTransparency = 0, ScaleType = Enum.ScaleType.Crop,
        ZIndex = 3, Theme = { BackgroundColor3 = "Field" }, Parent = card })
    Corner(av, 38) Stroke(av, "Card", 5, 0)
    if art.pfp then self:_ArtImage(art.pfp, function(a) if av.Parent then av.Image = a end end)
    else GetAvatar(LocalPlayer.UserId, function(a) if av.Parent then av.Image = a end end, "HeadShot", "Size150x150") end
    local nm = Lib:LoadChatName()
    if nm == "" then nm = LocalPlayer.DisplayName end
    New("TextLabel", { Text = nm, Font = Lib.FontBold, TextSize = 18, Size = UDim2.new(1, -130, 0, 22), Position = UDim2.fromOffset(112, 98), TextXAlignment = LEFT,
        TextTruncate = Enum.TextTruncate.AtEnd, Parent = card })
    New("TextLabel", { Text = "@" .. LocalPlayer.Name, TextSize = 12, Size = UDim2.new(1, -130, 0, 16), Position = UDim2.fromOffset(112, 121), TextXAlignment = LEFT,
        TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Dim" }, Parent = card })
    return card
end

function Chat:OpenSettings(page)
    if self._set and self._set.Parent then self._set:Destroy() end
    local chat = self
    -- lives in Lib.Gui at a very high ZIndex: above the window and above fullscreen chat, below menus / dialogs
    local root = Sink(New("Frame", { Name = "UserSettings", Size = UDim2.fromScale(1, 1), ZIndex = 500, Theme = { BackgroundColor3 = "Bg" }, Parent = Lib.Gui }))
    self._set = root
    local esc
    local function Close()
        if esc then esc:Disconnect() esc = nil end
        if root.Parent then root:Destroy() end
    end
    esc = UIS.InputBegan:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.Escape and not UIS:GetFocusedTextBox() then Close() end
    end)
    root.Destroying:Connect(function() if esc then esc:Disconnect() esc = nil end end)

    local vpx = Lib.Gui.AbsoluteSize.X
    local SW = vpx < 700 and 190 or 250
    local titles = { account = "My Account", profiles = "Profiles", notifs = "Notifications", appearance = "Appearance", privacy = "Privacy & Blocking" }
    local navDef = {
        { "account", "user", "My Account" }, { "profiles", "image", "Profiles" }, { "notifs", "bell", "Notifications" },
        { "appearance", "palette", "Appearance" }, { "privacy", "shield", "Privacy & Blocking" },
    }
    local cur, Show = nil, nil

    -- ---- sidebar ----
    local side = New("Frame", { Size = UDim2.new(0, SW, 1, 0), Theme = { BackgroundColor3 = "Surface" }, Parent = root })
    local sl = New("ScrollingFrame", { Size = UDim2.new(1, 0, 1, -64), AutomaticCanvasSize = Y, ScrollBarThickness = 0, Parent = side })
    List(sl, 2) Pad(sl, 12, 16, 12, 8)

    local headB = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, 54), LayoutOrder = 1, BackgroundTransparency = 1, Parent = sl })
    local hav = New("ImageLabel", { Size = UDim2.fromOffset(40, 40), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 4, 0.5, 0), BackgroundTransparency = 0,
        ScaleType = Enum.ScaleType.Crop, Theme = { BackgroundColor3 = "Field" }, Parent = headB })
    Corner(hav, 20)
    local art0 = Lib:LoadArt()
    if art0.pfp then self:_ArtImage(art0.pfp, function(a) if hav.Parent then hav.Image = a end end)
    else GetAvatar(LocalPlayer.UserId, function(a) if hav.Parent then hav.Image = a end end, "HeadShot", "Size150x150") end
    local hn = Lib:LoadChatName()
    if hn == "" then hn = LocalPlayer.DisplayName end
    New("TextLabel", { Text = hn, Font = Lib.FontBold, TextSize = 14, Size = UDim2.new(1, -56, 0, 18), Position = UDim2.fromOffset(54, 8), TextXAlignment = LEFT,
        TextTruncate = Enum.TextTruncate.AtEnd, Parent = headB })
    local ep = New("Frame", { Size = UDim2.new(1, -56, 0, 14), Position = UDim2.fromOffset(54, 28), BackgroundTransparency = 1, Parent = headB })
    Lib.Icon("pencil", 11, "Dim", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Parent = ep }, "e")
    New("TextLabel", { Text = "Edit Profiles", TextSize = 11, Size = UDim2.new(1, -14, 1, 0), Position = UDim2.fromOffset(14, 0), TextXAlignment = LEFT,
        Theme = { TextColor3 = "Dim" }, Parent = ep })
    headB.Activated:Connect(function() Show("profiles") end)

    New("TextLabel", { Text = "User Settings", Font = Lib.FontBold, TextSize = 11, Size = UDim2.new(1, 0, 0, 26), LayoutOrder = 2, TextXAlignment = LEFT,
        Theme = { TextColor3 = "Dim" }, Parent = sl })

    local navB = {}
    for i, def in ipairs(navDef) do
        local b = New("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, 36), LayoutOrder = 2 + i, BackgroundTransparency = 1, Theme = { BackgroundColor3 = "FieldHover" }, Parent = sl })
        Corner(b, 6)
        local ico = Lib.Icon(def[2], 16, "SubText", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0), Parent = b })
        local lbl = New("TextLabel", { Text = def[3], TextSize = 14, Size = UDim2.new(1, -40, 1, 0), Position = UDim2.fromOffset(36, 0), TextXAlignment = LEFT,
            TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = b })
        navB[def[1]] = { b = b, lbl = lbl, ico = ico }
        b.MouseEnter:Connect(function() if cur ~= def[1] then Tween(b, { BackgroundTransparency = 0.6 }, 0.06) end end)
        b.MouseLeave:Connect(function() if cur ~= def[1] then Tween(b, { BackgroundTransparency = 1 }, 0.08) end end)
        b.Activated:Connect(function() Show(def[1]) end)
    end
    local function StyleNav()
        for k, n in pairs(navB) do
            local on = k == cur
            n.b.BackgroundTransparency = on and 0.35 or 1
            n.lbl.TextColor3 = on and Lib.Theme.Text or Lib.Theme.SubText
            Tint(n.ico, on and Lib.Theme.Text or Lib.Theme.SubText, 0.05)
        end
    end

    local foot = New("Frame", { Size = UDim2.new(1, -24, 0, 52), AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 12, 1, -8), BackgroundTransparency = 1, Parent = side })
    List(foot, 6, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Bottom)
    local function FootBtn(text, order, fn)
        local b = New("TextButton", { Text = text, TextSize = 12, Size = UDim2.new(1, 0, 0, 24), LayoutOrder = order, BackgroundTransparency = 0,
            Theme = { BackgroundColor3 = "Field", TextColor3 = "SubText" }, Parent = foot })
        Corner(b, 5)
        b.Activated:Connect(fn)
    end
    FootBtn("Hub menu", 1, function()
        Close()
        if chat.Full then chat:SetFullscreen(false) end
        Lib:SetVisible(true)
        local w = Lib.MainWindow
        if w and w.Minimized then w:SetMinimized(false) end
    end)
    FootBtn("Close  (Esc)", 2, Close)

    -- ---- content ----
    local main = New("Frame", { Size = UDim2.new(1, -SW, 1, 0), Position = UDim2.fromOffset(SW, 0), BackgroundTransparency = 1, Parent = root })
    local titleL = New("TextLabel", { Text = "", Font = Lib.FontBold, TextSize = 16, Size = UDim2.new(1, -80, 0, 52), Position = UDim2.fromOffset(24, 0), TextXAlignment = LEFT, Parent = main })
    local x = IconButton(main, "x", "×", 32, "Close (Esc)", "Bad")
    x.Button.AnchorPoint, x.Button.Position = Vector2.new(1, 0.5), UDim2.new(1, -16, 0, 26)
    x.Button.Activated:Connect(Close)
    New("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromOffset(0, 52), BackgroundTransparency = 0.5, Theme = { BackgroundColor3 = "Stroke" }, Parent = main })
    local scroll = New("ScrollingFrame", { Size = UDim2.new(1, 0, 1, -53), Position = UDim2.fromOffset(0, 53), AutomaticCanvasSize = Y, ScrollBarThickness = 3, Parent = main })
    Pad(scroll, 24, 24, 24, 48)
    local stack = New("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Y, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, 0), BackgroundTransparency = 1, Parent = scroll })
    List(stack, 12)
    New("UISizeConstraint", { MaxSize = Vector2.new(680, 1e6), Parent = stack })

    -- ---- builders ----
    local order = 0
    local function O() order = order + 1 return order end
    local function Heading(t)
        New("TextLabel", { Text = t, Font = Lib.FontBold, TextSize = 22, Size = UDim2.new(1, 0, 0, 30), TextXAlignment = LEFT, LayoutOrder = O(), Parent = stack })
    end
    local function Note(t)
        local l = New("TextLabel", { Text = t, TextSize = 12, Size = UDim2.new(1, 0, 0, 16), TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top,
            LayoutOrder = O(), Theme = { TextColor3 = "Dim" }, Parent = stack })
        Wrap(l, nil, nil, 16)
    end
    local function Card()
        local c = New("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Y, LayoutOrder = O(), Theme = { BackgroundColor3 = "Card" }, Parent = stack })
        Corner(c, 8) Stroke(c, "Stroke", 1, 0.4) Pad(c, 16, 2, 16, 2) List(c, 0)
        return c
    end
    local function Right(parent)
        local f = New("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(0, 32), AutomaticSize = X, BackgroundTransparency = 1, Parent = parent })
        List(f, 6, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
        return f
    end
    local function Line(card, label, desc, build)
        local r = New("Frame", { Size = UDim2.new(1, 0, 0, desc and 56 or 46), BackgroundTransparency = 1, LayoutOrder = O(), Parent = card })
        New("TextLabel", { Text = label, TextSize = 14, Size = UDim2.new(1, -210, 0, 18), Position = UDim2.fromOffset(0, desc and 10 or 14), TextXAlignment = LEFT,
            TextTruncate = Enum.TextTruncate.AtEnd, Parent = r })
        if desc then
            New("TextLabel", { Text = desc, TextSize = 11, Size = UDim2.new(1, -210, 0, 14), Position = UDim2.fromOffset(0, 30), TextXAlignment = LEFT,
                TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Dim" }, Parent = r })
        end
        New("Frame", { Size = UDim2.new(1, 0, 0, 1), AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), BackgroundTransparency = 0.6,
            Theme = { BackgroundColor3 = "Stroke" }, Parent = r })
        build(Right(r))
    end
    local function Btn(parent, text, fn, o)
        o = o or {}
        local b = New("TextButton", { Text = text, TextSize = 12, AutomaticSize = X, Size = UDim2.fromOffset(0, 28), BackgroundTransparency = 0,
            Theme = { BackgroundColor3 = o.primary and "Accent" or "FieldHover", TextColor3 = o.primary and "OnAccent" or (o.danger and "Bad" or "Text") }, Parent = parent })
        Corner(b, 5) Pad(b, 12, 0, 12, 0)
        b.Activated:Connect(function() fn(b) end)
        return b
    end
    local function Val(parent, text)
        New("TextLabel", { Text = tostring(text), TextSize = 13, AutomaticSize = X, Size = UDim2.fromOffset(0, 28), Theme = { TextColor3 = "SubText" }, Parent = parent })
    end
    local function Toggle(parent, get, set)
        local on = get() and true or false
        local b = New("TextButton", { Text = "", Size = UDim2.fromOffset(42, 24), BackgroundTransparency = 0, BackgroundColor3 = on and Lib.Theme.Accent or Lib.Theme.Stroke, Parent = parent })
        Corner(b, 12)
        local k = New("Frame", { Size = UDim2.fromOffset(18, 18), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, on and 21 or 3, 0.5, 0), BackgroundColor3 = WHITE, Parent = b })
        Corner(k, 9)
        b.Activated:Connect(function()
            on = not on
            Tween(b, { BackgroundColor3 = on and Lib.Theme.Accent or Lib.Theme.Stroke }, 0.12)
            Tween(k, { Position = UDim2.new(0, on and 21 or 3, 0.5, 0) }, 0.14)
            set(on)
        end)
    end
    local function Seg(parent, values, getv, setv)
        local f = New("Frame", { Size = UDim2.fromOffset(#values * 86, 28), BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Field" }, Parent = parent })
        Corner(f, 6)
        local btns = {}
        local function Paint()
            for v, b in pairs(btns) do
                local on = v == getv()
                b.BackgroundColor3 = on and Lib.Theme.Accent or Lib.Theme.Field
                b.TextColor3 = on and Lib.KnobOn() or Lib.Theme.SubText
            end
        end
        for i, v in ipairs(values) do
            local b = New("TextButton", { Text = v, TextSize = 12, Size = UDim2.new(1 / #values, -4, 1, -4), Position = UDim2.new((i - 1) / #values, 2, 0, 2), BackgroundTransparency = 0, Parent = f })
            Corner(b, 5)
            btns[v] = b
            b.Activated:Connect(function() setv(v) Paint() end)
        end
        Paint()
    end
    local function Sync(idx, v) local t = Lib.Toggles[idx] if t then t:SetValue(v, true) end end

    local pages = {}

    pages.account = function()
        Heading("My Account")
        chat:_ProfilePreview(stack, O())
        local c = Card()
        local nm = Lib:LoadChatName()
        Line(c, "Chat display name", nm ~= "" and nm or LocalPlayer.DisplayName, function(R)
            Btn(R, "Edit", function()
                Lib:Prompt({ Title = "Chat display name", Text = "Shown on your chat messages. Leave empty to use your Roblox display name.", Default = nm,
                    Placeholder = LocalPlayer.DisplayName, Confirm = "Save" }, function(t)
                    Lib:SetChatName(t)
                    pcall(function() local o = Lib.Options.__ChatName if o then o:SetValue(t, true) end end)
                    task.delay(1.2, function() if root.Parent and cur == "account" then Show("account") end end)
                end)
            end)
        end)
        local bio = Lib:LoadBio()
        Line(c, "Bio", bio ~= "" and bio or "No bio yet", function(R)
            Btn(R, "Edit", function()
                Lib:Prompt({ Title = "Bio", Text = "Shown on your profile card (up to 120 characters).", Default = bio, Placeholder = "About me", Confirm = "Save" }, function(t)
                    Lib:SetBio(t)
                    pcall(function() local o = Lib.Options.__ChatBio if o then o:SetValue(t, true) end end)
                    if root.Parent and cur == "account" then Show("account") end
                end)
            end)
        end)
        Line(c, "Username", nil, function(R) Val(R, "@" .. LocalPlayer.Name) end)
        Line(c, "User ID", nil, function(R) Val(R, LocalPlayer.UserId) Btn(R, "Copy", function() Copy(tostring(LocalPlayer.UserId), "User ID") end) end)
        Line(c, "Account age", nil, function(R) Val(R, LocalPlayer.AccountAge .. " days") end)
        Line(c, "Membership", nil, function(R) Val(R, LocalPlayer.MembershipType.Name) end)
    end

    pages.profiles = function()
        Heading("Profiles")
        Note("Your profile picture is your Roblox avatar by default. Replace it, or the banner, with any picture.")
        chat:_ProfilePreview(stack, O())
        local c = Card()
        local art = Lib:LoadArt()
        local function Redo() if root.Parent and cur == "profiles" then Show("profiles") end end
        Line(c, "Profile picture", art.pfp and "Custom picture" or "Using your Roblox avatar", function(R)
            Btn(R, "Change", function(b) chat:ChooseArt("pfp", b, Redo) end, { primary = true })
            if art.pfp then Btn(R, "Remove", function() Lib:SetArt("pfp", nil) Redo() end, { danger = true }) end
        end)
        Line(c, "Banner", art.banner and "Custom banner" or "Using your accent color", function(R)
            Btn(R, "Change", function(b) chat:ChooseArt("banner", b, Redo) end, { primary = true })
            if art.banner then Btn(R, "Remove", function() Lib:SetArt("banner", nil) Redo() end, { danger = true }) end
        end)
        Note("Pictures are saved on this device. Other people only see them if your chat server stores profile art.")
    end

    pages.notifs = function()
        Heading("Notifications")
        local c = Card()
        local prefs, ex = Lib:LoadChatPrefs(), Lib:LoadExtras()
        Line(c, "Popup notifications", "Mentions, friend requests and announcements", function(R)
            Toggle(R, function() return Lib.NotifyEnabled ~= false end, function(v) Lib.NotifyEnabled = v Sync("NotifyOn", v) end)
        end)
        Line(c, "Read receipts (DMs)", "Show Read under your last DM, and let them see yours", function(R)
            Toggle(R, function() return prefs.ReadReceipts end, function(v)
                prefs.ReadReceipts = v Lib:SaveChatPrefs() Sync("ReadReceipts", v)
                if not v then chat.ReadMark = nil end
                pcall(function() chat:_PlaceRead() end)
            end)
        end)
        Line(c, "Presence cards", "Show what game a friend is in, with a Join button", function(R)
            Toggle(R, function() return ex.presence end, function(v)
                ex.presence = v Lib:SaveExtras() Sync("PresenceCards", v)
                pcall(function() chat:_UpdatePresence(true) end)
                chat:_QueueSidebar()
            end)
        end)
        Note("To mute a single chat: open its menu (the chevron in the chat header) > Notification Settings, or type /mute in a DM or group.")
    end

    pages.appearance = function()
        Heading("Appearance")
        local c = Card()
        local sk, S = Lib:LoadSkin(), Lib:LoadChatState()
        Line(c, "Message style", nil, function(R)
            Seg(R, { "Discord", "Bubbles" }, function() return sk.MsgStyle end, function(v)
                sk.MsgStyle = v Lib:SaveSkin() Sync("ChatMsgStyle", v)
                pcall(function() chat:_ReloadMessages() end)
            end)
        end)
        Line(c, "Chat layout", nil, function(R)
            Seg(R, { "Discord", "Compact" }, function() return S.layout end, function(v)
                S.layout = v Lib:SaveChatState() Sync("ChatLayout", v)
                pcall(function() chat:_ApplyLayout() end)
            end)
        end)
        Line(c, "Keep chat open when the menu closes", nil, function(R)
            Toggle(R, function() return sk.Independent end, function(v) sk.Independent = v Lib:SaveSkin() Sync("ChatIndependent", v) Lib:SetVisible(Lib.Visible) end)
        end)
        Line(c, "Link previews", nil, function(R)
            Toggle(R, function() return Lib.LinkPreviews ~= false end, function(v) Lib.LinkPreviews = v Sync("LinkPreviews", v) end)
        end)
        Line(c, "Load images automatically", nil, function(R)
            Toggle(R, function() return Lib.ShowImages ~= false end, function(v) Lib.ShowImages = v Sync("AutoImages", v) end)
        end)
        Note("Colors, fonts, backgrounds and UI size are in the hub menu (Settings tab).")
    end

    pages.privacy = function()
        Heading("Privacy & Blocking")
        local c = Card()
        Line(c, "Share my game in chat", "Lets people see your game and join your server", function(R)
            Toggle(R, function() return Lib.ShareServer ~= false end, function(v) Lib.ShareServer = v Sync("ShareServer", v) end)
        end)
        New("TextLabel", { Text = "Blocked users", Font = Lib.FontBold, TextSize = 16, Size = UDim2.new(1, 0, 0, 24), TextXAlignment = LEFT, LayoutOrder = O(), Parent = stack })
        local names = {}
        for uid, nm in pairs(Lib.BlockList) do names[#names + 1] = { uid = uid, name = tostring(nm) } end
        table.sort(names, function(a, b) return a.name:lower() < b.name:lower() end)
        if #names == 0 then
            Note("Nobody is blocked.")
            return
        end
        local bc = Card()
        for _, e in ipairs(names) do
            Line(bc, e.name, "User ID " .. e.uid, function(R)
                Btn(R, "Unblock", function()
                    Lib:Unblock(e.uid)
                    if root.Parent and cur == "privacy" then Show("privacy") end
                end)
            end)
        end
    end

    Show = function(key)
        if not pages[key] then key = "account" end
        local same = key == cur
        local y = scroll.CanvasPosition
        cur = key
        for _, c in ipairs(stack:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UISizeConstraint") then c:Destroy() end
        end
        order = 0
        titleL.Text = titles[key]
        StyleNav()
        local ok, err = pcall(pages[key])
        if not ok then warn("[Aether] settings page: " .. tostring(err)) end
        task.defer(function() if scroll.Parent then scroll.CanvasPosition = same and y or Vector2.zero end end)
    end
    Show(page or "account")
end

-- ==================== 6) wire it in ====================
function Chat:_InitSettings()
    local u = self._up
    if not (u and u.name.Parent) then return end
    local up = u.name.Parent
    -- replace the old gear (it opened the hub menu, which is hidden behind fullscreen chat)
    for _, c in ipairs(up:GetChildren()) do
        if c:IsA("TextButton") and c.AnchorPoint == Vector2.new(1, 0.5) then c:Destroy() end
    end
    local gear = IconButton(up, "settings", "*", H(24), "User Settings", "Accent", 1)
    gear.Button.AnchorPoint, gear.Button.Position, gear.Button.ZIndex = Vector2.new(1, 0.5), UDim2.new(1, -4, 0.5, 0), 3
    gear.Button.Activated:Connect(function() self:OpenSettings() end)
    self:_UpdateUserPanel()
end

P.PopMenu = Chat._PopMenu
function Chat:_PopMenu(spec, anchor)
    if anchor ~= nil and anchor == self.ChBtn and spec.Name ~= "Notifications" and spec.Sections and spec.Sections[2] then
        table.insert(spec.Sections[2], { Text = "User Settings", Icon = "settings", Cb = function() self:OpenSettings() end })
    end
    return P.PopMenu(self, spec, anchor)
end

P.CreateChat = Lib.CreateChat
function Lib:CreateChat(cfg)
    local chat = P.CreateChat(self, cfg)
    if chat and not chat._p63 then
        chat._p63 = true
        Lib:LoadArt()
        local ok, err = pcall(function() chat:_InitSettings() end)
        if not ok then warn("[Aether] user settings: " .. tostring(err)) end
    end
    return chat
end

end
-- ===================== end patch 6.3 =====================


return Lib
