param (
    [Parameter(Mandatory=$true)][string]$LocalServer,
    [Parameter(Mandatory=$true)][string]$RemoteServer,
    [Parameter(Mandatory=$true)][string]$LocalDB,
    [Parameter(Mandatory=$true)][string]$RemoteDB,
    [Parameter(Mandatory=$true)][string]$LocalTable,
    [Parameter(Mandatory=$true)][string]$RemoteTable,
    [Parameter(Mandatory=$true)][string]$User,
     [Parameter(Mandatory=$true)][SecureString]$Password
)

Import-Module SqlServer -ErrorAction Stop

$sourceConnStr = "Server=$LocalServer;Database=$LocalDB;User Id=$User;Password=$Password;"
$destConnStr = "Server=$RemoteServer;Database=$RemoteDB;User Id=$User;Password=$Password;"

Write-Host "Connecting to source: $LocalServer, database: $LocalDB"
Write-Host "Connecting to destination: $RemoteServer, database: $RemoteDB"

try {
    # Fetch all data from source table
    $data = Invoke-Sqlcmd -Query "SELECT * FROM $LocalTable" -ConnectionString $sourceConnStr

    if ($data.Count -eq 0) {
        Write-Host "No records found in source table '$LocalTable'. Nothing to migrate."
        exit 0
    }

    Write-Host "Fetched $($data.Count) records from source table."

    # Insert each row into destination table
    foreach ($row in $data) {
        # Build insert query — adjust columns as needed
        $insertQuery = @"
INSERT INTO $RemoteTable (user_id, user_name, user_email)
VALUES ('$($row.user_id)', '$($row.user_name)', '$($row.user_email)')
"@

        Invoke-Sqlcmd -Query $insertQuery -ConnectionString $destConnStr
    }

    Write-Host "Data migration completed successfully."

} catch {
    Write-Error "An error occurred: $_"
    exit 1
}
