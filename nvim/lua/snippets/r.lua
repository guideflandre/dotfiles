local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
    -- Basic roxygen2 title and description
    s("rox", {
        t("##' "), i(1, "Title"),
        t({ "", "##'" }),
        t({ "", "##' " }), i(2, "Description"),
        t({ "", "##'" }),
        i(0)
    }),

    -- Function with parameters
    s("roxf", {
        t("##' "), i(1, "Title"),
        t({ "", "##'" }),
        t({ "", "##' " }), i(2, "Description"),
        t({ "", "##'" }),
        t({ "", "##' @param " }), i(3, "param"), t(" "), i(4, "Description"),
        t({ "", "##'" }),
        t({ "", "##' @return " }), i(5, "Description"),
        t({ "", "##'" }),
        t({ "", "##' @export" }),
        t({ "", "" }),
        i(0)
    }),

    -- Add single parameter
    s("roxp", {
        t("##' @param "), i(1, "param"), t(" "), i(2, "Description"),
        i(0)
    }),

    -- Add return value
    s("roxr", {
        t("##' @return "), i(1, "Description"),
        i(0)
    }),

    -- Add examples
    s("roxe", {
        t("##' @examples"),
        t({ "", "##' " }), i(1, "example code"),
        i(0)
    }),

    -- Export tag
    s("roxex", {
        t("##' @export"),
        i(0)
    }),

    -- Import from package
    s("roxi", {
        t("##' @importFrom "), i(1, "package"), t(" "), i(2, "function"),
        i(0)
    }),

    -- Author
    s("roxa", {
        t("##' @author "), i(1, "Name"),
        i(0)
    }),

    -- See also
    s("roxs", {
        t("##' @seealso "), i(1, "reference"),
        i(0)
    }),

    -- Full template for exported function
    s("roxfull", {
        t("##' "), i(1, "Title"),
        t({ "", "##'" }),
        t({ "", "##' " }), i(2, "Description"),
        t({ "", "##'" }),
        t({ "", "##' @param " }), i(3, "param"), t(" "), i(4, "Description"),
        t({ "", "##'" }),
        t({ "", "##' @return " }), i(5, "Description"),
        t({ "", "##'" }),
        t({ "", "##' @examples" }),
        t({ "", "##' " }), i(6, "example code"),
        t({ "", "##'" }),
        t({ "", "##' @export" }),
        t({ "", "" }),
        i(0)
    }),
}
