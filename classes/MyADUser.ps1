Import-Module ActiveDirectory

Import-Module .\logManager.ps1

class MyADUser {
    [string]$firstName
    [string]$lastName
    [string]$fullName
    [string]$initials
    [string]$samAccountName
    [string]$displayName
    [string]$logonName
    [securestring]$password
    [string]$description
    [bool]$enabled
    [bool]$changePasswordAtLogon
    [bool]$passwordNeverExpires
    [bool]$cannotChangePassword

    [Microsoft.ActiveDirectory.Management.ADUser]$adUser
    
    MyADUser([hashtable]$user, $domain) {
        $this.setFirstName($user.firstName)
        $this.setLastName($user.lastName)
        $this.setFullName($user.fullName)
        $this.setInitials($user.initials)
        $this.setSamAccountName($user.samAccountName)
        $this.setDisplayName($user.displayName)
        $this.setLogonName($user.logonName, $domain)
        $this.setPassword($user.password)
        $this.setDescription($user.description)
        $this.setEnabled($user.enabled)
        $this.setChangePasswordAtLogon($user.changePasswordAtLogon)
        $this.setPasswordNeverExpires($user.passwordNeverExpires)
        $this.setCannotChangePassword($user.cannotChangePassword)
    }
    
    # === SETs & GETs ====================================================================================

    [void] setFirstName([string]$firstName) {
        $this.firstName = $firstName
    }

    [void] setLastName([string]$lastName) {
        $this.lastName = $lastName
    }

    [void] setFullName([string]$fullName) {
        $this.fullName = $fullName
    }

    [void] setInitials([string]$initials) {
        $this.initials = $initials
    }
    
    [void] setSamAccountName([string]$samAccountName) {
        $this.samAccountName = $samAccountName
    }

    [void] setDisplayName([string]$displayName) {
        $this.displayName = $displayName
    }

    [void] setLogonName([string]$logonName, [string[]]$domain) {
        $this.logonName = "$logonName@$($domain[0]).$($domain[1])" 
    }

    [void] setPassword([securestring]$password) {
        $this.password = $password
    }

    [void] setDescription([string]$description) {
        $this.description = $description
    }
    
    [void] setEnabled([bool]$enabled) {
        $this.enabled = $enabled
    }

    [void] setChangePasswordAtLogon([bool]$changePasswordAtLogon) {
        $this.changePasswordAtLogon = $changePasswordAtLogon
    }

    [void] setPasswordNeverExpires([bool]$passwordNeverExpires) {
        $this.passwordNeverExpires = $passwordNeverExpires
    }

    [void] setCannotChangePassword([bool]$cannotChangePassword) {
        $this.cannotChangePassword = $cannotChangePassword
    }

    [void] setADUser() {
        $this.adUser =  Get-ADUser -Identity $this.samAccountName
    }

    [string] getFirstName() {
        return $this.firstName
    }

    [string] getLastName() {
        return $this.lastName
    }

    [string] getFullName() {
        return $this.fullName
    }

    [string] getInitials() {
        return $this.initials
    }
    
    [string] getSamAccountName() {
        return $this.samAccountName
    }

    [string] getDisplayName() {
        return $this.displayName
    }

    [string] getLogonName() {
        return $this.logonName
    }

    [securestring] getPassword() {
        return $this.password
    }

    [string] getDescription() {
        return $this.description
    }

    [bool] isEnabled() {
        return $this.enabled
    }

    [bool] getChangePasswordAtLogon() {
        return $this.changePasswordAtLogon
    }

    [bool] getPasswordNeverExpires() {
        return $this.passwordNeverExpires
    }

    [bool] getCannotChangePassword() {
        return $this.cannotChangePassword
    }

    [Microsoft.ActiveDirectory.Management.ADUser] getADUser() {
        return $this.adUser
    }
    
    # === METHODS ========================================================================================

    static [bool] exists([string]$samAccountName) {
        return Get-ADUser -Filter "samAccountName -eq '$samAccountName'"
    }

    [PSCustomObject] create([string]$path){
        $status = [PSCustomObject] @{
            success = $false
            message = "Undefined error"
        }
        
        if([MyADUser]::exists($this.samAccountName)){
            $status.success = $false
            $status.message = "User called '$($this.samAccountName)' alredy exists"
        
        }else{
            try {
                $user = @{
                    GivenName = $this.firstName
                    Surname = $this.lastName
                    Name = $this.fullName
                    Initials = $this.initials
                    SamAccountName = $this.samAccountName
                    DisplayName = $this.displayName
                    UserPrincipalName = $this.logonName
                    AccountPassword = $this.password
                    Description = $this.description
                    Enabled = $this.enabled
                    ChangePasswordAtLogon = $this.changePasswordAtLogon
                    PasswordNeverExpires = $this.passwordNeverExpires
                    CannotChangePassword = $this.cannotChangePassword
                    Path = $path
                }

                New-ADUser @user

                $this.setADUser()
                       
                $status.success = $true
                $status.message = "User called '$($this.samAccountName)' created with success"
                    
            } catch {
                $status.success = $false
                $status.message = "Creation of User called '$($this.samAccountName)' failed with error: $($_.Exception.Message)"
            
            }
        }

        return $status
    }

    [void] addtoGroup([string]$group) {
        try {
            Add-ADGroupMember -Identity $group -Members $this.adUser
            
            Write-Log -message "User called '$($this.samAccountName)' added to '$group' with success" "Blue" -level 3
       
        }catch {
            Write-Log -message "Error adding group called '$($this.samAccountName)' to '$group': $($_.Exception.Message)" "Red" -level 3
            
        }
    }
}