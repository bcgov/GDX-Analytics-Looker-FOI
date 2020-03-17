connection: "redshift_pacific_time"

# Set the week start day to Sunday. Default is Monday
week_start_day: sunday

# Set fiscal year to begin April 1st -- https://docs.looker.com/reference/model-params/fiscal_month_offset
fiscal_month_offset: 3

# include all the views
include: "/Views/foi.view"

explore: foi {}
