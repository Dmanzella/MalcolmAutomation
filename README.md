The aim of this project is to automatically build a VM image with Malcolm on it, and run tests to verify Malcolm is working properly, then remove the VM. 

Vagrant works with Virtualbox to script and build out the VM image, and Ansible is used to configure Malcolm on the VM and run the tests.

Running the CompleteTest.sh script should do everything for you out of the box, but have not tested environment_setup.sh yet. Testing still needs to be built out.
