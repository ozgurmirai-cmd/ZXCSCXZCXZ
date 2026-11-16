-- Admin Panel v2.0 — Xeno Optimized
-- [9] tuşu → panel aç/kapat
-- Tabs: Move | Combat | Visual | Troll | Misc

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI PARENT
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AP_"..tostring(math.random(1000,9999))
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local ok = pcall(function()
    if gethui then ScreenGui.Parent = gethui()
    else ScreenGui.Parent = lp:WaitForChild("PlayerGui") end
end)
if not ok then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,440,0,520)
MainFrame.Position = UDim2.new(0.5,-220,0.5,-260)
MainFrame.BackgroundColor3 = Color3.fromRGB(18,18,28)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)

-- TITLE BAR
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,38)
TitleBar.BackgroundColor3 = Color3.fromRGB(28,28,50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,10)
local titleFix = Instance.new("Frame") -- alt köşe fix
titleFix.Size = UDim2.new(1,0,0,10); titleFix.Position = UDim2.new(0,0,1,-10)
titleFix.BackgroundColor3 = Color3.fromRGB(28,28,50); titleFix.BorderSizePixel = 0; titleFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "⚡ Admin Panel  v2.0"
TitleLabel.Size = UDim2.new(1,-110,1,0); TitleLabel.Position = UDim2.new(0,12,0,0)
TitleLabel.BackgroundTransparency = 1; TitleLabel.TextColor3 = Color3.fromRGB(180,180,255)
TitleLabel.Font = Enum.Font.GothamBold; TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left; TitleLabel.Parent = TitleBar

local KeyHint = Instance.new("TextLabel")
KeyHint.Text = "[9] aç/kapat"
KeyHint.Size = UDim2.new(0,80,1,0); KeyHint.Position = UDim2.new(0.5,-40,0,0)
KeyHint.BackgroundTransparency = 1; KeyHint.TextColor3 = Color3.fromRGB(90,90,140)
KeyHint.Font = Enum.Font.Gotham; KeyHint.TextSize = 10; KeyHint.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"; CloseBtn.Size = UDim2.new(0,28,0,28); CloseBtn.Position = UDim2.new(1,-32,0,5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,50,50); CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 12; CloseBtn.BorderSizePixel = 0; CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MinBtn = Instance.new("TextButton")
MinBtn.Text = "−"; MinBtn.Size = UDim2.new(0,28,0,28); MinBtn.Position = UDim2.new(1,-64,0,5)
MinBtn.BackgroundColor3 = Color3.fromRGB(50,50,80); MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 14; MinBtn.BorderSizePixel = 0; MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame.Size = minimized and UDim2.new(0,440,0,38) or UDim2.new(0,440,0,520)
end)

-- [9] TOGGLE
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Nine then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- DRAG
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)

-- TAB SYSTEM (5 tab = %20 genişlik)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,0,0,36); TabBar.Position = UDim2.new(0,0,0,38)
TabBar.BackgroundColor3 = Color3.fromRGB(13,13,22); TabBar.BorderSizePixel = 0; TabBar.Parent = MainFrame
local tbl = Instance.new("UIListLayout"); tbl.FillDirection = Enum.FillDirection.Horizontal; tbl.Parent = TabBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,0,1,-74); ContentFrame.Position = UDim2.new(0,0,0,74)
ContentFrame.BackgroundTransparency = 1; ContentFrame.Parent = MainFrame

