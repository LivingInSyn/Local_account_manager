param($help, $computer="localhost", $user, $DelProf="n")

 #CREATED BY JEREMY MILL
 #UITS - UNIVERSITY OF CT
 #7-3-2014
 
Function Help()
{
$helpText=@"

DESCRIPTION: This is a Utility to Delete an account on a local or remote computer

PARAMETERS:

-help	opens this help file

-computer	Specify the computer to run this script. Default is LocalHost

-user	The user to delete

-DelProf	Specify if you want to delete the users profile. Defaults to N

EXAMPLES:

.\DeleteLocalUser -help ?

--prints this help file

.\DeleteLocalUser -computer mycomputer.mydomain.com -user localadmin -delprof Y

--This will delete the local user named LocalAdmin on mycomputer.mydomain.com and delete
their profile

.\DeleteLocalUser -user localadmin

--This will delete the local user named LocalAdmin on the local machine and will NOT delete
its profile

"@

$helpText
	
exit
}

#check for help parameter existing
if($help){ "Obtaining help ..." ; help }

#make sure the user supplied a username to delete.
if(!$user)
	{
	$(Throw "A value for -user is required. Try DeleteLocalUser -help ?")
	}
	
#check if the user exists on the system, delete it if it does
if([ADSI]::Exists('WinNT://./'+$user))
	{
	echo "The account exists"
	$objOu = [ADSI]"WinNT://$computer"
	$objUser = $objOU.Delete("User", $user)
	echo "Account Deleted"
	}
	
#if delprof=y, check if it exists and delete it if it does
if($DelProf -match "Y")
	{
	$path = "C:\users\"+$user
	if(test-path $path)
		{
		$filter = "localpath=C:\\Users\\"+$user+"'"
		#$profile = Get-WmiObject Win32_UserProfile  -computer $computer -filter "localpath='C:\\Users\\testuser'"
		$profile = Get-WmiObject Win32_UserProfile  -computer $computer -filter $filter
		$profile.Delete()
		}
	else
		{
		echo "nothing to delete"
		}
	}

	
	
	