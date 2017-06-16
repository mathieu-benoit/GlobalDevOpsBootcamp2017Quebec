$path = "C:\inetpub\wwwroot"
$acl = Get-Acl $path
Set-Acl $path $acl