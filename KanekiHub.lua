local Players = game:GetService("Players"); local RunService = game:GetService("RunService"); local UIS = game:GetService("UserInputService"); local player = Players.LocalPlayer
if player.PlayerGui:FindFirstChild("iOS26KanekiHub") then player.PlayerGui.iOS26KanekiHub:Destroy() end

local sg = Instance.new("ScreenGui", player.PlayerGui); sg.Name = "iOS26KanekiHub"; sg.ResetOnSpawn = false

-- [ CONFIG Core ]
local bringDist = 4; local hitboxSize = Vector3.new(15, 15, 15)
local target, loopSel, loopAll, loopEnemy = nil, false, false, false
local uiThemeColor = Color3.fromRGB(0, 122, 255)

-- ลิงก์รูปภาพคาเนกิ (ใช้ทั้งพื้นหลังและปุ่มวงกลม)
local AssetID = "http://www.roblox.com/asset/?id=134103131336087" 

-- [ ฟังก์ชันสร้างขอบ RGB สไตล์ iOS 26 Aura ]
local function createRGBStroke(parent, thickness)
    local s = Instance.new("UIStroke", parent); s.Thickness = thickness or 1.5; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    task.spawn(function()
        while s.Parent do
            for i = 0, 1, 0.01 do if not s.Parent then break end; s.Color = Color3.fromHSV(i, 0.65, 1); task.wait(0.04) end
        end
    end)
end

-- [ ปุ่มวงกลมเปิด/ปิด UI (เปลี่ยนเป็นรูปคาเนกิเรียบร้อย) ]
local tBtn = Instance.new("ImageButton", sg); tBtn.Size = UDim2.new(0, 45, 0, 45); tBtn.Position = UDim2.new(0, 10, 0, 10); tBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); tBtn.Draggable = true
tBtn.Image = AssetID -- เอารูปคาเนกิมาใส่ในปุ่มวงกลมแทนข้อความเดิม
tBtn.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", tBtn).CornerRadius = UDim.new(1, 0); createRGBStroke(tBtn, 2)

-- [ หน้าต่างหลักขนาด MINI พร้อมพื้นหลัง Kaneki ]
local mf = Instance.new("Frame", sg); mf.Size = UDim2.new(0, 230, 0, 270); mf.Position = UDim2.new(0.5, -115, 0.5, -135); mf.BackgroundColor3 = Color3.fromRGB(15, 15, 15); mf.Visible = false; mf.Active = true; mf.Draggable = true
Instance.new("UICorner", mf).CornerRadius = UDim.new(0, 16); createRGBStroke(mf, 2)

-- ใส่รูปพื้นหลัง Kaneki ในหน้าหลัก
local bgImg = Instance.new("ImageLabel", mf); bgImg.Size = UDim2.new(1, 0, 1, 0); bgImg.Image = AssetID; bgImg.ImageTransparency = 0.4; bgImg.BackgroundTransparency = 1; bgImg.ScaleType = Enum.ScaleType.Crop; bgImg.ZIndex = 0
Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 16)

tBtn.MouseButton1Click:Connect(function() mf.Visible = not mf.Visible end)

local title = Instance.new("TextLabel", mf); title.Size = UDim2.new(1, 0, 0, 30); title.BackgroundTransparency = 1; title.Text = "Kaneki Hub • Mini V3"; title.TextColor3 = Color3.new(1,1,1); title.Font = Enum.Font.GothamBold; title.TextSize = 11; title.ZIndex = 2

-- หน้าแยกเนื้อหาภายใน
local function createPage()
    local p = Instance.new("ScrollingFrame", mf); p.Size = UDim2.new(1, -16, 1, -75); p.Position = UDim2.new(0, 8, 0, 35); p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0,0,0,0); p.ClipsDescendants = true; p.ZIndex = 2
    local layout = Instance.new("UIListLayout", p); layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 6)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() p.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10) end)
    return p
end
local p1 = createPage(); local p2 = createPage(); p2.Visible = false; local p3 = createPage(); p3.Visible = false

