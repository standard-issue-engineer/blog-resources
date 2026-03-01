param(
    [Parameter(Mandatory = $true)]
    [string]$FilePath,

    [Parameter(Mandatory = $true)]
    [string]$StorageAccountName,

    [Parameter(Mandatory = $true)]
    [string]$ContainerName,

    [string]$BlobName = $(Split-Path -Leaf $FilePath),

    [string]$ContentType,

    [switch]$CreateContainerIfMissing
)

function Write-ErrorAndExit {
    param(
        [string]$Message,
        [int]$Code = 1
    )

    Write-Error $Message
    exit $Code
}

if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-ErrorAndExit "Azure CLI is not installed or not available in PATH."
}

if (-not (Test-Path -Path $FilePath -PathType Leaf)) {
    Write-ErrorAndExit "The file '$FilePath' does not exist."
}

try {
    $accountCheck = az storage account show --name $StorageAccountName --query name -o tsv 2>&1
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($accountCheck)) {
        Write-ErrorAndExit "Storage account '$StorageAccountName' could not be found or accessed. Ensure you are logged in and the account name is correct."
    }
}
catch {
    Write-ErrorAndExit "Failed to verify storage account '$StorageAccountName': $_"
}

try {
    $containerExistsOutput = az storage container exists --account-name $StorageAccountName --name $ContainerName --auth-mode login -o tsv 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-ErrorAndExit "Failed to check whether container '$ContainerName' exists in storage account '$StorageAccountName'."
    }

    $containerExists = $containerExistsOutput -eq 'True'
    if (-not $containerExists) {
        if ($CreateContainerIfMissing) {
            Write-Output "Container '$ContainerName' does not exist. Creating it..."
            az storage container create --account-name $StorageAccountName --name $ContainerName --auth-mode login | Out-Null
            if ($LASTEXITCODE -ne 0) {
                Write-ErrorAndExit "Failed to create container '$ContainerName' in storage account '$StorageAccountName'."
            }
        }
        else {
            Write-ErrorAndExit "Container '$ContainerName' does not exist in storage account '$StorageAccountName'. Use -CreateContainerIfMissing to create it automatically."
        }
    }
}
catch {
    Write-ErrorAndExit "Failed to verify or create container '$ContainerName': $_"
}

try {
    $uploadArgs = @(
        'storage', 'blob', 'upload',
        '--account-name', $StorageAccountName,
        '--container-name', $ContainerName,
        '--name', $BlobName,
        '--file', $FilePath,
        '--auth-mode', 'login'
    )

    if ($PSBoundParameters.ContainsKey('ContentType') -and -not [string]::IsNullOrWhiteSpace($ContentType)) {
        $uploadArgs += @('--content-type', $ContentType)
    }

    $uploadResult = az @uploadArgs 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-ErrorAndExit "Upload failed: $uploadResult"
    }

    Write-Output "Upload succeeded: '$FilePath' -> '$StorageAccountName/$ContainerName/$BlobName'"
    exit 0
}
catch {
    Write-ErrorAndExit "Upload failed with error: $_"
}
