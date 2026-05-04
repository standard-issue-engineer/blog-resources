$headers = @{"Metadata" = "true" }
$ProgressPreference = "SilentlyContinue"
$response = Invoke-WebRequest -UseBasicParsing -Uri "http://169.254.169.254/metadata/identity/oauth2/token?resource=https://storage.azure.com/&api-version=2019-08-01" -Headers $headers
$response.StatusCode
