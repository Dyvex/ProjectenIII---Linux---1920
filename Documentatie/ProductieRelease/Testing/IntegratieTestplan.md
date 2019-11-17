# Integratie testplan week 9
## Requirements
  * De gehele opstelling werd volledig geautomatiseerd via ansible.
  * Elke server heeft een administrator account voor beheer vanop afstand.
  * Elke server heeft zijn correct IP adres meegekregen via de DHCP server.
  * Elk component in het netwerk stuurt zijn informatie over de eigen werking naar het monitoringsysteem.
  * Alle servers worden eerst intern gecontroleerd met een intern testplan van het team dat verschilt t.o.v. het integratie testplan.
  * De hostsystemen moeten voldoen aan volgende eigenschappen:
      * Volgende package moeten aanwezig zijn:
          * touch
          * nano
          * vim
          * bash auto completion
          * net-tools
          * curl
      * Client PC's hebben geen eigen gebruikers, authenticatie gebeurt via de domain server.  
      * Client PC's kunnen op het internet.
      * Client PC's kunnen mails versturen en ontvangen.
      * Client PC's hebben een home folder door de file server.

## A priori
* Het netwerk is volledig opgesteld door het netwerk team.
* Alle servers zijn geïnitialiseerd en zijn up and running.
    * Dit kan je controleren met het commando:
      ``` bash
      vagrant status
      ```
    * Dit ziet er als volgt uit:
```
/// te doen maandag
```
* Alle apparaten zijn voorzien van het juiste IP adres.
    * Voor servers kan je dit controleren via het commando:
    ``` bash
        ip a of ifconfig
    ```
    * Voor routers en switches kan je dit controleren via het commando:
    ``` bash
        show ip interface brief
    ```

## Stappenplan
#### 1. Netwerk & server opstellen (R&S & Productie-omgeving)
###### Router0
* [ ] Test indien de hostsnaam gelijk is aan **Router0**.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
          show running-config
     ```
* [ ] Controleer
#### 2. Kilo1 (DHCP)
* [ ] Controleer of de server(interface eth1) het IP adres ***172.16.1.1*** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip address show eth1
     ```
* [ ] Controleer of de eerste entry **default via 172.16.1.62 dev eth1** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip route show
     ```
* [ ] Verifeer of je kunt pingen naar het IP adres **172.16.1.62**.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ping 172.16.1.62
     ```
* [ ] Verifeer of je kunt pingen naar het IP adres **172.16.1.94**.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ping 172.16.1.94
     ```
* [ ] Controleer of de dhcpd service 'active (running)' is.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         sudo systemctl status dhcpd
     ```

###### DHCP scope voor VLAN 50
**Opmerking:** Bravo1 kan vervangen worden door eender welke server in VLAN 50 met fixed IP.
* pre-task: Verbind via Secure shell met Bravo1.
* [ ] Controleer of de server(interface eth1) het IP adres ***172.16.1.66/27*** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip address show eth1
     ```  
* [ ] Controleer of de eerste entry **default via 172.16.1.94** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip route show
     ```
* [ ] Test indien resolv.conf de DNS entrys bevat(172.16.1.66 en 172.16.1.67) en alsook het search domain green.local.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         cat /etc/resolv.conf
     ```
​
###### kilo1 DHCP scope voor VLAN 30 testen
**Opmerking:** Lima1 kan vervangen worden door eender welke server in VLAN 30 met fixed IP.
* pre-task: Verbind via Secure shell met Lima1.
* [ ] Controleer of de server(interface eth1) het IP adres ***172.16.1.2/27*** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip address show eth1
     ```
* [ ] Controleer of de eerste entry **default via 172.16.1.62** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
          ip route show
     ```
* [ ] Test indien resolv.conf de DNS entrys bevat(172.16.1.66 en 172.16.1.67) en alsook het search domain green.local.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
          cat /etc/resolv.conf
     ```
###### kilo1 DHCP scope voor VLAN 20 testen
* pre-task: Verbind via Secure shell met een host uit VLAN 20.
* [ ] Controleer of de host een IP adres bevat dat binnen in de range '172.16.0.10 - 172.16.0.253' ligt.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip address show eth1
     ```
* [ ] Controleer of de eerste entry **default via 172.16.1.62** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip route show
     ```
