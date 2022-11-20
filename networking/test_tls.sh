certfile=$1
pkeyfile=$2
host=$3
port=$4

openssl s_client -cert "${certfile}" -key "${pkeyfile}" -connect "${host}:${port}"
