#!/bin/bash

exec > >(tee -a "server-stats-$(date '+%F_%H-%M-%S').log") 2>&1

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

# Enhanced separator for more attractive headings
separator_top="╔════════════════════════════════════════════════════════════════════════════════╗"
separator_bottom="╚════════════════════════════════════════════════════════════════════════════════╝"

print_header() {
    local header_text="🔹 $1 🔹"
    local padding=$(( (76 - ${#1} - 4) / 2 ))
    printf "\n${CYAN}${BOLD}%s${RESET}\n" "$separator_top"
    printf "${CYAN}${BOLD}%*s%s%*s${RESET}\n" $padding "" "$header_text" $padding ""
    printf "${CYAN}${BOLD}%s${RESET}\n" "$separator_bottom"
}

print_header "🌟 Server Stats Run: $(date '+%F %T')"


# ------------------------ OS Info ------------------------

print_header "🧑‍💻  OS Info"

if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo -e "${GREEN}${NAME} ${VERSION}${RESET}"
else
    uname -a
fi

# ------------------------ CPU Uptime ------------------------

print_header "⏳ CPU Uptime"
# read system_uptime idle_time <<< "$(cat /proc/uptime)"
read system_uptime idle_time < /proc/uptime

total_seconds=${system_uptime%.*}
fractional_part=${system_uptime#*.}

days=$((total_seconds / 86400 ))
hours=$(((total_seconds % 86400) / 3600 ))
minutes=$(((total_seconds % 3600) / 60 ))
seconds=$((total_seconds % 60 ))

# echo "$days days, $hours hours, $minutes minutes, $seconds seconds"

# Print only non-zero units
[[ $days -gt 0 ]] && echo "$days days"
[[ $hours -gt 0 ]] && echo "$hours hours"
[[ $minutes -gt 0 ]] && echo "$minutes minutes"
[[ $seconds -gt 0 || $fractional_part -ne 0 ]] && echo "$seconds.${fractional_part} seconds"

# ------------------------ System Uptime (uptime command) ------------------------

print_header "⏰ System Uptime (uptime command)"
uptime_output=$(uptime -p)
echo -e "${GREEN}${uptime_output}${RESET}"

# ------------------------ Load Average ------------------------

print_header "📈 Load Average (1, 5, 15 min)"
loadavg=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
echo -e "${YELLOW}Load Average:${RESET} $loadavg"

# ------------------------ Network Usage ------------------------

print_header "🌐 Network Usage (RX/TX since boot)"
# Show RX/TX bytes for all interfaces except lo
awk '/:/ {if ($1 != "lo:") print $1, $2, $10}' /proc/net/dev | \
  awk '{gsub(":", "", $1); printf "%-10s RX: %10.2f MB  TX: %10.2f MB\n", $1, $2/1024/1024, $3/1024/1024}'


# ------------------------ CPU Usage ------------------------

print_header "🧮 CPU Usage"

top_output=$(top -bn1)

cpu_idle=$(echo "$top_output" | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/')
cpu_usage=$(awk -v idle="$cpu_idle" 'BEGIN { printf("%.1f", 100 - idle) }')

echo -e "Usage         : ${GREEN}${cpu_usage}%${RESET}"


# ------------------------ Memory Usage ------------------------

print_header "🧠 Memory Usage"

read total_memory available_memory <<< $(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {print t, a}' /proc/meminfo)
used_memory=$((total_memory - available_memory))

used_memory_percent=$(awk -v u=$used_memory -v t=$total_memory 'BEGIN { printf("%.1f", (u / t) * 100) }')
free_memory_percent=$(awk -v a=$available_memory -v t=$total_memory 'BEGIN { printf("%.1f", (a / t) * 100) }')

# Convert from kB to MB 
total_memory_mb=$(awk -v t=$total_memory 'BEGIN { printf("%.1f", t/1024) }')
used_memory_mb=$(awk -v u=$used_memory 'BEGIN { printf("%.1f", u/1024) }')
available_memory_mb=$(awk -v a=$available_memory 'BEGIN { printf("%.1f", a/1024) }')

printf "Total Memory    : ${YELLOW}%-10s MB${RESET}\n" "$total_memory_mb"
printf "Used Memory     : ${YELLOW}%-10s MB${RESET} (%s%%)\n" "$used_memory_mb" "$used_memory_percent"
printf "Free/Available  : ${YELLOW}%-10s MB${RESET} (%s%%)\n" "$available_memory_mb" "$free_memory_percent"


# ------------------------ Disk Usage ------------------------

print_header "💽 Disk Usage"

df_output=$(df -h /)
size_disk=$(echo "$df_output" | awk 'NR==2 {printf $2}')
# Dont use printf in below line, it doesnt add space
read used_disk available_disk <<< $(echo "$df_output" | awk 'NR==2 {print $3, $4}')

df_output_raw=$(df /)
read size_disk_kb used_disk_kb available_disk_kb <<< $(echo "$df_output_raw" | awk 'NR==2 {print $2, $3, $4}')

if command -v bc &> /dev/null; then
  used_disk_percent=$(echo "scale=2; $used_disk_kb * 100 / $size_disk_kb" | bc)
  available_disk_percent=$(echo "scale=2; $available_disk_kb * 100 / $size_disk_kb" | bc)
else
  used_disk_percent=$(( used_disk_kb * 100 / size_disk_kb ))
  available_disk_percent=$((available_disk_kb * 100 / size_disk_kb))
fi



printf "Disk Size       : ${YELLOW}%-10s${RESET}\n" "$size_disk"
printf "Used Space      : ${YELLOW}%-10s${RESET} (%s%%)\n" "$used_disk" "$used_disk_percent"
printf "Available Space : ${YELLOW}%-10s${RESET} (%s%%)\n" "$available_disk" "$available_disk_percent"


# ------------------------ Top Processes ------------------------

print_header "🔥 Top 5 Processes by CPU"
ps aux --sort=-%cpu | awk 'NR==1 || NR<=6 { printf "%-10s %-6s %-5s %-5s %s\n", $1, $2, $3, $4, $11 }'

print_header "💡 Top 5 Processes by Memory"
ps aux --sort=-%mem | awk 'NR==1 || NR<=6 { printf "%-10s %-6s %-5s %-5s %s\n", $1, $2, $3, $4, $11 }'


# ------------------------ Users currently Logged In ------------------------

print_header "👥 Users currently Logged In"
users

users_info_more=false

print_header "📝 More info on Logged In Users"

if [[ "$users_info_more" == false ]]; then
  echo "USER     TTY          LOGIN-TIME        FROM"
  who
else
  w
fi


# ------------------------ Failed Log In Attempts ------------------------

# Resources
# https://www.tecmint.com/find-failed-ssh-login-attempts-in-linux/

# Check which log file exists in the system for authentication logs
if [ -f /var/log/auth.log ]; then
  print_header "🚨 Top IPs causing failed logins"
  grep -a "Failed password" /var/log/auth.log | awk '{for(i=1;i<=NF;i++){if($i=="from"){print $(i+1)}}}' | sort | uniq -c | sort -nr
  print_header "📋 Logs of Failed Log In Attempts"
  grep -a -E "Failed password|authentication failure|Invalid user|Failed publickey" /var/log/auth.log
elif [ -f /var/log/secure ]; then
  print_header "🚨 Top IPs causing failed logins"
  grep -a "Failed password" /var/log/secure | awk '{for(i=1;i<=NF;i++){if($i=="from"){print $(i+1)}}}' | sort | uniq -c | sort -nr
  print_header "📋 Logs of Failed Log In Attempts"
  grep -a -E "Failed password|authentication failure|Invalid user|Failed publickey" /var/log/secure
else
  echo -e "${YELLOW}⚠️  Sorry, no recognised authentication log file found${RESET}"
fi

# # ------------------------ btop Summary ------------------------

# if command -v btop &> /dev/null; then
#     print_header "🖥️  btop System Resource Summary"
#     # Try to run btop in basic mode and capture a snapshot (if supported)
#     # btop does not have a true non-interactive summary mode, but we can run it for a short time and kill it
#     # Or instruct the user to run it interactively
#     echo -e "${YELLOW}🚀 Launching btop for a live, detailed system overview. Press 'q' to quit.${RESET}"
#     btop
# else
#     echo -e "${YELLOW}❌ btop is not installed. Please install btop for advanced system monitoring.${RESET}"
#     echo -e "${YELLOW}💡 Install it with: sudo apt install btop${RESET}"
# fi


# ------------------------ Basic Alerts ------------------------

# CPU usage alert (threshold: 85%)
CPU_ALERT_THRESHOLD=85
if (( $(echo "$cpu_usage > $CPU_ALERT_THRESHOLD" | bc -l) )); then
    echo -e "${YELLOW}ALERT: CPU usage is above ${CPU_ALERT_THRESHOLD}%! Current: ${cpu_usage}%${RESET}"
    echo "[$(date '+%F %T')] ALERT: CPU usage is above ${CPU_ALERT_THRESHOLD}%! Current: ${cpu_usage}%" >> "alerts-$(date '+%F').log"
fi

# Memory usage alert (threshold: 90%)
MEM_ALERT_THRESHOLD=90
if (( $(echo "$used_memory_percent > $MEM_ALERT_THRESHOLD" | bc -l) )); then
    echo -e "${YELLOW}ALERT: Memory usage is above ${MEM_ALERT_THRESHOLD}%! Current: ${used_memory_percent}%${RESET}"
    echo "[$(date '+%F %T')] ALERT: Memory usage is above ${MEM_ALERT_THRESHOLD}%! Current: ${used_memory_percent}%" >> "alerts-$(date '+%F').log"
fi

# Disk usage alert (threshold: 90%)
DISK_ALERT_THRESHOLD=90
if (( $(echo "$used_disk_percent > $DISK_ALERT_THRESHOLD" | bc -l) )); then
    echo -e "${YELLOW}ALERT: Disk usage is above ${DISK_ALERT_THRESHOLD}%! Current: ${used_disk_percent}%${RESET}"
    echo "[$(date '+%F %T')] ALERT: Disk usage is above ${DISK_ALERT_THRESHOLD}%! Current: ${used_disk_percent}%" >> "alerts-$(date '+%F').log"
fi

# Email alert option (optional, requires 'mail' or 'mailx' installed and configured)
# Set this to your email address to receive alert emails (requires 'mail' or 'mailx' configured)
EMAIL_ALERT=""
if [[ -n "$EMAIL_ALERT" ]]; then
    ALERT_LOG="alerts-$(date '+%F').log"
    if [[ -s "$ALERT_LOG" ]]; then
        mail -s "[ALERT] Server Performance Alert on $(hostname) - $(date '+%F')" "$EMAIL_ALERT" < "$ALERT_LOG"
        echo -e "${YELLOW}Alert log emailed to $EMAIL_ALERT${RESET}"
    fi
fi


# ------------------------ Disk I/O Statistics ------------------------
if command -v iostat &> /dev/null; then
    print_header "🔄 Disk I/O Stats"
    iostat -dx | head -n 10
else
    echo -e "${YELLOW}iostat not found. Install with: sudo apt install sysstat${RESET}"
fi

# ------------------------ Top Network Connections ------------------------
if command -v netstat &> /dev/null; then
    print_header "🌐 Top Network Connections"
    netstat -tunapl | head -n 10
else
    echo -e "${YELLOW}netstat not found. Install with: sudo apt install net-tools${RESET}"
fi

# ------------------------ Top Disk Usage by Directory ------------------------
print_header "📂 Top 5 Disk Usage by Directory (/)"
du -h --max-depth=1 / 2>/dev/null | sort -hr | head -n 6

