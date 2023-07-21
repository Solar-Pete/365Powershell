#Connect to the MsolService
Connect-MsolService

# Create an empty hashtable to store the counts
$counts = @{}

# Get all the users
$users = Get-MsolUser -All

# Loop through the users
foreach ($user in $users) {
    # Check if the user has an Exchange Online Plan 2 license
    if ($user | Where-Object {($_.licenses).AccountSkuId -match "SPB"}) {
        # Get the domain of the user
        $domain = $user.UserPrincipalName.Split("@")[1]

        # Increment the count for the domain
        if ($counts.ContainsKey($domain)) {
            $counts[$domain]++
        } else {
            $counts[$domain] = 1
        }
    }
}

# Output the counts
foreach ($domain in $counts.Keys) {
    Write-Output ("{0}: {1}" -f $domain, $counts[$domain])
}