local oldGame = game;
local newRandom = Random.new();

local mine = {
	["GetAutismLevel"] = function(UserID: (number) )
		assert(UserID, "You must provide a vaild UserId");
		local random = newRandom:NextInteger(1, 100);
		local new = "This user is ".. tostring(random).."% ".."Autistic!"
		return new;
	end;
};

_G.s = function()
	getfenv(2).game = setmetatable({}, {
		__index = function(self, index)
			return mine[index] or function(_, ...)
				return oldGame[index](oldGame, ...);
			end;
		end;
		__metatable = "The metatable is locked";
	});
end;
