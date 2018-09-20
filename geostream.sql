--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: datapoints; Type: TABLE; Schema: public; Owner: clowder
--

CREATE TABLE datapoints (
    gid integer NOT NULL,
    geog geography,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    data json,
    stream_id integer,
    created timestamp with time zone
);


ALTER TABLE datapoints OWNER TO clowder;

--
-- Name: geoindex_gid_seq; Type: SEQUENCE; Schema: public; Owner: clowder
--

CREATE SEQUENCE geoindex_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE geoindex_gid_seq OWNER TO clowder;

--
-- Name: geoindex_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clowder
--

ALTER SEQUENCE geoindex_gid_seq OWNED BY datapoints.gid;


--
-- Name: sensors; Type: TABLE; Schema: public; Owner: clowder
--

CREATE TABLE sensors (
    gid integer NOT NULL,
    name character varying(255),
    geog geography,
    created timestamp with time zone,
    metadata json
);


ALTER TABLE sensors OWNER TO clowder;

--
-- Name: sensors_gid_seq; Type: SEQUENCE; Schema: public; Owner: clowder
--

CREATE SEQUENCE sensors_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE sensors_gid_seq OWNER TO clowder;

--
-- Name: sensors_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clowder
--

ALTER SEQUENCE sensors_gid_seq OWNED BY sensors.gid;


--
-- Name: streams; Type: TABLE; Schema: public; Owner: clowder
--

CREATE TABLE streams (
    gid integer NOT NULL,
    name character varying(255),
    geog geography,
    created timestamp with time zone,
    metadata json,
    sensor_id integer,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    params text[]
);


ALTER TABLE streams OWNER TO clowder;

--
-- Name: streams_gid_seq; Type: SEQUENCE; Schema: public; Owner: clowder
--

CREATE SEQUENCE streams_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE streams_gid_seq OWNER TO clowder;

--
-- Name: streams_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clowder
--

ALTER SEQUENCE streams_gid_seq OWNED BY streams.gid;


-- Name: bins_year; Type: TABLE; Schema: public; Owner: clowder
--

CREATE TABLE bins_year (
  sensor_id integer NOT NULL,
  yyyy integer,
  parameter character varying(255),
  datapoint_count integer,
  sum float8,
  average float8,
  start_time timestamp with time zone,
  end_time timestamp with time zone,
  updated timestamp with time zone,
  PRIMARY KEY (sensor_id, yyyy, parameter)
);


ALTER TABLE bins_year OWNER TO clowder;


-- Name: bins_month; Type: TABLE; Schema: public; Owner: clowder
--

CREATE TABLE bins_month (
  sensor_id integer NOT NULL,
  yyyy integer,
  mm integer,
  parameter character varying(255),
  datapoint_count integer,
  sum float8,
  average float8,
  start_time timestamp with time zone,
  end_time timestamp with time zone,
  updated timestamp with time zone,
  PRIMARY KEY (sensor_id, yyyy, mm, parameter)
);


ALTER TABLE bins_month OWNER TO clowder;


-- Name: bins_hour; Type: TABLE; Schema: public; Owner: clowder
--

CREATE TABLE bins_day (
  sensor_id integer NOT NULL,
  yyyy integer,
  mm integer,
  dd integer,
  parameter character varying(255),
  datapoint_count integer,
  sum float8,
  average float8,
  start_time timestamp with time zone,
  end_time timestamp with time zone,
  updated timestamp with time zone,
  PRIMARY KEY (sensor_id, yyyy, mm, dd, parameter)
);


ALTER TABLE bins_day OWNER TO clowder;


-- Name: bins_hour; Type: TABLE; Schema: public; Owner: clowder
--

CREATE TABLE bins_hour (
  sensor_id integer NOT NULL,
  yyyy integer,
  mm integer,
  dd integer,
  hh integer,
  parameter character varying(255),
  datapoint_count integer,
  sum float8,
  average float8,
  start_time timestamp with time zone,
  end_time timestamp with time zone,
  updated timestamp with time zone,
  PRIMARY KEY (sensor_id, yyyy, mm, dd, hh, parameter)
);


