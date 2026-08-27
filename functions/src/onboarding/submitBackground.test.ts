import { validateBackgroundBody } from "./submitBackground";

describe("validateBackgroundBody", () => {
  it("accepts a fully-populated valid body and normalizes it", () => {
    const result = validateBackgroundBody({
      industry: "  Software  ",
      role: "Engineer",
      educationLevel: "postgraduate",
      locationQuery: "Bengaluru, India",
      latitude: 12.9716,
      longitude: 77.5946,
    });

    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.value).toEqual({
      industry: "Software", // trimmed
      role: "Engineer",
      education_level: "postgraduate",
      location_query: "Bengaluru, India",
      location: { lat: 12.9716, lng: 77.5946 },
    });
  });

  it("defaults everything to null for an empty body", () => {
    const result = validateBackgroundBody({});
    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.value).toEqual({
      industry: null,
      role: null,
      education_level: null,
      location_query: null,
      location: null,
    });
  });

  it("rejects an invalid education level", () => {
    const result = validateBackgroundBody({ educationLevel: "phd_dropout" });
    expect(result.ok).toBe(false);
    if (result.ok) return;
    expect(result.error).toMatch(/educationLevel/i);
  });

  it("rejects latitude outside [-90, 90]", () => {
    expect(
      validateBackgroundBody({ latitude: 91, longitude: 10 }).ok,
    ).toBe(false);
    expect(
      validateBackgroundBody({ latitude: -90.1, longitude: 10 }).ok,
    ).toBe(false);
  });

  it("rejects longitude outside [-180, 180]", () => {
    expect(
      validateBackgroundBody({ latitude: 10, longitude: 181 }).ok,
    ).toBe(false);
    expect(
      validateBackgroundBody({ latitude: 10, longitude: -180.5 }).ok,
    ).toBe(false);
  });

  it("rejects a lone latitude or longitude", () => {
    expect(validateBackgroundBody({ latitude: 12.34 }).ok).toBe(false);
    expect(validateBackgroundBody({ longitude: 56.78 }).ok).toBe(false);
  });

  it("accepts the range boundaries", () => {
    const result = validateBackgroundBody({
      latitude: -90,
      longitude: 180,
    });
    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.value.location).toEqual({ lat: -90, lng: 180 });
  });

  it("rejects non-numeric coordinates", () => {
    const result = validateBackgroundBody({
      latitude: "12.34",
      longitude: "56.78",
    });
    expect(result.ok).toBe(false);
  });
});
