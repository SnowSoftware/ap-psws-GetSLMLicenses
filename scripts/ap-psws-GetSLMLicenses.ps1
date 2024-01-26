function get-pswsslmlicenses {
    param($LicenseId, $queryfilter, $ApplicationNameSearch)
    
    
    #region debug setup
    if ([Environment]::UserInteractive -eq $true -or $APDebugMode) {
        if (-not (Get-Module IgapCore)) {
            try {
                #this part requires that the workflow engine is installed on the machine running this script
                $wfeLocation = (Get-WmiObject win32_service | where-object { $_.Name -eq "Snow Automation Platform Workflow Engine" } | Select-Object PathName).PathName
                $wfeDirectory = $wfeLocation.Substring(1, $wfeLocation.LastIndexOf('\') - 1) 
                $apdirectory = $wfeDirectory.Substring(0, $wfeDirectory.LastIndexOf('\'))
                $apdirectory
                Import-Module "$apdirectory\CoreScripts\IgapCore.psm1"
            }
            catch {
                #if the workflow engine is not installed on the machine running this script, update the path below
                Import-Module 'C:\Program Files\Snow Software\Snow Automation Platform\CoreScripts\IgapCore.psm1'
            }
            
        }
        if (Get-Module IgapCore) {
            if (Test-Path -Path Function:Write-Host) { remove-item -Path Function:Write-Host }
            if (Test-Path -Path Function:Write-Verbose) { remove-item -Path Function:Write-Verbose }
            if (Test-Path -Path Function:Write-Warning) { remove-item -Path Function:Write-Warning }
            if (Test-Path -Path Function:Write-Error) { remove-item -Path Function:Write-Error }
        }
    }
    #endregion
    
    #SLMHelper is available at https://github.com/SnowSoftware/slm-module-SLMHelper
    if (-not (Get-Module SLMHelper)) {
        Try {
            Import-Module SLMHelper -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to import SLMHelper module."
            return
        }
    }
    
    #region SLM Settings
    $SLMApiAccountName = Get-APSetting "SLMApiAccountName"
    $SLMUri = Get-APSetting "SLMUri"
    $SLMCustomerId = Get-APSetting "SLMCustomerId"
    $SLMUserAccount = Get-ServiceAccount -Name $SLMApiAccountName
    
    $securePassword = ConvertTo-SecureString $($SLMUserAccount.Password) -AsPlainText -Force
    $SLMApiCredentials = New-Object Management.Automation.PSCredential ($($SLMUserAccount.AccountName), $securePassword)
    #endregion
    
    $SLMApiEndpointConfiguration = New-SLMApiEndpointConfiguration -SLMUri $SLMUri -SLMCustomerId $SLMCustomerId -SLMApiCredentials $SLMApiCredentials -CleanupBody
    
    
    if (-not [string]::IsNullOrEmpty($queryfilter)) {
        $SLMLicenses = Get-SLMLicenses -SLMApiEndpointConfiguration $SLMApiEndpointConfiguration -filter $queryfilter
        return $SLMLicenses
    }
    
    if ([int]$LicenseId -gt 0) {
        $SLMLicenses = Get-SLMLicenses -SLMApiEndpointConfiguration $SLMApiEndpointConfiguration -Id $LicenseId
        return $SLMLicenses
    }
   
    if ($ApplicationNameSearch.Length -ge 3) {
        $SLMLicenses = Get-SLMLicenses -SLMApiEndpointConfiguration $SLMApiEndpointConfiguration
        $SLMLicensesSearchResult = $SLMLicenses | Where-Object { $_.ApplicationName -like "*$ApplicationNameSearch*" }
        return $SLMLicensesSearchResult
    }

    if ($ApplicationNameSearch.Length -ge 1) {
        return
    }

    $SLMLicenses = Get-SLMLicenses -SLMApiEndpointConfiguration $SLMApiEndpointConfiguration

    return $SLMLicenses
    
}

## Object Properties
#Id              
#ApplicationName 
#ManufacturerName
#Metric          
#AssignmentType  
#PurchaseDate    
#Quantity        
#IsIncomplete    
#UpdatedDate     
#UpdatedBy       
    
## Examples
#get-pswsslmlicenses
#get-pswsslmlicenses -LicenseId 3
#get-pswsslmlicenses -queryfilter "ApplicationName eq 'IBM Spectrum Protect 7.1 for Mail'"
#get-pswsslmlicenses -ApplicationNameSearch 'IBM'
#get-pswsslmlicenses -ApplicationNameSearch 'IB'