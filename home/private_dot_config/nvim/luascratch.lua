local matches = {}
for str in string.gmatch("/usr/bin/hi", "([^/]+)") do
  table.insert(matches, str)
end

print(vim.inspect(matches))
