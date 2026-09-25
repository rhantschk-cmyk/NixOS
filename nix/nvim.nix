{ pkgs, inputs, ... }:

let
  love-api = pkgs.fetchFromGitHub {
    owner = "love2d-community";
    repo = "love-api";
    rev = "447486c14b7af6ffb610c47d9b800703b4e628f4";
    hash = "sha256-8/0/In18VfxXP4f6e5OPde0eWIp6nuAuuMXgRmTwkI4=";
  };
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      love
      git
      ripgrep
      fd
      curl
      wget
    ];

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;
      termguicolors = true;
      cursorline = true;
      signcolumn = "yes";
      mouse = "a";
      clipboard = "unnamedplus";
      ignorecase = true;
      smartcase = true;
      updatetime = 250;
      timeoutlen = 300;
    };

    colorschemes.tokyonight = {
      enable = true;
      settings.style = "storm";
    };

    plugins = {
      nvim-autopairs.enable = true;
      telescope.enable = true;

      treesitter = {
        enable = true;
        nixvimInjections = true;
      };

      cmp = {
        enable = true;
        settings = {
          autoEnableSources = true;
          sources = [
            { name = "nvim_lsp"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            "<C-e>" = "cmp.mapping.abort()";
          };
        };
      };

      lsp = {
        enable = true;
        keymaps = {
          silent = true;
          lspBuf = {
            "gd" = "definition";
            "gD" = "declaration";
            "gr" = "references";
            "gi" = "implementation";
            "K" = "hover";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
          };
        };

        servers = {
          gopls = {
            enable = true;
            settings = {
              gopls = {
                gofumpt = true;
                staticcheck = true;
                usePlaceholders = true;
                analyses = {
                  unusedparams = true;
                  shadow = true;
                };
              };
            };
          };

          zls.enable = true;

          lua_ls = {
            enable = true;
            settings = {
              Lua = {
                runtime.version = "LuaJIT";
                diagnostics.globals = [ "vim" "love" ];
                telemetry.enable = false;
                workspace = {
                  checkThirdParty = false;
                  library = [
                    "diagnostics.globals"
                    "${love-api}"
                  ];
                };
              };
            };
          };
        };
      };
    };

    # Hier sind ausnahmslos NUR NOCH mode, key und action definiert. Kein expr, kein silent!
    keymaps = [
      { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; }
      { mode = "n"; key = "<leader>e"; action = "<cmd>lua vim.diagnostic.open_float()<CR>"; }
      { mode = "n"; key = "[d"; action = "<cmd>lua vim.diagnostic.goto_prev()<CR>"; }
      { mode = "n"; key = "]d"; action = "<cmd>lua vim.diagnostic.goto_next()<CR>"; }
      { mode = "n"; key = "<leader>f"; action = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>"; }
      { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<CR>"; }
      { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<CR>"; }
      { mode = "n"; key = "<leader>fb"; action = "<cmd>Telescope buffers<CR>"; }
      { mode = "n"; key = "<leader>fh"; action = "<cmd>Telescope help_tags<CR>"; }
    ];

    diagnostic = {
      settings = {
        virtual_text = true;
        signs = true;
        underline = true;
        update_in_insert = false;
        severity_sort = true;
        float = {
          border = "rounded";
        };
      };
    };

    extraConfigLua = ''
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    '';
  };
}

