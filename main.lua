-- Memuat UI Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "EWEHUB | FAF",
    LoadingTitle = "Memuat Script...",
    LoadingSubtitle = "by EWEHUB",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- ==========================================
-- VARIABEL PENGATURAN & LIST NAMA
-- ==========================================
local Settings = {
    LoopTime = 1,
    SelectedPlace = "1",
    AutoPlaceEnabled = false,
    
    FeedDrFalloutEnabled = false,
    
    SelectedGears = {},
    AutoBuyGearEnabled = false,
    
    SelectedBaits = {},
    AutoBuyBaitEnabled = false
}

-- DAFTAR NAMA ITEM (Silakan tambah nama lain di dalam tanda petik, pisahkan dengan koma)
local DaftarGears = {"BasicAutoFeeder", "FoodScoop", "SuprameFoodTray"} 
local DaftarBaits = {"DeepSea", "Glo", "River"}

local FolderName = "AutoHubConfigs"
if not isfolder(FolderName) then makefolder(FolderName) end

-- Fungsi untuk mengambil daftar config yang tersimpan
local function GetSavedConfigs()
    local configs = {}
    if isfolder(FolderName) then
        for _, file in ipairs(listfiles(FolderName)) do
            local fileName = file:match("([^/\\]+)%.json$")
            if fileName then table.insert(configs, fileName) end
        end
    end
    return #configs == 0 and {"Kosong"} or configs
end

-- Remote Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFolder = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("remo"):WaitForChild("src"):WaitForChild("container")

local placeBuildingRemote = RemoteFolder:WaitForChild("ponds.placeBuilding")
local nukeRemote = RemoteFolder:WaitForChild("nuke.feedDrFalloutAll")
local purchaseGearRemote = RemoteFolder:WaitForChild("shop.purchaseGear")
local purchaseBaitRemote = RemoteFolder:WaitForChild("shop.purchaseBait")

local PlaceCoordinates = {
    ["1"] = Vector3.new(76.86399841308594, -0.012000083923339844, 368),
    ["2"] = Vector3.new(-143.13600158691406, -0.012000083923339844, 371),
    ["3"] = Vector3.new(29.863998413085938, -0.012000083923339844, 129),
    ["4"] = Vector3.new(-127.13600158691406, -0.012000083923339844, 124),
    ["5"] = Vector3.new(14.863998413085938, -0.012000083923339844, 23),
    ["6"] = Vector3.new(-144.13600158691406, -0.012000083923339844, -34)
}

-- ==========================================
-- TAB 1: AUTO PLACE
-- ==========================================
local Tab1 = Window:CreateTab("Auto Place", 4483362458) 

local LoopTimeSlider = Tab1:CreateSlider({
    Name = "Waktu Loop (Semua Fitur)",
    Range = {0.1, 10}, Increment = 0.1, Suffix = "Detik",
    CurrentValue = Settings.LoopTime, Flag = "LoopTimeSlider",
    Callback = function(Value) Settings.LoopTime = Value end,
})

local HomePlaceDropdown = Tab1:CreateDropdown({
    Name = "Home Place", Options = {"1", "2", "3", "4", "5", "6"},
    CurrentOption = {"1"}, MultipleOptions = false, Flag = "HomePlaceDropdown",
    Callback = function(Options) Settings.SelectedPlace = Options[1] end,
})

