import { validateOnboardingBody } from "./submitOnboarding";

describe("validateOnboardingBody", () => {
  it("accepts a fully-populated valid body and normalizes it", () => {
    const result = validateOnboardingBody({
      birthdate: "1998-05-20",
      gender: "non_binary",
      customGenderIdentity: "  genderfluid  ",
      genderIdentityOptionIds: ["a", "b"],
      pronouns: ["They/Them"],
      customPronoun: null,
      showGenderOnProfile: true,
      showPronounsOnProfile: false,
      sexualOrientation: "queer",
      showSexualOrientationOnProfile: true,
      datingPreferences: ["men", "open_to_all"],
      datingGoalIds: ["long_term"],
    });

    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.value).toEqual({
      birthdate: "1998-05-20",
      gender: "non_binary",
      custom_gender_identity: "genderfluid", // trimmed
      gender_identity_option_ids: ["a", "b"],
      pronouns: ["They/Them"],
      custom_pronoun: null,
      show_gender_on_profile: true,
      show_pronouns_on_profile: false,
      sexual_orientation: "queer",
      show_sexual_orientation_on_profile: true,
      dating_preferences: ["men", "open_to_all"],
      dating_goal_ids: ["long_term"],
    });
  });

  it("defaults arrays and booleans for an empty body", () => {
    const result = validateOnboardingBody({});
    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.value.birthdate).toBeNull();
    expect(result.value.gender).toBeNull();
    expect(result.value.sexual_orientation).toBeNull();
    expect(result.value.dating_preferences).toEqual([]);
    expect(result.value.pronouns).toEqual([]);
    expect(result.value.show_gender_on_profile).toBe(false);
  });

  it("rejects an invalid gender enum", () => {
    const result = validateOnboardingBody({ gender: "attack_helicopter" });
    expect(result.ok).toBe(false);
    if (result.ok) return;
    expect(result.error).toMatch(/gender/i);
  });

  it("rejects an invalid sexual orientation", () => {
    const result = validateOnboardingBody({ sexualOrientation: "confused" });
    expect(result.ok).toBe(false);
  });

  it("rejects an invalid dating preference inside the array", () => {
    const result = validateOnboardingBody({
      datingPreferences: ["men", "aliens"],
    });
    expect(result.ok).toBe(false);
    if (result.ok) return;
    expect(result.error).toMatch(/dating preference/i);
  });

  it("rejects a malformed birthdate", () => {
    expect(validateOnboardingBody({ birthdate: "20-05-1998" }).ok).toBe(false);
    expect(validateOnboardingBody({ birthdate: "1998-13-40" }).ok).toBe(false);
    expect(validateOnboardingBody({ birthdate: 19980520 }).ok).toBe(false);
  });

  it("rejects a non-array datingPreferences", () => {
    const result = validateOnboardingBody({ datingPreferences: "men" });
    expect(result.ok).toBe(false);
  });
});
