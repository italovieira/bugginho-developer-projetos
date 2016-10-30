-- Require: https://github.com/harningt/luajson
local json = require('json')

-- Load data from JSON file to Lua's table
local load_data = function (file)
    local f = io.open(file, 'r')
    if f == nil then
        return {}
    else
        local content = f:read('*all')
        f:close()
        return json.decode(content) -- Decode file to Lua's object table
    end
end

local ls = function (guests)
    if next(guests) == nil then
        print 'It is empty.'
    else
        for i, guest in ipairs(guests) do
            print(i .. ':')
            for k, v in pairs(guest) do
                print('  ' .. k .. ': ' .. v)
            end
        end
    end
end

local add = function (name, cpf)
    local guest = {
        ['name'] = name,
        ['cpf'] = cpf
    }
    table.insert(guests, guest)
end

local search = function (str)
    if next(guests) == nil then
        print 'It is empty.'
    else
        for i, guest in ipairs(guests) do
            if string.find(guest.cpf, str) then
                print(i .. ':')
                print('  ' .. 'name:' .. guest.name)
                print('  ' .. 'cpf:'.. guest.cpf)
            else
                print 'No results found.'
            end
        end
    end
end

local rm = function (id, reason)
    local guest = guests[id]
    if guest == nil then
        print('The guest of id ' .. id .. ' does not exist.')
    else
        table.remove(guests, id)
        guest.reason = reason
        table.insert(removed_guests, guest)
    end
end

local save = function (table, file)
    if next(table) ~= nil then
        local f = io.open(file, 'w')
        f:write(json.encode(table))
        f:close()
    end
end

--

local file = 'guests.json'
local file_removed_guests = 'removed.json'

guests = load_data(file)
removed_guests = load_data(file_removed_guests)

while true do
    print '*** Commands ***'
    print '1: list'
    print '2: add'
    print '3: search'
    print '4: remove'
    print '5: help'
    print '6: quit'
    io.write('What now% ')

    local o = io.read()

    if o == '1' or string.match('list', '^' .. o) then
        print('1: guests')
        print('2: removed guests')
        io.write('What now% ')
        o = io.read()
        if o == '1' or string.match('guests', '^' .. o) then
            ls(guests)
        elseif o == '2' or string.match('removed guests', '^' .. o) then
            ls(removed_guests)
        else
            io.stderr:write('Invalid option\n')
        end

    elseif o == '2' or string.match('add', '^' .. o) then
        io.write('Name: ')
        local name = io.read()
        io.write('CPF: ')
        local cpf = io.read()
        add(name, cpf)

    elseif o == '3' or string.match('search', '^' .. o) then
        io.write('Search for CPF: ')
        local str = io.read()
        search(str)

    elseif o == '4' or string.match('remove', '^' .. o) then
        local id
        repeat
            io.write('Remove by id: ')
            id = tonumber(io.read())
        until id ~= nil
        io.write('Reason: ')
        local reason = io.read()
        rm(id, reason)

    elseif o == '5' or string.match('help', '^' .. o) then
        print 'list   - list party guests'
        print 'add    - add party guests'
        print 'search - search party guests by CPF'
        print 'remove - remove a party guests by id'

    elseif o == '6' or string.match('quit', '^' .. o) then
        save(guests, file)
        save(removed_guests, file_removed_guests)
        print 'Bye.'
        os.exit()
    else
        io.stderr:write('Invalid option\n')
    end
end
