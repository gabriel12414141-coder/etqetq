local Players = game:GetService("Players")

local player = Players.LocalPlayer

print("LOCALPLAYER:", player)
print("PLAYERGUI:", player and player:FindFirstChild("PlayerGui"))

if player then
    player:WaitForChild("PlayerGui"):SetAttribute("FruitNotifierTest", true)
    print("FRUIT NOTIFIER TESTE EXECUTADO")
end
