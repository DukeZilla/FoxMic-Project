$source = "https://download.sysinternals.com/files/PSTools.zip"
$destination = "$env:USERPROFILE\Downloads\PSTools.zip"
Invoke-WebRequest $source -OutFile $destination
cd \
cd $env:USERPROFILE\Downloads
Expand-Archive -LiteralPath $env:USERPROFILE\Downloads\PSTools.zip -DestinationPath $env:SYSTEMROOT\System32\PSTools
echo Done.