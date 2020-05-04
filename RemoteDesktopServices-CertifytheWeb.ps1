# Certify the Web Script for Remote Desktop Services

param($result)

$rdsPFXPath = $result.ManagedItem.CertificatePath

Import-Module RemoteDesktop

Set-RDCertificate -Role RDPublishing -ImportPath $rdsPFXPath -force
Set-RDCertificate -Role RDWebAccess -ImportPath $rdsPFXPath -force
Set-RDCertificate -Role RDRedirector -ImportPath $rdsPFXPath -force
Set-RDCertificate -Role RDGateway -ImportPath $rdsPFXPath -force
