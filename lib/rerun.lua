-- rerun

local rerun = {}

rerun.dependency = {}
local function add_dependency(path, parent)
  local d = rerun.dependency[path] or {}
  if parent then d[parent] = true end
  rerun.dependency[path] = d
end

local function pack_varargs(...)
  return {...}, select('#', ...)
end

rerun.stack = {}
local function push_stack(path)
  local n = #rerun.stack + 1
  rerun.stack[n] = path
  return n
end

local function pop_stack()
  local n = #rerun.stack
  if n == 0 then return error("Cannot pop empty stack") end
  local r = rerun.stack[n]
  rerun.stack[n] = nil
  return r
end

function rerun.current()
  return rerun.stack[#rerun.stack]
end

function rerun.reset()
  rerun.dependency = {}
  rerun.stack = {}
end

rerun.__lua_require = require
function rerun.require(path)
  if path:find("%.lua$") or path:find("[/\\:]") then
    return error(("rerun.require must use dot syntax, %q is invalid"):format(path))
  end

  local stackN = push_stack(path)

  -- save dependency
  add_dependency(path, rerun.stack[stackN-1])

  -- use rerun.require in body of required file
  local currentRequire = require
  require = rerun.require

  local r, n = pack_varargs(rerun.__lua_require(path))

  -- restore
  require = currentRequire

  pop_stack()

  return unpack(r, 1, n)
end

return rerun
