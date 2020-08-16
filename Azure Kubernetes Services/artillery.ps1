$ScenarioCount = 50
 
 Write-Host "AKS"
 artillery quick --count $ScenarioCount -n 20 http://spa.3bd9b466a0e14770af40.westeurope.aksapp.io/
 
 Write-Host "App Service Container"
 artillery quick --count $ScenarioCount -n 20 https://spa-in-appservice-container.azurewebsites.net/
 
 Write-Host "Storage Account Static Website"
 artillery quick --count $ScenarioCount -n 20 https://pdfstaticfiles.z6.web.core.windows.net/
 
 Write-Host "App Service"
 artillery quick --count $ScenarioCount -n 20 https://spa-in-appservice.azurewebsites.net/1