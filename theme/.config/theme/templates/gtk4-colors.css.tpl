/* Theme-generated GTK4/libadwaita overrides — do not edit manually */

/* Accent color */
@define-color accent_bg_color {{COLOR_PRIMARY}};
@define-color accent_fg_color {{COLOR_FG}};
@define-color accent_color {{COLOR_PRIMARY}};

/* Window/surface backgrounds */
@define-color window_bg_color {{COLOR_BG}};
@define-color window_fg_color {{COLOR_FG}};
@define-color view_bg_color {{COLOR_BG_ALT}};
@define-color view_fg_color {{COLOR_FG}};
@define-color headerbar_bg_color {{COLOR_BG}};
@define-color headerbar_fg_color {{COLOR_FG}};
@define-color card_bg_color {{COLOR_SURFACE}};
@define-color card_fg_color {{COLOR_FG}};
@define-color popover_bg_color {{COLOR_SURFACE}};
@define-color popover_fg_color {{COLOR_FG}};
@define-color dialog_bg_color {{COLOR_BG_ALT}};
@define-color dialog_fg_color {{COLOR_FG}};
@define-color sidebar_bg_color {{COLOR_BG}};
@define-color sidebar_fg_color {{COLOR_FG_DIM}};

/* Borders and separators */
@define-color borders alpha({{COLOR_PRIMARY}}, 0.3);
@define-color shade_color rgba(0, 0, 0, 0.25);

/* Semantic colors */
@define-color destructive_bg_color {{COLOR_CRIT}};
@define-color destructive_fg_color {{COLOR_FG}};
@define-color warning_bg_color {{COLOR_WARN}};
@define-color warning_fg_color {{COLOR_BG}};
@define-color success_bg_color {{COLOR_ACCENT}};
@define-color success_fg_color {{COLOR_BG}};

/* Selection */
@define-color selected_bg_color alpha({{COLOR_PRIMARY}}, 0.3);
@define-color selected_fg_color {{COLOR_FG}};

/* Scrollbar */
scrollbar slider {
  background-color: alpha({{COLOR_PRIMARY}}, 0.5);
  border-radius: 99px;
}
scrollbar slider:hover {
  background-color: alpha({{COLOR_PRIMARY}}, 0.7);
}

/* Sidebar row hover/selected */
.navigation-sidebar row:selected {
  background-color: alpha({{COLOR_PRIMARY}}, 0.2);
}
.navigation-sidebar row:hover {
  background-color: alpha({{COLOR_PRIMARY}}, 0.1);
}

/* Path bar active segment */
.path-bar button:checked {
  background-color: alpha({{COLOR_PRIMARY}}, 0.25);
  color: {{COLOR_ACCENT}};
}
