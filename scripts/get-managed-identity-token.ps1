$headers = @{"X-IDENTITY-HEADER" = $env:IDENTITY_HEADER }
$ProgressPreference = "SilentlyContinue"
$response = Invoke-WebRequest -UseBasicParsing -Uri "$($env:IDENTITY_ENDPOINT)?resource=https://storage.azure.com/&api-version=2019-08-01" -Headers $headers
$response.StatusCode
