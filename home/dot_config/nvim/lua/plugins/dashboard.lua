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

local function pick_message(messages)
  if #messages == 0 then
    return ""
  end
  math.randomseed(os.time() + vim.fn.getpid())
  math.random()
  math.random()
  return messages[math.random(#messages)]
end

local function get_mood_kaomoji()
  local cache_file = os.getenv("XDG_RUNTIME_DIR") .. "/tamagotchi_mood"
  if vim.fn.filereadable(cache_file) == 1 then
    local lines = vim.fn.readfile(cache_file)
    if lines and lines[1] then
      local parts = vim.split(lines[1], "::")
      if #parts == 2 and parts[2] ~= "" then
        return parts[2]
      end
    end
  end
  return "(・_・)" -- Fallback if daemon hasn't written yet
end

local function build_header()
  local filepath = dashboard_dir() .. "/dashboard_messages.txt"
  local message = pick_message(read_messages(filepath))
  local kaomoji = get_mood_kaomoji()

  local header = [[
ネ  コ  ヴィ  ム
ne  ko  vi    mu

    |\      _,,,---,,_     
    /,`.-'`'    -.  ;-;;,_ 
   |,4-  ) )-,_..;\ (  `'-'
  '---''(_/--'  `-'\_)     

]]

  if message ~= "" then
    return header .. kaomoji .. " " .. message
  else
    return header .. kaomoji
  end
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        width = 30,
        preset = {
          header = build_header(),
          keys = {
            { icon = "", key = "f", desc = "find file", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = "", key = "n", desc = "new file", action = ":ene | startinsert" },
            { icon = "", key = "r", desc = "recent files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = "", key = "g", desc = "find text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = "", key = "l", desc = "lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = "", key = "q", desc = "quit", action = ":qa" },
          },
        },
      },
    },
  },
}
