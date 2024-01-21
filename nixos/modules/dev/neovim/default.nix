{
  pkgs,
  lib,
  username,
  ...
}: let
  fromGitHub = rev: ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
        rev = rev;
      };
    };
in {
  home-manager.users.${username} = { pkgs, ...}: {
    home.packages = with pkgs; [
      vscode-extensions.ms-vscode.cpptools
      vscode-extensions.vadimcn.vscode-lldb
    ];
    programs = {
      neovim = {
        plugins = [
          ## Theme
          {
            plugin = pkgs.vimPlugins.tokyonight-nvim;
            config = "vim.cmd[[colorscheme tokyonight-night]]";
            type = "lua";
          }
  
          ## Treesitter
          {
            plugin = pkgs.vimPlugins.nvim-treesitter;
            config = builtins.readFile config/setup/treesitter.lua;
            type = "lua";
          }
          pkgs.vimPlugins.nvim-treesitter.withAllGrammars
          pkgs.vimPlugins.nvim-treesitter-textobjects
          {
            plugin = pkgs.vimPlugins.nvim-lspconfig;
            config = builtins.readFile config/setup/lspconfig.lua;
            type = "lua";
          }
  
          pkgs.vimPlugins.plenary-nvim
  
          ## Telescope
          {
            plugin = pkgs.vimPlugins.telescope-nvim;
            config = builtins.readFile config/setup/telescope.lua;
            type = "lua";
          }
          pkgs.vimPlugins.telescope-fzf-native-nvim
          pkgs.vimPlugins.harpoon
  
          ## cmp
          {
            plugin = pkgs.vimPlugins.nvim-cmp;
            config = builtins.readFile config/setup/cmp.lua;
            type = "lua";
          }
          pkgs.vimPlugins.cmp-nvim-lsp
          pkgs.vimPlugins.cmp-buffer
          pkgs.vimPlugins.cmp-cmdline
          pkgs.vimPlugins.cmp_luasnip
  
          ## Tpope
          pkgs.vimPlugins.vim-surround
          pkgs.vimPlugins.vim-sleuth
          pkgs.vimPlugins.vim-repeat
          pkgs.vimPlugins.copilot-vim
          # pkgs.vimPlugins.codeium-vim
  
          ## QoL
          pkgs.vimPlugins.lspkind-nvim
          pkgs.vimPlugins.rainbow
          pkgs.vimPlugins.nvim-web-devicons
          pkgs.vimPlugins.surround-nvim
          pkgs.vimPlugins.lazygit-nvim
          pkgs.vimPlugins.nvim-code-action-menu
          {
            plugin = pkgs.vimPlugins.neorg;
            config = builtins.readFile config/setup/neorg.lua;
            type = "lua";
          }
          {
            plugin = fromGitHub "6218a401824c5733ac50b264991b62d064e85ab2" "main" "m-demare/hlargs.nvim";
            config = "require('hlargs').setup()";
            type = "lua";
          }
          {
            plugin = fromGitHub "1764a8d8c25d7f6de58953362e7de79d3b3d970e" "main" "epwalsh/obsidian.nvim";
            config = ''
              require("obsidian").setup({
                workspaces = {
                  {
                    name = "notes",
                    path = "~/dev/notes",
                  },
                },
              })
            '';
            type = "lua";
          }
          (fromGitHub "f30f899c30d91bb35574ff5962103f00cc4ea23a" "main" "MattCairns/telescope-cargo-workspace.nvim")
          {
            plugin = pkgs.vimPlugins.oil-nvim;
            config = "require('oil').setup()";
            type = "lua";
          }
          {
            plugin = pkgs.vimPlugins.fidget-nvim;
            config = "require('fidget').setup{}";
            type = "lua";
          }
          {
            plugin = pkgs.vimPlugins.trouble-nvim;
            config = "require('trouble').setup {}";
            type = "lua";
          }
          {
            plugin = pkgs.vimPlugins.luasnip;
            config = builtins.readFile config/setup/luasnip.lua;
            type = "lua";
          }
          {
            plugin = pkgs.vimPlugins.comment-nvim;
            config = "require('Comment').setup()";
            type = "lua";
          }
          {
            plugin = pkgs.vimPlugins.gitsigns-nvim;
            config = "require('gitsigns').setup()";
            type = "lua";
          }
          {
            plugin = pkgs.vimPlugins.lualine-nvim;
            config = ''
              require('lualine').setup {
                  options = {
                      theme = 'tokyonight',
                  }
              }
            '';
            type = "lua";
          }
          {
            plugin = pkgs.vimPlugins.noice-nvim;
            config = ''
              require("noice").setup({
                lsp = {
                  -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                  override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                  },
                },
                -- you can enable a preset for easier configuration
                presets = {
                  bottom_search = true, -- use a classic bottom cmdline for search
                  command_palette = true, -- position the cmdline and popupmenu together
                  long_message_to_split = true, -- long messages will be sent to a split
                  inc_rename = false, -- enables an input dialog for inc-rename.nvim
                  lsp_doc_border = false, -- add a border to hover docs and signature help
                },
              })
            '';
            type = "lua";
          }
  
          ## Debugging
          pkgs.vimPlugins.nvim-dap-ui
          pkgs.vimPlugins.nvim-dap-virtual-text
          {
            plugin = pkgs.vimPlugins.nvim-dap;
            config = builtins.readFile config/setup/dap.lua;
            type = "lua";
          }
          {
            plugin = pkgs.vimPlugins.crates-nvim;
            config = "require('crates').setup{}";
            type = "lua";
          }
          pkgs.vimPlugins.rustaceanvim
        ];
  
        extraLuaConfig = ''
          ${builtins.readFile config/mappings.lua}
          ${builtins.readFile config/options.lua}
        '';
        enable = true;
        viAlias = true;
        vimAlias = true;
      };
    };
  };
}
