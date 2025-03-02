wait(1);

local hookmetamethod = shared.hookmetamethod;

local game: (game) = hookmetamethod(game, {
	GetService = function(Self, Service: (string) )
		return game:GetService("ReplicatedStorage");
	end,
})

print(game:GetService("ServerScriptService")) --> ReplicatedStorage
print(game:FindService("ServerScriptService")) --> ServerScriptService, because we didnt hook FindService.
