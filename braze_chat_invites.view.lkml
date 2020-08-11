view: braze_chat_invites {
  # 5ee199a7d21d705add627a59 is the campaign id for screening chat invites
  derived_table: {
    sql:
      select
      ce.id as request_id,
      split(parse_json(ce.properties):chat_url, '/')[array_size(split(parse_json(ce.properties):chat_url, '/')) - 1] as application_id,
      es.id as message_id
      from users_behaviors_customevent_shared ce
      left join users_messages_email_send_shared es on ce.user_id = es.user_id
      where ce.name = 'screening.chat.requested'
      and es.email_address not like '%@wadeandwendy.ai%'
      and es.campaign_id = '5ee199a7d21d705add627a59'
      and (parse_json(ce.properties):job_company = {% parameter client %} or {% parameter client %} is null)
      and datediff('day', to_timestamp_ltz(ce.time), current_timestamp(2)) <= 1
      and datediff('day', to_timestamp_ltz(es.time), current_timestamp(2)) <= 1
    ;;
  }

  parameter: client {
    type: string
    default_value: "Wade & Wendy"
    suggestions: ["Wade & Wendy", "Randstad", "E*TRADE", "Randstad Direct", "CWC PCN",
      "Equitable", "Lowell Herb", "RPO - Lyft", "Randstad RPO", "Randstad RCD",
      "Comcast", "American Care Quest", "Carex", "Genuine Search Group", "Reveal Global Intelligence",
      "Skiplagged", "Sealed", "Staff Garden", "Suzy", "M Financial",
      "Azimuth", "Wallace Carter Jones", "Deluxe", "GTT", "CAI", "Venture University",
      "RPO - Williams Lea Tag", "RPO - Marine Credit Union",
      "RPO - Cetera", "RPO - Bosch", "RPO - Evoqua"]
  }

  dimension: request_id {
    type: number
    sql: ${TABLE}."request_id" ;;
  }

  dimension: application_id {
    type: string
    sql: ${TABLE}."application_id" ;;
  }

  dimension: message_id {
    type: number
    sql: ${TABLE}."message_id" ;;
  }

  measure: invites_requested {
    type: count_distinct
    sql: ${TABLE}."invites_requested" ;;
    drill_fields: [request_id, application_id]
  }

  measure: invites_sent {
    type: count_distinct
    sql: ${TABLE}."invites_sent" ;;
    drill_fields: [message_id]
  }
}
