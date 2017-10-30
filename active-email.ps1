$emailFromAddress = "xxx@xxx.com"
$bccemail = "xxx@xxx.com"
$emailToAddress = "xxx@xxx.com"
$emailSMTPServer = "outlook.office365.com"
$emailSubject = "Member Connect NSW SES User List"
$emailBodyText = "#AUTOMATED EMAIL# - Attached User List for - " 
$date = Get-Date -format d-M-yyyy
$emailBody = $emailBodyText + $date
$credObject = Get-AutomationPSCredential -Name 'automation'
$fileName = "o365UserList-" + $date + ".csv"
Connect-MsolService -Credential $credObject
$outcsv = ‘C:\Users\Client\Temp\’ + $fileName
$users = Get-MsolUser -All | Where-Object {$_.IsLicensed -eq "true" -and $_.BlockCredential -eq $false} | Select-Object UserPrincipalName, DisplayName   | Sort-Object DisplayName
$users | Export-Csv $outcsv
Send-MailMessage -Credential $credObject -From $emailFromAddress -To $emailToAddress -bcc $bccemail -Subject $emailSubject -Body $emailbody –Attachments $outcsv -SmtpServer $emailSMTPServer -UseSSL
