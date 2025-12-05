


with months as (
    select 
        seq month_number
    from 
    seq_1_to_12 as months
),
years as (
    select 
        year(now()) -  5 + seq year_number
    from 
    seq_1_to_10 as years
),
calendar as (
    select 
        months.month_number,
        years.year_number
    from months join years on 1=1 and years.year_number <= year(now())
),
marketlist as (
    select 'Amazon' as market union all
    select 'eBay Payment' union all
    select 'Kaufland' union all
    select 'Metro Paypal' union all
    select 'OTTO Payment' union all
    select 'paypal' union all
    select 'PayPal: PayPal' union all
    select 'PayPal: Rechnungskauf' union all
    select 'PayPalExpress' union all
    select 'PayPalPlus' 
),
plenty as (
    select 
        month(datum) as month_number,
        year(datum) as  year_number,
        sum(brutto) as sales
    from 
        blg_hdr_plenty
    group by 
        month(datum),
        year(datum)
),
plenty_markets as (
    select 
        month(datum) as month_number,
        year(datum) as  year_number,
        sum(brutto) as sales
    from 
        blg_hdr_plenty
        
    where zahlungsart in (
        select marketlist.market from marketlist
    )
    
    group by 
        month(datum),
        year(datum)
),
plenty_not_markets as (
    select 
        month(datum) as month_number,
        year(datum) as  year_number,
        sum(brutto) as sales
    from 
        blg_hdr_plenty
        
    where zahlungsart not in (
        select marketlist.market from marketlist
    )
    
    group by 
        month(datum),
        year(datum)
),
amazonmarket as (
    select 
        month(vdatum) as month_number,
        year(vdatum) as  year_number,
        sum(brutto) as payments
    from 
        blg_pos_amazonmarket
        where saldenausgleich <> 0 and saldenausgleich is not null
    group by 
        month(vdatum),
        year(vdatum)
),
ottoauszahlung as (
    select 
        month(vdatum) as month_number,
        year(vdatum) as  year_number,
        sum(brutto) as payments
    from 
        blg_pos_ottoauszahlung
        where saldenausgleich <> 0 and saldenausgleich is not null
    group by 
        month(vdatum),
        year(vdatum)
),

paypal as (
    select 
        month(vdatum) as month_number,
        year(vdatum) as  year_number,
        sum(brutto) as payments
    from 
        blg_pos_paypal
        where saldenausgleich <> 0 and saldenausgleich is not null 
    group by 
        month(vdatum),
        year(vdatum)
),
ebay as (
    select 
        month(vdatum) as month_number,
        year(vdatum) as  year_number,
        sum(brutto) as payments
    from 
        blg_pos_ebay
        where saldenausgleich <> 0 and saldenausgleich is not null 
    group by 
        month(vdatum),
        year(vdatum)
),
kaufland as (
    select 
        month(vdatum) as month_number,
        year(vdatum) as  year_number,
        sum(brutto) as payments
    from 
        blg_pos_kaufland
        where saldenausgleich <> 0 and saldenausgleich is not null 
    group by 
        month(vdatum),
        year(vdatum)
),
amazon_pay as (
    select 
        month(vdatum) as month_number,
        year(vdatum) as  year_number,
        sum(brutto) as payments
    from 
        blg_pos_amazon_pay
    where saldenausgleich <> 0 and saldenausgleich is not null 
    group by 
        month(vdatum),
        year(vdatum)
),

overview as (

select 
    calendar.year_number,
    calendar.month_number,

    ifnull(plenty.sales, 0) total_sales,
    if( plenty.sales is null,'N/A','ok' ) plenty_message,


    ifnull(plenty_markets.sales, 0) plenty_markets_sales,
    if( plenty_markets.sales is null,'N/A','ok' ) plenty_markets_message,


    ifnull(plenty_not_markets.sales, 0) plenty_not_markets_sales,
    if( plenty_not_markets.sales is null,'N/A','ok' ) plenty_not_markets_message,

    
    ifnull(amazonmarket.payments, 0) amazonmarket_payments,
    if( amazonmarket.payments is null,'N/A','ok' ) amazonmarket_message,

        ifnull(ottoauszahlung.payments, 0) ottoauszahlung_payments,
    if( ottoauszahlung.payments is null,'N/A','ok' ) ottoauszahlung_message,

    ifnull(paypal.payments, 0) paypal_payments,
    if( paypal.payments is null,'N/A','ok' ) paypal_message,

    ifnull(ebay.payments, 0) ebay_payments,
    if( ebay.payments is null,'N/A','ok' ) ebay_message,

    ifnull(kaufland.payments, 0) kaufland_payments,
    if( kaufland.payments is null,'N/A','ok' ) kaufland_message,

    ifnull(amazon_pay.payments, 0) amazon_pay_payments,
    if( amazon_pay.payments is null,'N/A','ok' ) amazon_pay_message

from 
    calendar
    left join plenty
        on (calendar.year_number,calendar.month_number) = (plenty.year_number,plenty.month_number)
    left join plenty_markets
        on (calendar.year_number,calendar.month_number) = (plenty_markets.year_number,plenty_markets.month_number)

    left join plenty_not_markets
        on (calendar.year_number,calendar.month_number) = (plenty_not_markets.year_number,plenty_not_markets.month_number)

    left join amazonmarket
        on (calendar.year_number,calendar.month_number) = (amazonmarket.year_number,amazonmarket.month_number)
    left join ottoauszahlung
        on (calendar.year_number,calendar.month_number) = (ottoauszahlung.year_number,ottoauszahlung.month_number)
    left join paypal
        on (calendar.year_number,calendar.month_number) = (paypal.year_number,paypal.month_number)
    left join ebay
        on (calendar.year_number,calendar.month_number) = (ebay.year_number,ebay.month_number)
    left join kaufland
        on (calendar.year_number,calendar.month_number) = (kaufland.year_number,kaufland.month_number)
   left join amazon_pay
        on (calendar.year_number,calendar.month_number) = (amazon_pay.year_number,amazon_pay.month_number)

order by calendar.year_number,calendar.month_number
)
select 
    overview.* ,
    overview.amazonmarket_payments + overview.ottoauszahlung_payments + overview.paypal_payments + overview.ebay_payments + overview.kaufland_payments + overview.amazon_pay_payments as total_other_payments
from overview

order by overview.year_number,overview.month_number