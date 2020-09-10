$Settings = Get-Content -Raw -Path storage-settings.json | ConvertFrom-Json


az group delete --name $Settings.ResourceGroupName --yes