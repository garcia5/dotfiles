return {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = {
        "kyazdani42/nvim-web-devicons",
    },
    config = function()
        local dashboard = require("alpha.themes.dashboard")
        local nvim_web_devicons = require("nvim-web-devicons")
        local path = require("plenary.path")
        local cdir = vim.fn.getcwd()

        local header = {
            type = "text",
            val = cdir,
            opts = {
                position = "center",
                hl = "Bold",
            },
        }

        ---Get file extension
        ---@param fn string filename
        ---@return string
        local function get_extension(fn)
            local match = fn:match("^.+(%..+)$")
            local ext = ""
            if match ~= nil then ext = match:sub(2) end
            return ext
        end

        ---Get the icon corresponding to a file extension
        ---@param fn string filename
        ---@return string, string
        local function icon(fn)
            local nwd = require("nvim-web-devicons")
            local ext = get_extension(fn)
            return nwd.get_icon(fn, ext, { default = true })
        end

        ---@param fn string filename
        ---@param sc string shortcut key
        ---@param short_fn function shortening function
        ---@return table
        local function file_button(fn, sc, short_fn)
            short_fn = short_fn or fn
            local ico_txt
            local fb_hl = {}

            local ico, hl = icon(fn)
            local hl_option_type = type(nvim_web_devicons.highlight)
            if hl_option_type == "boolean" then
                if hl and nvim_web_devicons.highlight then table.insert(fb_hl, { hl, 0, 1 }) end
            end
            if hl_option_type == "string" then table.insert(fb_hl, { nvim_web_devicons.highlight, 0, 1 }) end
            ico_txt = ico .. "  "

            local file_button_el = dashboard.button(sc, ico_txt .. short_fn, "<cmd>e " .. fn .. " <CR>")
            local fn_start = short_fn:match(".*/")
            if fn_start ~= nil then table.insert(fb_hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt - 2 }) end
            file_button_el.opts.hl = fb_hl
            return file_button_el
        end

        local default_mru_ignore = { "gitcommit" }

        local mru_opts = {
            ignore = function(path, ext)
                return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
            end,
        }

        ---Get most recently used files
        ---@param cwd string current dir
        ---@param num_items number number of recent files to fetch
        ---@param opts table
        ---@return table
        local function mru(cwd, num_items, opts)
            opts = opts or mru_opts
            num_items = num_items or 9

            local oldfiles = {}
            for _, v in pairs(vim.v.oldfiles) do
                if #oldfiles == num_items then break end
                local cwd_cond
                if not cwd then
                    cwd_cond = true
                else
                    cwd_cond = vim.startswith(v, cwd)
                end
                local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
                if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then oldfiles[#oldfiles + 1] = v end
            end

            local target_width = 35

            local tbl = {}
            for i, fn in ipairs(oldfiles) do
                local short_fn
                if cwd then
                    short_fn = vim.fn.fnamemodify(fn, ":.")
                else
                    short_fn = vim.fn.fnamemodify(fn, ":~")
                end

                if #short_fn > target_width then
                    short_fn = path.new(short_fn):shorten(1, { -2, -1 })
                    if #short_fn > target_width then short_fn = path.new(short_fn):shorten(1, { -1 }) end
                end

                local shortcut = tostring(i)

                local file_button_el = file_button(fn, " " .. shortcut, short_fn)
                tbl[i] = file_button_el
            end
            return {
                type = "group",
                val = tbl,
                opts = {},
            }
        end

        local buttons = {
            type = "group",
            val = {
                { type = "text",    val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
                { type = "padding", val = 1 },
                dashboard.button("e", "  New file", ":e "),
                dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
                dashboard.button("g", "  Live grep", ":Telescope live_grep<CR>"),
                dashboard.button("c", "  Checkout branch", ":Telescope git_branches<CR>"),
                dashboard.button("m", "  Open mergetool", ":Git mergetool<CR>"),
                dashboard.button("s", "  Update Plugins", ":Lazy sync<CR>"),
                dashboard.button("q", "  Quit", ":qa<CR>"),
            },
            position = "center",
        }

        local section_mru = {
            type = "group",
            val = {
                {
                    type = "text",
                    val = "Recent files",
                    opts = {
                        hl = "SpecialComment",
                        shrink_margin = false,
                        position = "center",
                    },
                },
                { type = "padding", val = 1 },
                {
                    type = "group",
                    val = function() return { mru(cdir, 9) } end,
                    opts = { shrink_margin = false },
                },
            },
        }

        local opts = {
            layout = {
                { type = "padding", val = 2 },
                header,
                { type = "padding", val = 2 },
                section_mru,
                { type = "padding", val = 2 },
                buttons,
            },
            opts = {
                margin = 5,
            },
        }
        require("alpha").setup(opts)
    end,
}
