$Settings = Get-Content -Raw -Path cdn-settings.json | ConvertFrom-Json


az group delete --name $Settings.ResourceGroupName --yes