local tabs = {}
local function createTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Text = name; btn.Size = UDim2.new(0.2,0,1,0)
    btn.BackgroundColor3 = Color3.fromRGB(18,18,30); btn.TextColor3 = Color3.fromRGB(120,120,160)
    btn.Font = Enum.Font.Gotham; btn.TextSize = 10; btn.BorderSizePixel = 0
    btn.LayoutOrder = order; btn.Parent = TabBar

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1,0,1,0); page.BackgroundTransparency = 1
    page.BorderSizePixel = 0; page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(80,80,140); page.Visible = false; page.Parent = ContentFrame

    local pl = Instance.new("UIListLayout"); pl.SortOrder = Enum.SortOrder.LayoutOrder
    pl.Padding = UDim.new(0,5); pl.Parent = page
    local pp = Instance.new("UIPadding"); pp.PaddingLeft = UDim.new(0,10)
    pp.PaddingRight = UDim.new(0,10); pp.PaddingTop = UDim.new(0,8); pp.Parent = page

    pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0,pl.AbsoluteContentSize.Y+16)
    end)
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.page.Visible = false; t.btn.BackgroundColor3 = Color3.fromRGB(18,18,30)
            t.btn.TextColor3 = Color3.fromRGB(120,120,160)
        end
        page.Visible = true; btn.BackgroundColor3 = Color3.fromRGB(38,38,65)
        btn.TextColor3 = Color3.fromRGB(180,180,255)
    end)
    table.insert(tabs, {btn=btn, page=page}); return page
end

-- HELPER: Toggle
local function createToggle(parent, label, order, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-20,0,36); frame.BackgroundColor3 = Color3.fromRGB(26,26,42)
    frame.BorderSizePixel = 0; frame.LayoutOrder = order; frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)
    local lbl = Instance.new("TextLabel"); lbl.Text = label; lbl.Size = UDim2.new(1,-60,1,0)
    lbl.Position = UDim2.new(0,10,0,0); lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(200,200,220); lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame
    local togBtn = Instance.new("TextButton")
    togBtn.Size = UDim2.new(0,42,0,20); togBtn.Position = UDim2.new(1,-52,0.5,-10)
    togBtn.BackgroundColor3 = Color3.fromRGB(45,45,75); togBtn.Text = "OFF"
    togBtn.TextColor3 = Color3.fromRGB(130,130,160); togBtn.Font = Enum.Font.GothamBold
    togBtn.TextSize = 10; togBtn.BorderSizePixel = 0; togBtn.Parent = frame
    Instance.new("UICorner", togBtn).CornerRadius = UDim.new(0,10)
    local state = false
    togBtn.MouseButton1Click:Connect(function()
        state = not state
        togBtn.BackgroundColor3 = state and Color3.fromRGB(70,70,190) or Color3.fromRGB(45,45,75)
        togBtn.Text = state and "ON" or "OFF"
        togBtn.TextColor3 = state and Color3.fromRGB(190,190,255) or Color3.fromRGB(130,130,160)
        pcall(callback, state)
    end)
end

-- HELPER: Button
local function createButton(parent, label, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,32); btn.BackgroundColor3 = Color3.fromRGB(55,55,110)
    btn.TextColor3 = Color3.fromRGB(200,200,255); btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11; btn.BorderSizePixel = 0; btn.LayoutOrder = order
    btn.Text = label; btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(90,90,180)
        task.delay(0.15, function() btn.BackgroundColor3 = Color3.fromRGB(55,55,110) end)
        pcall(callback)
    end)
end

-- HELPER: Input + Button row
local function createInputRow(parent, placeholder, order, btnLabel, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-20,0,36); frame.BackgroundColor3 = Color3.fromRGB(26,26,42)
    frame.BorderSizePixel = 0; frame.LayoutOrder = order; frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)
    local input = Instance.new("TextBox"); input.PlaceholderText = placeholder
    input.Size = UDim2.new(0.6,0,0.75,0); input.Position = UDim2.new(0,8,0.125,0)
    input.BackgroundColor3 = Color3.fromRGB(38,38,58); input.TextColor3 = Color3.fromRGB(220,220,240)
    input.PlaceholderColor3 = Color3.fromRGB(90,90,120); input.Font = Enum.Font.Gotham
    input.TextSize = 11; input.BorderSizePixel = 0; input.ClearTextOnFocus = false; input.Parent = frame
    Instance.new("UICorner", input).CornerRadius = UDim.new(0,4)
    local btn = Instance.new("TextButton"); btn.Text = btnLabel
    btn.Size = UDim2.new(0.3,0,0.75,0); btn.Position = UDim2.new(0.65,0,0.125,0)
    btn.BackgroundColor3 = Color3.fromRGB(55,55,110); btn.TextColor3 = Color3.fromRGB(200,200,255)
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.BorderSizePixel = 0; btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    btn.MouseButton1Click:Connect(function() pcall(callback, input.Text) end)
    return input
