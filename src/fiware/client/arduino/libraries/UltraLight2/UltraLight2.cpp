#include "UltraLight2.h"

bool ultraLightDebugging = false;

#define FS(x) (__FlashStringHelper*)(x)
static const char header1[] PROGMEM = "{\"devices\": [{\"protocol\":\"PDI-IoTA-UltraLight\",\"entity_name\":\"";
static const char header2[] PROGMEM = "Ent\",\"entity_type\":\"thing\",\"timezone\":\"Europe/Amsterdam\",\"static_attributes\":[";
static const char betweenAttributes[] PROGMEM = "],\"attributes\":[";
static const char attribFormatType[] PROGMEM = "{\"type\":\"";
static const char attribFormatName[] PROGMEM = "\",\"name\":\"";
static const char attribFormatObjectId[] PROGMEM = "\",\"object_id\":\"";
static const char attribFormatEnd[] PROGMEM = "\"}";
static const char attribFormatValue[] PROGMEM = "\",\"value\":\"";
static const char attribCoordsMetadataPlusEnd[] PROGMEM = "\",\"metadatas\":[{\"name\":\"location\",\"type\":\"string\",\"value\":\"WGS84\"}]}";
static const char footer1[] PROGMEM = "],\"device_id\":\"";
static const char footer2[] PROGMEM = "\"}]}";

template <typename T>
static void dprint(Print* print, T value) {
	print->print(value);
  if(ultraLightDebugging)
    Serial.print(value);
}
void dprintln(Print* print) {
  dprint(print, F("\r\n"));
}
template <typename T>
static void dprintln(Print* print, T value) {
  dprint(print, value);
  dprintln(print);
}
void printTextForType(Print* print, AttributeType type) {
	if(type == AT_INT)
		 dprint(print, F("int"));
  else if(type == AT_FLOAT)
    dprint(print, F("float"));
  else if(type == AT_COORDS)
    dprint(print, F("coords"));
  else
    dprint(print, F("string"));
}
int getLengthForType(AttributeType type) {
	if(type == AT_INT)
		return 3; // int"
  else if(type == AT_FLOAT)
    return 5; // float
  else if(type == AT_COORDS)
    return 6; // coords
	return 6; //string
}
String getCoordsString(float lon, float lat) {
  return String(lon) + "," + String(lat);
}

Observation::Observation(const char* deviceId, Attribute* attributes, int numberOfAttributes) {
  _deviceId = deviceId;
  _attributes = attributes;
  _numberOfAttributes = numberOfAttributes;
}

bool Observation::setAttribute(const char* name, int value) {
  return setAttribute(name, AT_INT, String(value));
}

bool Observation::setAttribute(const char* name, const char* value) {
  return setAttribute(name, AT_STRING, String(value));
}

bool Observation::setAttribute(const char* name, float value) {
  return setAttribute(name, AT_FLOAT, String(value));
}

bool Observation::setAttribute(const char* name, float lon, float lat) {
  return setAttribute(name, AT_COORDS, getCoordsString(lon, lat));
}

bool Observation::setAttribute(const char* name, AttributeType type, String value) {
  for (int i = 0; i < _numberOfAttributes; i++) {
    if (strcmp(_attributes[i].name, name) == 0) {
      if (_attributes[i].type != type) {
        break;
      }
      _values[i] = value;
      return true;
    }
  }
  if(ultraLightDebugging)
    Serial.println(F("Observation:setAttribute: attrib not found!"));
  return false;
}

int Observation::send(Print* print, bool calculateOnly) {
  int len = 0;

  for (int i = 0; i < _numberOfAttributes; i++) {
    if (i > 0) {
      if(!calculateOnly) dprint(print, "#");
      len++;
    }

    if(!calculateOnly) {
      dprint(print, _attributes[i].id);
      dprint(print, "|");
      dprint(print, _values[i]);
    }

    len += 2 + _values[i].length();
  }

  return len;
}


Device::Device(const char* deviceId) {
  _deviceId = deviceId;
  _nextAttributeId = 'a';
}

bool Device::addStaticAttribute(const char* name, int value) {
  return addStaticAttribute(name, AT_INT, String(value));
}

bool Device::addStaticAttribute(const char* name, const char* value) {
  return addStaticAttribute(name, AT_STRING, String(value));
}

bool Device::addStaticAttribute(const char* name, float value) {
  return addStaticAttribute(name, AT_FLOAT, String(value));
}

bool Device::addStaticAttribute(const char* name, float lon, float lat) {
  return addStaticAttribute(name, AT_COORDS, getCoordsString(lon, lat));
}

bool Device::addStaticAttribute(const char* name, AttributeType type, String value) {
  if (_numberOfStaticAttributes >= MAX_STATIC_ATTRIBUTES) {
    if(ultraLightDebugging)
      Serial.println(F("Max # static attribs reached!"));
    return false;
  }

  StaticAttribute attrib;
  attrib.name = name;
  attrib.type = type;
  attrib.value = value;
  _staticAttributes[_numberOfStaticAttributes++] = attrib;
  return true;
}

bool Device::addStringAttribute(const char* name) {
  addAttribute(name, AT_STRING);
}

