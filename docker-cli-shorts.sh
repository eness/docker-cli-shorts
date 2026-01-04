############################################################################
#                                                                          #
#     Docker CLI Shorts                                                    #
#                                                                          #
#     author: enes sönmez <root/at/enes.dev>                               #
#                                                                          #
#     # INSTALLATION :                                                     #
#                                                                          #
#     Copy/paste these lines into your .bashrc or .zshrc file, or run:     #
#     wget -O - https://raw.githubusercontent.com/eness/docker-cli-shorts/main/docker-cli-shorts.sh >> ~/.bashrc
#                                                                          #
#     # USAGE :                                                            #
#                                                                          #
#     dc             : docker compose                                      #
#     dcu            : docker compose up -d                                #
#     dcd            : docker compose down                                 #
#     dcr            : docker compose run                                  #
#     dm             : interactively stop/restart a container              #
#     dex <name>     : docker exec -it <name> [bash|sh]                    #
#     di <name>      : docker inspect <container>                          #
#     dim            : docker images                                       #
#     dip            : IPs of running containers                           #
#     dl <name>      : docker logs -f <container>                          #
#     dnames         : names of running containers                         #
#     dps            : docker ps                                           #
#     dpsa           : docker ps -a                                        #
#     drmc           : remove exited containers                            #
#     drmid          : remove dangling images                              #
#     drun <image>   : run bash in new container from image                #
#     dsr <name>     : stop and remove container                           #
#     dlab <label>   : container ID by label                               #
#     dsp            : docker system prune --all                           #
#     dcfc           : re-create container on docker compose               #
#     b              : login to bash shell of container                    #
#     bsh            : login to sh shell of container                      #
#                                                                          #
############################################################################

function dnames-fn {
    for ID in $(docker ps -q); do
        docker inspect "$ID" | grep Name | head -1 | awk '{print $2}' | sed 's/[",\/]//g'
    done
}

function dip-fn {
    echo "IP addresses of all named running containers"
    for DOC in $(dnames-fn); do
        IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$DOC")
        OUT+="$DOC\t$IP\n"
    done
    echo -e "$OUT" | column -t
    unset OUT
}

function dex-fn {
    docker exec -it "$1" "${2:-bash}"
}

function di-fn {
    docker inspect "$1"
}

function dl-fn {
    docker logs -f "$1"
}

function drun-fn {
    docker run -it "$1" "$2"
}

function dcr-fn {
    docker compose run "$@"
}

function dsr-fn {
    docker stop "$1"
    docker rm "$1"
}

function drmc-fn {
    docker rm $(docker ps -aq -f status=exited)
}

function drmid-fn {
    imgs=$(docker images -q -f dangling=true)
    [ -n "$imgs" ] && docker rmi $imgs || echo "no dangling images."
}

function dlab {
    docker ps --filter="label=$1" --format="{{.ID}}"
}

function dc-fn {
    docker compose "$@"
}

function dm-fn {
    mode="stop"
    containers=$(docker ps -a --format '{{.ID}}|{{.Names}}|{{.Status}}|{{.Ports}}')
    mapfile -t lines <<< "$containers"

    echo "Current mode: ${mode^^}"
    echo ""
    echo -e "No\tName\t\t\tStatus\t\t\tPorts"
    for i in "${!lines[@]}"; do
        IFS='|' read -r id name status ports <<< "${lines[$i]}"
        printf "%d)\t%-20s\t%-20s\t%s\n" "$((i+1))" "$name" "$status" "$ports"
    done

    echo ""
    echo "Press [R] to switch to RESTART mode, [S] to switch to STOP mode, [Q] to quit."
    echo "Or press a number to ${mode^^} a container."

    while true; do
        read -rsn1 key

        if [[ "$key" =~ [Rr] ]]; then
            mode="restart"
            echo "🔁 Mode switched to RESTART"
        elif [[ "$key" =~ [Ss] ]]; then
            mode="stop"
            echo "🛑 Mode switched to STOP"
        elif [[ "$key" =~ [Qq] ]]; then
            echo -e "\n👋 Exiting..."
            return 0
        elif [[ "$key" =~ [0-9] ]]; then
            num="$key"
            read -t 0.5 -rsn1 next
            while [[ "$next" =~ [0-9] ]]; do
                num+="$next"
                read -t 0.5 -rsn1 next
            done

            if [[ ${#num} -gt 1 ]]; then
                echo -ne "\nConfirm selection ($num) with Enter: "
                read -r confirm
            fi

            index=$((num - 1))
            if [[ $index -ge 0 && $index -lt ${#lines[@]} ]]; then
                IFS='|' read -r container_id container_name _ <<< "${lines[$index]}"
                if [[ "$mode" == "stop" ]]; then
                    docker stop "$container_id"
                    echo "✅ Container $container_name ($num) stopped."
                else
                    docker restart "$container_id"
                    echo "✅ Container $container_name ($num) restarted."
                fi
                return 0
            else
                echo "⚠️  Invalid container number."
            fi
        else
            echo "⚠️  Invalid input. Use [R], [S], [Q], or a number."
        fi
    done
}

# Aliases
alias dc=dc-fn
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcr=dcr-fn
alias dm=dm-fn
alias dex=dex-fn
alias di=di-fn
alias dim="docker images"
alias dip=dip-fn
alias dl=dl-fn
alias dnames=dnames-fn
alias dps="docker ps"
alias dpsa="docker ps -a"
alias drmc=drmc-fn
alias drmid=drmid-fn
alias drun=drun-fn
alias dsp="docker system prune --all"
alias dsr=dsr-fn
alias dr="docker restart"
alias docker-compose='docker compose'
alias dcfc="docker compose up -d --force-recreate $1"
alias b='f() { local user="$2"; local append=""; [ -n "$user" ] && append="-u $user"; docker container exec -it $append "$1" bash; }; f'
alias bsh='f() { local user="$2"; local append=""; [ -n "$user" ] && append="-u $user"; docker container exec -it $append "$1" sh; }; f'
