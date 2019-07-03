@echo off
echo "言語オプションのキーボードに、Japanist 2003を追加"
powershell -NoProfile -ExecutionPolicy Unrestricted .\add_japanist2003.ps1
echo "完了しました"
pause > nul
exit
