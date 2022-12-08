
class('QuadTree').extends()

local quadTree <const> = QuadTree
local tableInsert <const> = table.insert

-- Create a new quad tree with the given bounds
function QuadTree:init(x, y, width, height, maxLeafSize)
    -- The bounds of this quad tree
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.maxLeafSize = maxLeafSize
    
    -- The objects in this quad tree
    self.objects = {}
    
    -- The child quad trees, if any
    self.topLeft = nil
    self.topRight = nil
    self.bottomLeft = nil
    self.bottomRight = nil
end

function QuadTree:rebuildQuadTree(objects)
    self.objects = {}
    -- The child quad trees, if any
    self.topLeft = nil
    self.topRight = nil
    self.bottomLeft = nil
    self.bottomRight = nil
    for i=1,#objects do
        self:insert(objects[i])
    end
end

-- Insert an object into the quad tree
function QuadTree:insert(object)
    -- If this quad tree is a leaf (has no children), and there are already objects
    -- in it, we need to split this quad tree into four quadrants and move the
    -- objects into the appropriate quadrants
    if self.topLeft == nil and #self.objects > self.maxLeafSize then
        -- Determine the center of this quad tree
        local centerX = self.x + self.width / 2
        local centerY = self.y + self.height / 2
        
        -- Create the four quadrants
        self.topLeft = quadTree(self.x, self.y, self.width / 2, self.height / 2, self.maxLeafSize)
        self.topRight = quadTree(centerX, self.y, self.width / 2, self.height / 2, self.maxLeafSize)
        self.bottomLeft = quadTree(self.x, centerY, self.width / 2, self.height / 2, self.maxLeafSize)
        self.bottomRight = quadTree(centerX, centerY, self.width / 2, self.height / 2, self.maxLeafSize)
        
        -- Move the objects into the appropriate quadrants
        for i=1,#self.objects do
            local obj = self.objects[i]
            local quadrant = self:getQuadrantForObject(obj)
            quadrant:insert(obj)
        end
        
        -- Clear the list of objects in this quad tree
        self.objects = {}
    end
    
    -- If this quad tree is not a leaf, insert the object into the appropriate
    -- quadrant
    if self.topLeft ~= nil then
        local quadrant = self:getQuadrantForObject(object)
        quadrant:insert(object)
    else
        -- Otherwise, add the object to this quad tree
        self.objects[#self.objects+1] = object
    end
end

-- Given an object, returns the quadrant it belongs to
function QuadTree:getQuadrantForObject(object)
    -- Determine the center of this quad tree
    local centerX = self.x + self.width / 2
    local centerY = self.y + self.height / 2
    
    -- Check which quadrant the object belongs to
    if object.x < centerX and object.y < centerY then
        return self.topLeft
    elseif object.x >= centerX and object.y < centerY then
        return self.topRight
    elseif object.x < centerX and object.y >= centerY then
        return self.bottomLeft
    else
        return self.bottomRight
    end
end

-- Find first object that intersects with the given bounds, and exits immediately 
function QuadTree:fastQuery(x, y, width, height, requester)
    -- If this quad tree does not intersect with the given bounds, return an empty list
    if x + width < self.x or x > self.x + self.width or y + height < self.y or y > self.y + self.height then
        return nil
    end

    -- If this quad tree is a leaf, return the first object that intersects with the given bounds
    if self.topLeft == nil then
        for i=1,#self.objects do
            local obj = self.objects[i]
            if obj ~= requester then
                if obj.x + obj.width >= x and obj.x <= x + width and obj.y + obj.height >= y and obj.y <= y + height then
                    return obj
                end
            end
        end
        return nil
    end

    -- Otherwise, query each quadrant
    local topLeft = self.topLeft:fastQuery(x, y, width, height, requester)
    if topLeft and topLeft ~= requester then
        return topLeft
    end
    local topRight = self.topRight:fastQuery(x, y, width, height, requester)
    if topRight and topRight ~= requester  then
        return topRight
    end
    local bottomLeft = self.bottomLeft:fastQuery(x, y, width, height, requester)
    if bottomLeft and bottomLeft ~= requester  then
        return bottomLeft
    end
    local bottomRight = self.bottomRight:fastQuery(x, y, width, height, requester)
    if bottomRight and bottomRight ~= requester then
        return bottomRight
    end
    return nil
end

-- Find all objects in the quad tree that intersect with the given bounds
function QuadTree:query(x, y, width, height)
    -- If this quad tree does not intersect with the given bounds, return an empty list
    if x + width < self.x or x > self.x + self.width or y + height < self.y or y > self.y + self.height then
        return {}
    end
    
    -- If this quad tree is a leaf, return all objects that intersect with the given bounds
    if self.topLeft == nil then
        local results = {}
        for i=1, #self.objects do
            local obj = self.objects[i]
            if obj.x + obj.width >= x and obj.x <= x + width and obj.y + obj.height >= y and obj.y <= y + height then
                table.insert(results, obj)
            end
        end
        return results
    end
    
    -- Otherwise, query each quadrant and return the results
    local results = {}
    table.extend(results, self.topLeft:query(x, y, width, height))
    table.extend(results, self.topRight:query(x, y, width, height))
    table.extend(results, self.bottomLeft:query(x, y, width, height))
    table.extend(results, self.bottomRight:query(x, y, width, height))
    return results
end
