# Import Active Directory module
Import-Module ActiveDirectory

# Define CSV file path (update before use)
$CSVPath = "C:\Path\To\users.csv"

# Import CSV file
$Users = Import-Csv -Path $CSVPath

foreach ($User in $Users) {
    # Define user properties
    $UserPrincipalName = "$($User.Email)"
    $Name = "$($User.DisplayName)"
    $OU = $User.OU
    $Password = (ConvertTo-SecureString -AsPlainText $User.Password -Force)

    # Retrieve manager's Distinguished Name if provided
    $ManagerDN = if ($User.Manager) { 
        (Get-ADUser -Identity $User.Manager).DistinguishedName
    } else {
        $null
    }

    # Check if user already exists
    if (Get-ADUser -Filter "SamAccountName -eq '$($User.SamAccountName)'" ) {
        Write-Host "User $($User.SamAccountName) already exists. Skipping..."
    } else {
        # Create the new user
        New-ADUser -Name $Name `
            -GivenName $User.FirstName `
            -Surname $User.LastName `
            -UserPrincipalName $UserPrincipalName `
            -SamAccountName $User.SamAccountName `
            -DisplayName $User.DisplayName `
            -Initials $User.Initials `
            -Company $User.Company `
            -Description $User.Description `
            -Department $User.Department `
            -Office $User.Office `
            -Title $User.Title `
            -Path $OU `
            -AccountPassword $Password `
            -Enabled $true `
            -AccountExpirationDate $User.AccountExpires `
            -Manager $ManagerDN `
            -ChangePasswordAtLogon $true  # Require password change at next login

        # Set the email address if available
        if ($User.Email) {
            Set-ADUser -Identity $User.SamAccountName -EmailAddress $User.Email
        }

        # Assign groups based on JobLevel
        $GroupList = @()
        switch ($User.JobLevel) {
            "Associate"  { $GroupList = @("Group_Associate_A", "Group_Associate_B") }
            "Supervisor" { $GroupList = @("Group_Supervisor_A", "Group_Supervisor_B") }
            "Manager"    { $GroupList = @("Group_Manager_A", "Group_Manager_B") }
            "Executive"  { $GroupList = @("Group_Executive_A", "Group_Executive_B") }
        }

        # Add user to the assigned groups
        foreach ($Group in $GroupList) {
            Add-ADGroupMember -Identity $Group -Members $User.SamAccountName
        }

        Write-Host "User $Name created successfully."
    }
}
