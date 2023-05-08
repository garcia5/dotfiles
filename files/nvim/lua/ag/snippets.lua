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
        -- function is called every time the function parameters ({params} in `fmt`) are updated
        doc = d(1, function(args)
            -- params_str = "param1: string, param2: other string, @Param('param3') param3: string"
            local params_str = args[1][1]

            local nodes = { t({ "/**", " * " }), r(1, "description", i(nil)) }
            -- after `nodes`: [[
            -- /**
            --  * |
            -- ]]
            for _, param in ipairs(vim.split(params_str, ",", { trimEmpty = true, plain = true })) do
                local name = param:match("([%a%d_-]+) ?:")
                if name then
                    local str = " * @param " .. name
                    table.insert(nodes, t({ "", str }))
                end
            end
            -- after inserting `params_str`: [[
            -- /**
            --  * inserted `description` here
            --  * @param param1
            --  * @param param2
            --  * @param param3
            -- ]]

            -- use restore_node to remember choice as params are added
            local return_str = r(
                2,
                "return_choice",
                c(nil, {
                    sn(nil, {
                        t({ "", " * @returns " }),
                        r(1, "return_description", i(nil)),
                    }),
                    t(""),
                })
            )
            -- after return_str:
            -- choice 1: [[
            --
            -- /**
            --  * inserted `description` here
            --  * @param param1
            --  * @param param2
            --  * @param param3
            --  * @returns |
            -- ]]
            --
            -- choice 2: [[
            --
            -- /**
            --  * inserted `description` here
            --  * @param param1
            --  * @param param2
            --  * @param param3|
            -- ]]
            local end_comment = t({ "", " */" })
            vim.list_extend(nodes, { return_str, end_comment })
            -- final: [[
            --
            -- /**
            --  * inserted `description` here
            --  * @param param1
            --  * @param param2
            --  * @param param3
            --  * @returns inserted `return_description` here
            --  */
            --
            -- OR
            --
            -- /**
            --  * inserted `description` here
            --  * @param param1
            --  * @param param2
            --  * @param param3
            --  */
            -- ]]
            return sn(nil, nodes)
        end, { 4 }),
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
            ["return_description"] = i(nil, ""),
            ["return_choice"] = i(nil, ""),
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

return {
    typescript = {
        -- methods
        s("public", ts_function_snippet("public")),
        s("private", ts_function_snippet("private")),
        -- array methods
        s({ trig = ".map", wordTrig = false }, ts_loop_snippet("map")),
        s({ trig = ".filter", wordTrig = false }, ts_loop_snippet("filter")),
        s({ trig = ".forEach", wordTrig = false }, ts_loop_snippet("forEach")),
        s({ trig = ".find", wordTrig = false }, ts_loop_snippet("find")),
        s({ trig = ".some", wordTrig = false }, ts_loop_snippet("some")),
        s({ trig = ".every", wordTrig = false }, ts_loop_snippet("every")),
        -- tests
        s(
            "describe",
            fmt(
                [[
describe('{suite}', () => {{
	{body}
}});
        ]],
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
    ]],
                {
                    test_case = i(1, "does something"),
                    async = c(2, { t("async "), t("") }),
                    body = i(0),
                }
            )
        ),
    },
}
