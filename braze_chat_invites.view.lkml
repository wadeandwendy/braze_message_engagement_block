view: braze_chat_invites {
  derived_table: {
    sql:
      select
      count(distinct ce.id) as invites_requested, count(distinct es.id) as invites_sent
      from users_behaviors_customevent_shared ce
      left join users_messages_email_send_shared es on ce.user_id = es.user_id
      where ce.name = 'screening.chat.requested'
      and es.email_address not like '%@wadeandwendy.ai%'
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

  dimension: invites_requested {
    type: number
    sql: ${TABLE}."invites_requested" ;;
  }

  dimension: invites_sent {
    type: number
    sql: ${TABLE}."invites_sent" ;;
  }
}
