public with sharing class WeatherService {

    private static final String API_KEY = 'YOUR_OPENWEATHER_API_KEY';
    private static final String BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';

    public class WeatherResponseWrapper {
        @AuraEnabled public String city;
        @AuraEnabled public String description;
        @AuraEnabled public Decimal temperature;
        @AuraEnabled public String icon;
    }

    @AuraEnabled(cacheable=false)
    public static WeatherResponseWrapper getWeatherData(String city) {
        if (String.isBlank(city)) {
            throw new AuraHandledException('City name is required.');
        }

        Http http = new Http();
        HttpRequest req = new HttpRequest();

        String endpoint =
            BASE_URL +
            '?q=' + EncodingUtil.urlEncode(city, 'UTF-8') +
            '&appid=' + API_KEY +
            '&units=metric';

        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        HttpResponse res = http.send(req);

        if (res.getStatusCode() != 200) {
            throw new AuraHandledException('Failed to retrieve weather data.');
        }

        Map<String, Object> payload =
            (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

        if (
            payload == null ||
            !payload.containsKey('weather') ||
            !payload.containsKey('main') ||
            !payload.containsKey('name')
        ) {
            throw new AuraHandledException('Invalid weather data structure.');
        }

        List<Object> weatherList = (List<Object>) payload.get('weather');
        Map<String, Object> mainMap = (Map<String, Object>) payload.get('main');

        if (weatherList == null || weatherList.isEmpty() || mainMap == null) {
            throw new AuraHandledException('Invalid weather data structure.');
        }

        Map<String, Object> firstWeather = (Map<String, Object>) weatherList[0];

        WeatherResponseWrapper wrapper = new WeatherResponseWrapper();
        wrapper.city = (String) payload.get('name');
        wrapper.description = firstWeather != null ? (String) firstWeather.get('description') : null;
        wrapper.icon = firstWeather != null ? (String) firstWeather.get('icon') : null;

        Object tempObj = mainMap.get('temp');
        if (tempObj == null) {
            throw new AuraHandledException('Invalid weather data structure.');
        }

        wrapper.temperature = Decimal.valueOf(String.valueOf(tempObj));

        return wrapper;
    }
}