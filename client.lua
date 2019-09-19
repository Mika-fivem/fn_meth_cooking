ESX = nil
local harvesting_antifreeze,harvesting_acetone,harvesting_redphosphorus,harvesting_sudafed = false,false,false,false
local antifreeze_label,acetone_label,redphosphorus_label,sudafed_label = "antifreeze","acetone","redphosphorus","sudafed"
local heat = 30
local PlayerData = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
    if PlayerData==nil then PlayerData = ESX.GetPlayerData() end
    ESX.TriggerServerCallback("fn_meth_cooking:getItemLabels",function(a,b,c,d) antifreeze_label,acetone_label,redphosphorus_label,sudafed_label=a,b,c,d end)
end)

function OpenCookingMenu()
    local count,order = 1,1
    local warningshown = false
    heat = 30
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'cook_count',
    {
        title = Config.lang.select_scount,
        align = 'center',
        elements = {}
    },
    function(dd, dialog)
        ESX.TriggerServerCallback("fn_meth_cooking:checkIngredientCount",function(enough)
            if enough then
                count = dd.value
                dialog.close()
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cook',
                {
                    title = Config.lang.cooking_menu_title,
                    align = 'top-right',
                    elements = {
                        {label = Config.lang.heat:format(heat), value = heat, type = "slider", min = 30, max = 100, action = "heat"},
                        {label = Config.lang.meth_count:format(count)},
                        {label = Config.lang.add:format(count,antifreeze_label), action = "add", item = "antifreeze", key = 3, used = false},
                        {label = Config.lang.add:format(count,acetone_label), action = "add", item = "acetone", key = 4, used = false},
                        {label = Config.lang.add:format(count,redphosphorus_label), action = "add", item = "redphosphorus", key = 5, used = false},
                        {label = Config.lang.add:format(count,sudafed_label), action = "add", item = "sudafed", key = 6, used = false}
                    }
                }, function(data, menu)
                    if data.current.action == "heat" then
                        heat = data.current.value
                        menu.setElement(1, "label", Config.lang.heat:format(heat))
                        menu.refresh()
                    elseif data.current.action == "add" then
                        if not data.current.used then
                            if Config.ingredient_order[order]==data.current.item and Config.ingredient_heat_order[order]-Config.heat_error_margin<=heat and Config.ingredient_heat_order[order]+Config.heat_error_margin>=heat then
                                menu.setElement(data.current.key, "label", "<span style='color:lightgray;'>"..Config.lang.used.."</span>")
                                menu.setElement(data.current.key, "used", true)
                                menu.refresh()
                                TriggerServerEvent("fn_meth_cooking:removeIngredientInOrder",order,count) -- kinda prevent some cheeky business by using order instead of passing the actual item name
                                if order>=#Config.ingredient_order then
                                    TriggerServerEvent("fn_meth_cooking:cookingSuccess",count)
                                    menu.close()
                                end
                                order=order+1
                            else
                                menu.close()
                                ESX.ShowNotification(Config.lang.blew_up)
                                AddExplosion(GetEntityCoords(GetPlayerPed(-1)), 4, 5, true, false, 15, false)
                            end
                        end
                    end
                end, function(data, menu)
                    if warningshown or order<=1 then menu.close() else ESX.ShowNotification(Config.lang.cooking_exit_warn); warningshown = true end
                end)
            else
                ESX.ShowNotification(Config.lang.not_enough_items:format(dd.value))
            end
        end,tonumber(dd.value))
    end, function(dd,dialog)
        dialog.close()
        return
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local pedpos = GetEntityCoords(ped)
        if Config.job==nil or (PlayerData~=nil and Config.job==PlayerData.job.name) then
            if Config.antifreeze.enabled then
                DrawMarker(1, Config.antifreeze.pos, 0, 0, 0, 0, 0, 0, Config.point.size.x, Config.point.size.y, Config.point.size.z, Config.point.color.r, Config.point.color.g, Config.point.color.b, Config.point.color.a, 0, 0, 0, false)
                if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.antifreeze.pos, false)<Config.point.size.x and not harvesting_antifreeze then
                    ESX.ShowHelpNotification(Config.lang.harvest:format(antifreeze_label))
                    if IsControlJustPressed(0,51) then TriggerServerEvent("fn_meth_cooking:startAntifreezeHarvest"); harvesting_antifreeze=true end
                elseif GetDistanceBetweenCoords(GetEntityCoords(ped), Config.antifreeze.pos, false)>Config.point.size.x and harvesting_antifreeze then
                    TriggerServerEvent("fn_meth_cooking:stopAntifreezeHarvest"); harvesting_antifreeze=false
                end
            end
            if Config.acetone.enabled then
                DrawMarker(1, Config.acetone.pos, 0, 0, 0, 0, 0, 0, Config.point.size.x, Config.point.size.y, Config.point.size.z, Config.point.color.r, Config.point.color.g, Config.point.color.b, Config.point.color.a, 0, 0, 0, false)
                if GetDistanceBetweenCoords(pedpos, Config.acetone.pos, false)<Config.point.size.x and not harvesting_acetone then
                    ESX.ShowHelpNotification(Config.lang.harvest:format(acetone_label))
                    if IsControlJustPressed(0,51) then TriggerServerEvent("fn_meth_cooking:startAcetoneHarvest"); harvesting_acetone=true end
                elseif GetDistanceBetweenCoords(pedpos, Config.acetone.pos, false)>Config.point.size.x and harvesting_acetone then
                    TriggerServerEvent("fn_meth_cooking:stopAcetoneHarvest"); harvesting_acetone=false
                end
            end
            if Config.redphosphorus.enabled then
                DrawMarker(1, Config.redphosphorus.pos, 0, 0, 0, 0, 0, 0, Config.point.size.x, Config.point.size.y, Config.point.size.z, Config.point.color.r, Config.point.color.g, Config.point.color.b, Config.point.color.a, 0, 0, 0, false)
                if GetDistanceBetweenCoords(pedpos, Config.redphosphorus.pos, false)<Config.point.size.x and not harvesting_redphosphorus then
                    ESX.ShowHelpNotification(Config.lang.harvest:format(redphosphorus_label))
                    if IsControlJustPressed(0,51) then TriggerServerEvent("fn_meth_cooking:startRedphosphorusHarvest"); harvesting_redphosphorus=true end
                elseif GetDistanceBetweenCoords(pedpos, Config.redphosphorus.pos, false)>Config.point.size.x and harvesting_redphosphorus then
                    TriggerServerEvent("fn_meth_cooking:stopRedphosphorusHarvest"); harvesting_redphosphorus=false
                end
            end
            if Config.sudafed.enabled then
                DrawMarker(1, Config.sudafed.pos, 0, 0, 0, 0, 0, 0, Config.point.size.x, Config.point.size.y, Config.point.size.z, Config.point.color.r, Config.point.color.g, Config.point.color.b, Config.point.color.a, 0, 0, 0, false)
                if GetDistanceBetweenCoords(pedpos, Config.sudafed.pos, false)<Config.point.size.x and not harvesting_sudafed then
                    ESX.ShowHelpNotification(Config.lang.harvest:format(sudafed_label))
                    if IsControlJustPressed(0,51) then TriggerServerEvent("fn_meth_cooking:startSudafedHarvest"); harvesting_sudafed=true end
                elseif GetDistanceBetweenCoords(pedpos, Config.sudafed.pos, false)>Config.point.size.x and harvesting_sudafed then
                    TriggerServerEvent("fn_meth_cooking:stopSudafedHarvest"); harvesting_sudafed=false
                end
            end
            
            DrawMarker(1, Config.cook_location, 0, 0, 0, 0, 0, 0, Config.point.size.x, Config.point.size.y, Config.point.size.z, Config.point.color.r, Config.point.color.g, Config.point.color.b, Config.point.color.a, 0, 0, 0, false)
            if GetDistanceBetweenCoords(pedpos, Config.cook_location, false)<Config.point.size.x then
                ESX.ShowHelpNotification(Config.lang.cooking_menu)
                if IsControlJustPressed(0, 51) then
                    OpenCookingMenu()
                end
            end
        end
    end
end)