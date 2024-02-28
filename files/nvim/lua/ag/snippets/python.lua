local success, ls = pcall(require, "luasnip")
if not success then return end
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt

---Choice snippet to toggle between python docstring and empty text node
---@param order number where in the root snippet the docstring appears
---@param default 'DOC' | 'NONE' the default choice to be returned
local optional_docstring_choice = function(order, default)
    local docstr = sn(nil, {
        t({ '"""', "\t" }),
        i(1, "description"),
        t({ "", '\t"""', "\t" }),
    })

    if default == "DOC" then return c(order, {
        docstr,
        t(""),
    }) end
    return c(order, {
        t(""),
        docstr,
    })
end

---
local function_fmt = [[
def {name}({params}){ret}:
	{doc}{body}
]]
local function_snippet = s(
    "def",
    fmt(function_fmt, {
        doc = optional_docstring_choice(1, "DOC"),
        name = c(2, {
            r(nil, "func_name", i(nil, "public_function")),
            sn(nil, {
                t("_"),
                r(1, "func_name", i(nil, "private_function")),
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
        body = i(0, "..."),
    }, {
        stored = {
            ["return_type"] = i(nil, "None"),
            ["func_name"] = i(nil, "function_name"),
        },
    })
)
---

---
local class_fmt = [[
class {cls}{parent}:
	{doc}{body}
]]
local class_snippet = s(
    "class",
    fmt(class_fmt, {
        doc = optional_docstring_choice(1, "DOC"),
        cls = i(2, "ClassName"),
        parent = c(3, {
            t(""),
            sn(nil, {
                t("("),
                i(1, "ParentClass"),
                t(")"),
            }),
        }),
        body = i(0, "..."),
    })
)
---

---
local if_name_main_fmt = [[
if __name__ == "__main__":
	{main}
]]
local if_name_main_snippet = s("inm", fmt(if_name_main_fmt, { main = i(0) }))
---

return {
    function_snippet,
    class_snippet,
    if_name_main_snippet,
}
