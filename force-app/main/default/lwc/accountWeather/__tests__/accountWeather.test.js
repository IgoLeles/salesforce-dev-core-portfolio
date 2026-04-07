import { createElement } from "lwc";
import AccountWeather from "c/accountWeather";
import { getRecord } from "lightning/uiRecordApi";
import getWeatherData from "@salesforce/apex/WeatherService.getWeatherData";
import { registerLdsTestWireAdapter } from "@salesforce/wire-service-jest-util";

const getRecordAdapter = registerLdsTestWireAdapter(getRecord);

jest.mock(
  "@salesforce/apex/WeatherService.getWeatherData",
  () => {
    return {
      default: jest.fn()
    };
  },
  { virtual: true }
);

function flushPromises() {
  return Promise.resolve();
}

describe("c-account-weather", () => {
  afterEach(() => {
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
    jest.clearAllMocks();
  });

  it("displays weather data successfully", async () => {
    getWeatherData.mockResolvedValue({
      city: "Sao Paulo",
      description: "clear sky",
      temperature: 26,
      icon: "01d"
    });

    const element = createElement("c-account-weather", {
      is: AccountWeather
    });
    element.recordId = "001XXXXXXXXXXXXXXX";
    document.body.appendChild(element);

    getRecordAdapter.emit({
      fields: {
        BillingCity: {
          value: "Sao Paulo"
        }
      }
    });

    await flushPromises();
    await flushPromises();

    expect(element.shadowRoot.textContent).toContain("Sao Paulo");
    expect(element.shadowRoot.textContent).toContain("clear sky");
    expect(element.shadowRoot.textContent).toContain("26");
    expect(element.shadowRoot.querySelector("img")).not.toBeNull();
  });

  it("shows error when apex call fails", async () => {
    getWeatherData.mockRejectedValue(new Error("Apex error"));

    const element = createElement("c-account-weather", {
      is: AccountWeather
    });
    element.recordId = "001XXXXXXXXXXXXXXX";
    document.body.appendChild(element);

    getRecordAdapter.emit({
      fields: {
        BillingCity: {
          value: "Rio de Janeiro"
        }
      }
    });

    await flushPromises();
    await flushPromises();

    expect(element.shadowRoot.textContent).toContain(
      "Failed to retrieve weather data."
    );
  });

  it("shows error for invalid weather structure", async () => {
    getWeatherData.mockResolvedValue({
      city: "Curitiba",
      description: null,
      temperature: 18,
      icon: null
    });

    const element = createElement("c-account-weather", {
      is: AccountWeather
    });
    element.recordId = "001XXXXXXXXXXXXXXX";
    document.body.appendChild(element);

    getRecordAdapter.emit({
      fields: {
        BillingCity: {
          value: "Curitiba"
        }
      }
    });

    await flushPromises();
    await flushPromises();

    expect(element.shadowRoot.textContent).toContain(
      "Invalid weather data received."
    );
  });

  it("shows error when account has no city", async () => {
    const element = createElement("c-account-weather", {
      is: AccountWeather
    });
    element.recordId = "001XXXXXXXXXXXXXXX";
    document.body.appendChild(element);

    getRecordAdapter.emit({
      fields: {
        BillingCity: {
          value: null
        }
      }
    });

    await flushPromises();

    expect(element.shadowRoot.textContent).toContain(
      "No city found for this account."
    );
  });
});
