CREATE TABLE dimension_users (
      user_id INTEGER NOT NULL,
      state VARCHAR(64),
      network_id INTEGER NOT NULL,
      permalink VARCHAR(1024),
      first_invite_id INTEGER,
      meta_user_id INTEGER,
      usage_policy_version INTEGER,
      deleted_by_id INTEGER,
      guest BOOLEAN,
      canonical_network_id INTEGER,
      created_at TIMESTAMP WITHOUT TIME ZONE,
      updated_at TIMESTAMP WITHOUT TIME ZONE,
      activated_at TIMESTAMP WITHOUT TIME ZONE,
      deleted_at TIMESTAMP WITHOUT TIME ZONE,
      suspended_at TIMESTAMP WITHOUT TIME ZONE,
      last_date_accessed TIMESTAMP WITHOUT TIME ZONE,
      clicked_activation_link_at TIMESTAMP WITHOUT TIME ZONE,
      department_name VARCHAR(512),
      country_code varchar(2),
      country varchar(255),
      continent varchar(255),
      paid_network BOOLEAN,
      paid_canonical_network BOOLEAN,
      network_type varchar(256),
      full_name VARCHAR(512),
      photo_id INTEGER,
      mugshot_id VARCHAR(255),
      "timezone" VARCHAR(512),
      locale VARCHAR(512),
      guid VARCHAR(512),
      contact_email_address VARCHAR(1024),
      contact_email_id INTEGER,
      im_username varchar(1024),
      im_provider varchar(1024),
      work_telephone varchar(1024),
      work_extension varchar(1024),
      mobile_telephone varchar(1024),
      twitter_username varchar(1024),
      skype_username varchar(1024),
      job_title varchar(1024),
      "location" varchar(1024),
      start_date timestamp,
      expertise varchar(4096),
      acquisition_type varchar(256),
      acquisition_virality_type varchar(256),
      PRIMARY KEY (network_id, user_id)
    ) 
