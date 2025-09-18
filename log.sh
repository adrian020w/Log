#!/bin/bash
# Sistem Login Admin & User + Auto-start
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
    echo -e "\e[1;36m   SISTEM LOGIN TOOLS       \e[0m"
    echo -e "\e[1;34m=============================\e[0m"
}

# Admin login
admin_login() {
    read -p "adrian: " email
    read -sp "Password: " pass
    echo ""
    if [[ "$email" == "$ADMIN_EMAIL" && "$pass" == "$ADMIN_PASS" ]]; then
        echo -e "\e[1;32mLogin Admin berhasil!\e[0m"
        log_login "Admin" "$email" "Sukses"
        admin_dashboard
    else
        echo -e "\e[1;31mLogin Admin gagal! Email atau password salah.\e[0m"
        log_login "Admin" "$email" "Gagal"
        exit 1
    fi
}

# User login
user_login() {
    read -p "Email User: " email
    read -sp "Password: " pass
    echo ""
    if grep -q "^$email:$pass\$" "$USER_FILE" 2>/dev/null; then
        echo -e "\e[1;32mLogin User berhasil!\e[0m"
        log_login "User" "$email" "Sukses"
        user_tools
    else
        echo -e "\e[1;31mLogin User gagal! Email atau password salah.\e[0m"
        log_login "User" "$email" "Gagal"
        exit 1
    fi
}

# Register user baru
register_user() {
    read -p "Email baru: " email
    read -sp "Password baru: " pass
    echo ""
    echo "$email:$pass" >> "$USER_FILE"
    echo -e "\e[1;32mUser baru berhasil ditambahkan.\e[0m"
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
            3) register_user ;;
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

# Auto-start setup untuk Termux/Linux
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

echo -e "\e[1;36m[1] Login Admin"
echo -e "[2] Login User"
echo -e "[3] Register User Baru\e[0m"
read -p "Pilih: " main_opt

case $main_opt in
    1) admin_login ;;
    2) user_login ;;
    3) register_user ;;
    *) echo "Pilihan tidak valid"; exit 1 ;;
esac
