-- rerun

local rerun = {}

local require = require
function rerun.require(path)
  if path:find("%.lua$") or path:find("[/\\:]") then
    return error(("rerun.require must use dot syntax, %q is invalid"):format(path))
  end

  return require(path)
end

return rerun
