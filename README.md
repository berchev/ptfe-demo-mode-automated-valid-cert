# ptfe-demo-mode-tls-automated
The repo is just an example how to perform TFE version 4 automated
- local instalation 
- restore from snapshot

We are going to use vagrant in order to create appropriate development environment for that.
Our VM configuration include:
- private IP address (192.168.56.33) 
- /dev/mapper/vagrant--vg-root 83GB
- /dev/mapper/vagrant--vg-var_lib 113G

## Repo Content
| File                   | Description                      |
|         ---            |                ---               |
| [Vagrantfile](Vagrantfile) | Vagrant template file. TFE env is going to be cretated based on that file|
| [delete_all.sh](delete_all.sh) | Purpose of this script is to break our environment. We will use it during snapshot restore|
|[scripts/provision.sh](scripts/provision.sh)| depends on some checks, this script will perform TFE install or restore|
|[conf/replicated.conf](conf/replicated.conf)| replicated configuration file, needed for the TFE install|


## Requirements
Please make sure you have fullfilled the reqirements before continue further:
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads) installed
- Hashicorp [Vagrant](https://www.vagrantup.com/) installed
- [Basic Vagrant skills](https://www.vagrantup.com/intro/getting-started/) 
- Perform [TFE manual tls instalation](https://github.com/berchev/ptfe-demo-mode-tls)
  - once installation is performed, ssh to ptfe vagrant box
  ```
  vagrant ssh
  ```
  - change to /vagrant directory (the directory synced with your host machine)
  ```
  cd /vagrant
  ```
  - extract the configuration of Terraform Enterprise application in JSON format
  ```
  replicatedctl app-config export > settings.json
  ```
- Into `sensitive` folder you need to place
  - settings.json file which you just extracted.
  - PTFE license, `.rli` file (You can contact Sales Team of HashiCorp - sales@hashicorp.com in order to purchase one)
  - your own SSL/TLS certificates - In case you do not have such, you can generate for free using [Let's encrypt](https://letsencrypt.org/) 
    - fullchain.pem
    - privkey.pem
- Make sure, that you will edit [conf/replicated.conf](conf/replicated.conf) fille according to your needs (adjust domain, password and files pointing to `sensitive` directory)

## Getting started
- Clone this repo locally
```
git clone https://github.com/berchev/ptfe-demo-mode-tls-automated
```
- Change into downloaded repo directory
```
cd ptfe-demo-mode-tls-automated
```

## PTFE version 4 automated install
- Start provision vagrant development environment (during VM provision, provision.sh script will perform automated install of TFE)
```
vagrant up
```
- at some point you will see, on your console, continuous output like this one:
```
default: Initializing... please wait!
default: Initializing... please wait!
default: Initializing... please wait!
```
- It means that replicated is already installed, and now TFE application itself is installing. You can monitor the process in your browser. Please type the following:
```
http://192.168.56.33
```
- You will see the following:
![](https://github.com/berchev/ptfe-demo-mode-tls-automated/blob/master/screenshots/1.png)

- After a while, you will see password prompt. Enter your password.
![](https://github.com/berchev/ptfe-demo-mode-tls-automated/blob/master/screenshots/2.png)

- Then click on `Dashboard` button and you will see current installation progress
![](https://github.com/berchev/ptfe-demo-mode-tls-automated/blob/master/screenshots/5.png)

- Once installation finish, you will see this screen
![](https://github.com/berchev/ptfe-demo-mode-tls-automated/blob/master/screenshots/6.png)

- We can check that everything is working fine, typing the TFE FQDN in the browser:
![](https://github.com/berchev/ptfe-demo-mode-tls-automated/blob/master/screenshots/7.png)

## TFE version 4 restore from snapshot
- Now we need to create snapshot. For this purpose, click on `Start Snapshot` button
![](https://github.com/berchev/ptfe-demo-mode-tls-automated/blob/master/screenshots/6.png)

- Wait the process to complete 
- ssh to vagrant VM 
```
vagrant ssh
```
- become root
```
sudo su -
```
- Brake your ptfe instance using `delete_all.sh`
```
bash /vagrant/delete_all.sh
```
- exit from ptfe VM shell. Need to type the command twice:
```
exit
```
- From your host machine execute following command in order to start the snapshot restore:
```
vagrant provision
```
- Now the script will detect that you have snapshot, and will perform restore from it. Into the console you will see:
```
default: Operator installation successful
default: To continue the installation, visit the following URL in your browser:
default: 
default:   http://192.168.56.33:8800
default: Restoring snapshot...
default: Loading app version info...
default: Waiting for all nodes to connect...
default: Restoring nodes...
default: Starting application...
default: Initializing... please wait!
default: Initializing... please wait!
```
- Again, you can monitor the process in your browser:
```
http://192.168.56.33
```
