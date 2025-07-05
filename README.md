# 📊 **Server Performance Stats**

A beautiful, lightweight Bash script for instant Linux server health checks — right from your terminal!

---

## ✨ Why Use `server-stats.sh`?

- 🚀 **One command, all the essentials:**
  - CPU, memory, disk, network, and top processes — all in a clean, colorized view.
- 🖥️ **No bloat:**
  - Uses only standard Linux tools (plus optional `btop` for advanced monitoring).
- 🔒 **No root required:**
  - Works out of the box on any major Linux distro.
- 💡 **Perfect for:**
  - DevOps, SRE, sysadmins, cloud engineers, and anyone who wants fast, reliable server stats.

---

## 🔧 **Features**

- ✅ **Live CPU Usage**
- ✅ **Memory Stats** (total, used, available, %)
- ✅ **Disk Usage** (human-readable & raw)
- ✅ **Network Usage** (RX/TX per interface)
- ✅ **Top 5 Processes** (by CPU & memory)
- ✅ **System Uptime & Load Average**
- ✅ **Failed Login Attempts & User Sessions**
- ✅ **Optional: Advanced monitoring with `btop`**

---

## 📸 **Sample Output**

```
╔════════════════════════════════════════════════════════════════════════════════╗
                🔹 🌟 Server Stats Run: 2025-07-05 06:05:35 🔹                
╚════════════════════════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════════════════════════╗
                              🔹 🧑‍💻  OS Info 🔹                              
╚════════════════════════════════════════════════════════════════════════════════╝
Ubuntu 24.04.2 LTS (Noble Numbat)

╔════════════════════════════════════════════════════════════════════════════════╗
                              🔹 ⏳ CPU Uptime 🔹                              
╚════════════════════════════════════════════════════════════════════════════════╝
10 minutes
3.56 seconds

╔════════════════════════════════════════════════════════════════════════════════╗
                    🔹 ⏰ System Uptime (uptime command) 🔹                    
╚════════════════════════════════════════════════════════════════════════════════╝
up 10 minutes

╔════════════════════════════════════════════════════════════════════════════════╗
                     🔹 📈 Load Average (1, 5, 15 min) 🔹                     
╚════════════════════════════════════════════════════════════════════════════════╝
Load Average: 0.17 0.24 0.20

╔════════════════════════════════════════════════════════════════════════════════╗
                   🔹 🌐 Network Usage (RX/TX since boot) 🔹                   
╚════════════════════════════════════════════════════════════════════════════════╝
enX0       RX:       1.20 MB  TX:       1.07 MB

╔════════════════════════════════════════════════════════════════════════════════╗
                              🔹 🧮 CPU Usage 🔹                              
╚════════════════════════════════════════════════════════════════════════════════╝
Usage         : 16.7%

╔════════════════════════════════════════════════════════════════════════════════╗
                             🔹 🧠 Memory Usage 🔹                             
╚════════════════════════════════════════════════════════════════════════════════╝
Total Memory    : 3912.2     MB
Used Memory     : 2512.5     MB (64.2%)
Free/Available  : 1399.7     MB (35.8%)

╔════════════════════════════════════════════════════════════════════════════════╗
                              🔹 💽 Disk Usage 🔹                              
╚════════════════════════════════════════════════════════════════════════════════╝
Disk Size       : 48G       
Used Space      : 5.8G       (12.10%)
Available Space : 42G        (87.86%)

╔════════════════════════════════════════════════════════════════════════════════╗
                        🔹 🔥 Top 5 Processes by CPU 🔹                        
╚════════════════════════════════════════════════════════════════════════════════╝
USER       PID    %CPU  %MEM  COMMAND
elastic+   1015   13.9  37.2  /usr/share/elasticsearch/jdk/bin/java
kibana     547    7.5   13.9  /usr/share/kibana/bin/../node/glibc-217/bin/node
elastic+   542    0.7   2.4   /usr/share/elasticsearch/jdk/bin/java
root       565    0.2   0.9   /usr/lib/snapd/snapd
root       1      0.2   0.3   /sbin/init

╔════════════════════════════════════════════════════════════════════════════════╗
                      🔹 💡 Top 5 Processes by Memory 🔹                      
╚════════════════════════════════════════════════════════════════════════════════╝
USER       PID    %CPU  %MEM  COMMAND
elastic+   1015   13.9  37.2  /usr/share/elasticsearch/jdk/bin/java
kibana     547    7.5   13.9  /usr/share/kibana/bin/../node/glibc-217/bin/node
elastic+   542    0.7   2.4   /usr/share/elasticsearch/jdk/bin/java
root       565    0.2   0.9   /usr/lib/snapd/snapd
root       193    0.0   0.6   /sbin/multipathd

╔════════════════════════════════════════════════════════════════════════════════╗
                      🔹 👥 Users currently Logged In 🔹                      
╚════════════════════════════════════════════════════════════════════════════════╝
ubuntu

╔════════════════════════════════════════════════════════════════════════════════╗
                     🔹 📝 More info on Logged In Users 🔹                     
╚════════════════════════════════════════════════════════════════════════════════╝
USER     TTY          LOGIN-TIME        FROM
ubuntu   pts/0        2025-07-05 05:59 (49.36.144.105)

╔════════════════════════════════════════════════════════════════════════════════╗
                    🔹 🚨 Top IPs causing failed logins 🔹                    
╚════════════════════════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════════════════════════╗
                    🔹 📋 Logs of Failed Log In Attempts 🔹                    
╚════════════════════════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════════════════════════╗
                            🔹 🔄 Disk I/O Stats 🔹                            
╚════════════════════════════════════════════════════════════════════════════════╝
Linux 6.8.0-1029-aws (ip-172-31-14-247) 	07/05/25 	_x86_64_	(2 CPU)

Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
loop0            0.25      6.92     0.00   0.00    0.62    27.50    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.00   0.02
loop1            1.14      4.25     0.00   0.00    0.11     3.73    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.00   0.01
loop2            1.14      4.25     0.00   0.00    0.10     3.72    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.00   0.01
loop3            0.10      0.63     0.00   0.00    0.33     6.05    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.00   0.00
loop4            1.02     36.16     0.00   0.00    1.54    35.50    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.00   0.13
loop5            0.02      0.02     0.00   0.00    0.00     1.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.00   0.00
xvda           134.37   1902.56    22.72  14.46    0.77    14.16   16.15    436.08    61.36  79.16    1.34    27.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.13   9.15

╔════════════════════════════════════════════════════════════════════════════════╗
                       🔹 🌐 Top Network Connections 🔹                       
╚════════════════════════════════════════════════════════════════════════════════╝
(No info could be read for "-p": geteuid()=1000 but you should be root.)
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:5601            0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:55928         127.0.0.1:9200          ESTABLISHED -                   
tcp        0      0 127.0.0.1:42754         127.0.0.1:9200          ESTABLISHED -                   
tcp        0      0 127.0.0.1:56490         127.0.0.1:9200          ESTABLISHED -                   
tcp6       0      0 127.0.0.1:9300          :::*                    LISTEN      -                   
tcp6       0      0 :::22                   :::*                    LISTEN      -                   

╔════════════════════════════════════════════════════════════════════════════════╗
                  🔹 📂 Top 5 Disk Usage by Directory (/) 🔹                  
╚════════════════════════════════════════════════════════════════════════════════╝
6.7G	/
4.7G	/usr
1.1G	/var
936M	/snap
86M	/boot
30M	/home
```

---

## 🚀 **Usage**

Make the script executable:
```sh
chmod +x server-stats.sh
```
Run it:
```sh
./server-stats.sh
```

For a live, interactive dashboard, install `btop` (optional but recommended):
```sh
sudo apt update && sudo apt install btop
```

---

## 📦 **Dependencies**
- Standard: `top`, `awk`, `sed`, `grep`, `bc`, `ps`, `df`, `who`, `uptime`, `cat`
- Optional: `btop` (for advanced live monitoring)

---

## 🧪 **Pro Tips**
- **Automate:**
  - Run every 5 minutes with cron:
    ```sh
    */5 * * * * /path/to/server-stats.sh >> /path/to/log.txt
    ```
- **Alias:**
  - Add to your `.bashrc` for quick access:
    ```sh
    alias sstat="/full/path/to/server-stats.sh"
    ```

---

## 🙌 **Contribute & Customize**
Feel free to fork, extend, or suggest features! PRs and feedback welcome.

---

## 🛠️ **About**
Created for cloud engineers, SREs, and anyone who loves clean, actionable server stats. 

---

**Happy monitoring!**
