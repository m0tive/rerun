-- rerun

local rerun = {}

rerun.dependency = {}
local function add_dependency(path, parent)
  local d = rerun.dependency[path] or {}
  d[parent] = true
  rerun.dependency[path] = d
end

local function pack_vararg(...)
  return {...}, select('#', ...)
end

rerun.__lua_require = require
function rerun.require(path)
  if path:find("%.lua$") or path:find("[/\\:]") then
    return error(("rerun.require must use dot syntax, %q is invalid"):format(path))
  end

  -- save dependency

  -- TODO: modify require

  local r, n = pack_varargs(rerun.__lua_require(path))

  -- restore

  return unpack(r, 1, n)
end

return rerun
