package org.archfirst.examples;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.inject.Named;

@Named
@RequestScoped
public class TempConvPm {

    @Inject
    private TemperatureConverter converter;
    
    private double farenheit;
    private double celsius;
    private double farenheitResult;
    private double celsiusResult;
    
    // ----- Commands -----
    public void convertToCelsius() {
        celsiusResult = converter.convertToCelsius(farenheit);
    }

    public void convertToFarenheit() {
        farenheitResult = converter.convertToFarenheit(celsius);
    }

    // ----- Getters and Setters -----
    public double getFarenheit() {
        return farenheit;
    }
    public void setFarenheit(double farenheit) {
        this.farenheit = farenheit;
    }

    public double getCelsius() {
        return celsius;
    }
    public void setCelsius(double celsius) {
        this.celsius = celsius;
    }

    public double getFarenheitResult() {
        return farenheitResult;
    }
    public void setFarenheitResult(double farenheitResult) {
        this.farenheitResult = farenheitResult;
    }

    public double getCelsiusResult() {
        return celsiusResult;
    }
    public void setCelsiusResult(double celsiusResult) {
        this.celsiusResult = celsiusResult;
    }
}