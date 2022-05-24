#!/bin/sh

# vars
jmeter_home="/jmeter/5.4.1"
jmeter_proj="/jmeter-main" # just to is relative path from this script location?

prop_file="${jmeter_proj}/data/env.properties"
plan_file="${jmeter_proj}/plans/pt-validation.jmx" 
results_file="${jmeter_proj}/temp/pt-validation-results.$(date +"%Y-%b-%d-%H:%M:%S").jtl" # datetime stamp?
run_log="${jmeter_proj}/temp/pt-validation.log"
export JAVA_OPTS="-Xms1024m -Xmx1024m"

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
