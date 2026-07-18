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

    -- Variabel Auto Craft
    SelectedCraftGear = "TimeJumper",
    AutoCraftTime = 1,
    AutoCraftEnabled = false,
    AutoTakeTime = 1,
    AutoTakeEnabled = false
}

-- DAFTAR NAMA ITEM 
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

-- ==========================================
-- RESEP CRAFTING (MUDAH DITAMBAH)
-- ==========================================
-- Kamu bisa menambahkan gear lain beserta bahan-bahannya di bawah ini
local CraftingRecipes = {
    ["TimeJumper"] = {
        "TeleportWand", "TeleportWand", "TeleportWand", "TeleportWand", "TeleportWand", 
        "TeleportWand", "TeleportWand", "TeleportWand", "TeleportWand", "TeleportWand",
        "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass", 
        "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass", 
        "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass", 
        "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass", 
        "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass", "MagnifyingGlass",
        "SupremeAutoFeeder"
    },
    -- Contoh cara menambah resep baru:
    -- ["NamaGearBaru"] = {
    --     "Bahan1", "Bahan2", "Bahan3"
    -- }
}

-- Mengambil nama-nama gear yang ada di CraftingRecipes secara otomatis untuk Dropdown
local DaftarCrafting = {}
for gearName, _ in pairs(CraftingRecipes) do
    table.insert(DaftarCrafting, gearName)
end

local FolderName = "AutoHubConfigs"
if not isfolder(FolderName) then 
    makefolder(FolderName) 
end

-- Fungsi untuk mengambil daftar config yang tersimpan
local function GetSavedConfigs()
    local configs = {}
    if isfolder(FolderName) then
        for _, file in ipairs(listfiles(FolderName)) do
            local fileName = file:match("([^/\\]+)%.json$")
            if fileName then 
                table.insert(configs, fileName) 
            end
        end
    end
    return #configs == 0 and {"Kosong"} or configs
end

local PlaceCoordinates = {
    ["1"] = Vector3.new(76.86399841308594, -0.012000083923339844, 368),
    ["2"] = Vector3.new(-143.13600158691406, -0.012000083923339844, 371),
    ["3"] = Vector3.new(29.863998413085938, -0.012000083923339844, 129),
    ["4"] = Vector3.new(-127.13600158691406, -0.012000083923339844, 124),
    ["5"] = Vector3.new(14.863998413085938, -0.012000083923339844, 23),
    ["6"] = Vector3.new(-144.13600158691406, -0.012000083923339844, -34)
}

-- Fungsi dinamis untuk mengambil remote agar tidak memblokir script di awal
local function GetRemoteContainer()
    return game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include", 5):WaitForChild("node_modules", 5):WaitForChild("@rbxts", 5):WaitForChild("remo", 5):WaitForChild("src", 5):WaitForChild("container", 5)
end

-- ==========================================
-- TAB 1: AUTO PLACE
-- ==========================================
local Tab1 = Window:CreateTab("Auto Place", 4483362458) 

local LoopTimeSlider = Tab1:CreateSlider({
    Name = "Waktu Loop (Semua Fitur Utama)",
    Range = {0.1, 10}, 
    Increment = 0.1, 
    Suffix = "Detik",
    CurrentValue = Settings.LoopTime, 
    Flag = "LoopTimeSlider",
    Callback = function(Value) 
        Settings.LoopTime = Value 
    end,
})

local HomePlaceDropdown = Tab1:CreateDropdown({
    Name = "Home Place", 
    Options = {"1", "2", "3", "4", "5", "6"},
    CurrentOption = {"1"}, 
    MultipleOptions = false, 
    Flag = "HomePlaceDropdown",
    Callback = function(Options) 
        Settings.SelectedPlace = Options[1] 
    end,
})

Tab1:CreateToggle({
    Name = "Mulai Auto Place", 
    CurrentValue = false, 
    Flag = "AutoPlaceToggle",
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
    Name = "Feed DrFallout",
    CurrentValue = false, 
    Flag = "FeedDrFalloutToggle",
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
    Name = "Pilih Gear (Bisa Tumpuk)",
    Options = DaftarGears,
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "GearDropdown",
    Callback = function(Options)
        Settings.SelectedGears = Options
    end,
})

