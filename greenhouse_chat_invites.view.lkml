view: greenhouse_chat_invites {
  derived_table: {
    sql:
      select
      count(distinct ce.id) as invites_requested, count(distinct es.id) as invites_sent
      from users_behaviors_customevent_shared ce
      left join users_messages_email_send_shared es on ce.user_id = es.user_id
      where ce.name = 'screening.chat.requested'
      and es.email_address not like '%@wadeandwendy.ai%'
      and parse_json(ce.properties):job_company = 'Wade & Wendy'
      and datediff('day', to_timestamp_ltz(ce.time), current_timestamp(2)) <= 1
      and datediff('day', to_timestamp_ltz(es.time), current_timestamp(2)) <= 1
    ;;
  }

  dimension: invites_requested {
    type: number
    sql: ${TABLE}."invites_requested" ;;
  }

  dimension: invites_sent {
    type: number
    sql: ${TABLE}."invites_sent" ;;
  }
}
