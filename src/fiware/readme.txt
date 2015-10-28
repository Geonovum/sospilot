FIWARE-related stuff

3/10/2015 - First Test

Goals
0- register at lab.fiware.org (justb4)
1- get connected to public services in Lab
2- basic Context Broker (Orion) interaction
3- publish temperatures to IDAS using UltraLight protocol
4- get temperatures from CB
5- show in Wirecloud Mashup

Rougly follow this article.
https://www.fiware.org/2014/06/18/connect-your-own-internet-of-things-to-fi-lab/

0- register at lab.fiware.org (justb4)
ok

1- get connected to public services in Lab

Generate token. Using script
https://raw.githubusercontent.com/fgalan/oauth2-example-orion-client/master/token_script.sh
(or Python script)



2- basic Context Broker (Orion) interaction
Manual:
https://fiware-orion.readthedocs.org/en/develop/index.html

FIGWAY
Use git submodule add  https://github.com/telefonicaid/fiware-figway
FIGWAY is an opensource tool to work with FIWARE Orion ContextBroker and/or FIWARE IDAS.2.6 (also known as SBC2.6).

The newest version is all under the "python-IDAS4/" folder and it is though to be used with the latest versions of IDAS (4.x). It is written in python

python CheckVersion.py
Traceback (most recent call last):
  File "CheckVersion.py", line 16, in <module>
    import requests, json
ImportError: No module named requests

pip install requests

# List all entities
python GetEntities.py ALL
sunda:ContextBroker just$ python GetEntities.py ALL
* Asking to http://130.206.80.40:1026/ngsi10/queryContext
* Headers: {'Fiware-Service': 'bus_auto', 'content-type': 'application/json', 'accept': 'application/json', 'X-Auth-Token': 'NULL'}
* Sending PAYLOAD:
{
    "entities": [
        {
            "type": "",
            "id": ".*",
            "isPattern": "true"
        }
    ],
    "attributes": []
}

...

* Status Code: 200
***** Number of Entity Types: 3

***** List of Entity Types
<entityId type="thing" isPattern="false"> : 3

**** Number of Entity IDs: 3

**** List of Entity IDs
<id>Temp- : 2
<id>1< : 1

Do you want me to print all Entities? (yes/no)yes
<queryContextResponse>
  <contextResponseList>
    <contextElementResponse>
      <contextElement>
        <entityId type="thing" isPattern="false">
          <id>1</id>
        </entityId>
        <contextAttributeList>
          <contextAttribute>
            <name>TimeInstant</name>
            <type>ISO8601</type>
            <contextValue>2015-09-24T11:57:15.616482Z</contextValue>
          </contextAttribute>
          <contextAttribute>
            <name>att_name</name>
            <type>string</type>
            <contextValue>value</contextValue>
            <metadata>
              <contextMetadata>
                <name>TimeInstant</name>
                <type>ISO8601</type>
                <value>2015-09-24T11:57:15.616892Z</value>
              </contextMetadata>
            </metadata>
          </contextAttribute>
        </contextAttributeList>
      </contextElement>
      <statusCode>
        <code>200</code>
        <reasonPhrase>OK</reasonPhrase>
      </statusCode>
    </contextElementResponse>
    <contextElementResponse>
      <contextElement>
        <entityId type="thing" isPattern="false">
          <id>Temp-Hird28001</id>
        </entityId>
        <contextAttributeList>
          <contextAttribute>
            <name>TimeInstant</name>
            <type>ISO8601</type>
            <contextValue>2015-10-02T10:10:22.180705Z</contextValue>
          </contextAttribute>
          <contextAttribute>
            <name>att_name</name>
            <type>string</type>
            <contextValue>value</contextValue>
            <metadata>
              <contextMetadata>
                <name>TimeInstant</name>
                <type>ISO8601</type>
                <value>2015-10-02T10:10:22.180910Z</value>
              </contextMetadata>
            </metadata>
          </contextAttribute>
        </contextAttributeList>
      </contextElement>
      <statusCode>
        <code>200</code>
        <reasonPhrase>OK</reasonPhrase>
      </statusCode>
    </contextElementResponse>
    <contextElementResponse>
      <contextElement>
        <entityId type="thing" isPattern="false">
          <id>Temp-Hird01</id>
        </entityId>
        <contextAttributeList>
          <contextAttribute>
            <name>TimeInstant</name>
            <type>ISO8601</type>
            <contextValue>2015-10-02T19:52:35.715150Z</contextValue>
          </contextAttribute>
          <contextAttribute>
            <name>att_name</name>
            <type>string</type>
            <contextValue>value</contextValue>
            <metadata>
              <contextMetadata>
                <name>TimeInstant</name>
                <type>ISO8601</type>
                <value>2015-10-02T19:52:35.715350Z</value>
              </contextMetadata>
            </metadata>
          </contextAttribute>
        </contextAttributeList>
      </contextElement>
      <statusCode>
        <code>200</code>
        <reasonPhrase>OK</reasonPhrase>
      </statusCode>
    </contextElementResponse>
  </contextResponseList>
