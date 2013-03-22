CREATE TABLE fact_events (
      event_property_id bigint NOT NULL,
      event_id varchar(128) NOT NULL,
      application varchar(128),
      event_name varchar(128),
      occurred_at timestamp,
      network_id int,
      user_id int,
      session_id varchar(128),
      client_id int,
      controller varchar(512),
      "action" varchar(512),
      param_id varchar(512),
      user_agent varchar(512),
      http_method varchar(512),
      ip_integer int,
      PRIMARY KEY (event_id)
    );
