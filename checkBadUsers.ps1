<#
Created By: Mateus Rogienfisz
Created Date: 03/09/2019
#>


#region Connections

Connect-MsolService 

#endregion Connections


$azureUsers = Get-MsolUser -all | ? {-not $_.LastDirSyncTime}

#region Functions

<#Verifies if the object have a name#>
function checkFirstNameStandard($user){
   return( -not ( $user.firstName -eq $null ) )
}

function checkLastNameStandard($user){
   return( -not ($user.firstName -eq $null) )  
}

function checkUPNStandard($user){
   return( ($user.UserPrincipalName -match '\b[0-9]+@idf.il\b') -and ( ($user.UserPrincipalName.split("@"))[0].Length -eq 9 ))
}

function checkPhoneStandard($user){
    return( -not ($user.PhoneNumber -eq $null) )   
}

function printBadUsers($Users){

    $badusers = @()

    $Users | %{
        $user = @{}
    
        if(-not (checkFirstNameStandard($_)) ){
            $user.Add("FirstName", "empty" )
        }

        if(-not (checkLastNameStandard($_))){
            $user.Add("LastName", "empty")
        }

        if(-not (checkUPNStandard($_))){
            $user.Add("UPN",$_.UserPrincipalName)
        }

        if(-not (checkPhoneStandard($_))){
            $user.Add("phone","empty")
        }
    
        if($user.Count -ne 0){
            $user.Add("ObjectId", $_.ObjectId )
            $badusers += $user
        }
    }


    $badusers | %{

        Write-Host "Object id - " $_.ObjectId

        if ($_.UPN -ne $null){
            Write-Host "UPN - " $_.UPN
        }

        if ($_.FirstName -ne $null){
            Write-Host "First Name -" $_.FirstName   
        }

        if ($_.LastName -ne $null){
             Write-Host "Last Name -" $_.LastName
        }

        if ($_.phone -ne $null){
             Write-Host "Phone -" $_.phone
        }

        Write-Host "-----------------------------------"
    }

}

#endregion Functions

#region logic
    printBadUsers($azureUsers)
#endregion logic