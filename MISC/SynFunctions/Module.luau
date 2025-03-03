--!nocheck
--!native

--[[
	This is a WIP project.
	The goal is to re-create most Synapse X Functions into pure LuaU.
	
	In order to use this, you need a custom LUA VM module and combine the enviroment with this custom one.
	
        --------------
    
	Current \ working functions:
	
	hookmetamethod,
	newcclosure,
	
	checkcaller (Broken)
	getgenv
	
	getscripts
	getinstances
	
	isreadonly
	gethiddenproperty
	
	--------------
	
	Soon:
	
	httpget
	hookfunction
	getrawmetatable
	
	
       --------------

	Maybe cant do:
	hookfunction
	
	--------------
	
	I know for sure you cant do these in pure luau :
	
	actual newcclosure

	getreg
	getgc ( Even with a custom lua VM)
	
	setreadonl
	sethiddenproperty
	
	getnilinstances
	
]]

-- Author: WATDAHECKLOL32.
-- Date:   3/1/25.
-- License: MIT License.

local __typeof = typeof;
local __info = debug.info;

local hooks = {};
local GameScripts = {};

local insert = table.insert;
local remove = table.remove;

local freeze = table.freeze;
local isfrozen = table.isfrozen;

local UGCValidationService = game:FindService("UGCValidationService");

local custom_typeof = function(target: any) : (any)
	local real_typeof = typeof(target);

	if real_typeof == "table" then
		if getmetatable(target) == "The metatable is locked" then
			return "Instance";
		else
			return real_typeof;
		end;
	else
		return real_typeof;
	end;
end;
local typeof = custom_typeof;



local a = function()
	return{
		gethiddenproperty = function(object: Instance, property: string): (any, boolean)
			local Success1, Check1 = pcall(function()
				return object[property];
			end);

			if Success1 then
				return Check1, false;
			else
				local Success2, Check2 = pcall(function()
					return UGCValidationService:GetPropertyValue(object, property)
				end);

				if Success2 then
					return Check2, true;
				else
					error("Property " .. property .. " does not exist in instance " .. tostring(object) .. ".");
				end;
			end;
		end,

		isfrozen = function(table) : (boolean)
			return isfrozen(table);
		end,

		getscripts = function() : ({LuaSourceContainer})
			return GameScripts
		end,

		getinstances = function() : ({Instance})
			return game:GetDescendants();	
		end,

		newcclosure = function(f: (RBXScriptConnection)) : (RBXScriptConnection)
			return f;
		end;
		
		compareinstances = function()
			
		end,

		checkcaller = function() : (boolean)
			return false;
		end;

		hookmetamethod = function(real_instance: Instance, operand: {[string]: any}) : (any)
			local cached_name = tostring(real_instance);
			local user_data = newproxy(true);

			for key,value in {
				__index = function(self, Index)
					if operand[Index] then
						return operand[Index];
					else
						local target = real_instance[Index];

						if typeof(target) == "function" then
							return function(real_self, ...)
								return target(real_instance, ...);
							end;
						else
							return target;
						end;
					end;
				end,
				__newindex = function(self, Index, Value)			
					if operand[Index] then
						operand[Index] = Value;
					else
						real_instance[Index] = Value;
					end;
				end,
				__tostring = function()
					return cached_name;
				end,
				__call = function(...)
					return real_instance(...);
				end,
				__concat = function(_,arg)
					return real_instance..arg;
				end,
				__unm = function()
					return -real_instance
				end,
				__add = function(_,arg)
					return real_instance+arg;
				end,
				__sub = function(_,arg)
					return real_instance-arg;
				end,
				__mul = function(_,arg)
					return real_instance*arg;
				end,
				__div = function(_,arg)
					return real_instance/arg;
				end,
				__idiv = function(_,arg)
					return real_instance//arg;
				end,
				__mod = function(_,arg)
					return real_instance%arg;
				end,
				__pow = function(_,arg)
					return real_instance^arg;
				end,
				__lt = function(_,arg)
					return real_instance<arg;
				end,
				__le = function(_,arg)
					return real_instance<=arg;
				end,
				__len = function()
					return #real_instance;
				end,
				__eq = function(_,arg)
					return real_instance==arg;
				end,} do

				getmetatable(user_data)[key] = value;
			end;

			operand.Rawset = function(self, Index, Value)
				operand[Index] = Value;
			end;

			getmetatable(user_data).__metatable = "The metatable is locked";
			return user_data;
		end;	
	}
end

return a();
