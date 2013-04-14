CREATE TABLE public.fact_events
(
    event_property_id int NOT NULL,
    event_id binary(36) NOT NULL,
    application varchar(128),
    event_name varchar(128),
    occurred_at timestamp NOT NULL,
    network_id int,
    user_id int,
    session_id varchar(128),
    client_id int,
    controller varchar(128),
    action varchar(128),
    param_id varchar(128),
    user_agent varchar(512),
    http_method varchar(128),
    ip_integer int
)
PARTITION BY (date_trunc('month', fact_events.occurred_at));

ALTER TABLE public.fact_events ADD CONSTRAINT C_PRIMARY PRIMARY KEY (event_id); 


CREATE PROJECTION public.fact_events_2_new_b0
(
 event_property_id,
 event_id,
 application ENCODING RLE,
 event_name ENCODING RLE,
 occurred_at ENCODING DELTAVAL,
 network_id ENCODING RLE,
 user_id ENCODING DELTAVAL,
 session_id,
 client_id ENCODING RLE,
 controller ENCODING RLE,
 action ENCODING RLE,
 param_id ENCODING RLE,
 user_agent,
 http_method ENCODING RLE,
 ip_integer
)
AS
 SELECT fact_events.event_property_id,
        fact_events.event_id,
        fact_events.application,
        fact_events.event_name,
        fact_events.occurred_at,
        fact_events.network_id,
        fact_events.user_id,
        fact_events.session_id,
        fact_events.client_id,
        fact_events.controller,
        fact_events.action,
        fact_events.param_id,
        fact_events.user_agent,
        fact_events.http_method,
        fact_events.ip_integer
 FROM public.fact_events
 ORDER BY fact_events.event_name,
          fact_events.application,
          fact_events.controller,
          fact_events.action,
          fact_events.client_id,
          fact_events.network_id,
          fact_events.http_method,
          fact_events.param_id,
          fact_events.occurred_at
SEGMENTED BY hash(fact_events.event_id) ALL NODES ;

CREATE PROJECTION public.fact_events_2_new_b1
(
 event_property_id,
 event_id,
 application ENCODING RLE,
 event_name ENCODING RLE,
 occurred_at ENCODING DELTAVAL,
 network_id ENCODING RLE,
 user_id ENCODING DELTAVAL,
 session_id,
 client_id ENCODING RLE,
 controller ENCODING RLE,
 action ENCODING RLE,
 param_id ENCODING RLE,
 user_agent,
 http_method ENCODING RLE,
 ip_integer
)
AS
 SELECT fact_events.event_property_id,
        fact_events.event_id,
        fact_events.application,
        fact_events.event_name,
        fact_events.occurred_at,
        fact_events.network_id,
        fact_events.user_id,
        fact_events.session_id,
        fact_events.client_id,
        fact_events.controller,
        fact_events.action,
        fact_events.param_id,
        fact_events.user_agent,
        fact_events.http_method,
        fact_events.ip_integer
 FROM public.fact_events
 ORDER BY fact_events.event_name,
          fact_events.application,
          fact_events.controller,
          fact_events.action,
          fact_events.client_id,
          fact_events.network_id,
          fact_events.http_method,
          fact_events.param_id,
          fact_events.occurred_at
SEGMENTED BY hash(fact_events.event_id) ALL NODES OFFSET 1;

CREATE PROJECTION public.fact_events_P3_v1
(
 application ENCODING RLE,
 event_name ENCODING RLE,
 occurred_at,
 user_id ENCODING DELTAVAL,
 network_id ENCODING DELTAVAL,
 controller ENCODING RLE,
 action ENCODING RLE,
 client_id ENCODING RLE
)
AS
 SELECT fact_events.application,
        fact_events.event_name,
        fact_events.occurred_at,
        fact_events.user_id,
        fact_events.network_id,
        fact_events.controller,
        fact_events.action,
        fact_events.client_id
 FROM public.fact_events
 ORDER BY fact_events.application,
          fact_events.event_name,
          fact_events.controller,
          fact_events.action,
          fact_events.client_id
SEGMENTED BY hash(fact_events.network_id, fact_events.user_id) ALL NODES ;

CREATE PROJECTION public.fact_events_P4_v1
(
 application ENCODING RLE,
 event_name ENCODING RLE,
 occurred_at,
 user_id ENCODING DELTAVAL,
 network_id ENCODING DELTAVAL,
 controller ENCODING RLE,
 action ENCODING RLE,
 client_id ENCODING RLE
)
AS
 SELECT fact_events.application,
        fact_events.event_name,
        fact_events.occurred_at,
        fact_events.user_id,
        fact_events.network_id,
        fact_events.controller,
        fact_events.action,
        fact_events.client_id
 FROM public.fact_events
 ORDER BY fact_events.application,
          fact_events.event_name,
          fact_events.controller,
          fact_events.action,
          fact_events.client_id
SEGMENTED BY hash(fact_events.network_id, fact_events.user_id) ALL NODES OFFSET 1;