end

-- HELPER: Slider
local function createSlider(parent, label, order, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-20,0,52); frame.BackgroundColor3 = Color3.fromRGB(26,26,42)
    frame.BorderSizePixel = 0; frame.LayoutOrder = order; frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)
    local lbl = Instance.new("TextLabel"); lbl.Text = label..": "..tostring(default)
    lbl.Size = UDim2.new(1,-10,0,20); lbl.Position = UDim2.new(0,10,0,4); lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(200,200,220); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame
    local track = Instance.new("Frame"); track.Size = UDim2.new(1,-20,0,6); track.Position = UDim2.new(0,10,0,32)
    track.BackgroundColor3 = Color3.fromRGB(45,45,75); track.BorderSizePixel = 0; track.Parent = frame
    Instance.new("UICorner", track).CornerRadius = UDim.new(0,3)
    local fill = Instance.new("Frame"); fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(80,80,200); fill.BorderSizePixel = 0; fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,3)
    local knob = Instance.new("TextButton"); knob.Size = UDim2.new(0,14,0,14)
    knob.Position = UDim2.new((default-min)/(max-min),-7,0.5,-7)
    knob.BackgroundColor3 = Color3.fromRGB(150,150,255); knob.Text = ""; knob.BorderSizePixel = 0; knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0,7)
    local sliding = false
    knob.MouseButton1Down:Connect(function() sliding = true end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
            local val = math.floor(min+(max-min)*rel)
            fill.Size = UDim2.new(rel,0,1,0); knob.Position = UDim2.new(rel,-7,0.5,-7)
            lbl.Text = label..": "..tostring(val); pcall(callback,val)
        end
    end)
end

-- HELPER: Section
local function createSection(parent, text, order)
    local lbl = Instance.new("TextLabel"); lbl.Text = " "..text; lbl.Size = UDim2.new(1,-20,0,22)
    lbl.BackgroundColor3 = Color3.fromRGB(38,38,62); lbl.TextColor3 = Color3.fromRGB(110,110,190)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BorderSizePixel = 0; lbl.LayoutOrder = order; lbl.Parent = parent
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0,4)
end

-- ===== TABS =====
local movePage   = createTab("Move",   1)
local combatPage = createTab("Combat", 2)
local visualPage = createTab("Visual", 3)
local trollPage  = createTab("Troll",  4)
local miscPage   = createTab("Misc",   5)

tabs[1].page.Visible = true
tabs[1].btn.BackgroundColor3 = Color3.fromRGB(38,38,65)
tabs[1].btn.TextColor3 = Color3.fromRGB(180,180,255)

-- UTILITY
local function getNearestPlayerHRP()
    local c = lp.Character; local mhrp = c and c:FindFirstChild("HumanoidRootPart"); if not mhrp then return nil end
    local nearest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local th = plr.Character:FindFirstChild("HumanoidRootPart")
            local th2 = plr.Character:FindFirstChildOfClass("Humanoid")
            if th and th2 and th2.Health > 0 then
                local d = (mhrp.Position-th.Position).Magnitude
                if d < dist then dist = d; nearest = th end
            end
        end
    end
    return nearest
end

