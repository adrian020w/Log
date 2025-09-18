#!/bin/bash

LOG_FILE="$HOME/adrian_logs.csv"
USER_FILE="$HOME/adrian_users.db"

ADMIN_EMAIL="admin@adrian.com"
ADMIN_PASS_HASH="5e884898da28047151d0e56f8dc6292773603d0d6aabbddf8a2..."  # hash SHA256 dari "password"

# ======= FUNGSI =======
banner() {
    clear
    echo -e "\e[1;34m==============================\e[0m"
    echo -e "\e[1;36m       ADRIAN TOOLS          \e[0m"
    echo -e "\e[1;34m==============================\e[0m"
}

sha256() { echo -n "$1" | sha256sum | awk '{print $1}'; }

log_action() {
    local email="$1"
    local action="$2"
    local ip=$(curl -s https://api.ipify.org)
    local ua=$(uname -a)
    local now=$(date +"%Y-%m-%d %H:%M:%S")
    [[ ! -f "$LOG_FILE" ]] && echo "Email,Waktu,IP,UserAgent,Action" > "$LOG_FILE"
    echo "$email,$now,$ip,\"$ua\",$action" >> "$LOG_FILE"
}

verify_login() {
    local email="$1"
    local pass="$2"
    local pass_hash=$(sha256 "$pass")

    # Admin login
    if [[ "$email" == "$ADMIN_EMAIL" ]]; then
        [[ "$pass_hash" == "$ADMIN_PASS_HASH" ]] && return 0 || return 1
    fi

    # User biasa login
    [[ ! -f "$USER_FILE" ]] && touch "$USER_FILE"
    local stored_hash=$(grep "^$email:" "$USER_FILE" | cut -d: -f2)
    if [[ -z "$stored_hash" ]]; then
        echo "$email:$pass_hash" >> "$USER_FILE"
        return 0
    fi
    [[ "$pass_hash" == "$stored_hash" ]] && return 0 || return 1
}

admin_menu() {
    echo -e "\e[1;32m[*] Admin Mode: Realtime log aktif. Ctrl+C untuk keluar.\e[0m"
    echo -e "\e[1;33m[!] Ketik 'hapus email@example.com' untuk menghapus user.\e[0m"
    tail -f "$LOG_FILE" | while read line; do
        echo "$line"
    done
}

delete_user() {
    local email_del="$1"
    sed -i "/^$email_del:/d" "$USER_FILE"
    sed -i "/^$email_del,/d" "$LOG_FILE"
    echo -e "\e[1;31m[!] User $email_del dihapus dari database.\e[0m"
}

login() {
    read -p "Email: " email
    read -s -p "Password: " pass
    echo

    if ! verify_login "$email" "$pass"; then
        echo -e "\e[1;31m[!] Login gagal\e[0m"
        exit 1
    fi

    if [[ "$email" == "$ADMIN_EMAIL" ]]; then
        admin_menu
    else
        log_action "$email" "Menjalankan Option repository"
        git clone https://github.com/adrian020w/Option.git &>/dev/null
        cd Option || exit
        bash run.sh
    fi
}

banner
login
