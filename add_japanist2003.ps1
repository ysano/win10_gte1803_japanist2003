# https://www.fujitsu.com/jp/products/software/applications/applications/japanist/contact/
# Windows 10��[�ݒ�]-[����]-[����I�v�V����]-[�L�[�{�[�h]����Japanist 2003�̒ǉ��E�폜���ł��Ȃ��̂ł����c 
# Set-ExecutionPolicy RemoteSigned
Set-StrictMode -Version Latest
Set-PSDebug -strict

## ���ꃊ�X�g�́u���{��v�̕\�������m�F���܂��B
[int]$i = 0
foreach($lang in Get-WinUserLanguageList){
    if($lang.LanguageTag -eq 'ja'){
        [int]$languageIndex = $i
    }
    $i++
}

if($languageIndex -eq $null){
    Write-Host -BackgroundColor red 'Error: LanguageTag: ja ��������܂���'
    exit
}
Write-Host "LanguageIndex: $languageIndex"

## �uJapanist 2003�v��"Keyboard layout ID"���m�F���܂��B 
[String]$targetLayout = "Japanist 2003"
$registory = Get-ChildItem -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layouts" |
  Where-Object {($_.GetValue("Layout Text") -match $targetLayout)}

if($registory -eq $null){
    Write-Host  -BackgroundColor red "Error: Registory: $targetLayout ��������܂���"
    exit
}

$keyboardLayoutId = $registory.PSChildName
Write-Host "Keyboard layout ID: $keyboardLayoutId"

# https://www.autoitscript.com/autoit3/docs/appendix/OSLangCodes.htm
[String]$dispLangCode = '0411'

## ���͕����ɒǉ�
$languageList = Get-WinUserLanguageList
$languageList[$languageIndex].InputMethodTips.Add("${dispLangCode}:${keyboardLayoutId}")
Set-WinUserLanguageList $languageList -Force

## ���͕�������폜
# $languageList = Get-WinUserLanguageList
# $languageList[$languageIndex].InputMethodTips.Remove("$dispLangCode:$keyboardLayoutId")
# Set-WinUserLanguageList $languageList -Force

