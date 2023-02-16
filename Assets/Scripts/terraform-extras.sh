# Remove Prosimo state

if [ -n "$(terraform state list | grep "module.*.prosimo_*.")" ]
then 
    terraform state rm $(terraform state list | grep "module.*.prosimo_*.")
fi


# Extract private key from state


privateKeys=$(terraform show -json | jq -r '.values.root_module.child_modules[].resources[].values | select (.private_key_pem) | .private_key_pem')
privateIps=$(terraform show -json | jq -r '.values.root_module.child_modules[].resources[].values | select (.private_ip) | .private_ip')
sshKeys=$(printf '%s' $privateKeys)

i=$((0))
for p in $sshKeys
do
    echo $p >> privatekey-$i.pem
    i=$((i+1))
done

i=$((0))

for p in $privateIps
do
    mv privatekey-$p.pem $p.pem
    i=$((i+1))
done