### Documentation on why we are using this modified versions will follow here:


1. **copy_kernel:** *unused* now a shellprocess: [shellprocess_ck.conf](https://github.com/endeavouros-team/EndeavourOS-calamares/blob/main/calamares/modules/shellprocess_ck.conf)

2. **eos_script:** This module is unique to EndeavourOS, and used to integrate the scripts we need to create EndeavourOS and mainly Archlinux specific configurations.

3. **fstab** and ***mount:** We use the fstab and mount modules from Calamares 3.3. There are a couple of big advantages:
   * Mount options are now set prior to installation so things like compression are applied to the install itself
   * You can now have separate options for both SSDs and HDDs

5. **packages:** We are using a custom version of the packages module to provide feedback to the user during the package installation process

6. **pacstrap:** This module is unique to EndeavourOS, and the pure online install method to be close to arch we are using pacstrap for the initial system creation.

7. **userpkglist:** This module is unique to EndeavourOS, and used on the implementation for users to add a list of packages that will get installed in addition to the system on install process. 
