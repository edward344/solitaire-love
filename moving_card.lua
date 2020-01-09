Moving_card = Object:extend()

function Moving_card:new()
    self.x = 0
    self.y = 0
    self.diff_x = 0
    self.diff_y = 0
    self.card_table = {}
    self.class_name = "none"
    self.key = 0 
end

function Moving_card:is_empty()
    if #self.card_table > 0 then
        return false
    else
        return true
    end
end

function Moving_card:set_position(x,y,card_x,card_y)
    self.diff_x = x - card_x
    self.diff_y = y - card_y
    
    self.x = x - self.diff_x
    self.y = y - self.diff_y
end

function Moving_card:update()
    if #self.card_table > 0 then
        self.x = love.mouse.getX() - self.diff_x
        self.y = love.mouse.getY() - self.diff_y 
    end
end

function Moving_card:draw(spritesheet)
    if #self.card_table > 0 then
        for i = 1, #self.card_table do
            love.graphics.draw(spritesheet,self.card_table[i].quad,self.x,self.y + 30 * (i-1))
        end
    end
end