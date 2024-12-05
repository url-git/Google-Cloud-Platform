%%bigquery --project produkcja-instore

Select *
from

(
SELECT media_source, campaign, sum(cast(event_revenue as float64)) as revenue,

case when media_source like 'organic' then 'organic'
when regexp_contains(campaign, (r'(521815663|559980723|559967985|525107730|865406387|525074431|525108647|13350954225|559964110|13756165807)')) or (regexp_contains(media_source, r'(?i)(Apple Search Ads|googleadwords_int|google)') and campaign is null) then 'SEM Marketing'
when regexp_contains(media_source, r'(?i)(rtbhouse|criteo)') then 'Remarketing zewnętrzny'
when regexp_contains(media_source, r'(?i)(BF LP|App10promo|af_banner|Owned_media|af_smartbanner)') then 'Strona Web'
when regexp_contains(campaign,  r'(?i)(af_banner)') then 'Strona Web'
when regexp_contains(campaign, r'(?i)(brand|marki)') and regexp_contains(media_source, r'(?i)(Facebook Ads|fb|facebook|ig|msg)') then 'Paid Social Marketing'
when regexp_contains(campaign, r'(?i)(propozycja)') and regexp_contains(media_source, r'(?i)(facebook ads|fb|msg|ig|an|facebook)') then 'Facebook Organic'
when regexp_contains(campaign, r'(?i)(BRAND)') and regexp_contains(media_source, r'(?i)(Apple Search Ads|googleadwords_int|google)') then 'SEM Performance Search Brand'
when regexp_contains(campaign, r'(?i)(WIDEO|MRKT|B2B)') and regexp_contains(media_source, r'(?i)(Apple Search Ads|googleadwords_int|google)') then 'SEM Marketing'
when regexp_contains(campaign, r'(?i)(GMC|GDN|Retail|SMART|RODZAJ|PLA|DSA|MEKT|MARKA|Rem|Asortyment|\d{8,})') and regexp_contains(media_source, r'(?i)(Apple Search Ads|googleadwords_int|google|yahoo)') then 'SEM Performance'
when regexp_contains(af_prt, r'(?i)(multichanelnetw)') then 'Sieci mobilne'
when regexp_contains(media_source, r'(?i)(appnext_int|restricted|bytedanceglobal_int)') then 'Sieci mobilne'
when regexp_contains(campaign, r'(?i)(domodi|newsweek|picodi|metapic|edipresse|gazeta)') and regexp_contains(media_source, r'(?i)(Tradedoubler|adhydra)') then 'Afiliacja portale'
when regexp_contains(campaign, r'(?i)(ceneo|alerabat|glami|stileo|cpc)') and regexp_contains(media_source, r'(?i)(Tradedoubler|adhydra|glami|stileo|zbozi|idealode|heureka)') then 'Porównywarki'
when regexp_contains(media_source, r'(?i)(awin|convertiser|adhydra|WPPL|Tradedoubler|vivnetworks)') then 'Afiliacja'
when regexp_contains(campaign, r'(?i)(wsparcieakcji)') and regexp_contains(media_source, r'(?i)(DV360|fb|Onet|Adplaner)') then 'Paid Social Performance Wsparcie Akcji'
when regexp_contains(campaign, r'(?i)(dpa|daba|marki|prospe|rabat|stories|propozycja|fb)') and regexp_contains(media_source, r'(?i)(fb|msg|ig|facebook|instagram|IGShopping|an)') then 'Paid Social Performance'
when regexp_contains(media_source, r'(?i)(googleadwords_int|appnext_int|google|sklik)') then 'SEM Performance'
when regexp_contains(campaign, r'(?i)(Webravo|instagram|Payback|allemarkt)') and regexp_contains(media_source, r'(?i)(awin|convertiser|Awin)') then 'Afiliacja'
when regexp_contains(campaign, r'(?i)(mailing)') and regexp_contains(media_source, r'(?i)(WPPL|interia)') then 'Mailing zewnętrzny'
when regexp_contains(campaign, r'(?i)(wakacje|code_news|ulubiona|wsparcieakcji|skechers|esizeme|newsletter)') and regexp_contains(media_source, r'(?i)(synerise)') then 'Newsletter'
when regexp_contains(campaign, r'(?i)((\d{8,})|welcome|top3marki)') and media_source in ('synerise') then 'Web push'
when regexp_contains(campaign, r'(?i)(pozapisie|nizszacena|pozapisiewinter|cart|visit|cart|)')  and regexp_contains(media_source, r'(?i)(synerise)') then 'Automaty'
when regexp_contains(campaign, r'(?i)(wsparcieakcji)') and regexp_contains(media_source, r'(?i)(Admetrics)') then 'SMS'
when regexp_contains(media_source, r'(?i)(doubleclick_int)') then 'Programmatic + Display'
else 'Pozostałe' END as kanal_ogolne,


case when media_source like 'organic' then 'organic'
when regexp_contains(media_source, (r'(criteo)')) then 'Criteo'
when regexp_contains(media_source, (r'(rtbhouse)')) then 'RTB'
when regexp_contains(media_source, r'(?i)(bf lp|app10promo|af_banner|owned_media|af_smartbanner)') then 'Strona Web'
when regexp_contains(campaign, r'(?i)(af_banner)') then 'Strona Web'
when regexp_contains(campaign, r'(?i)(marki)') and regexp_contains(media_source, r'(?i)(facebook ads|fb|msg|ig|an)') then 'Paid Social Marketing b2b'
when regexp_contains(campaign, r'(?i)(brand)') and regexp_contains(media_source, r'(?i)(facebook ads|fb|msg|ig|an)') then 'Paid Social Marketing brand'
when regexp_contains(campaign, r'(?i)(prospe)') and not regexp_contains(campaign, r'(?i)(wsparcieakcji)') and regexp_contains(media_source, r'(?i)(facebook ads|fb|msg|ig|an)') then 'Paid Social Performance prospecting'
when regexp_contains(campaign, r'(?i)(rem|rtg)') and regexp_contains(media_source, r'(?i)(facebook ads|fb|msg|ig|an)') then 'Paid Social Performance remarketing'
when regexp_contains(campaign, r'(?i)(wsparcieakcji)') and regexp_contains(media_source, r'(?i)(fb|dv360|ig|an|msg|Onet|ginorossi)') then 'Paid Social Performance Wsparcie Akcji'
when regexp_contains(campaign, r'(?i)(daba|.*)|fb') and regexp_contains(media_source, r'(?i)(facebook ads|fb|msg|ig|an|igshopping|instagram)') and not regexp_contains(media_source, r'(?i)(bytedanceglobal_int)') then 'Paid Social other'
when regexp_contains(campaign, r'(?i)(propozycja)') and regexp_contains(media_source, r'(?i)(facebook ads|fb|msg|ig|an|facebook)') then 'Facebook Organic'
when regexp_contains(af_prt, r'(?i)(multichanelnetw)') then 'Sieci mobilne'
when regexp_contains(media_source, r'(?i)(appnext_int|restricted|bytedanceglobal_int)') then 'Sieci mobilne'
when regexp_contains(campaign, r'(?i)(domodi|newsweek|picodi|metapic|edipresse|gazeta)') and regexp_contains(media_source, r'(?i)(tradedoubler|adhydra)') then 'Afiliacja portale'
when regexp_contains(campaign, r'(?i)(domodi|glami.\D\D|cpc|cp|cpc_polecane|(not set))')
and regexp_contains(media_source, r'(?i)(domodi|glami.\D\D|lamoda|listupp|shopalike|ceneo)') then 'Porównywarki Produktowe'
when regexp_contains(campaign, r'(?i)(stileo|direct_link|cpc|(not set)|ceneo|ck_alerabat)')
and regexp_contains(media_source, r'(?i)(okazje\.info\.pl|skapiec.pl|kaina24.lt|stileo|shopmania|zbozi|nokaut.pl|idealo|adhydra|tradedoubler|heureka)') then 'Porównywarki Cenowe'
when regexp_contains(campaign, r'(?i)(webravo|instagram|payback|allemarkt|ceneo|wp_mailing|ck_alerabat|epso group|shop|lety|paypo)')
and regexp_contains(media_source, r'(?i)(awin|convertiser|awin|adhydra|wppl|tradedoubler|vivnetworks)') then 'Afiliacja'
when regexp_contains(media_source, r'(?i)(awin|convertiser|awin|adhydra|wppl|tradedoubler|vivnetworks)') then 'Afiliacja'
when regexp_contains(campaign, r'(?i)(%)') and regexp_contains(campaign, r'(?i)(remarketing sdc|remarketing)') and not regexp_contains(campaign, r'(?i)(MRKT)') and regexp_contains(media_source, r'(?i)(apple search ads|googleadwords_int|google|sklik)') then 'SEM Performance Remarketing'
when regexp_contains(campaign, r'(?i)(^#.*)') and not regexp_contains(campaign, r'(?i)(CPA|RODZAJ|SSC|B2B|BRAND)') and regexp_contains(media_source, r'(?i)(apple search ads|googleadwords_int|google|sklik)') then 'SEM Performance PLA'
when regexp_contains(campaign, r'(?i)(brand)') and regexp_contains(media_source, r'(?i)(apple search ads|googleadwords_int|google)') then 'SEM Performance Search Brand'
when regexp_contains(campaign, r'(?i)(rem dyn)') and regexp_contains(media_source, r'(?i)(apple search ads|googleadwords_int|google|sklik)') then 'SEM Performance REM DYN'
when regexp_contains(campaign, r'(?i)(SSC)') and not regexp_contains(campaign, r'(?i)(MRKT|B2B)') and regexp_contains(media_source, r'(?i)(apple search ads|googleadwords_int|google|sklik)') then 'SEM Performance SSC'
when regexp_contains(media_source, r'(?i)(yahoo)') then "SEM Performance inne"
when regexp_contains(campaign, r'(?i)(marka)') and not regexp_contains(campaign, r'(?i)(MRKT)') and regexp_contains(media_source, r'(?i)(apple search ads|googleadwords_int|google)') then 'SEM Performance Search MARKA'
when regexp_contains(campaign, r'(?i)(gdn)') and regexp_contains(campaign, r'(?i)(b2b)') and regexp_contains(media_source, r'(?i)(apple search ads|googleadwords_int|google|sklik)') then 'SEM Marketing B2B Display'
when regexp_contains(campaign, r'(?i)(MRKT)') and regexp_contains(campaign, r'(?i)(%)') and regexp_contains(media_source, r'(?i)(apple search ads|googleadwords_int|google|sklik)') then 'SEM Marketing Display'
when regexp_contains(campaign, r'(?i)(gdn)') and regexp_contains(media_source, r'(?i)(apple search ads|googleadwords_int|google|sklik)') then 'SEM Performance GDN'
when regexp_contains(campaign, r'(?i)(^$.*)') and regexp_contains(campaign, r'(?i)(rodzaj)') and not regexp_contains(campaign, r'(?i)(konkurencja)')  and regexp_contains(media_source, r'(?i)(apple search ads|googleadwords_int|google)') then 'SEM Performance Search RODZAJ'
when regexp_contains(campaign, r'(?i)(^$.*)') and regexp_contains(campaign, r'(?i)(konkurencja)') and regexp_contains(media_source, r'(?i)(apple search ads|googleadwords_int|google)') then 'SEM Performance Search Konkurencja'
when regexp_contains(campaign, r'(?i)(^$.*)') and not regexp_contains(campaign, r'(?i)(MRKT|%)') and regexp_contains(media_source, r'(?i)(apple search ads|googleadwords_int|google)') then 'SEM Performance Search Inne'
when regexp_contains(campaign, r'(?i)(mrkt|mekt|gmc|eobuwie|\d{8,})') and regexp_contains(media_source, r'(?i)(apple search ads|googleadwords_int|google)') then 'SEM Marketing inne'
when regexp_contains(media_source, r'(?i)(googleadwords_int|google|sklik)') then 'SEM Marketing Inne'
when regexp_contains(media_source, r'(?i)(apple search ads|googleadwords_int|google|yahoo)') then 'SEM Performance inne'
when regexp_contains(campaign, r'(?i)(pozapisie|pozapisiewinter|visit|cart|esizmerabat|unsubscribe_news|favorites|accept_news|nizszacena)') and regexp_contains(media_source, r'(?i)(synerise)') then 'Automaty'
when regexp_contains(campaign, r'(?i)(wakacje|code_news|cart|ulubiona||wsparcieakcji)') and not regexp_contains(campaign, r'(?i)(22062021_adidas_ny|welcome|top3marki|20210709_topmarki)') and regexp_contains(media_source, r'(?i)(synerise)') then 'Newsletter'
when regexp_contains(campaign, r'(?i)((\d{8,})|favorites|accept_news|welcome|top3marki)') and media_source in ('synerise') then 'Web push'
when regexp_contains(campaign, r'(?i)(wsparcieakcji)') and regexp_contains(media_source, r'(?i)(admetrics)') then 'SMS'
when regexp_contains(media_source, r'(?i)(doubleclick_int)') then 'Programmatic + Display'
else 'Pozostałe' END as kanal_szczegolowe,



FROM `eobuwie-181013.01_AppsFlyer_EOB.mobile_devices_events`
where is_primary_attribution = true
and partition_time > '2021-06-15'
group by 1,2,4,5
order by 3 desc) as t1
limit 5