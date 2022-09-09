
#!/bin/bash
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Script to create or update Servers or Network stack"
   echo 
   echo "Syntax: scriptTemplate [--network|servers|help]"
   echo "options:"
   echo "--network         Create the network stack."
   echo "--servers         Create the servers stack."
   echo "--update          Use after --network or --servers to update the stack."
   echo "-h, --help      Print this Help."
   echo
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
        aws cloudformation $operation --stack-name $NETWORK_STACK_NAME --template-body file://network.yml  --parameters file://network-parameters.json --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" --region=$AWS_REGION
    else
        >&2 echo "NETWORK_STACK_NAME environment variable is empty"; exit 1;
    fi
elif [ "$1" = "--servers" ]; then
    if [ $SERVERS_STACK_NAME ]; then
        aws cloudformation $operation --stack-name $SERVERS_STACK_NAME --template-body file://servers.yml  --parameters file://server-parameters.json --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" --region=$AWS_REGION
    else
        >&2 echo "SERVERS_STACK_NAME environment variable is empty"; exit 1;
    fi
elif [ "$1" = "--help" -o "$1" = "-h" ]; then
    Help
else
    >&2 echo "ERROR: Invalid option"; exit 1;
    Help
fi
