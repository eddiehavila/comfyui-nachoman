<#
.SYNOPSIS
    Creates a new Active Directory group with specified name and description.

.DESCRIPTION
    This script creates a new Active Directory group in a specified Organizational Unit (OU).
    The OU path is defined as a variable within the script.

.PARAMETER GroupName
    The name of the Active Directory group to create.

.PARAMETER GroupDescription
    The description for the Active Directory group.

.EXAMPLE
    .\New-ADGroupScript.ps1 -GroupName "IT_Admins" -GroupDescription "IT Administration Team"
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$GroupName,

    [Parameter(Mandatory=$true)]
    [string]$GroupDescription
)

# Define the OU path where the group will be created
# Modify this variable to match your environment
$OU = "OU=Groups,DC=domain,DC=com"

# Group scope and type (modify as needed)
$GroupScope = "Global"
$GroupCategory = "Security"

try {
    # Check if Active Directory module is available
    if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
        Write-Error "Active Directory module is not installed. Please install RSAT tools."
        exit 1
    }

    # Import Active Directory module
    Import-Module ActiveDirectory -ErrorAction Stop

    # Check if group already exists
    $existingGroup = Get-ADGroup -Filter "Name -eq '$GroupName'" -ErrorAction SilentlyContinue

    if ($existingGroup) {
        Write-Warning "Group '$GroupName' already exists in Active Directory."
        exit 1
    }

    # Create the new AD group
    New-ADGroup -Name $GroupName `
                -GroupScope $GroupScope `
                -GroupCategory $GroupCategory `
                -Description $GroupDescription `
                -Path $OU `
                -ErrorAction Stop

    Write-Host "Successfully created AD group: $GroupName" -ForegroundColor Green
    Write-Host "Description: $GroupDescription" -ForegroundColor Green
    Write-Host "OU: $OU" -ForegroundColor Green
    Write-Host "Group Scope: $GroupScope" -ForegroundColor Green
    Write-Host "Group Category: $GroupCategory" -ForegroundColor Green
}
catch {
    Write-Error "Failed to create AD group: $_"
    exit 1
}
