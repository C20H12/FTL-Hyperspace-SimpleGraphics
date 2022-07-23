---@class Polygon static 
Polygon = {
  -- Reference https://2dengine.com/?p=polygons

  -- Finds twice the signed area of a polygon
  signedPolyArea = function(pointsTable)
    local area = 0
    local totalPoints = #pointsTable
    local lastPoint = pointsTable[totalPoints]
    for i = 1, totalPoints do
      local currPoint = pointsTable[i]
      area = area + (currPoint[1] + lastPoint[1]) * (currPoint[2] - lastPoint[2])
      lastPoint = currPoint
    end
    return area
  end,

  -- Finds the actual area of a polygon
  polyArea = function(self, pointsTable)
    local area = self.signedPolyArea(pointsTable)
    return math.abs(area / 2)
  end,

  -- Checks if the winding of a polygon is counter-clockwise
  isPolyCCW = function(self, pointsTable)
    return self.signedPolyArea(pointsTable) > 0
  end,

  -- Reverses the vertex winding
  polyReverse = function(pointsTable)
    local numberOfPoints = #pointsTable
    for i = 1, math.floor(numberOfPoints / 2) do
      local iCountedBackwards = numberOfPoints - i + 1
      pointsTable[i] = pointsTable[iCountedBackwards]
      pointsTable[iCountedBackwards] = pointsTable[i]
    end
  end,

  -- Finds twice the signed area of a triangle
  signedTriArea = function(point_1, point_2, point_3)
    return ((point_1[1] - point_3[1]) * (point_2[2] - point_3[2]) 
            - 
            (point_1[2] - point_3[2]) * (point_2[1] - point_3[1])
          )
  end,

  -- Checks if a point is inside a triangle
  pointInTri = function(point, tri_pt1, tri_pt2, tri_pt3)
    local point_x = point[1]
    local point_y = point[2]
    local px1 =  tri_pt1[1] - point_x
    local py1 = tri_pt1[2] - point_y
    local px2 = tri_pt2[1] - point_x
    local py2 = tri_pt2[2] - point_y
    local px3 = tri_pt3[1] - point_x
    local py3 = tri_pt3[2] - point_y
    local ab = px1 * py2 - py1 * px2
    local bc = px2 * py3 - py2 * px3
    local ca = px3 * py1 - py3 * px1
    local sab = ab < 0
    local sbc = bc < 0
    local sca = ca < 0
    if sab ~= sbc then
      return false
    end
    return sab == sca
  end,

  -- Checks if the vertex is an "ear" or "mouth"
  left = {},
  right = {}, -- linked lists? maybe?

  isEar = function(self, point_1, point_2, point_3) -- points are pairs

    if self.signedTriArea(point_1, point_2, point_3) >= 0 then
      local j1 = self.right[point_3]

      repeat
        local j0 = self.left[j1]
        local j2 = self.right[j1]
        if self.signedTriArea(j0, j1, j2) <= 0 then
          if self.pointInTri(j1, point_1, point_2, point_3) then
            return false
          end
        end
        j1 = j2
      until j1 == point_1

      return true
    end

    return false
  end,

  -- Triangulates a counter-clockwise polygon
  triangulatePoly = function(self, pointsTable)
    if not self:isPolyCCW(pointsTable) then
      self.polyReverse(pointsTable)
    end

    local numberOfPoints = #pointsTable

    for i = 1, numberOfPoints do
      local v = pointsTable[i]
      self.left[v], self.right[v] = pointsTable[i - 1], pointsTable[i + 1]
    end

    local firstPoint = pointsTable[1]
    local lastPoint = pointsTable[numberOfPoints]
    self.left[firstPoint] = lastPoint
    self.right[lastPoint] = firstPoint

    local out = {}
    local skippedCounter = 0
    local i1 = firstPoint
    while numberOfPoints >= 3 and skippedCounter <= numberOfPoints do
      local i0, i2 = self.left[i1], self.right[i1]
      if numberOfPoints > 3 and self:isEar(i0, i1, i2) then
        table.insert(out, { i0, i1, i2 })
        self.left[i2], self.right[i0] = i0, i2     
        self.left[i1], self.right[i1] = nil, nil
        skippedCounter = 0
        i1 = i0
      else
        skippedCounter = skippedCounter + 1
        i1 = i2
      end
    end
    return out
  end
}
