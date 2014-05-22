.. _ideas:

Some First Ideas
================

Hieronder wat eerste ideeën.


Project naam
------------

SensorPlus of bestaat er al iets? Denk ``SOSPilot``

Support Technologie
-------------------


#. website sensors.geonovum.nl: simpele Bootstrap HTML met info + links naar bijv. 52N Client en andere demo’s, documentatie etc
#. code en doc: GitHub: account Geonovum?, in ieder geval waar we beiden direct op kunnen committen ipv via PRs?  *DONE*
#. documentatie: Sphynx+ReadTheDocs, gebruik bij bijv Stetl en OGG: http://stetl.org, werkt via GH Post Commit, dus bij iedere commit is docu weer synced en online en er is export naar PDF *DONE*
#. ETL: Python, GDAL, SQL, evt Stetl?
#. website: sensors.geonovum.nl, simpele Bootstrap site, auto deploy via: https://gist.github.com/oodavid/1809044

Inrichten Linux Server
----------------------

* algemeen: stappen doc http://docs.kademo.nl/project/geolinuxserver.html
* apart admin account die minder rechten heeft als root maar wel Tomcat/ETL etc kan runnen
* backup: inrichten (met CloudVPS backupserver en script)

ETL Opzet
---------

Denk 3 ETL stappen met 3 stores:

#. Harvesten van brondata uit http://geluid.rivm.nl/sos/ op in DB als XML Blobs met filenaam en start/eind tijd kolom
#. lokale brondata naar intermediate “core” DB: in principe 2 tabellen nodig: Stations en Metingen, 1:1 overzetten uit XML
#. “Core DB” naar 52N SOS DB, evt later naar IPR/INSPIRE XML


.. figure:: _static/sospilot-arch1.jpg
   :align: center

   *Figure 1 - Overall Architecture*

De pijlen geven de dataflow weer. Processen zijn cirkels. De flow is als volgt:

#. De File Harvester haalt steeds XML files met AQ/LML metingen op van de RIVM server
#. De File Harvester stopt deze files als XML blobs 1-1 in de database, met filenaam+datum kolommen
#. Het AQ ETL proces leest steeds de file blobs uit de Raw File Data DB en zet deze om naar een Core AQ DB
#. De Core AQ DB bevat de metingen + stations in reguliere tabellen 1-1 met de oorspronkelijke data, met ook Time kolommen
#. De Core AQ DB kan gebruikt worden om OWS (WMS/WFS) services via GeoServer te bieden
#. Het SOS ETL proces zet de core AQ data om naar de 52North SOS DB schema of evt via REST publicatie (TODO)
#. De drie processen (File Harvester, AQ ETL en SOS ETL) bewaren steeds  een "last ETL time" timestamp waardoor ze op elk moment "weten waar ze zijn" en kunnen hervatten

Deze opzet is vergelijkbaar met die van BAG in PDOK, daar vinden de volgende stappen plaats:

#. BAG XML downloaden (via Atom).
#. BAG XML inlezen 1:1 model, in Core BAG DB.
#. Vanaf Core BAG DB transformatie naar andere formats/DBs: GeoCoder, INSPIRE AD, BagViewer etc.

De 3 ETL-processen (bijv via cron) houden steeds hun laatste sync-time bij in DB.

Voordelen van deze opzet:

* backups van de brondata mogelijk
* bij wijzigingen/fouten altijd de “tijd terugzetten” en opnieuw draaien
* simpeler ETL scripts dan “alles-in-1", bijv van “Core AQ DB” naar "52N SOS DB" kan evt in SQL
* migratie bij wijzigingen 52N SOS DB schema simpeler
* voorbereid op IPR/INSPIRE ETL (bron is dan Core OM DB)
* OWS server (WMS/WFS evt WCS)  aansluiten op Core OM DB (via VIEW evt, zie onder)

OWS Inrichting
--------------

GeoServer draait reeds op http://sensors.geonovum.nl/gs

* GeoServer (?, handig bijv voor WMS-T en brede WFS en INSPIRE support)
* Met een VIEW op de “Core OM DB” kan een DB voor WMS(-Time) / WFS evt WCS ingeregeld (join tabel op stations/metingen).

OWS Client
----------


* WFS Filter Client met Download: voorbeeld: http://lib.heron-mc.org/heron/latest/examples/multisearchcenternl/ (“Build your own searches” optie)
* TimeSlider (WMS-Time)  voorbeeld:  http://lib.heron-mc.org/heron/latest/examples/timeslider/ en http://www.eea.europa.eu/themes/air/interactive/pm10-interpolated-maps

SOS Inrichting
--------------

52N SOS draait reeds op http://sensors.geonovum.nl/sos

* 52N SOS server (Simon) inspire versie, zie action point
* DB in PG schema, niet in “public” (ivm backup/restore andere systemen)

SOS Client Inrichting
---------------------

* 52N (Simon) zie action point

