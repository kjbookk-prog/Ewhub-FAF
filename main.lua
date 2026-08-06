--[================================================================]--
--                  EWEHUB UNIVERSAL LOADER                         --
--          Single File, Clean, No Libraries, Fully Self-Contained   --
--[================================================================]--

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Konfigurasi & Registry Game (Cukup tambah entry baru di sini)
local Config = {
    Debug = true,
    Width = 295,
    Theme = {
        Background = Color3.fromRGB(18, 18, 22),
        Surface = Color3.fromRGB(24, 24, 30),
        Border = Color3.fromRGB(55, 55, 68),
        Accent = Color3.fromRGB(0, 255, 128),
        TextPrimary = Color3.fromRGB(245, 245, 250),
        TextSecondary = Color3.fromRGB(180, 180, 195),
        Success = Color3.fromRGB(0, 255, 128),
        Error = Color3.fromRGB(255, 75, 75)
    }
}

local GameRegistry = {
    [8243724761] = { 
        Name = "Farm A Fish", 
        Enabled = true,
        ScriptUrl = "https://raw.githubusercontent.com/kjbookk-prog/Ewehub-FAF/refs/heads/main/ewehub.lua"
    },
    -- Contoh penambahan game lain:
    -- [UNIVERSE_ID_DISINI] = { Name = "Nama Game", Enabled = true, ScriptUrl = "URL" },
    [10144280947] = {
        Name = "+1 Speed Monkey
        Enabled = true
        ScriptUrl = "https://raw.githubusercontent.com/kjbookk-prog/Ewehub-FAF/refs/heads/main/monkey.lua"
}

-- Deteksi Executor yang Digunakan Secara Otomatis
local function GetExecutorName()
    local name = "Unknown Executor"
    pcall(function()
        if identifyexecutor then
            name = identifyexecutor()
        elseif getexecutorname then
            name = getexecutorname()
        elseif syn then
            name = "Synapse X"
        elseif KRNL_LOADED then
            name = "KRNL"
        elseif Delta then
            name = "Delta"
        elseif Fluxus then
            name = "Fluxus"
        elseif Hydrogen then
            name = "Hydrogen"
        end
    end)
    return tostring(name)
end

-- Logger Sederhana
local function Log(type, msg)
    if not Config.Debug then return end
    print(string.format("[EWEHUB Loader] [%s] %s", type, tostring(msg)))
end

-- Helper Pembuatan Instance Cepat
local function Create(className, parent, props, children)
    local obj = Instance.new(className)
    if props then
        for k, v in pairs(props) do
            obj[k] = v
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = obj
        end
    end
    if parent then
        obj.Parent = parent
    end
    return obj
end

-- Helper Tween Cepat
local function PlayTween(instance, info, props, callback)
    local tween = TweenService:Create(instance, TweenInfo.new(unpack(info)), props)
    if callback then
        tween.Completed:Connect(callback)
    end
    tween:Play()
    return tween
end

-- Eksekusi Utama Loader (Dibungkus pcall agar aman dari crash)
local success, err = pcall(function()
    Log("INFO", "Membuat UI Loader...")

    -- ScreenGui Utama (Layer Paling Atas, Tidak Bisa Diinteraksi)
    local ScreenGui = Create("ScreenGui", CoreGui, {
        Name = "EWEHUBLoader",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 999999
    })

    -- Main Container (Ditengah Layar)
    local MainFrame = Create("Frame", ScreenGui, {
        Name = "MainFrame",
        Size = UDim2.new(0, Config.Width, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Config.Theme.Background,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ClipsDescendants = true
    }, {
        Create("UICorner", nil, { CornerRadius = UDim.new(0, 14) }),
        Create("UIStroke", nil, { Color = Config.Theme.Border, Thickness = 1.2, Transparency = 1 }),
        Create("UIPadding", nil, {
            PaddingTop = UDim.new(0, 18),
            PaddingBottom = UDim.new(0, 18),
            PaddingLeft = UDim.new(0, 18),
            PaddingRight = UDim.new(0, 18)
        })
    })

    -- Shadow Halus
    local Shadow = Create("ImageLabel", MainFrame, {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 40, 1, 40),
        ZIndex = -1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })

    -- Header (Icon + Status Teks)
    local Header = Create("Frame", MainFrame, {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1
    }, {
        Create("UIListLayout", nil, {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 12)
        })
    })

    local IconBox = Create("Frame", Header, {
        Size = UDim2.new(0, 36, 0, 36),
        BackgroundColor3 = Config.Theme.Surface,
        BackgroundTransparency = 0
    }, {
        Create("UICorner", nil, { CornerRadius = UDim.new(0, 10) }),
        Create("UIStroke", nil, { Color = Config.Theme.Border, Thickness = 1 })
    })

    local StatusIcon = Create("TextLabel", IconBox, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = "⚡",
        TextSize = 15,
        TextColor3 = Config.Theme.Accent
    })

    local TextContainer = Create("Frame", Header, {
        Size = UDim2.new(1, -48, 1, 0),
        BackgroundTransparency = 1
    }, {
        Create("UIListLayout", nil, {
            FillDirection = Enum.FillDirection.Vertical,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 3)
        })
    })

    Create("TextLabel", TextContainer, {
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = "EWEHUB LOADER",
        TextSize = 13,
        TextColor3 = Config.Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local StatusLabel = Create("TextLabel", TextContainer, {
        Size = UDim2.new(1, 0, 0, 13),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = "Initializing...",
        TextSize = 11,
        TextColor3 = Config.Theme.TextSecondary,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Progress Bar
    local ProgressBg = Create("Frame", MainFrame, {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 56),
        BackgroundColor3 = Config.Theme.Surface,
        BorderSizePixel = 0
    }, {
        Create("UICorner", nil, { CornerRadius = UDim.new(1, 0) }),
        Create("UIStroke", nil, { Color = Config.Theme.Border, Thickness = 1 })
    })

    local ProgressBar = Create("Frame", ProgressBg, {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Config.Theme.Accent,
        BorderSizePixel = 0
    }, {
        Create("UICorner", nil, { CornerRadius = UDim.new(1, 0) })
    })

    -- Detail Game Info (Muncul setelah verifikasi)
    local DetailFrame = Create("Frame", MainFrame, {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 74),
        BackgroundTransparency = 1,
        Visible = false
    }, {
        Create("UIListLayout", nil, {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 5)
        })
    })

    local GameNameLabel = Create("TextLabel", DetailFrame, {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = "",
        TextSize = 12,
        TextColor3 = Config.Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local GameIdLabel = Create("TextLabel", DetailFrame, {
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = "",
        TextSize = 10,
        TextColor3 = Config.Theme.TextSecondary,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ExecutorLabel = Create("TextLabel", DetailFrame, {
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = "",
        TextSize = 10,
        TextColor3 = Config.Theme.TextSecondary,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local FooterLabel = Create("TextLabel", DetailFrame, {
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = "Thank you for using EWEHUB!",
        TextSize = 10,
        TextColor3 = Config.Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Fungsi Pembersihan Memori (Cleanup)
    local function Cleanup()
        Log("INFO", "Membersihkan instance loader...")
        pcall(function()
            ScreenGui:Destroy()
        end)
    end

    -- Animasi Masuk (Fade In & Scale In Bersamaan)
    PlayTween(MainFrame, {0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {
        Size = UDim2.new(0, Config.Width, 0, 82),
        BackgroundTransparency = 0
    })
    PlayTween(MainFrame:FindFirstChild("UIStroke"), {0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, { Transparency = 0.3 })
    PlayTween(Shadow, {0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, { ImageTransparency = 0.4 })

    -- Proses Pengecekan Bertahap
    task.spawn(function()
        task.wait(0.2)
        PlayTween(ProgressBar, {0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, { Size = UDim2.new(0.3, 0, 1, 0) })

        task.wait(0.35)
        StatusLabel.Text = "Detecting Game..."
        PlayTween(ProgressBar, {0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, { Size = UDim2.new(0.6, 0, 1, 0) })

        task.wait(0.35)
        StatusLabel.Text = "Checking Game Support..."
        PlayTween(ProgressBar, {0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, { Size = UDim2.new(0.85, 0, 1, 0) })

        task.wait(0.4)
        StatusLabel.Text = "Verifying Database..."
        PlayTween(ProgressBar, {0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, { Size = UDim2.new(0.95, 0, 1, 0) })

        task.wait(0.4)

        -- Ambil ID Game Nyata & Nama Executor
        local universeId = game.GameId
        local placeId = game.PlaceId
        local registryData = GameRegistry[universeId] or GameRegistry[placeId]
        local currentExecutor = GetExecutorName()

        -- Perbesar ukuran Frame secara pas agar seluruh informasi di bawah terlihat sangat jelas tanpa terpotong
        PlayTween(MainFrame, {0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {
            Size = UDim2.new(0, Config.Width, 0, 158)
        })
        DetailFrame.Visible = true

        local isSupported = registryData and registryData.Enabled

        if isSupported then
            -- Game Didukung
            PlayTween(ProgressBar, {0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Config.Theme.Success
            })

            StatusIcon.Text = "✓"
            StatusIcon.TextColor3 = Config.Theme.Success
            StatusLabel.Text = "Game Supported"
            StatusLabel.TextColor3 = Config.Theme.Success

            GameNameLabel.Text = "Game: " .. tostring(registryData.Name)
            GameIdLabel.Text = "Universe ID: " .. tostring(universeId)
            ExecutorLabel.Text = "Executor: " .. currentExecutor
            Log("SUCCESS", "Game terverifikasi didukung: " .. tostring(registryData.Name))

            -- Efek Glow Singkat pada Border
            local stroke = MainFrame:FindFirstChild("UIStroke")
            if stroke then
                PlayTween(stroke, {0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out}, { Color = Config.Theme.Success, Transparency = 0.1 }, function()
                    PlayTween(stroke, {0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In}, { Color = Config.Theme.Border, Transparency = 0.3 })
                end)
            end

            task.wait(1.8)
        else
            -- Game Tidak Didukung
            PlayTween(ProgressBar, {0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {
                BackgroundColor3 = Config.Theme.Error
            })

            StatusIcon.Text = "✕"
            StatusIcon.TextColor3 = Config.Theme.Error
            StatusLabel.Text = "Game Not Supported"
            StatusLabel.TextColor3 = Config.Theme.Error

            GameNameLabel.Text = "Universe ID: " .. tostring(universeId)
            GameIdLabel.Text = "Place ID: " .. tostring(placeId)
            ExecutorLabel.Text = "Executor: " .. currentExecutor
            Log("WARN", "Game tidak terdaftar di database.")

            task.wait(2.2)
        end

        -- Animasi Keluar (Fade Out & Scale Out)
        PlayTween(MainFrame, {0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In}, {
            Size = UDim2.new(0, Config.Width, 0, 0),
            BackgroundTransparency = 1
        })
        PlayTween(MainFrame:FindFirstChild("UIStroke"), {0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In}, { Transparency = 1 })
        PlayTween(Shadow, {0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In}, { ImageTransparency = 1 }, function()
            Cleanup()
            
            -- Eksekusi Script Target jika Game Didukung
            if isSupported and registryData.ScriptUrl then
                Log("INFO", "Menjalankan script target...")
                task.spawn(function()
                    local execSuccess, execErr = pcall(function()
                        loadstring(game:HttpGet(registryData.ScriptUrl))()
                    end)
                    if not execSuccess then
                        Log("ERROR", "Gagal mengeksekusi script target: " .. tostring(execErr))
                    end
                end)
            end
        end)
    end)
end)

if not success then
    warn("[EWEHUB Loader Error]: " .. tostring(err))
end
