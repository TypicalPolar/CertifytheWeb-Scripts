# Certify the Web Script for Filezilla Server

param($result)

$filezillaPFXPath = $result.ManagedItem.CertificatePath
$filezillaThumbprint = $result.ManagedItem.CertificateThumbprintHash
$filezillaConfigFile = "C:\Program Files (x86)\FileZilla Server\FileZilla Server.xml"

if (!(Test-Path .\cert -PathType Container)) {
    New-Item -ItemType Directory -Force -Path .\cert
}

.\openssl\openssl pkcs12 -in $filezillaPFXPath -passin pass: -nocerts -out ".\cert\${filezillaThumbprint}.key" -nodes
.\openssl\openssl pkcs12 -in $filezillaPFXPath -passin pass: -clcerts -nokeys -out ".\cert\${filezillaThumbprint}.crt"

$filezillaSSLKeyPath = Resolve-Path .\cert\${filezillaThumbprint}.key
$filezillaSSLCertPath = Resolve-Path .\cert\${filezillaThumbprint}.crt

[xml]$filezillaXML = Get-Content $filezillaConfigFile
$filezillaXML.FileZillaServer.Settings.SelectSingleNode("Item[@name='SSL Key file']").InnerText = $filezillaSSLKeyPath
$filezillaXML.FileZillaServer.Settings.SelectSingleNode("Item[@name='SSL Certificate file']").InnerText = $filezillaSSLCertPath
$filezillaXML.Save($filezillaConfigFile)

Restart-Service "FileZilla Server" -Force -ErrorAction Stop