Tab1:CreateToggle({
    Name = "Mulai Auto Place", CurrentValue = false, Flag = "AutoPlaceToggle",
    Callback = function(Value)
        Settings.AutoPlaceEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoPlaceEnabled do
                    local pos = PlaceCoordinates[Settings.SelectedPlace]
                    if pos then
                        pcall(function() placeBuildingRemote:InvokeServer("booster", "SupremeFoodTray", pos) end)
                    end
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 2: EVENT
-- ==========================================
local TabEvent = Window:CreateTab("Event", 4483362458)

TabEvent:CreateToggle({
    Name = "Feed DrFallout",
    CurrentValue = false, Flag = "FeedDrFalloutToggle",
    Callback = function(Value)
        Settings.FeedDrFalloutEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.FeedDrFalloutEnabled do
                    pcall(function() nukeRemote:FireServer() end)
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 3: GEAR SHOP
-- ==========================================
local TabGear = Window:CreateTab("Gear Shop", 4483362458)

local GearDropdownUI = TabGear:CreateDropdown({
    Name = "Pilih Gear (Bisa Tumpuk)",
    Options = DaftarGears,
    CurrentOption = {},
    MultipleOptions = true, -- Memungkinkan pilihan ganda (ditumpuk)
    Flag = "GearDropdown",
    Callback = function(Options)
        Settings.SelectedGears = Options
    end,
})

TabGear:CreateToggle({
    Name = "Auto Buy Gear", CurrentValue = false, Flag = "AutoBuyGearToggle",
    Callback = function(Value)
        Settings.AutoBuyGearEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoBuyGearEnabled do
                    for _, gearName in ipairs(Settings.SelectedGears) do
                        pcall(function() purchaseGearRemote:FireServer(gearName) end)
                        task.wait(0.1) -- Jeda kecil per item agar tidak disconnect
                    end
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 4: BAIT SHOP
-- ==========================================
local TabBait = Window:CreateTab("Bait Shop", 4483362458)

local BaitDropdownUI = TabBait:CreateDropdown({
    Name = "Pilih Bait (Bisa Tumpuk)",
    Options = DaftarBaits,
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "BaitDropdown",
    Callback = function(Options)
        Settings.SelectedBaits = Options
    end,
})

TabBait:CreateToggle({
    Name = "Auto Buy Bait", CurrentValue = false, Flag = "AutoBuyBaitToggle",
    Callback = function(Value)
        Settings.AutoBuyBaitEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoBuyBaitEnabled do
                    for _, baitName in ipairs(Settings.SelectedBaits) do
                        pcall(function() purchaseBaitRemote:FireServer(baitName) end)
                        task.wait(0.1)
                    end
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 5: KONFIG
-- ==========================================
local TabKonfig = Window:CreateTab("Konfig", 4483362458)

local NewConfigName = ""
local SelectedDropdownConfig = ""

TabKonfig:CreateParagraph({Title = "Buat Config Baru", Content = "Ketik nama di bawah ini lalu tekan Create."})

TabKonfig:CreateInput({
    Name = "Nama Config Baru", PlaceholderText = "Ketik nama...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) NewConfigName = Text end,
})

local ConfigDropdown

TabKonfig:CreateButton({
    Name = "Create SC (Buat Baru)",
    Callback = function()
        if NewConfigName == "" or NewConfigName == "Kosong" then return end
        local HttpService = game:GetService("HttpService")
        local dataToSave = {
            SavedLoopTime = Settings.LoopTime,
            SavedPlace = Settings.SelectedPlace,
            SavedGears = Settings.SelectedGears,
            SavedBaits = Settings.SelectedBaits
        }
        writefile(FolderName .. "/" .. NewConfigName .. ".json", HttpService:JSONEncode(dataToSave))
        Rayfield:Notify({Title = "Berhasil!", Content = "Config dibuat.", Duration = 3})
        ConfigDropdown:Refresh(GetSavedConfigs(), true)
    end,
})

TabKonfig:CreateDivider()
TabKonfig:CreateParagraph({Title = "Daftar Config Tersimpan", Content = "Pilih lalu Load atau Overwrite."})

local InitialConfigs = GetSavedConfigs()
ConfigDropdown = TabKonfig:CreateDropdown({
    Name = "Pilih Config", Options = InitialConfigs,
    CurrentOption = {InitialConfigs[1]}, MultipleOptions = false, Flag = "SavedConfigs",
    Callback = function(Options) SelectedDropdownConfig = Options[1] end,
})

TabKonfig:CreateButton({
    Name = "Overwrite Terpilih",
    Callback = function()
        if SelectedDropdownConfig == "" or SelectedDropdownConfig == "Kosong" then return end
        local HttpService = game:GetService("HttpService")
        local dataToSave = {
            SavedLoopTime = Settings.LoopTime,
            SavedPlace = Settings.SelectedPlace,
            SavedGears = Settings.SelectedGears,
            SavedBaits = Settings.SelectedBaits
        }
        writefile(FolderName .. "/" .. SelectedDropdownConfig .. ".json", HttpService:JSONEncode(dataToSave))
        Rayfield:Notify({Title = "Overwritten!", Content = "Config diperbarui.", Duration = 3})
    end,
})

TabKonfig:CreateButton({
    Name = "Muat (Load) Terpilih",
    Callback = function()
        if SelectedDropdownConfig == "" or SelectedDropdownConfig == "Kosong" then return end
        local filePath = FolderName .. "/" .. SelectedDropdownConfig .. ".json"
        
        if isfile(filePath) then
            local decodedData = game:GetService("HttpService"):JSONDecode(readfile(filePath))
            
            Settings.LoopTime = decodedData.SavedLoopTime or 1
            Settings.SelectedPlace = decodedData.SavedPlace or "1"
            Settings.SelectedGears = decodedData.SavedGears or {}
            Settings.SelectedBaits = decodedData.SavedBaits or {}
            
            -- Memperbarui Tampilan UI agar sinkron dengan yang diload
            LoopTimeSlider:Set(Settings.LoopTime)
            HomePlaceDropdown:Set({Settings.SelectedPlace})
            GearDropdownUI:Set(Settings.SelectedGears)
            BaitDropdownUI:Set(Settings.SelectedBaits)
            
            Rayfield:Notify({Title = "Berhasil Dimuat!", Content = "Config digunakan.", Duration = 3})
        end
    end,
})
