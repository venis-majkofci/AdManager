Import-Module ActiveDirectory

Import-Module .\classes\MyADOrganizationalUnit.ps1
Import-Module .\classes\MyADGroup.ps1
Import-Module .\classes\MyADUser.ps1

Import-Module .\logManager.ps1

$jsonPath = ".\data\domain_setup.json"
$data = Get-Content -Path $jsonPath | ConvertFrom-Json

$domain = $($data.domain.name, $data.domain.extension)

# Create organizational units
foreach ($ouData in $data.organizationalUnits) {
    $ou = [MyADOrganizationalUnit]::new($ouData.name, $ouData.protectAccidentalDeletion, 
        "DC=$($domain[0]),DC=$($domain[1])", $ouData.description)
    $result = $ou.create()

    if ($result.success) {
        Write-Log -message $result.message "Green" -level 0

        # Create groups
        foreach($groupData in $ouData.groups){
            $group = [MyADGroup]::new($groupData.name, $groupData.samAccountName, $groupData.displayName,
                $groupData.groupScope, $groupData.groupType, $groupData.description, $groupData.memberOf)
            $result = $group.create($ou.getADOrganizationalUnit().DistinguishedName)
            
            if ($result.success) {
                Write-Log -message $result.message "Green" -level 1

                $group.addToGroups($groupData.memberOf);

                if($groupData.membersOptions.useCsv -eq $true) {
                    $membersData = Import-Csv -Path $groupData.membersOptions.scvPath -Delimiter ";"
                }else{
                    $membersData = $groupData.membersOptions.members
                } 

                foreach($memberData in $membersData) {
                    
                    # Create users
                    $userHT = @{
                        firstName = $memberData.firstName
                        lastName = $memberData.lastName
                        fullName = $memberData.fullName
                        initials = $memberData.initials
                        samAccountName = $memberData.samAccountName
                        displayName = $memberData.displayName
                        logonName = $memberData.logonName
                        password = (ConvertTo-SecureString $memberData.password -AsPlainText -Force)
                        description = $memberData.description
                        enabled = $memberData.enabled, $domain
                        changePasswordAtLogon = [bool]::Parse($memberData.changePasswordAtLogon)
                        cannotChangePassword = [bool]::Parse($memberData.cannotChangePassword)
                        passwordNeverExpires = [bool]::Parse($memberData.passwordNeverExpires)
                    }

                    $user = [MyADUser]::new($userHT, $domain)

                    $result = $user.create($ou.getADOrganizationalUnit().DistinguishedName)

                    if($result.success){
                        Write-Log -message $result.message "Green" -level 2

                        $user.addtoGroup($groupData.samAccountName)

                    }else {
                        Write-Log -message $result.message "Red" -level 2

                    }
                }
        
            }else {
                Write-Log -message $result.message "Red" -level 1
            }
        }
    }else {
        Write-Log -message $result.message "Red" -level 0
    }
}

