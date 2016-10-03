-- Require: https://github.com/harningt/luajson
local json = require('json')

file = 'guests.json' -- File to export data

local load_data = function ()
    local f = io.open(file, 'r')
    if f == nil then
        guests = {}
    else
        local content = f:read('*all')
        guests = json.decode(content) -- Decode file to Lua's object table
        f:close()
    end
end

local ls = function ()
    if next(guests) == nil then
        print "It's empty."
    else
        for i, guest in ipairs(guests) do
            print(i .. ':')
            for k, v in pairs(guest) do
                print('  ' .. k, v)
            end
        end
    end
end

local add = function (name, cpf)
    table.insert(guests, {['name'] = name, ['cpf'] = cpf})
end

local search = function (str)
    if next(guests) == nil then
        print "It's empty."
    else
        for i, guest in ipairs(guests) do
            if string.find(guest.cpf, str) then
                print(i .. ':')
                print('  ' .. 'name', guest.name)
                print('  ' .. 'cpf', guest.cpf)
            else
                print "No results found."
            end
        end
    end
end

local rm = function (id)
    if guests[id] == nil then
        print('The guest of id ' .. id .. ' does not exist.')
    else
        table.remove(guests, id)
    end
end

local save = function ()
    if next(guests) ~= nil then
        local f = io.open(file, 'w')
        f:write(json.encode(guests))
        f:close()
    end
end

--

load_data()

print "1: list"
print "2: add"
print "3: search"
print "4: remove"
print "5: help"
print "6: quit"

while true do
    io.write("What now% ")
    local o = io.read()

    if o == '1' or string.match('list', '^' .. o) then
        ls()
    elseif o == '2' or string.match('add', '^' .. o) then
        io.write('Name: ')
        name = io.read()
        io.write('CPF: ')
        cpf = io.read()
        add(name, cpf)
    elseif o == '3' or string.match('search', '^' .. o) then
        io.write('Search for CPF: ')
        str = io.read()
        search(str)
    elseif o == '4' or string.match('remove', '^' .. o) then
        io.write('Remove by id: ')
        id = io.read()
        rm(id)
    elseif o == '5' or string.match('help', '^' .. o) then
        print "list   - list party guests"
        print "add    - add party guests"
        print "search - search party guests by CPF"
        print "remove - remove a party guests by id"
    elseif o == '6' or string.match('quit', '^' .. o) then
        save()
        print 'Bye.'
        os.exit()
    else
        io.stderr:write("Invalid option\n")
    end
end
