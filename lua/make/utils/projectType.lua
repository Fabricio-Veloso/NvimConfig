-- TEST: M ={}

function M.run(modules)

  local isProjectIdentifyed = false

  for _, mod in ipairs(modules) do

    if mod and type(mod.identify) == "function" then
      local ok,  result = pcall(mod.identify)

      if ok and result and result.ok == true then
        isProjectIdentifyed = result
      end
    end

  end
  if isProjectIdentifyed == false then
    print('O tipo de projeto não pode ser identificado')
  end

  return isProjectIdentifyed
end

return M