bool Device::addIntAttribute(const char* name) {
  addAttribute(name, AT_INT);
}

bool Device::addFloatAttribute(const char* name) {
  addAttribute(name, AT_FLOAT);
}

bool Device::addCoordsAttribute(const char* name) {
  addAttribute(name, AT_COORDS);  
}

bool Device::addAttribute(const char* name, AttributeType type) {
  if (_numberOfAttributes >= MAX_ATTRIBUTES) {
    if(ultraLightDebugging)
      Serial.println(F("Max # attribs reached!"));
    return false;
  }

  Attribute attrib;
  attrib.name = name;
  attrib.type = type;
  attrib.id = _nextAttributeId++;
  _attributes[_numberOfAttributes++] = attrib;
  return true;
}

Observation Device::createObservation() {
  return Observation(_deviceId, _attributes, _numberOfAttributes);
}

int Device::sendStaticAttributes(Print* print, bool calculateOnly) {
  int len = 0;

  for(int i = 0; i < _numberOfStaticAttributes; i++) {
    if (i > 0) {
      if(!calculateOnly) dprint(print, F(","));
      len++;
    }
    StaticAttribute* a = &(_staticAttributes[i]);

    if(!calculateOnly) {
      dprint(print, FS(attribFormatType));
      printTextForType(print, a->type);
      dprint(print, FS(attribFormatName));
      dprint(print, a->name);
      dprint(print, FS(attribFormatValue));
      dprint(print, a->value);
      if(a->type == AT_COORDS)
        dprint(print, FS(attribCoordsMetadataPlusEnd));
      else
        dprint(print, FS(attribFormatEnd));
    }
    len += strlen_P(attribFormatType) + getLengthForType(a->type) + strlen_P(attribFormatName) + 
            strlen(a->name) + strlen_P(attribFormatValue) + a->value.length() +
            (a->type == AT_COORDS ? strlen_P(attribCoordsMetadataPlusEnd) : strlen_P(attribFormatEnd));
  }
  return len;
}

int Device::sendAttributes(Print* print, bool calculateOnly) {
  int len = 0;

  for (int i = 0; i < _numberOfAttributes; i++) {
    if (i > 0) {
      if(!calculateOnly) dprint(print, F(","));
      len++;
    }
    Attribute* a = &(_attributes[i]);

    if(!calculateOnly) {
      dprint(print, FS(attribFormatType));
      printTextForType(print, a->type);
      dprint(print, FS(attribFormatName));
      dprint(print, a->name);
      dprint(print, FS(attribFormatObjectId));
      dprint(print, a->id);
      if(a->type == AT_COORDS)
        dprint(print, FS(attribCoordsMetadataPlusEnd));
      else
        dprint(print, FS(attribFormatEnd));
    }
    len += strlen_P(attribFormatType) + getLengthForType(a->type) + strlen_P(attribFormatName) +
            strlen(a->name) + strlen_P(attribFormatObjectId) + 1 +
            (a->type == AT_COORDS ? strlen_P(attribCoordsMetadataPlusEnd) : strlen_P(attribFormatEnd));
  }
  return len;
}

int Device::send(Print* print, bool calculateOnly) {

  if(!calculateOnly) {
	  dprint(print, FS(header1));
	  dprint(print, _deviceId);
	  dprint(print, FS(header2));
  }
  int len = strlen_P(header1) + strlen(_deviceId) + strlen_P(header2);

  len += sendStaticAttributes(print, calculateOnly);
  
  if(!calculateOnly) dprint(print, FS(betweenAttributes));
  len += strlen_P(betweenAttributes);

  len += sendAttributes(print, calculateOnly);

  if(!calculateOnly) {
    dprint(print, FS(footer1));
    dprint(print, _deviceId);
    dprint(print, FS(footer2));
  }
  len += strlen_P(footer1) + strlen(_deviceId) + strlen_P(footer2);

  return len;
}


Publisher::Publisher(Device* device) {
  _device = device;
}

HttpPublisher::HttpPublisher(Print* print, Device* device) : Publisher(device) {
  int bodyLength = device->send(print, true);
  sendHeader(print, F("/iot/devices"), NULL, bodyLength);
  device->send(print, false);
}

void HttpPublisher::send(Print* print, Observation* observation) {
  int bodyLength = observation->send(print, true);
  sendHeader(print, F("/iot/d?k=4jggokgpepnvsb2uv4s40d59ov&i="), observation->deviceId(), bodyLength);
  observation->send(print, false);
}

void HttpPublisher::sendHeader(Print* print, const __FlashStringHelper* url, const char* url2, int bodyLength) {
  dprint(print, F("POST "));
  dprint(print, url);
  if(url2 != NULL)
    dprint(print, url2);
  dprintln(print, F(" HTTP/1.1"));
  dprintln(print, F("Content-Type: application/json"));
  dprint(print, F("Content-Length: "));
  dprintln(print, bodyLength);
  dprintln(print, F("Fiware-Service: fiwareiot"));
  dprintln(print, F("Fiware-ServicePath: /"));
  dprintln(print, F("X-Auth-Token: NULL"));
  dprintln(print);
}
