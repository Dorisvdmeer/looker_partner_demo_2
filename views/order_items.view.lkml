# The name of this view in Looker is "Order Items"
view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `my-python-adventure.looker_partner_demo.order_items`
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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
      month_name,
      month_num,
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
  # This dimension will be called "Inventory Item ID" in Explore.

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
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

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: average_spend_per_customer {
    type:  number
    value_format_name: usd
    sql: ${total_sale_price} / ${orders.number_of_customers} ;;
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
  }

  measure: cumulative_total_sales{
    type: running_total
    sql: ${total_sale_price} ;;
  }

  measure: total_gross_revenue{
    type: sum
    sql: ${sale_price} - ${products.cost}   ;;
    value_format_name: usd
    filters: [status:  "Shipped, Complete, Processing"]
  }

  measure: oi_total_cost {
    type: sum
    sql: ${products.cost} ;;
    value_format_name: usd
  }

  measure: oi_average_cost {
    type: average
    sql: ${products.cost} ;;
    value_format_name: usd
  }

  measure: total_revenue_completed_sales {
    hidden: yes
    type: sum
    sql:  ${sale_price} - ${products.cost}   ;;
    filters: {
      field: status
      value: "Complete"
    }
  }

  measure: total_cost_sold {
    hidden: yes
    type: sum
    sql: ${products.cost}   ;;
    filters: {
      field: status
      value: "Shipped, Complete, Processing"
    }
  }

  # Total difference between the total revenue from completed sales and the
  # cost of the goods that were sold
  measure: total_gross_margin {
    type: number
    sql: ${total_revenue_completed_sales} - ${total_cost_sold}   ;;
  }

  measure: average_gross_margin {
    type: average
    sql: ${total_revenue_completed_sales} - ${total_cost_sold}   ;;
  }

  measure: gross_margin_percentage {
    type: number
    value_format_name: percent_2
    sql: ${total_gross_margin} / ${total_revenue_completed_sales} ;;
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
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name,
      products.name,
      products.id,
      orders.order_id
    ]
  }
}
