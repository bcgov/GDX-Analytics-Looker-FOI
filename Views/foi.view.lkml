view: foi {
  derived_table: {
    sql: SELECT
         *
      FROM static.foi
      ;;
  }

    dimension: ministry {
      type: string
      sql: ${TABLE}.ministry ;;
      drill_fields: [applicant]
      group_label: "Request Info"
    }
  dimension: ministry_and_type {
    type: string
    sql: ${TABLE}.ministry || ' - ' ||  ${TABLE}."Type";;
    drill_fields: [applicant]
    group_label: "Request Info"
  }


   dimension: request {
    type: string
    sql: ${TABLE}."Request #" ;;
    group_label: "Request Info"
  }
  dimension: type {
    type: string
    sql: ${TABLE}."Type" ;;
    group_label: "Request Info"
  }
  dimension: applicant {
    type: string
    sql: ${TABLE}."Applicant" ;;
    group_label: "Request Info"
    drill_fields: [ministry]
  }
  dimension_group: due_date {
    type: time
    timeframes: [date, day_of_month, week, month, month_name, quarter, fiscal_quarter, year]
    sql: ${TABLE}."Due Date" ;;
  }
  dimension_group: start_date {
    type: time
    timeframes: [date, day_of_month, week, month, month_name, quarter, fiscal_quarter, year]
    sql: ${TABLE}."Start Date" ;;
  }
  dimension_group: end_date {
    type: time
    timeframes: [date, day_of_month, week, month, month_name, quarter, fiscal_quarter, year]
    sql: ${TABLE}."End Date" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."Status" ;;
    group_label: "Outcome"
  }
  dimension: disposition {
    type: string
    sql: ${TABLE}."Disposition" ;;
    group_label: "Outcome"
  }
  dimension: on_hold_days {
    type: string
    sql: ${TABLE}."On Hold Days" ;;
    group_label: "Timing"
  }
  dimension: processing_days {
    type: number
    sql: ${TABLE}."Processing Days" ;;
    group_label: "Timing"
  }
  dimension: overdue_days {
    type: number
    sql: ${TABLE}."Overdue Days" ;;
    group_label: "Timing"
    }
  dimension: extension {
    type: yesno
    sql: ${TABLE}."Extension" ;;
    group_label: "Timing"
  }
  dimension: fees_paid {
    type: number
    value_format: "$#,##0.00"
    sql: ${TABLE}."Fees Paid" ;;
    group_label: "Outcome"
  }
  dimension: publication {
    type: string
    sql: ${TABLE}."Publication" ;;
    group_label: "Outcome"
  }
  dimension: reason {
    type: string
    sql: ${TABLE}."Reason" ;;
    group_label: "Outcome"
  }


  measure: count {
    type:  count
  }
  measure: average_fees_paid {
    type: average
    value_format: "$#,##0.00"
    sql: ${fees_paid} ;;
  }
  measure: total_fees_paid {
    type: sum
    value_format: "$#,##0.00"
    sql: ${fees_paid} ;;
  }

  measure: average_on_hold_days {
    type: average
    value_format: "0.00"
    sql: ${on_hold_days} * 1.000 ;;
    group_label: "Hold Days"
  }
  measure: total_on_hold_days {
    type: sum
    sql: ${on_hold_days} ;;
    group_label: "Hold Days"
  }
  measure: number_with_holds {
    type: sum
    sql: CASE WHEN ${on_hold_days} > 0 THEN 1 END ;;
    group_label: "Hold Days"
  }

  measure: average_processing_days {
    type: average
    value_format: "0.00"
    sql: ${processing_days} * 1.000;;
    group_label: "Processing Days"
  }
  measure: total_processing_days {
    type: sum
    sql: ${processing_days} ;;
    group_label: "Processing Days"
  }
  measure: number_with_processing_days {
    type: sum
    sql: CASE WHEN ${processing_days} > 0 THEN 1 END ;;
    group_label: "Processing Days"
  }


  measure: average_overdue_days {
    type: average
    value_format: "0.00"
    sql: ${overdue_days} * 1.000 ;;
    group_label: "Overdue Days"
  }
  measure: total_overdue_days {
    type: sum
    sql: ${overdue_days} ;;
    group_label: "Overdue Days"
  }
  measure: number_overdue {
    type: sum
    sql: CASE WHEN ${overdue_days} > 0 THEN 1 END ;;
    group_label: "Overdue Days"
  }



}
