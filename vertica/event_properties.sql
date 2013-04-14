CREATE PROJECTION public.event_properties_4_v1
(
 id,
 event_id,
 application ENCODING RLE,
 event_name ENCODING RLE,
 occurred_at ENCODING COMMONDELTA_COMP,
 property_name,
 property_value
)
AS
 SELECT event_properties.id,
        event_properties.event_id,
        event_properties.application,
        event_properties.event_name,
        event_properties.occurred_at,
        event_properties.property_name,
        event_properties.property_value
 FROM public.event_properties event_properties
 ORDER BY event_properties.id,
          event_properties.event_name,
          event_properties.application,
          event_properties.occurred_at
SEGMENTED BY hash(event_properties.event_id) ALL NODES ;

CREATE PROJECTION public.event_properties_5_v1
(
 id,
 event_id,
 application ENCODING RLE,
 event_name ENCODING RLE,
 occurred_at ENCODING COMMONDELTA_COMP,
 property_name,
 property_value
)
AS
 SELECT event_properties.id,
        event_properties.event_id,
        event_properties.application,
        event_properties.event_name,
        event_properties.occurred_at,
        event_properties.property_name,
        event_properties.property_value
 FROM public.event_properties event_properties
 ORDER BY event_properties.event_name,
          event_properties.application,
          event_properties.id,
          event_properties.occurred_at
SEGMENTED BY hash(event_properties.event_id) ALL NODES OFFSET 1;
