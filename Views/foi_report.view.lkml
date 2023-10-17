# Version:     2.0.1
include: "//snowplow_web_block/Includes/date_comparisons_common.view"

view: foi_report {
  derived_table: {
    sql: SELECT wp.id as page_view_id,
        foi.root_tstamp AS timestamp,
        CASE WHEN applicant_type = '[null]' THEN 'All' ELSE SUBSTRING(RTRIM(applicant_type, '"]'), 3) END AS applicant_type,
        is_overdue,
        organization,
        status,
        due_date_start,
        due_date_end,
        file_format,
        start_date_start,
        start_date_end,
        CASE WHEN organization LIKE '%AGR%' THEN 1 ELSE NULL END AS AGR_count,
        CASE WHEN organization LIKE '%CAS%' THEN 1 ELSE NULL END AS CAS_count,
        CASE WHEN organization LIKE '%CFD%' THEN 1 ELSE NULL END AS CFD_count,
        CASE WHEN organization LIKE '%COR%' THEN 1 ELSE NULL END AS COR_count,
        CASE WHEN organization LIKE '%CTZ%' THEN 1 ELSE NULL END AS CTZ_count,
        CASE WHEN organization LIKE '%DAS%' THEN 1 ELSE NULL END AS DAS_count,
        CASE WHEN organization LIKE '%EAO%' THEN 1 ELSE NULL END AS EAO_count,
        CASE WHEN organization LIKE '%ECC%' THEN 1 ELSE NULL END AS ECC_count,
        CASE WHEN organization LIKE '%EMC%' THEN 1 ELSE NULL END AS EMC_count,
        CASE WHEN organization LIKE '%EML%' THEN 1 ELSE NULL END AS EML_count,
        CASE WHEN organization LIKE '%FIN%' THEN 1 ELSE NULL END AS FIN_count,
        CASE WHEN organization LIKE '%FOR%' THEN 1 ELSE NULL END AS FOR_count,
        CASE WHEN organization LIKE '%GCP%' THEN 1 ELSE NULL END AS GCP_count,
        CASE WHEN organization LIKE '%HSG%' THEN 1 ELSE NULL END AS HSG_count,
        CASE WHEN organization LIKE '%HTH%' THEN 1 ELSE NULL END AS HTH_count,
        CASE WHEN organization LIKE '%IRR%' THEN 1 ELSE NULL END AS IRR_count,
        CASE WHEN organization LIKE '%JED%' THEN 1 ELSE NULL END AS JED_count,
        CASE WHEN organization LIKE '%LBR%' THEN 1 ELSE NULL END AS LBR_count,
        CASE WHEN organization LIKE '%LDB%' THEN 1 ELSE NULL END AS LDB_count,
        CASE WHEN organization LIKE '%MAG%' THEN 1 ELSE NULL END AS MAG_count,
        CASE WHEN organization LIKE '%MHA%' THEN 1 ELSE NULL END AS MHA_count,
        CASE WHEN organization LIKE '%MMA%' THEN 1 ELSE NULL END AS MMA_count,
        CASE WHEN organization LIKE '%MOE%' THEN 1 ELSE NULL END AS MOE_count,
        CASE WHEN organization LIKE '%MSD%' THEN 1 ELSE NULL END AS MSD_count,
        CASE WHEN organization LIKE '%OCC%' THEN 1 ELSE NULL END AS OCC_count,
        CASE WHEN organization LIKE '%OOP%' THEN 1 ELSE NULL END AS OOP_count,
        CASE WHEN organization LIKE '%PSA%' THEN 1 ELSE NULL END AS PSA_count,
        CASE WHEN organization LIKE '%PSE%' THEN 1 ELSE NULL END AS PSE_count,
        CASE WHEN organization LIKE '%PSS%' THEN 1 ELSE NULL END AS PSS_count,
        CASE WHEN organization LIKE '%TAC%' THEN 1 ELSE NULL END AS TAC_count,
        CASE WHEN organization LIKE '%TRA%' THEN 1 ELSE NULL END AS TRA_count,
        CASE WHEN organization LIKE '%WLR%' THEN 1 ELSE NULL END AS WLR_count

      FROM atomic.ca_bc_gov_foi_foi_report_2 AS foi
      JOIN atomic.com_snowplowanalytics_snowplow_web_page_1 AS wp ON foi.root_id = wp.root_id AND foi.root_tstamp = wp.root_tstamp
      ;;
    distribution_style: all
    persist_for: "2 hours"
  }

  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.timestamp  ;;
  }



  dimension_group: report {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
    #X# group_label:"Page View Time"
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

  measure: AGR_count {
    group_label: "Organizations"
    type: sum
  }
  measure: CAS_count {
    group_label: "Organizations"
    type: sum
  }
  measure: CFD_count {
    group_label: "Organizations"
    type: sum
  }
  measure: COR_count {
    group_label: "Organizations"
    type: sum
  }
  measure: CTZ_count {
    group_label: "Organizations"
    type: sum
  }
  measure: DAS_count {
    group_label: "Organizations"
    type: sum
  }
  measure: EAO_count {
    group_label: "Organizations"
    type: sum
  }
  measure: ECC_count {
    group_label: "Organizations"
    type: sum
  }
  measure: EMC_count {
    group_label: "Organizations"
    type: sum
  }
  measure: EML_count {
    group_label: "Organizations"
    type: sum
  }
  measure: FIN_count {
    group_label: "Organizations"
    type: sum
  }
  measure: FOR_count {
    group_label: "Organizations"
    type: sum
  }
  measure: GCP_count {
    group_label: "Organizations"
    type: sum
  }
  measure: HSG_count {
    group_label: "Organizations"
    type: sum
  }
  measure: HTH_count {
    group_label: "Organizations"
    type: sum
  }
  measure: IRR_count {
    group_label: "Organizations"
    type: sum
  }
  measure: JED_count {
    group_label: "Organizations"
    type: sum
  }
  measure: LBR_count {
    group_label: "Organizations"
    type: sum
  }
  measure: LDB_count {
    group_label: "Organizations"
    type: sum
  }
  measure: MAG_count {
    group_label: "Organizations"
    type: sum
  }
  measure: MHA_count {
    group_label: "Organizations"
    type: sum
  }
  measure: MMA_count {
    group_label: "Organizations"
    type: sum
  }
  measure: MOE_count {
    group_label: "Organizations"
    type: sum
  }
  measure: MSD_count {
    group_label: "Organizations"
    type: sum
  }
  measure: OCC_count {
    group_label: "Organizations"
    type: sum
  }
  measure: OOP_count {
    group_label: "Organizations"
    type: sum
  }
  measure: PSA_count {
    group_label: "Organizations"
    type: sum
  }
  measure: PSS_count {
    group_label: "Organizations"
    type: sum
  }
  measure: TAC_count {
    group_label: "Organizations"
    type: sum
  }
  measure: TRA_count {
    group_label: "Organizations"
    type: sum
  }
  measure: WLR_count {
    group_label: "Organizations"
    type: sum
  }
  dimension: label {
    sql: 'Organization' ;;
  }

}
