C:\Windows\System32\OpenSSH\ssh.exe amelnyk@192.168.56.102 "rm -rf /home/amelnyk/Documents/Avid/techTask/mdbackup/*"
C:\Windows\System32\OpenSSH\ssh.exe amelnyk@192.168.56.102 "rm -rf /home/amelnyk/Documents/Avid/techTask/cleadDir.sh"
C:\Windows\System32\OpenSSH\scp.exe C:\Users\anton.melnyk\Documents\workspace\MyPets\My_shell\src\cleadDir.sh amelnyk@192.168.56.102:/home/amelnyk/Documents/Avid/techTask/
C:\Windows\System32\OpenSSH\ssh.exe amelnyk@192.168.56.102 "chmod u+x /home/amelnyk/Documents/Avid/techTask/cleadDir.sh"
C:\Windows\System32\OpenSSH\scp.exe -r C:\Users\anton.melnyk\Documents\Avid\TechTask\mdbackup amelnyk@192.168.56.102:/home/amelnyk/Documents/Avid/techTask/
::C:\Windows\System32\OpenSSH\ssh.exe amelnyk@192.168.56.102 "/home/amelnyk/Documents/Avid/techTask/cleadDir.sh /home/amelnyk/Documents/Avid/techTask/mdbackup"
::C:\Windows\System32\OpenSSH\ssh.exe amelnyk@192.168.56.102 "ls -la /home/amelnyk/Documents/Avid/techTask/mdbackup"