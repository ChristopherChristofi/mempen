#!/bin/bash

write_command='False'
dest_dir=~/.ilistmem
config=${dest_dir}/config.ini
config_data="\
store='${dest_dir}/store'
store_comms='${dest_dir}/store/comms'
"

function add_comm_entry() {
    [[ $comm_val1 ]] && [[ $comm_val2 ]] && [[ $comm_val3 ]] \
    && comm_valid=$(( $comm_val1 + $comm_val2 + $comm_val3 ))
    [[ -z $comm_valid || $comm_valid != 111 ]] && echo -e "all comms options not provided\n"

    # return to: 'mkdir -p ${store}/${cmd_name}' if comm identifier baseline decided instead of tree extender
    comm_wloc_destination=${store_comms}/${comm_tree}
    echo "what is this: "${comm_wloc_destination}
    [[ -d "$cmd_wloc_destination" ]] && echo "Texists: "${comm_wloc_destination} || mkdir -p $comm_wloc_destination
    echo -e "${comm_cmd}" >> ${comm_wloc_destination}"/"${comm_name}
}

function generate_config() {
    [[ -d "$dest_dir" ]] || mkdir -p "$dest_dir"
    echo "$config_data" >> "$config"
}

function validate_config() {
    # potential overwrite function when missing config (arises when new builtin values added to script)
    source "$config"
    [[ $store && $store_comms ]] && echo "config validated well" || echo "config incomplete"
}
 
function call_help() {
    echo "Help: $(basename $0)" 2>&1
    echo "  -h show help"
    exit 1
}

[[ -f "$config" ]] || generate_config
validate_config

opts="hwn:c:t:"

while getopts $opts arg; do
    case "$arg" in
        w)
            write_command='True'
            ;;
        n)
            comm_name="${OPTARG}"
            [[ ${comm_name} ]] && comm_val3=100
            ;;
        c)
            comm_cmd="${OPTARG}"
            comm_val2=10
            ;;
        t)
            comm_tree="${OPTARG}"
            comm_val1=1
            ;;
        h)
            call_help
            ;;
        ?)
            echo "Invalid option: -${OPTARG}"
            call_help
            ;;
    esac
done

[[ ${write_command} == 'True' ]] && echo "we are writing" && add_comm_entry && echo "func called" || echo "command write fail"

exit 0