@isTest
private class WeatherServiceTest {
  @isTest
  static void testGetWeatherDataSuccess() {
    String mockBody = '{"weather":[{"description":"clear sky","icon":"01d"}],"main":{"temp":25.5},"name":"Sao Paulo"}';

    Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(200, mockBody));

    Test.startTest();
    WeatherService.WeatherResponseWrapper result = WeatherService.getWeatherData(
      'Sao Paulo'
    );
    Test.stopTest();

    System.assertNotEquals(null, result);
    System.assertEquals('Sao Paulo', result.city);
    System.assertEquals('clear sky', result.description);
    System.assertEquals(25.5, result.temperature);
    System.assertEquals('01d', result.icon);
  }

  @isTest
  static void testGetWeatherDataFailureResponse() {
    Test.setMock(
      HttpCalloutMock.class,
      new WeatherServiceMock(404, '{"message":"city not found"}')
    );

    Test.startTest();
    Boolean exceptionThrown = false;

    try {
      WeatherService.getWeatherData('InvalidCity');
    } catch (Exception e) {
      exceptionThrown = true;
    }

    Test.stopTest();
    System.assertEquals(true, exceptionThrown);
  }

  @isTest
  static void testGetWeatherDataInvalidStructure() {
    String mockBody = '{"foo":"bar"}';

    Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(200, mockBody));

    Test.startTest();
    Boolean exceptionThrown = false;

    try {
      WeatherService.getWeatherData('Rio');
    } catch (Exception e) {
      exceptionThrown = true;
    }

    Test.stopTest();
    System.assertEquals(true, exceptionThrown);
  }

  @isTest
  static void testGetWeatherDataBlankCity() {
    Test.startTest();
    Boolean exceptionThrown = false;

    try {
      WeatherService.getWeatherData('');
    } catch (Exception e) {
      exceptionThrown = true;
    }

    Test.stopTest();
    System.assertEquals(true, exceptionThrown);
  }
}
