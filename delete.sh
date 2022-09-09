# Delete Network
# Delete Servers
#!/bin/bash
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Script to delete Servers or Network stack"
   echo 
   echo "Syntax: scriptTemplate [--network|servers|help]"
   echo "options:"
   echo "--network         Create the network stack."
   echo "--servers         Create the servers stack."
   echo "-h, --help      Print this Help."
   echo
}

############################################################
# Process the input options.                               #
############################################################
if [ "$1" = "--network" ]; then
    # Create Network
    if [ $NETWORK_STACK_NAME ]; then
        aws cloudformation delete-stack --stack-name $NETWORK_STACK_NAME
    else
        >&2 echo "NETWORK_STACK_NAME environment variable is empty"; exit 1;
    fi
elif [ "$1" = "--servers" ]; then
    if [ $SERVERS_STACK_NAME ]; then
        line_number=$(grep -A 1 -n FrontendBucketName server-parameters.json | tail -1 | cut -f1 -d-)
        s3bucketname=$(awk -F\" 'NR == '$line_number' {print $4}' server-parameters.json)
        aws s3 rm s3://$s3bucketname --recursive
        aws cloudformation delete-stack --stack-name $SERVERS_STACK_NAME
    else
        >&2 echo "SERVERS_STACK_NAME environment variable is empty"; exit 1;
    fi
elif [ "$1" = "--database" ]; then
    if [ $SERVERS_STACK_NAME ]; then

        aws cloudformation delete-stack --stack-name $DATABASE_STACK_NAME
    else
        >&2 echo "SERVERS_STACK_NAME environment variable is empty"; exit 1;
    fi
elif [ "$1" = "--help" -o "$1" = "-h" ]; then
    Help
else
    >&2 echo "ERROR: Invalid option"; exit 1;
    Help
fi
