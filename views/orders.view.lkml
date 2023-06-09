# The name of this view in Looker is "Orders"
view: orders {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `my-python-adventure.looker_partner_demo.orders`
    ;;
  drill_fields: [order_id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Gender" in Explore.

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: num_of_item {
    type: number
    sql: ${TABLE}.num_of_item ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: number_of_items {
    type: sum
    sql: ${num_of_item} ;;
  }

  measure: number_of_items_sold {
    type: sum
    sql: ${num_of_item} ;;
    filters: {
      field: status
      value: "Shipped, Completed, Processing"
    }
  }

  measure: number_of_items_returned {
    type: sum
    sql: ${num_of_item} ;;
    filters: {
      field: status
      value: "Returned"
    }
  }

  measure: item_return_rate {
    type: number
    value_format_name: percent_2
    sql: ${number_of_items_returned} /  ${number_of_items_sold};;
  }

  measure: number_of_customers {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: number_of_customers_returning_items {
    type: count_distinct
    sql: ${user_id} ;;
    filters: {
      field: status
      value: "Returned"
    }
  }

  measure: percentage_users_with_returns {
    type: number
    sql: ${number_of_customers_returning_items} / ${number_of_customers} ;;
    value_format_name: percent_2
  }

  measure: average_num_of_item {
    type: average
    sql: ${num_of_item} ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [order_id, users.last_name, users.id, users.first_name, order_items.count]
  }
}
