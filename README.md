# Scripts
Scripts for simplifying the deployment of AWS Lightsail Instances

### addvhost.sh
---
Purpose: \
Creates a root relative to ~/www/ for a placeholder file, then adds a vHosts file using the template found in vhost.skeleton.conf

It also uses certbot to attempt to generate a certificate of the same domain name and install said certificate within the skeleton file

Usage: \
`sudo ~/scripts/addvhost.sh -u newsite.local -d relative/root`


### reclone.sh
---
Purpose: \
Clears and clones this repository into ~/scripts, executing any initalising scripts

Usage: \
`source ~/scripts/reclone.sh`

### clearvhosts.sh
---
Purpose: \
Clears vhosts from the system, removing any ssh cert configs etc

Usage: \
`source ~/scripts/clearvhosts.sh`

### installCertbot.sh
---
Purpose: \
Installs Certbot on a blank system preparing for SSL Config

Usage: \
`source ~/scripts/installCertbot.sh`

