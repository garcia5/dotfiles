local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt

---#Config
ls.config.set_config({
    -- Remember the last snippet I was in
    history = true,

    -- Update snippet text in _real time_
    updateevents = "TextChanged,TextChangedI",

    enable_autosnippets = true,
})

---#Mappings
-- Previous snippet region
vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if ls.jumpable(-1) then ls.jump(-1) end
end, { silent = true })

-- Next snippet region
vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if ls.jumpable(1) then ls.jump(1) end
end, { silent = true })

-- Cycle "choices" for current snippet region
vim.keymap.set({ "i", "s" }, "<C-l>", function()
    if ls.choice_active() then ls.change_choice(1) end
end)

-- DEBUG: reload snippets
vim.keymap.set("n", "<leader><leader>s", function()
    ls.cleanup()
    vim.cmd("source ~/.config/nvim/lua/ag/plugin-conf/luasnip.lua")
end)

--[[
--#Snippets
--]]

---#Typescript
local ts_function_fmt = [[
{type} {async}{name}({params}): {ret} {{
	{body}
}}
]]
local ts_function_snippet = function(type)
    return fmt(ts_function_fmt, {
        type = t(type),
        async = c(1, { t("async "), t("") }),
        name = i(2, "funcName"),
        params = i(3, "args"),
        ret = d(4, function(args)
            local async = string.match(args[1][1], "async")
            if async == nil then
                return sn(nil, {
                    r(1, "return_type", i(nil, "return")),
                })
            end
            return sn(nil, {
                t("Promise<"),
                r(1, "return_type", i(nil, "return")),
                t(">"),
            })
        end, { 1 }),
        body = i(0),
    }, {
        stored = {
            ["return_type"] = i(nil, "return"),
        },
    })
end

local ts_loop_fmt = [[
{type}({async}({item}) => {{
	{body}
}})
]]
local ts_loop_snippet = function(type)
    return fmt(ts_loop_fmt, {
        type = t(type),
        async = c(1, { t(""), t("async ") }),
        item = c(2, { i(1, "item"), sn(nil, { t("{ "), i(1, "field"), t(" }") }) }),
        body = i(0),
    })
end
ls.add_snippets("typescript", {
    s("public", ts_function_snippet("public")),
    s("private", ts_function_snippet("private")),
    s(
        "describe",
        fmt(
            [[
describe('{suite}', () => {{
	{body}
}});
        ]]   ,
            {
                suite = i(1, "function or module"),
                body = i(0),
            }
        )
    ),
    s(
        "it",
        fmt(
            [[
it('{test_case}', {async}() => {{
	{body}
}});
    ]]       ,
            {
                test_case = i(1, "does something"),
                async = c(2, { t("async "), t("") }),
                body = i(0),
            }
        )
    ),
    s("map", ts_loop_snippet("map")),
    s("filter", ts_loop_snippet("filter")),
    s("forEach", ts_loop_snippet("forEach")),
})
