local success, ls = pcall(require, "luasnip")
if not success then return end
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local types = require("luasnip.util.types")

---#Config
ls.config.set_config({
    -- Remember the last snippet I was in
    history = true,

    -- Update snippet text in _real time_
    updateevents = "TextChanged,TextChangedI",

    -- Show virtual text hints for node types
    ext_opts = {
        [types.insertNode] = {
            active = {
                virt_text = { { "●", "Operator" } },
            },
        },
        [types.choiceNode] = {
            active = {
                virt_text = { { "●", "Constant" } },
            },
        },
    },
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
{doc}
{type} {async}{name}({params}): {ret} {{
	{body}
}}
]]
local ts_function_snippet = function(type)
    return fmt(ts_function_fmt, {
        doc = d(1, function(args)
            local params_str = args[1][1]
            local return_type = args[2][1]
            local nodes = { t({ "/**", " * " }), r(1, "description", i(nil)) }
            for _, param in ipairs(vim.split(params_str, ",", true)) do
                local name = param:match("([%a%d_-]+):?")
                if name then
                    local str = " * @param " .. name
                    table.insert(nodes, t({ "", str }))
                end
            end
            vim.list_extend(nodes, { t({ "", " * @returns " .. return_type, " */" }) })
            return sn(nil, nodes)
        end, { 4, 5 }),
        -- doc = c(1, { sn(nil, { t({ "/**", " * " }), i(1), t({ "", " */" }) }), t("") }),
        type = t(type),
        async = c(2, { t("async "), t("") }),
        name = i(3, "funcName"),
        params = i(4),
        ret = d(5, function(args)
            local async = string.match(args[1][1], "async")
            if async == nil then
                return sn(nil, {
                    r(1, "return_type", i(nil, "void")),
                })
            end
            return sn(nil, {
                t("Promise<"),
                r(1, "return_type", i(nil, "void")),
                t(">"),
            })
        end, { 2 }),
        body = i(0),
    }, {
        stored = {
            ["return_type"] = i(nil, "void"),
            ["description"] = i(nil, "description"),
        },
    })
end

local ts_loop_fmt = [[
.{type}({async}({item}) => {{
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
    -- methods
    s("public", ts_function_snippet("public")),
    s("private", ts_function_snippet("private")),
    -- array methods
    s(".map", ts_loop_snippet("map")),
    s(".filter", ts_loop_snippet("filter")),
    s(".forEach", ts_loop_snippet("forEach")),
    s(".find", ts_loop_snippet("find")),
    s(".some", ts_loop_snippet("some")),
    s(".every", ts_loop_snippet("every")),
    -- tests
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
})
