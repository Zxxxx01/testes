local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

---------------------------------------------------
-- KEYBIND SYSTEM
---------------------------------------------------
local minimizeKey = Enum.KeyCode.RightShift -- padrão
local minimized = false

---------------------------------------------------
-- GUI ROOT
---------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

---------------------------------------------------
-- MAIN WINDOW
---------------------------------------------------
local main = Instance.new("Frame")
main.Size = UDim2.new(0,650,0,380)
main.Position = UDim2.new(0.5,-325,0.5,-190)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,8)

---------------------------------------------------
-- TOP BAR
---------------------------------------------------
local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,35)
top.BackgroundColor3 = Color3.fromRGB(25,25,25)
top.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "ZX Hub"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0,10,0,0)
title.Parent = top

---------------------------------------------------
-- BOTÃO DE MINIMIZAR
---------------------------------------------------
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,35,1,0)
minimizeBtn.Position = UDim2.new(1,-40,0,0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Text = "-"
minimizeBtn.Parent = top
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,6)

---------------------------------------------------
-- ÍCONE DE RESTAURAR
---------------------------------------------------
local restoreIcon = Instance.new("TextButton")
restoreIcon.Size = UDim2.new(0,50,0,50)
restoreIcon.Position = UDim2.new(0,10,1,-60)
restoreIcon.BackgroundColor3 = Color3.fromRGB(25,25,25)
restoreIcon.TextColor3 = Color3.fromRGB(255,255,255)
restoreIcon.Font = Enum.Font.GothamBold
restoreIcon.TextSize = 20
restoreIcon.Text = "+"
restoreIcon.Visible = false
restoreIcon.Parent = gui
Instance.new("UICorner", restoreIcon).CornerRadius = UDim.new(1,0)

---------------------------------------------------
-- FUNÇÃO DE MINIMIZAR / RESTAURAR
---------------------------------------------------
local function toggleGui()
    minimized = not minimized
    if minimized then
        main.Visible = false
        restoreIcon.Visible = true
    else
        main.Visible = true
        restoreIcon.Visible = false
    end
end

minimizeBtn.MouseButton1Click:Connect(toggleGui)
restoreIcon.MouseButton1Click:Connect(toggleGui)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == minimizeKey then
            toggleGui()
        end
    end
end)

---------------------------------------------------
-- SIDEBAR
---------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0,160,1,-35)
sidebar.Position = UDim2.new(0,0,0,35)
sidebar.BackgroundColor3 = Color3.fromRGB(15,15,15)
sidebar.Parent = main
Instance.new("UIListLayout", sidebar).Padding = UDim.new(0,5)

---------------------------------------------------
-- CONTENT
---------------------------------------------------
local content = Instance.new("Frame")
content.Size = UDim2.new(1,-160,1,-35)
content.Position = UDim2.new(0,160,0,35)
content.BackgroundColor3 = Color3.fromRGB(20,20,20)
content.Parent = main

---------------------------------------------------
-- PAGES
---------------------------------------------------
local pages = {}
local function newPage(name)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundTransparency = 1
    f.Visible = false
    f.Parent = content
    pages[name] = f
    return f
end

local mainPage = newPage("Main")
local localPage = newPage("Local Player")
local settings = newPage("Settings")
mainPage.Visible = true

local function show(page)
    for _,v in pairs(pages) do v.Visible = false end
    page.Visible = true
end

---------------------------------------------------
-- TABS
---------------------------------------------------
local function tab(name, page)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,40)
    b.BackgroundColor3 = Color3.fromRGB(25,25,25)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.Text = name
    b.Parent = sidebar
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    b.MouseButton1Click:Connect(function() show(page) end)
end

tab("Main", mainPage)
tab("Local Player", localPage)
tab("Settings", settings)

---------------------------------------------------
-- BUTTON SYSTEM
---------------------------------------------------
local function button(parent, text, y, func)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,300,0,35)
    b.Position = UDim2.new(0,20,0,y)
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.Text = text
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    b.MouseButton1Click:Connect(func)
end

---------------------------------------------------
-- MAIN PAGE
---------------------------------------------------
button(mainPage,"Função Exemplo",20,function()
    print("Executando função exemplo")
end)

---------------------------------------------------
-- LOCAL PLAYER
---------------------------------------------------
button(localPage,"Super Speed",20,function()
    humanoid.WalkSpeed = 80
end)
button(localPage,"Reset Speed",65,function()
    humanoid.WalkSpeed = 16
end)

---------------------------------------------------
-- SETTINGS
---------------------------------------------------
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1,0,0,30)
info.Position = UDim2.new(0,0,0,10)
info.BackgroundTransparency = 1
info.Text = "Pressione uma tecla para minimizar"
info.TextColor3 = Color3.fromRGB(255,255,255)
info.Font = Enum.Font.Gotham
info.TextSize = 14
info.Parent = settings

local box = Instance.new("TextBox")
box.Size = UDim2.new(0,200,0,35)
box.Position = UDim2.new(0,20,0,60)
box.BackgroundColor3 = Color3.fromRGB(30,30,30)
box.TextColor3 = Color3.fromRGB(255,255,255)
box.Font = Enum.Font.Gotham
box.TextSize = 14
box.PlaceholderText = "RightShift / E / K / F"
box.Text = ""
box.Parent = settings
Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)

box.FocusLost:Connect(function()
    local t = box.Text:lower()
    local keyMap = {
        rightshift = Enum.KeyCode.RightShift,
        e = Enum.KeyCode.E,
        k = Enum.KeyCode.K,
        f = Enum.KeyCode.F
    }
    if keyMap[t] then
        minimizeKey = keyMap[t]
        box.Text = "Tecla: " .. minimizeKey.Name
    end
end)

---------------------------------------------------
-- PLAYER CARD (compacto e estiloso)
---------------------------------------------------
local card = Instance.new("Frame")
card.Size = UDim2.new(0,120,0,40) -- menor e mais compacto
card.Position = UDim2.new(0,15,1,-45) -- canto inferior esquerdo, sem invadir conteúdo
card.BackgroundColor3 = Color3.fromRGB(25,25,25)
card.Parent = main
Instance.new("UICorner", card).CornerRadius = UDim.new(1,0)

-- Avatar com fundo cinza arredondado
local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0,30,0,30)
avatar.Position = UDim2.new(0,5,0.5,-15)
avatar.BackgroundColor3 = Color3.fromRGB(35,35,35) -- fundo cinza
avatar.Parent = card
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1,0)

-- Nome do jogador
local name = Instance.new("TextLabel")
name.Size = UDim2.new(1,-40,1,0)
name.Position = UDim2.new(0,40,0,0)
name.BackgroundTransparency = 1
name.TextColor3 = Color3.fromRGB(255,255,255)
name.Font = Enum.Font.GothamBold
name.TextSize = 12
name.TextXAlignment = Enum.TextXAlignment.Left
name.Text = player.Name
name.Parent = card

-- Thumbnail do jogador
local thumb, isReady = Players:GetUserThumbnailAsync(
    player.UserId,
    Enum.ThumbnailType.HeadShot,
    Enum.ThumbnailSize.Size100x100
)
if isReady then
    avatar.Image = thumb
end

---------------------------------------------------
-- DRAG SYSTEM (mover GUI pela barra superior)
---------------------------------------------------
local dragging = false
local dragStart
local startPos

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

