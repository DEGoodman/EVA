int setLuminosity(){
  println("hour: " + hour());
  if (hour() < 12)
    return hour() + 1;
  else {
    int h = int(map(hour(), 12, 23, 12, 1));
    return h;
  }
}

void getData() {
  lightRes = getLight();
  temperature = getTemp();
} 

int getGainLevel() {
  /* I can normalize the 'gain' (here, the power) by making an array and reading in the levels, and take average.
   * can update the array (array[i] = array[i+1], array[last] = new level), then average results
   * scale accordingly to get reasonable 'power'
   sa*/

 float maxVolume = in.mix.level();
    
  // scale maxVolume for MAX GAINZ!!!!  0.02-0.14
  if (maxVolume <= 0.02) {
    seeLines = false;
    return 65 + gainModifier;
  }  
  else if (maxVolume <= 0.07){ 
    if (gainModifier < 1)
      seeLines();
    else
      seeLines = false;
    return 50 + gainModifier;
  }  
  else if (maxVolume <= 0.14) { 
    seeLines();
    return 35 + gainModifier; 
  }  
  else if (maxVolume <= 0.20){
    seeLines = false;
    for(int i = 0; i < numCircles; i++)
      rounds[i].isVisible = !rounds[i].isVisible;
    return 25 + gainModifier;
  }  
  else{
    seeLines = false;
    return 18 + gainModifier;
  }  
}

//turn on connecting lines
void seeLines(){
  if (!seeLines && !wait) {
    seeLines = true;
    lineCounter = 1000;
  }  
}    

// based on time of day
int getLight() {
  temp = setLuminosity();
  return temp;
}  

//from user location
int getTemp() {
  //find users' local temperature
  int t = int(weather.getTemperature());
  if(t > 120)
    t = 120;
  if(t < 20)
    t = 20;  
  return 55;
}  