-- แถบสลับหน้าด้านล่าง
local navBar = Instance.new("Frame", mf); navBar.Size = UDim2.new(0.92, 0, 0, 32); navBar.Position = UDim2.new(0.04, 0, 1, -38); navBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25); navBar.BackgroundTransparency = 0.2; navBar.ZIndex = 3
Instance.new("UICorner", navBar).CornerRadius = UDim.new(0, 10)

local tabsTable = {}
local function createTabBtn(txt, pos, targetPage)
    local b = Instance.new("TextButton", navBar); b.Size = UDim2.new(0.33, -2, 0, 26); b.Position = pos; b.Text = txt; b.BackgroundTransparency = 1; b.TextColor3 = Color3.fromRGB(140,140,140); b.Font = Enum.Font.GothamBold; b.TextSize = 10; b.ZIndex = 4
    b.MouseButton1Click:Connect(function()
        p1.Visible = false; p2.Visible = false; p3.Visible = false; targetPage.Visible = true
        for _, btn in pairs(tabsTable) do btn.TextColor3 = Color3.fromRGB(140,140,140) end
        b.TextColor3 = uiThemeColor
    end)
    table.insert(tabsTable, b)
    return b
end
local bT1 = createTabBtn("BRING", UDim2.new(0, 2, 0, 3), p1); bT1.TextColor3 = uiThemeColor
local bT2 = createTabBtn("ESP", UDim2.new(0.33, 2, 0, 3), p2)
local bT3 = createTabBtn("MISC", UDim2.new(0.66, 2, 0, 3), p3)

-- ฟังก์ชันสร้างปุ่มพื้นฐาน
local function createIOSBtn(parent, txt, bgCol, h)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(0.98, 0, 0, h or 28); b.Text = txt; b.BackgroundColor3 = bgCol or Color3.fromRGB(40, 40, 40); b.BackgroundTransparency = 0.1; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamMedium; b.TextSize = 10; b.ZIndex = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local function createRow(parent, h)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(0.98, 0, 0, h or 28); f.BackgroundTransparency = 1; f.ZIndex = 3
    local l = Instance.new("UIListLayout", f); l.FillDirection = Enum.FillDirection.Horizontal; l.Padding = UDim.new(0, 6); l.SortOrder = Enum.SortOrder.LayoutOrder
    return f
end

-- ฟังก์ชันอัปเดตสีปุ่มตามธีมปัจจุบัน
local activeToggles = {}
local function createToggleBtn(parent, txt, stateTable, stateKey, size)
    local b = createIOSBtn(parent, txt)
    if size then b.Size = size end
    local function updateColor()
        b.BackgroundColor3 = stateTable[stateKey] and uiThemeColor or Color3.fromRGB(40, 40, 40)
    end
    b.MouseButton1Click:Connect(function()
        stateTable[stateKey] = not stateTable[stateKey]
        updateColor()
    end)
    activeToggles[b] = {st = stateTable, sk = stateKey}
    return b
end

local function refreshActiveToggleColors()
    for btn, info in pairs(activeToggles) do
        btn.BackgroundColor3 = info.st[info.sk] and uiThemeColor or Color3.fromRGB(40, 40, 40)
    end
    for _, btn in pairs(tabsTable) do
        if btn.TextColor3 ~= Color3.fromRGB(140,140,140) then btn.TextColor3 = uiThemeColor end
    end
end

-------------------------------------------------------------------------------
-- [ 1. หน้า BRING ]
local plFrame = Instance.new("Frame", sg); plFrame.Size = UDim2.new(0, 180, 0, 200); plFrame.Position = UDim2.new(0.5, 120, 0.5, -100); plFrame.BackgroundColor3 = Color3.fromRGB(15,15,15); plFrame.Visible = false
Instance.new("UICorner", plFrame).CornerRadius = UDim.new(0, 12); createRGBStroke(plFrame, 1.5)

