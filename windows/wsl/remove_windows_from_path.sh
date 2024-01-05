# Set these variables before running
windows_user=
program_files="/mnt/c/Program Files"

function query_windows_registry {
    reg.exe query "$@" | \
        tail +3 | \
        head -1 | \
        awk '{$1=$2=""; print $0}'
}

function query_windows_registry_path {
    query_windows_registry "$@" | \
        sed 's/ *$//;s/^ *//;s#C:\\#/mnt/c/#g;s#\\#/#g;s/\;/:/g'
}

# This is currently hardcoded, don't know of a way to find it out because looks
# like we can't access the WindowsApps directory from withing WSL.
wsl_dir_name='MicrosoftCorporationII.WindowsSubsystemForLinux_2.0.9.0_x64__8wekyb3d8bbwe'

wsl_path="/mnt/c/Program Files/WindowsApps/$wsl_dir_name"
local_user_path=$(query_windows_registry_path 'HKEY_CURRENT_USER\Environment' /v Path | \
  sed "s#%USERPROFILE%#/mnt/c/Users/$windows_user#g" | \
  sed "s#%ProgramFiles%#$program_files#g")
local_user_path=${local_user_path%:$'\r'}
local_machine_path=$(query_windows_registry_path \
  'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' /v Path)
local_machine_path=${local_machine_path%$'\r'}
all_windows_paths="${wsl_path}:${local_machine_path}:${local_user_path}"

# add_windows_paths includes the windows paths at the end of PATH
function add_windows_paths {
    export PATH="${PATH/$all_windows_paths}:$all_windows_paths"
}

# remove_windows_paths removes the windows paths from anywhere inside of PATH
function remove_windows_paths {
    export PATH=${PATH/$all_windows_paths}
    export PATH=${PATH%:}
}

remove_windows_paths