-- ========== MOVEMENT ==========
createSection(movePage, "MOVEMENT", 1)
local flyActive = false; local flySpeed = 60; local flyConn
createToggle(movePage, "Fly  [WASD + Space/Shift]", 2, function(state)
    flyActive = state; char = lp.Character
    hrp = char and char:FindFirstChild("HumanoidRootPart")
    hum = char and char:FindFirstChildOfClass("Humanoid")
    if state and hrp and hum then
        hum:ChangeState(Enum.HumanoidStateType.Physics)
        local bv = Instance.new("BodyVelocity"); bv.MaxForce = Vector3.new(9999,9999,9999)
        bv.Velocity = Vector3.zero; bv.Name = "FlyVel"; bv.Parent = hrp
        local bg = Instance.new("BodyGyro"); bg.MaxTorque = Vector3.new(9999,9999,9999)
        bg.P = 5000; bg.D = 100; bg.Name = "FlyGyro"; bg.Parent = hrp
        flyConn = RunService.RenderStepped:Connect(function()
            if not flyActive or not hrp or not hrp.Parent then return end
            pcall(function()
                local cam = workspace.CurrentCamera; local mv = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv += cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv -= cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv -= cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv += cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space)     then mv += Vector3.yAxis end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then mv -= Vector3.yAxis end
                bv.Velocity = mv * flySpeed; bg.CFrame = cam.CFrame
            end)
        end)
    else
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        pcall(function()
            if hrp then
                local bv = hrp:FindFirstChild("FlyVel"); if bv then bv:Destroy() end
                local bg = hrp:FindFirstChild("FlyGyro"); if bg then bg:Destroy() end
            end
            if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        end)
    end
end)
createSlider(movePage, "Fly Speed", 3, 10, 400, 60, function(v) flySpeed = v end)

local infJumpConn
createToggle(movePage, "Infinite Jump", 4, function(state)
    if state then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            pcall(function()
                local c = lp.Character; local h = c and c:FindFirstChildOfClass("Humanoid")
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end)
    else if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end end
end)

local noclipConn
createToggle(movePage, "Noclip", 5, function(state)
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            pcall(function()
                local c = lp.Character; if not c then return end
                for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
            end)
        end)
    else
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        pcall(function()
            local c = lp.Character; if c then
                for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
            end
        end)
    end
end)
createSection(movePage, "SPEED", 6)
createSlider(movePage, "WalkSpeed", 7, 16, 500, 16, function(v)
    pcall(function() local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = v end end)
end)
createSlider(movePage, "JumpPower", 8, 50, 500, 50, function(v)
    pcall(function() local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h.JumpPower = v end end)
end)

-- ========== COMBAT ==========
createSection(combatPage, "KILL AURA", 1)
local kaActive = false; local kaRange = 15; local kaConn
createToggle(combatPage, "Kill Aura", 2, function(state)
    kaActive = state
    if state then
        kaConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local c = lp.Character; local mhr = c and c:FindFirstChild("HumanoidRootPart"); if not mhr then return end
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= lp and plr.Character then
                        local th = plr.Character:FindFirstChild("HumanoidRootPart")
                        local th2 = plr.Character:FindFirstChildOfClass("Humanoid")
                        if th and th2 and th2.Health > 0 and (mhr.Position-th.Position).Magnitude <= kaRange then
                            th2:TakeDamage(math.huge)
                        end
                    end
                end
            end)
        end)
    else if kaConn then kaConn:Disconnect(); kaConn = nil end end
end)
createSlider(combatPage, "KA Range", 3, 5, 150, 15, function(v) kaRange = v end)

-- SILENT AIM — mouse.Hit / mouse.Target hook
createSection(combatPage, "SILENT AIM", 4)
local silentAimActive = false
local function setupSilentAim()
    local ok2, mt = pcall(getrawmetatable, game)
    if not ok2 or not mt then return false end
    local ok3 = pcall(setreadonly, mt, false)
    if not ok3 then return false end
    local oldIndex = mt.__index
    mt.__index = newcclosure(function(self, key)
        if silentAimActive and self == lp:GetMouse() then
            local target = getNearestPlayerHRP()
            if target then
                if key == "Hit"    then return target.CFrame end
                if key == "Target" then return target end
            end
        end
        return oldIndex(self, key)
    end)
    pcall(setreadonly, mt, true)
    return true