local bgImg2 = Instance.new("ImageLabel", plFrame); bgImg2.Size = UDim2.new(1, 0, 1, 0); bgImg2.Image = AssetID; bgImg2.ImageTransparency = 0.5; bgImg2.BackgroundTransparency = 1; bgImg2.ScaleType = Enum.ScaleType.Crop; bgImg2.ZIndex = 0
Instance.new("UICorner", bgImg2).CornerRadius = UDim.new(0, 12)

local plTitle = Instance.new("TextLabel", plFrame); plTitle.Size = UDim2.new(1,0,0,25); plTitle.Text = "เลือกผู้เล่น"; plTitle.TextColor3 = Color3.new(1,1,1); plTitle.Font = Enum.Font.GothamBold; plTitle.TextSize = 10; plTitle.BackgroundTransparency = 1; plTitle.ZIndex = 2
local list = Instance.new("ScrollingFrame", plFrame); list.Size = UDim2.new(1, -10, 1, -35); list.Position = UDim2.new(0, 5, 0, 25); list.BackgroundTransparency = 1; list.ScrollBarThickness = 2; list.ZIndex = 2
local innerLayout = Instance.new("UIListLayout", list); innerLayout.SortOrder = Enum.SortOrder.LayoutOrder; innerLayout.Padding = UDim.new(0, 4)

local r1 = createRow(p1); local bListToggle = createIOSBtn(r1, "👤 เปิดรายชื่อผู้เล่น", Color3.fromRGB(50,50,50)) bListToggle.Size = UDim2.new(0.6, -3, 1, 0)
local bRef = createIOSBtn(r1, "🔄 รีเฟรช", Color3.fromRGB(35,35,35)) bRef.Size = UDim2.new(0.4, -3, 1, 0)
bListToggle.MouseButton1Click:Connect(function() plFrame.Visible = not plFrame.Visible end)

local rowDist = createRow(p1, 26)
local distLabel = Instance.new("TextLabel", rowDist); distLabel.Size = UDim2.new(0.45, 0, 1, 0); distLabel.Text = "ระยะดึง: " .. bringDist; distLabel.TextColor3 = Color3.new(1,1,1); distLabel.BackgroundTransparency = 1; distLabel.Font = Enum.Font.GothamBold; distLabel.TextSize = 10; distLabel.ZIndex = 3
local bDistPlus = Instance.new("TextButton", rowDist); bDistPlus.Size = UDim2.new(0.25, -3, 1, 0); bDistPlus.Text = "+"; bDistPlus.BackgroundColor3 = Color3.fromRGB(50,50,50); bDistPlus.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", bDistPlus); bDistPlus.ZIndex = 3
local bDistMinus = Instance.new("TextButton", rowDist); bDistMinus.Size = UDim2.new(0.25, -3, 1, 0); bDistMinus.Text = "-"; bDistMinus.BackgroundColor3 = Color3.fromRGB(50,50,50); bDistMinus.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", bDistMinus); bDistMinus.ZIndex = 3

local bringState = {Sel = false, All = false, Enemy = false}
local bSel = createIOSBtn(p1, "ดึงรายคน", Color3.fromRGB(45,45,45))
local bAll = createIOSBtn(p1, "ดึงทุกคน", Color3.fromRGB(140,30,30))
local bEnemy = createIOSBtn(p1, "ดึงศัตรู", Color3.fromRGB(110,30,30))

bDistPlus.MouseButton1Click:Connect(function() bringDist = bringDist + 1; distLabel.Text = "ระยะดึง: " .. bringDist end)
bDistMinus.MouseButton1Click:Connect(function() bringDist = math.max(2, bringDist - 1); distLabel.Text = "ระยะดึง: " .. bringDist end)

