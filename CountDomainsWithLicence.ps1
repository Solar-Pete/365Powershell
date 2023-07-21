#Connect to the MsolService
Connect-MsolService

# Create an empty hashtable to store the counts
$counts = @{}

# Get all the users
$users = Get-MsolUser -All

# Loop through the users
foreach ($user in $users) {
    
	# Check if the user has an Microsoft 365 Business Premium licence. Change the ENTERSKUHERE to the SKU you are wishing to look for.
	
	# Common SKUs are
	# Exchange Plan 2 - EXCHANGEENTERPRISE
	# Business Basic - O365_BUSINESS_ESSENTIALS
	# Business Standard - O365_BUSINESS_PREMIUM
	# Business Premium - SPB
	# Office 365 E3 - ENTERPRISEPACK
	# Office 365 E5 - ENTERPRISEPREMIUM
	
    if ($user | Where-Object {($_.licenses).AccountSkuId -match "ENTERSKUHERE"}) {
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