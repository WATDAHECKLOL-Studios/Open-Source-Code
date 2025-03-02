wait(1);

local Real = game:GetService("HttpService");
local hookmetamethod = shared.hookmetamethod;

local Fake;
Fake = hookmetamethod(Real, {
	JSONEncode = function(Self, ...)
		local Args = {...};

		--[[print(Args[1])
		print(Args[1]["content"])]]

		for Index, Value in next, Args do
			print("----------")
			print(Index, Value)
			print("---------")
		end;

		Args[1]["content"] = "lol get rekt noob";

		return Real:JSONEncode(...);
	end,
});

local data = {["content"] = 'h'};
local Decoy = Fake:JSONEncode(data);

print(Decoy) --> this does print lol get rekt noob
