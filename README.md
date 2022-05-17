# psadmin.io PeopleSoft Validation JMeter Library
This library is a collection of JMeter test plans, test modules, data files, helper scripts and more. It is used to run JMeter tests against PeopleSoft environments. The tests can be used for stress/performance testing, environment setup validation and more.

# Library Contents

* `data`
    * User data files
    * This directory contains environment specific *user.properties* files. These are used to pass test plan parameters like URL, site name, etc.
* `lib`
    * Helper script library
    * Scripts used to run *JMeter* from the command line.
* `modules`
    * Central location of JMeter test fragments. (Example: User Login, User Logout)
    * Test fragments found here can be referenced in *Test Plans* using a *Module Controller*.
* `plans`
    * *JMeter* test plans
    * These are the main test plans that are opened by *JMeter*
* `temp`
    * Temporary file location, not saved in git repository.
    * Things like log output,etc are stored in this directory temporarily.

# JMeter Install
The *JMeter* binaries can be [downloaded](https://jmeter.apache.org/download_jmeter.cgi) and unzipped locally on any machine with Java.

# Running JMeter
JMeter can run in GUI or CLI mode. To run in GUI mode, it is best to run `$JMETER_HOME\jmeter\bin\jmeter.bat`. To run in CLI mode, run `$JMETER_HOME\jmeter\bin\jmeter -n` with additional parameters as needed.

## Configure JVM Settings
If you want to set specific JVM settings, etc, create a `$JMETER_HOME\jmeter\bin\setEnv.bat` file. 

Example `setEnv.bat` setting HEAP size:
```
# Set HEAP to 2gb
set HEAP=-Xms2g -Xmx2g -XX:MaxMetaspaceSize=512m
```

## CLI Parameters
To run *JMeter* in CLI mode, you need to pass [multiple parameters](https://jmeter.apache.org/usermanual/get-started.html#non_gui). To pass in a User Property via parameter, pass a key value pair with `-J` prefixed to the front of the property key name.

```
# Example
.\jmeter -n `
  -t "$plan_file" `
  -p "$prop_file" `
  -JOPRID="$User" `
  -JPASS="$Pass" `
  --logfile "$results_file" `
  --jmeterlogfile "$run_log" `
```

# PeopleTools Validation Test Plan
The PeopleTools Validation test plan([/plans/psft-general-load.jmx]()) can be used to validate a PeopleSoft environments configuration and functionality. The goal of this plan is to test a series of PeopleTools functions to ensure an environment is configured correctly. This is often used after a refresh, applying maintenance or initial build.

## Validation Tests

* User Login
* Process Scheduler Tests
    * Process Request - SQR
    * Process Request - AE
* Integration Broker Tests
    * Ping - Gateway
    * Ping - PSFT_HR
    * Service Configuration Target Locations
* Search Framework Tests
    * Cluster Search Instance Properties
    * Call Back Properties
    * Search Index - Navigator
* Portal Tests    
    * Test HRMS Component
* User Logout

## Running via CLI
You can run this test in CLI via the PowerShell helper script `lib\cli-example.ps1`
```
# Default Parameters
# -JMeterHome "[JMETER_HOME]\jmeter" # binary
# -JMeterLib "C:\psft-validation" # test plans
cd c:\jmeter
.\lib\cli-example.ps1 -Environment "<envname>" -User "<user>" -Pass "<password>"
```

## Running via Rundeck
You can run the PeopleSoft Validation Test Plan from Rundeck. Pass in the environment name and credentials. The job will pick a batch server for this environment to run on. It will first copy the latest version of this JMeter Library, then run the test plan. If there are any errors in the test plan log, the Rundeck job will fail. 

# Environment User Properties
Each environment has its own *user.properties* file. This can be found at `data\$ENVNAME.properties`. Below is an example of a properties file.

```
# Thread Group Settings
threads=1
rampup=1
loopcount=1

PROTOCOL=http
SERVER=hr.lab.conf.oraclevcn.com
NODE=HRMS
PORT=8000
SITE=ps

ENABLE_PRCS_PSNT=TRUE
ENABLE_IB=TRUE
ENABLE_SF=TRUE
ENABLE_PORTAL=TRUE
```
