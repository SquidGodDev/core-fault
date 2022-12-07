-- Define a function to create a new quadtree node
function newQuadtreeNode(x, y, width, height)
    local node = {}
  
    -- Store the node's position and dimensions
    node.x = x
    node.y = y
    node.width = width
    node.height = height
  
    -- Create a table to hold the child nodes
    node.nodes = {}
  
    -- Create a table to hold the objects in the node
    node.objects = {}
  
    -- Define a function to check if an object is inside the node
    function node:contains(object)
      return object.x >= self.x and object.x <= self.x + self.width and
             object.y >= self.y and object.y <= self.y + self.height
    end
  
    -- Define a function to split the node into four child nodes
    function node:split()
      local halfWidth = self.width / 2
      local halfHeight = self.height / 2
  
      -- Create the four child nodes
      self.nodes[1] = newQuadtreeNode(self.x, self.y, halfWidth, halfHeight)
      self.nodes[2] = newQuadtreeNode(self.x + halfWidth, self.y, halfWidth, halfHeight)
      self.nodes[3] = newQuadtreeNode(self.x, self.y + halfHeight, halfWidth, halfHeight)
      self.nodes[4] = newQuadtreeNode(self.x + halfWidth, self.y + halfHeight, halfWidth, halfHeight)
    end
  
    -- Define a function to insert an object into the quadtree
    function node:insert(object)
      -- Check if the object fits in any of the child nodes
      for i, child in ipairs(self.nodes) do
        if child:contains(object) then
          child:insert(object)
          return
        end
      end
  
      -- If the object doesn't fit in any child nodes, add it to this node
      table.insert(self.objects, object)
    end
  
    -- Define a function to retrieve all objects in the quadtree that could collide with a given object
    function node:retrieve(object, results)
      -- Check if the object fits in any of the child nodes
      for i, child in ipairs(self.nodes) do
        if child:contains(object) then
          child:retrieve(object, results)
        end
      end
  
      -- Add all objects in this node to the results
      for i, other in ipairs(self.objects) do
        table.insert(results, other)
      end
    end
  
    return node
end

-- Define a function to create a new spatial hash
function newSpatialHash(width, height, maxObjects, maxLevels)
    local hash = {}
  
    -- Store the dimensions of the hash
    hash.width = width
    hash.height = height
  
    -- Store the maximum number of objects and levels in the hash
    hash.maxObjects = maxObjects or 10
    hash.maxLevels = maxLevels or 5
  
    -- Create the root node of the quadtree
    hash.root = newQuadtreeNode(0, 0, width, height)
  
    -- Define a function to add an object to the hash
    function hash:add(object)
      self.root:insert(object)
    end
  
    -- Define a function to check for collisions in the hash
    function hash:checkCollisions()
      -- Loop through each object in the hash
      for i, object in ipairs(self.objects) do
        -- Retrieve a list of objects that could collide with the current object
        local others = {}
        self.root:retrieve(object, others)
  
        -- Check for collisions with the other objects
        for j, other in ipairs(others) do
          -- Skip the current object if it's the same as the other object
          if object ~= other then
            -- Calculate the distance between the two objects
            local dx = object.x - other.x
            local dy = object.y - other.y
            local distance = math.sqrt(dx * dx + dy * dy)
    
            -- Check if the distance is less than the sum of the objects' radii
            if distance < object.radius + other.radius then
              -- Handle the collision
              object:onCollision(other)
              other:onCollision(object)
            end
          end
        end
      end
    end
  
    return hash
end

-- -- Example usage:

-- -- Create a new spatial hash with dimensions of 10x10
-- local hash = newSpatialHash(10, 10)

-- -- Add some objects to the hash
-- hash:add({x = 0, y = 0, radius = 1, onCollision = function() print("Collision!") end})
-- hash:add({x = 0.5, y = 0.5, radius = 1, onCollision = function() print("Collision!") end})

-- -- Check for collisions in the hash
-- hash:checkCollisions()