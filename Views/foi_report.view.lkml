include: "//snowplow_web_block/Includes/date_comparisons_common.view"

view: foi_report {
  derived_table: {
    sql: SELECT wp.id as page_view_id, foi.*
        FROM atomic.ca_bc_gov_foi_foi_report_2 AS foi
        JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp ON foi.root_id = wp.root_id AND foi.root_tstamp = wp.root_tstamp
      ;;
    distribution_style: all
    persist_for: "2 hours"
  }

  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.root_tstamp  ;;
  }


  dimension: page_view_id {
    description: "Unique page view ID"
    type: string
    sql: ${TABLE}.page_view_id ;;
    group_label: "Debug Info"
  }

  dimension: root_id {
    description: "Unique ID of the event"
    type: string
    sql: ${TABLE}.root_id ;;
    group_label: "Debug Info"
  }


  dimension: root_tstamp {
    description: "The timestamp of the video event."
    type: string
    sql: ${TABLE}.root_tstamp ;;
    group_label: "Debug Info"
  }

  dimension_group: report {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.root_tstamp ;;
    #X# group_label:"Page View Time"
  }


  dimension: schema_vendor {
    description: "The schema vendor."
    type: string
    sql: ${TABLE}.schema_vendor ;;
    group_label: "Debug Info"
  }

  dimension: schema_name {
    description: "The schema name."
    type: string
    sql: ${TABLE}.schema_name ;;
    group_label: "Debug Info"
  }

  dimension: schema_format {
    description: "The schema format."
    type: string
    sql: ${TABLE}.schema_format ;;
    group_label: "Debug Info"
  }

  dimension: schema_version {
    description: "The schema version."
    type: string
    sql: ${TABLE}.schema_version ;;
    group_label: "Debug Info"
  }

  dimension: ref_root {
    hidden:  yes
    type: string
    sql: ${TABLE}.ref_root ;;
    group_label: "Debug Info"
  }

  dimension: ref_tree {
    hidden:  yes
    sql: ${TABLE}.ref_tree ;;
    group_label: "Debug Info"
  }

  dimension: ref_parents {
    hidden:  yes
    sql: ${TABLE}.ref_parents ;;
    group_label: "Debug Info"
  }

  dimension: file_format {
    description: "file_format"
    type: string
    suggestions: ["PDF","Excel"]
    sql: ${TABLE}.file_format;;
  }

  dimension: organization {
    description: "organization"
    type: string
    sql: ${TABLE}.organization;;
  }

  dimension: applicant_type {
    description: "applicant_type"
    type: string
    sql: ${TABLE}.applicant_type;;
  }

  dimension: is_overdue {
    description: "Is the record marked as overdue or not"
    type: string
    suggestions: ["Yes","No","All"]
    sql: ${TABLE}.is_overdue;;
  }

  dimension: status {
    description: "status"
    type: string
    sql: ${TABLE}.status;;
  }

  dimension: due_date_end {
    description: "due_date_end"
    type: string
    sql: ${TABLE}.due_date_end;;
  }

  dimension: due_date_start {
    description: "due_date_start"
    type: string
    sql: ${TABLE}.due_date_start;;
  }

  dimension: start_date_end {
    description: "start_date_end"
    type: string
    sql: ${TABLE}.start_date_end;;
  }

  dimension: start_date_start {
    description: "start_date_start"
    type: string
    sql: ${TABLE}.start_date_start;;
  }

  measure: count {
    type: count
  }
  measure: organization_set_count{
    type: sum
    sql: CASE WHEN ${TABLE}.organization <> '[null]' THEN 1 ELSE 0 END ;;
  }
  measure: start_date_set_count{
    type: sum
    sql: CASE WHEN ${TABLE}.start_date_start IS NOT NULL OR ${TABLE}.start_date_end IS NOT NULL THEN 1 ELSE 0 END ;;
  }
  measure: due_date_set_count{
    type: sum
    sql: CASE WHEN ${TABLE}.due_date_start IS NOT NULL OR ${TABLE}.due_date_end IS NOT NULL THEN 1 ELSE 0 END ;;
  }
  measure: pdf_count{
    type: sum
    sql: CASE WHEN ${TABLE}.file_format = 'PDF' THEN 1 ELSE 0 END ;;
    group_label: "File Format Counts"
  }
  measure: excel_count{
    type: sum
    sql: CASE WHEN ${TABLE}.file_format = 'Excel' THEN 1 ELSE 0 END ;;
    group_label: "File Format Counts"
  }
  measure: business_count{
    type: sum
    sql: CASE WHEN ${TABLE}.applicant_type = '[null]' OR ${TABLE}.applicant_type LIKE '%Business%' THEN 1 ELSE 0 END ;;
    group_label: "Applicant Type Counts"
  }
  measure: individual_count{
    type: sum
    sql: CASE WHEN ${TABLE}.applicant_type = '[null]' OR ${TABLE}.applicant_type LIKE '%Individual%' THEN 1 ELSE 0 END ;;
    group_label: "Applicant Type Counts"
  }
  measure: interest_group_count{
    type: sum
    sql: CASE WHEN ${TABLE}.applicant_type = '[null]' OR ${TABLE}.applicant_type LIKE '%Interest Group%' THEN 1 ELSE 0 END ;;
    group_label: "Applicant Type Counts"
  }
  measure: law_firm_count{
    type: sum
    sql: CASE WHEN ${TABLE}.applicant_type = '[null]' OR ${TABLE}.applicant_type LIKE '%Law Firm%' THEN 1 ELSE 0 END ;;
    group_label: "Applicant Type Counts"
  }
  measure: media_count{
    type: sum
    sql: CASE WHEN ${TABLE}.applicant_type = '[null]' OR ${TABLE}.applicant_type LIKE '%Media%' THEN 1 ELSE 0 END ;;
    group_label: "Applicant Type Counts"
  }
  measure: other_governments_count{
    type: sum
    sql: CASE WHEN ${TABLE}.applicant_type = '[null]' OR ${TABLE}.applicant_type LIKE '%Other Governments%' THEN 1 ELSE 0 END ;;
    group_label: "Applicant Type Counts"
  }
  measure: other_public_body_count{
    type: sum
    sql: CASE WHEN ${TABLE}.applicant_type = '[null]' OR ${TABLE}.applicant_type LIKE '%Other Public Body%' THEN 1 ELSE 0 END ;;
    group_label: "Applicant Type Counts"
  }
  measure: political_party_count{
    type: sum
    sql: CASE WHEN ${TABLE}.applicant_type = '[null]' OR ${TABLE}.applicant_type LIKE '%Political Party%' THEN 1 ELSE 0 END ;;
    group_label: "Applicant Type Counts"
  }
  measure: researcher_count{
    type: sum
    sql: CASE WHEN ${TABLE}.applicant_type = '[null]' OR ${TABLE}.applicant_type LIKE '%Researcher%' THEN 1 ELSE 0 END ;;
    group_label: "Applicant Type Counts"
  }
  measure: is_overdue_count{
    type: sum
    sql: CASE WHEN ${TABLE}.is_overdue IN ('Yes','All') THEN 1 ELSE 0 END ;;
    group_label: "Overdue Counts"
  }
  measure: is_not_overdue_count{
    type: sum
    sql: CASE WHEN ${TABLE}.is_overdue IN ('No','All') THEN 1 ELSE 0 END ;;
    group_label: "Overdue Counts"
  }

}