</queryContextResponse>

To get an entity provide the ID only!

sunda:ContextBroker just$ python GetEntity.py 1
* Asking to http://130.206.80.40:1026/ngsi10/queryContext
* Headers: {'Fiware-Service': 'bus_auto', 'content-type': 'application/json', 'accept': 'application/json', 'X-Auth-Token': 'NULL'}
* Sending PAYLOAD:
{
    "entities": [
        {
            "type": "",
            "id": "1",
            "isPattern": "false"
        }
    ],
    "attributes": []
}

...

* Status Code: 200
* Response:
{
  "contextResponses" : [
    {
      "contextElement" : {
        "type" : "thing",
        "isPattern" : "false",
        "id" : "1",
        "attributes" : [
          {
            "name" : "TimeInstant",
            "type" : "ISO8601",
            "value" : "2015-09-24T11:57:15.616482Z"
          },
          {
            "name" : "att_name",
            "type" : "string",
            "value" : "value",
            "metadatas" : [
              {
                "name" : "TimeInstant",
                "type" : "ISO8601",
                "value" : "2015-09-24T11:57:15.616892Z"
              }
            ]
          }
        ]
      },
      "statusCode" : {
        "code" : "200",
        "reasonPhrase" : "OK"
      }
    }
  ]
}

# Update Entity Attribute Value
python UpdateEntityAttribute.py  Temp-Hird01 thing TimeInstant ISO8601 2015-10-03T15:02:35.715150Z


3- publish temperatures to IDAS using UltraLight protocol
See http://www.slideshare.net/FI-WARE/fiware-iotidasintroul20v2

