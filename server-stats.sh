echo "System Uptime"

uptime

echo "Total CPU Usage"
top -bn1 | grep "%Cpu(s):" | cut -d ',' -f 4 | awk '{print "Usage: " 100-$1 "%"}'
echo

echo "Total Memory Usage"
free | grep "Mem:" -w | awk '{printf "Total: %.1fGi\nUsed: %.1fGi (%.2f%%)\nFree: %.1fGi (%.2f%%)\n",$2/1024^2, $3/1024^2, $3/$2 * 100, $4/1024^2, $4/$2 * 100}'
echo

echo "Total Disk Usage"
df -P | grep '^/dev/' | awk '{total += $2; used += $3; free += $4} END {if (total == 0) {print "No mounted disks"; exit}; total_gb = total / 1024 / 1024; used_gb = used / 1024 / 1024; free_gb = free / 1024 / 1024; used_pctg = (used / total) * 100; free_pctg = (free / total) * 100; printf "Total %8.2f GB\n", total_gb; printf "Used %8.2f GB (%5.1f%%)\n", used_gb, used_pctg; printf "Free %8.2f GB (%5.1f%%)\n", free_gb, free_pctg}'
echo

echo "Top 5 processes by CPU usage"
ps --no-headers -eo pid,user,%cpu,comm --sort=-%cpu | head -n 5
echo

echo "Top 5 processes by memory usage"
ps --no-headers -eo pid,user,%mem,comm --sort=-%mem | head -n 5
echo

echo "System Stats"
echo "OS Version:         $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
echo "Uptime:             $(uptime -p)"
echo "Load average:       $(awk '{print $1", "$2", "$3}' /proc/loadavg)"
echo "Logged in users:    $(who | wc -l) session(s) by: $(users | tr ' ' '\n' | sort -u | xargs)"
echo "Failed logins:      $(sudo lastb 2>/dev/null | grep -v '^$' | head -n -2 | wc -l) (since log rotation)"
echo
