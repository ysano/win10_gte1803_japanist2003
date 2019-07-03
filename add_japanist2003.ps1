# https://www.fujitsu.com/jp/products/software/applications/applications/japanist/contact/
# Windows 10の[設定]-[言語]-[言語オプション]-[キーボード]からJapanist 2003の追加・削除ができないのですが… 
# Set-ExecutionPolicy RemoteSigned
Set-StrictMode -Version Latest
Set-PSDebug -strict

## 言語リストの「日本語」の表示順を確認します。
[int]$i = 0
foreach($lang in Get-WinUserLanguageList){
    if($lang.LanguageTag -eq 'ja'){
        [int]$languageIndex = $i
    }
    $i++
}

if($languageIndex -eq $null){
    Write-Host -BackgroundColor red 'Error: LanguageTag: ja が見つかりません'
    exit
}
Write-Host "LanguageIndex: $languageIndex"

## 「Japanist 2003」の"Keyboard layout ID"を確認します。 
[String]$targetLayout = "Japanist 2003"
$registory = Get-ChildItem -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layouts" |
  Where-Object {($_.GetValue("Layout Text") -match $targetLayout)}

if($registory -eq $null){
    Write-Host  -BackgroundColor red "Error: Registory: $targetLayout が見つかりません"
    exit
}

$keyboardLayoutId = $registory.PSChildName
Write-Host "Keyboard layout ID: $keyboardLayoutId"

# https://www.autoitscript.com/autoit3/docs/appendix/OSLangCodes.htm
[String]$dispLangCode = '0411'

## 入力方式に追加
$languageList = Get-WinUserLanguageList
$languageList[$languageIndex].InputMethodTips.Add("${dispLangCode}:${keyboardLayoutId}")
Set-WinUserLanguageList $languageList -Force

## 入力方式から削除
# $languageList = Get-WinUserLanguageList
# $languageList[$languageIndex].InputMethodTips.Remove("$dispLangCode:$keyboardLayoutId")
# Set-WinUserLanguageList $languageList -Force