* [ ] Test indien resolv.conf de DNS entrys bevat(172.16.1.66 en 172.16.1.67) en alsook het search domain green.local.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         cat /etc/resolv.conf
     ```
#### 3. Alfa1 (Domeinserver)
* [ ] Controleer of de server(interface eth1) het IP adres ***172.16.1.65/27*** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip address show eth1
     ```
* [ ] Verifieer dat service **slapd** actief is.
    *  Gebruik onderstaand commando om de status van de service te bekijken.
    ``` bash
        systemctl status slapd
    ```
* [ ] Controleer of we de server via localhost kunnen bereiken.
    * Gebruik onderstaand commando om een query naar alle entries op de server via localhost uit te voeren.
    ``` bash
        ldapsearch -x -LLL
    ```
* [ ] Test met het vorige commando om de onderstaande gebruikers en groepen terug te vinden.
    * [ ] Groepen:
        * IT_Administratie
        * Verkoop
        * Administratie
        * Ontwikkeling
        * Directie
    * [ ] Gebruikers:
        * Milan Dewilde
#### 4. Bravo1 (DNS)
* [ ] Controleer of de server(interface eth1) het IP adres ***172.16.1.66/27*** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip address show eth1
     ```
* [ ] Check of de named service (naam van de bind applicatie op CentOS) actief is.
  * Controleer met onderstaand commando:
  ``` bash
      sudo systemctl status named
  ```
* [ ] Test indien het versturen van dns query mogelijks is.

    Note: In de live productie omgeving worden alle dns-requests eerst naar quebec 1 verstuurd en vervolgens naar bravo1/charlie1 indien de bestemming zich in green.local bevindt. Om bravo1 of charlie1 individueel te testen moet je met vi met root rechten bestand /etc/resolv.conf aanpassen en de nameserver verwijzen naar 172.16.1.66.

    * Gebruik onderstaand commando om dit te controleren:
    ``` bash
        nslookup alpha1.green.local
    ```
* [ ] Controleer indien reverse lookup mogelijk is.
  * Controleer met onderstaand commando:
  ``` bash
      nslookup 172.16.1.65
  ```
* [ ] Controleer of server enkel reageert op request vanuit de 172.16/16 netwerk.
    Note: Indien stap 2 en 3 succesvol verliep betekent dit dat uw host zich in het bovenvermelde netwerk bevindt. U kan dit verifiëren met het "ip a" commando.
    Pas het ip adres, bijvoorbeeld op uw fysieke apparaat aan naar 192.168.0.x (getal naar keuze zolang dit niet in conflict komt met een ander apparaat op uw netwerk). Test de nslookup commando opnieuw. Deze keer zou deze moeten mislopen

    * Gebruik onderstaand commando om dit te controleren:
    ``` bash
        nslookup alpha1.green.local
    ```
#### 5. Charlie1 (DNS)
* [ ] Controleer of de server(interface eth1) het IP adres ***172.16.1.67/27*** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip address show eth1
     ```
* [ ] Check of de named service (naam van de bind applicatie op CentOS) actief is.
  * Controleer met onderstaand commando:
  ``` bash
      sudo systemctl status named
  ```
* [ ] Test indien het versturen van dns query mogelijks is.

    Note: In de live productie omgeving worden alle dns-requests eerst naar quebec 1 verstuurd en vervolgens naar bravo1/charlie1 indien de bestemming zich in green.local bevindt. Om bravo1 of charlie1 individueel te testen moet je met vi met root rechten bestand /etc/resolv.conf aanpassen en de nameserver verwijzen naar 172.16.1.67.

    * Gebruik onderstaand commando om dit te controleren:
    ``` bash
        nslookup alpha1.green.local 172.16.1.67
    ```
* [ ] Controleer of reverse lookup mogelijk is.
  * Controleer met onderstaand commando:
  ``` bash
      nslookup 172.16.1.65 172.16.1.67
  ```
