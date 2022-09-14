
#!/bin/bash
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Script to create or update Servers or Network stack"
   echo 
   echo "Syntax: scriptTemplate [--network|servers|database|help]"
   echo "options:"
   echo "--network         Create the network stack."
   echo "--servers         Create the servers stack."
   echo "--database        Create the database stack."
   echo "--update          Use after --network, --servers or --database to update the stack."
   echo "-h, --help        Print this Help."
   echo
}


############################################################
# Cloudformation Management                                #
############################################################
runCloudformation()
{
    state=$(aws cloudformation $1 --stack-name $2 --template-body file://$3.yml  --parameters file://$3-parameters.json --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" --region=$AWS_REGION 2>&1)
    already_exists=$(echo "$state" | grep -F AlreadyExistsException)
    no_new_updates=""
    if [ ! -z "$already_exists" ] ; then
        echo "$2 already exists, Updating..."
        state=$(aws cloudformation update-stack --stack-name $2 --template-body file://$3.yml  --parameters file://$3-parameters.json --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" --region=$AWS_REGION 2>&1)
    fi
    no_new_updates=$(echo "$state" | grep -F "No updates are to be performed")
    if [ ! -z "$no_new_updates" ] ; then
        echo "$2 Has no updates to be performed."
        return 0
    fi
    >&2 echo $state

}
############################################################
# Hold until network stack is created                      #
############################################################
STACK_STATUS="temp"
sleep_cnt=0
Hold()
{
    while [ $STACK_STATUS != "CREATE_COMPLETE" ] && [ $STACK_STATUS != "UPDATE_COMPLETE" ] ; do
        echo "Waiting for $2 stack to finalize..."
        STACK_STATUS=$(aws cloudformation describe-stacks --stack-name $1 --query Stacks[].StackStatus --output text)
        sleep 10
        echo $STACK_STATUS
        sleep_cnt=$((sleep_cnt+1))
        if [ $sleep_cnt -gt 150 ]; then 
            >&2 echo "FAILED: Stack took too long to finalize"
            exit 1
        fi
    done
    echo "$2 Stack Completed"
}
############################################################
# Process the input options.                               #
############################################################
if [ "$2" = "--update" ]; then
    operation="update-stack"
else
    operation="create-stack"
fi
if [ "$1" = "--network" ]; then
    if [ $NETWORK_STACK_NAME ]; then
        runCloudformation $operation $NETWORK_STACK_NAME "network"
        Hold $NETWORK_STACK_NAME "Network"
    else
        >&2 echo "NETWORK_STACK_NAME environment variable is empty"; exit 1;
    fi
elif [ "$1" = "--servers" ]; then
    if [ $SERVERS_STACK_NAME ]; then
        runCloudformation $operation $SERVERS_STACK_NAME "servers"
        Hold $SERVERS_STACK_NAME "Servers"
    else
        >&2 echo "SERVERS_STACK_NAME environment variable is empty"; exit 1;
    fi
elif [ "$1" = "--database" ]; then
    if [ $DATABASE_STACK_NAME ]; then
        runCloudformation $operation $DATABASE_STACK_NAME "database"
        Hold $DATABASE_STACK_NAME "Database"
    else
        >&2 echo "DATABASE_STACK_NAME environment variable is empty"; exit 1;
    fi
elif [ "$1" = "--help" -o "$1" = "-h" ]; then
    Help
else
    >&2 echo "ERROR: Invalid option"; exit 1;
    Help
fi
