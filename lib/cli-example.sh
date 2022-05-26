#!/bin/bash

# vars
jmeter_home="/jmeter/5.4.1" # Adjust this to the path for JMeter install
jmeter_proj="/jmeter-main" # Adjust to is relative path from this script location

prop_file="${jmeter_proj}/data/env.properties"
plan_file="${jmeter_proj}/plans/pt-validation.jmx"
results_file="${jmeter_proj}/temp/pt-validation-results.$(date +"%Y-%b-%d-%H:%M:%S").jtl" # datetime stamp?
run_log="${jmeter_proj}/temp/pt-validation.log"
export JAVA_OPTS="-Xms1024m -Xmx1024m"

function usage () {

    echo 'usage: '$0' -Environment "<envname>" -User "<user>" -Pass "<password>"'
    echo '   '$0' -f #forces use of the prop file for variables'
    exit

}


function main () {
        #$jmeter_home\bin\jmeter -p "$prop_file" -n -t "$plan_file" `
        cd $jmeter_home/bin || return
        ./jmeter -n -t $plan_file \
          -p $prop_file \
          -JOPRID="$User" \
          -JPASS="$Pass" \
          --logfile       $results_file \
          --jmeterlogfile $run_log

        # check for failures
        failures="$(grep '\!ERROR\!' ${results_file} )"
        if [ ${#failures} -ge 2 ]; then
            echo "ERROR: Results file contains failures!"
            exit 1
        else
            echo "Success!"
        fi
}



# Process the a null request
if [[ $# -eq 0  ]]
         then
            usage
            exit
fi

# Process the command line options
while [[ $# -gt 0 ]]; do
    case $1 in

        -Environment )          Environment=$2
                                shift
                                shift
                                # Validate that the Environment file exists
                                if [ -f "${jmeter_proj}/data/$Environment.properties" ]; then
                                        prop_file=${jmeter_proj}/data/$Environment.properties
                                else
                                        echo "Error: Environment file does not exist"
                                        exit 1
                                fi
                                ;;
        -User )                 User=$2
                                shift
                                shift
                                ;;
        -Pass )                 Pass=$2
                                shift
                                shift
                                ;;

        -f )                    shift
                                shift
                                ;;
        -h | --help )           usage
                                exit
                                ;;
    esac
done


# Validate that the JMeter Home exists
if [ ! -d "${jmeter_home}" ]; then
        echo "Error: JMeter Home does not exist"
        exit 1
fi

# Validate that the psft project home exists
if [ ! -d "${jmeter_proj}" ]; then
        echo "Error: JMeter project does not exist"
        exit 1
fi

# Validate that the plan file exists
if [ ! -f "${plan_file}" ]; then
        echo "Error: Plan file does not exist"
        exit 1
fi

# Validate that the Environment file exists
if [ ! -f "${jmeter_proj}/data/$Environment.properties" ]; then
        echo "Error: Environment file does not exist"
        exit 1
fi


main