local function refresh()
    for _, child in pairs(list:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    local count = 0
    for _, v in pairs(Players:GetPlayers()) do if v ~= player then
        count = count + 1
        local b = Instance.new("TextButton", list); b.Size = UDim2.new(1, -4, 0, 24); b.Text = v.Name; b.TextColor3=Color3.new(1,1,1); b.BackgroundColor3=Color3.fromRGB(30,30,30); b.BackgroundTransparency = 0.2; b.Font=Enum.Font.Gotham; b.TextSize = 10; Instance.new("UICorner", b); b.ZIndex = 3
        b.MouseButton1Click:Connect(function() target = v; bSel.Text = bringState.Sel and "กำลังดึง: "..v.Name or "ดึง: "..v.Name; plFrame.Visible = false end)
    end end
    list.CanvasSize = UDim2.new(0, 0, 0, count * 28)
end

local function setHitbox(targetPlayer, enable)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = targetPlayer.Character.HumanoidRootPart
        if enable then hrp.Size = hitboxSize; hrp.Transparency = 1; hrp.CanCollide = false 
        else hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1; hrp.CanCollide = true end
    end
end
local function resetAllHitboxes() for _, v in pairs(Players:GetPlayers()) do if v ~= player then setHitbox(v, false) end end end

bSel.MouseButton1Click:Connect(function()
    bringState.Sel = not bringState.Sel; bSel.BackgroundColor3 = bringState.Sel and uiThemeColor or Color3.fromRGB(45,45,45)
    bSel.Text = bringState.Sel and ("กำลังดึง: "..(target and target.Name or "ไม่มีเป้า")) or (target and ("ดึง: "..target.Name) or "ดึงรายคน")
    if not bringState.Sel then resetAllHitboxes() end
end)
bAll.MouseButton1Click:Connect(function() bringState.All = not bringState.All; bAll.BackgroundColor3 = bringState.All and uiThemeColor or Color3.fromRGB(140,30,30); bAll.Text = bringState.All and "กำลังดึงทุกคน" or "ดึงทุกคน" if not bringState.All then resetAllHitboxes() end end)
bEnemy.MouseButton1Click:Connect(function() bringState.Enemy = not bringState.Enemy; bEnemy.BackgroundColor3 = bringState.Enemy and uiThemeColor or Color3.fromRGB(110,30,30); bEnemy.Text = bringState.Enemy and "กำลังดึงศัตรู" or "ดึงศัตรู" if not bringState.Enemy then resetAllHitboxes() end end)
bRef.MouseButton1Click:Connect(refresh); refresh()

local function bringToMe(targetChar)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
        targetChar.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -bringDist) * CFrame.Angles(0, math.rad(180), 0)
    end
end
task.spawn(function()
    while true do
        if bringState.Sel and target and target.Character then bringToMe(target.Character); setHitbox(target, true) end
        if bringState.All then for _,v in pairs(Players:GetPlayers()) do if v ~= player and v.Character then bringToMe(v.Character); setHitbox(v, true) end end end
        if bringState.Enemy then for _,v in pairs(Players:GetPlayers()) do if v ~= player and v.Team ~= player.Team and v.Character then bringToMe(v.Character); setHitbox(v, true) end end end
        task.wait(0.2)
    end
end)

-------------------------------------------------------------------------------
-- [ 2. หน้า ESP ]
local esp = { Master = false, Box = false, Chams = false, Info = false, Tracers = false, IsRGB = false, EnemyColor = Color3.new(1,0,0), TeammateColor = Color3.new(0,1,0) }
local LinesTable = {}

local function createEsp(char)
    if char:FindFirstChild("ESP_Chams") then return end
    local h = Instance.new("Highlight", char); h.Name = "ESP_Chams"
    local hp = Instance.new("BillboardGui", char); hp.Name = "ESP_UI"; hp.Size = UDim2.new(0, 80, 0, 30); hp.StudsOffset = Vector3.new(1.5, 0, 0); hp.AlwaysOnTop = true
    local bg = Instance.new("Frame", hp); bg.Name = "BG"; bg.Size = UDim2.new(0.05, 0, 1, 0); bg.BackgroundColor3 = Color3.new(0.2,0.2,0.2); bg.BorderSizePixel = 0
    local bar = Instance.new("Frame", bg); bar.Name = "Bar"; bar.Size = UDim2.new(1, 0, 1, 0); bar.Position = UDim2.new(0,0,1,0); bar.AnchorPoint = Vector2.new(0,1); bar.BackgroundColor3 = Color3.new(0,1,0); bar.BorderSizePixel = 0
    local t = Instance.new("TextLabel", hp); t.Name = "Txt"; t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.GothamBold; t.TextSize = 9
