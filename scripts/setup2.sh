termux-setup-storage

pkg update -y && pkg upgrade -y
pkg install -y git zsh curl wget nano
yes | pkg install git gh zsh neovim nodejs python perl php curl wget lua-language-server​-y
$ lstermux-setup-





if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[+] ติดตั้ง Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "[!] Oh My Zsh มีอยู่แล้ว ข้าม..."
fi

# โคลนปลั๊กอิน Zsh ที่จำเป็น
PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p $PLUGINS_DIR

plugins=(
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-syntax-highlighting"
    "zsh-users/zsh-history-substring-search"
    "changyuheng/zsh-interactive-cd"
    "ohmyzsh/ohmyzsh/plugins/web-search"
)

for plugin in "${plugins[@]}"; do
    repo_name=$(basename $plugin)
    if [ ! -d "$PLUGINS_DIR/$repo_name" ]; then
        echo "[+] ติดตั้ง $repo_name..."
        git clone "https://github.com/$plugin" "$PLUGINS_DIR/$repo_name"
    else
        echo "[!] $repo_name มีอยู่แล้ว ข้าม..."
    fi
done

# ติดตั้ง Powerlevel10k Theme
THEMES_DIR="$HOME/.oh-my-zsh/custom/themes"
mkdir -p $THEMES_DIR
if [ ! -d "$THEMES_DIR/powerlevel10k" ]; then
    echo "[+] ติดตั้ง Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEMES_DIR/powerlevel10k"
else
    echo "[!] Powerlevel10k มีอยู่แล้ว ข้าม..."
fi

# สร้างไฟล์ ~/.zshrc (หากยังไม่มี)
if [ ! -f ~/.zshrc ]; then
    touch ~/.zshrc
fi

# เพิ่มการตั้งค่าใน ~/.zshrc
if ! grep -q "POWERLEVEL9K" ~/.zshrc; then
    echo "[+] กำลังแก้ไข ~/.zshrc..."
    cat > ~/.zshrc << 'EOL'
# ตั้งค่าโดยสคริปต์ Termux Zsh + p10k
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    z
    colored-man-pages
    command-not-found
    history-substring-search
    zsh-interactive-cd
    extract
    sudo
    copypath
    web-search
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ตั้งค่า Powerlevel10k
if [[ -f ~/.p10k.zsh ]]; then
    source ~/.p10k.zsh
fi
EOL
else
    echo "[!] พบการตั้งค่าใน ~/.zshrc แล้ว ข้าม..."
fi

# ดาวน์โหลดไฟล์ ~/.p10k.zsh (หากยังไม่มี)
if [ ! -f ~/.p10k.zsh ]; then
    echo "[+] ดาวน์โหลดไฟล์ ~/.p10k.zsh..."
    curl -o ~/.p10k.zsh https://raw.githubusercontent.com/romkatv/powerlevel10k/master/config/p10k.zsh
fi

# เปลี่ยน Shell เริ่มต้นเป็น Zsh
if [ "$SHELL" != "/data/data/com.termux/files/usr/bin/zsh" ]; then
    echo "[+] เปลี่ยน Shell เริ่มต้นเป็น Zsh..."
    chsh -s zsh
else
    echo "[!] Shell เริ่มต้นเป็น Zsh อยู่แล้ว ข้าม..."
fi

# โหลด Zsh ใหม่
echo "[+] ติดตั้งเสร็จสมบูรณ์! ปิดและเปิด Termux ใหม่เพื่อใช้งาน Powerlevel10k"
echo "[?] หากต้องการปรับแต่ง Powerlevel10k ให้รัน: p10k configure"

echo -e "\nInstalling NvChad...\n"

# Check if a Termux package is installed
is_installed() {
  dpkg -l | grep -q "^ii  $1 "
}

# Check if a Node.js module is installed globally
npm_installed() {
  npm list -g --depth=0 | grep -q "$1@"
}

# Install required Termux packages if not already installed
for package in git neovim nodejs python perl curl wget lua-language-server ripgrep stylua tree-sitter-parsers; do
  is_installed "$package" || yes | pkg install "$package"
done

# Install Prettier globally if not already installed
npm_installed "prettier" || npm install -g prettier

# Ensure the configuration directory exists
[ -d ~/.config ] || mkdir -p ~/.config

# Copy Neovim configuration
cp -r ./nvim ~/.config


rm -rf ~/.config/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim

#!/data/data/com.termux/files/usr/bin/bash

# สคริปต์ติดตั้ง LazyVim บน Termux
echo "กำลังติดตั้ง LazyVim Starter บน Termux..."

# อัปเดตและอัปเกรดแพ็คเกจ
pkg update -y && pkg upgrade -y

# ติดตั้ง dependencies
pkg install -y git neovim nodejs python ripgrep fd

# ลบ config เก่าถ้ามี
NVIM_DIR="$HOME/.config/nvim"
if [ -d "$NVIM_DIR" ]; then
  echo "พบ config เดิม จะทำการสำรองข้อมูล..."
  mv "$NVIM_DIR" "$NVIM_DIR.backup.$(date +%s)"
fi

npm i -g @devcorex/dev.x

# ติดตั้ง plugins (ผ่าน Lazy.nvim ที่มากับ Starter)
echo "กำลังติดตั้ง plugins..."
nvim --headless "+Lazy! sync" +qa

# ติดตั้ง LSP servers (ผ่าน Mason)
echo "กำลังติดตั้ง LSP servers..."
nvim --headless "+MasonInstallAll" +qa

# ติดตั้ง Treesitter parsers พื้นฐาน
echo "กำลังติดตั้ง Treesitter parsers..."
nvim --headless "+TSInstall lua python bash javascript typescript" +qa

# สร้าง alias
echo "alias vim='nvim'" >> ~/.bashrc
echo "alias nvim='nvim'" >> ~/.bashrc
source ~/.bashrc

echo "การติดตั้งเสร็จสมบูรณ์!"
echo "ใช้คำสั่ง 'nvim' เพื่อเริ่มใช้งาน"


git clone https://github.com/NvChad/starter ~/.config/nvim

 
nvim
