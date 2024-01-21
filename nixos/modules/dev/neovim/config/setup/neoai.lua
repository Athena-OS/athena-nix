require('neoai').setup{
    -- Below are the default options, feel free to override what you would like changed
    ui = {
        output_popup_text = "NeoAI",
        input_popup_text = "Prompt",
        width = 30,      -- As percentage eg. 30%
        output_popup_height = 80, -- As percentage eg. 80%
    },
    models = {
        {
            name = "openai",
            model = "gpt-3.5-turbo"
        },
    },
    register_output = {
        ["g"] = function(output)
            return output
        end,
        ["c"] = require("neoai.utils").extract_code_snippets,
    },
    inject = {
        cutoff_width = 75,
    },
    prompts = {
        context_prompt = function(context)
            return "Hey, I'd like to provide some context for future "
                .. "messages. Here is the code/text that I want to refer "
                .. "to in our upcoming conversations:\n\n"
                .. context
        end,
    },
    open_api_key_env = "OPENAI_API_KEY",
    shortcuts = {
        {
            name = "textify",
            key = "<leader>as",
            desc = "fix text with AI",
            use_context = true,
            prompt = [[
            Act as a c++ developer documenting code.  Only write documentation in the form of a doxygen comment.  Do not write aything else.
            ]],
            modes = { "v" },
            strip_function = nil,
        },
        {
            name = "flatbuffer",
            key = "<leader>fb",
            desc = "fix text with AI",
            use_context = true,
            prompt = [[
            Act as a c++ developer writing code to test flatbuffer schemas.  Only write c++ code and nothing else. Convert the given flatbuffer schema to c++ code, fill the flatbuffer with dummy data.
            ]],
            modes = { "v" },
            strip_function = nil,
        },
        {
            name = "gitcommit",
            key = "<leader>ag",
            desc = "generate git commit message",
            use_context = false,
            prompt = function ()
                return [[
                    Using the following git diff generate a consise and
                    clear git commit message, with a short title summary
                    that is 75 characters or less:
                ]] .. vim.fn.system("git diff --cached")
            end,
            modes = { "n" },
            strip_function = nil,
        },
    },
}