end
local saReady = false
createToggle(combatPage, "Silent Aim (en yakın hedef)", 5, function(state)
    if state and not saReady then saReady = setupSilentAim() end
    silentAimActive = state
end)

-- KILL
createSection(combatPage, "KILL", 6)
createButton(combatPage, "Kill All", 7, function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if h then pcall(function() h:TakeDamage(math.huge) end) end
        end
    end
end)
createInputRow(combatPage, "Oyuncu adı...", 8, "Kill", function(name)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Name:lower():find(name:lower()) and plr.Character then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if h then pcall(function() h:TakeDamage(math.huge) end) end
        end
    end
end)

-- ========== VISUAL ==========
createSection(visualPage, "ESP", 1)
local espBoxes = {}; local espActive = false; local espConn
local function clearESP()
    for _, b in pairs(espBoxes) do pcall(function() b:Destroy() end) end; espBoxes = {}
end
local function makeESPLabel(character, player)
    local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if not root then return end
    local existing = root:FindFirstChild("ESPTag"); if existing then existing:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0,80,0,22); bb.StudsOffset = Vector3.new(0,3,0)
    bb.AlwaysOnTop = true; bb.Adornee = root; bb.Parent = root; bb.Name = "ESPTag"
    local lbl2 = Instance.new("TextLabel"); lbl2.Size = UDim2.new(1,0,1,0); lbl2.BackgroundTransparency = 1
    lbl2.TextColor3 = Color3.fromRGB(255,80,80); lbl2.Text = player.Name
    lbl2.Font = Enum.Font.GothamBold; lbl2.TextSize = 12; lbl2.Parent = bb
    table.insert(espBoxes, bb)
end
createToggle(visualPage, "Player ESP", 2, function(state)
    espActive = state
    if not state then if espConn then espConn:Disconnect(); espConn = nil end; clearESP(); return end
    espConn = RunService.Heartbeat:Connect(function()
        if not espActive then return end; clearESP()
        pcall(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= lp and plr.Character then makeESPLabel(plr.Character, plr) end
            end
        end)
    end)
end)
createToggle(visualPage, "Chams", 3, function(state)
    pcall(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp and plr.Character then
                for _, part in ipairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if state then
                            local h2 = Instance.new("SelectionBox"); h2.Adornee = part
                            h2.Color3 = Color3.fromRGB(255,100,0); h2.SurfaceTransparency = 0.5
                            h2.SurfaceColor3 = Color3.fromRGB(255,100,0); h2.Name = "Cham"; h2.Parent = part
                        else local ch = part:FindFirstChild("Cham"); if ch then ch:Destroy() end end
                    end
                end
            end
        end
    end)
end)
createToggle(visualPage, "Fullbright", 4, function(state)
    pcall(function()
        local L = game:GetService("Lighting")
        L.Brightness = state and 10 or 1; L.GlobalShadows = not state; L.FogEnd = state and 1e6 or 1e4
    end)
end)

createSection(visualPage, "INVISIBILITY", 5)
local invConn
createToggle(visualPage, "Görünmezlik", 6, function(state)
    if invConn then invConn:Disconnect(); invConn = nil end
    if state then
        invConn = RunService.RenderStepped:Connect(function()
            pcall(function()
                local c = lp.Character; if not c then return end
                for _, part in ipairs(c:GetDescendants()) do
                    if part:IsA("BasePart") then part.LocalTransparencyModifier = 1 end
                end
            end)
        end)
    else
        pcall(function()
            local c = lp.Character; if not c then return end
            for _, part in ipairs(c:GetDescendants()) do
                if part:IsA("BasePart") then part.LocalTransparencyModifier = 0 end
            end
        end)
    end
end)

