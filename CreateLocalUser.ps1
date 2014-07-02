param($computer="localhost", $user, $password, $help, $admin="n", $ForcePW="n")

 #CREATED BY JEREMY MILL
 #UITS - UNIVERSITY OF CT
 #7-2-2014

function funHelp()

{

$helpText=@"

DESCRIPTION:

NAME: CreateLocalUser.ps1

Creates a local user on either a local or remote machine.

 

PARAMETERS:

-computer Specifies the name of the computer upon which to run the script

-user    Name of user to create

-admin   Boolean administrator value, defaults to N

-ForcePW Boolean force-password change if the account exists, defaults to N

-help     prints help file

 

SYNTAX:

CreateLocalUser.ps1

Generates an error. You must supply a user name

 

CreateLocalUser.ps1 -computer MyComputer -user myUser

 -password Passw0rd^&! -admin Y -forcepw Y

 

Creates a local user called myUser on a computer named MyComputer

with a password of Passw0rd^&! and is made an administrator, a password

change is forced if the account exists

 

CreateLocalUser.ps1 -user myUser -password Passw0rd^&! -admin N -ForcePW N

 

Creates a local user called myUser on local computer with

a password of Passw0rd^&! who isn't an admin and whose password

isn't forced to change if it exists

 

CreateLocalUser.ps1 -help ?

 

Displays the help topic for the script

 

"@

$helpText

exit

}

 
#if help recieves any argument, call function funhelp
if($help){ "Obtaining help ..." ; funhelp }

 
#if the user/password arguments are blank, throw an error
if(!$user -or !$password)

      {

       $(Throw 'A value for $user and $password is required.

       Try this: CreateLocalUser.ps1 -help ?')

        }

#if the user account exists
if([ADSI]::Exists('WinNT://./'+$user))
		{
		echo "we found it already exists"
		#if ForcePW says yes
		if($ForcePW -match "Y")
			{
			#old way of doing things. Here for reference
			#$user_instance = [adsi]"WinNT://localhost/"+$user
			
			#call and instance of the USER and change its password
			$user_instance= [adsi]"WinNT://$computer/$user,user"
			$user_instance.SetPassword($password)
			echo "we forced a password change"
			}
		#$(Throw 'User already exists')
		#no longer throwing an error here, there are still things to do
		}

#Here is the else, basically, run this if you got a user and a password and it never existed
else
	{
	$objOu = [ADSI]"WinNT://$computer"

	$objUser = $objOU.Create("User", $user)

	$objUser.setpassword($password)

	$objUser.SetInfo()

	$objUser.description = "Powershell added account"

	$objUser.SetInfo()
	}
	
#check to see if you want the account to be an admin
#THIS DOESN"T REMOVE ADMIN RIGHTS, if it was an admin once, it's still an admin
if($admin -match "Y")
	{
	net localgroup administrators /ADD $user
	net localgroup users /ADD $user
	}
if($admin -match "Y")
	{
	net localgroup users /ADD $user
	}

