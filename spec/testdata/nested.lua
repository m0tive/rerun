require "testdata.nested_sub1"


return {
  foo = function()
      return require "testdata.nested_sub2"
    end,
}