-- ========== TROLL ==========
createSection(trollPage, "PULL / FLING", 1)
createInputRow(trollPage, "Oyuncu adı...", 2, "Çek", function(name)
    pcall(function()
        local c = lp.Character; local mhrp = c and c:FindFirstChild("HumanoidRootPart"); if not mhrp then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp and plr.Name:lower():find(name:lower()) and plr.Character then
                local th = plr.Character:FindFirstChild("HumanoidRootPart")
                if th then th.CFrame = mhrp.CFrame + Vector3.new(2,0,0) end
            end
        end
    end)
end)
createInputRow(trollPage, "Oyuncu adı...", 3, "Fling", function(name)
    pcall(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp and plr.Name:lower():find(name:lower()) and plr.Character then
                local th = plr.Character:FindFirstChild("HumanoidRootPart")
                if th then
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                    bv.Velocity = Vector3.new(math.random(-800,800),1500,math.random(-800,800))
                    bv.Parent = th; game:GetService("Debris"):AddItem(bv, 0.08)
                end
            end
        end
    end)
end)
createButton(trollPage, "Fling All", 4, function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local th = plr.Character:FindFirstChild("HumanoidRootPart")
            if th then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                bv.Velocity = Vector3.new(math.random(-800,800),1500,math.random(-800,800))
                bv.Parent = th; game:GetService("Debris"):AddItem(bv,0.08)
            end
        end
    end
end)

createSection(trollPage, "HARİTA", 5)
createToggle(trollPage, "Haritayı Kırmızı Yap", 6, function(state)
    pcall(function()
        local L = game:GetService("Lighting")
        if state then
            local cc = Instance.new("ColorCorrectionEffect"); cc.Name = "RedTroll"
            cc.TintColor = Color3.fromRGB(255,30,30); cc.Saturation = 1; cc.Contrast = 0.3; cc.Parent = L
            L.Ambient = Color3.fromRGB(255,0,0); L.OutdoorAmbient = Color3.fromRGB(180,0,0)
            L.FogColor = Color3.fromRGB(200,0,0); L.FogEnd = 150
        else
            local cc = L:FindFirstChild("RedTroll"); if cc then cc:Destroy() end
            L.Ambient = Color3.fromRGB(127,127,127); L.OutdoorAmbient = Color3.fromRGB(127,127,127); L.FogEnd = 100000
        end
    end)
end)
createToggle(trollPage, "Anti Gravity", 7, function(state)
    pcall(function() workspace.Gravity = state and 5 or 196.2 end)
end)
createToggle(trollPage, "Freeze All (Dondur)", 8, function(state)
    pcall(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp and plr.Character then
                local th = plr.Character:FindFirstChild("HumanoidRootPart")
                local h2 = plr.Character:FindFirstChildOfClass("Humanoid")
                if th then th.Anchored = state end
                if h2 then h2.WalkSpeed = state and 0 or 16 end
            end
        end
    end)
end)
createButton(trollPage, "Herkesi Karanlığa Al", 9, function()
    pcall(function()
        local L = game:GetService("Lighting")
        L.Brightness = 0; L.ClockTime = 0; L.GlobalShadows = true
        L.FogEnd = 20; L.FogColor = Color3.new(0,0,0)
        L.Ambient = Color3.new(0,0,0); L.OutdoorAmbient = Color3.new(0,0,0)
    end)
end)

