view: sql_runner_query {
  derived_table: {
    sql: SELECT
          flights.carrier  AS `flights.carrier`,
          AVG(flights.arr_delay ) AS `flights.average_arr_delay`,
          COUNT(*) AS `flights.count`
      FROM demo_db.flights  AS flights
      WHERE (( (CONVERT_TZ(TIMESTAMP(DATE(CONVERT_TZ(flights.dep_time ,'UTC','America/Los_Angeles'))),'America/Los_Angeles','UTC')) >= CONVERT_TZ(TIMESTAMP(CONCAT(CAST(2004 AS SIGNED), '-', LPAD(CAST(12 AS SIGNED), 2, '0'), '-', LPAD(CAST(31 AS SIGNED), 2, '0'), ' 00:00:00')),'America/Los_Angeles','UTC')) AND ( (CONVERT_TZ(TIMESTAMP(DATE(CONVERT_TZ(flights.dep_time ,'UTC','America/Los_Angeles'))),'America/Los_Angeles','UTC')) < NOW()))
      GROUP BY
          1
      ORDER BY
          AVG(flights.arr_delay ) DESC
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: flights_carrier {
    type: string
    sql: ${TABLE}.`flights.carrier` ;;
  }

  dimension: flights_average_arr_delay {
    type: number
    sql: ${TABLE}.`flights.average_arr_delay` ;;
  }

  dimension: flights_count {
    type: number
    sql: ${TABLE}.`flights.count` ;;
  }

  set: detail {
    fields: [flights_carrier, flights_average_arr_delay, flights_count]
  }
}