TabGear:CreateToggle({
    Name = "Auto Buy Gear", 
    CurrentValue = false, 
    Flag = "AutoBuyGearToggle",
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
    Name = "Auto Buy Bait", 
    CurrentValue = false, 
    Flag = "AutoBuyBaitToggle",
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
-- TAB 5: AUTO CRAFT (NEW)
-- ==========================================
local TabCraft = Window:CreateTab("Auto Craft", 4483362458)

local CraftGearDropdown = TabCraft:CreateDropdown({
    Name = "Pilih Gear untuk Craft",
    Options = #DaftarCrafting > 0 and DaftarCrafting or {"Kosong"},
    CurrentOption = #DaftarCrafting > 0 and {DaftarCrafting[1]} or {"Kosong"},
    MultipleOptions = false,
    Flag = "CraftGearDropdown",
    Callback = function(Options)
        Settings.SelectedCraftGear = Options[1]
        
        -- Mengeksekusi pemilihan item crafting ke server saat user memilih di dropdown
        if Settings.SelectedCraftGear and Settings.SelectedCraftGear ~= "Kosong" then
            pcall(function()
                local container = GetRemoteContainer()
                if container and container:FindFirstChild("crafting.selectCraftingItem") then
                    container["crafting.selectCraftingItem"]:FireServer(Settings.SelectedCraftGear, "gear")
                end
            end)
        end
    end,
})

local AutoCraftSlider = TabCraft:CreateSlider({
    Name = "Waktu Auto Craft Gear",
    Range = {0.1, 10}, 
    Increment = 0.1, 
    Suffix = "Detik",
    CurrentValue = Settings.AutoCraftTime, 
    Flag = "AutoCraftSlider",
    Callback = function(Value) 
        Settings.AutoCraftTime = Value 
    end,
})

TabCraft:CreateToggle({
    Name = "Mulai Auto Craft Gear", 
    CurrentValue = false, 
    Flag = "AutoCraftToggle",
    Callback = function(Value)
        Settings.AutoCraftEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoCraftEnabled do
                    if Settings.SelectedCraftGear and Settings.SelectedCraftGear ~= "Kosong" then
                        local resep = CraftingRecipes[Settings.SelectedCraftGear]
                        
                        pcall(function()
                            local container = GetRemoteContainer()
                            if container then
                                -- Submit Items
                                if container:FindFirstChild("crafting.submitItems") and resep then
                                    container["crafting.submitItems"]:FireServer(resep, "gear")
                                end
                                task.wait(0.2) -- Jeda kecil agar tidak overlap di server
                                -- Start Craft
                                if container:FindFirstChild("crafting.startCraft") then
                                    container["crafting.startCraft"]:FireServer("gear")
                                end
                            end
                        end)
                    end
                    task.wait(Settings.AutoCraftTime)
                end
            end)
        end
    end,
})

TabCraft:CreateDivider()

local AutoTakeSlider = TabCraft:CreateSlider({
    Name = "Waktu Auto Take Gear",
    Range = {0.1, 10}, 
    Increment = 0.1, 
    Suffix = "Detik",
    CurrentValue = Settings.AutoTakeTime, 
    Flag = "AutoTakeSlider",
    Callback = function(Value) 
        Settings.AutoTakeTime = Value 
    end,
})

TabCraft:CreateToggle({
    Name = "Mulai Auto Take Gear", 
    CurrentValue = false, 
    Flag = "AutoTakeToggle",
    Callback = function(Value)
        Settings.AutoTakeEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoTakeEnabled do
                    pcall(function()
                        local container = GetRemoteContainer()
                        if container and container:FindFirstChild("crafting.collectCraft") then
                            container["crafting.collectCraft"]:FireServer("gear")
                        end
                    end)
                    task.wait(Settings.AutoTakeTime)
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
    Name = "Nama Config Baru", 
    PlaceholderText = "Ketik nama...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) 
        NewConfigName = Text 
    end,
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
            
            -- Menyimpan opsi Auto Craft
            SavedCraftGear = Settings.SelectedCraftGear,
            SavedAutoCraftTime = Settings.AutoCraftTime,
            SavedAutoTakeTime = Settings.AutoTakeTime
        }
        
        writefile(FolderName .. "/" .. NewConfigName .. ".json", HttpService:JSONEncode(dataToSave))
        Rayfield:Notify({Title = "Berhasil!", Content = "Config dibuat.", Duration = 3})
        
        ConfigDropdown:Refresh(GetSavedConfigs(), true)
    end,
})

local InitialConfigs = GetSavedConfigs()
ConfigDropdown = TabKonfig:CreateDropdown({
    Name = "Pilih Config", 
    Options = InitialConfigs,
    CurrentOption = {InitialConfigs[1]}, 
    MultipleOptions = false, 
    Flag = "SavedConfigs",
    Callback = function(Options) 
        SelectedDropdownConfig = Options[1] 
    end,
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
            
            SavedCraftGear = Settings.SelectedCraftGear,
            SavedAutoCraftTime = Settings.AutoCraftTime,
            SavedAutoTakeTime = Settings.AutoTakeTime
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
            
            Settings.SelectedCraftGear = decodedData.SavedCraftGear or "TimeJumper"
            Settings.AutoCraftTime = decodedData.SavedAutoCraftTime or 1
            Settings.AutoTakeTime = decodedData.SavedAutoTakeTime or 1
            
            -- Update UI
            LoopTimeSlider:Set(Settings.LoopTime)
            HomePlaceDropdown:Set({Settings.SelectedPlace})
            GearDropdownUI:Set(Settings.SelectedGears)
            BaitDropdownUI:Set(Settings.SelectedBaits)
            
            CraftGearDropdown:Set({Settings.SelectedCraftGear})
            AutoCraftSlider:Set(Settings.AutoCraftTime)
            AutoTakeSlider:Set(Settings.AutoTakeTime)
            
            Rayfield:Notify({Title = "Berhasil Dimuat!", Content = "Config digunakan.", Duration = 3})
        end
    end,
})
