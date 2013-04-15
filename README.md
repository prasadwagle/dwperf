dwperf: Data Warehouse Performance Benchmark
============================================

Recently there has been a spate of data warehouse solutions for "Big Data" analytics. However, there isn't a standard way
to compare these solutions using a realistic workload. This project is an attempt at creating a benchmark for 
data warehouse query performance. We use queries and data that are used at Yammer.
The data set size is around 10 TB and the largest table contains around 100 billion rows.

Benchmark Details
=================
The event_properties table has around 100 billion rows.
The data set size is around 10 TB.
event_properties is transformed to fact_events using load_fact_events.
fact_events is joined with dimension tables in the rollup query.

Results (VERY PRELIMINARY)
==========================
These are VERY PRELIMINARY results since we haven't explored all the optimization strategies for some of the systems.

https://docs.google.com/a/yammer-inc.com/spreadsheet/ccc?key=0Aj1dTJ0aW5ETdDRiRXEwaU5JYmZ4RWxoSXlaWmhuTHc#gid=0

Todo
====
1. Currently the data set is Yammer proprietary information. We need to figure out a way to obfuscate 
sensitive fields so we can release the data set to the public domain.

2. Add system details (hardware and software configuration, optimizations) for every result.

3. Explore reasonable optimization opportunities to improve benchmark performance.

4. Add more complex analytics queries.

5. Benchmark Hadoop and Cosmos.


Queries and Output
==================

<pre>

Command to load event_properties.2012-06-01-2012-06-02.gz which is around 25 GB and contains around 2 billion rows: 

cat event_properties.2012-06-01-2012-06-02.gz | vsql -U yammer_rw -w yamittome -c "copy event_properties from stdin gzip direct delimiter E'\001' record terminator E'\002' no escape null 'NIL#'"


dbadmin=> select count(1) from event_properties;
    count    
-------------
 96816257433
(1 row)

Time: First fetch (1 row): 3138.082 ms. All rows formatted: 3138.122 ms
dbadmin=> select date_trunc('day', occurred_at), count(1)
dbadmin-> from event_properties
dbadmin-> group by 1
dbadmin-> order by 1;
     date_trunc      |   count    
---------------------+------------
 2012-06-01 00:00:00 | 2128283364
 2012-06-02 00:00:00 |  786202822
 2012-06-03 00:00:00 |  771174399
 2012-06-04 00:00:00 | 2047682811
 2012-06-05 00:00:00 | 2186160046
 2012-06-06 00:00:00 | 2293550833
 2012-06-07 00:00:00 | 2305821360
 2012-06-08 00:00:00 | 2117336749
 2012-06-09 00:00:00 |  762954404
 2012-06-10 00:00:00 |  712545950
 2012-06-11 00:00:00 | 1934659777
 2012-06-12 00:00:00 | 2150945458
 2012-06-13 00:00:00 | 2117833975
 2012-06-14 00:00:00 | 2179765460
 2012-06-15 00:00:00 | 2071390882
 2012-06-16 00:00:00 |  793366040
 2012-06-17 00:00:00 |  753412686
 2012-06-18 00:00:00 | 2089274582
 2012-06-19 00:00:00 | 2230808823
 2012-06-20 00:00:00 | 2259301916
 2012-06-21 00:00:00 | 2209921539
 2012-06-22 00:00:00 | 2026312863
 2012-06-23 00:00:00 |  678576339
 2012-06-24 00:00:00 |  646416104
 2012-06-25 00:00:00 | 1754212844
 2012-06-26 00:00:00 | 1998713950
 2012-06-27 00:00:00 | 2039776294
 2012-06-28 00:00:00 | 2008367602
 2012-06-29 00:00:00 | 1787510837
 2012-06-30 00:00:00 |  781284899
 2012-07-01 00:00:00 |  776039128
 2012-07-02 00:00:00 | 1822697805
 2012-07-03 00:00:00 | 1907170086
 2012-07-04 00:00:00 | 1556436652
 2012-07-05 00:00:00 | 1746278097
 2012-07-06 00:00:00 | 1666958550
 2012-07-07 00:00:00 |  723035112
 2012-07-08 00:00:00 |  717321217
 2012-07-09 00:00:00 | 1726706618
 2012-07-10 00:00:00 | 1833922180
 2012-07-11 00:00:00 | 1801778627
 2012-07-12 00:00:00 | 1790164248
 2012-07-13 00:00:00 | 1636045984
 2012-07-14 00:00:00 |  762452480
 2012-07-15 00:00:00 |  723488484
 2012-07-16 00:00:00 | 1687597299
 2012-07-17 00:00:00 | 1894090811
 2012-07-18 00:00:00 | 1954666371
 2012-07-19 00:00:00 | 1921733172
 2012-07-20 00:00:00 | 1760811529
 2012-07-21 00:00:00 |  797646252
 2012-07-22 00:00:00 |  739816308
 2012-07-23 00:00:00 | 1834802057
 2012-07-24 00:00:00 | 1920564147
 2012-07-25 00:00:00 | 1895990755
 2012-07-26 00:00:00 | 1892477228
 2012-07-27 00:00:00 | 1707468725
 2012-07-28 00:00:00 |  741388548
 2012-07-29 00:00:00 |  713800711
 2012-07-30 00:00:00 | 1710571330
 2012-07-31 00:00:00 | 1828771314
