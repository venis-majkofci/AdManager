Import-Module ActiveDirectory

Class MyADOrganizationalUnit {
    [string]$name
    [bool]$protectAccidentalDeletion
    [string]$LDAPath
    [string]$description

    [Microsoft.ActiveDirectory.Management.ADOrganizationalUnit]$adOrganizationalUnit
    

    MyADOrganizationalUnit([string]$name, [bool]$protectAccidentalDeletion, [string]$LDAPath, [string]$description){
        $this.setName($name)
        $this.setProtectAccidentalDeletion($protectAccidentalDeletion)
        $this.setLDAPath($LDAPath)
        $this.setDescription($description)

    }

    # === SETs & GETs ====================================================================================

    [void] setName([string]$name) {
        $this.name = $name
    }    
    
    [void] setProtectAccidentalDeletion([bool]$protectAccidentalDeletion) {
        $this.protectAccidentalDeletion = $protectAccidentalDeletion
    }

    [void] setLDAPath([string]$LDAPath){
        $this.LDAPath = $LDAPath
    }

    [void] setDescription([string]$description) {
        $this.description = $description
    }

    [void] setADOrganizationalUnit() {
        $this.adOrganizationalUnit = Get-ADOrganizationalUnit -Filter "Name -eq '$($this.name)'"
    }

    [string] getName() {
        return $this.name
    }

    [bool] getProtectAccidentalDeletion() {
        return $this.protectAccidentalDeletion
    }

    [string] getLDAPath() {
        return $this.LDAPath
    }

    [string] getDescription() {
        return $this.description
    }

    [Microsoft.ActiveDirectory.Management.ADOrganizationalUnit] getADOrganizationalUnit() {
        return $this.adOrganizationalUnit
    }

    # === METHODS ========================================================================================

    static [bool] exists([string]$name, [string]$searchBase) {
        return Get-ADOrganizationalUnit -Filter "Name -eq '$name'" -SearchBase $searchBase
    }

    [PSCustomObject] create() {
        $status = [PSCustomObject] @{
            success = $false
            message = "Undefined error"
        }

        if ([MyADOrganizationalUnit]::exists($this.name, $this.LDAPath)) {
            $status.success = $false
            $status.message = "Organizational unit called '$($this.name)' alredy exists"
        
        }else {
            try {
                New-ADOrganizationalUnit -Name $this.name `
                    -ProtectedFromAccidentalDeletion $this.protectAccidentalDeletion `
                    -Path $this.LDAPath

                $this.setADOrganizationalUnit()

                $status.success = $true
                $status.message = "Organizational unit called '$($this.name)' created with success"
                
            } catch {
                $status.success = $false
                $status.message = "Creation of Organizational unit called '$($this.name)' failed with error: $($_.Exception.Message)"
            
            }
        }

        return $status
    }
}