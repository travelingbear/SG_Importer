D:
cd \
Import-Module AWSPowerShell
#$groupid = Read-Host "What is the new security group ID: "
#$region = Read-Host "What is the region (i.e. eu-west-1): "
$csvimport = Get-Content .\sg.csv |convertfrom-csv
$csvimport | where Type -Match Inbound | where UserIdGroupPairs -eq $null | foreach {
    $_in_rule = new-object Amazon.EC2.Model.IpPermission
    if ($_.IpProtocol -match "'-1"){$_in_rule.IpProtocol = $_.IpProtocol.Replace("'","")}else {$_in_rule.IpProtocol = $_.IpProtocol}
	if($_.FromPort -ne $null) {$_in_rule.FromPort = $_.FromPort}else {$_in_rule.FromPort = "-1"}
	if($_.ToPort -ne $null){$_in_rule.ToPort = $_.ToPort}else {$_in_rule.ToPort = "-1"}
    if($_.IpRanges -ne $null){$_in_rule.IpRanges.Add($_.IpRanges)}
    Grant-EC2SecurityGroupIngress -GroupId sg-084528b72b4d2c596 -IpPermissions @( $_in_rule ) -Region us-east-1
}
