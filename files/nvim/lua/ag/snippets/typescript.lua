require("luasnip.session.snippet_collection").clear_snippets("typescript")
local success, ls = pcall(require, "luasnip")
if not success then return end
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt

local ts_function_fmt = [[
{doc}
{type} {async}{name}({params}): {ret} {{
	{body}
}}
]]
local ts_function_snippet = function(type)
    return fmt(ts_function_fmt, {
        doc = isn(1, {
            t({ "/**", " " }),
            i(1, "function description"),
            c(2, {
                sn(nil, {
                    t({ "", " @returns " }),
                    i(1, "return description"),
                }),
                t(""),
            }),
            t({ "", "/" }),
        }, "$PARENT_INDENT *"),
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
    -- block comments
    s(
        { trig = "/**", snippetType = "autosnippet" },
        fmt(
            [[
/**
 * {comment}
 */
        ]],
            {
                comment = isn(0, {
                    i(1),
                }, "$PARENT_INDENT *"),
            }
        )
    ),
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
}