* [ ] Controleer of server enkel reageert op request vanuit de 172.16.0.0/16 netwerk

    Note: Indien stap 2 en 3 succesvol verliep betekent dit dat uw host zich in het bovenvermelde netwerk bevindt. U kan dit verifiëren met het "ip a" commando.
    Pas het ip adres, bijvoorbeeld op uw fysieke apparaat aan naar 192.168.0.x (getal naar keuze zolang dit niet in conflict komt met een ander apparaat op uw netwerk). **Test de nslookup commando opnieuw. Deze keer zou deze moeten mislopen**
    * Gebruik onderstaand commando om dit te controleren:
    ``` bash
        nslookup alpha1.green.local 172.16.1.67
    ```
#### 6. Oscar1 (Monitoring-systeem)
* [ ] Controleer of de server(interface eth1) het IP adres ***172.16.1.5/26*** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip address show eth1
     ```
###### Promotheus website
* [ ] Verifieer of de Prometheus website bereikbaar en zichtbaar is.
  * Surf naar '172.16.1.5:9090' om de Prometheus website te bereiken.
* [ ] Controleer of alle servers actief zijn.
  * Ga naar *Status > Targets* om dit te controleren.
    * Alle servers moet onder het hoofding *Prometheus* als **state** *up* hebben in de tabel.
    * Alle routers, switches en firewalls moeten onder de hoofding *SNMP* als **state** *up* hebben.
###### Grafana dashboards
* [ ] Verifieer of de Grafana website bereikbaar en zichtbaar is.
  * Surf naar '172.16.1.5:3000' om de Prometheus website te bereiken.
* [ ] Test indien je op deze website met volgende gegevens kunt aanmelden:
    - **Gebruikersnaam**: admin
    - **Wachtwoord**: oscar1
###### Node Exporter Server Metrics Dashboard
* [ ] Toets indien je nergens de foutmelding *No data* krijgt.
    * Ga naar *Home (linksboven) > Node Exporter Server Metrics*.
    * Selecteer de gewenste servers bij *Node* (linksboven).
    * Verander de tijd (*rechtsboven*) van *Last 7 days* naar *Last 5 minutes*
    * Krijg je nergens de foutmelding *No Data*?
###### Node Exporter Full Dashboard
* [ ] Toets indien je nergens de foutmelding *No data* krijgt.
    * Selecteer het dashboard *Node Exporter Full* (Links bovenaan, waar *Node Exporter Server Metrics*)
    * Kies de gewenste server bij *Host* (linksboven).
    * Verander de tijd (*rechtsboven*) van *Last 7 days* naar *Last 5 minutes*.
    * Krijg je nergens de foutmelding *No Data*?
###### SNMP Interface Througput Dashboard
* [ ] Toets indien je nergens de foutmelding *No data* krijgt.
    * Selecteer het dashboard *SNMP Interface Throughput* (Links bovenaan, waar *Node Exporter Server Metrics*)
    * Kies de gewenste server bij *Host* (linksboven)
    * Verander de tijd (*rechtsboven*) van *Last 7 days* naar *Last 5 minutes*
    * Krijg je nergens de foutmelding *No Data*?

#### 7. Papa1 (PXEBoot-server)
* [ ] Controleer of de server(interface eth1) het IP adres ***172.16.1.6/26*** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip address show eth1
     ```
###### Services
* [ ] Controleer indien de service *nginx* actief is.
    * Gebruik onderstaand commando om dit te controleren.
    ``` bash
        systemctl status nginx
    ```
* [ ] Controleer indien de service *xinetd* actief is.
    * Gebruik onderstaand commando om dit te controleren.
    ``` bash
        systemctl status xinetd
    ```
###### Mounts
* [ ] Verifiëer dat de ISO files correct gemount zijn.
    * Gebruik onderstaand commando om dit te controleren.
    ``` bash
        cat /proc/mounts | grep /var/www/html
    ```
    * De uitvoer moet als volgt zijn:
    ```
        /dev/loop0 /var/www/html/centos8 iso9660 ro,relatime 0 0
        /dev/loop1 /var/www/html/fedora iso9660 ro,relatime 0 0
    ```