(61 rows)

Time: First fetch (61 rows): 133800.984 ms. All rows formatted: 136915.185 ms
dbadmin=> select event_name, count(1)
dbadmin-> from event_properties
dbadmin-> group by 1
dbadmin-> order by 1;
                            event_name                            |    count    
------------------------------------------------------------------+-------------
 Signup - Download Desktop                                        |          77
 accepted_group_suggestion                                        |    11176909
 activation_reminder_sent                                         |     2482204
 activities_fetch                                                 | 14960410701
 address_book_import                                              |     1154511
 api_error                                                        |   531646939
 apple_push_message                                               |  1471953046
 canonicals_from_community                                        |      126268
 click_help_link                                                  |      323088
 clickthrough                                                     |     1105475
 content_relationship_added                                       |    27161936
 content_relationship_removed                                     |      474420
 declined_group_suggestion                                        |      429604
 declined_suggestion_created                                      |     1746910
 desktop_download                                                 |     3671003
 desktop_session                                                  |   446156950
 desktop_upgrade                                                  |     7833067
 download_desktop_reminder_sent                                   |       51339
 duplicate_invite                                                 |     1552766
 email_address_activation                                         |     9548943
 email_address_deleted                                            |     1119697
 email_address_suspended                                          |      589454
 email_open                                                       |   190255028
 engagement                                                       |  5984048075
 exp_treatment                                                    | 14021005016
 export                                                           |       63429
 feed_page_load                                                   |   157122416
 file_attached                                                    |     6892044
 file_created                                                     |     7771511
 file_downloaded                                                  |    24205199
 file_shared                                                      |       35442
 file_update_description                                          |      239096
 file_update_name                                                 |       60853
 file_visited                                                     |    31480250
 follow                                                           |    84968937
 follow_thread                                                    |          28
 forgot_password                                                  |       34784
 group_creation                                                   |     3211490
 group_deletion                                                   |      513685
 group_downgrade                                                  |       10825
 group_invitation                                                 |     1364218
 group_member_activation                                          |    23403765
 group_member_deletion                                            |     3392822
 group_premium_settings_change                                    |     4131925
 group_upgrade                                                    |        6653
 group_upgrade_failure                                            |        1630
 group_upgrade_lightbox                                           |      538254
 group_upgrade_pay_later                                          |        4448
 group_upgrade_pay_later_page                                     |      390080
 group_upgrade_payment                                            |        2343
 hide_chat_messages_disabled                                      |       27780
 hide_chat_messages_enabled                                       |       13596
 home_page                                                        |   246780765
 invalid_csrf_token                                               |      274614
 invite                                                           |    68441294
 landing                                                          |   745626042
 mark_file_official                                               |       19685
 mark_page_official                                               |       11296
 marked_message_creation                                          |    41622720
 marked_message_deletion                                          |      708698
 master_unsubscribe                                               |       16340
 message_creation                                                 |   248447259
 message_deletion                                                 |     3879365
 message_feed_backfill                                            |   110352080
 message_feed_deliver                                             | 10650946124
 message_feed_downgrade_primary                                   |      789185
 message_feed_purge                                               |     2994301
 message_feed_unbackfill                                          |     3621844
 monitored_keyword_alert                                          |      106498
 mute_thread                                                      |      415876
 network_activation                                               |      669910
 network_claim                                                    |      122097
 network_contact_suggestion_accepted                              |      856001
 network_contact_suggestion_declined                              |      439234
 network_contact_suggestion_suggested                             |   595784500
 network_user_suspension                                          |        7570
 notifications_fetch                                              | 40244218757
 oauth_activation                                                 |    17487614
 ooo_email                                                        |      220140
 page_compare                                                     |      277080
 page_creation                                                    |      890141
 page_invite                                                      |      112000
 page_publish                                                     |     1129702
 page_revert                                                      |        2349
 page_share_created                                               |       22304
 page_share_revoked                                               |          94
 page_share_visited                                               |       39146
 page_shared                                                      |          66
 page_view                                                        |     4110390
 page_visited_from_module                                         |         676
 password_recovery_attempt                                        |     1918683
 pg_stat_user_tables                                              |   655971238
 pmta_logs                                                        |   682542912
 preferred_my_feed_changed                                        |      442113
 process_bulk_import_user                                         |      323093
 profile_update_department_id                                     |     6141634
 profile_update_expertise                                         |     1711625
 profile_update_full_name                                         |     8370409
 profile_update_im_provider                                       |     1521852
 profile_update_im_username                                       |     1528032
 profile_update_interests                                         |     1648463
 profile_update_job_title                                         |     8205839
 profile_update_kids_names                                        |     1443407
 profile_update_location                                          |     2532209
 profile_update_mobile_telephone                                  |     2353728
 profile_update_photo                                             |     2858101
 profile_update_significant_other                                 |     1442084
 profile_update_skype_username                                    |     1485060
 profile_update_summary                                           |     2454930
 profile_update_twitter_username                                  |     1564210
 profile_update_work_extension                                    |     1607074
 profile_update_work_telephone                                    |     2449854
 public_site_hit                                                  |    64734098
 reinvite                                                         |       75427
 relationship                                                     |    22825203
 search_ac                                                        |     7506462
 search_ac/images/public_site/yammer_logos/yammer-logo_ps2.png    |         180
 search_ac?show_login=true                                        |         710
 search_click                                                     |      412473
 search_click/images/public_site/yammer_logos/yammer-logo_ps2.png |          50
 search_click?show_login=true                                     |          40
 search_performance                                               |    14200825
 sent_email_activation                                            |     8015677
 sent_email_activation_reminder                                   |     2984911
 sent_email_activation_request                                    |    41087481
 sent_email_activation_request_organic                            |     5204936
 sent_email_billing_charge_failed                                 |        1360
 sent_email_billing_invoice                                       |        3092
 sent_email_blackberry_download                                   |       88620
 sent_email_browser_activation                                    |      174650
 sent_email_clicked                                               |    42956262
 sent_email_confirm_master_email_unsubscribe                      |       15443
 sent_email_conversation_digest                                   |    12970159
 sent_email_copy_of_message                                       |   344023367
 sent_email_download_desktop_reminder                             |       68396
 sent_email_duplicate_email_rejected                              |       10348
 sent_email_email_change_validation                               |       44142
 sent_email_email_verification_request                            |      276445
 sent_email_empty_update_error                                    |        1240
 sent_email_error_posting_by_email                                |        1100
 sent_email_existing_user_signup                                  |     3065260
 sent_email_export_notification                                   |        3844
 sent_email_forgot_password                                       |     1994547
 sent_email_group_downgrade                                       |       16740
 sent_email_group_forbidden_by_email                              |        4444
 sent_email_group_member_auto_added                               |     3732968
 sent_email_group_request                                         |     1228561
 sent_email_group_upgrade_benefits                                |     3534440
 sent_email_groups_digest                                         |   275823264
 sent_email_invitee_on_master_unsub_list                          |       21593
 sent_email_join_request_digest                                   |       87460
 sent_email_like_digest                                           |     4425100
 sent_email_msft                                                  |    13309256
 sent_email_must_activate                                         |       38488
 sent_email_new_app_auth                                          |     3590869
 sent_email_new_group_downgrade                                   |        2408
 sent_email_new_premium_group_downgrade_reminder                  |        1199
 sent_email_new_premium_group_invoice                             |          84
 sent_email_new_premium_group_pay_later                           |        7430
 sent_email_new_premium_group_payment_reminder                    |        1254
 sent_email_new_user_cc_invitation                                |      111225
 sent_email_new_user_group_invitation                             |     1663703
 sent_email_new_user_pm_invitation                                |       12246
 sent_email_org_chart_by_digest                                   |      173596
 sent_email_pending_group_digest                                  |      517810
 sent_email_post_confirmation_request                             |      192648
 sent_email_posting_instructions                                  |       80084
 sent_email_premium_group_downgrade_reminder                      |     4546839
 sent_email_premium_group_invoice                                 |         357
 sent_email_premium_group_pay_later                               |          44
 sent_email_premium_group_payment_reminder                        |     4575989
 sent_email_reactivate_account_request                            |       35709
 sent_email_share_activation_reminder                             |         295
 sent_email_suggestions                                           |    10868608
 sfaearch_ac                                                      |          15
 show_thread                                                      |    42377562
 signon_attempt                                                   |    51458468
 signon_with_cookie                                               |   165852720
 signout                                                          |    12501148
 signup_add_photo                                                 |     6561401
 signup_add_relationships                                         |     5855088
 signup_baddomain                                                 |        1364
 signup_complete_activation                                       |     7372272
 signup_complete_signup                                           |     9198638
 signup_confirm                                                   |     4949110
 signup_download_client                                           |     5691653
 signup_email_confirm                                             |     1209180
 signup_enter_email                                               |     4243726
 signup_join_groups                                               |     6047628
 signup_org_chart                                                 |     5860360
 signup_send_confirmation                                         |     1175967
 sms_received                                                     |      103716
 social_content_view                                              |          54
 sso_error_redirect                                               |        5125
 suggestion                                                       |     8165454
 suggestion_suggested                                             |  2015777923
 suspension_threshold                                             |     1724040
 sync                                                             |       96120
 task_completion                                                  |    18847698
 task_dismissal                                                   |      210578
 test-event                                                       |      202219
 test_event                                                       |          24
 text_for_app_click                                               |       34084
 text_for_app_sent                                                |      117531
 ticker                                                           |     3759036
 ticker...                                                        |          12
 ticker/images/public_site/yammer_logos/yammer-logo_ps2.png       |         153
 ticker?show_login=true                                           |         308
 tickerf                                                          |          12
 tickerhttp://www.iwstech.com/blog/                               |          27
 topic_application_phase                                          |    27016817
 topic_phase                                                      |     4145972
 unfollow                                                         |     1523018
 unfollow_thread                                                  |          98
 unmark_file_official                                             |        1842
 unmark_page_official                                             |        2656
 unmute_thread                                                    |       29542
 unsubscribe_click                                                |      144293
 update_xml_hit                                                   |  1048017314
 uploaded_file_share_created                                      |       40704
 uploaded_file_share_revoked                                      |         242
 uploaded_file_share_visited                                      |       39765
 user_activation                                                  |    14722734
 user_creation                                                    |    21371981
 user_deletion                                                    |     1380252
 user_guid_set                                                    |     1386396
 user_suspension                                                  |      698310
 viral_signup_email_change_v2                                     |      214994
 yamio_creation                                                   |     4942045
 ymodule_callback_sender                                          |      946796
 ymodule_instance_creation                                        |     1008553
