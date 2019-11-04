# Documentatie

## To Do

- [x] Zoeken naar goede ansible role
- [x] Prometheus laten draaien op server `oscar1`
- [ ] Prometheus op anders servers installeren
- [ ] Prometheus queries schrijven
- [ ] Zorgen dat andere servers naar prometheus rapporteren
- [ ] Querying zodat juiste informatie wordt getoond
- [x] Installatie *Grafana* met ansible
- [ ] Zorgen dat alles correct wordt weergegeven op grafana

## Notes to Stijn

> Bij testen zorgen dat je andere servers in `ansible/servers.yml` in commentaar zet. Deze gaven bij mij soms foutmeldingen omdat er dingen bij hen nog niet werken.
>
> Installatie lukt bij mij, zie [output](commandoutput.txt).
>
> Pingen naar het ip-adres van oscar1 (`172.16.1.5`), gaat zonder problemen, maar als ik `172.16.1.5:9100`(!1) probeer te openen in Firefox, dan lukt dit niet. Dit al geprbeerd maar werkte niet:
>
> * Firewallregel toevoegen met http en https (`sudo firewall-cmd --add-service http`)
> * Log over prometheus nog niet gevonden, als je dit googled krijg je resultaten van hoe logs er in importeren of hoe de logs bekijken als het draait op docker
>
> Weet dus niet zeker als prometheus al draait op het systeem. Configuratiebestanden (`/etc/prometheus/*`) kan ik wel bekijken op de vm.
> 
> !1: deze poort staat ingesteld in [server.yml](/ansible/servers.yml)

## Notes to Maarten

> De prometheus server is bereikbaar via `172.16.1.5:9090`
> Grafana is geinstalleerd, bereikbaar via `172.16.1.5:3000`
>   Grafana username: `admin`
>   Grafana password: `oscar1`
> Het viel mij op dat standaard Firewalld is uitgeschakeld bij het opstarten van de server

## Stappenplan opzetten

1. `vagrant up oscar1`

## Stappenplan enkele server

1. Installeer prometheus-role van [Ansible Galaxy](https://galaxy.ansible.com/cloudalchemy/prometheus):

```bash
ansible-galaxy install cloudalchemy.prometheus
```

2. Vul het playbook aan met volgende code

```yml
---
- hosts: oscar1
  become: true
  gather_facts: yes
  roles:
  - cloudalchemy.prometheus
  - cloudalchemy.grafana
  - cloudalchemy.node-exporter
```

3. Maak het bestand `ansible/host_vars/oscar1.yml` aan en voeg volgende code toe.  

Functionaliteit code:
* Prometheus targets toevoegen (apparaten die gemonitored moeten worden)
* Grafana credentials instellen
* Grafana datasource instellen
* Grafana dashboard downloaden

``` yml
---
prometheus_targets:
  node:
  - targets:
    - 172.16.1.5:9100
    labels:
      env: Oscar1
grafana_security:
  admin_user: admin
  admin_password: oscar1
grafana_datasources:
  - name: "prometheus"
    type: "prometheus"
    access: proxy
    url: 'http://localhost:9090'
    basicAuth: false
grafana_dashboards:
  - dashboard_id: 10645
    revision_id: 1
    datasource: 'prometheus'
```

4. Voeg aan alle servers in het bestand `ansible/servers.yml` de rol cloudalchemy.node-exporter toe.

## Bekijken van de grafieken met grafana

1. Surf naar 172.16.1.5:3000
2. Login met gebruikersnaam `admin` en wachtwoord `oscar1`
3. Klik linksboven op home
4. Selecteer het enige dashboard in de lijst
5. Bekijk de grafieken

## Status Monitoring verschillende linux servers

|  Server   | Monitoring status                         |
| :-------: | ----------------------------------------- |
|   Alfa1   | Success                                   |
|  Bravo1   | Success                                   |
| Charlie1  | Success                                   |
|  Delta1   | Success --> mits toevoegen firewall regel |
|   Echo1   | Success                                   |
|   Kilo1   | Success                                   |
|   Lima1   | Success                                   |
|   Mike1   | Success                                   |
| November1 | Success                                   |
|  Oscar1   | Success                                   |
|   Papa1   | success                                   |
|   Zulu1   | Failed --> Server nog niet aangemaakt     |

## Troubleshooting

### Grafana: No data

Indien op het grafana dashboard bij bepaalde zaken staat "No data" kan je rechtsboven de timespan van de grafieken aanpassen, standaard staat dit op zeven dagen. Indien de server nog maar net is opgestart heeft hij nog geen 7 dagen oude data. Selecteer dan bv.: laatste 5 minuten

## Geen servers bereikbaar

De oscar1 server maakt gebruik van de DNS-server bravo1 om de hostnamen (alfa1,bravo1,...) om te zetten naar IP-addressen.  
 Indien er geen verbinding kan gemaakt worden met de DNS-server bravo1, dan zal prometheus geen verbinding kunnen maken met de andere servers.  
Zorg er dus altijd voor dat de prometheus server connectie heeft met de server DNS-server.
