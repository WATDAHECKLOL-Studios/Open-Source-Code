--!nonstrict
--!native

local HelicopterClass = {};

HelicopterClass.__index = HelicopterClass;
HelicopterClass.__mode = "KV";

warn("[Flux/Server] Loaded HelicopterClass");

local wait, delay, spawn, defer = task.wait, task.delay, task.spawn, task.defer;
local include = shared.import;

local require = include("require");
local CreateAnimation = require("CreateAnimation");

local TweenService = game:FindService("TweenService");

function HelicopterClass.new(Helicopter: (any) )
	assert(Helicopter);
		
	local self = setmetatable({}, HelicopterClass);
	
	self.Helicopter = Helicopter;	
	self.SpinSFX = self.Helicopter.Apache1Rotor.Heli
	
	-- defer
	return self;
end;

function HelicopterClass:Deploy()
	self.Helicopter.Parent = workspace
	self.DeployAnimation = CreateAnimation.new(self.Helicopter.AnimationController.Animator, 78077063263630);
	
	self.DeployAnimation:Play(0.2)
	self.SpinSFX:Play()
	
	wait(39);
	
	self.Helicopter:Destroy();
	self = nil
end;

return HelicopterClass;
