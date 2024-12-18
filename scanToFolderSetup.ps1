# Variables
$folderPath = "C:\Users\lab\Documents\Scan"
$shareName = "Scan"
$userName = "scan"
$password = "123456"
$group = "Everyone"

# Create the folder if it doesn't exist
if (-Not (Test-Path -Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath
}

# Create the share
New-SmbShare -Name $shareName -Path $folderPath -FullAccess $group

# Set permissions on the folder
$acl = Get-Acl -Path $folderPath
$permission = New-Object System.Security.AccessControl.FileSystemAccessRule($group, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.SetAccessRule($permission)
Set-Acl -Path $folderPath -AclObject $acl

# Create a new user if it doesn't exist
if (-Not (Get-LocalUser -Name $userName -ErrorAction SilentlyContinue)) {
    New-LocalUser -Name $userName -Password (ConvertTo-SecureString -AsPlainText $password -Force) -FullName "Scan User" -Description "User for scan to SMB"
}

# Add user to the Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $userName

# Output message
Write-Output "Scan to folder setup completed successfully. Folder path: $folderPath, Share name: $shareName, User: $userName"

<# This script does the following:
    1. Defines the path of the folder to be shared and other relevant details.
    2. Checks if the folder exists; if not, creates it.
    3. Creates a new SMB share for the folder.
    4. Sets full control permissions for the "Everyone" group on the folder.
    5. Creates a new local user for accessing the share if it doesn’t already exist.
    6. Adds the user to the Administrators group for elevated permissions.
Run this script in PowerShell as an administrator to ensure all commands execute properly.
Is there anything else you'd like to configure or any other setup you need help with?
#>
