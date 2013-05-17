INSERT /*+direct*/ INTO fact_events
(
SELECT fe.*
FROM (
SELECT MAX(id) AS event_property_id,
       event_id,
       MAX(application) AS application,
       MAX(event_name)  AS event_name,
       MAX(occurred_at) AS occurred_at,
       MAX(CASE property_name WHEN 'network_id'  THEN property_value ELSE null END)::bigint AS network_id,
       MAX(CASE property_name WHEN 'user_id'     THEN property_value ELSE null END)::bigint AS user_id,
       MAX(CASE property_name WHEN 'session_id'  THEN SUBSTRING(property_value,1,128) ELSE null END)      AS session_id,
       MAX(CASE property_name WHEN 'client_id'   THEN property_value ELSE null END)::bigint AS client_id,
       MAX(CASE property_name WHEN 'controller'  THEN property_value ELSE null END)      AS controller,
       MAX(CASE property_name WHEN 'action'      THEN property_value ELSE null END)      AS action,
       MAX(CASE property_name WHEN 'id_param'    THEN SUBSTRING(property_value,1,128) ELSE null END)      AS param_id,
       MAX(CASE property_name WHEN 'user_agent'  THEN property_value ELSE null END)      AS user_agent,
       MAX(CASE property_name WHEN 'http_method' THEN property_value ELSE null END)      AS http_method,
       --INET_ATON(MAX(CASE property_name WHEN 'ip_address'  THEN property_value ELSE null END)) AS ip_integer
       1
  FROM event_properties ep
 WHERE (
        (property_name IN ('network_id','user_id','client_id') ) --AND REGEXP_LIKE(property_value, '^\d+$'))
        OR property_name IN ('session_id','controller','action','id_param','user_agent','http_method','ip_address')
       )
   AND property_value NOT IN ('nil','null')
   AND application IN('web-prod','web-backstage')
   AND id > 0
   AND occurred_at >= '2012-06-01' and occurred_at < '2012-06-02'
   AND event_id IS NOT NULL
 GROUP BY event_id
) fe
);
