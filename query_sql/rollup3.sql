SELECT drp.period_id, drp.time_id,
           'all' AS cohort_type,
           'all' AS cohort,
            e1.engaged_users,
            e1.engaged_meta_users,
            e1.engaged_networks,
            m1.posters,
            m1.messages,
            m1.active_groups
      FROM dimension_rollup_periods drp
      LEFT JOIN (SELECT drp1.period_id, drp1.time_id,
                        COUNT(DISTINCT engagements.user_id) AS engaged_users,
                        COUNT(DISTINCT users.meta_user_id) AS engaged_meta_users,
                        COUNT(DISTINCT users.network_id) AS engaged_networks
                   FROM dimension_rollup_periods drp1
                   JOIN fact_events engagements
                     ON engagements.occurred_at >= drp1.begin_time
                    AND engagements.occurred_at <  drp1.end_time
                    AND engagements.application IN('web-prod','web-backstage') 
                    AND engagements.occurred_at >= TO_TIMESTAMP( '2012-06-03', 'YYYY-MM-DD HH24:MI:SS' )
                    AND engagements.occurred_at <= TO_TIMESTAMP( '2012-06-04', 'YYYY-MM-DD HH24:MI:SS' )
                   LEFT JOIN dimension_users users
                     ON engagements.user_id = users.user_id
                    AND engagements.network_id = users.network_id
                  WHERE drp1.period_id = 2001
                    AND drp1.time_id >= TO_TIMESTAMP( '2012-06-03', 'YYYY-MM-DD HH24:MI:SS' )
                    AND drp1.time_id <= TO_TIMESTAMP( '2012-06-04', 'YYYY-MM-DD HH24:MI:SS' )
                  GROUP BY drp1.period_id, drp1.time_id )e1
        ON e1.time_id = drp.time_id
      LEFT JOIN (SELECT drp2.period_id, drp2.time_id,
                        COUNT(DISTINCT m.sender_id) AS posters,
                        COUNT(DISTINCT m.message_id) AS messages,
                        COUNT(DISTINCT m.group_id) AS active_groups          
                   FROM dimension_rollup_periods drp2
                   JOIN dimension_messages m
                     ON m.message_type IN (0, 4)
                    AND m.client_type_id NOT IN (112, 142)
                    AND m.created_at >= drp2.begin_time
                    AND m.created_at <  drp2.end_time
                    AND m.created_at >= TO_TIMESTAMP( '2012-06-03', 'YYYY-MM-DD HH24:MI:SS' )
                    AND m.created_at <= TO_TIMESTAMP( '2012-06-04', 'YYYY-MM-DD HH24:MI:SS' )
                  WHERE drp2.period_id = 2001
                    AND drp2.time_id >= TO_TIMESTAMP( '2012-06-03', 'YYYY-MM-DD HH24:MI:SS' )
                    AND drp2.time_id <= TO_TIMESTAMP( '2012-06-04', 'YYYY-MM-DD HH24:MI:SS' )
                  GROUP BY drp2.period_id, drp2.time_id) m1
        ON m1.time_id = drp.time_id
     WHERE drp.period_id = 2001
       AND drp.time_id >= TO_TIMESTAMP( '2012-06-03', 'YYYY-MM-DD HH24:MI:SS' )
       AND drp.time_id <= TO_TIMESTAMP( '2012-06-04', 'YYYY-MM-DD HH24:MI:SS' )
;