###### Connectiviteit met nieuwe vm's
  * [ ] Werkstation moet booten met als eerste bootoptie "boot via network".
  * [ ] Het blauw scherm moet zichtbaar worden met opties voor CentOS8 en Fedora Workstation.
  * [ ] Bij het kiezen van de CentOS8 optie worden de installatie files gemount en begint de installatie van de OS. Dit gebeurd zonder foutmeldingen.
  * [ ] Bij het kiezen van de Fedora optie worden de correcte files gemount en begint de installatie van de OS. Dit gebeurd zonder foutmeldingen.
  * [ ] De hosts werd geboot zonder enige foutmeldingen.

&rarr; De hosts geboot & geïnstalleerd adhv de PXEboot server worden apart getest adhv test files. Deze bevinden zich buiten het algemeen testplan.
#### 7. Quebec1 (Forwarding DNS)
* [ ] Controleer of de server(interface eth1) het IP adres ***172.16.1.70/27*** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip address show eth1
     ```
* [ ] Onderzoek of de FQDN(Fully Qualified Domain Name) is ingesteld op quebec1.green.local?
  * Gebruik onderstaand commando om dit te controleren.
   ``` bash
       hostname
   ```

###### NSLookups Testen
* [ ] Controleer NSLookups van de servers overeenkomen met onderstaand tabel.
  * Gebruik onderstaand commando om dit te controleren.
   ``` bash
       nslookup alfa1
   ```
**Opmerking:** Pas steeds de servergeving aan voor de juiste server.

| Naam       | VLAN    | IP-adres                         |
| :--------- | :------ | :------------------------------- |
| Alfa1      | VLAN 50 | 172.16.1.65                      |
| Bravo1     | VLAN 50 | 172.16.1.66                      |
| Charlie1   | VLAN 50 | 172.16.1.67                      |   
| Delta1     | VLAN 50 | 172.16.1.68                      |    
| Echo1      | VLAN 50 | 172.16.1.69                      |   
| Quebec1    | VLAN 50 | 172.16.1.70                      |  
| Kilo1      | VLAN 30 | 172.16.1.1                       |   
| Lima1      | VLAN 30 | 172.16.1.2                       |    
| Mike1      | VLAN 30 | 172.16.1.3                       |   
| November1  | VLAN 30 | 172.16.1.4                       |    
| Oscar1     | VLAN 30 | 172.16.1.5                       |    
| Papa1      | VLAN 30 | 172.16.1.6                       |
| www.hogent.be | / | ??? |

#### 8. November1 (MariaDB)
* [ ] Controleer of de server(interface eth1) het IP adres ***172.16.1.4/26*** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip address show eth1
     ```
* [ ] Controleer of de MariaDB service gestart is bij de boot.
    * sudo systemctl status mariadb
* [ ] Verifeer of de MariaDB service 'Actief' is.
    * sudo systemctl status mariadb
* [ ] Toets of de databanken 'drupal_echo1' en 'drupal_mike1' bestaan.
    * mysql -uroot -p${mariadb_root_password} --execute 'show databases'*
    * mysql -uroot -p${mariadb_root_password} --execute 'show tables'*
* [ ] Onderzoek of gebruikers 'mike1_user' en 'echo1_user' schrijfrechten voor de aangewezen databanken.
    * mysql -u${mike1_user} -pmike1 \ --execute 'CREATE TABLE a (id int); DROP TABLE a;*
* [ ] Inspecteer dat MariaDB geen testdatabank en anonieme gebruikers meer heeft.
    * run mysql -uroot -p${mariadb_root_password} --execute 'show databases' test [ "0" -ne "${status}" ]*
    * sudo systemctl list-units --type service*
    * result=$(mysql -uroot -p${mariadb_root_password} --execute "select * from user where user='';" mysql) [ -z "${result}" ]
