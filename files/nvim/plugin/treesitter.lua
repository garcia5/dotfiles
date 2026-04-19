vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if ev.data.spec.name == "nvim-treesitter" and (ev.data.kind == "install" or ev.data.kind == "update") then
            vim.cmd("TSUpdate")
        end
    end,
})

vim.pack.add({
    { src = "gh:nvim-treesitter/nvim-treesitter", branch = "main" },
    { src = "gh:nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
})

-- textobjects swap
vim.keymap.set(
    "n",
    "<leader>l",
    function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end,
    { desc = "[Treesitter] Swap with right parameter", silent = true }
)
vim.keymap.set(
    "n",
    "<leader>h",
    function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner") end,
    { desc = "[Treesitter] Swap with right parameter", silent = true }
)

-- textobjects move
local move_maps = {
    class = { first = "[", last = "]" },
    func = { first = "(", last = ")" },
}
for t, vals in pairs(move_maps) do
    for which_direction, first_key in pairs(vals) do
        for which_end, second_key in pairs(vals) do
            local first = which_direction == "first" and "previous" or "next"
            local second = which_end == "first" and "start" or "end"
            local func_name = "goto_" .. first .. "_" .. second
            vim.keymap.set(
                { "n", "x", "o" },
                first_key .. second_key,
                function() require("nvim-treesitter-textobjects.move")[func_name]("@" .. t .. ".outer") end,
                { desc = "[Treesitter]" .. func_name, silent = true }
            )
        end
    end
end

-- textobjects select
for _, t in ipairs({ "function", "class" }) do
    local first = t:sub(1, 1)
    vim.keymap.set(
        { "x", "o" },
        "a" .. first,
        function() require("nvim-treesitter-textobjects.select").select_textobject("@" .. t .. ".outer", "textobjects") end,
        { desc = "[Treesitter] _ all " .. t, silent = true }
    )
    vim.keymap.set(
        { "x", "o" },
        "i" .. first,
        function() require("nvim-treesitter-textobjects.select").select_textobject("@" .. t .. ".inner", "textobjects") end,
        { desc = "[Treesitter] _ in " .. t, silent = true }
    )
end

-- treesitter init (highlighting)
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        local available_langs = require("nvim-treesitter").get_available()
        local is_available = vim.tbl_contains(available_langs, lang)
        if is_available then
            -- install if needed
            local installed_langs = require("nvim-treesitter").get_installed()
            local is_installed = vim.tbl_contains(installed_langs, lang)
            if not is_installed then require("nvim-treesitter").install(lang):wait() end

            -- enable treesitter features
            vim.treesitter.start()
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldmethod = "expr"
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

require("nvim-treesitter").setup({
    -- we set install_dir via the config function as before, but since we are using vim.pack,
    -- it's usually better to let it use standard paths, however I will keep your preference.
    parser_install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "treesitter", "parsers"),
})
vim.opt.runtimepath:append(vim.fs.joinpath(vim.fn.stdpath("data"), "treesitter", "parsers"))
