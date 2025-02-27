// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `English`
  String get language {
    return Intl.message(
      'English',
      name: 'language',
      desc: 'The current language',
      args: [],
    );
  }

  /// `My Plants`
  String get myPlants {
    return Intl.message('My Plants', name: 'myPlants', desc: '', args: []);
  }

  /// `Calendar`
  String get calendar {
    return Intl.message('Calendar', name: 'calendar', desc: '', args: []);
  }

  /// `Plant Wiki`
  String get plantWiki {
    return Intl.message('Plant Wiki', name: 'plantWiki', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Welcome to Plant Friends!`
  String get welcome {
    return Intl.message(
      'Welcome to Plant Friends!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Hello plant lover! ❤️ \n\nWhether you're a green thumb or just starting out, Plant Friends is your ultimate companion. With customized plant care, timely reminders, and helpful information, you'll keep your houseplants happy and healthy. \n\nLet’s make your indoor jungle thrive together! 🌿`
  String get greetings {
    return Intl.message(
      'Hello plant lover! ❤️ \n\nWhether you\'re a green thumb or just starting out, Plant Friends is your ultimate companion. With customized plant care, timely reminders, and helpful information, you\'ll keep your houseplants happy and healthy. \n\nLet’s make your indoor jungle thrive together! 🌿',
      name: 'greetings',
      desc: '',
      args: [],
    );
  }

  /// `Ready to get started?`
  String get getStarted {
    return Intl.message(
      'Ready to get started?',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Create an account or log in to manage your plants today.`
  String get createOrLogin {
    return Intl.message(
      'Create an account or log in to manage your plants today.',
      name: 'createOrLogin',
      desc: '',
      args: [],
    );
  }

  /// `LOGIN`
  String get login {
    return Intl.message('LOGIN', name: 'login', desc: '', args: []);
  }

  /// `SIGN UP`
  String get signUp {
    return Intl.message('SIGN UP', name: 'signUp', desc: '', args: []);
  }

  /// `Login to Plant Friends`
  String get loginTitle {
    return Intl.message(
      'Login to Plant Friends',
      name: 'loginTitle',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get email {
    return Intl.message('Email Address', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Forgot Password? `
  String get forgotPasswordQuestion {
    return Intl.message(
      'Forgot Password? ',
      name: 'forgotPasswordQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Reset Here`
  String get resetHere {
    return Intl.message('Reset Here', name: 'resetHere', desc: '', args: []);
  }

  /// `Or continue with`
  String get continueWithQuestion {
    return Intl.message(
      'Or continue with',
      name: 'continueWithQuestion',
      desc: '',
      args: [],
    );
  }

  /// `New to PlantFriends? `
  String get newQuestion {
    return Intl.message(
      'New to PlantFriends? ',
      name: 'newQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Email address cannot be empty`
  String get emailEmptyErrorMessage {
    return Intl.message(
      'Email address cannot be empty',
      name: 'emailEmptyErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email address format`
  String get emailInvalidErrorMessage {
    return Intl.message(
      'Invalid email address format',
      name: 'emailInvalidErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get passwordEmptyErrorMessage {
    return Intl.message(
      'Password cannot be empty',
      name: 'passwordEmptyErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Logged in as `
  String get loggedInMessage {
    return Intl.message(
      'Logged in as ',
      name: 'loggedInMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to login with Google: `
  String get googleLoginError {
    return Intl.message(
      'Failed to login with Google: ',
      name: 'googleLoginError',
      desc: '',
      args: [],
    );
  }

  /// `Create your Account`
  String get signUpTitle {
    return Intl.message(
      'Create your Account',
      name: 'signUpTitle',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Already have an Account? `
  String get alreadyQuestion {
    return Intl.message(
      'Already have an Account? ',
      name: 'alreadyQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginSmall {
    return Intl.message('Login', name: 'loginSmall', desc: '', args: []);
  }

  /// `Full name cannot be empty`
  String get fullNameEmptyErrorMessage {
    return Intl.message(
      'Full name cannot be empty',
      name: 'fullNameEmptyErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Google Sign-In was cancelled.`
  String get googleSignInCancelled {
    return Intl.message(
      'Google Sign-In was cancelled.',
      name: 'googleSignInCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get Google authentication tokens.`
  String get googleSignInNoTokens {
    return Intl.message(
      'Failed to get Google authentication tokens.',
      name: 'googleSignInNoTokens',
      desc: '',
      args: [],
    );
  }

  /// `Signed up as `
  String get signUpMessage {
    return Intl.message(
      'Signed up as ',
      name: 'signUpMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to sign up with Google: `
  String get googleSignUpError {
    return Intl.message(
      'Failed to sign up with Google: ',
      name: 'googleSignUpError',
      desc: '',
      args: [],
    );
  }

  /// `Reset your Password`
  String get resetYourPassword {
    return Intl.message(
      'Reset your Password',
      name: 'resetYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your Email Address`
  String get pleaseEnterEmail {
    return Intl.message(
      'Please enter your Email Address',
      name: 'pleaseEnterEmail',
      desc: '',
      args: [],
    );
  }

  /// `RESET PASSWORD`
  String get resetPasswordButton {
    return Intl.message(
      'RESET PASSWORD',
      name: 'resetPasswordButton',
      desc: '',
      args: [],
    );
  }

  /// `Result`
  String get result {
    return Intl.message('Result', name: 'result', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `How often do you remember to water your plants?`
  String get question1 {
    return Intl.message(
      'How often do you remember to water your plants?',
      name: 'question1',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get answer1_1 {
    return Intl.message('Daily', name: 'answer1_1', desc: '', args: []);
  }

  /// `Weekly`
  String get answer1_2 {
    return Intl.message('Weekly', name: 'answer1_2', desc: '', args: []);
  }

  /// `Monthly`
  String get answer1_3 {
    return Intl.message('Monthly', name: 'answer1_3', desc: '', args: []);
  }

  /// `Irregularly`
  String get answer1_4 {
    return Intl.message('Irregularly', name: 'answer1_4', desc: '', args: []);
  }

  /// `Pet warning: Check which plants are poisonous!`
  String get petWarning {
    return Intl.message(
      'Pet warning: Check which plants are poisonous!',
      name: 'petWarning',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Quiz!`
  String get welcomeQuiz {
    return Intl.message(
      'Welcome to the Quiz!',
      name: 'welcomeQuiz',
      desc: '',
      args: [],
    );
  }

  /// `Here we will ask about your room conditions and plant care habits. Based on your answers, we will recommend the best plants that suit you.`
  String get quizDescription {
    return Intl.message(
      'Here we will ask about your room conditions and plant care habits. Based on your answers, we will recommend the best plants that suit you.',
      name: 'quizDescription',
      desc: '',
      args: [],
    );
  }

  /// `Let's get started!`
  String get letsGetStarted {
    return Intl.message(
      'Let\'s get started!',
      name: 'letsGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Start Quiz`
  String get startQuizButton {
    return Intl.message(
      'Start Quiz',
      name: 'startQuizButton',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Plant`
  String get unknownPlant {
    return Intl.message(
      'Unknown Plant',
      name: 'unknownPlant',
      desc: '',
      args: [],
    );
  }

  /// `Take or pick a plant photo`
  String get takeOrPickPhoto {
    return Intl.message(
      'Take or pick a plant photo',
      name: 'takeOrPickPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Gallery`
  String get gallery {
    return Intl.message('Gallery', name: 'gallery', desc: '', args: []);
  }

  /// `My Plants`
  String get myPlantsTitle {
    return Intl.message('My Plants', name: 'myPlantsTitle', desc: '', args: []);
  }

  /// `Find your plants`
  String get findYourPlants {
    return Intl.message(
      'Find your plants',
      name: 'findYourPlants',
      desc: '',
      args: [],
    );
  }

  /// `No plants found in the search`
  String get noPlantsFound {
    return Intl.message(
      'No plants found in the search',
      name: 'noPlantsFound',
      desc: '',
      args: [],
    );
  }

  /// `Add new plant`
  String get addNewPlant {
    return Intl.message(
      'Add new plant',
      name: 'addNewPlant',
      desc: '',
      args: [],
    );
  }

  /// `I have all the data for my plant`
  String get allData {
    return Intl.message(
      'I have all the data for my plant',
      name: 'allData',
      desc: '',
      args: [],
    );
  }

  /// `I need help`
  String get needHelp {
    return Intl.message('I need help', name: 'needHelp', desc: '', args: []);
  }

  /// `Watering event marked as done`
  String get wateringDoneMessage {
    return Intl.message(
      'Watering event marked as done',
      name: 'wateringDoneMessage',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Watering Event Update`
  String get confirmWateringEventUpdate {
    return Intl.message(
      'Confirm Watering Event Update',
      name: 'confirmWateringEventUpdate',
      desc: '',
      args: [],
    );
  }

  /// `You've marked your plant as watered today, even though it's not scheduled for watering. All previous watering records for this plant will be deleted, and a new cycle will start from today. Do you want to proceed?`
  String get markedWatered {
    return Intl.message(
      'You\'ve marked your plant as watered today, even though it\'s not scheduled for watering. All previous watering records for this plant will be deleted, and a new cycle will start from today. Do you want to proceed?',
      name: 'markedWatered',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Low`
  String get low {
    return Intl.message('Low', name: 'low', desc: '', args: []);
  }

  /// `Watering events updated successfully`
  String get wateringEventsUpdatedSuccessfully {
    return Intl.message(
      'Watering events updated successfully',
      name: 'wateringEventsUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error updating events: `
  String get updatingEventsError {
    return Intl.message(
      'Error updating events: ',
      name: 'updatingEventsError',
      desc: '',
      args: [],
    );
  }

  /// `Proceed`
  String get proceed {
    return Intl.message('Proceed', name: 'proceed', desc: '', args: []);
  }

  /// `No Name`
  String get noName {
    return Intl.message('No Name', name: 'noName', desc: '', args: []);
  }

  /// `Water me!`
  String get waterMe {
    return Intl.message('Water me!', name: 'waterMe', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Plant Type`
  String get plantType {
    return Intl.message('Plant Type', name: 'plantType', desc: '', args: []);
  }

  /// `Water`
  String get water {
    return Intl.message('Water', name: 'water', desc: '', args: []);
  }

  /// `Watering Interval`
  String get wateringInterval {
    return Intl.message(
      'Watering Interval',
      name: 'wateringInterval',
      desc: '',
      args: [],
    );
  }

  /// ` day(s)`
  String get days {
    return Intl.message(' day(s)', name: 'days', desc: '', args: []);
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Next Watering`
  String get nextWatering {
    return Intl.message(
      'Next Watering',
      name: 'nextWatering',
      desc: '',
      args: [],
    );
  }

  /// `Show photo journal`
  String get showPhotoJournal {
    return Intl.message(
      'Show photo journal',
      name: 'showPhotoJournal',
      desc: '',
      args: [],
    );
  }

  /// `Easy`
  String get easy {
    return Intl.message('Easy', name: 'easy', desc: '', args: []);
  }

  /// `Direct Light`
  String get directLight {
    return Intl.message(
      'Direct Light',
      name: 'directLight',
      desc: '',
      args: [],
    );
  }

  /// `Cacti/Succulents`
  String get cacti {
    return Intl.message('Cacti/Succulents', name: 'cacti', desc: '', args: []);
  }

  /// `Delete Plant`
  String get deletePlant {
    return Intl.message(
      'Delete Plant',
      name: 'deletePlant',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this plant? This will also remove all associated watering events.`
  String get sureDeleting {
    return Intl.message(
      'Are you sure you want to delete this plant? This will also remove all associated watering events.',
      name: 'sureDeleting',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Error deleting image from storage: `
  String get errorDeleting {
    return Intl.message(
      'Error deleting image from storage: ',
      name: 'errorDeleting',
      desc: '',
      args: [],
    );
  }

  /// `Plant deleted successfully`
  String get deletedSuccessfully {
    return Intl.message(
      'Plant deleted successfully',
      name: 'deletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete plant: `
  String get failedToDelete {
    return Intl.message(
      'Failed to delete plant: ',
      name: 'failedToDelete',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting entries and images: `
  String get errorDeletingEntries {
    return Intl.message(
      'Error deleting entries and images: ',
      name: 'errorDeletingEntries',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting image from storage: `
  String get errorDeletingImages {
    return Intl.message(
      'Error deleting image from storage: ',
      name: 'errorDeletingImages',
      desc: '',
      args: [],
    );
  }

  /// `Watering Events Update`
  String get waterEventsUpdate {
    return Intl.message(
      'Watering Events Update',
      name: 'waterEventsUpdate',
      desc: '',
      args: [],
    );
  }

  /// `You changed the water needs. All existing watering events will be deleted and new ones will be created. Do you want to proceed?`
  String get waterNeedsChanged {
    return Intl.message(
      'You changed the water needs. All existing watering events will be deleted and new ones will be created. Do you want to proceed?',
      name: 'waterNeedsChanged',
      desc: '',
      args: [],
    );
  }

  /// `Plant details updated successfully`
  String get plantDetailsUpdatedSuccessfully {
    return Intl.message(
      'Plant details updated successfully',
      name: 'plantDetailsUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update plant details: `
  String get failedToUpdatePlantDetails {
    return Intl.message(
      'Failed to update plant details: ',
      name: 'failedToUpdatePlantDetails',
      desc: '',
      args: [],
    );
  }

  /// `Edit Plant`
  String get editPlant {
    return Intl.message('Edit Plant', name: 'editPlant', desc: '', args: []);
  }

  /// `Plant Name`
  String get plantName {
    return Intl.message('Plant Name', name: 'plantName', desc: '', args: []);
  }

  /// `Enter plant name`
  String get enterPlantName {
    return Intl.message(
      'Enter plant name',
      name: 'enterPlantName',
      desc: '',
      args: [],
    );
  }

  /// `Scientific Name`
  String get scientificName {
    return Intl.message(
      'Scientific Name',
      name: 'scientificName',
      desc: '',
      args: [],
    );
  }

  /// `Enter scientific name`
  String get enterScientificName {
    return Intl.message(
      'Enter scientific name',
      name: 'enterScientificName',
      desc: '',
      args: [],
    );
  }

  /// `Date of purchase`
  String get dateOfPurchase {
    return Intl.message(
      'Date of purchase',
      name: 'dateOfPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Select date of purchase`
  String get selectDateOfPurchase {
    return Intl.message(
      'Select date of purchase',
      name: 'selectDateOfPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Plant Care Information`
  String get plantCareInformation {
    return Intl.message(
      'Plant Care Information',
      name: 'plantCareInformation',
      desc: '',
      args: [],
    );
  }

  /// `Tropical Plants`
  String get tropicalPlants {
    return Intl.message(
      'Tropical Plants',
      name: 'tropicalPlants',
      desc: '',
      args: [],
    );
  }

  /// `Climbing Plants`
  String get climbingPlants {
    return Intl.message(
      'Climbing Plants',
      name: 'climbingPlants',
      desc: '',
      args: [],
    );
  }

  /// `Flowering Plants`
  String get floweringPlants {
    return Intl.message(
      'Flowering Plants',
      name: 'floweringPlants',
      desc: '',
      args: [],
    );
  }

  /// `Trees/Palms`
  String get trees {
    return Intl.message('Trees/Palms', name: 'trees', desc: '', args: []);
  }

  /// `Herbs`
  String get herbs {
    return Intl.message('Herbs', name: 'herbs', desc: '', args: []);
  }

  /// `Others`
  String get others {
    return Intl.message('Others', name: 'others', desc: '', args: []);
  }

  /// `Light Requirement`
  String get lightRequirement {
    return Intl.message(
      'Light Requirement',
      name: 'lightRequirement',
      desc: '',
      args: [],
    );
  }

  /// `Indirect Light`
  String get indirectLight {
    return Intl.message(
      'Indirect Light',
      name: 'indirectLight',
      desc: '',
      args: [],
    );
  }

  /// `Partial Shade`
  String get partialShade {
    return Intl.message(
      'Partial Shade',
      name: 'partialShade',
      desc: '',
      args: [],
    );
  }

  /// `Low Light`
  String get lowLight {
    return Intl.message('Low Light', name: 'lowLight', desc: '', args: []);
  }

  /// `Water Requirement`
  String get waterRequirement {
    return Intl.message(
      'Water Requirement',
      name: 'waterRequirement',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get medium {
    return Intl.message('Medium', name: 'medium', desc: '', args: []);
  }

  /// `High`
  String get high {
    return Intl.message('High', name: 'high', desc: '', args: []);
  }

  /// `Custom`
  String get custom {
    return Intl.message('Custom', name: 'custom', desc: '', args: []);
  }

  /// `Watering Interval (Days)`
  String get wateringIntervalDays {
    return Intl.message(
      'Watering Interval (Days)',
      name: 'wateringIntervalDays',
      desc: '',
      args: [],
    );
  }

  /// `Enter watering interval (1-50 days)`
  String get enterWateringInterval {
    return Intl.message(
      'Enter watering interval (1-50 days)',
      name: 'enterWateringInterval',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Choose Image Source`
  String get chooseImageSource {
    return Intl.message(
      'Choose Image Source',
      name: 'chooseImageSource',
      desc: '',
      args: [],
    );
  }

  /// `No photo selected yet.\nTap the camera icon to upload a photo.`
  String get noPhotoSelected {
    return Intl.message(
      'No photo selected yet.\nTap the camera icon to upload a photo.',
      name: 'noPhotoSelected',
      desc: '',
      args: [],
    );
  }

  /// `Identified Plant: `
  String get identifiedPlant {
    return Intl.message(
      'Identified Plant: ',
      name: 'identifiedPlant',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Select Plant Type`
  String get selectPlantType {
    return Intl.message(
      'Select Plant Type',
      name: 'selectPlantType',
      desc: '',
      args: [],
    );
  }

  /// `Select Light Requirement`
  String get selectLightRequirement {
    return Intl.message(
      'Select Light Requirement',
      name: 'selectLightRequirement',
      desc: '',
      args: [],
    );
  }

  /// `Select Water Requirement`
  String get selectWaterRequirement {
    return Intl.message(
      'Select Water Requirement',
      name: 'selectWaterRequirement',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all required fields.`
  String get fillRequiredFields {
    return Intl.message(
      'Please fill in all required fields.',
      name: 'fillRequiredFields',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get userId. Please sign in again.`
  String get failedToGetUserId {
    return Intl.message(
      'Failed to get userId. Please sign in again.',
      name: 'failedToGetUserId',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Hard`
  String get hard {
    return Intl.message('Hard', name: 'hard', desc: '', args: []);
  }

  /// `AI-Recognition`
  String get aiRecognition {
    return Intl.message(
      'AI-Recognition',
      name: 'aiRecognition',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load plant data`
  String get failedToLoadData {
    return Intl.message(
      'Failed to load plant data',
      name: 'failedToLoadData',
      desc: '',
      args: [],
    );
  }

  /// `Search by name or scientific name`
  String get searchByName {
    return Intl.message(
      'Search by name or scientific name',
      name: 'searchByName',
      desc: '',
      args: [],
    );
  }

  /// `No plants match this filter.`
  String get noPlantsMatch {
    return Intl.message(
      'No plants match this filter.',
      name: 'noPlantsMatch',
      desc: '',
      args: [],
    );
  }

  /// `Request to Add a Plant`
  String get request {
    return Intl.message(
      'Request to Add a Plant',
      name: 'request',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Add a new plant photo`
  String get addNewPhoto {
    return Intl.message(
      'Add a new plant photo',
      name: 'addNewPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Please select an image before adding.`
  String get selectImage {
    return Intl.message(
      'Please select an image before adding.',
      name: 'selectImage',
      desc: '',
      args: [],
    );
  }

  /// `Please select a date before adding.`
  String get selectDate {
    return Intl.message(
      'Please select a date before adding.',
      name: 'selectDate',
      desc: '',
      args: [],
    );
  }

  /// `Add Photo`
  String get addPhoto {
    return Intl.message('Add Photo', name: 'addPhoto', desc: '', args: []);
  }

  /// `Unknown Plant ID`
  String get unknownPlantId {
    return Intl.message(
      'Unknown Plant ID',
      name: 'unknownPlantId',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting photo from storage: `
  String get errorDeletingPhotoStorage {
    return Intl.message(
      'Error deleting photo from storage: ',
      name: 'errorDeletingPhotoStorage',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting photo from database: `
  String get errorDeletingPhotoDatabase {
    return Intl.message(
      'Error deleting photo from database: ',
      name: 'errorDeletingPhotoDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Error: Missing key or image URL for this photo entry.`
  String get errorMissingKey {
    return Intl.message(
      'Error: Missing key or image URL for this photo entry.',
      name: 'errorMissingKey',
      desc: '',
      args: [],
    );
  }

  /// `Photo Journal`
  String get photoJournal {
    return Intl.message(
      'Photo Journal',
      name: 'photoJournal',
      desc: '',
      args: [],
    );
  }

  /// `No photos yet. \nAdd some photos to document \nyour plant\'s progress.`
  String get noPhotos {
    return Intl.message(
      'No photos yet. \nAdd some photos to document \nyour plant\\\'s progress.',
      name: 'noPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Photo taken on `
  String get photoTaken {
    return Intl.message(
      'Photo taken on ',
      name: 'photoTaken',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to delete this photo entry?'`
  String get reallyDeleting {
    return Intl.message(
      'Do you really want to delete this photo entry?\'',
      name: 'reallyDeleting',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `Month`
  String get month {
    return Intl.message('Month', name: 'month', desc: '', args: []);
  }

  /// `Please select a date to see the events.`
  String get selectDateForEvents {
    return Intl.message(
      'Please select a date to see the events.',
      name: 'selectDateForEvents',
      desc: '',
      args: [],
    );
  }

  /// `All your plants are happy. \nThere is nothing for you to do on this day.`
  String get allPlantsHappy {
    return Intl.message(
      'All your plants are happy. \nThere is nothing for you to do on this day.',
      name: 'allPlantsHappy',
      desc: '',
      args: [],
    );
  }

  /// `All Plants`
  String get allPlants {
    return Intl.message('All Plants', name: 'allPlants', desc: '', args: []);
  }

  /// `By Type`
  String get byType {
    return Intl.message('By Type', name: 'byType', desc: '', args: []);
  }

  /// `By Water Needs`
  String get byWaterNeeds {
    return Intl.message(
      'By Water Needs',
      name: 'byWaterNeeds',
      desc: '',
      args: [],
    );
  }

  /// `By Light Needs`
  String get byLightNeeds {
    return Intl.message(
      'By Light Needs',
      name: 'byLightNeeds',
      desc: '',
      args: [],
    );
  }

  /// `By Difficulty`
  String get byDifficulty {
    return Intl.message(
      'By Difficulty',
      name: 'byDifficulty',
      desc: '',
      args: [],
    );
  }

  /// `Add plant to \n`
  String get addPlantTo {
    return Intl.message(
      'Add plant to \n',
      name: 'addPlantTo',
      desc: '',
      args: [],
    );
  }

  /// `"My Plants"`
  String get myPlantsWiki {
    return Intl.message(
      '"My Plants"',
      name: 'myPlantsWiki',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty`
  String get difficulty {
    return Intl.message('Difficulty', name: 'difficulty', desc: '', args: []);
  }

  /// `Image URL`
  String get imageUrl {
    return Intl.message('Image URL', name: 'imageUrl', desc: '', args: []);
  }

  /// `View URL`
  String get viewUrl {
    return Intl.message('View URL', name: 'viewUrl', desc: '', args: []);
  }

  /// `Email and Plant name are required`
  String get emailAndPlantRequired {
    return Intl.message(
      'Email and Plant name are required',
      name: 'emailAndPlantRequired',
      desc: '',
      args: [],
    );
  }

  /// `Request submitted successfully`
  String get requestSuccessfully {
    return Intl.message(
      'Request submitted successfully',
      name: 'requestSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to submit request`
  String get failedToSubmitRequest {
    return Intl.message(
      'Failed to submit request',
      name: 'failedToSubmitRequest',
      desc: '',
      args: [],
    );
  }

  /// `Request Plant Addition`
  String get requestPlant {
    return Intl.message(
      'Request Plant Addition',
      name: 'requestPlant',
      desc: '',
      args: [],
    );
  }

  /// `Help us grow our plant database!`
  String get growPlantDatabase {
    return Intl.message(
      'Help us grow our plant database!',
      name: 'growPlantDatabase',
      desc: '',
      args: [],
    );
  }

  /// `If a plant you know is missing, please submit the form below and we will consider adding it.`
  String get ifPlantMissing {
    return Intl.message(
      'If a plant you know is missing, please submit the form below and we will consider adding it.',
      name: 'ifPlantMissing',
      desc: '',
      args: [],
    );
  }

  /// `Your Email`
  String get yourEmail {
    return Intl.message('Your Email', name: 'yourEmail', desc: '', args: []);
  }

  /// `Additional Notes (Optional)`
  String get additionalNotes {
    return Intl.message(
      'Additional Notes (Optional)',
      name: 'additionalNotes',
      desc: '',
      args: [],
    );
  }

  /// `Submit Request`
  String get submitRequest {
    return Intl.message(
      'Submit Request',
      name: 'submitRequest',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch wishlist`
  String get failedToFetchWishlist {
    return Intl.message(
      'Failed to fetch wishlist',
      name: 'failedToFetchWishlist',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get undo {
    return Intl.message('Undo', name: 'undo', desc: '', args: []);
  }

  /// ` added to wishlist `
  String get addedToWishlist {
    return Intl.message(
      ' added to wishlist ',
      name: 'addedToWishlist',
      desc: '',
      args: [],
    );
  }

  /// ` removed from wishlist :(`
  String get removedFromWishlist {
    return Intl.message(
      ' removed from wishlist :(',
      name: 'removedFromWishlist',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update wishlist: `
  String get failedToUpdateWishlist {
    return Intl.message(
      'Failed to update wishlist: ',
      name: 'failedToUpdateWishlist',
      desc: '',
      args: [],
    );
  }

  /// `Wishlist`
  String get wishlistTitle {
    return Intl.message('Wishlist', name: 'wishlistTitle', desc: '', args: []);
  }

  /// `My Wishlist`
  String get myWishlist {
    return Intl.message('My Wishlist', name: 'myWishlist', desc: '', args: []);
  }

  /// `Your wishlist is empty. \n '\n'Go to Wiki and tap the heart \n '\n'button to add plants.`
  String get wishlistEmpty {
    return Intl.message(
      'Your wishlist is empty. \n \'\n\'Go to Wiki and tap the heart \n \'\n\'button to add plants.',
      name: 'wishlistEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Plants by Difficulty`
  String get plantsByDifficulty {
    return Intl.message(
      'Plants by Difficulty',
      name: 'plantsByDifficulty',
      desc: '',
      args: [],
    );
  }

  /// `Difficult`
  String get difficult {
    return Intl.message('Difficult', name: 'difficult', desc: '', args: []);
  }

  /// `Plants by Light Needs`
  String get plantsByLightNeeds {
    return Intl.message(
      'Plants by Light Needs',
      name: 'plantsByLightNeeds',
      desc: '',
      args: [],
    );
  }

  /// `Plants by Type`
  String get plantsByType {
    return Intl.message(
      'Plants by Type',
      name: 'plantsByType',
      desc: '',
      args: [],
    );
  }

  /// `Plants by Water Needs`
  String get plantsByWaterNeeds {
    return Intl.message(
      'Plants by Water Needs',
      name: 'plantsByWaterNeeds',
      desc: '',
      args: [],
    );
  }

  /// `Anonymous`
  String get anonymous {
    return Intl.message('Anonymous', name: 'anonymous', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `User Information`
  String get userInformation {
    return Intl.message(
      'User Information',
      name: 'userInformation',
      desc: '',
      args: [],
    );
  }

  /// `Plant Quiz`
  String get plantQuiz {
    return Intl.message('Plant Quiz', name: 'plantQuiz', desc: '', args: []);
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Not Available`
  String get notAvailable {
    return Intl.message(
      'Not Available',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Change Your `
  String get changeYour {
    return Intl.message('Change Your ', name: 'changeYour', desc: '', args: []);
  }

  /// `New Full Name`
  String get newFullName {
    return Intl.message(
      'New Full Name',
      name: 'newFullName',
      desc: '',
      args: [],
    );
  }

  /// `New Email Address`
  String get newEmail {
    return Intl.message(
      'New Email Address',
      name: 'newEmail',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `SAVE`
  String get saveBig {
    return Intl.message('SAVE', name: 'saveBig', desc: '', args: []);
  }

  /// `Joined: `
  String get joined {
    return Intl.message('Joined: ', name: 'joined', desc: '', args: []);
  }

  /// `Your full name was changed successfully.`
  String get fullNameChanged {
    return Intl.message(
      'Your full name was changed successfully.',
      name: 'fullNameChanged',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password to change your email.`
  String get enterPassword {
    return Intl.message(
      'Please enter your password to change your email.',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `A verification email has been sent to `
  String get messageProfile1 {
    return Intl.message(
      'A verification email has been sent to ',
      name: 'messageProfile1',
      desc: '',
      args: [],
    );
  }

  /// `Please verify the email to complete the update.`
  String get messageProfile2 {
    return Intl.message(
      'Please verify the email to complete the update.',
      name: 'messageProfile2',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a new password to change your current password.`
  String get enterNewPassword {
    return Intl.message(
      'Please enter a new password to change your current password.',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `You entered the same password!? The new password must be different from the current password.`
  String get samePassword {
    return Intl.message(
      'You entered the same password!? The new password must be different from the current password.',
      name: 'samePassword',
      desc: '',
      args: [],
    );
  }

  /// `Your password was changed successfully.`
  String get passwordChanged {
    return Intl.message(
      'Your password was changed successfully.',
      name: 'passwordChanged',
      desc: '',
      args: [],
    );
  }

  /// `No changes made...`
  String get noChanges {
    return Intl.message(
      'No changes made...',
      name: 'noChanges',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred!`
  String get errorOccurred {
    return Intl.message(
      'An error occurred!',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while updating profile! Please contact the support for help.`
  String get contactSupport {
    return Intl.message(
      'An error occurred while updating profile! Please contact the support for help.',
      name: 'contactSupport',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message('About Us', name: 'aboutUs', desc: '', args: []);
  }

  /// `We (Laura Voß, Lisa Kütemeier, \nAylin Oymak, Gero Stöwe) are \nstudying computer science in the \n4 semester. We developed this \nplant app as part of the “Software \nEngineering 2” course. Our vision is to \nsupport plant lovers in the planning, \nselection and care of houseplants.`
  String get aboutUsDescription {
    return Intl.message(
      'We (Laura Voß, Lisa Kütemeier, \nAylin Oymak, Gero Stöwe) are \nstudying computer science in the \n4 semester. We developed this \nplant app as part of the “Software \nEngineering 2” course. Our vision is to \nsupport plant lovers in the planning, \nselection and care of houseplants.',
      name: 'aboutUsDescription',
      desc: '',
      args: [],
    );
  }

  /// `App Version`
  String get appVersion {
    return Intl.message('App Version', name: 'appVersion', desc: '', args: []);
  }

  /// `E-Mail`
  String get emailProfile {
    return Intl.message('E-Mail', name: 'emailProfile', desc: '', args: []);
  }

  /// `User ID`
  String get userId {
    return Intl.message('User ID', name: 'userId', desc: '', args: []);
  }

  /// `Joined At`
  String get joinedAt {
    return Intl.message('Joined At', name: 'joinedAt', desc: '', args: []);
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
