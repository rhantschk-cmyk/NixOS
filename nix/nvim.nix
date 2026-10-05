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
      git
      ripgrep
      fd
      curl
      wget
      typescript
      typescript-language-server
      vscode-langservers-extracted
      prettier
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

    plugins.alpha = {
      enable = true;
      theme = "dashboard";
  
      layout = [
        # 1. Willkommens-Text
        {
          type = "text";
          val = "👋 Willkommen zurück, Raphael!";
          opts = {
            position = "center";
            hl = "Comment"; # Macht den Text dezent grau/kursiv
          };
        }
        {
          type = "padding";
          val = 1;
        }
  
        # 2. Hellblaues NIXVIM ASCII-Logo
        {
          type = "text";
          val = [
            "  _   _ _____  ______     _______ __  __ "
            " | \\ | |_   _|\\ \\ / / \\   / /_   _|  \\/  |"
            " |  \\| | | |   \\ V / \\ \\ / /  | | | |\\/| |"
            " | |\\  | | |    > <   \\ V /   | | | |  | |"
            " |_| \\_|____|  /_/\\_\\   \\_/   |___|_|  |_|"
          ];
          opts = {
            position = "center";
            hl = "DiagnosticInfo"; # Nutzt die vordefinierte hellblaue Farbe deines Themes
          };
        }
        {
          type = "padding";
          val = 2;
        }
  
        # 3. Deine nützlichen Aktionen (abgestimmt auf deine Keymaps)
        {
          type = "buttons";
          val = [
            [ "f" "  Datei suchen" "<cmd>Telescope find_files<CR>" ]
            [ "g" "  Text im Projekt suchen" "<cmd>Telescope live_grep<CR>" ]
            [ "b" "  Geöffnete Dokumente (Buffers)" "<cmd>Telescope buffers<CR>" ]
            [ "n" "    Leere Datei erstellen" "<cmd>ene <BAR> startinsert <CR>" ]
            [ "q" "    Neovim beenden" "<cmd>qa<CR>" ]
          ];
        }
        {
          type = "padding";
          val = 1;
        }
  
        # 4. Eine kleine Fußzeile, die anzeigt, wie viele Plugins geladen wurden
        {
          type = "text";
          val = "⚡ Nixvim geladen mit purer Performance";
          opts = {
            position = "center";
            hl = "Comment";
          };
        }
      ];
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

      gitsigns.enable = true;

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
          nixd.enable = true;
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

          pyright = {
            enable = true;
            settings = {
              python = {
                analyses = {
                  autoSearchPaths = true;
                  useLibraryCodeForTypes = true;
                  diagnosticMode = "workspace";
                };
              };
            };
          };

          zls.enable = true;

          ts_ls.enable = true;
          html.enable = true;
          cssls.enable = true;
          jsonls.enable = true;
        };
      };
      ruff = {
          enable = true;
          extraOptions = {
            on_attach = ''
              function(client, bufnr)
                if client.name == "ruff" then
                  client.server_capabilities.hoverProvider = false
                end
              end
            '';
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
      { mode = "n"; key = "<leader>rn"; action = "<cmd>lua vim.lsp.buf.rename()<CR>"; }
      { mode = "n"; key = "<leader>ca"; action = "<cmd>lua vim.lsp.buf.code_action()<CR>"; }
      { mode = "n"; key = "gd"; action = "<cmd>lua vim.lsp.buf.definition()<CR>"; } 
      { mode = "n"; key = "gr"; action = "<cmd>Telescope lsp_references<CR>"; }    
      { mode = "n"; key = "K";  action = "<cmd>lua vim.lsp.buf.hover()<CR>"; }     
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

