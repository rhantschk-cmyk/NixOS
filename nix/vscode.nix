{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Language servers, formatters, debuggers, and build tooling for VS Code.
    gopls
    gofumpt
    golangci-lint
    delve
    zls
    lua-language-server
    stylua
    typescript-language-server
    eslint
    prettier
    biome
    clang-tools
    cmake
    ninja
    lldb
    gdb
    nixd
    nixfmt
    vscode-langservers-extracted
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 14;
          y = 12;
        };
        dynamic_padding = true;
        opacity = 0.97;
        title = "Terminal";
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        size = 12.5;
      };

      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
        vi_mode_style.shape = "Block";
      };

      selection.save_to_clipboard = true;

      # Tokyo Night Storm with Discord's blue-gray surfaces and accent blue.
      colors = {
        primary = {
          background = "#1E1F2B";
          foreground = "#C9D1E8";
          bright_foreground = "#E2E8FF";
        };
        cursor = {
          text = "#1E1F2B";
          cursor = "#7AA2F7";
        };
        selection = {
          text = "#E2E8FF";
          background = "#34466F";
        };
        normal = {
          black = "#191B26";
          red = "#F7768E";
          green = "#9ECE6A";
          yellow = "#E0AF68";
          blue = "#7AA2F7";
          magenta = "#BB9AF7";
          cyan = "#7DCFFF";
          white = "#A9B1D6";
        };
        bright = {
          black = "#565F89";
          red = "#FF899D";
          green = "#B9F27C";
          yellow = "#F2C982";
          blue = "#89B4FA";
          magenta = "#CAA9FA";
          cyan = "#9BE4FF";
          white = "#D5DCFA";
        };
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      # Keep the declarative baseline, but let VS Code persist changes made
      # through its Settings UI instead of pointing settings.json at /nix/store.
      mutableUserSettings = true;

      extensions = with pkgs.vscode-extensions; [
        # Core look, navigation, and editor ergonomics.
        enkia.tokyo-night
        pkief.material-icon-theme
        vscodevim.vim
        usernamehw.errorlens
        oderwat.indent-rainbow
        editorconfig.editorconfig
        aaron-bond.better-comments
        alefragnani.bookmarks
        alefragnani.project-manager
        gruntfuggly.todo-tree

        # GitHub and Git.
        eamodio.gitlens
        github.vscode-pull-request-github
        github.vscode-github-actions
        mkhl.direnv

        # Go and Zig.
        golang.go
        ziglang.vscode-zig

        # JavaScript and TypeScript.
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        biomejs.biome
        yoavbls.pretty-ts-errors

        # Lua.
        sumneko.lua

        # C and C++.
        ms-vscode.cpptools
        ms-vscode.cmake-tools
        llvm-vs-code-extensions.vscode-clangd
        vadimcn.vscode-lldb

        # Nix, containers, remote work, and config formats.
        jnoortheen.nix-ide
        arrterian.nix-env-selector
        ms-azuretools.vscode-docker
        ms-vscode.remote-explorer
        redhat.vscode-yaml
        tamasfe.even-better-toml

        # Documentation and data files.
        yzhang.markdown-all-in-one
        davidanson.vscode-markdownlint
        bierner.markdown-mermaid
      ];

      userSettings = {
        "workbench.colorTheme" = "Tokyo Night Storm";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.productIconTheme" = "material-product-icons";
        "window.titleBarStyle" = "custom";
        "window.commandCenter" = true;
        "window.density.editorTabHeight" = "compact";
        "workbench.activityBar.location" = "left";
        "workbench.sideBar.location" = "left";
        "workbench.editor.enablePreview" = false;
        "workbench.startupEditor" = "none";
        "workbench.list.smoothScrolling" = true;
        "workbench.tree.indent" = 16;
        "workbench.tree.renderIndentGuides" = "always";

        "editor.fontFamily" = "JetBrainsMono Nerd Font, JetBrains Mono, monospace";
        "editor.fontSize" = 15;
        "editor.fontLigatures" = true;
        "editor.lineHeight" = 24;
        "editor.cursorBlinking" = "smooth";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.smoothScrolling" = true;
        "editor.minimap.enabled" = false;
        "editor.stickyScroll.enabled" = true;
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = "active";
        "editor.guides.indentation" = true;
        "editor.renderWhitespace" = "selection";
        "editor.renderControlCharacters" = false;
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.codeActionsOnSave" = {
          "source.fixAll.eslint" = "explicit";
          "source.organizeImports" = "explicit";
        };

        "terminal.integrated.defaultProfile.linux" = "bash";
        "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
        "terminal.integrated.fontSize" = 14;
        "terminal.integrated.fontWeight" = "500";
        "terminal.integrated.cursorStyle" = "line";
        "terminal.integrated.smoothScrolling" = true;
        "terminal.integrated.gpuAcceleration" = "on";
        "terminal.integrated.minimumContrastRatio" = 1;

        "explorer.confirmDelete" = false;
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;
        "files.exclude" = {
          "**/.direnv" = true;
          "**/.git" = false;
        };

        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "git.openRepositoryInParentFolders" = "always";
        "gitlens.codeLens.enabled" = true;
        "gitlens.currentLine.enabled" = true;

        "vim.leader" = "<space>";
        "vim.useSystemClipboard" = true;
        "vim.highlightedyank.enable" = true;
        "vim.smartRelativeLine" = true;
        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            before = [ "<leader>" "f" "f" ];
            commands = [ "workbench.action.quickOpen" ];
          }
          {
            before = [ "<leader>" "g" "g" ];
            commands = [ "workbench.view.scm" ];
          }
          {
            before = [ "<leader>" "e" ];
            commands = [ "workbench.view.explorer" ];
          }
        ];

        "go.useLanguageServer" = true;
        "go.toolsManagement.autoUpdate" = false;
        "go.formatTool" = "gofumpt";
        "go.lintTool" = "golangci-lint";
        "go.lintOnSave" = "package";
        "go.testFlags" = [ "-v" ];
        "go.coverOnSave" = true;
        "go.coverageDecorator" = {
          "type" = "highlight";
          "coveredHighlightColor" = "#2E7D5B55";
          "uncoveredHighlightColor" = "#A83A4A55";
        };

        "zig.path" = "${pkgs.zig}/bin/zig";
        "zig.zls.path" = "${pkgs.zls}/bin/zls";
        "zig.zls.enableInlayHints" = true;

        "typescript.tsserver.useSyntaxServer" = "never";
        "typescript.updateImportsOnFileMove.enabled" = "always";
        "javascript.updateImportsOnFileMove.enabled" = "always";
        "eslint.useFlatConfig" = true;
        "prettier.requireConfig" = false;

        "lua.runtime.version" = "LuaJIT";
        "lua.format.enable" = false;

        "C_Cpp.intelliSenseEngine" = "disabled";
        "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
        "clangd.arguments" = [ "--background-index" "--clang-tidy" "--completion-style=detailed" ];
        "cmake.configureOnOpen" = true;
        "cmake.generator" = "Ninja";

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
        "nix.formatterPath" = "${pkgs.nixfmt}/bin/nixfmt";

        "errorLens.enabled" = true;
        "errorLens.messageBackgroundMode" = "line";
        "todo-tree.highlights.defaultHighlight" = {
          "foreground" = "#E2E8FF";
          "background" = "#34466F";
          "icon" = "alert";
        };

        "workbench.colorCustomizations" = {
          "[Tokyo Night Storm]" = {
            "editor.background" = "#1E1F2B";
            "editor.foreground" = "#C9D1E8";
            "editor.lineHighlightBackground" = "#292E4255";
            "editor.selectionBackground" = "#34466FCC";
            "editor.inactiveSelectionBackground" = "#2B365A99";
            "editorCursor.foreground" = "#89B4FA";
            "editorLineNumber.foreground" = "#6E789D";
            "editorLineNumber.activeForeground" = "#C9D1E8";
            "editorIndentGuide.background1" = "#2D3040";
            "editorIndentGuide.activeBackground1" = "#526AA5";
            "sideBar.background" = "#191B26";
            "sideBar.foreground" = "#AEB8D8";
            "activityBar.background" = "#161821";
            "activityBar.foreground" = "#89B4FA";
            "activityBarBadge.background" = "#6D8FEA";
            "titleBar.activeBackground" = "#191B26";
            "titleBar.activeForeground" = "#C9D1E8";
            "tab.activeBackground" = "#1E1F2B";
            "tab.activeBorderTop" = "#7AA2F7";
            "tab.inactiveBackground" = "#191B26";
            "statusBar.background" = "#161821";
            "statusBar.foreground" = "#AEB8D8";
            "statusBar.debuggingBackground" = "#BB9AF7";
            "terminal.background" = "#1E1F2B";
            "terminal.foreground" = "#C9D1E8";
            "terminalCursor.foreground" = "#89B4FA";
            "focusBorder" = "#6D8FEA";
            "list.activeSelectionBackground" = "#34466F";
            "list.activeSelectionForeground" = "#E2E8FF";
          };
        };
      };
    };
  };
}
