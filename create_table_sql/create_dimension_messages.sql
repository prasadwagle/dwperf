CREATE TABLE dimension_messages
(
    message_id bigint NOT NULL,
    network_id bigint,
    replied_to_id bigint,
    thread_id bigint,
    message_type bigint,
    sender_id bigint,
    sender_type varchar(1024),
    reply_count bigint,
    addressed boolean,
    client_type_id bigint,
    conversation_id bigint,
    group_id bigint,
    ref_id bigint,
    created_at timestamp,
    updated_at timestamp,
    shared_message_id bigint,
    has_cross_group_attachments boolean
);
