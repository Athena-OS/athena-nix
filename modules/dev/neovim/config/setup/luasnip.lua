local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

-- If you're reading this file for the first time, best skip to around line 190
-- where the actual snippet-definitions start.

-- Every unspecified option will be set to the default.
ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	update_events = "TextChanged,TextChangedI",
	-- Snippets aren't automatically removed if their text is deleted.
	-- `delete_check_events` determines on which events (:h events) a check for
	-- deleted snippets is performed.
	-- This can be especially useful when `history` is enabled.
	delete_check_events = "TextChanged",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { " <- Current Choice", "Comment" } },
			},
		},
	},
	-- treesitter-hl has 100, use something higher (default is 200).
	ext_base_prio = 300,
	-- minimal increase in priority.
	ext_prio_increase = 1,
	enable_autosnippets = true,
	-- mapping for cutting selected text so it's usable as SELECT_DEDENT,
	-- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
	store_selection_keys = "<Tab>",
	-- luasnip uses this function to get the currently active filetype. This
	-- is the (rather uninteresting) default, but it's possible to use
	-- eg. treesitter for getting the current filetype by setting ft_func to
	-- require("luasnip.extras.filetype_functions").from_cursor (requires
	-- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
	-- the current filetype in eg. a markdown-code block or `vim.cmd()`.
	ft_func = function()
		return vim.split(vim.bo.filetype, ".", true)
	end,
})

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
	return args[1]
end

-- 'recursive' dynamic snippet. Expands to some text followed by itself.
local rec_ls
rec_ls = function()
	return sn(
		nil,
		c(1, {
			-- Order is important, sn(...) first would cause infinite loop of expansion.
			t(""),
			sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
		})
	)
end

-- complicated function for dynamicNode.
local function jdocsnip(args, _, old_state)
	-- !!! old_state is used to preserve user-input here. DON'T DO IT THAT WAY!
	-- Using a restoreNode instead is much easier.
	-- View this only as an example on how old_state functions.
	local nodes = {
		t({ "/**", " * " }),
		i(1, "A short Description"),
		t({ "", "" }),
	}

	-- These will be merged with the snippet; that way, should the snippet be updated,
	-- some user input eg. text can be referred to in the new snippet.
	local param_nodes = {}

	if old_state then
		nodes[2] = i(1, old_state.descr:get_text())
	end
	param_nodes.descr = nodes[2]

	-- At least one param.
	if string.find(args[2][1], ", ") then
		vim.list_extend(nodes, { t({ " * ", "" }) })
	end

	local insert = 2
	for indx, arg in ipairs(vim.split(args[2][1], ", ", true)) do
		-- Get actual name parameter.
		arg = vim.split(arg, " ", true)[2]
		if arg then
			local inode
			-- if there was some text in this parameter, use it as static_text for this new snippet.
			if old_state and old_state[arg] then
				inode = i(insert, old_state["arg" .. arg]:get_text())
			else
				inode = i(insert)
			end
			vim.list_extend(
				nodes,
				{ t({ " * @param " .. arg .. " " }), inode, t({ "", "" }) }
			)
			param_nodes["arg" .. arg] = inode

			insert = insert + 1
		end
	end

	if args[1][1] ~= "void" then
		local inode
		if old_state and old_state.ret then
			inode = i(insert, old_state.ret:get_text())
		else
			inode = i(insert)
		end

		vim.list_extend(
			nodes,
			{ t({ " * ", " * @return " }), inode, t({ "", "" }) }
		)
		param_nodes.ret = inode
		insert = insert + 1
	end

	if vim.tbl_count(args[3]) ~= 1 then
		local exc = string.gsub(args[3][2], " throws ", "")
		local ins
		if old_state and old_state.ex then
			ins = i(insert, old_state.ex:get_text())
		else
			ins = i(insert)
		end
		vim.list_extend(
			nodes,
			{ t({ " * ", " * @throws " .. exc .. " " }), ins, t({ "", "" }) }
		)
		param_nodes.ex = ins
		insert = insert + 1
	end

	vim.list_extend(nodes, { t({ " */" }) })

	local snip = sn(nil, nodes)
	-- Error on attempting overwrite.
	snip.old_state = param_nodes
	return snip
end

-- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
local function bash(_, _, command)
	local file = io.popen(command, "r")
	local res = {}
	for line in file:lines() do
		table.insert(res, line)
	end
	return res
end

-- Returns a snippet_node wrapped around an insert_node whose initial
-- text value is set to the current date in the desired format.
local date_input = function(args, snip, old_state, fmt)
	local fmt = fmt or "%Y-%m-%d"
	return sn(nil, i(1, os.date(fmt)))
end

local delete_class = function(class_name)
  return sn(nil, {
          t({"", "\t"}), t(class_name), t("(const "), t(class_name), t("&) = delete;"),
          t({"", "\t"}), t(class_name), t("& operator=(const "), t(class_name), t("&) = delete;"), 
         })
end


local rec_ls
rec_ls = function()
	return sn(nil, {
		c(1, {
			t({""}),
			sn(nil, {t( " << "), i(1), d(2, rec_ls, {})}),
		}),
	});
end

ls.add_snippets("cpp", {
	s("cp", {
    t("// Copyright 2023 Open Ocean Robotics"), i(0)
	}),

	s("fn", {
		i(1, "rtype"),
    t(" "),
		i(2, "foo"),
		t("("),
		i(3, "int bar"),
    c(4, {
      sn(nil, {
        t(");"),
        i(1),
      }),
		  sn(nil, { 
        t({ ") {", "\t" }),
        i(1),
		    t({ "", "}" }),
      }),
    }),
		i(0),
	}),

	s("inc", {
		t("#include "),
    c(1, {
      sn(nil, {t("\""), i(1, "file.h"), t("\"")}),
      sn(nil, {t("<"), i(1, "file.h"), t(">")}),
    }),
    i(0),
	}),

  s("cout", {
    t("std::cout << "), i(1), d(2, rec_ls, {}), t(" << std::endl;"), i(0)
  }),

  s('once', {
    t('#ifndef '),
    dl(1, l.TM_FILENAME:upper():gsub('%.', '_'), {}),
    t({'', '#define '}),
    f(function(args) return args[1][1] end, {1}),
    t({'', '', ''}),
    i(0),
    t({'', '', '#endif // '}),
    f(function(args) return args[1][1] end, {1}),
  }),

  s("cla", {
    t("class "), i(1, "ClassName"), t(" {"),
    t({"", "public:"}),
    t({"", "\t"}), f(copy, 1), t("();"),
    t({"", "\tvirtual ~"}), f(copy, 1), t("() {}"),
    t({"", ""}),
    t({"", "private:"}),
    t({"", "\t"}), f(copy, 1), t(" (const "), f(copy, 1), t("&) = delete;"),
    t({"", "\t"}), f(copy, 1), t("& operator = (const "), f(copy, 1), t("&) = delete;"),
    c(2, {
      t(""),
      d(3, delete_class, { 1 })
    }),
    t({"", "};"}),
    i(0),
  })
})

-- set type to "autosnippets" for adding autotriggered snippets.
ls.add_snippets("all", {
	s("autotrigger", {
		t("autosnippet"),
	}),
}, {
	type = "autosnippets",
	key = "all_auto",
})

-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2)
vim.keymap.set("i", "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice")

-- shorcut to source my luasnips file again, which will reload my snippets
vim.keymap.set("n", "<leader><leader>r", "<cmd>source ~/.config/nvim/lua/setup/luasnip.lua<CR>")
