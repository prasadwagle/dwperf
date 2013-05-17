Create table fact_events
WITH (distribution = Hash (event_id)
, CLUSTERED INDEX (occurred_at)
, partition ([occurred_at] Range Right For Values
(
'May 29 2012', 'May 30 2012', 'May 31 2012', 'Jun 01 2012', 'Jun 02 2012', 'Jun 03 2012', 'Jun 04 2012', 'Jun 05 2012', 'Jun 06 2012', 'Jun 07 2012', 'Jun 08 2012', 'Jun 09 2012', 'Jun 10 2012',
'Jun 11 2012', 'Jun 12 2012', 'Jun 13 2012', 'Jun 14 2012', 'Jun 15 2012', 'Jun 16 2012', 'Jun 17 2012', 'Jun 18 2012', 'Jun 19 2012', 'Jun 20 2012', 'Jun 21 2012', 'Jun 22 2012', 'Jun 23 2012',
'Jun 24 2012', 'Jun 25 2012', 'Jun 26 2012', 'Jun 27 2012', 'Jun 28 2012', 'Jun 29 2012', 'Jun 30 2012', 'Jul 01 2012', 'Jul 02 2012', 'Jul 03 2012', 'Jul 04 2012', 'Jul 05 2012', 'Jul 06 2012',
'Jul 07 2012', 'Jul 08 2012', 'Jul 09 2012', 'Jul 10 2012', 'Jul 11 2012', 'Jul 12 2012', 'Jul 13 2012', 'Jul 14 2012', 'Jul 15 2012', 'Jul 16 2012', 'Jul 17 2012', 'Jul 18 2012', 'Jul 19 2012',
'Jul 20 2012', 'Jul 21 2012', 'Jul 22 2012', 'Jul 23 2012', 'Jul 24 2012', 'Jul 25 2012', 'Jul 26 2012', 'Jul 27 2012', 'Jul 28 2012', 'Jul 29 2012', 'Jul 30 2012', 'Jul 31 2012', 'Aug 01 2012',
'Aug 02 2012', 'Aug 03 2012', 'Aug 04 2012', 'Aug 05 2012'
)))
AS
SELECT
event_property_id
,event_id
,application
,event_name
,occurred_at
,network_id
,[user_id]
,[session_id]
,client_id
,controller
,[action]
,param_id
,user_agent
,http_method
,CASE WHEN RIGHT(Ip_address, 1) = '.' OR LEFT(Ip_address, 1) = '.' THEN NULL ELSE
                CASE WHEN ISNUMERIC (REPLACE(IP_Address, '.','')) = 1 THEN
                                CASE WHEN PATINDEX('[0-9]%.[0-9]%.[0-9]%.[0-9]%',IP_Address) != 1  THEN NULL ELSE
                                                (CONVERT(BIGINT, LEFT(IP_Address, CHARINDEX('.', IP_Address) - 1)) * 16777216)
                                + (CONVERT(BIGINT, LEFT(RIGHT(IP_Address, LEN(IP_Address) - CHARINDEX('.', IP_Address)), CHARINDEX('.', RIGHT(IP_Address, LEN(IP_Address) - CHARINDEX('.', IP_Address))) - 1)) * 65536)
                                + (CONVERT(BIGINT, LEFT(RIGHT(IP_Address, LEN(RIGHT(IP_Address, LEN(IP_Address) - CHARINDEX('.', IP_Address))) - CHARINDEX('.', RIGHT(IP_Address, LEN(IP_Address) - CHARINDEX('.', IP_Address)))), CHARINDEX('.', RIGHT(IP_Address, LEN(RIGHT(IP_Address, LEN(IP_Address) - CHARINDEX('.', IP_Address))) - CHARINDEX('.', RIGHT(IP_Address, LEN(IP_Address) - CHARINDEX('.', IP_Address))))) - 1)) * 256)
                                + CONVERT(BIGINT, RIGHT(IP_Address, LEN(RIGHT(IP_Address, LEN(RIGHT(IP_Address, LEN(IP_Address) - CHARINDEX('.', IP_Address))) - CHARINDEX('.', RIGHT(IP_Address, LEN(IP_Address) - CHARINDEX('.', IP_Address))))) - CHARINDEX('.', RIGHT(IP_Address, LEN(RIGHT(IP_Address, LEN(IP_Address) - CHARINDEX('.', IP_Address))) - CHARINDEX('.', RIGHT(IP_Address, LEN(IP_Address) - CHARINDEX('.', IP_Address)))))))
END
ELSE NULL END
END
as ip_integer
FROM (
SELECT MAX(id) AS event_property_id,
       event_id,
MAX(application) AS application,
MAX(event_name)  AS event_name,
MAX(occurred_at) AS occurred_at,
CONVERT (BIGINT, (MAX(CASE property_name WHEN 'network_id'  THEN property_value ELSE null END))) AS network_id,
CONVERT (BIGINT, (MAX(CASE property_name WHEN 'user_id'     THEN property_value ELSE null END))) AS user_id,
MAX(CASE property_name WHEN 'session_id'  THEN SUBSTRING(property_value,1,128) ELSE null END)      AS session_id,
CONVERT (BIGINT, (MAX(CASE property_name WHEN 'client_id'   THEN property_value ELSE null END))) AS client_id,
MAX(CASE property_name WHEN 'controller'  THEN property_value ELSE null END)      AS controller,
MAX(CASE property_name WHEN 'action'      THEN property_value ELSE null END)      AS action,
MAX(CASE property_name WHEN 'id_param'    THEN SUBSTRING(property_value,1,128) ELSE null END)      AS param_id,
MAX(CASE property_name WHEN 'user_agent'  THEN property_value ELSE null END)      AS user_agent,
MAX(CASE property_name WHEN 'http_method' THEN property_value ELSE null END)      AS http_method ,
MAX(CASE property_name WHEN 'ip_address'  THEN property_value ELSE null END) AS ip_address
  FROM YammerDW.dbo.event_properties ep
WHERE (
        (property_name IN ('network_id','user_id','client_id') AND ISNUMERIC(property_value) = 1)
        OR property_name IN ('session_id','controller','action','id_param','user_agent','http_method','ip_address')
       )
   AND property_value NOT IN ('nil','null')
   AND application IN('web-prod','web-backstage')
   AND id > 0
   --AND occurred_at > sysdate() - interval '1 week'
   --AND occurred_at = '07/24/2012'
   AND event_id IS NOT NULL
GROUP BY event_id
) fe
WHERE fe.network_id NOT IN((SELECT network_id FROM dimension_reserved_networks))
;