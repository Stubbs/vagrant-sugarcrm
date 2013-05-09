# Vagrant Config for a SugarCRM VM

## SOLD AS SEEN

You should treat this as a starting point for your SugarCRM based VM, and not a working solution. It works for me last time I tried it, and that's all I'll say about it :-)

You'll need to do the following to get started:

* Edit Vagrantconfig and set your box to something you have.
* Download the latest CE edition of SugarCRM into this directory
* Edit manifests/base.pp and make sure the sugarDir variable matches the version you downloaded
* Edit manifests/base.pp and change the SugarCRM zip file to match the one you downloaded.
* Run bootstrap.sh to install required puppet modules.

Please submit pull requests with any fixes to documentation or bugs.
