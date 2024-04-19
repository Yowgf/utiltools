#!/bin/bash

set -e

[ -n "$(command -v dotnet)" ] || ( 
    echo "Installing dotnet 8.0" && \
        apt-get install dotnet-sdk-8.0 )
dotnet_version=$(dotnet --version)
echo "Using dotnet version $dotnet_version"

tmpdir=$(mktemp -d)
cd "$tmpdir"
git clone https://github.com/jonstodle/DotNetSdkHelpers
cd DotNetSdkHelpers
sed -i 's/"7\..\+"/"'$dotnet_version'"/' global.json
sed -i \
    's/<TargetFrameworks>net7.0/<TargetFrameworks>net8.0;net7.0/g' \
    src/DotNetSdkHelpers/DotNetSdkHelpers.csproj
dotnet build

install_dir_name=.dotnetsdkhelper
install_dir=~/$install_dir_name
mkdir -p "$install_dir"
cp -r src/DotNetSdkHelpers/bin "$install_dir"
echo '#!/bin/bash
cd ~/.dotnetsdkhelper
dotnet bin/Debug/net8.0/DotNetSdkHelpers.dll
'  > "$install_dir/dotnet-sdk"
chmod +x "$install_dir/dotnet-sdk"

echo "alias dotnet-sdk=\$HOME/.dotnetsdkhelper/dotnet-sdk" >> ~/.bashrc
