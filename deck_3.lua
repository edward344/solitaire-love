Deck_3 = Deck:extend()

function Deck_3:new(x,y,width,height,card_table)
    Deck_3.super.new(self,x,y,width,height,{table.remove(card_table)})
    self.hidden_cards = card_table
end


function Deck_3:draw(spritesheet,card_back)
    local j = self.y
    if #self.hidden_cards > 0 then
        for i = 1, #self.hidden_cards do
            love.graphics.draw(spritesheet,card_back,self.x,j)
            j = j + 30
        end
    end
    if #self.card_table > 0 then
        for i = 1, #self.card_table do
            love.graphics.draw(spritesheet,self.card_table[i].quad,self.x,j)
            j = j + 30
        end
    end
    
    if #self.hidden_cards == 0 and #self.card_table == 0 then
        love.graphics.rectangle("line",self.x,self.y,self.width,self.height)
    end
end

function Deck_3:get_selected_index(x,y)
    local index = 0
    if #self.card_table > 0 then
        local left = self.x
        local right = self.x + self.width
        local top
        local bottom
        for i = 1, #self.card_table do
            top = self:get_top_of_deck() + 30 * (i-1)
            if i == #self.card_table then
                bottom = top + self.height
            else
                bottom = top + 30
            end
            if self:is_inside(x,y,left,right,top,bottom) then
                index = i
            end
        end
    end
    
    return index 
end

function Deck_3:get_selected_cards(index)
    return self:return_removed_cards(#self.card_table - (index - 1))
end

function Deck_3:get_position(index)
    local x = self.x
    local y = self:get_top_of_deck() + 30 * (index - 1)
    
    return x,y
end

function Deck_3:return_removed_cards(n)
    tb1 = {}
    for i = 1, n do
        table.insert(tb1,1,table.remove(self.card_table))
    end
    
    return tb1
end

function Deck_3:is_inside(x,y,left,right,top,bottom)
    if left < x and right > x and top < y and bottom > y then
        return true
    else
        return false
    end
end

function Deck_3:is_mouse_button_down(x,y)
    if #self.card_table > 0 then
        local left = self.x
        local right = self.x + self.width
        local top = self:get_top_of_deck()
        local bottom = top + self.height + 30 * (#self.card_table - 1)
        
        if self:is_inside(x,y,left,right,top,bottom) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function Deck_3:is_mouse_button_up(x,y)
    local left = self.x
    local right = self.x + self.width
    local top
    local bottom 
    if #self.card_table > 1 then
        top = self:get_top_of_deck() + 30 * (#self.card_table - 1)
        bottom = top + self.height
    else
        top = self:get_top_of_deck()
        bottom = top + self.height
    end
    
    if left < x and right > x and top < y and bottom > y then
        return true
    else
        return false
    end
end

function Deck_3:get_top_of_deck()
    return self.y + #self.hidden_cards * 30
end

function Deck_3:check_empty_card_table()
    if #self.card_table == 0 and #self.hidden_cards > 0 then
        self.card_table = {table.remove(self.hidden_cards)}
    end
end

function Deck_3:set_rules(tb1)
    if #self.card_table > 0 then
        local suit = self.card_table[#self.card_table].suit 
        local number = self.card_table[#self.card_table].number
        if suit == "diamonds" or suit == "hearts" then
            if tb1[1].suit == "clubs" or tb1[1].suit == "spades" then
                if tb1[1].number == number - 1 then
                    return true
                else
                    return false
                end
            else
                return false
            end
        elseif tb1[1].suit == "diamonds" or tb1[1].suit == "hearts" then
            if tb1[1].number == number - 1 then
                return true
            else
                return false
            end
        else
            return false
        end
    elseif tb1[1].number == 13 then
        return true
    else
        return false
    end
end