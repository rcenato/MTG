# MTG
Malicious Traffic Generator

Let's break down the lines of the Bash script:

1. **`#!/bin/bash`**: Specifies that the script will be interpreted using the Bash shell.
   
2. **`helpFunction()`**: Defines a function that prints usage instructions for the script and exits if invoked.

3. **`while getopts e:t:f: flag`**: Parses command-line options for traffic volume (-e), target IP (-t), and time (-f).

4. **`if [ -z "$traffic" ] || [ -z "$IP" ] || [ -z "$time" ]`**: Checks if any of the required parameters are missing.

5. **`export NET="${IP%.*}".0/24""`**: Extracts the network portion from the IP address and exports it as an environment variable.

6. **`echo "Username:"; whoami`**: Prints the current user's name.

7. **`ifconfig eth0 | grep 'inet ' | cut -c 14-28`**: Retrieves the local machine's IP address on interface `eth0`.

8. **`interface="eth0"`**: Defines the network interface.

9. **Fake IP variables (`IPL1`, `IPL2`, etc.)**: Define spoofed or decoy IPs and a fake MAC address for malicious traffic simulation.

10. **`core_loop()` function**: 
   - Takes `iterations`, `group`, and `time` as arguments.
   - Reads Nmap commands from a file (`nmap_groupX.txt`) and executes them for each iteration.
   - Sleeps for the specified time before stopping Nmap processes.

11. **Traffic handling logic**: 
   - If `traffic` is low, sets appropriate iteration count (`exec`) and Nmap group to use.
   - If `traffic` is high, adjusts these parameters accordingly.

12. **`dataInicio=$(date '+%Y-%m-%d %H:%M:%S')`**: Stores the start time of the execution.

13. **`echo "Finished on:"`**: Prints the script’s completion time and appends both start and end times to a CSV file.

The script simulates network traffic based on Nmap commands and can vary the intensity based on user input. It logs execution times and network details, making it useful for cybersecurity research.
