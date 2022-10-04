
host=
user=
password=
database=
port=

# MySQL
mysql -h "$host" -P "$port" -u "$user" --enable-cleartext-plugin --ssl-mode=REQUIRED --default-auth=mysql_clear_password "-p$password"

# MongoDB
auth_source=
replica_set=
mongo "mongodb://$host:$port/$database?authSource=${auth_source}&authMechanism=PLAIN&replicaSet=${replica_set}" --username "$username" --password "$password"
