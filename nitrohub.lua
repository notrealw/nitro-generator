

repeat wait() until game:IsLoaded() 
    game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
  Name = "nitrohub by raven (native anti afk)",
  LoadingTitle = "loading...",
  LoadingSubtitle = "by syn_raven#0999",
  ConfigurationSaving = {
     Enabled = true,
     FolderName = nil, -- Create a custom folder for your hub/game
     FileName = "Big Hub"
  },
  Discord = {
     Enabled = false,
     Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
     RememberJoins = true -- Set this to false to make them join the discord every time they load it up
  },
  KeySystem = false, -- Set this to true to use our key system
  KeySettings = {
     Title = "Untitled",
     Subtitle = "Key System",
     Note = "No method of obtaining the key is provided",
     FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
     SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
     GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
     Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
  }
})


local Tab1 = Window:CreateTab("Generator", 4483362458)
local Tab2 = Window:CreateTab("Auto Gen", 4483362458)
local Tab = Window:CreateTab("Checker", 4483362458)

getgenv().NitroForCheck = nil
getgenv().SelectedNitro = "Gift"
getgenv().AutoCheck = false
getgenv().AutoGen = false
getgenv().Webhook = nil



local function randomstring(comprimento)
  local stringAleatoria = ""
  local caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

  for i = 1, comprimento do
      local indice = math.random(1, #caracteres)
      local caractere = string.char(caracteres:byte(indice))
      stringAleatoria = stringAleatoria .. caractere
  end

  return stringAleatoria
end

local function gerarnitro()
  if SelectedNitro == "Gift" then
    return randomstring(16)
  elseif SelectedNitro == "Promotional" then
    return randomstring(24)
  end
end



local function checknitro(code)
  local url = "https://discordapp.com/api/v9/entitlements/gift-codes/"..code.."?with_application=false&with_subscription_plan=true"
  local response = http_request({Url=url, Method="GET"})
  if response.StatusCode == 200 then
    Rayfield:Notify({
      Title = "Nitro Checked",
      Content = "its a valid nitro bro!",
      Duration = 3,
      Image = 4483362458,
    })

  elseif response.StatusCode ~= 200 then
    Rayfield:Notify({
      Title = "Nitro Checked",
      Content = "its a invalid nitro bro :/",
      Duration = 3,
      Image = 4483362458,

    })
  end
end

local function sendwebhook(nitro, amount)
  local headers = {["content-type"] = "application/json"}
  local Body =
  {
    ["content"] = nil,
    ["embeds"] = {
      {
        ["title"] = "Nitro Logs",
        ["description"] = "```diff\n+ Você gerou um nitro válido!\n```",
        ["color"] = tonumber(0x2ce85f),
        ["fields"] = {
          {
            ["name"] = "Nitro",
            ["value"] = nitro,
            ["inline"] = true
          },
          {
            ["name"] = "Nitros Gerados",
            ["value"] = amount,
            ["inline"] = true
          }
        },
        ["image"] = {
          ["url"] = "https://cdn.discordapp.com/attachments/1099772468606025768/1117660451875061811/image.png"
        },
        ["thumbnail"] = {
          ["url"] = "https://assets-global.website-files.com/6257adef93867e50d84d30e2/62a315f45888ab5517509314_b941bc1dfe379db6cc1f2acc5a612f41.png"
        }
      }
  },
    ["attachments"] = {},
  }

  local RealBody = game:GetService('HttpService'):JSONEncode(Body)
  http_request({Url=Webhook, Body=RealBody, Method="POST", Headers=headers})
end

local function autogen()
  local nitrosgenerated = 0
  while AutoGen do
    if SelectedNitro == "Promotional" then
      local nitro = gerarnitro()
      local nitrosowithurl = "https://discord.com/billing/promotions/"..nitro
      local url = "https://discordapp.com/api/v9/entitlements/gift-codes/"..nitro.."?with_application=false&with_subscription_plan=true"
      local response = http_request({Url=url, Method="GET"})
      nitrosgenerated += 1
      Label2:Set("Nitros Generated: "..nitrosgenerated)
      if response.StatusCode == 200 then
        sendwebhook(nitrosowithurl, nitrosgenerated)
      end
    elseif SelectedNitro == "Gift" then
      local nitro = gerarnitro()
      local nitrosowithurl = "https://discord.gift/"..nitro
      local url = "https://discordapp.com/api/v9/entitlements/gift-codes/"..nitro.."?with_application=false&with_subscription_plan=true"
      local response = http_request({Url=url, Method="GET"})
      nitrosgenerated += 1
      Label2:Set("Nitros Generated: "..nitrosgenerated)
      if response.StatusCode == 200 then
        sendwebhook(nitrosowithurl, nitrosgenerated)
      end
    end
    wait()
  end
end

local Dropdown = Tab1:CreateDropdown({
  Name = "Nitro Type",
  Options = {"Gift","Promotional"},
  CurrentOption = {"Gift"},
  MultipleOptions = false,
  Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
  Callback = function(Option)
    SelectedNitro = unpack(Option)
  end,
})

local Label = Tab1:CreateLabel("Nitro: ")

local Toggle = Tab1:CreateToggle({
  Name = "Auto Check",
  CurrentValue = false,
  Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
  Callback = function(Value)
    AutoCheck = Value
  end,
})


local Button = Tab1:CreateButton({
  Name = "Generate a Random Nitro",
  Callback = function()
    if SelectedNitro == "Promotional" then
      local nitroso = gerarnitro()
      local nitrosowithurl = "https://discord.com/billing/promotions/"..nitroso
      Label:Set("Nitro: "..nitrosowithurl)
      setclipboard(nitrosowithurl)
      if AutoCheck then
        checknitro(nitroso)
      end
    elseif SelectedNitro == "Gift" then
      local nitroso = gerarnitro()
      local nitrosowithurl = "https://discord.gift/"..nitroso
      Label:Set("Nitro: "..nitrosowithurl)
      setclipboard(nitrosowithurl)
      if AutoCheck then
        checknitro(nitroso)
      end
    end
  end,
})

local Section = Tab2:CreateSection("Config")

local Label5 = Tab2:CreateLabel("the type of nitro is the same as in the previous tab")

local Input = Tab2:CreateInput({
  Name = "Your Webhook",
  PlaceholderText = "webhook here",
  RemoveTextAfterFocusLost = false,
  Callback = function(Text)
    Webhook = Text
  end,
})

local Section = Tab2:CreateSection("Auto Gen")

Label2 = Tab2:CreateLabel("Nitros generated: ")

local Toggle = Tab2:CreateToggle({
  Name = "Auto Gen",
  CurrentValue = false,
  Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
  Callback = function(Value)
    AutoGen = Value
    autogen()
  end,
})


local Input = Tab:CreateInput({
  Name = "Nitro Code",
  PlaceholderText = "nitro here",
  RemoveTextAfterFocusLost = false,
  Callback = function(Text)
    NitroForCheck = Text
  end,
})

local Button = Tab:CreateButton({
  Name = "Check Nitro",
  Callback = function()
    checknitro(NitroForCheck)
  end,
})

