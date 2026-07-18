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
    AutoBuyBaitEnabled = false,

    SelectedEggs = {},
    AutoBuyEggEnabled = false
}

-- DAFTAR NAMA ITEM (Silakan tambah/ubah sesuai game)
local DaftarGears = {
    "BasicAutoFeeder", "FoodScoop", "BasicFoodTray", "MoveTool", 
    "MagnifyingGlass", "AdvancedFoodTray", "AdvancedAutoFeeder", 
    "XPCookie", "TeleportWand", "StarLock", "SupremeAutoFeeder", 
    "PetToy", "TradingTicket", "EggHatcher", "PetWhistle", 
    "GoldenCookie", "MutationBeacon", "EggIncubator", 
    "ExtremeAutoFeeder", "StormHorn", "GodlyAutoFeeder"
} 

local DaftarBaits = {
    "Starter", "Novice", "Reef", "DeepSea", "Koi", "River", 
    "Puffer", "Glo", "Seal", "Ray", "Octopus", "Axolotl", 
    "Jelly", "Whale", "Shark", "Squid", "Megalodon", 
    "Kraken", "Maw", "Bloop", "OceanEater", "Serpent"
}

local DaftarEggs = {
    "Starter", "Basic", "Forest", "Polar", "Tropical", "Exotic" -- Silakan ditambah lagi di sini
}

local FolderName = "AutoHubConfigs"
if not isfolder(FolderName) then makefolder(FolderName) end

-- Fungsi untuk mengambil daftar config
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

local PlaceCoordinates = {
    ["1"] = Vector3.new(32.36399841308594, -0.012000083923339844, 58.5),
    ["2"] = Vector3.new(69.36299896240234, -0.012000083923339844, 36.5),
    ["3"] = Vector3.new(30.363998413085938, -0.012000083923339844, -130.5),
    ["4"] = Vector3.new(-131.63600158691406,-0.012000083923339844, -125.5),
    ["5"] = Vector3.new(27.363998413085938, -0.012000083923339844, -387.5),
    ["6"] = Vector3.new(126.63600158691406, -0.012000083923339844, -368.5)
}

local function GetRemoteContainer()
    return game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include", 5):WaitForChild("node_modules", 5):WaitForChild("@rbxts", 5):WaitForChild("remo", 5):WaitForChild("src", 5):WaitForChild("container", 5)
end

-- ==========================================
-- TAB 1: AUTO PLACE
-- ==========================================
local Tab1 = Window:CreateTab("Auto Place", 4483362458) 

local LoopTimeSlider = Tab1:CreateSlider({
    Name = "Waktu Loop (Semua Fitur Utama)",
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
                        pcall(function() 
                            local container = GetRemoteContainer()
                            if container and container:FindFirstChild("ponds.placeBuilding") then
                                container["ponds.placeBuilding"]:InvokeServer("booster", "SupremeFoodTray", pos)
                            end
                        end)
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
    Name = "Feed DrFallout", CurrentValue = false, Flag = "FeedDrFalloutToggle",
    Callback = function(Value)
        Settings.FeedDrFalloutEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.FeedDrFalloutEnabled do
                    pcall(function() 
                        local container = GetRemoteContainer()
                        if container and container:FindFirstChild("nuke.feedDrFalloutAll") then
                            container["nuke.feedDrFalloutAll"]:FireServer() 
                        end
                    end)
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
    Name = "Pilih Gear (Bisa Tumpuk)", Options = DaftarGears,
    CurrentOption = {}, MultipleOptions = true, Flag = "GearDropdown",
    Callback = function(Options) Settings.SelectedGears = Options end,
})

TabGear:CreateToggle({
    Name = "Auto Buy Gear", CurrentValue = false, Flag = "AutoBuyGearToggle",
    Callback = function(Value)
        Settings.AutoBuyGearEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoBuyGearEnabled do
                    for _, gearName in ipairs(Settings.SelectedGears) do
                        pcall(function() 
                            local container = GetRemoteContainer()
                            if container and container:FindFirstChild("shop.purchaseGear") then
                                container["shop.purchaseGear"]:FireServer(gearName) 
                            end
                        end)
                        task.wait(0.1)
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
    Name = "Pilih Bait (Bisa Tumpuk)", Options = DaftarBaits,
    CurrentOption = {}, MultipleOptions = true, Flag = "BaitDropdown",
    Callback = function(Options) Settings.SelectedBaits = Options end,
})

TabBait:CreateToggle({
    Name = "Auto Buy Bait", CurrentValue = false, Flag = "AutoBuyBaitToggle",
    Callback = function(Value)
        Settings.AutoBuyBaitEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoBuyBaitEnabled do
                    for _, baitName in ipairs(Settings.SelectedBaits) do
                        pcall(function() 
                            local container = GetRemoteContainer()
                            if container and container:FindFirstChild("shop.purchaseBait") then
                                container["shop.purchaseBait"]:FireServer(baitName) 
                            end
                        end)
                        task.wait(0.1)
                    end
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 5: EGG SHOP
-- ==========================================
local TabEgg = Window:CreateTab("Egg Shop", 4483362458)

local EggDropdownUI = TabEgg:CreateDropdown({
    Name = "Pilih Egg (Bisa Tumpuk)", Options = DaftarEggs,
    CurrentOption = {}, MultipleOptions = true, Flag = "EggDropdown",
    Callback = function(Options) Settings.SelectedEggs = Options end,
})

TabEgg:CreateToggle({
    Name = "Auto Buy Egg", CurrentValue = false, Flag = "AutoBuyEggToggle",
    Callback = function(Value)
        Settings.AutoBuyEggEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoBuyEggEnabled do
                    for _, eggName in ipairs(Settings.SelectedEggs) do
                        pcall(function() 
                            local container = GetRemoteContainer()
                            if container and container:FindFirstChild("shop.purchaseEgg") then
                                container["shop.purchaseEgg"]:FireServer(eggName) 
                            end
                        end)
                        task.wait(0.1)
                    end
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 6: KONFIG
-- ==========================================
local TabKonfig = Window:CreateTab("Konfig", 4483362458)

local NewConfigName = ""
local SelectedDropdownConfig = ""

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
            SavedBaits = Settings.SelectedBaits,
            SavedEggs = Settings.SelectedEggs
        }
        writefile(FolderName .. "/" .. NewConfigName .. ".json", HttpService:JSONEncode(dataToSave))
        Rayfield:Notify({Title = "Berhasil!", Content = "Config dibuat.", Duration = 3})
        ConfigDropdown:Refresh(GetSavedConfigs(), true)
    end,
})

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
            SavedBaits = Settings.SelectedBaits,
            SavedEggs = Settings.SelectedEggs
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
            Settings.SelectedEggs = decodedData.SavedEggs or {}
            
            LoopTimeSlider:Set(Settings.LoopTime)
            HomePlaceDropdown:Set({Settings.SelectedPlace})
            GearDropdownUI:Set(Settings.SelectedGears)
            BaitDropdownUI:Set(Settings.SelectedBaits)
            EggDropdownUI:Set(Settings.SelectedEggs)
            
            Rayfield:Notify({Title = "Berhasil Dimuat!", Content = "Config digunakan.", Duration = 3})
        end
    end,
})
