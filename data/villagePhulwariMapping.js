const VILLAGE_PHULWARI_MAPPING = new Map([
    ['Chaparava', ['']],
    ['Bindaval', ['Sumitrabai']],
    ['Achanakmar', ['kalindribai']],
    ['Sarasdol', ['Rampyari']],
    ['Sivalkhar', ['']],
    ['Lamani', ['']],
    ['TIlaidabara', ['']],
    ['Chuiha', ['']],
    ['Mangalpur', ['']],
    ['Karaka', ['Bachan bai']],
    ['Mohtara', ['']],
    ['Kewarapara', ['Seeta Khusro']],
    ['Jogipur', ['Kumari bai/Arati']],
    ['Nevasa', ['Kota bai']],
    ['Koripara', ['Ganeshiya bai']],
    ['Karpiha', ['Dhanbai, Pardesh, Narmada']],
    ['Saraipali', ['Sunita']],
    ['Shivtarai', ['Kantibai, Lalita Bai']],
    ['Manpur', ['Aradhana']],
    ['Piparkhunti', ['Maheshiya bai']],
    ['Davanpur', ['Tijmati, Uma bai']],
    ['Parasada', ['']],
    ['Niwaskhar', ['Anitabai, Bisahin']],
    ['Rajak', ['Samari bai']],
    ['Boiraha', ['Bajarahin']],
    ['Patparaha', ['Garbhibai']],
    ['Aurapani', ['', '']],
    ['Babutola', ['Kumari bai, Budheshwari']],
    ['Dangniya', ['Birashbai']],
    ['Katami', ['Dharmin bai']],
    ['Bamhani', ['Dulari bai, Shivbati']],
    ['Atariya', ['Kunti bai']],
    ['Surahi', ['Manju']],
    ['Jakadbandha', ['']],
    ['Jamunahi', ['Phumani, Pyaro bai']],
    ['Bahaud', ['Budhavarin bai']],
    ['Bankal', ['']],
    ['Bokarakachar', ['']],
    ['Sambhardhasan', ['']],
    ['Mahamai', ['Sumitra']],
    ['Ghameri', ['Lalita, Kaushilya']],
    ['Manjuraha', ['Phuleshwari']],
    ['Sarsoha', ['Matibai']],
    ['Bisauni', ['jaya bai, Manmati']],
    ['Dudavadongari', ['']],
    ['Chakada', ['']],
    ['Salagi', ['']],
    ['Parsaha', ['']],
    ['Bijarakachar', ['Syamkali/Sukhiya']],
    ['Mahuamacha', ['Phulto/Sukriya']],
    ['Batipathara', ['']],
    ['Jhiriya', ['']],
    ['Baheramuda', ['Chandrkali /Sumitra']],
    ['Vicharpur', ['Rajkumari']],
    ['Semipani', ['']],
    ['Kupabandha', ['Nan bai']],
    ['Jharana', ['Kunjmati /Krushna bai']],
    ['Kholipara', ['Bindu Rashmi']],
    ['Badebarar', ['Deena, Rajeshwari']],
    ['Chotebarar', ['Purnima yadav']],
    ['Jhinjaripara', ['']],
    ['Ratkhandi', ['Anusuiya']],
    ['Karhikachar', ['Shanta, Ganeshiya']],
    ['Kekaradih', ['']],
    ['Navadih', ['']],
    ['Majhgoan', ['Bishahin bai']],
    ['Phulwaripara', ['Chanmani, Bilasho']],
    ['Semaria', ['Shanti, Ramshila']],
    ['Jhingatpur', ['Manibai']],
    ['Baigapara', ['Gayatri, sunita']],
    ['Manjipara', ['Sarota bai']],
    ['Bindaval',['Pramila']],
    ['Bindaval',['Rajani bai']],
    ['Achanakmar',['Kiran Netam']],
    ['Achanakmar',['Chamabai']],
    ['Sarasdol',['Kevara bai']],
    ['Sarasdol',['Rajkumari']],
    ['Sarasdol',['Santoshi bai']],
    ['Nevasa',['Omvati']],
    ['Nevasa',['Jalabai, Ganeshiya']],
    ['Nevasa',['Mahetarin, Dropati']],
    ['Koripara',['Rajmati, Purnima']],
    ['Shivtarai',['Mamta Bai']],
    ['Shivtarai',['Kaushilya bai']],
    ['Piparkhunti',['Ramila bai']],
    ['Davanpur',['Yogeshwari bai']],
    ['Davanpur',['Savita, Kamla']],
    ['Niwaskhar',['Duvasiya bai']],
    ['Rajak',['Sonmati']],
    ['Boiraha',['Jagmati']],
    ['Boiraha',['Bhagwantin']],
    ['Babutola',['Baisakhiya bai']],
    ['Dangniya',['Rajmati']],
    ['Dangniya',['Andiyaro bai']],
    ['Dangniya',['Bigari bai']],
    ['Dangniya',['Ramshibai']],
    ['Dangniya',['Kuvariya bai']],
    ['Katami',['Ramshila, Tiharin']],
    ['Atariya',['sanmat bai']],
    ['Surahi',['Dukhiya bai']],
    ['Surahi',['Devbati']],
    ['Surahi',['Kachra bai, prambai']],
    ['Jamunahi',['Hemvati']],
    ['Jamunahi',['Soniya']],
    ['Jamunahi',['Seeta bai']],
    ['Bahaud',['Shyamkali']],
    ['Mahamai',['Susma bai']],
    ['Mahamai',['Ramjaniya']],
    ['Ghameri',['Kumari']],
    ['Sarsoha',['Sangita bai']],
    ['Sarsoha',['Anitabai']],
    ['Mahuamacha',['Sunita/Darogin']],
    ['Vicharpur',['Rampyari Tirki']],
    ['Chotebarar',['Triveni']],
    ['Ratkhandi',['Manmati']],
    ['Ratkhandi',['Rajkumari']],
    ['Ratkhandi',['Birsiya']],
    ['Karhikachar',['Parmeswari, Shivkumari']],
    ['Karhikachar',['Chandrika']],
    ['Karhikachar',['Heera']],
    ['Karhikachar',['Rajkumari']],
    ['Semaria',['Duleshari']],
    ['Semaria',['Priti Madhukar']],
    ['Jhingatpur',['Rambai, Ramphul']],
    ['Jhingatpur',['Sunita Bhanu']]
]);
export default VILLAGE_PHULWARI_MAPPING;
