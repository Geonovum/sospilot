Sources for ETL of Smart Emission project Nijmegen.

Uses host-specific variables for databases, passwords etc.
To use define a file on your host called options-<your host>.sh
Take the example file options-sunda.sh for initial values and adapt to your host.

NB for now only raw files are processed, i.e. ETL Step 1 (Harvesting) is not yet performed.

Only ETL Steps 2 and 3.

Step 2: files2measurements: put files+stations in regular DB tables (DB sensors, schema: smartem)
Step 3: publish stationas and observations from tables in Step2 to SOS



