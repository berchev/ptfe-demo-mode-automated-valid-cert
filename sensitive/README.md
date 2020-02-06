## What is this folder for?
Into `sensitive` folder you need to place
  - settings.json file which you just extracted.
  - PTFE license, `.rli` file (You can contact Sales Team of HashiCorp - sales@hashicorp.com in order to purchase one)
  - your own SSL/TLS certificates - In case you do not have such, you can generate for free using [Let's encrypt](https://letsencrypt.org/) 
    - fullchain.pem
    - privkey.pem
- Make sure, that you will edit [conf/replicated.conf](conf/replicated.conf) fille according to your needs (adjust domain, password and files pointing to `sensitive` directory)
