# Note: This plugin should only being used when the plugin wmic_if.bat doesഀ
#       deliver insufficient data. For example, teaming interfaces in Win2012ഀ
#       are not reported correctly (missing speed) by the wmic_if.bat script.ഀ
#ഀ
# This plugin extends the information reported by the performance countersഀ
# with the following fields:ഀ
# Nodenameഀ
# MACAddressഀ
# Interface Nameഀ
# Interface NetConnectionIDഀ
# Interface Driver Desriptionഀ
# Connection Statusഀ
# Interface Speedഀ
ഀ
tryഀ
{ഀ
    $teams = Get-NetLbfoTeamഀ
} catch {}ഀ
ഀ
Function getSpeed($speed_text)ഀ
{ഀ
    $value  = 0ഀ
	$factor = 1ഀ
	$speed_tokens = $speed_text.split(" ")ഀ
	if ($speed_tokens.length -eq 2) {ഀ
	    $value = [float]$speed_tokens[0]ഀ
		$unit  = $speed_tokens[1]ഀ
		if ($unit.tolower() -eq "gbps")ഀ
		{ഀ
		    $factor = 1000000000ഀ
	 	}ഀ
		elseif ($unit.tolower() -eq "mbps")ഀ
		{ഀ
		   $factor = 1000000ഀ
		}ഀ
		elseif ($unit.tolower() -eq "kbps")ഀ
		{ഀ
		   $factor = 1000ഀ
		}ഀ
		}ഀ
	return $($value * $factor)ഀ
}ഀ
ഀ
Function getStatus($status_text)ഀ
{ഀ
	if ($status_text.tolower() -eq "up")ഀ
	{ഀ
	   return "2"ഀ
	}ഀ
	elseഀ
	{ഀ
	   return "0"#ഀ
	}ഀ
}ഀ
ഀ
Write-Host "<<<winperf_if:sep(9)>>>"ഀ
ഀ
Write-Host "Node`tMACAddress`tName`tNetConnectionID`tInterfaceDescription`tNetConnectionStatus`tSpeed"ഀ
foreach ($net in Get-Netadapter -IncludeHidden)ഀ
{ഀ
    $address = $net.MacAddress -replace "-", ":"ഀ
	Write-Host -NoNewline "$env:COMPUTERNAME`t"ഀ
    Write-Host -NoNewline "$($address)`t"ഀ
    Write-Host -NoNewline "$($net.DriverDescription)`t"ഀ
	Write-Host -NoNewline "$($net.Name)`t"ഀ
	Write-Host -NoNewline "$($net.InterfaceDescription)`t"ഀ
ഀ
	$status = "0"ഀ
	if ($net.Status) {ഀ
		$status = "$(getStatus($net.Status.tostring()))"ഀ
	}ഀ
    Write-Host -NoNewline "$status`t"ഀ
	Write-Host $(getSpeed($net.LinkSpeed))ഀ
}ഀ
ഀ
