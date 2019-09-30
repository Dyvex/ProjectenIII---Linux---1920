# Kilo1 Assignment


Een DHCP-server die de interne werkstations voorziet van correcte IP-configuratie:IP-adres (en netwerkmasker), default gateway en DNS service voor toegang zowelop het lokale netwerk als het Internet. Gekende werkstations krijgen een IP-adresgereserveerd op MAC-adres.

Optioneel: voorzie ook servers van een gereserveerd IP-adres, op basis van MAC-adres. Merk op dat de MAC-adressen in de test- en productie-omgeving verschil-lend zullen zijn, dus hou hier rekening mee.


Hosts die booten over het netwerk (PXEBoot), worden doorverwezen naar de PXE-Boot-server,papa1.