// return capital city of a given country
// I know this is a terrible method, but it is faster than an API call
String getCity(String countryIn){
    cc = new StringDict();
    cc.set("Afghanistan","Kabul");
    cc.set("Albania","Tirane");
    cc.set("Algeria","Algiers");
    cc.set("Andorra","Andorra la Vella");
    cc.set("Angola","Luanda");
    cc.set("Antigua and Barbuda","Saint John's");
    cc.set("Argentina","Buenos Aires");
    cc.set("Armenia","Yerevan");
    cc.set("Australia","Canberra");
    cc.set("Austria","Vienna");
    cc.set("Azerbaijan","Baku");
    cc.set("Bahrain","Manama");
    cc.set("Bangladesh","Dhaka");
    cc.set("Barbados","Bridgetown");
    cc.set("Belarus","Minsk");
    cc.set("Belgium","Brussels");
    cc.set("Belize","Belmopan");
    cc.set("Benin","Porto-Novo");
    cc.set("Bhutan","Thimphu");
    cc.set("Bolivia","La Paz");
    cc.set("Bosnia and Herzegovina","Sarajevo");
    cc.set("Botswana","Gaborone");
    cc.set("Brazil","Brasilia");
    cc.set("Brunei","Bandar Seri Begawan");
    cc.set("Bulgaria","Sofia");
    cc.set("Burkina Faso","Ouagadougou");
    cc.set("Burma","Rangoon");
    cc.set("Burundi","Bujumbura");
    cc.set("Cambodia","Phnom Penh");
    cc.set("Cameroon","Yaounde");
    cc.set("Canada","Ottawa");
    cc.set("Cape Verde","Praia");
    cc.set("Central African Republic","Bangui");
    cc.set("Chad","N'Djamena");
    cc.set("Chile","Santiago");
    cc.set("China","Beijing");
    cc.set("Colombia","Bogota");
    cc.set("Comoros","Moroni");
    cc.set("Costa Rica","San Jose");
    cc.set("Cote d'Ivoire","Yamoussoukro");
    cc.set("Croatia","Zagreb");
    cc.set("Cuba","Havana");
    cc.set("Cyprus","Nicosia");
    cc.set("Czech Republic","Prague");
    cc.set("Democratic Republic of the Congo","Kinshasa");
    cc.set("Denmark","Copenhagen");
    cc.set("Djibouti","Djibouti");
    cc.set("Dominica","Roseau");
    cc.set("Dominican Republic","Santo Domingo");
    cc.set("East Timor","Dili");
    cc.set("Ecuador","Quito");
    cc.set("Egypt","Cairo");
    cc.set("El Salvador","San Salvador");
    cc.set("Equatorial Guinea","Malabo");
    cc.set("Eritrea","Asmara");
    cc.set("Estonia","Tallinn");
    cc.set("Ethiopia","Addis Ababa");
    cc.set("Federated States of Micronesia","Palikir");
    cc.set("Fiji","Suva");
    cc.set("Finland","Helsinki");
    cc.set("France","Paris");
    cc.set("Gabon","Libreville");
    cc.set("Georgia","Tbilisi");
    cc.set("Germany","Berlin");
    cc.set("Ghana","Accra");
    cc.set("Greece","Athens");
    cc.set("Grenada","Saint George's");
    cc.set("Guatemala","Guatemala City");
    cc.set("Guinea","Conakry");
    cc.set("Guinea-Bissau","Bissau");
    cc.set("Guyana","Georgetown");
    cc.set("Haiti","Port-au-Prince");
    cc.set("Honduras","Tegucigalpa");
    cc.set("Hungary","Budapest");
    cc.set("Iceland","Reykjavik");
    cc.set("India","New Delhi");
    cc.set("Indonesia","Jakarta");
    cc.set("Iran","Tehran");
    cc.set("Iraq","Baghdad");
    cc.set("Ireland","Dublin");
    cc.set("Israel","Jerusalem");
    cc.set("Italy","Rome");
    cc.set("Jamaica","Kingston");
    cc.set("Japan","Tokyo");
    cc.set("Jordan","Amman");
    cc.set("Kazakhstan","Astana");
    cc.set("Kenya","Nairobi");
    cc.set("Kiribati","Tarawa");
    cc.set("Kuwait","Kuwait City");
    cc.set("Kyrgyzstan","Bishtek");
    cc.set("Laos","Vientiane");
    cc.set("Latvia","Riga");
    cc.set("Lebanon","Beirut");
    cc.set("Lesotho","Maseru");
    cc.set("Liberia","Monrovia");
    cc.set("Libya","Tripoli");
    cc.set("Liechtenstein","Vaduz");
    cc.set("Lithuania","Vilnius");
    cc.set("Luxembourg","Luxembourg");
    cc.set("Macedonia","Skopje");
    cc.set("Madagascar","Antananarivo");
    cc.set("Malawi","Lilongwe");
    cc.set("Malaysia","Kuala Lumpur");
    cc.set("Maldives","Male");
    cc.set("Mali","Bamako");
    cc.set("Malta","Valletta");
    cc.set("Marshall Islands","Majuro");
    cc.set("Mauritania","Nouakchott");
    cc.set("Mauritius","Port Louis");
    cc.set("Mexico","Mexico City");
    cc.set("Moldova","Chisinau");
    cc.set("Monaco","Monaco");
    cc.set("Mongolia","Ulaanbaatar");
    cc.set("Morocco","Rabat");
    cc.set("Mozambique","Maputo");
    cc.set("Namibia","Windhoek");
    cc.set("Nauru","Yaren District");
    cc.set("Nepal","Kathmandu");
    cc.set("Netherlands","Amsterdam");
    cc.set("New Zealand","Wellington");
    cc.set("Nicaragua","Managua");
    cc.set("Niger","Niamey");
    cc.set("Nigeria","Abuja");
    cc.set("North Korea","Pyongyang");
    cc.set("Norway","Oslo");
    cc.set("Oman","Muscat");
    cc.set("Pakistan","Islamabad");
    cc.set("Palau","Koror");
    cc.set("Panama","Panama City");
    cc.set("Papua New Guinea","Port Moresby");
    cc.set("Paraguay","Asuncion");
    cc.set("Peru","Lima");
    cc.set("Philippines","Manila");
    cc.set("Poland","Warsaw");
    cc.set("Portugal","Lisbon");
    cc.set("Qatar","Doha");
    cc.set("Republic of the Congo","Brazzaville");
    cc.set("Romania","Bucharest");
    cc.set("Russia","Moscow");
    cc.set("Rwanda","Kigali");
    cc.set("Saint Kitts and Nevis","Basseterre");
    cc.set("Saint Lucia","Castries");
    cc.set("Saint Vincent and the Grenadines","Kingstown");
    cc.set("Samoa","Apia");
    cc.set("San Marino","San Marino");
    cc.set("Sao Tome and Principe","Sao Tome");
    cc.set("Saudi Arabia","Riyadh");
    cc.set("Senegal","Dakar");
    cc.set("Serbia and Montenegro","Belgrade");
    cc.set("Seychelles","Victoria");
    cc.set("Sierra Leone","Freetown");
    cc.set("Singapore","Singapore");
    cc.set("Slovakia","Bratislava");
    cc.set("Slovenia","Ljubljana");
    cc.set("Solomon Islands","Honiara");
    cc.set("Somalia","Mogadishu");
    cc.set("South Africa","Pretoria");
    cc.set("South Korea","Seoul");
    cc.set("Spain","Madrid");
    cc.set("Sri Lanka","Colombo");
    cc.set("Sudan","Khartoum");
    cc.set("Suriname","Paramaribo");
    cc.set("Swaziland","Mbabana");
    cc.set("Sweden","Stockholm");
    cc.set("Switzerland","Bern");
    cc.set("Syria","Damascus");
    cc.set("Taiwan","Taipei");
    cc.set("Tajikistan","Dushanbe");
    cc.set("Tanzania","Dar es Salaam");
    cc.set("Thailand","Bangkok");
    cc.set("The Bahamas","Nassau");
    cc.set("The Gambia","Banjul");
    cc.set("Togo","Lome");
    cc.set("Tonga","Nuku'alofa");
    cc.set("Trinidad and Tobago","Port-of-Spain");
    cc.set("Tunisia","Tunis");
    cc.set("Turkey","Ankara");
    cc.set("Turkmenistan","Ashgabat");
    cc.set("Tuvalu","Funafuti");
    cc.set("Uganda","Kampala");
    cc.set("Ukraine","Kiev");
    cc.set("United Arab Emirates","Abu Dhabi");
    cc.set("United Kingdom","London");
    cc.set("United States","Washington D.C.");
    cc.set("Uruguay","Montevideo");
    cc.set("Uzbekistan","Tashkent");
    cc.set("Vanuatu","Port-Vila");
    cc.set("Vatican City","Vatican City");
    cc.set("Venezuela","Caracas");
    cc.set("Vietnam","Hanoi");
    cc.set("Yemen","Sanaa");
    cc.set("Zambia","Lusaka");
    cc.set("Zimbabwe","Harare");
    
    return cc.get(countryIn);
}  

//get WOEID for place
// ex) http://where.yahooapis.com/v1/places.q('Sweden')?appid=9c75c376c3153f80997f44c13731758b995fda5f
String getW(){
  XML xml;
  
  GetRequest get = new GetRequest("http://where.yahooapis.com/v1/places.q('" + city + "')?appid=9c75c376c3153f80997f44c13731758b995fda5f");
  get.send();
  xml = loadXML(get.getContent());
  
  XML woeid = xml.getChild("woeid");
  w = woeid.getContent();
  
  return w; 
}


