#!/data/data/com.termux/files/usr/bin/bash

# ตั้งค่าพื้นฐาน Termux
termux-setup-storage
pkg update -y && pkg upgrade -y

# ติดตั้งแพ็กเกจหลัก
pkg install -y git gh zsh neovim nodejs python perl \
    php curl wget lua-language-server ripgrep fd

# ติดตั้ง Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ติดตั้ง Zsh plugins
plugins=(
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-syntax-highlighting"
    "zsh-users/zsh-history-substring-search"
    "changyuheng/zsh-interactive-cd"
)

for plugin in "${plugins[@]}"; do
    repo_name=$(basename "$plugin")
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$repo_name" ]; then
        git clone "https://github.com/$plugin" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$repo_name"
    fi
done

# ติดตั้ง Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
fi

# ติดตั้ง Neovim (NvChad)
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone https://github.com/NvChad/starter ~/.config/nvim
    nvim --headless "+Lazy! sync" +qa
    nvim --headless "+MasonInstallAll" +qa
fi

# เปลี่ยน Shell เริ่มต้นเป็น Zsh
if [ "$(basename "$SHELL")" != "zsh" ]; then
    chsh -s zsh
fi

echo "✅ ติดตั้งเสร็จสมบูรณ์! ปิด Termux แล้วเปิดใหม่เพื่อใช้งาน"
