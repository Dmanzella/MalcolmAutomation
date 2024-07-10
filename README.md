The aim of this project is to automatically build a VM image with Malcolm on it, and run tests to verify Malcolm is working properly, then remove the VM. 

This tool uses Vagrant with Virtualbox or Libvirt to script and build out the VM image, and Ansible is used to configure Malcolm on the VM and run the tests.

Run setup.sh to configure your environment and install all the required dependencies for this tool, as well as any plugins needed for you system. It also allows you to specify custom Malcolm repos/versions to test with the tool

The testing is still a work in progress, but the idea is to be able to specify exactly what pcaps for Malcolm to ingest, tag every pcap uniquely, then run api calls against every tag produced to see if they match the known good output for each pcap.

List of every available pcap to test with this tool came from https://github.com/mmguero-dev/Malcolm-PCAP