<#
  Run JMeter validation test plan against a PeopleSoft environment
#>
[CmdletBinding()]
Param(    
    [Parameter(Position=0,Mandatory=$true)][string]$Environment,
    [string]$User,
	  [string]$Pass,
	  [string]$JMeterHome = "<JMETER_HOME", # binary
	  [string]$JMeterLib	= "<REPO_DIR>" # test plans
)

# Vars
$cwd          = $(pwd)
$prop_file    = "$JMeterLib\data\env\$Environment.properties"
$plan_file    = "$JMeterLib\plans\psft-validation.jmx"
$results_file = "$JMeterLib\temp\psft-validation-results.$(get-date -f yyyyMMddhm).jtl"
$run_log      = "$JMeterLib\temp\psft-validation.log"
$jvm_options = "-Xms1024m -Xmx1024m"

# Pre Validation
# TODO - Validate props file

# Run
$env:JAVA_OPTS = "$jvm_options"
cd $JMeterHome\bin\
.\jmeter -n `
  -t "$plan_file" `
  -p "$prop_file" `
  -JOPRID="$User" `
  -JPASS="$Pass" `
  --logfile "$results_file" `
  --jmeterlogfile "$run_log" `  
  
# Post Validate
$error_pattern = '(?<=\[!ERROR!\])(.*)(?=\[!ERROR!\])'
#$failures = Select-String -Path $results_file -Pattern "$error_pattern"
$failures = Select-String -Path $results_file -Pattern "$error_pattern" -AllMatches
if ($failures -ne $null){
    Write-Error "ERROR: Results file contains failures!"
    #Select-String -Path $results_file -Pattern "$error_pattern" | Select-Object Line
	$failures.Matches | Foreach-Object { "[ERROR] - $($_.Value)" }
	Write-Host ""
	cd $cwd
    Exit 1
} else {
    Write-Host "Success!"
	cd $cwd
}
