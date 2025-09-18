#!/bin/bash
# Login langsung Admin & User + Auto-start
LOG_FILE="$HOME/log.txt"
USER_FILE="$HOME/users.txt"
AUTO_START="$HOME/.bash_login_tools.sh"

# Admin credentials
ADMIN_EMAIL="admin@example.com"
ADMIN_PASS="Rahasia123"

# Fungsi log login
log_login() {
    local role="$1"
    local email="$2"
    local status="$3"
    local time=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$time] Role: $role | Email: $email | Status: $status" >> "$LOG_FILE"
}

# Banner
banner() {
    clear
    echo -e "\e[1;34m=============================\e[0m"
    echo -e "\e[1;36m   SILAHKAN LOGIN TOOLS     \e[0m"
    echo -e "\e[1;34m=============================\e[0m"
}

# Admin dashboard
admin_dashboard() {
    while true; do
        echo -e "\n\e[1;33m=== MENU ADMIN ==="
        echo "[1] Lihat semua login user"
        echo "[2] Hapus user"
        echo "[3] Register user baru"
        echo "[4] Jalankan Option (tools)"
        echo "[0] Logout\e[0m"
        read -p "Pilih: " choice
        case $choice in
            1) cat "$LOG_FILE" ;;
            2)
                read -p "Email user yang ingin dihapus: " del_email
                grep -v "^$del_email:" "$USER_FILE" > tmp && mv tmp "$USER_FILE"
                echo -e "\e[1;32mUser $del_email dihapus.\e[0m"
                ;;
            3)
                read -p "Email baru: " new_email
                read -sp "Password baru: " new_pass
                echo ""
                echo "$new_email:$new_pass" >> "$USER_FILE"
                echo -e "\e[1;32mUser baru berhasil ditambahkan.\e[0m"
                ;;
            4)
                echo -e "\e[1;32mMenjalankan Option...\e[0m"
                git clone https://github.com/adrian020w/Option.git
                cd Option || exit
                bash run.sh
                ;;
            0) echo "Logout..."; exit 0 ;;
            *) echo "Pilihan tidak valid." ;;
        esac
    done
}

# User tools
user_tools() {
    echo -e "\e[1;32mUser masuk ke tools...\e[0m"
    git clone https://github.com/adrian020w/Option.git
    cd Option || exit
    bash run.sh
}

# Auto-start setup
setup_autostart() {
    if [[ ! -f "$AUTO_START" ]]; then
        cp "$0" "$AUTO_START"
        echo -e "\n# Auto-start Login Tools" >> "$HOME/.bashrc"
        echo "bash $AUTO_START" >> "$HOME/.bashrc"
    fi
}

# Jalankan
banner
setup_autostart

# **Langsung prompt login tanpa opsi**
read -p "Masukkan email login: " email
read -sp "Masukkan password: " pass
echo ""

if [[ "$email" == "$ADMIN_EMAIL" && "$pass" == "$ADMIN_PASS" ]]; then
    log_login "Admin" "$email" "Sukses"
    admin_dashboard
elif grep -q "^$email:$pass\$" "$USER_FILE" 2>/dev/null; then
    log_login "User" "$email" "Sukses"
    user_tools
else
    echo -e "\e[1;31mLogin gagal! Email atau password salah.\e[0m"
    log_login "Unknown" "$email" "Gagal"
    exit 1
fi
