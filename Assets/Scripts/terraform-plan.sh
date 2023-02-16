set -o errexit

if [ $DECOM = true ]
then
    pModules=$(terraform state list | grep "module.*.prosimo_*.")
    if [ $CLOUD = "AWS" ]
    then
        if [ -n "$pModules" ]
        then
            for n in $pModules
            do
                terraform plan -target="$n" -var="prosimo_token=$PROSIMO_API_TOKEN" -var="prosimo_teamName=$PROSIMO_TEAMNAME" -var="decommission=$DECOM" -var="configFile=$CONFIGFILE" -out "tfplan-$CLOUD" -input=false
                terraform apply "tfplan-$CLOUD"
            done
        fi
    fi
    if [ $CLOUD = "Azure" ]
    then
        if [ -n "$pModules" ]
        then 
            for n in $pModules
            do
                terraform plan -target="$n" -var="prosimo_token=$PROSIMO_API_TOKEN" -var="prosimo_teamName=$PROSIMO_TEAMNAME" -var="adminPassword=$VM_PASSWORD" -var="decommission=$DECOM" -var="configFile=$CONFIGFILE" -out "tfplan-$CLOUD" -input=false
                terraform apply "tfplan-$CLOUD"
            done 
        fi    
    fi    
fi

if [ $DECOM = false ]
then
    if [ $CLOUD = "AWS" ]
    then
        terraform plan -var="prosimo_token=$PROSIMO_API_TOKEN" -var="prosimo_teamName=$PROSIMO_TEAMNAME" -var="decommission=$DECOM" -var="configFile=$CONFIGFILE" -out "tfplan-$CLOUD" -input=false 
    fi
    if [ $CLOUD = "Azure" ]
    then
        terraform plan -var="prosimo_token=$PROSIMO_API_TOKEN" -var="prosimo_teamName=$PROSIMO_TEAMNAME" -var="adminPassword=$VM_PASSWORD" -var="decommission=$DECOM" -var="configFile=$CONFIGFILE" -out "tfplan-$CLOUD" -input=false 
    fi    
fi

if [ $DESTROY = true ]
then
    DECOM=true
    if [ $CLOUD = "AWS" ]
    then
        terraform plan -var="prosimo_token=$PROSIMO_API_TOKEN" -var="prosimo_teamName=$PROSIMO_TEAMNAME" -var="decommission=$DECOM" -destroy -var="configFile=$CONFIGFILE" -out "tfplan-$CLOUD" -input=false 
    fi
    if [ $CLOUD = "Azure" ]
    then
        terraform plan -var="prosimo_token=$PROSIMO_API_TOKEN" -var="prosimo_teamName=$PROSIMO_TEAMNAME" -var="adminPassword=$VM_PASSWORD" -var="decommission=$DECOM" -var="configFile=$CONFIGFILE" -destroy -out "tfplan-$CLOUD" -input=false 
    fi    
fi
