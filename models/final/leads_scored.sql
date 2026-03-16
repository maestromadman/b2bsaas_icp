with staging as (
    select * from {{ ref('stg_leads') }}
),

scored as (
    select
        *,

        -- derived feature
        (has_salesforce + has_hubspot + has_marketo + has_pardot +
         has_outreach + has_segment + has_demandbase + has_drift +
         has_apollo + has_zoominfo + has_clearbit + has_intercom) as gtm_tool_count,

        -- ICP label
        case
            when size_rank between 2 and 4
            and latest_funding_usd > 10000000
            and (
                has_salesforce = 1
                or has_hubspot = 1
                or has_marketo = 1
                or has_pardot = 1
            )
            then 1
            else 0
        end as is_icp

    from staging
)

select * from scored