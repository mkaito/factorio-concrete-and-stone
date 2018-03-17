local function replace(str, what, with)
    what = string.gsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
    with = string.gsub(with, "[%%]", "%%%%") -- escape replacement
    return string.gsub(str, what, with)
end

for _, picture in pairs(data.raw.wall["stone-wall"].pictures) do
	if picture.layers then
		for _, layer in pairs(picture.layers) do
			layer.filename = replace(layer.filename, "__base__", "__concrete-and-stone-016__")
		end
	else
		for _, variations in pairs(picture) do
			if variations.layers then
				for _, layer in pairs(variations.layers) do
					layer.filename = replace(layer.filename, "__base__", "__concrete-and-stone-016__")
				end
			end
		end
	end
end

local concrete = table.deepcopy(data.raw.wall["stone-wall"])
concrete.name = "concrete-wall"
concrete.minable = {
        mining_time = 0.5,
        result = "concrete-wall"
      }
for _, picture in pairs(concrete.pictures) do
	if picture.layers then
		for _, layer in pairs(picture.layers) do
			layer.filename = replace(layer.filename, "stone-wall", "concrete-wall")
		end
	else
		for _, variations in pairs(picture) do
			if variations.layers then
				for _, layer in pairs(variations.layers) do
					layer.filename = replace(layer.filename, "stone-wall", "concrete-wall")
				end
			end
		end
	end
end
concrete.max_health = 1000

data:extend({
	concrete,
  -- stone brick is 2 stone
  -- stone wall is 5 stone brick = 10 stone
  -- 10 concrete = 5 stone brick = 1 stone each
  {
		enabled = false,
		ingredients = {
			{ "stone-wall", 1 },
			{ "concrete", 12 }
		},
		name = "concrete-wall",
		requester_paste_multiplier = 10,
		result = "concrete-wall",
		type = "recipe"
  },
	{
		flags = {
			"goes-to-quickbar"
		},
		icon = "__concrete-and-stone-016__/graphics/icons/concrete-wall.png",
		icon_size = 32,
		name = "concrete-wall",
		order = "a[stone-wall]-b[concrete-wall]",
		place_result = "concrete-wall",
		stack_size = 50,
		subgroup = "defensive-structure",
		type = "item"
    },
})
data.raw.item["stone-wall"].icon = "__concrete-and-stone-016__/graphics/icons/stone-wall.png"
data.raw.recipe["concrete"].ingredients = {
	{
	  "stone-brick",
	  5
	},
	{
	  "iron-stick",
	  2
	},
	{
	  amount = 10,
	  name = "water",
	  type = "fluid"
	}
}

table.insert(data.raw["technology"]["concrete"].effects, {type = "unlock-recipe", recipe = "concrete-wall"})
