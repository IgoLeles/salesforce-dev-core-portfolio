import { LightningElement, api, wire } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import getWeatherData from "@salesforce/apex/WeatherService.getWeatherData";

const ACCOUNT_FIELDS = ["Account.BillingCity"];

export default class AccountWeather extends LightningElement {
  @api recordId;

  city;
  weather;
  error;
  isLoading = false;

  @wire(getRecord, { recordId: "$recordId", fields: ACCOUNT_FIELDS })
  wiredAccount({ error, data }) {
    if (data) {
      this.city = data.fields.BillingCity.value;
      this.error = undefined;

      if (this.city) {
        this.fetchWeather();
      } else {
        this.weather = undefined;
        this.error = "No city found for this account.";
      }
    } else if (error) {
      this.weather = undefined;
      this.error = "Failed to load account data.";
    }
  }

  async fetchWeather() {
    this.isLoading = true;
    this.error = undefined;

    try {
      const result = await getWeatherData({ city: this.city });

      if (
        !result ||
        !result.description ||
        result.temperature === undefined ||
        !result.icon
      ) {
        this.weather = undefined;
        this.error = "Invalid weather data received.";
        return;
      }

      this.weather = result;
    } catch (e) {
      this.weather = undefined;
      this.error = "Failed to retrieve weather data.";
    } finally {
      this.isLoading = false;
    }
  }

  get iconUrl() {
    return this.weather && this.weather.icon
      ? `https://openweathermap.org/img/wn/${this.weather.icon}@2x.png`
      : null;
  }
}
