/* Raphael's DWM profile: Nix pixel grid / Tokyo Night Storm. */
#include <X11/XF86keysym.h>

static const unsigned int borderpx  = 3;
static const unsigned int snap      = 24;
static const int showbar            = 1;
static const int topbar             = 1;
static const char *fonts[]          = { "JetBrainsMono Nerd Font:size=10:style=Bold" };
static const char dmenufont[]       = "JetBrainsMono Nerd Font:size=10:style=Bold";
static const char col_bg[]          = "#161821";
static const char col_surface[]     = "#1E1F2B";
static const char col_border[]      = "#3B4261";
static const char col_fg[]          = "#C9D1E8";
static const char col_blue[]        = "#7AA2F7";
static const char col_cyan[]        = "#7DCFFF";
static const char col_purple[]      = "#BB9AF7";
static const char *colors[][3]      = {
  [SchemeNorm] = { col_fg, col_surface, col_border },
  [SchemeSel]  = { col_bg, col_blue, col_cyan },
};

static const char *tags[] = { "1:term", "2:code", "3:web", "4:media", "5:notes", "6:chat", "7:ops", "8:game", "9:misc" };

static const Rule rules[] = {
  /* class      instance  title  tags mask  isfloating  monitor */
  { "Alacritty", NULL,    NULL,  1 << 0,   0,          -1 },
  { "Code",     NULL,     NULL,  1 << 1,   0,          -1 },
  { "Chromium", NULL,     NULL,  1 << 2,   0,          -1 },
  { "obsidian", NULL,     NULL,  1 << 4,   0,          -1 },
  { "Obsidian", NULL,     NULL,  1 << 4,   0,          -1 },
  { "discord",  NULL,     NULL,  1 << 5,   0,          -1 },
  { "DaVinci Resolve", NULL, NULL, 1 << 3, 0,          -1 },
};

static const float mfact     = 0.58;
static const int nmaster     = 1;
static const int resizehints = 1;
static const int lockfullscreen = 1;

static const Layout layouts[] = {
  { "[]=", tile },
  { "[M]", monocle },
  { "><>", NULL },
};

#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
  { MODKEY,                       KEY,      view,       {.ui = 1 << TAG} }, \
  { MODKEY|ControlMask,           KEY,      toggleview, {.ui = 1 << TAG} }, \
  { MODKEY|ShiftMask,             KEY,      tag,        {.ui = 1 << TAG} }, \
  { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,  {.ui = 1 << TAG} },
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

static const char *termcmd[] = { "alacritty", NULL };
static const char *tmuxcmd[] = { "alacritty", "--command", "tmux", "new", "-A", "-s", "main", NULL };
static const char *roficmd[] = { "rofi", "-show", "drun", NULL };
static const char *rofiruncmd[] = { "rofi", "-show", "run", NULL };

static const Key keys[] = {
  { MODKEY,                       XK_p,      spawn,          {.v = roficmd } },
  { MODKEY|ShiftMask,             XK_p,      spawn,          {.v = rofiruncmd } },
  { MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
  { MODKEY|ShiftMask,             XK_Return, spawn,          {.v = tmuxcmd } },
  { MODKEY,                       XK_o,      spawn,          SHCMD("obsidian") },
  { MODKEY,                       XK_y,      spawn,          SHCMD("alacritty --command yazi") },
  { MODKEY,                       XK_b,      togglebar,      {0} },
  { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
  { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
  { MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
  { MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
  { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
  { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
  { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
  { MODKEY,                       XK_m,      setlayout,      {.v = &layouts[1]} },
  { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[2]} },
  { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
  { MODKEY,                       XK_space,  zoom,           {0} },
  { MODKEY,                       XK_Tab,    view,           {0} },
  { MODKEY|ShiftMask,             XK_q,      killclient,     {0} },
  { MODKEY|ShiftMask,             XK_r,      quit,           {0} },
  { MODKEY|ShiftMask,             XK_e,      spawn,          SHCMD("loginctl terminate-user $USER") },
  { 0, XF86XK_AudioRaiseVolume,   spawn,     SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+") },
  { 0, XF86XK_AudioLowerVolume,   spawn,     SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") },
  { 0, XF86XK_AudioMute,          spawn,     SHCMD("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") },
  { 0, XF86XK_MonBrightnessUp,    spawn,     SHCMD("brightnessctl set +10%") },
  { 0, XF86XK_MonBrightnessDown,  spawn,     SHCMD("brightnessctl set 10%-") },
  TAGKEYS(                        XK_1,                      0)
  TAGKEYS(                        XK_2,                      1)
  TAGKEYS(                        XK_3,                      2)
  TAGKEYS(                        XK_4,                      3)
  TAGKEYS(                        XK_5,                      4)
  TAGKEYS(                        XK_6,                      5)
  TAGKEYS(                        XK_7,                      6)
  TAGKEYS(                        XK_8,                      7)
  TAGKEYS(                        XK_9,                      8)
  { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
  { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
};

static const Button buttons[] = {
  { ClkLtSymbol, 0, Button1, setlayout, {.v = &layouts[0]} },
  { ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]} },
  { ClkWinTitle, 0, Button2, zoom,      {0} },
  { ClkStatusText, 0, Button2, spawn,   SHCMD("alacritty --command btop") },
  { ClkClientWin, MODKEY, Button1, movemouse, {0} },
  { ClkClientWin, MODKEY, Button2, togglefloating, {0} },
  { ClkClientWin, MODKEY, Button3, resizemouse, {0} },
  { ClkTagBar, 0, Button1, view, {.ui = 0} },
  { ClkTagBar, 0, Button3, toggleview, {.ui = 0} },
  { ClkTagBar, MODKEY, Button1, tag, {.ui = 0} },
  { ClkTagBar, MODKEY, Button3, toggletag, {.ui = 0} },
};
