local __typeof = typeof;

local custom_typeof = function(target: any)
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

shared.hookmetamethod = function(real_instance: Instance, operand: {[string]: any})
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

