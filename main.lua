function love.load()
    love.window.setTitle("Solitaire")
    
    Object = require "classic"
    require "game"
    
    game = Game()
    
end

function love.update(dt)
    game:run_logic(dt)
end

function love.draw()
    game:display_frame()
end

function love.mousepressed(x,y)
    game:mousepressed(x,y)
end

function love.mousereleased(x,y)
    game:mousereleased(x,y)
end