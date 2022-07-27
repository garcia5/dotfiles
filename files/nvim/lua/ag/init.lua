require("ag.autocmd") -- lua autocommands
local no_plugins = require("ag.plugins") -- plugins
require("ag.mappings") -- keymaps
if no_plugins then return end
require("ag.lsp_config") -- LSP configs
require("ag.treesitter") -- treesitter configs
