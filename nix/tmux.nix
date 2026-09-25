{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # ============================================================
    # CORE
    # ============================================================

    # Standard-Tmux-Prefix bleibt C-b
    # Keine bestehenden Standard-Keybinds werden ersetzt.

    terminal = "tmux-256color";

    # Sehr große Scrollback-History
    historyLimit = 100000;

    # Maus vollständig aktivieren
    mouse = true;

    # Fokus-Events für Neovim / andere TUI-Programme
    focusEvents = true;

    # Vi-Modus für Copy Mode
    keyMode = "vi";

    # Schnellere Reaktion auf Escape
    escapeTime = 0;

    # Fenster bei 1 beginnen
    baseIndex = 1;

    # 24h Uhr
    clock24 = true;

    # Neue Sessions automatisch erzeugen
    newSession = true;


    # ============================================================
    # PLUGINS
    # ============================================================

    plugins = with pkgs.tmuxPlugins; [

      # ----------------------------------------------------------
      # Base / sensible defaults
      # ----------------------------------------------------------

      sensible

      # ----------------------------------------------------------
      # TOKYO NIGHT
      # ----------------------------------------------------------
      #
      # Offiziell in nixpkgs vorhanden:
      # tmuxPlugins.tokyo-night-tmux
      #
      # Passt sehr gut zu deinem Tokyo Night Storm Desktop.
      #
      tokyo-night-tmux


      # ----------------------------------------------------------
      # NAVIGATION
      # ----------------------------------------------------------

      # Ctrl-h/j/k/l bzw. Vim-kompatible Navigation zwischen
      # Tmux-Panes und Neovim.
      vim-tmux-navigator


      # ----------------------------------------------------------
      # MOUSE
      # ----------------------------------------------------------

      # Verbessertes Mouse-Verhalten.
      better-mouse-mode


      # ----------------------------------------------------------
      # CLIPBOARD
      # ----------------------------------------------------------

      # Tmux <-> System Clipboard
      yank


      # ----------------------------------------------------------
      # SEARCH / COPY
      # ----------------------------------------------------------

      # Schnelleres Suchen in Tmux
      copycat


      # ----------------------------------------------------------
      # OPEN
      # ----------------------------------------------------------

      # URLs / Dateien aus Copy Mode heraus öffnen
      open


      # ----------------------------------------------------------
      # SESSION PERSISTENCE
      # ----------------------------------------------------------

      {
        plugin = resurrect;

        extraConfig = ''
          # Tmux-Sessions speichern
          set -g @resurrect-capture-pane-contents 'on'

          # Neovim-Sessions mitretten
          set -g @resurrect-strategy-nvim 'session'

          # Vim-Sessions mitretten
          set -g @resurrect-strategy-vim 'session'

          # Zusätzliche Programme wiederherstellen
          set -g @resurrect-processes 'nvim vim ssh lazygit btop htop'
        '';
      }


      # ----------------------------------------------------------
      # AUTOMATIC SESSION SAVE / RESTORE
      # ----------------------------------------------------------
      #
      # Muss NACH resurrect kommen.
      #
      # Speichert Sessions automatisch und stellt sie beim Start
      # des Tmux-Servers wieder her.
      #
      {
        plugin = continuum;

        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'

          # Beim Start des Systems Tmux nicht automatisch
          # in jedem Terminal erzwingen.
          set -g @continuum-boot 'off'
        '';
      }


      # ----------------------------------------------------------
      # PREFIX INDICATOR
      # ----------------------------------------------------------

      # Zeigt visuell an, wenn C-b gedrückt wurde.
      prefix-highlight


      # ----------------------------------------------------------
      # SYSTEM INFORMATION
      # ----------------------------------------------------------

      cpu
    ];


    # ============================================================
    # TMUX CONFIGURATION
    # ============================================================

    extraConfig = ''

      # ==========================================================
      # TERMINAL / TRUE COLOR
      # ==========================================================

      # Modernes Terminal
      set -g default-terminal "tmux-256color"

      # 24-bit True Color
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -ag terminal-overrides ",screen-256color:RGB"
      set -ag terminal-overrides ",tmux-256color:RGB"

      # Moderne Cursor-/Focus-Unterstützung
      set -g focus-events on


      # ==========================================================
      # GENERAL
      # ==========================================================

      # Status Bar dauerhaft anzeigen
      set -g status on

      # Kein unnötiges Flackern
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off

      # Activity Monitoring
      setw -g monitor-activity off

      # Aggressive Resize
      setw -g aggressive-resize on

      # Fenster automatisch umbenennen
      setw -g automatic-rename on
      setw -g automatic-rename-format "#{b:pane_current_path}"


      # ==========================================================
      # CURSOR
      # ==========================================================

      # Cursor sichtbar und nicht blinkend in Tmux
      set -g cursor-style block

      # Beim Copy Mode ebenfalls Vi-Verhalten
      setw -g mode-keys vi


      # ==========================================================
      # COPY MODE
      # ==========================================================

      # Vi-Selection
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

      # Mit q Copy Mode verlassen
      bind-key -T copy-mode-vi 'q' send -X cancel

      # Mouse Drag soll nach dem Kopieren nicht nervig
      # im Copy Mode hängen bleiben.
      unbind-key -T copy-mode-vi MouseDragEnd1Pane


      # ==========================================================
      # PANE BEHAVIOR
      # ==========================================================

      # Neue Splits starten im aktuellen Verzeichnis.
      #
      # Die Standard-Keybinds bleiben:
      # C-b %   -> horizontal
      # C-b "   -> vertikal
      #
      # Nur das Startverzeichnis wird verbessert.

      bind '%' split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

      # Neue Fenster ebenfalls im aktuellen Directory
      bind c new-window -c "#{pane_current_path}"


      # ==========================================================
      # PANE BORDER
      # ==========================================================

      # Aktives Pane deutlich hervorheben
      set -g pane-border-status top

      # Pane-Titel
      set -g pane-border-format "  #P: #{pane_title}  "

      # Minimaler Border Style passend zu Tokyo Night
      set -g pane-border-style "fg=#3b4261"
      set -g pane-active-border-style "fg=#7aa2f7"


      # ==========================================================
      # WINDOW STATUS
      # ==========================================================

      # Window index + name
      set -g status-justify left

      # Aktives Window klar hervorheben
      setw -g window-status-current-format \
        "#[fg=#1a1b26,bg=#7aa2f7,bold]  #I:#W  "

      setw -g window-status-format \
        "#[fg=#565f89,bg=#16161e]  #I:#W  "

      # Window separators
      setw -g window-status-separator " "


      # ==========================================================
      # STATUS BAR
      # ==========================================================

      # Tokyo Night Storm Grundfarben
      set -g status-style "fg=#a9b1d6,bg=#16161e"

      # Höhe etwas erhöhen
      set -g status-left-length 100
      set -g status-right-length 200


      # ----------------------------------------------------------
      # LEFT SIDE
      # ----------------------------------------------------------

      set -g status-left \
        "#[fg=#1a1b26,bg=#7aa2f7,bold]  #S  "

      # kleiner Übergang
      set -ag status-left \
        "#[fg=#7aa2f7,bg=#16161e]"


      # ----------------------------------------------------------
      # RIGHT SIDE
      # ----------------------------------------------------------

      set -g status-right \
        "#[fg=#565f89]│ "

      set -ag status-right \
        "#[fg=#7aa2f7]󰥔 "

      set -ag status-right \
        "#[fg=#a9b1d6]%H:%M "

      set -ag status-right \
        "#[fg=#565f89]│ "

      set -ag status-right \
        "#[fg=#9ece6a]󰘚 "

      set -ag status-right \
        "#[fg=#a9b1d6]#{cpu_percentage} "

      set -ag status-right \
        "#[fg=#565f89]│ "

      set -ag status-right \
        "#[fg=#bb9af7]󰍛 "

      set -ag status-right \
        "#[fg=#a9b1d6]#(free -h | awk '/^Mem:/ {print $3 \"/\" $2}') "

      set -ag status-right \
        "#[fg=#565f89]│ "

      set -ag status-right \
        "#[fg=#7dcfff]󰒋 "

      set -ag status-right \
        "#[fg=#a9b1d6]#{host_short} "


      # ==========================================================
      # MESSAGE STYLE
      # ==========================================================

      set -g message-style \
        "fg=#c0caf5,bg=#1f2335,bold"

      set -g message-command-style \
        "fg=#7aa2f7,bg=#1f2335,bold"


      # ==========================================================
      # PANE NUMBER DISPLAY
      # ==========================================================

      set -g display-panes-active-colour "#7aa2f7"
      set -g display-panes-colour "#565f89"

      set -g display-panes-time 1200


      # ==========================================================
      # COMMAND PROMPT
      # ==========================================================

      set -g status-keys vi


      # ==========================================================
      # WINDOW ACTIVITY
      # ==========================================================

      # Aktivität in anderen Windows sichtbar machen
      setw -g window-status-activity-style \
        "fg=#ff9e64,bg=#16161e,bold"


      # ==========================================================
      # MODE / SELECTION COLORS
      # ==========================================================

      setw -g mode-style \
        "fg=#1a1b26,bg=#7aa2f7,bold"


      # ==========================================================
      # FOCUS / INPUT
      # ==========================================================

      # Maus-Scrolling fühlt sich natürlicher an
      set -g mouse on

      # Wheel scroll amount
      bind -T copy-mode-vi WheelUpPane send-keys -X scroll-up
      bind -T copy-mode-vi WheelDownPane send-keys -X scroll-down


      # ==========================================================
      # TMUX ENVIRONMENT
      # ==========================================================

      # Mehr Informationen für Programme innerhalb von Tmux
      set -g set-titles on
      set -g set-titles-string "#S:#I:#W"


      # ==========================================================
      # PERFORMANCE
      # ==========================================================

      # Status nicht unnötig oft neu zeichnen
      set -g status-interval 5


      # ==========================================================
      # CLEAN TERMINAL
      # ==========================================================

      # Keine Tmux-Standardmeldung beim Wechseln
      set -g remain-on-exit off

    '';
  };
}