Steps
- Create (IDAS) Service (not needed for public instance, use exiting
- Create Device
- Send Measurements
- Send Commands

sunda:Sensors_UL20 just$  python RegisterDevice.py SENSOR_TEMP NexusPro Temp-Otterlo

Create Device
{
 "devices": [
    { "device_id": "DEV_ID",
      "entity_name": "ENTITY_ID",
      "entity_type": "thing",
      "protocol": "PDI-IoTA-UltraLight",
      "timezone": "Europe/Madrid",
"attributes": [
        { "object_id": "t",
          "name": "temperature",
          "type": "int"
        } ],
 "static_attributes": [
        { "name": "att_name",
          "type": "string",
          "value": "value"
        }
       ]
      }
     ]
    }


sunda:Sensors_UL20 just$ python RegisterDevice.py SENSOR_TEMP NexusPro Temp-Otterlo
* opening: ./devices/SENSOR_TEMP
* Asking to http://130.206.80.40:5371/iot/devices
* Headers: {'Fiware-Service': 'bus_auto', 'content-type': 'application/json', 'Fiware-ServicePath': '/', 'X-Auth-Token': 'NULL'}
* Headers: {'Fiware-Service': 'bus_auto', 'content-type': 'application/json', 'Fiware-ServicePath': '/', 'X-Auth-Token': 'NULL'}
* Sending PAYLOAD:
{
    "devices": [
        {
            "protocol": "PDI-IoTA-UltraLight",
            "entity_name": "Temp-Otterlo",
            "entity_type": "thing",
            "static_attributes": [
                {
                    "type": "string",
                    "name": "att_name",
                    "value": "value"
                }
            ],
            "timezone": "Europe/Madrid",
            "attributes": [
                {
                    "type": "int",
                    "name": "temperature",
                    "object_id": "t"
                }
            ],
            "device_id": "NexusPro"
        }
    ]
}

...

* Status Code: 201
* Response:


List Devices:
sunda:Sensors_UL20 just$ python ListDevices.py
* Asking to http://130.206.80.40:5371/iot/devices
* Headers: {'Fiware-Service': 'bus_auto', 'content-type': 'application/json', 'Fiware-ServicePath': '/', 'X-Auth-Token': 'NULL'}
...

* Status Code: 200
* Response:
{ "count": 40,"devices": [{ "device_id" : "0001" },{ "device_id" : "1111" },{ "device_id" : "123123" },
{ "device_id" : "1395000742736" },{ "device_id" : "ComDigSensor" },
{ "device_id" : "DEV_ID" },{ "device_id" : "DOOR1" },{ "device_id" : "DOOR2" },
{ "device_id" : "DOOR3" },{ "device_id" : "DSV" },{ "device_id" : "IDASSensor" },{ "device_id" : "Mariscal" },
{ "device_id" : "NexusPro" },{ "device_id" : "OilTemp1" },{ "device_id" : "SENSOR_EXTERNAL_TEMP" },{ "device_id" : "SENSOR_INTERNAL_TEMP" },
{ "device_id" : "SJC" },{ "device_id" : "SLM4G_Temp1_dev" },{ "device_id" : "Sejong" },{ "device_id" : "SejongSensor" }]}

Send Measurement

sunda:Sensors_UL20 just$ python SendObservation.py NexusPro 't|16'
* Asking to http://130.206.80.40:5371/iot/d?k=4jggokgpepnvsb2uv4s40d59ov&i=NexusPro
* Headers: {'Fiware-Service': 'bus_auto', 'content-type': 'application/json', 'Fiware-ServicePath': '/', 'X-Auth-Token': 'NULL'}
* Sending PAYLOAD:
t|16

...

* Status Code: 200
* Response:

NB protocol field is important!!
https://github.com/telefonicaid/fiware-figway/issues/3

4- get temperatures from CB

Yes NexusPro is registered at CB:

sunda:ContextBroker just$ python GetEntities.py ALL
* Asking to http://130.206.80.40:1026/ngsi10/queryContext
* Headers: {'Fiware-Service': 'bus_auto', 'content-type': 'application/json', 'accept': 'application/json', 'X-Auth-Token': 'NULL'}
* Sending PAYLOAD:
{
    "entities": [
        {
            "type": "",
            "id": ".*",
            "isPattern": "true"
        }
    ],
    "attributes": []
}

...

* Status Code: 200
***** Number of Entity Types: 4

***** List of Entity Types
<entityId type="thing" isPattern="false"> : 4

**** Number of Entity IDs: 4

**** List of Entity IDs
<id>Temp- : 3
<id>1< : 1

Do you want me to print all Entities? (yes/no)yes
<queryContextResponse>
  <contextResponseList>
    <contextElementResponse>
      <contextElement>
        <entityId type="thing" isPattern="false">
          <id>1</id>
        </entityId>
        <contextAttributeList>
          <contextAttribute>
            <name>TimeInstant</name>
            <type>ISO8601</type>
            <contextValue>2015-09-24T11:57:15.616482Z</contextValue>
          </contextAttribute>
          <contextAttribute>
            <name>att_name</name>
            <type>string</type>
            <contextValue>value</contextValue>
            <metadata>
              <contextMetadata>
                <name>TimeInstant</name>
                <type>ISO8601</type>
                <value>2015-09-24T11:57:15.616892Z</value>
              </contextMetadata>
            </metadata>
          </contextAttribute>
        </contextAttributeList>
      </contextElement>
      <statusCode>
        <code>200</code>
        <reasonPhrase>OK</reasonPhrase>
      </statusCode>
    </contextElementResponse>
    <contextElementResponse>
      <contextElement>
        <entityId type="thing" isPattern="false">
          <id>Temp-Hird28001</id>
        </entityId>
        <contextAttributeList>
          <contextAttribute>
            <name>TimeInstant</name>
            <type>ISO8601</type>
            <contextValue>2015-10-02T10:10:22.180705Z</contextValue>
          </contextAttribute>
          <contextAttribute>
            <name>att_name</name>
            <type>string</type>
            <contextValue>value</contextValue>
            <metadata>
              <contextMetadata>
                <name>TimeInstant</name>
                <type>ISO8601</type>
                <value>2015-10-02T10:10:22.180910Z</value>
              </contextMetadata>
            </metadata>
          </contextAttribute>
        </contextAttributeList>
      </contextElement>
      <statusCode>
        <code>200</code>
        <reasonPhrase>OK</reasonPhrase>
      </statusCode>
    </contextElementResponse>
    <contextElementResponse>
      <contextElement>
        <entityId type="thing" isPattern="false">
          <id>Temp-Hird01</id>
        </entityId>
        <contextAttributeList>
          <contextAttribute>
            <name>TimeInstant</name>
            <type>ISO8601</type>
            <contextValue>2015-10-03T15:02:35.715150Z</contextValue>
          </contextAttribute>
          <contextAttribute>
            <name>att_name</name>
            <type>string</type>
            <contextValue>value</contextValue>
            <metadata>
              <contextMetadata>
                <name>TimeInstant</name>
                <type>ISO8601</type>
                <value>2015-10-02T19:52:35.715350Z</value>
              </contextMetadata>
            </metadata>
          </contextAttribute>
        </contextAttributeList>
      </contextElement>
      <statusCode>
        <code>200</code>
        <reasonPhrase>OK</reasonPhrase>
      </statusCode>
    </contextElementResponse>
    <contextElementResponse>
      <contextElement>
        <entityId type="thing" isPattern="false">
          <id>Temp-Otterlo</id>
        </entityId>
        <contextAttributeList>
          <contextAttribute>
            <name>TimeInstant</name>
            <type>ISO8601</type>
            <contextValue>2015-10-03T14:04:44.663133Z</contextValue>
          </contextAttribute>
          <contextAttribute>
            <name>att_name</name>
            <type>string</type>
            <contextValue>value</contextValue>
            <metadata>
              <contextMetadata>
                <name>TimeInstant</name>
                <type>ISO8601</type>
                <value>2015-10-03T14:04:44.663500Z</value>
              </contextMetadata>
            </metadata>
          </contextAttribute>
        </contextAttributeList>
      </contextElement>
      <statusCode>
        <code>200</code>
        <reasonPhrase>OK</reasonPhrase>
      </statusCode>
    </contextElementResponse>
  </contextResponseList>
</queryContextResponse>


GetEntity
sunda:ContextBroker just$ python GetEntity.py Temp-Otterlo
* Asking to http://130.206.80.40:1026/ngsi10/queryContext
* Headers: {'Fiware-Service': 'bus_auto', 'content-type': 'application/json', 'accept': 'application/json', 'X-Auth-Token': 'NULL'}
* Sending PAYLOAD:
{
    "entities": [
        {
            "type": "",
            "id": "Temp-Otterlo",
            "isPattern": "false"
        }
    ],
    "attributes": []
}

...

* Status Code: 200
* Response:
{
  "contextResponses" : [
    {
      "contextElement" : {
        "type" : "thing",
        "isPattern" : "false",
        "id" : "Temp-Otterlo",
        "attributes" : [
          {
            "name" : "TimeInstant",
            "type" : "ISO8601",
            "value" : "2015-10-03T14:04:44.663133Z"
          },
          {
            "name" : "att_name",
            "type" : "string",
            "value" : "value",
            "metadatas" : [
              {
                "name" : "TimeInstant",
                "type" : "ISO8601",
                "value" : "2015-10-03T14:04:44.663500Z"
              }
            ]
          }
        ]
      },
      "statusCode" : {
        "code" : "200",
        "reasonPhrase" : "OK"
      }
    }
  ]
}

PROBLEEM: geen temperatuur in Orion Context Broker:
http://stackoverflow.com/questions/32933813/fiware-no-observation-attributes-in-orion-cb-when-registered-sent-via-idas-ultr?sem=2

5- show in Wirecloud Mashup
