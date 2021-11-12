local function trim3(s)
   return s:gsub("^%s+", ""):gsub("%s+$", "")
end
local function string_starts(str, start)
  return (string.sub(str, 1, string.len(start)) == start)
end
local function starts_with_pipe_3f(line)
  return string_starts(trim3(line), "|> ")
end
local function join_newline_pipes(lines)
  local updated_lines = {}
  for i, line in ipairs(lines) do
    if starts_with_pipe_3f(line) then
      local prev_line = table.remove(updated_lines)
      table.insert(updated_lines, (prev_line .. " " .. line))
    else
      table.insert(updated_lines, line)
    end
  end
  return updated_lines
end
return {
	join_newline_pipes = join_newline_pipes,
}
