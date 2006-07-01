# From:
# http://www.unav.es/cti/ldap-smb/smb-ldap-3-howto.html
#
# samba-3.0alpha24
# Several attributtes has been renamed to avoid name clash.
# 
#  LDAP Schema Changes
#  -------------------
#  A new objectclass (sambaSamAccount) has been introduced to replace the old
#  sambaAccount.  This change aids us in the renaming of attributes to prevent
#  clashes with attributes from other vendors.  There is a conversion script
#  (examples/LDAP/convertSambaAccount) to modify and LDIF file to the new schema.
#
# Also, in a hurry, you can use this awk script
#
# Replace our SID with your SID
# to obtain your SID:
#         bin/net getlocalsid <DOMAINNAME>
# on the Samba PDC as root.
#
# example:
#
#  ./slapcat -f slapd-3.conf -b "o=smb,dc=unav,dc=es" -l smb-ldif-3-030515
#   awk -f ldif2samAcount.awk smb-ldif-030515 > smb-ldif-030515-v3
#   ./slapadd -f slapd-3.conf -b "o=smb,dc=unav,dc=es" -l smb-ldif-030515-V3
#
#


BEGIN {
     FS = ": "
     SID = "S-1-5-21-2656270644-2771678393-2525940785" }
{
     if ($1=="rid") {print "sambaSID: "SID"-"$2}

     else if ($2=="sambaAccount") {print "objectClass: sambaSamAccount"}
     else if ($1=="ntSid") {print "sambaSID: "$2}
     else if ($1=="ntGroupType") {print "sambaGroupType: "$2}
     else if ($1=="primaryGroupID") {print "sambaPrimaryGroupSID: "SID"-"$2}
     else if ($1=="lmPassword") {print "sambaLMPassword: "$2}
     else if ($1=="ntPassword") {print "sambaNTPassword: "$2}
     else if ($1=="pwdLastSet") {print "sambaPwdLastSet: "$2}
     else if ($1=="pwdMustChange") {print "sambaPwdMustChange: "$2}
     else if ($1=="pwdCanChange") {print "sambaPwdCanChange: "$2}
     else if ($1=="homeDrive") {print "sambaHomeDrive: "$2}
     else if ($1=="smbHome") {print "sambaHomePath: "$2}
     else if ($1=="scriptPath") {print "sambaLogonScript: "$2}
     else if ($1=="profilePath") {print "sambaProfilePath: "$2}
     else if ($1=="kickoffTime") {print "sambaKickoffTime: "$2}
     else if ($1=="logonTime") {print "sambaLogonTime: "$2}
     else if ($1=="logoffTime") {print "sambaLogoffTime: "$2}
     else if ($1=="userWorkstations") {print "sambaUserWorkstations: "$2}
     else if ($1=="domain") {print "sambaDomainName: "$2}
     else if ($1=="acctFlags") {print "sambaAcctFlags: "$2}

     else {print $_}
}

	 