(231 rows)


yammer_rw=> INSERT /*+direct*/ INTO fact_events 
yammer_rw-> (
yammer_rw(> SELECT fe.*
yammer_rw(> FROM (
yammer_rw(> SELECT MAX(id) AS event_property_id,
yammer_rw(>        event_id,
yammer_rw(>        MAX(application) AS application,
yammer_rw(>        MAX(event_name)  AS event_name,
yammer_rw(>        MAX(occurred_at) AS occurred_at,
yammer_rw(>        MAX(CASE property_name WHEN 'network_id'  THEN property_value ELSE null END)::INT AS network_id,
yammer_rw(>        MAX(CASE property_name WHEN 'user_id'     THEN property_value ELSE null END)::INT AS user_id,
yammer_rw(>        MAX(CASE property_name WHEN 'session_id'  THEN SUBSTRING(property_value,1,128) ELSE null END)      AS session_id,
yammer_rw(>        MAX(CASE property_name WHEN 'client_id'   THEN property_value ELSE null END)::INT AS client_id,
yammer_rw(>        MAX(CASE property_name WHEN 'controller'  THEN property_value ELSE null END)      AS controller,
yammer_rw(>        MAX(CASE property_name WHEN 'action'      THEN property_value ELSE null END)      AS action,
yammer_rw(>        MAX(CASE property_name WHEN 'id_param'    THEN SUBSTRING(property_value,1,128) ELSE null END)      AS param_id,
yammer_rw(>        MAX(CASE property_name WHEN 'user_agent'  THEN property_value ELSE null END)      AS user_agent,
yammer_rw(>        MAX(CASE property_name WHEN 'http_method' THEN property_value ELSE null END)      AS http_method,
yammer_rw(>        INET_ATON(MAX(CASE property_name WHEN 'ip_address'  THEN property_value ELSE null END)) AS ip_integer
yammer_rw(>   FROM event_properties ep
yammer_rw(>  WHERE (
yammer_rw(>         (property_name IN ('network_id','user_id','client_id') AND REGEXP_LIKE(property_value, '^\d+\z'))
yammer_rw(>         OR property_name IN ('session_id','controller','action','id_param','user_agent','http_method','ip_address')
yammer_rw(>        )
yammer_rw(>    AND property_value NOT IN ('nil','null')
yammer_rw(>    AND application IN('web-prod','web-backstage')
yammer_rw(>    AND id > 0
yammer_rw(>    AND occurred_at >= '2012-06-01' and occurred_at < '2012-06-02'
yammer_rw(>    AND event_id IS NOT NULL
yammer_rw(>  GROUP BY event_id
yammer_rw(> ) fe
yammer_rw(> );
  OUTPUT   
-----------
 135118588
(1 row)

Time: First fetch (1 row): 215108.224 ms. All rows formatted: 215108.267 ms
yammer_rw=> commit;
COMMIT
Time: First fetch (0 rows): 81.559 ms. All rows formatted: 81.571 ms


yammer_rw=> SELECT drp.period_id, drp.time_id,
yammer_rw->            'all' AS cohort_type,
yammer_rw->            'all' AS cohort,
yammer_rw->             e1.engaged_users,
yammer_rw->             e1.engaged_meta_users,
yammer_rw->             e1.engaged_networks,
yammer_rw->             m1.posters,
yammer_rw->             m1.messages,
yammer_rw->             m1.active_groups
yammer_rw->       FROM dimension_rollup_periods drp
yammer_rw->       LEFT JOIN (SELECT drp1.period_id, drp1.time_id,
yammer_rw(>                         COUNT(DISTINCT engagements.user_id) AS engaged_users,
yammer_rw(>                         COUNT(DISTINCT users.meta_user_id) AS engaged_meta_users,
yammer_rw(>                         COUNT(DISTINCT users.network_id) AS engaged_networks
yammer_rw(>                    FROM dimension_rollup_periods drp1
yammer_rw(>                    JOIN fact_events engagements
yammer_rw(>                      ON engagements.occurred_at >= drp1.begin_time
yammer_rw(>                     AND engagements.occurred_at <  drp1.end_time
yammer_rw(>                     AND engagements.application IN('web-prod','web-backstage') 
yammer_rw(>                     AND engagements.occurred_at >= TO_TIMESTAMP( '2012-06-01', 'YYYY-MM-DD HH24:MI:SS' )
yammer_rw(>                     AND engagements.occurred_at <= TO_TIMESTAMP( '2012-06-02', 'YYYY-MM-DD HH24:MI:SS' )
yammer_rw(>                    LEFT JOIN dimension_users users
yammer_rw(>                      ON engagements.user_id = users.user_id
yammer_rw(>                     AND engagements.network_id = users.network_id
yammer_rw(>                   WHERE drp1.period_id = 2001
yammer_rw(>                     AND drp1.time_id >= TO_TIMESTAMP( '2012-06-01', 'YYYY-MM-DD HH24:MI:SS' )
yammer_rw(>                     AND drp1.time_id <= TO_TIMESTAMP( '2012-06-02', 'YYYY-MM-DD HH24:MI:SS' )
yammer_rw(>                   GROUP BY drp1.period_id, drp1.time_id )e1
yammer_rw->         ON e1.time_id = drp.time_id
yammer_rw->       LEFT JOIN (SELECT drp2.period_id, drp2.time_id,
yammer_rw(>                         COUNT(DISTINCT m.sender_id) AS posters,
yammer_rw(>                         COUNT(DISTINCT m.message_id) AS messages,
yammer_rw(>                         COUNT(DISTINCT m.group_id) AS active_groups          
yammer_rw(>                    FROM dimension_rollup_periods drp2
yammer_rw(>                    JOIN dimension_messages m
yammer_rw(>                      ON m.message_type IN (0, 4)
yammer_rw(>                     AND m.client_type_id NOT IN (112, 142)
yammer_rw(>                     AND m.created_at >= drp2.begin_time
yammer_rw(>                     AND m.created_at <  drp2.end_time
yammer_rw(>                     AND m.created_at >= TO_TIMESTAMP( '2012-06-01', 'YYYY-MM-DD HH24:MI:SS' )
yammer_rw(>                     AND m.created_at <= TO_TIMESTAMP( '2012-06-02', 'YYYY-MM-DD HH24:MI:SS' )
yammer_rw(>                   WHERE drp2.period_id = 2001
yammer_rw(>                     AND drp2.time_id >= TO_TIMESTAMP( '2012-06-01', 'YYYY-MM-DD HH24:MI:SS' )
yammer_rw(>                     AND drp2.time_id <= TO_TIMESTAMP( '2012-06-02', 'YYYY-MM-DD HH24:MI:SS' )
yammer_rw(>                   GROUP BY drp2.period_id, drp2.time_id) m1
yammer_rw->         ON m1.time_id = drp.time_id
yammer_rw->      WHERE drp.period_id = 2001
yammer_rw->        AND drp.time_id >= TO_TIMESTAMP( '2012-06-01', 'YYYY-MM-DD HH24:MI:SS' )
yammer_rw->        AND drp.time_id <= TO_TIMESTAMP( '2012-06-02', 'YYYY-MM-DD HH24:MI:SS' )
yammer_rw-> ;
 period_id |       time_id       | cohort_type | cohort | engaged_users | engaged_meta_users | engaged_networks | posters | messages | active_groups 
-----------+---------------------+-------------+--------+---------------+--------------------+------------------+---------+----------+---------------
      2001 | 2012-06-01 02:00:00 | all         | all    |        304198 |             293477 |            30726 |   23165 |    51843 |          4887
      2001 | 2012-06-01 09:00:00 | all         | all    |        484199 |             465242 |            36923 |   44746 |   109879 |          8820
      2001 | 2012-06-01 13:00:00 | all         | all    |        548643 |             526425 |            38502 |   52868 |   136162 |         10163
      2001 | 2012-06-01 00:00:00 | all         | all    |        241264 |             233583 |            27507 |   16128 |    35613 |          3511
      2001 | 2012-06-01 11:00:00 | all         | all    |        521631 |             500981 |            37780 |   49287 |   124086 |          9568
      2001 | 2012-06-01 12:00:00 | all         | all    |        535276 |             513900 |            38129 |   51148 |   130324 |          9877
      2001 | 2012-06-01 15:00:00 | all         | all    |        572930 |             548886 |            39125 |   55734 |   146470 |         10596
      2001 | 2012-06-01 08:00:00 | all         | all    |        460194 |             442068 |            36346 |   41688 |   101219 |          8296
      2001 | 2012-06-01 22:00:00 | all         | all    |        556372 |             533729 |            38122 |   50961 |   128805 |          9754
      2001 | 2012-06-01 18:00:00 | all         | all    |        580788 |             556408 |            39212 |   55842 |   147521 |         10626
      2001 | 2012-06-01 21:00:00 | all         | all    |        563751 |             540654 |            38419 |   52243 |   133194 |          9972
      2001 | 2012-06-01 23:00:00 | all         | all    |        542715 |             520836 |            37675 |   49391 |   123556 |          9491
      2001 | 2012-06-01 05:00:00 | all         | all    |        362972 |             348605 |            33360 |   31329 |    74807 |          6384
      2001 | 2012-06-01 19:00:00 | all         | all    |        574618 |             550712 |            38890 |   54533 |   142196 |         10389
      2001 | 2012-06-02 00:00:00 | all         | all    |        523167 |             502409 |            36911 |   46957 |   116713 |          9064
      2001 | 2012-06-01 04:00:00 | all         | all    |        340073 |             326733 |            32538 |   28748 |    67472 |          5884
      2001 | 2012-06-01 14:00:00 | all         | all    |        562912 |             539723 |            38846 |   54484 |   141788 |         10417
      2001 | 2012-06-01 16:00:00 | all         | all    |        580064 |             555607 |            39303 |   56616 |   149776 |         10732
      2001 | 2012-06-01 17:00:00 | all         | all    |        588117 |             563287 |            39454 |   57164 |   152326 |         10828
      2001 | 2012-06-01 20:00:00 | all         | all    |        569300 |             545777 |            38663 |   53382 |   137356 |         10190
      2001 | 2012-06-01 01:00:00 | all         | all    |        279287 |             269929 |            29615 |   19751 |    43453 |          4229
      2001 | 2012-06-01 03:00:00 | all         | all    |        324748 |             312647 |            31599 |   26174 |    60030 |          5445
      2001 | 2012-06-01 06:00:00 | all         | all    |        395500 |             379935 |            34445 |   34442 |    82910 |          6996
      2001 | 2012-06-01 07:00:00 | all         | all    |        430611 |             413745 |            35552 |   38174 |    92240 |          7651
      2001 | 2012-06-01 10:00:00 | all         | all    |        504073 |             484208 |            37404 |   47198 |   117354 |          9230
(25 rows)

</pre>
