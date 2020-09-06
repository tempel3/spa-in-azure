

param (
    $localPath = "c:\ebanking\PosPay\*.*" ,
    $RemotePath = "/incoming/arp/" ,
    $backupPath = "C:\eBanking\Z_Arch\PosPay"
)
try
{
# Load WinSCP .NET assembly
Add-Type -Path "WinSCPnet.dll"
 
# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "fdqn.computer.com"
    UserName = "xxxxxxx"
    Password = "xxxxxxxxxxx"
    SshHostKeyFingerprint = "ssh-rsa 1024 abcdefghijklmnopqrstuvwxyz"
    
}
 
$session = New-Object WinSCP.Session
 
try
{
    # Connect
    $session.Open($sessionOptions)
 
        # Upload files, collect results
        $transferResult = $session.PutFiles($localPath, $remotePath)
 
        # Iterate over every transfer
        foreach ($transfer in $transferResult.Transfers)
        {
            # Success or error?
            if ($transfer.Error -eq $Null)
            {
                Write-Output "Upload of $($transfer.FileName) succeeded, moving to backup" >> C:\eBanking\Z_Logs\BofAPP.log
                # Upload succeeded, move source file to backup
                Move-Item $transfer.FileName $backupPath
            }
            else
            {
                Write-Host "Upload of $($transfer.FileName) failed: $($transfer.Error.Message)"
            }
        }
    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }
 
    exit 0
}
catch
{
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}