end

RunService.RenderStepped:Connect(function()
    local rgbColor = esp.IsRGB and Color3.fromHSV(tick() % 5 / 5, 1, 1) or nil
    
    for name, line in pairs(LinesTable) do
        if not esp.Master or not esp.Tracers or not Players:FindFirstChild(name) then
            line.Visible = false; line:Remove(); LinesTable[name] = nil
        end
    end

    for _, v in pairs(Players:GetPlayers()) do if v ~= player then
        if esp.Master and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
            local hrp = v.Character.HumanoidRootPart; local hum = v.Character.Humanoid; createEsp(v.Character)
            local h = v.Character:FindFirstChild("ESP_Chams"); local ui = v.Character:FindFirstChild("ESP_UI")
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
            local finalColor = esp.IsRGB and rgbColor or (v.Team ~= player.Team and esp.EnemyColor or esp.TeammateColor)
            
            if esp.Tracers and onScreen then
                if not LinesTable[v.Name] then LinesTable[v.Name] = Drawing.new("Line"); LinesTable[v.Name].Thickness = 1 end
                LinesTable[v.Name].From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                LinesTable[v.Name].To = Vector2.new(pos.X, pos.Y); LinesTable[v.Name].Color = finalColor; LinesTable[v.Name].Visible = true
            else if LinesTable[v.Name] then LinesTable[v.Name].Visible = false end end
            if h then h.Enabled = (esp.Box or esp.Chams); h.FillColor = finalColor; h.OutlineColor = finalColor; h.OutlineTransparency = esp.Box and 0 or 1; h.FillTransparency = esp.Chams and 0.6 or 1 end
            if ui then ui.Enabled = esp.Info; if ui.Enabled then ui.BG.Bar.Size = UDim2.new(1, 0, hum.Health/hum.MaxHealth, 0); ui.Txt.Text = v.Name.."\n"..math.floor(hum.Health) end end
        else
            if LinesTable[v.Name] then LinesTable[v.Name].Visible = false end
            if v.Character and v.Character:FindFirstChild("ESP_Chams") then v.Character.ESP_Chams.Enabled = false end
            if v.Character and v.Character:FindFirstChild("ESP_UI") then v.Character.ESP_UI.Enabled = false end
        end
    end end
end)

local er1 = createRow(p2); createToggleBtn(er1, "เปิด ESP", esp, "Master", UDim2.new(0.5, -3, 1, 0)); createToggleBtn(er1, "RGB โหมด", esp, "IsRGB", UDim2.new(0.5, -3, 1, 0))
local er2 = createRow(p2); createToggleBtn(er2, "กรอบ (Box)", esp, "Box", UDim2.new(0.5, -3, 1, 0)); createToggleBtn(er2, "สีตัว (Chams)", esp, "Chams", UDim2.new(0.5, -3, 1, 0))
local er3 = createRow(p2); createToggleBtn(er3, "เส้นเท้า (Tracer)", esp, "Tracers", UDim2.new(0.5, -3, 1, 0)); createToggleBtn(er3, "เลือด (Info)", esp, "Info", UDim2.new(0.5, -3, 1, 0))

