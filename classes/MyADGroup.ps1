Import-Module ActiveDirectory

Import-Module .\logManager.ps1
class MyADGroup {
    [string]$name
    [string]$samAccountName
    [string]$displayName
    [string]$groupScope
    [string]$groupType
    [string]$description
    [string[]]$memberOf

    [Microsoft.ActiveDirectory.Management.ADGroup]$adGroup

    MyADGroup([string]$name, [string]$samAccountName, [string]$displayName, [string]$groupScope, 
        [string]$groupType, [string]$description, [string[]]$memberOf) {
        
        $this.setName($name)
        $this.setSamAccountName($samAccountName)
        $this.setDisplayName($displayName)
        $this.setGroupScope($groupScope)
        $this.setGroupType($groupType)
        $this.setDescription($description)
        $this.setMemberOf($memberOf)
    }
    
    # === SETs & GETs ====================================================================================

    [void] setName([string]$name) {
        $this.name = $name
    }
    
    [void] setSamAccountName([string]$samAccountName) {
        $this.samAccountName = $samAccountName
    }

    [void] setDisplayName([string]$displayName) {
        $this.displayName = $displayName
    }

    [void] setGroupScope([string]$groupScope) {
        $this.groupScope = $groupScope
    }

    [void] setGroupType([string]$groupType) {
        $this.groupType = $groupType
    }

    [void] setDescription([string]$description) {
        $this.description = $description
    }

    [void] setMemberOf([string[]]$memberOf) {
        $this.memberOf = $memberOf
    }

    [void] setADGroup() {
        $this.adGroup =  Get-ADGroup -Identity $this.name
    }

    [string] getName() {
        return $this.name
    }
    
    [string] getSamAccountName() {
        return $this.samAccountName
    }

    [string] getDisplayName() {
        return $this.displayName
    }

    [string] getGroupScope() {
        return $this.groupScope
    }
    
    [string] getGroupType() {
        return $this.groupType
    }
    
    [string] getDescription() {
        return $this.description
    }
    
    [string[]] getMemberOf() {
        return $this.memberOf
    }
    
    [Microsoft.ActiveDirectory.Management.ADGroup] getADGroup() {
        return $this.adGroup
    }

    # === METHODS ========================================================================================

    static [bool] exists([string]$samAccountName) {
        return Get-ADGroup -Filter "samAccountName -eq '$samAccountName'"
    }
  
    [PSCustomObject] create([string]$path){
        $status = [PSCustomObject] @{
            success = $false
            message = "Undefined error"
        }

        if([MyADGroup]::exists($this.samAccountName)){
            $status.success = $false
            $status.message = "Group called '$($this.name)' alredy exists"
        
        }else{
            try {
                New-ADGroup -Name $this.name `
                    -SamAccountName $this.samAccountName `
                    -DisplayName $this.displayName `
                    -GroupScope $this.groupScope `
                    -GroupCategory $this.groupType `
                    -Path $path `
                    -Description $this.description

                $this.setAdGroup()
                            
                $status.success = $true
                $status.message = "Group called '$($this.name)' created with success"
                    
            } catch {
                $status.success = $false
                $status.message = "Creation of Group called '$($this.name)' failed with error: $($_.Exception.Message)"
            
            }
        }

        return $status
    }

    [void] addToGroups([string[]]$groups){
        foreach($group in $groups) {
            try {
                Add-ADGroupMember -Identity $group -Members $this.adGroup
                
                Write-Log -message "Group called '$($this.name)' added to '$group' with success" "Blue" -level 3
           
            }catch {
                Write-Log -message "Error adding group called '$($this.name)' to '$group': $($_.Exception.Message)" "Red" -level 3
                
            }
        }
    }
}