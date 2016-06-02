#!/bin/sh

usage() {
	echo "SYNOPSIS
	$0 <a.out>
DESCRIPTION
	Show non-reentrant calls in binary <a.out>
"
}

if [ -z "$1" ]; then
	usage
	exit 1
fi

nm "$1"|grep ' U '|awk '{print $2}'|sed -e 's/@.*//' |
grep  -w -E 'asctime|crypt|ctime|drand48|ecvt|encrypt|erand48|fcvt|fgetgrent|fgetpwent|getdate|getgrent|getgrgid|getgrnam|gethostbyaddr|gethostbyname2|gethostbyname|getmntent|getnetgrent|getpwent|getpwnam|getpwuid|getutent|getutid|getutline|gmtime|hcreate|hdestroy|hsearch|initstate|jrand48|lcong48|lgamma|lgammaf|lgammal|localtime|lrand48|mrand48|nrand48|ptsname|qecvt|qfcvt|rand|random|readdir64|readdir|seed48|setkey|setstate|srand48|srandom|strerror|strtok|tmpnam|ttyname'
