local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", ";", ":", { desc = "Command-line mode" })
