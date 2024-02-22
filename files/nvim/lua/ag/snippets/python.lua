local success, ls = pcall(require, "luasnip")
if not success then return end
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt

local py_function_fmt = [[
def {name}({params}){ret}:
	{doc}
	{body}
]]
local python_function_snippet = function()
    return fmt(py_function_fmt, {
        doc = sn(1, {
            t({ '"""', "\t" }),
            i(1, "function description"),
            t({ "", '\t"""' }),
        }),
        name = c(2, {
            r(nil, "func_name", i(nil, "func_name")),
            sn(nil, {
                t("_"),
                r(1, "func_name", i(nil, "func_name")),
            }),
        }),
        params = i(3),
        ret = c(4, {
            sn(nil, {
                t({ " -> " }),
                r(1, "return_type", i(nil, "None")),
            }),
            t(""),
        }),
        body = i(0),
    }, {
        stored = {
            ["return_type"] = i(nil, "None"),
        },
    })
end

local if_name_main_fmt = [[
if __name__ == "__main__":
    {main}
]]

return {
    s("def", python_function_snippet()),
    s("inm", fmt(if_name_main_fmt, { main = i(0) })),
}
