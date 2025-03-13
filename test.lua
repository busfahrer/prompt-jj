
local cmd = "jj st"
local f = assert(io.popen(cmd, 'r'))
local s = assert(f:read('*a'))
f:close()

print(s)

local change, commit, bookmarks, msg = string.match(s, "Working copy : (%a+) (%S+) ([^\n]+) | ([^\n]+)\n")
if not change then
    change, commit, msg = string.match(s, "Working copy : (%a+) (%S+) ([^\n]+)\n")
end
local parent_change, parent_commit, parent_bookmarks, parent_msg = string.match(s, "Parent commit: (%a+) (%S+) ([^\n]+) | ([^\n]+)\n")
if not parent_change then
    parent_change, parent_commit, parent_msg = string.match(s, "Parent commit: (%a+) (%S+) ([^\n]+)\n")
end

print("change   ", "commit   ", "msg                ", "bookmarks")
print(change, commit, msg, bookmarks)
print(parent_change, parent_commit, parent_msg, parent_bookmarks)

-- TODO why does ^(empty) not work here?
print()
local clean = nil ~= string.find(s, "^The working copy is clean\n")
print("clean", clean)
-- TODO this is identical(?) to the "clean" above, which is safer
--local empty = nil ~= string.find(msg, "(empty)")
--print("empty", empty)
local desc = nil == string.find(msg, "(no description set)")
print("desc", desc)
local conflict = nil ~= string.find(msg, "(conflict)")
print("confl.", conflict)

local bookmarks_list = bookmarks and string.gmatch(bookmarks, "[^%s]+")

if bookmarks_list then
    for bm in bookmarks_list do
        print("bookmark:", bm)
    end
end
