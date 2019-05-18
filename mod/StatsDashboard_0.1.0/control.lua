script.on_event(
    {defines.events.on_tick},
    function(e)

        if e.tick % 30 == 0 then -- adjust tick at the end to ensure no game lag
            local player = game.get_player(1)
            local prodStats = player.force.item_production_statistics.output_counts
            local fluidStats = player.force.fluid_production_statistics.output_counts

            -- Writes data to text file using built in logging tool
            -- Conversion to json format happens on web server to alleviate performance issues during game
            game.write_file("itemOutputStats.txt", serpent.block(prodStats))
            game.write_file("fluidOutputStats.txt", serpent.block(fluidStats))


            -- NOTE 
            -- Following code converts to json in-game which causes heavy performance drops at 30 ticks.
            -- Increasing the duration leads to a framerate spike at the set interval so not recommended 
            -- -- collect output stats
            -- game.write_file("outputs.json", "{ \n")
            -- tableToJson("itemProduction", prodStats, true, "outputs.json")
            -- tableToJson("fluidProduction", fluidStats, false, "outputs.json")
            -- game.write_file("outputs.json", "}", true)

            -- -- collect input stats
            -- local prodInputs = player.force.item_production_statistics.input_counts
            -- local fluidInputs = player.force.fluid_production_statistics.input_counts
            -- game.write_file("inputs.json", "{ \n")
            -- tableToJson("itemInputs", prodInputs, true, "inputs.json")
            -- tableToJson("fluidInputs", fluidInputs, false, "inputs.json")
            -- game.write_file("inputs.json", "}", true)
        end
    end
)

function tableToJson(name, dataTable, shouldComma, fileName)
    game.write_file(fileName, string.format('"%s": [ \n', name), true)
    -- count number of keys in stats table
    local count = 0
    for _ in pairs(dataTable) do
        count = count + 1
    end

    -- Loop through each key and convert to string
    local keyset = {}
    local n = 0
    for k, v in pairs(dataTable) do
        n = n + 1
        keyset[n] = k
        local comma = ","
        if count == n then
            comma = ""
        end
        local dataString = string.format('{\n "name": "%s", \n"value": %s \n}%s\n', k, tostring(v), comma)
        game.write_file(fileName, dataString, true)
    end

    local endComma = ","
    if shouldComma == false then
        endComma = ""
    end
    game.write_file(fileName, string.format("]%s \n", endComma), true)
end
