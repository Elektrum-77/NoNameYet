local Entity = 
{
  Furnace =
  {
    RecipeType = "Smelting",
    Width = 2,
    Height = 2,
    MaxInput = 1,
    MaxOutput = 1,
    Texture = love.graphics.newImage("Textures/Furnace.png"),
  },
  OreCrackingStation =
  {
    RecipeType = "OreCracking",
    Width = 2,
    Height = 2,
    MaxInput = 2,
    MaxOutput = 4,
  },
}

for k,v in pairs(Entity) do
  game.Prototypes.Entity[k] = v
end