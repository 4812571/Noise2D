--[=[
    @class Noise2D

    A 2D noise object that can be used to generate noise. It is designed to be stateful, and 
    designed to feel similar in usage to Roblox's built in Random object.

    It uses math.noise() under the hood, and feeds the seed into the first argument.
]=]
local Noise2D = {}
Noise2D.__index = Noise2D

-- Note: This random object is only used to generate a seed if one is not provided.
-- It being a singleton is not a problem, as it is not used if the user provides a seed.
local random = Random.new()

type Noise2D = {
    new: (seed: number) -> Noise2D,
    Noise: (x: number, y: number, scale: number) -> number,
    UnitNoise: (x: number, y: number, scale: number) -> number,
    Range: (x: number, y: number, scale: number, range: number) -> boolean,
    EdgeRange: (x: number, y: number, scale: number, range: number) -> boolean,
}

--[=[
    Creates a new Noise2D object. If no seed is provided, a random seed will be
    generated using the module's internal Random object.
]=]
function Noise2D.new(seed: number?): Noise2D
	local self = setmetatable({}, Noise2D)
	self._seed = seed or random:NextInteger(-2^53, 2^53)
	return self
end

--[=[
    Returns a noise value between -scale and scale. This is the same as math.noise() except
    that the seed is fed into the first argument, and the scale is applied to the result.
]=]
function Noise2D:Noise(x: number, y: number, scale: number): number
	return math.noise(x / scale, y / scale, self._seed)
end

--[=[
    Returns a noise value between 0 and scale. This is the same as Noise2D:Noise() except
    that the result is shifted and scaled to be between 0 and scale.
]=]
function Noise2D:UnitNoise(x: number, y: number, scale: number): number
	local rawNoise = self:Noise(x, y, scale)
	return (rawNoise + 1) / 2
end

--[=[
    Returns true if the noise value is between -range and range. This is the same as
    Noise2D:Noise() except that the result is checked to be within the range.

    This range is from the center of the distribution, going outwards as you increase range.
]=]
function Noise2D:Range(x: number, y: number, scale: number, range: number): boolean
	local rawNoise = self:Noise(x, y, scale)
	return math.abs(rawNoise) < range
end

--[=[
    Returns true if the unit noise value is between 0 and range. This is the same as
    Noise2D:UnitNoise() except that the result is checked to be within the range.

    This range is from the edge of the distribution, going towards the right as you increase range.
]=]
function Noise2D:EdgeRange(x: number, y: number, scale: number, range: number): boolean
	local unitNoise = self:UnitNoise(x, y, scale)
	return unitNoise < range
end

return Noise2D