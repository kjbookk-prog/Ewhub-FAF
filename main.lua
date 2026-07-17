-- Memuat UI Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Auto Place Hub",
    LoadingTitle = "Memuat Script...",
    LoadingSubtitle = "by Executor",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false
})

-- Variabel Global untuk Pengaturan
local Settings = {
    LoopTime = 1,
    SelectedPlace = "1",
    AutoPlaceEnabled = false
}

local FolderName = "AutoPlaceConfigs"

-- Fungsi untuk membuat folder config jika belum ada
if not isfolder(FolderName) then
    makefolder(FolderName)
end

-- Fungsi untuk mengambil daftar config yang tersimpan
local function GetSavedConfigs()
    local configs = {}
    if isfolder(FolderName) then
        local files = listfiles(FolderName)
        for _, file in ipairs(files) do
            -- Mengambil nama file tanpa ekstensi .json dan tanpa path folder
            local fileName = file:match("([^/\\]+)%.json$")
            if fileName then
                table.insert(configs, fileName)
            end
        end
    end
    
    -- Jika tidak ada file config sama sekali
    if #configs == 0 then
        return {"Kosong"}
    end
    return configs
end

-- Variabel Remote & Koordinat
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local placeBuildingRemote = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("remo"):WaitForChild("src"):WaitForChild("container"):WaitForChild("ponds.placeBuilding")

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
    Name = "Waktu Loop (Detik)",
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
                        local args = {
                            [1] = "booster",
                            [2] = "SupremeFoodTray",
                            [3] = pos
                        }
                        pcall(function()
                            placeBuildingRemote:InvokeServer(unpack(args))
                        end)
                    end
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 2: KONFIG
-- ==========================================
local Tab2 = Window:CreateTab("Konfig", 4483362458)

local NewConfigName = ""
local SelectedDropdownConfig = ""

Tab2:CreateParagraph({Title = "Buat Config Baru", Content = "Ketik nama di bawah ini lalu tekan Create untuk membuat file config baru."})

local ConfigInput = Tab2:CreateInput({
    Name = "Nama Config Baru",
    PlaceholderText = "Ketik nama config...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        NewConfigName = Text
    end,
})

local ConfigDropdown -- Dideklarasikan lebih awal agar bisa diakses oleh tombol Create

Tab2:CreateButton({
    Name = "Create SC (Buat Baru)",
    Callback = function()
        if NewConfigName == "" or NewConfigName == "Kosong" then
            Rayfield:Notify({Title = "Gagal", Content = "Nama config tidak boleh kosong!", Duration = 3})
            return
        end

        local HttpService = game:GetService("HttpService")
        local dataToSave = {
            SavedLoopTime = Settings.LoopTime,
            SavedPlace = Settings.SelectedPlace
        }
        
        writefile(FolderName .. "/" .. NewConfigName .. ".json", HttpService:JSONEncode(dataToSave))
        
        Rayfield:Notify({Title = "Berhasil!", Content = "Config '" .. NewConfigName .. "' dibuat.", Duration = 3})
        
        -- Refresh Dropdown setelah membuat config baru
        ConfigDropdown:Refresh(GetSavedConfigs(), true)
    end,
})

Tab2:CreateDivider()

Tab2:CreateParagraph({Title = "Daftar Config Tersimpan", Content = "Pilih config dari menu di bawah untuk di Load atau di Overwrite."})

local InitialConfigs = GetSavedConfigs()
ConfigDropdown = Tab2:CreateDropdown({
    Name = "Pilih Config",
    Options = InitialConfigs,
    CurrentOption = {InitialConfigs[1]},
    MultipleOptions = false,
    Flag = "SavedConfigsDropdown",
    Callback = function(Options)
        SelectedDropdownConfig = Options[1]
    end,
})

Tab2:CreateButton({
    Name = "Overwrite Terpilih",
    Callback = function()
        if SelectedDropdownConfig == "" or SelectedDropdownConfig == "Kosong" then
            Rayfield:Notify({Title = "Gagal", Content = "Tidak ada config yang dipilih untuk di-overwrite.", Duration = 3})
            return
        end

        local HttpService = game:GetService("HttpService")
        local dataToSave = {
            SavedLoopTime = Settings.LoopTime,
            SavedPlace = Settings.SelectedPlace
        }
        
        writefile(FolderName .. "/" .. SelectedDropdownConfig .. ".json", HttpService:JSONEncode(dataToSave))
        
        Rayfield:Notify({Title = "Overwritten!", Content = "Config '" .. SelectedDropdownConfig .. "' berhasil diperbarui.", Duration = 3})
    end,
})

Tab2:CreateButton({
    Name = "Muat (Load) Terpilih",
    Callback = function()
        if SelectedDropdownConfig == "" or SelectedDropdownConfig == "Kosong" then
            Rayfield:Notify({Title = "Gagal", Content = "Tidak ada config untuk dimuat.", Duration = 3})
            return
        end

        local filePath = FolderName .. "/" .. SelectedDropdownConfig .. ".json"
        
        if isfile(filePath) then
            local HttpService = game:GetService("HttpService")
            local fileData = readfile(filePath)
            local decodedData = HttpService:JSONDecode(fileData)
            
            Settings.LoopTime = decodedData.SavedLoopTime or 1
            Settings.SelectedPlace = decodedData.SavedPlace or "1"
            
            LoopTimeSlider:Set(Settings.LoopTime)
            HomePlaceDropdown:Set({Settings.SelectedPlace})
            
            Rayfield:Notify({Title = "Berhasil Dimuat!", Content = "Config '" .. SelectedDropdownConfig .. "' sedang digunakan.", Duration = 3})
        else
            Rayfield:Notify({Title = "Error", Content = "File config tidak ditemukan di sistem.", Duration = 3})
        end
    end,
})
