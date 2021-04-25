$resourceGroupName=$args[0]
$webappname=$args[1]
$location="Southeast Asia"

# Create a resource group.
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create an App Service plan in `Free` tier.
New-AzAppServicePlan -Name $webappname -Location $location `
-ResourceGroupName $resourceGroupName -Tier Basic

# Create a web app.
New-AzWebApp -Name $webappname -Location $location -AppServicePlan $webappname `
-ResourceGroupName $resourceGroupName

$hashtable = @{WEBSITE_NODE_DEFAULT_VERSION = "~10"}
Set-AzWebApp -AppSettings $hashtable -ResourceGroupName $resourceGroupName -Name $webappname -Use32BitWorkerProcess 0

# Get publishing profile for the web app
$xml = [xml](Get-AzWebAppPublishingProfile -Name $webappname `
-ResourceGroupName $resourceGroupName `
-OutputFile null)

$CurrentDir = Get-Location
$CurrentDirPath = Join-Path -Path $CurrentDir -ChildPath  "/"  
$FilePath = $CurrentDirPath + "weather-service-app.zip"
Publish-AzWebapp -ResourceGroupName  $resourceGroupName -Name $webappname -ArchivePath $FilePath
