# Sublime 个人配置信息

## Preference.sublime-setting --User
```
{
    "color_scheme": "Packages/Material Theme/schemes/Material-Theme.tmTheme",
    "font_size": 15,
    "ignored_packages":
    [
        "Vintage"
    ],
    "material_theme_bullet_tree_indicator": true,
    "material_theme_compact_sidebar": true,
    "spacegray_tabs_font_large": true,
    "theme": "Material-Theme.sublime-theme",
    "update_check": false
}
```

## Markdown.sublime-settings
```
   {
    "extensions":
    [
        "md"
    ],

    // "color_scheme": "Packages/MarkdownEditing/MarkdownEditor.tmTheme",
    // "color_scheme": "Packages/Theme - Spacegray/base16-eighties.dark.tmTheme",
    "color_scheme": "Packages/Material Theme/schemes/Material-Theme.tmTheme",
    "theme": "Material-Theme.sublime-theme",

    "line_padding_top": 4,
    "line_padding_bottom": 4,

    "tab_size": 4,
    "translate_tabs_to_spaces": true,

    "draw_centered": false,
    "word_wrap": true,
    "wrap_width": 120,
    // "rulers": [80, 120]
}
```


## sublime.keymap
```
[
    { "keys": ["alt+m"], "command": "markdown_preview", "args": {"target": "browser", "parser":"markdown"} }
]
```

## 总是以新窗口打开文件的解决办法
具体设置：Preferences -> Settings – User -> 添加 
```
"open_files_in_new_window": false,
```
重启一下sublime text 3


