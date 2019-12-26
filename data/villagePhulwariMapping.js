/*
with x as (select '["'||al.title||'", ['||string_agg('"'||u.name||'"', ', ')||']]' as value
from address_level al
      join virtual_catchment_address_mapping_table vat on vat.addresslevel_id = al.id
      join users u on u.catchment_id = vat.catchment_id
group by al.title)
select 1, '['||string_agg(x.value, ',
 ')||']' from x group by 1;
*/

const VILLAGE_PHULWARI_MAPPING = new Map([
 ["Aurapani", ["Birsingh Armo"]],
 ["Babutola", ["Test user", "Ramcharan Dhurve"]],
 ["Bahaud", ["Rupsing Tekam"]],
 ["Baheramuda", ["Ishwar Patel"]],
 ["Baigapara", ["Birsingh Armo"]],
 ["Bankal", ["Rupsing Tekam"]],
 ["Batipathara", ["Rajmumar Baiga"]],
 ["Bijarakachar", ["Rajmumar Baiga"]],
 ["Bisauni", ["Rajmumar Baiga"]],
 ["Bokarakachar", ["Rupsing Tekam"]],
 ["Chakada", ["Rajmumar Baiga"]],
 ["Dangniya", ["Test user", "Ramcharan Dhurve"]],
 ["Davanpur", ["Jitendra Yadav"]],
 ["Dudavadongari", ["Rajmumar Baiga"]],
 ["Ghameri", ["Rupsing Tekam"]],
 ["Jamunahi", ["Rupsing Tekam"]],
 ["Jharana", ["Ishwar Patel"]],
 ["Jhingatpur", ["Birsingh Armo"]],
 ["Jhiriya", ["Rajmumar Baiga"]],
 ["Kekaradih", ["Birsingh Armo"]],
 ["Kupabandha", ["Ishwar Patel"]],
 ["Mahamai", ["Rupsing Tekam"]],
 ["Mahuamacha", ["Rajmumar Baiga"]],
 ["Majhgoan", ["Birsingh Armo"]],
 ["Manjipara", ["Birsingh Armo"]],
 ["Manjuraha", ["Rajmumar Baiga"]],
 ["Manpur", ["Jitendra Yadav"]],
 ["Navadih", ["Birsingh Armo"]],
 ["Parasada", ["Jitendra Yadav"]],
 ["Parsaha", ["Rajmumar Baiga"]],
 ["Phulwaripara", ["Birsingh Armo"]],
 ["Piparkhunti", ["Jitendra Yadav"]],
 ["Salagi", ["Rajmumar Baiga"]],
 ["Sambhardhasan", ["Rupsing Tekam"]],
 ["Saraipali", ["Jitendra Yadav"]],
 ["Sarsoha", ["Rajmumar Baiga"]],
 ["Semaria", ["Birsingh Armo"]],
 ["Semipani", ["Ishwar Patel"]],
 ["Shivtarai", ["Jitendra Yadav"]],
 ["Vicharpur", ["Ishwar Patel"]]
]);

export default VILLAGE_PHULWARI_MAPPING;