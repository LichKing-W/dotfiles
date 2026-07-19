# dotfiles

我的个人终端 / 编辑器配置文件，覆盖 zsh、Neovim、Starship 提示符和 Ghostty 终端。

## 目录结构

```
.
├── zsh/                          # Shell 配置
│   └── .zshrc
├── nvim/                         # Neovim 配置（基于 LazyVim）
│   └── plugins/
│       ├── leetcode.lua          # leetcode.nvim 刷题插件
│       ├── supertab.lua          # blink.cmp 的 super-tab 补全键位
│       ├── disabled.lua          # 禁用 noice.nvim
│       └── example.lua           # LazyVim 自带示例（未加载）
├── starship/
│   └── starship.toml             # 提示符主题与多套配色
├── ghostty/
│   ├── config                    # 终端配置
│   └── shaders/
│       └── cursor_smear_rainbow.glsl   # 光标拖影 shader
├── install.sh                    # 一键软链接安装脚本
└── README.md
```

## 对应的安装位置

| 仓库路径 | 目标路径 |
|---------|---------|
| `zsh/.zshrc` | `~/.zshrc` |
| `nvim/plugins/` | `~/.config/nvim/lua/plugins/` |
| `starship/starship.toml` | `~/.config/starship/starship.toml` |
| `ghostty/config` | `~/.config/ghostty/config` |
| `ghostty/shaders/` | `~/.config/ghostty/shaders/` |

## 安装

本仓库通过 `install.sh` 用**软链接**把配置映射到目标位置，无需 `stow` 等额外依赖。

```bash
# 先预览将要发生什么（不会改动任何文件）
./install.sh --dry-run

# 正式安装：已存在的真实文件会被备份成 *.bak.<时间戳>
./install.sh

# 其他选项
./install.sh --force     # 覆盖已存在的真实文件（不备份）
./install.sh --unlink    # 移除本脚本创建的软链接
./install.sh --help
```

脚本可重复运行（幂等）。装完后打开新终端、重启 Neovim / Ghostty 即可生效。

## 各组件说明

### zsh (`.zshrc`)
- 基于 **Oh My Zsh**，主题 `xxf`
- 插件：`git`、`zsh-autosuggestions`、`zsh-syntax-highlighting`、`z`、`extract`、`web-search`
- `y()` 函数：退出 [yazi](https://github.com/sxyazi/yazi) 后自动 `cd` 到它最后所在的目录
- 集成 nvm、bun、deno、[thefuck](https://github.com/nvbn/thefuck)、opencode、Homebrew
- 代理环境变量指向 `127.0.0.1:7897`
- 别名：`v`(neovide)、`ls`/`l`/`la`/`lla`/`lt` 全部改用 [lsd](https://github.com/lsd-rs/lsd)
- 启动时加载 Starship

### Starship (`starship.toml`)
- 单行提示符，默认配色 `custom1`（Catppuccin Mocha 风格）
- 内置 5 套可切换配色：`custom1`、`gruvbox_dark`、`tokyonight_night`、`solarized_osaka`、`one_dark`
- 自定义模块：
  - `venv` —— 显示当前 Python / Conda 虚拟环境
  - `giturl` —— 根据 remote 显示 GitHub / GitLab / Bitbucket 图标
  - `git_worktree` —— 处于 git worktree 时显示 `⛓`
- 语言版本显示：Node、Bun、C、Rust、Go、PHP、Java、Kotlin、Haskell、Python、Docker

### Neovim (`nvim/`)
- 基于 [LazyVim](https://www.lazyvim.org/) 发行版，使用 lazy.nvim 管理
- `leetcode.lua` —— [leetcode.nvim](https://github.com/kawre/leetcode.nvim)，连接 **leetcode.cn**，默认语言 `python3`，题目存于 `~/leetcode`
- `supertab.lua` —— [blink.cmp](https://github.com/Saghen/blink.cmp)，`<Tab>` 接受补全 / 跳转代码片段
- `disabled.lua` —— 关闭 `noice.nvim`

### Ghostty (`ghostty/`)
- 主题 `TokyoNight Moon`
- 字体 `Maple Mono NF CN`，关闭连字（`-calt -liga -dlig`）
- 窗口 120×30，字号 14，启动位置 (5, 5)
- 块状光标、不闪烁
- 自定义 shader：光标移动时的彩虹拖尾效果

## 依赖的工具

这些配置假设系统已安装：

- [zsh](https://www.zsh.org/) + [Oh My Zsh](https://ohmyz.sh/)，以及插件 `zsh-autosuggestions`、`zsh-syntax-highlighting`
- [Starship](https://starship.rs/)
- [Neovim](https://neovim.io/)（建议 v0.9+）+ [LazyVim](https://www.lazyvim.org/)
- [Ghostty](https://ghostty.org/)
- 辅助工具：[lsd](https://github.com/lsd-rs/lsd)、[yazi](https://github.com/sxyazi/yazi)、[neovide](https://github.com/neovide/neovide)、[thefuck](https://github.com/nvbn/thefuck)、[bun](https://bun.sh/)、[deno](https://deno.land/)、nvm、Homebrew

## License

个人使用配置，按需取用。