#### 9. Echo1 (Webserver)
* [ ] Controleer of de server(interface eth1) het IP adres ***172.16.1.69/27*** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip address show eth1
     ```
###### Test toegangelijkheid
* [ ] Controleer indien www.green.local(of 172.16.1.69) in de browser een webpagina toont.
    * Opmerking: dns records voor www.green.local zijn vereist

###### Test https
* [ ] Controleer indien https actief is.
  * Ga naar https://www.green.local
    * Expected: https werkt en u krijgt een webpagina te zien
* [ ] Controleer of je van **http://www.green.local** geredirect wordt naar **https://www.green.local**.
    * Expected: http://www.green.local wordt geredirect naar https://www.green.local
###### Test Drupal
**--> niet ontvangen groep echo1**

#### 10. Mike1 (Content management systeem) AFWERKEN
* [ ] Controleer of de server(interface eth1) het IP adres ***172.16.1.3/26*** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip address show eth1
     ```
**--> niet ontvangen groep echo1**
#### 11. Lima1 (Interne file-server)
* [ ] Controleer of de server(interface eth1) het IP adres ***172.16.1.2/26*** bevat.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         ip address show eth1
     ```
###### LDAP Client
* [ ] Controleer of we de server via localhost kunnen bereiken.
    * Gebruik onderstaand commando om een query naar alle entries op de server via localhost uit te voeren.
     ``` bash
         ldapsearch -x -LLL
     ```
* [ ] Controleer met vorige commando om de onderstaande gebruikers en groepen terug te vinden.
   * [ ] Groepen:
        * IT_Administratie
        * Verkoop
        * Administratie
        * Ontwikkeling
        * Directie
   * [ ] Gebruikers:
        * Milan Dewilde
* [ ] Controleer indien de gebruiker 'milan' werd aangemaakt als systeemgebruiker.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         getent passwd
     ```

###### Samba
* [ ] Test of volgende samba shares aangemaakt en beschikbaar zijn.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         smbclient -L //lima1/
     ```
 **Opmerking:** het wachtwoord is *vagrant*.
    * IT_Administratie
    * Verkoop
    * Administratie
    * Ontwikkeling
    * Directie

* [ ] Test of je met samba user 'Viktor' kan inloggen op de share 'IT_Administratie' waar hij WEL toegangsrechten op heeft.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         smbclient //lima1/IT_Administratie/ -UViktor%mno123!
     ```
 **Opmerking:** Indien je *smb: \>* te zien krijgt, betekend het dat je bent ingelogd op de IT_Administratie.

