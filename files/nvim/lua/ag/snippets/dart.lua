local success, ls = pcall(require, "luasnip")
if not success then return end
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
    s(
        "StatelessWidget",
        fmt(
            [[
class {name} extends StatelessWidget {{
	{name_rep}({{super.key}});

	@override
	Widget build(BuildContext context) {{
		return {body}
	}}
}}
]],
            {
                name = i(1, "WidgetName"),
                name_rep = rep(1),
                body = i(0),
            }
        )
    ),
    s(
        "StatefulWidget",
        fmt(
            [[
class {name} extends StatefulWidget {{
	{name_rep}({{super.key}});

	@override
	State<{name_rep}> createState() => {impl_name}();
}}

class {impl_name} extends State<{name_rep}> {{
	@override
	Widget build(BuildContext context) {{
		return {body}
	}}
}}
]],
            {
                name = i(1, "WidgetName"),
                name_rep = rep(1),
                impl_name = f(function(args)
                    local widget_name = args[1][1]
                    return "_" .. widget_name .. "State"
                end, { 1 }),
                body = i(0),
            }
        )
    ),
}
