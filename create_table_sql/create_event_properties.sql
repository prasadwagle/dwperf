CREATE TABLE event_properties
(
    id bigint,
    event_id  varchar(128),
    application varchar(128),
    event_name varchar(128),
    occurred_at timestamp NOT NULL,
    property_name varchar(128),
    property_value varchar(512)
);
