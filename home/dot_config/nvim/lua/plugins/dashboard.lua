local function dashboard_dir()
  return vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
end

local function read_messages(filepath)
  local file = io.open(filepath, "r")
  if not file then
    return {}
  end

  local messages = {}
  local current = {}

  for line in file:lines() do
    if line == "" then
      if #current > 0 then
        messages[#messages + 1] = table.concat(current, "\n")
        current = {}
      end
    else
      current[#current + 1] = line
    end
  end

  file:close()

  if #current > 0 then
    messages[#messages + 1] = table.concat(current, "\n")
  end

  return messages
end

local function seed_random()
  math.randomseed(os.time() + vim.fn.getpid())
  math.random()
  math.random()
end

local function pick_message(messages)
  if #messages == 0 then
    return ""
  end

  seed_random()
  return messages[math.random(#messages)]
end

local function build_header()
  local filepath = dashboard_dir() .. "/dashboard_messages.txt"
  local message = pick_message(read_messages(filepath))

  local header = [[
ネ  コ  ヴィ  ム
ne  ko  vi    mu

    |\      _,,,---,,_     
    /,`.-'`'    -.  ;-;;,_ 
   |,4-  ) )-,_..;\ (  `'-'
  '---''(_/--'  `-'\_)     

]]

  return header .. message
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = build_header(),
        },
      },
    },
  },
}
