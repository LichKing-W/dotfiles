#!/usr/bin/env bash
#
# install.sh — 把仓库里的配置软链接到它们的目标位置。
#
# 用法:
#   ./install.sh              安装/更新软链接（已存在的真实文件会自动备份）
#   ./install.sh --dry-run    只打印将要做什么，不实际执行
#   ./install.sh --force      覆盖已存在的真实文件（不备份）
#   ./install.sh --unlink     移除本脚本创建的软链接
#   ./install.sh --help
#
set -euo pipefail

# 仓库根目录 = 本脚本所在目录（支持从任意路径调用）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DRY_RUN=0
FORCE=0
UNLINK=0

# ---------- 颜色输出 ----------
if [[ -t 1 ]]; then
  C_BOLD=$'\033[1m'; C_GREEN=$'\033[32m'; C_YELLOW=$'\033[33m'
  C_RED=$'\033[31m'; C_BLUE=$'\033[34m'; C_DIM=$'\033[2m'; C_RESET=$'\033[0m'
else
  C_BOLD=""; C_GREEN=""; C_YELLOW=""; C_RED=""; C_BLUE=""; C_DIM=""; C_RESET=""
fi

note()  { printf "%s→%s %s\n" "$C_BLUE" "$C_RESET" "$*"; }
ok()    { printf "%s✓%s %s\n" "$C_GREEN" "$C_RESET" "$*"; }
warn()  { printf "%s⚠%s %s\n" "$C_YELLOW" "$C_RESET" "$*"; }
skip()  { printf "%s·%s %s\n" "$C_DIM" "$C_RESET" "$*"; }

usage() {
  cat <<EOF
${C_BOLD}用法:${C_RESET} ./install.sh [选项]

${C_BOLD}选项:${C_RESET}
  -n, --dry-run    只预览将要发生的操作，不实际改动
  -f, --force      覆盖已存在的真实文件/目录（不备份）
  -u, --unlink     移除本脚本创建的软链接
  -h, --help       显示本帮助

默认行为：已存在的真实文件会被备份成 <path>.bak.<时间戳>。
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run) DRY_RUN=1 ;;
    -f|--force)   FORCE=1 ;;
    -u|--unlink)  UNLINK=1 ;;
    -h|--help)    usage; exit 0 ;;
    *) echo "未知选项: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

# ---------- 核心：创建/移除一个软链接 ----------
# 参数: link <repo相对路径> <绝对目标路径>
link() {
  local src_rel="$1"
  local dst="$2"
  local src="$SCRIPT_DIR/$src_rel"
  local dst_dir
  dst_dir="$(dirname "$dst")"

  if [[ ! -e "$src" ]]; then
    warn "源文件不存在，跳过: $src_rel"
    return 0
  fi

  # ---- 卸载模式 ----
  if [[ $UNLINK -eq 1 ]]; then
    if [[ -L "$dst" ]]; then
      printf "%s✖%s 移除链接 %s\n" "$C_RED" "$C_RESET" "$dst"
      if [[ $DRY_RUN -eq 0 ]]; then rm "$dst"; fi
    else
      skip "非软链接，保持不动: $dst"
    fi
    return 0
  fi

  mkdir -p "$dst_dir"

  # 已经指向本仓库源？幂等跳过
  if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$src" ]]; then
    ok "已链接: $dst"
    return 0
  fi

  # 已存在的真实文件/目录：备份或强制删除
  if [[ -e "$dst" ]] && [[ ! -L "$dst" ]]; then
    if [[ $FORCE -eq 1 ]]; then
      warn "强制覆盖: $dst"
      if [[ $DRY_RUN -eq 0 ]]; then rm -rf "$dst"; fi
    else
      local bak="${dst}.bak.$(date +%Y%m%d%H%M%S)"
      note "备份 $dst → $bak"
      if [[ $DRY_RUN -eq 0 ]]; then mv "$dst" "$bak"; fi
    fi
  fi

  # 指向别处的旧软链接，直接覆盖
  note "链接 $dst  →  $src_rel"
  if [[ $DRY_RUN -eq 0 ]]; then ln -sfn "$src" "$dst"; fi
}

# ---------- 映射表：仓库路径 → 目标路径 ----------
main() {
  printf "%s仓库根目录:%s %s\n" "$C_BOLD" "$C_RESET" "$SCRIPT_DIR"
  if [[ $DRY_RUN -eq 1 ]]; then warn "DRY-RUN 模式：不会做任何实际改动"; fi
  echo

  link "zsh/.zshrc"              "$HOME/.zshrc"
  link "nvim/plugins"            "$HOME/.config/nvim/lua/plugins"
  link "starship/starship.toml"  "$HOME/.config/starship/starship.toml"
  link "ghostty/config"          "$HOME/.config/ghostty/config"
  link "ghostty/shaders"         "$HOME/.config/ghostty/shaders"

  echo
  if [[ $UNLINK -eq 1 ]]; then
    ok "卸载完成。被备份的文件仍保留为 *.bak.*。"
  else
    ok "完成。如需还原，可用 --unlink 移除链接；原文件备份为 *.bak.*。"
  fi
}

main