* [ ] Test of je met samba user 'Viktor' kan inloggen op de share 'Administratie' waar hij GEEN toegangsrechten op heeft.
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         smbclient //lima1/Administratie/ -UViktor%mno123!
     ```
 **Opmerking:**  Indien je *NT_STATUS_ACCESS_DENIED* te zien krijgt, betekend dit dat je geen toegang hebt tot Administratie.

* [ ] Test indien je kan inloggen als guest op de samba share 'Aministratie' (of 1 van de 4 andere).
    * Gebruik onderstaand commando om dit te controleren.
     ``` bash
         smbclient //lima1/Administratie -U%
     ```
 **Opmerking:**  Indien je *NT_STATUS_ACCESS_DENIED* te zien krijgt, betekend dit dat je als Guest geen toegang hebt tot Administratie.

* [ ] Controleer of alle onderstaand gebruikers aanwezig zijn op de server.
* Gebruik onderstaand commando om dit te controleren.
 ``` bash
     cat /etc/passwd
 ```
 * Gebruikers:
      * [ ] Robert
      * [ ] Els
      * [ ] Thomas
      * [ ] Noah
      * [ ] Emma
      * [ ] Louise
      * [ ] Marie
      * [ ] Lucas
      * [ ] Viktor
      * [ ] Sarah
      * [ ] Jade
      * [ ] Lars

#### 12. Delta1 (Mailserver)
**Opmerking:** Het testplan wordt gecontroleerd via het testscript dat is opgesteld door het team.
* [ ] Volgende elementen worden gecontroleerd via het testscript.
    * IP adres is **172.16.1.68/27**
    * Controle op default gateway
    * Controle op firewall instellingen.
* [ ] Test indien het webportaal en mailbox bereikbaar is.
  * Surf naar http://172.16.1.68/webmail om dit te testen.
  * Log in met volgende gegevens:
  ``` bash
      Name: johndoe
      Password: test123
  ```
* [ ] Verifeer indien je een mail kunt versturen BINNEN het domain.
  * Selecteer "Compose" bovenaan de webpagina en voer volgende gegevens in:
  ``` bash
      To: ericdoe@green.local
      Subject: anytesttexthere
      Message: Testtext in textarea from johndoe@green.local
  ```
  * Selecteer "Sent" om de mail te versturen.
* [ ] Verifeer indien je een mail kunt versturen BUITEN het domain.
   * Selecteer "Compose" bovenaan de webpagina en voer volgende gegevens in:
   ``` bash
       To: ericdoe@red.local
       Subject: anytesttexthere
       Message: Testtext in textarea from johndoe@green.local
   ```
  * Selecteer "Sent" om de mail te versturen.

* [ ] Controleer of je de mail hebt ontvangen van johndoe BINNEN het domein.
  * Log in met volgende gegevens:
  ``` bash
      Name: ericdoe
      Password: test123
  ```
  * De mail van "johndoe@green.local" moet aanwezig zijn.

* [ ] Controleer of je de mail hebt ontvangen van ??? BUITEN het domein.
  * Log in met volgende gegevens:
  ``` bash
      Name: johndoe
      Password: test123
  ```
  * De mail van "??@red.local" moet aanwezig zijn.

#### 13. Zulu1 (firewall)
* [ ] Controleer of deze correct ingesteld zijn.
	* WAN: 192.168.1.106/30
  * LAN: 192.168.1.102/30

* [ ] Controleer of de daemon services aan staan.
  * Kies voor services in de navigatiebalk en druk op SNMP in het dropdown menu.
	* De services staan aan, met polling port 161.

* [ ] Controleer of de juiste roles/aliases aanwezig zijn.
	* Kies voor firewall in de navigatiebalk en druk op aliases in het dropdown menu.
	* De volgende aliases moeten bestaan:
		* HTTPandHTTPS
			* Poort 80 & 443
		* IMAPandIMAPS
			* Poort 143 & 993
		* POPandPOPS
			* Poort 110 & 995

* [ ] Controleer of service DHCP is uitgeschakeld
	* Kies voor services in de navigatiebalk en druk op DHCP Server in het dropdown menu
	* Enable DHCP is niet aangeduid

* [ ] Controleer of IPv6 is uitgeschakeld
	* Kies voor system in de navigatiebalk, druk op advanced in het dropdown menu en druk vervolgens op networking
	* Allow IPv6 is niet aangeduid

* [ ] Ping van een interne host naar de interface van de Pfsense firewall.
	* Gebruik je commandline en ping naar:
		* WAN: 192.168.1.106/30
		* LAN: 192.168.1.102/30
  * Dit moet normaal gezien slagen.

* [ ] Ping van een interne host naar een externe interface.
	* Gebruik je commandline en ping naar:
		* IP adres: ???
  * Dit moet normaal gezien slagen.

* [ ] Ping van een externe hosts naar een intern device.
	* Gebruik je commandline en ping naar:
		* IP adres: 172.16.1.2
  * Dit moet normaal gezien falen.

* [ ] Ping van een externe hosts naar de Webserver.
	* Gebruik je commandline en ping naar:
		* IP adres: 172.16.1.69
  * Dit moet normaal gezien slagen.

#### 14. HOSTS
* [ ] Controleer indien je kan inloggen met een gebruiker van het domain.
  * Log in met volgende gegevens:
  ``` bash
      Name: ??
      Password: ??
  ```  
* [ ] Test of de host een IP adres heeft gekregen in het netwerk 172.16.0.0/24.
  * Gebruik onderstaand commando om dit te testen.
  ``` bash
      ip a
      ifconfig
  ```
* [ ] Verifeer installatie van volgende packages:
    * Gebruik onderstaand commando om dit te verifiëren.
    ``` bash
        dpkg -s 'package naam'
    ```
      * touch
      * nano
      * vim
      * bash auto completion
      * net-tools
      * curl
* [ ] Controleer indien je met de client PC op het internet kunt.
* [ ] Controleer indien je mails kunt versturen en ontvangen met de client pc.
* [ ] Controleer indien je kunt server naar https://www.green.local/  
* [ ] Controleer of de home folder zichtbaar is.
* [ ] ...

#### Opgesteld door Olivier Troch en Joeri Verhavert
