drop schema if exists sos cascade;

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: sos; Type: SCHEMA; Schema: -; Owner: sensors
--

CREATE SCHEMA sos;


ALTER SCHEMA sos OWNER TO sensors;

--
-- Name: SCHEMA sos; Type: COMMENT; Schema: -; Owner: sensors
--

COMMENT ON SCHEMA sos IS 'main sos database';


SET search_path = sos, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: blobvalue; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE blobvalue (
    observationid bigint NOT NULL,
    value oid
);


ALTER TABLE sos.blobvalue OWNER TO sensors;

--
-- Name: booleanvalue; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE booleanvalue (
    observationid bigint NOT NULL,
    value character(1),
    CONSTRAINT booleanvalue_value_check CHECK ((value = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);


ALTER TABLE sos.booleanvalue OWNER TO sensors;

--
-- Name: categoryvalue; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE categoryvalue (
    observationid bigint NOT NULL,
    value character varying(255)
);


ALTER TABLE sos.categoryvalue OWNER TO sensors;

--
-- Name: codespace; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE codespace (
    codespaceid bigint NOT NULL,
    codespace character varying(255) NOT NULL
);


ALTER TABLE sos.codespace OWNER TO sensors;

--
-- Name: codespaceid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE codespaceid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.codespaceid_seq OWNER TO sensors;

--
-- Name: compositephenomenon; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE compositephenomenon (
    parentobservablepropertyid bigint NOT NULL,
    childobservablepropertyid bigint NOT NULL
);


ALTER TABLE sos.compositephenomenon OWNER TO sensors;

--
-- Name: countvalue; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE countvalue (
    observationid bigint NOT NULL,
    value integer
);


ALTER TABLE sos.countvalue OWNER TO sensors;

--
-- Name: featureofinterest; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE featureofinterest (
    featureofinterestid bigint NOT NULL,
    hibernatediscriminator character(1) NOT NULL,
    featureofinteresttypeid bigint NOT NULL,
    identifier character varying(255),
    codespace bigint,
    name character varying(255),
    codespacename bigint,
    description character varying(255),
    geom public.geometry,
    descriptionxml text,
    url character varying(255)
);


ALTER TABLE sos.featureofinterest OWNER TO sensors;

--
-- Name: featureofinterestid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE featureofinterestid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.featureofinterestid_seq OWNER TO sensors;

--
-- Name: featureofinteresttype; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE featureofinteresttype (
    featureofinteresttypeid bigint NOT NULL,
    featureofinteresttype character varying(255) NOT NULL
);


ALTER TABLE sos.featureofinteresttype OWNER TO sensors;

--
-- Name: featureofinteresttypeid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE featureofinteresttypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.featureofinteresttypeid_seq OWNER TO sensors;

--
-- Name: featurerelation; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE featurerelation (
    parentfeatureid bigint NOT NULL,
    childfeatureid bigint NOT NULL
);


ALTER TABLE sos.featurerelation OWNER TO sensors;

--
-- Name: geometryvalue; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE geometryvalue (
    observationid bigint NOT NULL,
    value public.geometry
);


ALTER TABLE sos.geometryvalue OWNER TO sensors;

--
-- Name: i18ncapabilities; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE i18ncapabilities (
    id bigint NOT NULL,
    codespace bigint NOT NULL,
    title character varying(255),
    abstract character varying(255)
);


ALTER TABLE sos.i18ncapabilities OWNER TO sensors;

--
-- Name: i18ncapabilitiesid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE i18ncapabilitiesid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.i18ncapabilitiesid_seq OWNER TO sensors;

--
-- Name: i18nfeatureofinterest; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE i18nfeatureofinterest (
    id bigint NOT NULL,
    objectid bigint NOT NULL,
    codespace bigint NOT NULL,
    name character varying(255),
    description character varying(255)
);


ALTER TABLE sos.i18nfeatureofinterest OWNER TO sensors;

--
-- Name: i18nfeatureofinterestid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE i18nfeatureofinterestid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.i18nfeatureofinterestid_seq OWNER TO sensors;

--
-- Name: i18nobservableproperty; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE i18nobservableproperty (
    id bigint NOT NULL,
    objectid bigint NOT NULL,
    codespace bigint NOT NULL,
    name character varying(255),
    description character varying(255)
);


ALTER TABLE sos.i18nobservableproperty OWNER TO sensors;

--
-- Name: i18nobspropid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE i18nobspropid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.i18nobspropid_seq OWNER TO sensors;

--
-- Name: i18noffering; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE i18noffering (
    id bigint NOT NULL,
    objectid bigint NOT NULL,
    codespace bigint NOT NULL,
    name character varying(255),
    description character varying(255)
);


ALTER TABLE sos.i18noffering OWNER TO sensors;

--
-- Name: i18nofferingid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE i18nofferingid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.i18nofferingid_seq OWNER TO sensors;

--
-- Name: i18nprocedure; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE i18nprocedure (
    id bigint NOT NULL,
    objectid bigint NOT NULL,
    codespace bigint NOT NULL,
    name character varying(255),
    description character varying(255),
    shortname character varying(255),
    longname character varying(255)
);


ALTER TABLE sos.i18nprocedure OWNER TO sensors;

--
-- Name: i18nprocedureid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE i18nprocedureid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.i18nprocedureid_seq OWNER TO sensors;

--
-- Name: numericvalue; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE numericvalue (
    observationid bigint NOT NULL,
    value numeric(19,2)
);


ALTER TABLE sos.numericvalue OWNER TO sensors;

--
-- Name: observableproperty; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE observableproperty (
    observablepropertyid bigint NOT NULL,
    hibernatediscriminator character(1) NOT NULL,
    identifier character varying(255),
    codespace bigint,
    name character varying(255),
    codespacename bigint,
    description character varying(255),
    disabled character(1) DEFAULT 'F'::bpchar NOT NULL,
    CONSTRAINT observableproperty_disabled_check CHECK ((disabled = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);


ALTER TABLE sos.observableproperty OWNER TO sensors;

--
-- Name: observablepropertyid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE observablepropertyid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.observablepropertyid_seq OWNER TO sensors;

--
-- Name: observation; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE observation (
    observationid bigint NOT NULL,
    seriesid bigint NOT NULL,
    phenomenontimestart timestamp without time zone NOT NULL,
    phenomenontimeend timestamp without time zone NOT NULL,
    resulttime timestamp without time zone NOT NULL,
    validtimestart timestamp without time zone,
    validtimeend timestamp without time zone,
    deleted character(1) DEFAULT 'F'::bpchar NOT NULL,
    identifier character varying(255),
    codespace bigint,
    name character varying(255),
    codespacename bigint,
    description character varying(255),
    unitid bigint,
    CONSTRAINT observation_deleted_check CHECK ((deleted = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);


ALTER TABLE sos.observation OWNER TO sensors;

--
-- Name: observationconstellation; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE observationconstellation (
    observationconstellationid bigint NOT NULL,
    observablepropertyid bigint NOT NULL,
    procedureid bigint NOT NULL,
    observationtypeid bigint,
    offeringid bigint NOT NULL,
    deleted character(1) DEFAULT 'F'::bpchar NOT NULL,
    hiddenchild character(1) DEFAULT 'F'::bpchar NOT NULL,
    CONSTRAINT observationconstellation_deleted_check CHECK ((deleted = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT observationconstellation_hiddenchild_check CHECK ((hiddenchild = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);


ALTER TABLE sos.observationconstellation OWNER TO sensors;

--
-- Name: observationconstellationid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE observationconstellationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.observationconstellationid_seq OWNER TO sensors;

--
-- Name: observationhasoffering; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE observationhasoffering (
    observationid bigint NOT NULL,
    offeringid bigint NOT NULL
);


ALTER TABLE sos.observationhasoffering OWNER TO sensors;

--
-- Name: observationid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE observationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.observationid_seq OWNER TO sensors;

--
-- Name: observationtype; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE observationtype (
    observationtypeid bigint NOT NULL,
    observationtype character varying(255) NOT NULL
);


ALTER TABLE sos.observationtype OWNER TO sensors;

--
-- Name: observationtypeid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE observationtypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.observationtypeid_seq OWNER TO sensors;

--
-- Name: offering; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE offering (
    offeringid bigint NOT NULL,
    hibernatediscriminator character(1) NOT NULL,
    identifier character varying(255) NOT NULL,
    codespace bigint,
    name character varying(255),
    codespacename bigint,
    description character varying(255),
    disabled character(1) DEFAULT 'F'::bpchar NOT NULL,
    CONSTRAINT offering_disabled_check CHECK ((disabled = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);


ALTER TABLE sos.offering OWNER TO sensors;

--
-- Name: offeringallowedfeaturetype; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE offeringallowedfeaturetype (
    offeringid bigint NOT NULL,
    featureofinteresttypeid bigint NOT NULL
);


ALTER TABLE sos.offeringallowedfeaturetype OWNER TO sensors;

--
-- Name: offeringallowedobservationtype; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE offeringallowedobservationtype (
    offeringid bigint NOT NULL,
    observationtypeid bigint NOT NULL
);


ALTER TABLE sos.offeringallowedobservationtype OWNER TO sensors;

--
-- Name: offeringhasrelatedfeature; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE offeringhasrelatedfeature (
    offeringid bigint NOT NULL,
    relatedfeatureid bigint NOT NULL
);


ALTER TABLE sos.offeringhasrelatedfeature OWNER TO sensors;

--
-- Name: offeringid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE offeringid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.offeringid_seq OWNER TO sensors;

--
-- Name: parameter; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE parameter (
    parameterid bigint NOT NULL,
    observationid bigint NOT NULL,
    definition character varying(255) NOT NULL,
    title character varying(255),
    value oid NOT NULL
);


ALTER TABLE sos.parameter OWNER TO sensors;

--
-- Name: parameterid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE parameterid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.parameterid_seq OWNER TO sensors;

--
-- Name: procdescformatid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE procdescformatid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.procdescformatid_seq OWNER TO sensors;

--
-- Name: procedure; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE procedure (
    procedureid bigint NOT NULL,
    hibernatediscriminator character(1) NOT NULL,
    proceduredescriptionformatid bigint NOT NULL,
    identifier character varying(255),
    codespace bigint,
    name character varying(255),
    codespacename bigint,
    description character varying(255),
    deleted character(1) DEFAULT 'F'::bpchar NOT NULL,
    disabled character(1) DEFAULT 'F'::bpchar NOT NULL,
    descriptionfile text,
    referenceflag character(1) DEFAULT 'F'::bpchar,
    CONSTRAINT procedure_deleted_check CHECK ((deleted = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT procedure_disabled_check CHECK ((disabled = ANY (ARRAY['T'::bpchar, 'F'::bpchar]))),
    CONSTRAINT procedure_referenceflag_check CHECK ((referenceflag = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);


ALTER TABLE sos.procedure OWNER TO sensors;

--
-- Name: proceduredescriptionformat; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE proceduredescriptionformat (
    proceduredescriptionformatid bigint NOT NULL,
    proceduredescriptionformat character varying(255) NOT NULL
);


ALTER TABLE sos.proceduredescriptionformat OWNER TO sensors;

--
-- Name: procedureid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE procedureid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.procedureid_seq OWNER TO sensors;

--
-- Name: relatedfeature; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE relatedfeature (
    relatedfeatureid bigint NOT NULL,
    featureofinterestid bigint NOT NULL
);


ALTER TABLE sos.relatedfeature OWNER TO sensors;

--
-- Name: relatedfeaturehasrole; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE relatedfeaturehasrole (
    relatedfeatureid bigint NOT NULL,
    relatedfeatureroleid bigint NOT NULL
);


ALTER TABLE sos.relatedfeaturehasrole OWNER TO sensors;

--
-- Name: relatedfeatureid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE relatedfeatureid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.relatedfeatureid_seq OWNER TO sensors;

--
-- Name: relatedfeaturerole; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE relatedfeaturerole (
    relatedfeatureroleid bigint NOT NULL,
    relatedfeaturerole character varying(255) NOT NULL
);


ALTER TABLE sos.relatedfeaturerole OWNER TO sensors;

--
-- Name: relatedfeatureroleid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE relatedfeatureroleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.relatedfeatureroleid_seq OWNER TO sensors;

--
-- Name: resulttemplate; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE resulttemplate (
    resulttemplateid bigint NOT NULL,
    offeringid bigint NOT NULL,
    observablepropertyid bigint NOT NULL,
    procedureid bigint NOT NULL,
    featureofinterestid bigint NOT NULL,
    identifier character varying(255) NOT NULL,
    resultstructure text NOT NULL,
    resultencoding text NOT NULL
);


ALTER TABLE sos.resulttemplate OWNER TO sensors;

--
-- Name: resulttemplateid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE resulttemplateid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.resulttemplateid_seq OWNER TO sensors;

--
-- Name: sensorsystem; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE sensorsystem (
    parentsensorid bigint NOT NULL,
    childsensorid bigint NOT NULL
);


ALTER TABLE sos.sensorsystem OWNER TO sensors;

--
-- Name: series; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE series (
    seriesid bigint NOT NULL,
    featureofinterestid bigint NOT NULL,
    observablepropertyid bigint NOT NULL,
    procedureid bigint NOT NULL,
    deleted character(1) DEFAULT 'F'::bpchar NOT NULL,
    firsttimestamp timestamp without time zone,
    lasttimestamp timestamp without time zone,
    firstnumericvalue numeric(19,2),
    lastnumericvalue numeric(19,2),
    unitid bigint,
    CONSTRAINT series_deleted_check CHECK ((deleted = ANY (ARRAY['T'::bpchar, 'F'::bpchar])))
);


ALTER TABLE sos.series OWNER TO sensors;

--
-- Name: seriesid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE seriesid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.seriesid_seq OWNER TO sensors;

--
-- Name: spatialfilteringprofile; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE spatialfilteringprofile (
    spatialfilteringprofileid bigint NOT NULL,
    observation bigint NOT NULL,
    identifier character varying(255),
    codespace bigint,
    name character varying(255),
    codespacename bigint,
    description character varying(255),
    geom public.geometry NOT NULL
);


ALTER TABLE sos.spatialfilteringprofile OWNER TO sensors;

--
-- Name: spatialfilteringprofileid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE spatialfilteringprofileid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.spatialfilteringprofileid_seq OWNER TO sensors;

--
-- Name: swedataarrayvalue; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE swedataarrayvalue (
    observationid bigint NOT NULL,
    value text
);


ALTER TABLE sos.swedataarrayvalue OWNER TO sensors;

--
-- Name: textvalue; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE textvalue (
    observationid bigint NOT NULL,
    value text
);


ALTER TABLE sos.textvalue OWNER TO sensors;

--
-- Name: unit; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE unit (
    unitid bigint NOT NULL,
    unit character varying(255) NOT NULL
);


ALTER TABLE sos.unit OWNER TO sensors;

--
-- Name: unitid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE unitid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.unitid_seq OWNER TO sensors;

--
-- Name: validproceduretime; Type: TABLE; Schema: sos; Owner: sensors; Tablespace:
--

CREATE TABLE validproceduretime (
    validproceduretimeid bigint NOT NULL,
    procedureid bigint NOT NULL,
    proceduredescriptionformatid bigint NOT NULL,
    starttime timestamp without time zone NOT NULL,
    endtime timestamp without time zone,
    descriptionxml text NOT NULL
);


ALTER TABLE sos.validproceduretime OWNER TO sensors;

--
-- Name: validproceduretimeid_seq; Type: SEQUENCE; Schema: sos; Owner: sensors
--

CREATE SEQUENCE validproceduretimeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sos.validproceduretimeid_seq OWNER TO sensors;

--
-- Data for Name: blobvalue; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: booleanvalue; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: categoryvalue; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: codespace; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: codespaceid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('codespaceid_seq', 1, false);


--
-- Data for Name: compositephenomenon; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: countvalue; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: featureofinterest; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: featureofinterestid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('featureofinterestid_seq', 1, false);


--
-- Data for Name: featureofinteresttype; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: featureofinteresttypeid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('featureofinteresttypeid_seq', 1, false);


--
-- Data for Name: featurerelation; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: geometryvalue; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: i18ncapabilities; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: i18ncapabilitiesid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('i18ncapabilitiesid_seq', 1, false);


--
-- Data for Name: i18nfeatureofinterest; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: i18nfeatureofinterestid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('i18nfeatureofinterestid_seq', 1, false);


--
-- Data for Name: i18nobservableproperty; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: i18nobspropid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('i18nobspropid_seq', 1, false);


--
-- Data for Name: i18noffering; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: i18nofferingid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('i18nofferingid_seq', 1, false);


--
-- Data for Name: i18nprocedure; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: i18nprocedureid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('i18nprocedureid_seq', 1, false);


--
-- Data for Name: numericvalue; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: observableproperty; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: observablepropertyid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('observablepropertyid_seq', 1, false);


--
-- Data for Name: observation; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: observationconstellation; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: observationconstellationid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('observationconstellationid_seq', 1, false);


--
-- Data for Name: observationhasoffering; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: observationid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('observationid_seq', 1, false);


--
-- Data for Name: observationtype; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: observationtypeid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('observationtypeid_seq', 1, false);


--
-- Data for Name: offering; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: offeringallowedfeaturetype; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: offeringallowedobservationtype; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: offeringhasrelatedfeature; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: offeringid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('offeringid_seq', 1, false);


--
-- Data for Name: parameter; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: parameterid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('parameterid_seq', 1, false);


--
-- Name: procdescformatid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('procdescformatid_seq', 1, false);


--
-- Data for Name: procedure; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: proceduredescriptionformat; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: procedureid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('procedureid_seq', 1, false);


--
-- Data for Name: relatedfeature; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: relatedfeaturehasrole; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: relatedfeatureid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('relatedfeatureid_seq', 1, false);


--
-- Data for Name: relatedfeaturerole; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: relatedfeatureroleid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('relatedfeatureroleid_seq', 1, false);


--
-- Data for Name: resulttemplate; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: resulttemplateid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('resulttemplateid_seq', 1, false);


--
-- Data for Name: sensorsystem; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: series; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: seriesid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('seriesid_seq', 1, false);


--
-- Data for Name: spatialfilteringprofile; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: spatialfilteringprofileid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('spatialfilteringprofileid_seq', 1, false);


--
-- Data for Name: swedataarrayvalue; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: textvalue; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Data for Name: unit; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: unitid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('unitid_seq', 1, false);


--
-- Data for Name: validproceduretime; Type: TABLE DATA; Schema: sos; Owner: sensors
--



--
-- Name: validproceduretimeid_seq; Type: SEQUENCE SET; Schema: sos; Owner: sensors
--

SELECT pg_catalog.setval('validproceduretimeid_seq', 1, false);


--
-- Name: blobvalue_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY blobvalue
    ADD CONSTRAINT blobvalue_pkey PRIMARY KEY (observationid);


--
-- Name: booleanvalue_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY booleanvalue
    ADD CONSTRAINT booleanvalue_pkey PRIMARY KEY (observationid);


--
-- Name: categoryvalue_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY categoryvalue
    ADD CONSTRAINT categoryvalue_pkey PRIMARY KEY (observationid);


--
-- Name: codespace_codespace_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY codespace
    ADD CONSTRAINT codespace_codespace_key UNIQUE (codespace);


--
-- Name: codespace_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY codespace
    ADD CONSTRAINT codespace_pkey PRIMARY KEY (codespaceid);


--
-- Name: compositephenomenon_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY compositephenomenon
    ADD CONSTRAINT compositephenomenon_pkey PRIMARY KEY (childobservablepropertyid, parentobservablepropertyid);


--
-- Name: countvalue_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY countvalue
    ADD CONSTRAINT countvalue_pkey PRIMARY KEY (observationid);


--
-- Name: featureofinterest_identifier_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY featureofinterest
    ADD CONSTRAINT featureofinterest_identifier_key UNIQUE (identifier);


--
-- Name: featureofinterest_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY featureofinterest
    ADD CONSTRAINT featureofinterest_pkey PRIMARY KEY (featureofinterestid);


--
-- Name: featureofinterest_url_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY featureofinterest
    ADD CONSTRAINT featureofinterest_url_key UNIQUE (url);


--
-- Name: featureofinteresttype_featureofinteresttype_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY featureofinteresttype
    ADD CONSTRAINT featureofinteresttype_featureofinteresttype_key UNIQUE (featureofinteresttype);


--
-- Name: featureofinteresttype_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY featureofinteresttype
    ADD CONSTRAINT featureofinteresttype_pkey PRIMARY KEY (featureofinteresttypeid);


--
-- Name: featurerelation_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY featurerelation
    ADD CONSTRAINT featurerelation_pkey PRIMARY KEY (childfeatureid, parentfeatureid);


--
-- Name: geometryvalue_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY geometryvalue
    ADD CONSTRAINT geometryvalue_pkey PRIMARY KEY (observationid);


--
-- Name: i18ncapabilities_codespace_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY i18ncapabilities
    ADD CONSTRAINT i18ncapabilities_codespace_key UNIQUE (codespace);


--
-- Name: i18ncapabilities_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY i18ncapabilities
    ADD CONSTRAINT i18ncapabilities_pkey PRIMARY KEY (id);


--
-- Name: i18nfeatureofinterest_objectid_codespace_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY i18nfeatureofinterest
    ADD CONSTRAINT i18nfeatureofinterest_objectid_codespace_key UNIQUE (objectid, codespace);


--
-- Name: i18nfeatureofinterest_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY i18nfeatureofinterest
    ADD CONSTRAINT i18nfeatureofinterest_pkey PRIMARY KEY (id);


--
-- Name: i18nobservableproperty_objectid_codespace_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY i18nobservableproperty
    ADD CONSTRAINT i18nobservableproperty_objectid_codespace_key UNIQUE (objectid, codespace);


--
-- Name: i18nobservableproperty_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY i18nobservableproperty
    ADD CONSTRAINT i18nobservableproperty_pkey PRIMARY KEY (id);


--
-- Name: i18noffering_objectid_codespace_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY i18noffering
    ADD CONSTRAINT i18noffering_objectid_codespace_key UNIQUE (objectid, codespace);


--
-- Name: i18noffering_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY i18noffering
    ADD CONSTRAINT i18noffering_pkey PRIMARY KEY (id);


--
-- Name: i18nprocedure_objectid_codespace_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY i18nprocedure
    ADD CONSTRAINT i18nprocedure_objectid_codespace_key UNIQUE (objectid, codespace);


--
-- Name: i18nprocedure_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY i18nprocedure
    ADD CONSTRAINT i18nprocedure_pkey PRIMARY KEY (id);


--
-- Name: numericvalue_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY numericvalue
    ADD CONSTRAINT numericvalue_pkey PRIMARY KEY (observationid);


--
-- Name: observableproperty_identifier_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY observableproperty
    ADD CONSTRAINT observableproperty_identifier_key UNIQUE (identifier);


--
-- Name: observableproperty_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY observableproperty
    ADD CONSTRAINT observableproperty_pkey PRIMARY KEY (observablepropertyid);


--
-- Name: observation_identifier_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY observation
    ADD CONSTRAINT observation_identifier_key UNIQUE (identifier);


--
-- Name: observation_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY observation
    ADD CONSTRAINT observation_pkey PRIMARY KEY (observationid);


--
-- Name: observation_seriesid_phenomenontimestart_phenomenontimeend__key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY observation
    ADD CONSTRAINT observation_seriesid_phenomenontimestart_phenomenontimeend__key UNIQUE (seriesid, phenomenontimestart, phenomenontimeend, resulttime);


--
-- Name: observationconstellation_observablepropertyid_procedureid_o_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY observationconstellation
    ADD CONSTRAINT observationconstellation_observablepropertyid_procedureid_o_key UNIQUE (observablepropertyid, procedureid, offeringid);


--
-- Name: observationconstellation_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY observationconstellation
    ADD CONSTRAINT observationconstellation_pkey PRIMARY KEY (observationconstellationid);


--
-- Name: observationhasoffering_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY observationhasoffering
    ADD CONSTRAINT observationhasoffering_pkey PRIMARY KEY (observationid, offeringid);


--
-- Name: observationtype_observationtype_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY observationtype
    ADD CONSTRAINT observationtype_observationtype_key UNIQUE (observationtype);


--
-- Name: observationtype_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY observationtype
    ADD CONSTRAINT observationtype_pkey PRIMARY KEY (observationtypeid);


--
-- Name: offering_identifier_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY offering
    ADD CONSTRAINT offering_identifier_key UNIQUE (identifier);


--
-- Name: offering_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY offering
    ADD CONSTRAINT offering_pkey PRIMARY KEY (offeringid);


--
-- Name: offeringallowedfeaturetype_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY offeringallowedfeaturetype
    ADD CONSTRAINT offeringallowedfeaturetype_pkey PRIMARY KEY (offeringid, featureofinteresttypeid);


--
-- Name: offeringallowedobservationtype_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY offeringallowedobservationtype
    ADD CONSTRAINT offeringallowedobservationtype_pkey PRIMARY KEY (offeringid, observationtypeid);


--
-- Name: offeringhasrelatedfeature_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY offeringhasrelatedfeature
    ADD CONSTRAINT offeringhasrelatedfeature_pkey PRIMARY KEY (offeringid, relatedfeatureid);


--
-- Name: parameter_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY parameter
    ADD CONSTRAINT parameter_pkey PRIMARY KEY (parameterid);


--
-- Name: procedure_identifier_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY procedure
    ADD CONSTRAINT procedure_identifier_key UNIQUE (identifier);


--
-- Name: procedure_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY procedure
    ADD CONSTRAINT procedure_pkey PRIMARY KEY (procedureid);


--
-- Name: proceduredescriptionformat_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY proceduredescriptionformat
    ADD CONSTRAINT proceduredescriptionformat_pkey PRIMARY KEY (proceduredescriptionformatid);


--
-- Name: relatedfeature_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY relatedfeature
    ADD CONSTRAINT relatedfeature_pkey PRIMARY KEY (relatedfeatureid);


--
-- Name: relatedfeaturehasrole_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY relatedfeaturehasrole
    ADD CONSTRAINT relatedfeaturehasrole_pkey PRIMARY KEY (relatedfeatureid, relatedfeatureroleid);


--
-- Name: relatedfeaturerole_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY relatedfeaturerole
    ADD CONSTRAINT relatedfeaturerole_pkey PRIMARY KEY (relatedfeatureroleid);


--
-- Name: relatedfeaturerole_relatedfeaturerole_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY relatedfeaturerole
    ADD CONSTRAINT relatedfeaturerole_relatedfeaturerole_key UNIQUE (relatedfeaturerole);


--
-- Name: resulttemplate_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY resulttemplate
    ADD CONSTRAINT resulttemplate_pkey PRIMARY KEY (resulttemplateid);


--
-- Name: sensorsystem_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY sensorsystem
    ADD CONSTRAINT sensorsystem_pkey PRIMARY KEY (childsensorid, parentsensorid);


--
-- Name: series_featureofinterestid_observablepropertyid_procedureid_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY series
    ADD CONSTRAINT series_featureofinterestid_observablepropertyid_procedureid_key UNIQUE (featureofinterestid, observablepropertyid, procedureid);


--
-- Name: series_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY series
    ADD CONSTRAINT series_pkey PRIMARY KEY (seriesid);


--
-- Name: spatialfilteringprofile_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY spatialfilteringprofile
    ADD CONSTRAINT spatialfilteringprofile_pkey PRIMARY KEY (spatialfilteringprofileid);


--
-- Name: swedataarrayvalue_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY swedataarrayvalue
    ADD CONSTRAINT swedataarrayvalue_pkey PRIMARY KEY (observationid);


--
-- Name: textvalue_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY textvalue
    ADD CONSTRAINT textvalue_pkey PRIMARY KEY (observationid);


--
-- Name: unit_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY unit
    ADD CONSTRAINT unit_pkey PRIMARY KEY (unitid);


--
-- Name: unit_unit_key; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY unit
    ADD CONSTRAINT unit_unit_key UNIQUE (unit);


--
-- Name: validproceduretime_pkey; Type: CONSTRAINT; Schema: sos; Owner: sensors; Tablespace:
--

ALTER TABLE ONLY validproceduretime
    ADD CONSTRAINT validproceduretime_pkey PRIMARY KEY (validproceduretimeid);


--
-- Name: i18nfeatureidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX i18nfeatureidx ON i18nfeatureofinterest USING btree (objectid);


--
-- Name: i18nobspropidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX i18nobspropidx ON i18nobservableproperty USING btree (objectid);


--
-- Name: i18nofferingidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX i18nofferingidx ON i18noffering USING btree (objectid);


--
-- Name: i18nprocedureidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX i18nprocedureidx ON i18nprocedure USING btree (objectid);


--
-- Name: obsconstobspropidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX obsconstobspropidx ON observationconstellation USING btree (observablepropertyid);


--
-- Name: obsconstofferingidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX obsconstofferingidx ON observationconstellation USING btree (offeringid);


--
-- Name: obsconstprocedureidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX obsconstprocedureidx ON observationconstellation USING btree (procedureid);


--
-- Name: obshasoffobservationidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX obshasoffobservationidx ON observationhasoffering USING btree (observationid);


--
-- Name: obshasoffofferingidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX obshasoffofferingidx ON observationhasoffering USING btree (offeringid);


--
-- Name: obsphentimeendidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX obsphentimeendidx ON observation USING btree (phenomenontimeend);


--
-- Name: obsphentimestartidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX obsphentimestartidx ON observation USING btree (phenomenontimestart);


--
-- Name: obsresulttimeidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX obsresulttimeidx ON observation USING btree (resulttime);


--
-- Name: obsseriesidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX obsseriesidx ON observation USING btree (seriesid);


--
-- Name: resulttempeobspropidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX resulttempeobspropidx ON resulttemplate USING btree (observablepropertyid);


--
-- Name: resulttempidentifieridx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX resulttempidentifieridx ON resulttemplate USING btree (identifier);


--
-- Name: resulttempofferingidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX resulttempofferingidx ON resulttemplate USING btree (offeringid);


--
-- Name: resulttempprocedureidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX resulttempprocedureidx ON resulttemplate USING btree (procedureid);


--
-- Name: seriesfeatureidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX seriesfeatureidx ON series USING btree (featureofinterestid);


--
-- Name: seriesobspropidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX seriesobspropidx ON series USING btree (observablepropertyid);


--
-- Name: seriesprocedureidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX seriesprocedureidx ON series USING btree (procedureid);


--
-- Name: sfpobservationidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX sfpobservationidx ON spatialfilteringprofile USING btree (observation);


--
-- Name: validproceduretimeendtimeidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX validproceduretimeendtimeidx ON validproceduretime USING btree (endtime);


--
-- Name: validproceduretimestarttimeidx; Type: INDEX; Schema: sos; Owner: sensors; Tablespace:
--

CREATE INDEX validproceduretimestarttimeidx ON validproceduretime USING btree (starttime);


--
-- Name: featurecodespaceidentifierfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY featureofinterest
    ADD CONSTRAINT featurecodespaceidentifierfk FOREIGN KEY (codespace) REFERENCES codespace(codespaceid);


--
-- Name: featurecodespacenamefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY featureofinterest
    ADD CONSTRAINT featurecodespacenamefk FOREIGN KEY (codespacename) REFERENCES codespace(codespaceid);


--
-- Name: featurefeaturetypefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY featureofinterest
    ADD CONSTRAINT featurefeaturetypefk FOREIGN KEY (featureofinteresttypeid) REFERENCES featureofinteresttype(featureofinteresttypeid);


--
-- Name: featureofinterestchildfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY featurerelation
    ADD CONSTRAINT featureofinterestchildfk FOREIGN KEY (childfeatureid) REFERENCES featureofinterest(featureofinterestid);


--
-- Name: featureofinterestparentfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY featurerelation
    ADD CONSTRAINT featureofinterestparentfk FOREIGN KEY (parentfeatureid) REFERENCES featureofinterest(featureofinterestid);


--
-- Name: fk28e66a64e4ef3005; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY offeringallowedobservationtype
    ADD CONSTRAINT fk28e66a64e4ef3005 FOREIGN KEY (offeringid) REFERENCES offering(offeringid);


--
-- Name: fk5643e7654a79987; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY relatedfeaturehasrole
    ADD CONSTRAINT fk5643e7654a79987 FOREIGN KEY (relatedfeatureid) REFERENCES relatedfeature(relatedfeatureid);


--
-- Name: fk7d7608f4e759db68; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY observationhasoffering
    ADD CONSTRAINT fk7d7608f4e759db68 FOREIGN KEY (observationid) REFERENCES observation(observationid);


--
-- Name: fkf68cb72ee4ef3005; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY offeringallowedfeaturetype
    ADD CONSTRAINT fkf68cb72ee4ef3005 FOREIGN KEY (offeringid) REFERENCES offering(offeringid);


--
-- Name: obscodespaceidentifierfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY observation
    ADD CONSTRAINT obscodespaceidentifierfk FOREIGN KEY (codespace) REFERENCES codespace(codespaceid);


--
-- Name: obscodespacenamefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY observation
    ADD CONSTRAINT obscodespacenamefk FOREIGN KEY (codespacename) REFERENCES codespace(codespaceid);


--
-- Name: obsconstobservationiypefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY observationconstellation
    ADD CONSTRAINT obsconstobservationiypefk FOREIGN KEY (observationtypeid) REFERENCES observationtype(observationtypeid);


--
-- Name: obsconstobspropfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY observationconstellation
    ADD CONSTRAINT obsconstobspropfk FOREIGN KEY (observablepropertyid) REFERENCES observableproperty(observablepropertyid);


--
-- Name: obsconstofferingfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY observationconstellation
    ADD CONSTRAINT obsconstofferingfk FOREIGN KEY (offeringid) REFERENCES offering(offeringid);


--
-- Name: observablepropertychildfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY compositephenomenon
    ADD CONSTRAINT observablepropertychildfk FOREIGN KEY (childobservablepropertyid) REFERENCES observableproperty(observablepropertyid);


--
-- Name: observablepropertyparentfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY compositephenomenon
    ADD CONSTRAINT observablepropertyparentfk FOREIGN KEY (parentobservablepropertyid) REFERENCES observableproperty(observablepropertyid);


--
-- Name: observationblobvaluefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY blobvalue
    ADD CONSTRAINT observationblobvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);


--
-- Name: observationbooleanvaluefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY booleanvalue
    ADD CONSTRAINT observationbooleanvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);


--
-- Name: observationcategoryvaluefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY categoryvalue
    ADD CONSTRAINT observationcategoryvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);


--
-- Name: observationcountvaluefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY countvalue
    ADD CONSTRAINT observationcountvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);


--
-- Name: observationgeometryvaluefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY geometryvalue
    ADD CONSTRAINT observationgeometryvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);


--
-- Name: observationnumericvaluefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY numericvalue
    ADD CONSTRAINT observationnumericvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);


--
-- Name: observationofferingfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY observationhasoffering
    ADD CONSTRAINT observationofferingfk FOREIGN KEY (offeringid) REFERENCES offering(offeringid);


--
-- Name: observationseriesfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY observation
    ADD CONSTRAINT observationseriesfk FOREIGN KEY (seriesid) REFERENCES series(seriesid);


--
-- Name: observationswedataarrayvaluefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY swedataarrayvalue
    ADD CONSTRAINT observationswedataarrayvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);


--
-- Name: observationtextvaluefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY textvalue
    ADD CONSTRAINT observationtextvaluefk FOREIGN KEY (observationid) REFERENCES observation(observationid);


--
-- Name: observationunitfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY observation
    ADD CONSTRAINT observationunitfk FOREIGN KEY (unitid) REFERENCES unit(unitid);


--
-- Name: obsnconstprocedurefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY observationconstellation
    ADD CONSTRAINT obsnconstprocedurefk FOREIGN KEY (procedureid) REFERENCES procedure(procedureid);


--
-- Name: obspropcodespaceidentifierfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY observableproperty
    ADD CONSTRAINT obspropcodespaceidentifierfk FOREIGN KEY (codespace) REFERENCES codespace(codespaceid);


--
-- Name: obspropcodespacenamefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY observableproperty
    ADD CONSTRAINT obspropcodespacenamefk FOREIGN KEY (codespacename) REFERENCES codespace(codespaceid);


--
-- Name: offcodespaceidentifierfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY offering
    ADD CONSTRAINT offcodespaceidentifierfk FOREIGN KEY (codespace) REFERENCES codespace(codespaceid);


--
-- Name: offcodespacenamefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY offering
    ADD CONSTRAINT offcodespacenamefk FOREIGN KEY (codespacename) REFERENCES codespace(codespaceid);


--
-- Name: offeringfeaturetypefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY offeringallowedfeaturetype
    ADD CONSTRAINT offeringfeaturetypefk FOREIGN KEY (featureofinteresttypeid) REFERENCES featureofinteresttype(featureofinteresttypeid);


--
-- Name: offeringobservationtypefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY offeringallowedobservationtype
    ADD CONSTRAINT offeringobservationtypefk FOREIGN KEY (observationtypeid) REFERENCES observationtype(observationtypeid);


--
-- Name: offeringrelatedfeaturefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY offeringhasrelatedfeature
    ADD CONSTRAINT offeringrelatedfeaturefk FOREIGN KEY (relatedfeatureid) REFERENCES relatedfeature(relatedfeatureid);


--
-- Name: proccodespaceidentifierfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY procedure
    ADD CONSTRAINT proccodespaceidentifierfk FOREIGN KEY (codespace) REFERENCES codespace(codespaceid);


--
-- Name: proccodespacenamefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY procedure
    ADD CONSTRAINT proccodespacenamefk FOREIGN KEY (codespacename) REFERENCES codespace(codespaceid);


--
-- Name: procedurechildfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY sensorsystem
    ADD CONSTRAINT procedurechildfk FOREIGN KEY (childsensorid) REFERENCES procedure(procedureid);


--
-- Name: procedureparenffk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY sensorsystem
    ADD CONSTRAINT procedureparenffk FOREIGN KEY (parentsensorid) REFERENCES procedure(procedureid);


--
-- Name: procprocdescformatfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY procedure
    ADD CONSTRAINT procprocdescformatfk FOREIGN KEY (proceduredescriptionformatid) REFERENCES proceduredescriptionformat(proceduredescriptionformatid);


--
-- Name: relatedfeatrelatedfeatrolefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY relatedfeaturehasrole
    ADD CONSTRAINT relatedfeatrelatedfeatrolefk FOREIGN KEY (relatedfeatureroleid) REFERENCES relatedfeaturerole(relatedfeatureroleid);


--
-- Name: relatedfeaturefeaturefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY relatedfeature
    ADD CONSTRAINT relatedfeaturefeaturefk FOREIGN KEY (featureofinterestid) REFERENCES featureofinterest(featureofinterestid);


--
-- Name: relatedfeatureofferingfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY offeringhasrelatedfeature
    ADD CONSTRAINT relatedfeatureofferingfk FOREIGN KEY (offeringid) REFERENCES offering(offeringid);


--
-- Name: resulttemplatefeatureidx; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY resulttemplate
    ADD CONSTRAINT resulttemplatefeatureidx FOREIGN KEY (featureofinterestid) REFERENCES featureofinterest(featureofinterestid);


--
-- Name: resulttemplateobspropfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY resulttemplate
    ADD CONSTRAINT resulttemplateobspropfk FOREIGN KEY (observablepropertyid) REFERENCES observableproperty(observablepropertyid);


--
-- Name: resulttemplateofferingidx; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY resulttemplate
    ADD CONSTRAINT resulttemplateofferingidx FOREIGN KEY (offeringid) REFERENCES offering(offeringid);


--
-- Name: resulttemplateprocedurefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY resulttemplate
    ADD CONSTRAINT resulttemplateprocedurefk FOREIGN KEY (procedureid) REFERENCES procedure(procedureid);


--
-- Name: seriesfeaturefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY series
    ADD CONSTRAINT seriesfeaturefk FOREIGN KEY (featureofinterestid) REFERENCES featureofinterest(featureofinterestid);


--
-- Name: seriesobpropfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY series
    ADD CONSTRAINT seriesobpropfk FOREIGN KEY (observablepropertyid) REFERENCES observableproperty(observablepropertyid);


--
-- Name: seriesprocedurefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY series
    ADD CONSTRAINT seriesprocedurefk FOREIGN KEY (procedureid) REFERENCES procedure(procedureid);


--
-- Name: seriesunitfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY series
    ADD CONSTRAINT seriesunitfk FOREIGN KEY (unitid) REFERENCES unit(unitid);


--
-- Name: sfpcodespaceidentifierfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY spatialfilteringprofile
    ADD CONSTRAINT sfpcodespaceidentifierfk FOREIGN KEY (codespace) REFERENCES codespace(codespaceid);


--
-- Name: sfpcodespacenamefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY spatialfilteringprofile
    ADD CONSTRAINT sfpcodespacenamefk FOREIGN KEY (codespacename) REFERENCES codespace(codespaceid);


--
-- Name: sfpobservationfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY spatialfilteringprofile
    ADD CONSTRAINT sfpobservationfk FOREIGN KEY (observation) REFERENCES observation(observationid);


--
-- Name: validproceduretimeprocedurefk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY validproceduretime
    ADD CONSTRAINT validproceduretimeprocedurefk FOREIGN KEY (procedureid) REFERENCES procedure(procedureid);


--
-- Name: validprocprocdescformatfk; Type: FK CONSTRAINT; Schema: sos; Owner: sensors
--

ALTER TABLE ONLY validproceduretime
    ADD CONSTRAINT validprocprocdescformatfk FOREIGN KEY (proceduredescriptionformatid) REFERENCES proceduredescriptionformat(proceduredescriptionformatid);


--
-- PostgreSQL database dump complete
--
