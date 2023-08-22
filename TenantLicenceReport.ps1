Connect-MsolService

# Get all users
$users = Get-MsolUser | Where-Object { $_.BlockCredential -eq $false -and $_.IsLicensed -eq $true }

# Get all licenses
$licenses = Get-MsolAccountSku | Select-Object -ExpandProperty AccountSkuId

# Create an empty array to store the results
$results = @()

# Loop through each user
foreach ($user in $users) {
    # Create a custom object to store user info and license
    $result = New-Object PSObject
    $result | Add-Member -MemberType NoteProperty -Name "User Principal Name" -Value $user.UserPrincipalName
    $result | Add-Member -MemberType NoteProperty -Name "Display Name" -Value $user.DisplayName

    # Loop through each license
    foreach ($license in $licenses) {
        $hasLicense = $user.Licenses.AccountSkuId -contains $license
        $result | Add-Member -MemberType NoteProperty -Name $license -Value $(if($hasLicense) {"X"} else {""})
    }

    # Add the result to the array
    $results += $result
}

# Export user-license data to Excel worksheet
$excelPath = "C:\Scripts\UsersAndLicenses.xlsx"
$results | Export-Excel -Path $excelPath -WorksheetName "Users and Licenses"