local enemyLabel = Instance.new("TextLabel", p2); enemyLabel.Size = UDim2.new(0.98,0,0,16); enemyLabel.Text = "🔴 สีทีมศัตรู (Enemies)"; enemyLabel.TextColor3 = Color3.new(1,1,1); enemyLabel.BackgroundTransparency = 1; enemyLabel.Font=Enum.Font.GothamBold; enemyLabel.TextSize = 9; enemyLabel.TextXAlignment = Enum.TextXAlignment.Left; enemyLabel.ZIndex = 3
local rowEnemy = Instance.new("Frame", p2); rowEnemy.Size = UDim2.new(0.98, 0, 0, 48); rowEnemy.BackgroundTransparency = 1; rowEnemy.ZIndex = 3
local enemyColors = {Red=Color3.new(1,0,0), Yellow=Color3.new(1,1,0), Black=Color3.new(0,0,0), Gray=Color3.new(0.5,0.5,0.5)}
local eX, eY = 0, 0; for name, col in pairs(enemyColors) do
    local b = Instance.new("TextButton", rowEnemy); b.Size = UDim2.new(0.22, 0, 0, 20); b.Position = UDim2.new(eX, 0, eY, 0); b.Text = name:sub(1,2); b.BackgroundColor3 = col; b.TextColor3 = (col==Color3.new(0,0,0) or col==Color3.new(0.5,0.5,0.5)) and Color3.new(1,1,1) or Color3.new(0,0,0); Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6); b.Font = Enum.Font.GothamBold; b.TextSize = 9; b.ZIndex = 4
    b.MouseButton1Click:Connect(function() esp.IsRGB = false; refreshActiveToggleColors(); esp.EnemyColor = col end)
    eX = eX + 0.25; if eX >= 1 then eX = 0; eY = eY + 24 end
end

local teamLabel = Instance.new("TextLabel", p2); teamLabel.Size = UDim2.new(0.98,0,0,16); teamLabel.Text = "🔵 สีทีมเดียวกัน (Teammates)"; teamLabel.TextColor3 = Color3.new(1,1,1); teamLabel.BackgroundTransparency = 1; teamLabel.Font=Enum.Font.GothamBold; teamLabel.TextSize = 9; teamLabel.TextXAlignment = Enum.TextXAlignment.Left; teamLabel.ZIndex = 3
local rowTeam = Instance.new("Frame", p2); rowTeam.Size = UDim2.new(0.98, 0, 0, 48); rowTeam.BackgroundTransparency = 1; rowTeam.ZIndex = 3
local teamColors = {Green=Color3.new(0,1,0), Cyan=Color3.fromRGB(0,255,255), Black=Color3.new(0,0,0), Gray=Color3.new(0.5,0.5,0.5)}
local tX, tY = 0, 0; for name, col in pairs(teamColors) do
    local b = Instance.new("TextButton", rowTeam); b.Size = UDim2.new(0.22, 0, 0, 20); b.Position = UDim2.new(tX, 0, tY, 0); b.Text = name:sub(1,2); b.BackgroundColor3 = col; b.TextColor3 = (col==Color3.new(0,0,0) or col==Color3.new(0.5,0.5,0.5)) and Color3.new(1,1,1) or Color3.new(0,0,0); Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6); b.Font = Enum.Font.GothamBold; b.TextSize = 9; b.ZIndex = 4
    b.MouseButton1Click:Connect(function() esp.IsRGB = false; refreshActiveToggleColors(); esp.TeammateColor = col end)
    tX = tX + 0.25; if tX >= 1 then tX = 0; tY = tY + 24 end
end

-------------------------------------------------------------------------------
-- [ 3. หน้า MISC + ระบบหมุนๆ (Spin Mode) ]
local speedCfg = {On = false, Value = 50}; local misc = {Spin = false, SpinSpeed = 45, Noclip = false, InfiniteJump = false}; local tpPoints = {P1 = nil, P2 = nil}

createToggleBtn(p3, "Speed Toggle", speedCfg, "On")
local rowSpeed = createRow(p3, 26)
local lSpeed = Instance.new("TextLabel", rowSpeed); lSpeed.Size = UDim2.new(0.5, 0, 1, 0); lSpeed.Text = "เร็ว: " .. speedCfg.Value; lSpeed.TextColor3 = Color3.new(1,1,1); lSpeed.BackgroundTransparency = 1; lSpeed.Font = Enum.Font.Gotham; lSpeed.TextSize = 10; lSpeed.ZIndex = 3
local bPlus = Instance.new("TextButton", rowSpeed); bPlus.Size = UDim2.new(0.22, -3, 1, 0); bPlus.Text = "+"; bPlus.BackgroundColor3 = Color3.fromRGB(50,50,50); bPlus.TextColor3 = Co
