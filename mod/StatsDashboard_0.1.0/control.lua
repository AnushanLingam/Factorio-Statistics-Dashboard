script.on_event(
    {defines.events.on_tick},
    function(e)
        local player = game.get_player(1)

        -- Collects data at alternating intervals to avoid performance drop
        if e.tick % 30 == 0 then
            -- Collect output statistics
            local itemOutput = game.table_to_json(player.force.item_production_statistics.output_counts)
            local fluidOutput = game.table_to_json(player.force.fluid_production_statistics.output_counts)

            -- Write outputs to file
            game.write_file("statsDashboard/output.json", "[ \n")
            game.write_file("statsDashboard/output.json", string.format("%s, \n %s \n", itemOutput, fluidOutput), true)
            game.write_file("statsDashboard/output.json", "] \n", true)
        end
        if e.tick % 45 == 0 then
            -- Collect input statistics
            local itemInput = game.table_to_json(player.force.item_production_statistics.input_counts)
            local fluidInput = game.table_to_json(player.force.fluid_production_statistics.input_counts)

            -- Write inputs to file
            game.write_file("statsDashboard/input.json", "[ \n")
            game.write_file("statsDashboard/input.json", string.format("%s, \n %s \n", itemInput, fluidInput), true)
            game.write_file("statsDashboard/input.json", "] \n", true)
        end
    end
)

-- NOTE - MOVED TO BUILT IN TABLE_TO_JSON METHOD
-- function tableToJson(name, dataTable, shouldComma, fileName)
--     game.write_file(fileName, string.format('"%s": [ \n', name), true)
--     -- count number of keys in stats table
--     local count = 0
--     for _ in pairs(dataTable) do
--         count = count + 1
--     end

--     -- Loop through each key and convert to string
--     local keyset = {}
--     local n = 0
--     for k, v in pairs(dataTable) do
--         n = n + 1
--         keyset[n] = k
--         local comma = ","
--         if count == n then
--             comma = ""
--         end
--         local dataString = string.format('{\n "name": "%s", \n"value": %s \n}%s\n', k, tostring(v), comma)
--         game.write_file(fileName, dataString, true)
--     end

--     local endComma = ","
--     if shouldComma == false then
--         endComma = ""
--     end
--     game.write_file(fileName, string.format("]%s \n", endComma), true)
-- end
