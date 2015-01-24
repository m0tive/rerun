-- rerun

local rerun = {}

rerun.dependency = {}
local function add_dependency(path, parent)
  local d = rerun.dependency[path] or {}
  d[parent] = true
  rerun.dependency[path] = d
end

rerun.__lua_require = require
function rerun.require(path, parent)
  if path:find("%.lua$") or path:find("[/\\:]") then
    return error(("rerun.require must use dot syntax, %q is invalid"):format(path))
  end

  if parent then
    add_dependency(path, parent)
  end

  local origEnv = getfenv(require)
  local env = { require = function(p) return rerun.require(p, path) end, }
  setmetatable(env, {
    __index = origEnv,
    __newindex = function(_,k,v) origEnv[k] = v end,
  })

  local function caller()
    return rerun.__lua_require(path)
  end

  setfenv(caller, env)
  return caller()
end

return rerun
