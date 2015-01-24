-- rerun

local rerun = {}

rerun.__lua_require = require
function rerun.require(path)
  if path:find("%.lua$") or path:find("[/\\:]") then
    return error(("rerun.require must use dot syntax, %q is invalid"):format(path))
  end

  local origEnv = getfenv(require)
  local env = { require = rerun.require }
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
