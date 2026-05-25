local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

---------------------------------------------------
-- PROTEÇÃO COM PCALL
---------------------------------------------------
local success, errorMsg = pcall(function()

local player = Players.LocalPlayer

---------------------------------------------------
-- VARIÁVEIS DO SISTEMA UNIVERSAL
---------------------------------------------------
local minimizeKey = Enum.KeyCode.RightShift -- Padrão inicial
local minimizeInputType = Enum.UserInputType.Keyboard -- Tipo inicial
local minimized = false
local humanoid = nil

---------------------------------------------------
-- PROTEÇÃO DE RESPAWN (ATUALIZA HUMANUID)
---------------------------------------------------
local function updateHumanoid()
    local char = player.Character
    if char then
        humanoid = char:WaitForChild("Humanoid")
        return true
    end
    return false
end

-- Inicializa humanoid
local char = player.Character or player.CharacterAdded:Wait()
humanoid = char:WaitForChild("Humanoid")

-- Reconecta ao renascer
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
end)

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

---------------------------------------------------
-- SISTEMA DE KEYBIND UNIVERSAL
---------------------------------------------------
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    if (input.KeyCode == minimizeKey and input.KeyCode ~= Enum.KeyCode.Unknown) or 
       (input.UserInputType == minimizeInputType and minimizeKey == Enum.KeyCode.Unknown) then
        toggleGui()
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

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Parent = sidebar
sidebarLayout.Padding = UDim.new(0,5)

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

---------------------------------------------------
-- UIListLayout NAS PÁGINAS (SEM POSIÇÃO MANUAL)
---------------------------------------------------
local mainLayout = Instance.new("UIListLayout")
mainLayout.Parent = mainPage
mainLayout.Padding = UDim.new(0,15)
mainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local localLayout = Instance.new("UIListLayout")
localLayout.Parent = localPage
localLayout.Padding = UDim.new(0,15)
localLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local settingsLayout = Instance.new("UIListLayout")
settingsLayout.Parent = settings
settingsLayout.Padding = UDim.new(0,15)
settingsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

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
-- BUTTON SYSTEM COM UIListLayout (SEM PARÂMETRO Y)
---------------------------------------------------
local function button(parent, text, func)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,300,0,35)
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.Text = text
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    
    -- Proteção pcall na execução do callback
    b.MouseButton1Click:Connect(function()
        pcall(func)
    end)
end

---------------------------------------------------
-- MAIN PAGE (Botões se organizam automaticamente)
---------------------------------------------------
button(mainPage,"✨ Função Exemplo",function()
    print("Executando função exemplo")
end)

---------------------------------------------------
-- LOCAL PLAYER (Com proteção de respawn)
---------------------------------------------------
button(localPage,"⚡ Super Speed",function()
    if humanoid then
        humanoid.WalkSpeed = 80
    end
end)

button(localPage,"🔄 Reset Speed",function()
    if humanoid then
        humanoid.WalkSpeed = 16
    end
end)

---------------------------------------------------
-- SETTINGS (Keybind Universal Profissional)
---------------------------------------------------
local info = Instance.new("TextLabel")
info.Size = UDim2.new(0,300,0,30)
info.BackgroundTransparency = 1
info.Text = "Configuração do Atalho de Menu"
info.TextColor3 = Color3.fromRGB(255,255,255)
info.Font = Enum.Font.GothamBold
info.TextSize = 14
info.TextXAlignment = Enum.TextXAlignment.Center
info.Parent = settings

local box = Instance.new("TextBox")
box.Size = UDim2.new(0,300,0,35)
box.BackgroundColor3 = Color3.fromRGB(30,30,30)
box.TextColor3 = Color3.fromRGB(150,150,150)
box.Font = Enum.Font.GothamMedium
box.TextSize = 14
box.Text = "Atalho Atual: " .. (minimizeKey ~= Enum.KeyCode.Unknown and minimizeKey.Name or minimizeInputType.Name)
box.ClearTextOnFocus = false
box.Parent = settings
Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)

local bindingConnection = nil

box.Focused:Connect(function()
    box.Text = "Aguardando qualquer tecla ou clique..."
    box.TextColor3 = Color3.fromRGB(235,160,50)
    
    if bindingConnection then bindingConnection:Disconnect() end
    
    bindingConnection = UIS.InputBegan:Connect(function(input, gpe)
        local inputType = input.UserInputType
        local keyCode = input.KeyCode
        
        if inputType == Enum.UserInputType.MouseMovement or keyCode == Enum.KeyCode.Unknown then 
            return 
        end
        
        if inputType == Enum.UserInputType.MouseButton1 or 
           inputType == Enum.UserInputType.MouseButton2 or 
           inputType == Enum.UserInputType.MouseButton3 then
            minimizeKey = Enum.KeyCode.Unknown
            minimizeInputType = inputType
            box.Text = "Atalho: " .. inputType.Name
        else
            minimizeKey = keyCode
            minimizeInputType = Enum.UserInputType.Keyboard
            box.Text = "Atalho: " .. keyCode.Name
        end
        
        box.TextColor3 = Color3.fromRGB(100,220,100)
        
        bindingConnection:Disconnect()
        bindingConnection = nil
        box:ReleaseFocus()
    end)
end)

box.FocusLost:Connect(function()
    if bindingConnection then
        bindingConnection:Disconnect()
        bindingConnection = nil
    end
    box.Text = "Atalho: " .. (minimizeKey ~= Enum.KeyCode.Unknown and minimizeKey.Name or minimizeInputType.Name)
    box.TextColor3 = Color3.fromRGB(255,255,255)
end)

---------------------------------------------------
-- PLAYER CARD
---------------------------------------------------
local card = Instance.new("Frame")
card.Size = UDim2.new(0,120,0,40)
card.Position = UDim2.new(0,15,1,-45)
card.BackgroundColor3 = Color3.fromRGB(25,25,25)
card.Parent = main
Instance.new("UICorner", card).CornerRadius = UDim.new(1,0)

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0,30,0,30)
avatar.Position = UDim2.new(0,5,0.5,-15)
avatar.BackgroundColor3 = Color3.fromRGB(35,35,35)
avatar.Parent = card
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1,0)

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

-- Proteção pcall no thumbnail
pcall(function()
    local thumb, isReady = Players:GetUserThumbnailAsync(
        player.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size100x100
    )
    if isReady then
        avatar.Image = thumb
    end
end)

---------------------------------------------------
-- DRAG SYSTEM
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

end) -- Fim do pcall

-- Tratamento de erro caso algo dê errado
if not success then
    warn("[ZX Hub] Erro ao carregar: " .. tostring(errorMsg))
end
