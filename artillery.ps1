$ScenarioCount = 50
 
 Write-Host "AKS"
 artillery quick --count $ScenarioCount -n 20 http://spa2.6dfe276b0fbb4a579892.westeurope.aksapp.io/
 
 Write-Host "App Service Container"
 artillery quick --count $ScenarioCount -n 20 https://spa-in-appservice-container.azurewebsites.net/
 
 Write-Host "Storage Account Static Website"
 artillery quick --count $ScenarioCount -n 20 https://pdfstaticfiles.z6.web.core.windows.net/
 
 Write-Host "App Service"
 artillery quick --count $ScenarioCount -n 20 https://spa-in-appservice.azurewebsites.net/1