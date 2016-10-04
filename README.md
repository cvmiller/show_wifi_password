## Show Wifi Passwords on Chrome OS
A script to show stored Wifi Passwords on the Chromebook.

### Requirements
Chromebook **must** be in **developeer** mode. Root access is required via the [crash shell](chrome-extension://nkoccljplnhpfnfiajclkommnmllphnl/html/crosh.html) (via Ctrl+Alt+T).

Additionally having **Crouton** installed will make things *much* easier.

### A tale of two machines - Chrome OS & Crouton
Chrome OS has most of the mounted partitions restricted from executing scripts. Crouton has a less restrictive directory tree. Fortunately, Crouton shares /tmp/ with Chrome OS.

### Step 1 
Must be preformed in the crash shell (under ChromeOS), to copy the wifi password file to /tmp, and change permissions such that the Crouton user can read the file. The following will copy the wifi password file to /tmp/.

```
sudo find  /home/root/ -name shill.profile -exec cp {} /tmp/ \;
sudo chmod 644 /tmp/shill.profile
```

### Step 2
Run the show script from Crouton, using the `-f` parameter to specify the wifi password file.

<pre>
./show_wifi_passwd.sh -f /tmp/shill.profile 
=== Show the decoded wifi password file
Name=wind
<font color="red">windyday</font>
Name=lilikoi
<font color="red">ohsosweet</font>
Name=Room-128
<font color="red">Guest128</font>
=== Pau!
(trusty)cvmiller@localhost:~/Downloads$
</pre>


### Background Info
Chrome OS stores Wifi Passwords with a minimum of encryption (ROT47) in `/home/root/<user_id>/shill/shill.profile`. If there are multiple users on the chromebook, there will be multiple shill.profile files.

Since Chrome OS mounts most partitions with `noexec` parameter, the `show_wifi_password.sh` will not run from Chrome OS. Therefore, one must copy the `shill.profile` file to `/tmp/` where it is accessible from Crouton. Inside Crouton, one can easily execute scripts, including the `show_wifi_password.sh` script.

### Limitations
**Step 1** only works with a single user on the Chromebook. If you have multiple users, the `find ...` command will copy the highest <user_id> to `/tmp/`.

Some wifi logins are more complex than just a simple WPA/WPA2 password. The script will decode all fields marked as password (such as EAP.Password) for a given access point.

This script *only* decodes ROT47 encoded passwords. 

### Reference
Information on how to decode stored wifi passwords written on [Reddit](https://www.reddit.com/r/chromeos/comments/3gbaw0/chromebook_stored_wifi_password_access/) a few years ago.

### About the Script Author

Craig Miller has been an IPv6 advocate since 1998 when he then worked for Bay Networks. He has been working professionally in Telecom/Networking ever since. Look for his other OpenWRT projects, [v6 Brouter](https://github.com/cvmiller/v6brouter) a script to extend a /64 network (when upstream won't give you your own /64) and [v6disc](https://github.com/cvmiller/v6disc) an IPv6 discovery script.

