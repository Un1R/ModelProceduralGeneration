local module = {}

local function GetRayParams(Datatable)
	local RaycastPararms = RaycastParams.new()
	RaycastPararms.FilterDescendantsInstances = Datatable.Filter
	return RaycastPararms
end

local function FindGround(Pos1,Pos2)
	local Type1, Type2 = typeof(Pos1), typeof(Pos2)
	local NewRay = workspace:Raycast(Pos1,Pos2,GetRayParams({Filter = {workspace.GENP,workspace}}))
	local Pos
	
	local S,E = pcall(function()
		Pos = NewRay.Position
	end)
	if Pos ~= nil then
		return Vector3.new(Pos.X,Pos.Y - 16,Pos.Z)
	elseif Pos == nil then
		return nil
	end
end

module.GetDataTable = function(Part)
	local tab = {
		MaxX = nil;
		MinX = nil;
		MaxY = nil;
		MinY = nil;
		MaxZ = nil;
		MinZ = nil;
		instance = nil;
	}
	
	local OldSize = Part.Size
	local OldPos = Part.Position
	
	tab.MaxX = OldPos.X
	Part.Size = Vector3.new(1,OldSize.Y,OldSize.Z)
	tab.MinX = Part.Position.X - 710
	Part.Size = OldSize
	
	tab.MaxY = OldPos.Y
	Part.Size = Vector3.new(OldSize.X,1,OldSize.Z)
	tab.MinY = Part.Position.Y - 5
	Part.Size = OldSize
	
	tab.MaxZ = OldPos.Z
	Part.Size = Vector3.new(OldSize.X,OldSize.Y,1)
	tab.MinZ = Part.Position.Z - 710
	Part.Size = OldSize
	return tab
end

module.GenerateModelAround = function(datatable)
	local MinX = datatable.MinX
	local MaxX = datatable.MaxX
	local MinY = datatable.MinY
	local MaxY = datatable.MaxY
	local MaxZ = datatable.MaxZ
	local MinZ = datatable.MinZ
	local x
	local y
	local z
	if MinX > MaxX then
		x = math.random(MaxX,MinX)
	elseif MaxX > MinX then
		x = math.random(MinX,MaxX)
	end
	
	if MinY > MaxY then
		y = math.random(MaxY,MinY)
	elseif MaxY > MinY then
		y = math.random(MinY,MaxY)
	end
	
	if MinZ > MaxZ then
		z = math.random(MaxZ,MinZ)
	elseif MaxZ > MinZ then
		z = math.random(MinZ,MaxZ)
	end
	
	local self = {};
	self.GetCFrame = function(x,y,z)
		return CFrame.new(x,y,z)
	end
	self.GetVector3 = function(x,y,z)
		return Vector3.new(x,y,z)
	end
	
	local Type = datatable.instance.ClassName
	if Type ~= "Model" then
		datatable.instance.Position = self.GetVector3(x,y,z)
		local Ground = FindGround(datatable.instance.PrimaryPart.Position,Vector3.new(0,-700,0))
		if Ground then
			datatable.instance.Position = Ground
		else end
	else
		datatable.instance:SetPrimaryPartCFrame(self.GetCFrame(x,y,z))
		local Ground = FindGround(datatable.instance.PrimaryPart.Position,Vector3.new(0,-700,0))
		if Ground then
			datatable.instance:SetPrimaryPartCFrame(CFrame.new(Ground))
		else end
	end
end

return module