createSection(trollPage, "EFEKTLER", 10)
createButton(trollPage, "💥 Boomer Ses", 11, function()
    pcall(function()
        local s = Instance.new("Sound"); s.SoundId = "rbxassetid://9120322378"
        s.Volume = 10; s.RollOffMaxDistance = 999999; s.Parent = workspace
        s:Play(); game:GetService("Debris"):AddItem(s, 15)
    end)
end)
createButton(trollPage, "Sahte Error Mesajı", 12, function()
    pcall(function()
        local sg = Instance.new("ScreenGui"); sg.Name = "FakeErr"; sg.ResetOnSpawn = false
        sg.Parent = lp:WaitForChild("PlayerGui")
        local frame = Instance.new("Frame"); frame.Size = UDim2.new(0,380,0,160)
        frame.Position = UDim2.new(0.5,-190,0.5,-80); frame.BackgroundColor3 = Color3.fromRGB(240,240,240)
        frame.BorderSizePixel = 0; frame.Parent = sg
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)
        local tb2 = Instance.new("Frame"); tb2.Size = UDim2.new(1,0,0,30)
        tb2.BackgroundColor3 = Color3.fromRGB(0,120,215); tb2.BorderSizePixel = 0; tb2.Parent = frame
        Instance.new("UICorner", tb2).CornerRadius = UDim.new(0,8)
        local fix2 = Instance.new("Frame"); fix2.Size = UDim2.new(1,0,0,8); fix2.Position = UDim2.new(0,0,1,-8)
        fix2.BackgroundColor3 = Color3.fromRGB(0,120,215); fix2.BorderSizePixel = 0; fix2.Parent = tb2
        local tl2 = Instance.new("TextLabel"); tl2.Text = "Roblox — Hata Kodu: 0x80070005"
        tl2.Size = UDim2.new(1,0,1,0); tl2.BackgroundTransparency = 1
        tl2.TextColor3 = Color3.fromRGB(255,255,255); tl2.Font = Enum.Font.Gotham
        tl2.TextSize = 12; tl2.Parent = tb2
        local msg = Instance.new("TextLabel")
        msg.Text = "Kritik bir sistem hatası oluştu.\n\nAccess is denied. (HRESULT: 0x80070005)\nOyun kapatılıyor..."
        msg.Size = UDim2.new(1,-20,0,90); msg.Position = UDim2.new(0,10,0,36)
        msg.BackgroundTransparency = 1; msg.TextColor3 = Color3.fromRGB(50,50,50)
        msg.Font = Enum.Font.Gotham; msg.TextSize = 11; msg.TextWrapped = true
        msg.TextXAlignment = Enum.TextXAlignment.Left; msg.Parent = frame
        local okB = Instance.new("TextButton"); okB.Text = "Tamam"
        okB.Size = UDim2.new(0,80,0,26); okB.Position = UDim2.new(1,-90,1,-36)
        okB.BackgroundColor3 = Color3.fromRGB(220,220,220); okB.TextColor3 = Color3.fromRGB(0,0,0)
        okB.Font = Enum.Font.Gotham; okB.TextSize = 12; okB.BorderSizePixel = 1; okB.Parent = frame
        Instance.new("UICorner", okB).CornerRadius = UDim.new(0,4)
        okB.MouseButton1Click:Connect(function() sg:Destroy() end)
        task.delay(8, function() if sg and sg.Parent then sg:Destroy() end end)
    end)
end)

-- ========== MISC ==========
createSection(miscPage, "MISC", 1)
createToggle(miscPage, "Anti-AFK", 2, function(state)
    if state then pcall(function()
        local vu = game:GetService("VirtualUser")
        lp.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1); vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end) end
end)
local godConn
createToggle(miscPage, "Local God Mode", 3, function(state)
    if state then
        godConn = RunService.Heartbeat:Connect(function()
            pcall(function() local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h.Health = h.MaxHealth end end)
        end)
    else if godConn then godConn:Disconnect(); godConn = nil end end
end)
createToggle(miscPage, "Big Head", 4, function(state)
    pcall(function()
        local head = lp.Character and lp.Character:FindFirstChild("Head")
        if head then head.Size = state and Vector3.new(5,5,5) or Vector3.new(2,1,1) end
    end)
end)
createSection(miscPage, "TELEPORT", 5)
createInputRow(miscPage, "Oyuncu adı...", 6, "TP", function(name)
    pcall(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp and plr.Name:lower():find(name:lower()) and plr.Character then
                local th = plr.Character:FindFirstChild("HumanoidRootPart")
                local c2 = lp.Character; local mhrp = c2 and c2:FindFirstChild("HumanoidRootPart")
                if th and mhrp then mhrp.CFrame = th.CFrame + Vector3.new(2,0,0) end
            end
        end
    end)
end)

-- Respawn
lp.CharacterAdded:Connect(function(newChar)
    char = newChar; hum = newChar:WaitForChild("Humanoid"); hrp = newChar:WaitForChild("HumanoidRootPart")
end)