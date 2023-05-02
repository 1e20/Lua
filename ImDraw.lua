-- Immediate mode drawing for synapse x 
local Draw = Drawing.new;
local Insert, Remove = table.insert, table.remove;

local ImmediateDraw = { 
    Allocated = { };   
    Memory = { Line = { }; Square = { }; Circle = { }; Image = { }; Triangle = { }; Text = { }; };  
};

function ImmediateDraw:Draw(Type, Properties)
    local TypeCache = self.Memory[Type];
    local Object = TypeCache[1]; 

    if (not Object) then 
        Object = { Type = Type; Drawing = Draw(Type); };
    end;

    for p, v in pairs(Properties) do
        if (Object.Drawing[p] == v) then continue end;  
        Object.Drawing[p] = v;  
    end; 

    Remove(TypeCache, 1);
    Insert(self.Allocated, Object);
    return Object;
end; 

function ImmediateDraw:Release(ClearScreen)
    for allocationIndex = 1, #self.Allocated do 
        local Cache = self.Allocated[allocationIndex];
        Remove(self.Allocated, allocationIndex); 
        Insert(self.Memory[Cache.Type], Cache);

        if (ClearScreen) then 
            Cache.Drawing.Visible = false;
        end; 
    end; 
end;

function ImmediateDraw:Free()
    for t, c in pairs(self.Memory) do 
        for i = #c, 1, -1 do 
            local Cache = c[i];
            Cache.Drawing:Remove(); 
            Remove(c, i);
        end; 
    end; 
end; 

return ImmediateDraw;