ALTER TABLE bins_hour OWNER TO clowder;

-- Name: bins_season; Type: TABLE; Schema: public; Owner: clowder
--

CREATE TABLE bins_season (
  sensor_id integer NOT NULL,
  yyyy integer,
  season character varying(10),
  parameter character varying(255),
  datapoint_count integer,
  sum float8,
  average float8,
  start_time timestamp with time zone,
  end_time timestamp with time zone,
  updated timestamp with time zone,
  PRIMARY KEY (sensor_id, yyyy, season, parameter)
);


ALTER TABLE bins_season OWNER TO clowder;

--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: clowder
--

ALTER TABLE ONLY datapoints ALTER COLUMN gid SET DEFAULT nextval('geoindex_gid_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: clowder
--

ALTER TABLE ONLY sensors ALTER COLUMN gid SET DEFAULT nextval('sensors_gid_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: clowder
--

ALTER TABLE ONLY streams ALTER COLUMN gid SET DEFAULT nextval('streams_gid_seq'::regclass);


--
-- Name: geoindex_pkey; Type: CONSTRAINT; Schema: public; Owner: clowder
--

ALTER TABLE ONLY datapoints
ADD CONSTRAINT geoindex_pkey PRIMARY KEY (gid);


--
-- Name: sensors_pkey; Type: CONSTRAINT; Schema: public; Owner: clowder
--

ALTER TABLE ONLY sensors
ADD CONSTRAINT sensors_pkey PRIMARY KEY (gid);


--
-- Name: streams_pkey; Type: CONSTRAINT; Schema: public; Owner: clowder
--

ALTER TABLE ONLY streams
ADD CONSTRAINT streams_pkey PRIMARY KEY (gid);


--
-- Name: geoindex_gix; Type: INDEX; Schema: public; Owner: clowder
--

CREATE INDEX geoindex_gix ON datapoints USING gist (geog);


--
-- Name: geoindex_stream_id; Type: INDEX; Schema: public; Owner: clowder
--

CREATE INDEX geoindex_stream_id ON datapoints USING btree (stream_id);


--
-- Name: geoindex_times; Type: INDEX; Schema: public; Owner: clowder
--

CREATE INDEX geoindex_times ON datapoints USING btree (start_time, end_time);


--
-- Name: sensors_gix; Type: INDEX; Schema: public; Owner: clowder
--

CREATE INDEX sensors_gix ON sensors USING gist (geog);


--
-- Name: streams_gix; Type: INDEX; Schema: public; Owner: clowder
--

CREATE INDEX streams_gix ON streams USING gist (geog);


--
-- Name: streams_sensor_id; Type: INDEX; Schema: public; Owner: clowder
--

CREATE INDEX streams_sensor_id ON streams USING btree (sensor_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO clowder;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: datapoints; Type: ACL; Schema: public; Owner: clowder
--

REVOKE ALL ON TABLE datapoints FROM PUBLIC;
REVOKE ALL ON TABLE datapoints FROM clowder;
GRANT ALL ON TABLE datapoints TO clowder;


--
-- Name: geoindex_gid_seq; Type: ACL; Schema: public; Owner: clowder
--

REVOKE ALL ON SEQUENCE geoindex_gid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE geoindex_gid_seq FROM clowder;
GRANT ALL ON SEQUENCE geoindex_gid_seq TO clowder;


--
-- Name: sensors; Type: ACL; Schema: public; Owner: clowder
--

REVOKE ALL ON TABLE sensors FROM PUBLIC;
REVOKE ALL ON TABLE sensors FROM clowder;
GRANT ALL ON TABLE sensors TO clowder;


--
-- Name: sensors_gid_seq; Type: ACL; Schema: public; Owner: clowder
--

REVOKE ALL ON SEQUENCE sensors_gid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE sensors_gid_seq FROM clowder;
GRANT ALL ON SEQUENCE sensors_gid_seq TO clowder;


--
-- Name: streams; Type: ACL; Schema: public; Owner: clowder
--

REVOKE ALL ON TABLE streams FROM PUBLIC;
REVOKE ALL ON TABLE streams FROM clowder;
GRANT ALL ON TABLE streams TO clowder;


--
-- Name: streams_gid_seq; Type: ACL; Schema: public; Owner: clowder
--

REVOKE ALL ON SEQUENCE streams_gid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE streams_gid_seq FROM clowder;
GRANT ALL ON SEQUENCE streams_gid_seq TO clowder;

--
-- Name: users; Type: TABLE; Schema: public; Owner: clowder
--

CREATE TABLE users (
      gid integer default nextval('geoindex_gid_seq'::regclass) PRIMARY KEY,
      email varchar(40) NOT NULL,
      emailConfirmed boolean,
      password varchar(80) NOT NULL,
      first_name varchar(20) NOT NULL,
      last_name varchar(20) NOT NULL,
      organization varchar(80) NOT NULL,
      services varchar(60) NOT NULL
);

ALTER TABLE users OWNER TO clowder;

--
-- Name: events; Type: TABLE; Schema: public; Owner: clowder
--

CREATE TABLE events (
      gid integer default nextval('geoindex_gid_seq'::regclass) PRIMARY KEY,
      userid integer REFERENCES users (gid),
      sources varchar(50),
      attributes varchar(200),
      geocode varchar(2000),
      since varchar(50),
      until varchar(50),
      purpose varchar(1000),
      downloaddate timestamp with time zone
);

ALTER TABLE events OWNER TO clowder;


-- need to be postgres user to do this
-- can list casts with \dC
create or replace function cast_to_double(text) returns DOUBLE PRECISION as $$
begin
  -- Note the double casting to avoid infinite recursion.
  return cast($1::varchar as DOUBLE PRECISION);
  exception
  when invalid_text_representation then
    return 0.0;
end;
$$ language plpgsql immutable;
create cast (text as DOUBLE PRECISION) with function cast_to_double(text);



--
-- Name: regions; Type: TABLE; Schema: public; Owner: clowder
-- id is not integer, it's short name like 'su'.
-- boundary & center_coordinate is not used currently
--
CREATE TABLE regions(
      id varchar(10) PRIMARY KEY,
      title varchar(50),
      boundary geography,
      center_coordinate geography
);

ALTER TABLE regions OWNER TO clowder;

--
-- Name: region_trends; Type: TABLE; Schema: public; Owner: clowder
--

CREATE TABLE region_trends(
      region_id varchar(10) REFERENCES regions(id),
      season varchar(8),
      parameter varchar(200),
      lastaverage float8,
      tenyearsaverage float8,
      totalaverage float8,
      PRIMARY KEY (region_id, season, parameter)
);

ALTER TABLE region_trends OWNER TO clowder;

CREATE TABLE parameters
(
    gid integer default nextval('geoindex_gid_seq' :: regclass) not null
    constraint parameters_pkey
    primary key,
    name         varchar(50) not null,
    title        varchar(100),
    unit         varchar(20),
    search_view  boolean default true,
    explore_view boolean default true,
    scale_names  varchar(250),
    scale_colors varchar(100)
);

CREATE UNIQUE index parameters_gid_uindex
  on parameters (gid);

CREATE UNIQUE index parameters_name_uindex
  on parameters (name);

ALTER TABLE parameters OWNER TO clowder;

CREATE TABLE categories
(
    gid integer default nextval('geoindex_gid_seq' :: regclass) not null
    constraint categories_pkey
    primary key,
    name varchar(50),
    detail_type varchar(50)
);

CREATE UNIQUE index categories_id_uindex
  on categories (gid);

ALTER TABLE categories OWNER TO clowder;

CREATE TABLE parameter_categories
(
    gid integer default nextval('geoindex_gid_seq' :: regclass) not null
    constraint parameter_categories_pkey
    primary key,
    parameter_gid integer not null
    constraint parameter_fk
    references parameters,
    category_gid  integer not null
    constraint categories_fk
    references categories
);

ALTER TABLE parameter_categories OWNER TO clowder;

--
-- PostgreSQL database dump complete
--
